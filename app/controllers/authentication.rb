require_relative '../app'
require_relative '../models/google_calendar/client'
require_relative '../models/google_calendar/calendar'
require_relative '../models/token_pair'

module Caldo
  class App < Sinatra::Application
    get '/oauth2callback' do
      initialize_api_client
      client.fetch_access_token

      token_pair = TokenPair.create(client.authorization_details)
      session[:token_pair_id] = token_pair.id

      flash[:success] = "Sign in was successful, well done!"
      redirect to(client.path_before_signing_in)
    end

    get '/sign_out' do
      session[:token_pair_id] = nil
      flash[:notice] = "You have been signed out! See you again soon."
      redirect to('/')
    end

    private
    attr_accessor :client, :calendar

    def initialize_api_client
      # this is a good opportunity to use a DSL to create it
      self.client = GoogleCalendar::Client.new(
                      :client_id     => settings.client_id,
                      :client_secret => settings.client_secret,
                      :token_pair    => session_token_pair,
                      :state         => params[:state] || request.path_info,
                      :redirect_uri  => to('/oauth2callback'),
                      :code          => params[:code])

      if client.has_valid_access_token?
        self.calendar = GoogleCalendar::Calendar.new(client)
      else
        redirect client.authorization_uri, 303 unless authorization_in_progress?
      end
    end

    set(:authenticates) do |required|
      condition { initialize_api_client if required }
    end

    def session_token_pair
      TokenPair.get(session[:token_pair_id]) unless session[:token_pair_id].nil?
    end

    def authorization_in_progress?
      request.path_info =~ /^\/oauth2/
    end
  end
end
