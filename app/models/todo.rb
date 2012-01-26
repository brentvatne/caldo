module Caldo
  class Todo
    # Fetches events within a 10 day range and only returns those that are
    # marked as important or occur on the specified date.
    #
    # date - A string date in the format "YYYY-MM-DD"
    #        Example: Todo.all_on_date("2012-01-31")
    #
    # Returns an array of Event instances
    def self.all_on_date(date)
      five_days_before = DateTime.parse(date) - 5
      five_days_after  = DateTime.parse(date) + 5

      events = service.find_events_by_date(:min => five_days_before,
                                           :max => five_days_after)

      events.inject([]) do |filtered_events, event|
        if event.occurs_on?(date) || event.summary.match(/\*important\*/)
          filtered_events << event
        end
        filtered_events
      end
    end

    def self.mark_complete(params)
      service.update_event(params.merge(:color => "2"))
    end

    def self.service
      Thread.current['GoogleCalendar']
    end
  end
end
