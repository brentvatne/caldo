require_relative 'config/monkeypatch_auth'
require 'rack/test'
require 'rspec'
require 'timecop'

require 'vcr'
require 'fakeweb'

Timecop.travel(Time.new(2012,1,15,15,25,0, "-08:00"))

RSpec.configure do |config|
  config.mock_with :rspec
  config.before(:each) do
  end
end

VCR.config do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.stub_with :fakeweb
end

def test_account
  CaldoSpecs::TEST_ACCOUNT
end

def test_password
  CaldoSpecs::TEST_PASSWORD
end
