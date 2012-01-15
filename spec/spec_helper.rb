require_relative '../app/app'
require_relative '../app/models/google_calendar/google_calendar'
require 'rack/test'
require 'rspec'

set :environment, :test

RSpec.configure do |config|
  config.mock_with :rspec
end

def event(summary, description="")
  Caldo::GoogleCalendar::Event.new("summary" => summary,
                                   "description" => description)
end

class FakeCalendar
  def initialize(events)
    @events = events
  end

  def find_events_on_date(date)
    @events
  end
end
