CALDO_ENV = 'test'

require 'rack/test'
require 'rspec'
require 'sinatra/base'
require_relative '../config/data_mapper'


module TimeSpecHelpers
  def current_time_is(time)
    Time.stubs(:now).returns(Time.parse(time))
  end

  # Requires a client method to be set in current context
  # eg: let(:client) { Client.new }
  def token_expiration_is(time)
    client.stub(:token_expiration).and_returns(Time.parse(time))
  end
end

RSpec.configure do |config|
  config.before(:each) { DataMapper.auto_migrate! }
  config.mock_with :mocha
  config.include TimeSpecHelpers
end
