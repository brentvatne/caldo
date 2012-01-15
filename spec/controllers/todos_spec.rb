require_relative '../../app/controllers/todos'

describe 'todo actions' do
  include Rack::Test::Methods

  def app
    Caldo::App
  end

  before do
    Caldo::App.any_instance.stub(:calendar).and_return(fake_calendar)
  end

  describe "calendar has events for the day" do
    let(:birthday) { event("attend marta's birthday") }
    let(:exercise) { event("do rmu edu exercise") }
    let(:fake_calendar) { FakeCalendar.new([birthday, exercise]) }

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

  describe "calendar does not have events for the day" do
    let(:fake_calendar) { FakeCalendar.new([]) }
    it "informs the user that there are no events scheduled" do
      get '/2012-01-01'
      last_response.body.should =~ /nothing to do today/i
    end
  end
end
