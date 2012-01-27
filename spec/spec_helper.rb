require_relative '../app/bootstrap'
require 'rack/test'
require 'rspec'
require 'timecop'
require 'sinatra/base'
require 'capybara'
require 'capybara/dsl'

Capybara.app = Caldo::App

RSpec.configure do |config|
  config.mock_with :rspec
  # config.include Capybara::DSL

  # config.before(:suite) do
  #   get_new_access_token
  #   require_relative 'config/monkeypatch_auth'
  #   Timecop.travel(Time.new(2012,1,15,15,25,0, "-08:00"))
  # end
end

def get_new_access_token
  auth = load_auth_config
  old_token = Caldo::TokenPair.create(auth["token"])

  client = Caldo::GoogleCalendar::Client.new(:client_id => auth["api_client_id"],
  :client_secret => auth["api_client_secret"], :token_pair => old_token, :state => '/',
  :redirect_uri  => 'http://localhost/oauth2callback', :code => nil)

  client.fetch_access_token

  new_token = Caldo::TokenPair.create(client.token_pair)

  auth["token"]["refresh_token"] = new_token.refresh_token
  auth["token"]["access_token"]  = new_token.access_token
  auth["token"]["expires_in"]    = new_token.expires_in
  auth["token"]["issued_at"]     = new_token.issued_at

  save_auth_config(auth)
  $auth = auth
end

def save_auth_config(auth)
  File.open(test_config_file("api_access.yaml"), 'w') do |out|
   YAML.dump(auth, out)
  end
end

def load_auth_config
  YAML.load_file(test_config_file("api_access.yaml"))
end

def test_config_file(file)
  File.expand_path(File.join(File.dirname(__FILE__), "config", file))
end

# require 'vcr'
# require 'fakeweb'
# VCR.config do |c|
#   c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
#   c.stub_with :fakeweb
# end
