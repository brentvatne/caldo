require_relative '../app/caldo'

describe 'Caldo' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it 'no tests.. yet' do
    # get '/'
    # last_response.body.should   == "some text"
    # last_response.status.should == 200
  end
end
