require_relative '../app'
require_relative '../models/google_calendar/client'
require_relative '../models/google_calendar/calendar'
require_relative '../models/google_calendar/throttler'

module Caldo
  GoogleAPIGateway = Object.new

  class << GoogleAPIGateway
    def clients
      @clients ||= {}
    end

    def [](uid)
      clients[uid]
    end

    def []=(uid, client)
      clients[uid] = GoogleCalendar::Throttler.new(client, 3)
    end
  end

  class App < Sinatra::Application
    attr_accessor :client, :calendar

    # Should deal with an edge case:
    # if the user does not have a refresh token, and no refresh
    # token was given, should redirect to auth with force
    get '/auth/:provider/callback' do
      user          = User.find_or_create_from_omniauth(omniauth_params)
      session[:uid] = user.email

      redirect to('/today')
    end

    get '/auth/failure' do
      content_type 'text/plain'
      "Sorry, something has gone wrong with the authentication process!"
    end

    # Logs the user out by reseting the session token information. Does not
    # delete their token key from the database.
    get '/sign_out' do
      GoogleAPIGateway[session[:uid]] = nil
      session[:uid]                   = nil
      flash[:notice] = "You have been signed out! See you again soon."
      redirect to('/')
    end

    # A condition that can be added to Sinatra app class methods, as follows:
    # get '/', :authenticates => true { .. }
    set(:authenticates) do |required|
      condition { authenticate if required }
    end

    private

    # Instantiates the API client and makes it available to the local thread,
    # or initiates the authroization process if the user is not already
    # authorized
    def authenticate
      if user_logged_in?
        client = find_or_create_client_for_session
        puts client.inspect
      else
        unless authentication_in_progress?
          redirect '/auth/google_oauth2', 303
        end
      end
    end

    def find_or_create_client_for_session
      Thread.current['uid'] = session[:uid]
      GoogleAPIGateway[session[:uid]] = new_client
    end

    def user_logged_in?
      !!session[:uid]
    end

    def new_client
      GoogleCalendar::Client.new do |c|
        c.client_id     = settings.client_id
        c.client_secret = settings.client_secret
        c.token_pair    = session_token_pair
      end
    end

    # Returns TokenPair instance from the session or returns nil
    def session_token_pair
      if user = User.first(:email => session[:uid])
        user.token_pair
      end
    end

    # Private: Examines the path to determine if authorization is taking place
    #
    # Returns true if authorization is in progress, or false otherwise
    def authentication_in_progress?
      request.path_info =~ /^\/oauth/
    end

    # Private: Returns the Omniauth parameters hash
    def omniauth_params
     request.env['omniauth.auth'].to_hash
    end
  end
end
