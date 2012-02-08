require 'rack/test'
require 'rspec'
require 'sinatra/base'

RSpec.configure do |config|
  config.mock_with :mocha
end
