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

      redirect to(client.path_before_signing_in)
    end

    get '/sign_out' do
      session[:token_pair_id] = nil
      redirect to('/')
    end

    private
    attr_accessor :client, :calendar

    def initialize_api_client
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

    alias_method :require_authentication, :initialize_api_client

    def session_token_pair
      TokenPair.get(session[:token_pair_id]) unless session[:token_pair_id].nil?
    end

    def authorization_in_progress?
      request.path_info =~ /^\/oauth2/
    end
  end
end
