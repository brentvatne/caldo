require_relative '../app/caldo'

describe 'Caldo' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it 'should run a simple test' do
    get '/'
    last_response.body.should == "Hello world!"
    last_response.status.should == 200
  end
end
