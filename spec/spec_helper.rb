CALDO_TESTING = true

require 'rack/test'
require 'rspec'
require 'sinatra/base'
require_relative '../config/data_mapper'

module TimeSpecHelpers
  def current_time_is(time)
    Time.stubs(:now).returns(Time.parse(time))
  end
end

RSpec.configure do |config|
  config.before(:each) { DataMapper.auto_migrate! }
  config.mock_with :mocha
  config.include TimeSpecHelpers
end
