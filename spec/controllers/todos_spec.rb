require_relative '../../app/controllers/todos'

describe 'Todos' do
  include Rack::Test::Methods

  def app
    Caldo::App
  end

  let(:birthday) { event("attend marta's birthday") }
  let(:exercise) { event("do rmu edu exercise") }
  let(:fake_calendar) { FakeCalendar.new([birthday, exercise]) }

  before do
    Caldo::App.any_instance.stub(:calendar).and_return(fake_calendar)
  end

  it 'prints the date' do
    get '/2012-01-14'
    last_response.body.should include("Saturday, January 14")
  end

  it 'prints the summary for both events' do
    get '/2012-01-14'
    last_response.body.should include("attend marta's birthday")
    last_response.body.should include("do rmu edu exercise")
  end
end
