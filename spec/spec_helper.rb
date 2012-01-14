require 'sinatra'
require 'rack/test'
require 'rspec'

set :environment, :test

RSpec.configure do |config|
  config.mock_with :rspec
end
