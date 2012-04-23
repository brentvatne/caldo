require 'rack/test'
require 'rspec'
require 'sinatra/base'

CALDO_ENV = 'test'

RSpec.configure do |config|
  config.before(:each) { DataMapper.auto_migrate! }
  config.mock_with :mocha
end
