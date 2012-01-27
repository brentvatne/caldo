require 'date'

module Caldo
  class Todo
    attr_accessor :event_id, :summary, :start_date, :end_date, :complete, :important

    # Fetches events within a 5 days ahead and only returns those that are
    # marked as important or occur on the specified date.
    #
    # date - A string date in the format "YYYY-MM-DD"
    #        Example: Todo.all_on_date("2012-01-31")
    #
    # Returns an array of Event instances
    def self.all_on_date(date)
      given_date      = DateTime.parse(date)
      five_days_after = DateTime.parse(date) + 5

      events = service.find_events_by_date(:min => given_date,
                                           :max => five_days_after)

      todos = events.inject([]) do |filtered_todos, event|
        if event.occurs_on?(date) || event.important?
          filtered_todos << new(event)
        end
        filtered_todos
      end
      todos.sort
    end

    def <=>(other)
      self.start_date <=> other.start_date
    end

    def self.mark_complete(params)
      service.update_event(params.merge(:color => :green))
    end

    def self.mark_incomplete(params)
      service.update_event(params.merge(:color => :grey))
    end

    def initialize(event)
      self.event_id   = event.id
      self.summary    = event.summary
      self.complete   = event.complete?
      self.important  = event.important?
      self.start_date = event.start_date
      self.end_date   = event.end_date
    end

    def summary
      @summary.gsub('*important*','')
    end

    def complete?
      self.complete
    end

    def important?
      self.important
    end

    def date
      DateTime.parse(start_date).strftime("%A")
    end

    def time
      date_time = DateTime.parse(start_date)
      if date_time.hour == 0 && date_time.minute == 0 && date_time.second == 0
        ""
      else
        date_time.strftime("%l:%M %p")
      end
    end

    private
    def self.service
      Thread.current['GoogleCalendar']
    end
  end
end
