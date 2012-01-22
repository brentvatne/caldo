require_relative 'api_access'
require_relative '../../app/bootstrap'
require 'sinatra/base'

module Caldo
  class App < Sinatra::Application
    private
    def initialize_api_client
      token = TokenPair.create(:refesh_token => CaldoSpecs::REFRESH_TOKEN,
                               :access_token => CaldoSpecs::ACCESS_TOKEN,
                               :expires_in   => CaldoSpecs::EXPIRES_IN,
                               :issued_at    => CaldoSpecs::ISSUED_AT)

      self.client = GoogleCalendar::Client.new(
        :client_id     => ::CaldoSpecs::API_CLIENT_ID,
        :client_secret => ::CaldoSpecs::API_CLIENT_SECRET,
        :token_pair    => token,
        :state         => params[:state] || request.path_info,
        :redirect_uri  => to('/oauth2callback'),
        :code          => params[:code])

      if client.has_valid_access_token?
        self.calendar = GoogleCalendar::Calendar.new(client)
      else
        raise "CRASHED BECAUSE TOKEN IS NOT VALID"
      end
    end
  end
end
