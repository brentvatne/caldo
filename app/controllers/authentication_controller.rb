require_relative '../app'
require_relative '../models/google_calendar/client'
require_relative '../models/google_calendar/calendar'
require_relative '../models/google_calendar/throttler'
require_relative '../models/token_pair'

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

    get '/auth/:provider/callback' do
      content_type 'text/plain'
      request.env['omniauth.auth'].to_hash.inspect rescue "No data"

      # create user here
      # why is this create? how do we check if it already exists?
      token_pair = TokenPair.create(omniauth_params['credentials'])
      session[:token_pair_id] = token_pair.id

      redirect to('/today')
    end

    get '/auth/failure' do
      content_type 'text/plain'
      request.env['omniauth.auth'].to_hash.inspect rescue "No data"
    end

    # Logs the user out by reseting the session token information. Does not
    # delete their token key from the database.
    get '/sign_out' do
      session[:token_pair_id] = nil
      GoogleAPIGateway[session[:uid]] = nil
      session[:uid] = nil
      flash[:notice] = "You have been signed out! See you again soon."
      redirect to('/')
    end

    private
    # Instantiates the API client and makes it available to the local thread,
    # or initiates the authroization process if the user is not already
    # authorized
    def initialize_api_client
      client = GoogleAPIGateway[session[:uid]]

      # gateway client already created and has a valid access token
      if client && client.has_valid_access_token?
        Thread.current['uid'] = session[:uid]
      else
        session[:uid] = omniauth_params['info']['email'] unless session[:uid]
        client        = new_client_for_session
        redirect '/auth/google_oauth2', 303 unless authorization_in_progress?
      end
    end

    def new_client_for_session
      GoogleAPIGateway[session[:uid]] = new_client
    end

    def new_client
      GoogleCalendar::Client.new do |c|
        c.client_id     = settings.client_id
        c.client_secret = settings.client_secret
        c.token_pair    = session_token_pair
        #c.state         = params[:state] || request.path_info
        c.redirect_uri  = to('/auth/google_oauth2/callback')
      end
    end

    # A condition that can be added to Sinatra app class methods, as follows:
    # get '/', :authenticates => true { .. }
    set(:authenticates) do |required|
      condition { initialize_api_client if required }
    end

    # Creates a TokenPair instance from the session token pair id or returns nil
    def session_token_pair
      TokenPair.get(session[:token_pair_id]) unless session[:token_pair_id].nil?
    end

    # Examines the path to determine if authorization is taking place
    #
    # Returns true if authorization is in progress, or false otherwise
    def authorization_in_progress?
      request.path_info =~ /^\/oauth/
    end

    def omniauth_params
     request.env['omniauth.auth'].to_hash
    end
  end
end
