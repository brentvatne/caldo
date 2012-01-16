require 'google/api_client'
require_relative '../models/google_calendar/google_calendar'
require_relative '../models/token_pair'

module Caldo
  class App < Sinatra::Application
    attr_reader :calendar

    before %r{/(\d{4}-\d{2}-\d{2})?} do
      @client = initialize_api_client

      # Need some other way to remember the user, by a username I create for example
      if token = find_saved_token_by_session
        @client.authorization.update_token!(token.to_hash)

        # It is considered a "TokenPair" because there are two tokens: the access token
        # and the refresh token. The access token has a relatively short life to protect
        # against it getting stolen, and the refresh token allows us to grab
        # another access token if the authorization has expired.
        #
        # The question now is if there is some way to identify the user before I redirect
        # them to the authorization url, so I can just get the access token?
        if @client.authorization.refresh_token && @client.authorization.expired?
          @client.authorization.fetch_access_token!
        end
      end

      @calendar_api = @client.discovered_api('calendar', 'v3')
      @oauth_api    = @client.discovered_api('oauth2', 'v2')

      @calendar = GoogleCalendar::Calendar.new(@client, @calendar_api)

      unless @client.authorization.access_token || request.path_info =~ /^\/oauth2/
        redirect to('/oauth2authorize')
      end
    end

    get '/oauth2authorize' do
      redirect @client.authorization.authorization_uri.to_s, 303
    end

    # This should only be reached after the client gives permissions
    get '/oauth2callback' do
      @client.authorization.fetch_access_token!
      token_pair = TokenPair.new(@client.authorization)

      token_pair.save
      session[:token_id] = token_pair.id

      redirect to('/')
    end

    get '/sign_out' do
      session[:token_id] = nil
    end

    private
    def initialize_api_client
      client = Google::APIClient.new
      client.authorization.client_id     = settings.client_id
      client.authorization.client_secret = settings.client_secret
      client.authorization.scope         = 'https://www.googleapis.com/auth/calendar https://www.googleapis.com/auth/userinfo.email'
      client.authorization.redirect_uri  = to('/oauth2callback')
      client.authorization.code          = params[:code] if params[:code]
      client
    end

    def find_saved_token_by_session
      TokenPair.get(session[:token_id]) unless session[:token_id].nil?
    end
  end
end
