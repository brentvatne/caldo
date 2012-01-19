require_relative '../models/google_calendar/google_calendar'
require_relative '../models/google_calendar/client'
require_relative '../models/token_pair'

module Caldo
  class App < Sinatra::Application

    before do
      self.client = GoogleCalendar::Client.new(
                      :client_id     => settings.client_id,
                      :client_secret => settings.client_secret,
                      :token_pair    => session_token_pair,
                      :redirect_uri  => to('/oauth2callback'),
                      :code          => params[:code])

      if client.has_access_token?
        self.calendar = GoogleCalendar::Calendar.new(client)
      else
        redirect client.authorization_uri, 303 unless authorization_in_progress?
      end
    end

    # This should only be reached after the client gives permissions
    get '/oauth2callback' do
      client.fetch_access_token!
      token_pair = TokenPair.new(client.authorization_details)
      token_pair.save
      session[:token_pair_id] = token_pair.id

      redirect to('/')
    end

    get '/sign_out' do
      session[:token_pair_id] = nil
      "Signed out!"
    end

    private
    attr_accessor :client, :calendar

    def authorization_in_progress?
      request.path_info =~ /^\/oauth2/
    end

    def session_token_pair
      TokenPair.get(session[:token_pair_id]) unless session[:token_pair_id].nil?
    end
  end
end
