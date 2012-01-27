require 'date'

module Caldo
  class Todo
    attr_accessor :event_id, :summary, :start_date, :end_date, :complete

    # Fetches events within a 5 days ahead and only returns those that are
    # marked as important or occur on the specified date.
    #
    # date - A string date in the format "YYYY-MM-DD"
    #        Example: Todo.all_on_date("2012-01-31")
    #
    # Returns an array of Event instances
    def self.all_on_date(date)
      five_days_before = DateTime.parse(date) - 1
      five_days_after  = DateTime.parse(date) + 5

      events = service.find_events_by_date(:min => five_days_before,
                                           :max => five_days_after)

      events.inject([]) do |filtered_todos, event|
        if event.occurs_on?(date) || event.summary.match(/\*important\*/)
          filtered_todos << new(event)
        end
        filtered_todos
      end
    end

    def self.mark_complete(params)
      service.update_event(params.merge(:color => "2"))
    end

    def self.mark_incomplete(params)
      service.update_event(params.merge(:color => "8"))
    end

    def self.service
      Thread.current['GoogleCalendar']
    end

    def initialize(event)
      self.event_id   = event.id
      self.summary    = event.summary
      self.complete   = event.complete?
      self.start_date = event.start_date
      self.end_date   = event.end_date
    end

    def complete?
      self.complete
    end

    def important?
      self.summary.match(/\*important\*/)
    end

    def date
      DateTime.parse(start_date).strftime("%A")
    end

    def time
      date_time = DateTime.parse(start_date)
      if date_time.hour == 0 && date_time.minute == 0 && date_time.second == 0
        "All day"
      else
        date_time.strftime("%l:%M %p")
      end
    end
  end
end
