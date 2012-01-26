module Caldo
  class Todo
    def self.all_on_date(date)
      service.find_events_on_date(date)
    end

    def self.mark_complete(params)
      service.update_event(params.merge(:color => "2"))
    end

    def self.service
      Thread.current['GoogleCalendar']
    end
  end
end
