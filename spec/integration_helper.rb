require_relative 'spec_helper'
require 'capybara'
require 'capybara/dsl'

RSpec.configure do |config|
  config.include Capybara::DSL

  config.before(:suite) do
    get_new_access_token
    require_relative 'config/monkeypatch_auth'
  end
end

Capybara.app = Caldo::App

def test_account
  YAML.load_file(test_config_file("api_access.yaml"))["test_account"]
end

def test_password
  YAML.load_file(test_config_file("api_access.yaml"))["test_password"]
end
