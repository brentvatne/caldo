require_relative '../../app/bootstrap'
require 'sinatra/base'

module Caldo
  class App < Sinatra::Application
    private
    def session_token_pair
      TokenPair.create(:refesh_token => $auth["token"]["refresh_token"],
                       :access_token => $auth["token"]["access_token"],
                       :expires_in   => $auth["token"]["expires_in"],
                       :issued_at    => $auth["token"]["issued_at"])
    end
  end
end

