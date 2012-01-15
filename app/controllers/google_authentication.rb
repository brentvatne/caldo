require 'yaml'
require 'google/api_client'
require_relative '../models/google_calendar/google_calendar'
require_relative '../models/token_pair'

module Caldo
  class App < Sinatra::Application
    attr_reader :calendar

    before do
      @client = Google::APIClient.new
      # The client_id and client_secret are application specific codes that any user
      # of this application will need to generate using the google api console
      @client.authorization.client_id     = settings.client_id
      @client.authorization.client_secret = settings.client_secret
      @client.authorization.scope         = 'https://www.googleapis.com/auth/calendar https://www.googleapis.com/auth/userinfo.email'
      @client.authorization.redirect_uri  = to('/oauth2callback')
      @client.authorization.code          = params[:code] if params[:code]

      # Use the existing access token in the session if it's available
      if session[:token_id]
        token_pair = TokenPair.get(session[:token_id])
        # If the session could not be found, don't update the auth token - to_hash
        # will return an error because it cannot be called on nil
        unless token_pair.nil?
          @client.authorization.update_token!(token_pair.to_hash)
        end
      end

      # If the authorization is expired, we need to get it again
      if @client.authorization.refresh_token && @client.authorization.expired?
        @client.authorization.fetch_access_token!
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

    get '/oauth2callback' do
      @client.authorization.fetch_access_token!

      # Persist the token; update to newer token data if already exists
      token_pair = TokenPair.get(session[:token_id]) || TokenPair.new
      token_pair.update_token!(@client.authorization)
      token_pair.save

      # Set the session data
      session[:token_id] = token_pair.id

      redirect to('/')
    end
  end
end
