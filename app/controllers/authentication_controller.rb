require_relative '../app'
require_relative '../models/google_calendar/client'
require_relative '../models/google_calendar/calendar'
require_relative '../models/token_pair'

module Caldo
  class App < Sinatra::Application
    attr_accessor :client, :calendar

    # When Google authentication is confirmed, it is re-directed back to this path.
    # After confirmation, we need to fetch the access token based on a provided code
    # and initialize the session token information, then redirect to the path they
    # wanted to visit previously.
    get '/oauth2callback' do
      initialize_api_client
      client.fetch_access_token

      token_pair = TokenPair.create(client.authorization_details)
      session[:token_pair_id] = token_pair.id

      flash[:success] = "Sign in was successful, well done!"
      redirect to(client.path_before_signing_in)
    end

    # Logs the user out by reseting the session token information. Does not
    # delete their token key from the database.
    get '/sign_out' do
      session[:token_pair_id] = nil
      flash[:notice] = "You have been signed out! See you again soon."
      redirect to('/')
    end

    private

    # Instantiates the API client and makes it available to the local thread,
    # or initiates the authroization process if the user is not already
    # authorized
    def initialize_api_client
      self.client = GoogleCalendar::Client.new do |c|
        c.client_id     = settings.client_id
        c.client_secret = settings.client_secret
        c.token_pair    = session_token_pair
        c.state         = params[:state] || request.path_info
        c.redirect_uri  = to('/oauth2callback')
        c.code          = params[:code]
      end

      if client.has_valid_access_token?
        Thread.current['GoogleCalendar'] = self.client.calendar
      else
        redirect client.authorization_uri, 303 unless authorization_in_progress?
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
      request.path_info =~ /^\/oauth2/
    end
  end
end
