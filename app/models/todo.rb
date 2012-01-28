require 'date'

module Caldo
  # A variable can appear in the summary of a Todo, for example "Run {minutes}"
  VARIABLE_TAG        = /(\{)(?<variable>[\w\s]+)(\})/
  VARIABLE_EXPRESSION = /(?<task>.*?)#{VARIABLE_TAG}/

  IMPORTANT_TAG = /\*important\*/

  class Todo
    attr_accessor :event_id, :event_color_id, :summary, :start_date, :end_date

    # Fetches events within a 5 days ahead and only returns those that are
    # marked as important or occur on the specified date.
    #
    # date - A string date in the format "YYYY-MM-DD"
    #        Example: Todo.all_on_date("2012-01-31")
    #
    # Returns an array of Event instances
    def self.all_on_date(date)
      events = service.find_events_by_date(:min => DateTime.parse(date),
                                           :max => DateTime.parse(date) + 5)

      events.inject([]) { |todos, event|
        todo = new(event)
        todos.tap { |list| list << todo if todo.occurs_on?(date) || todo.important? }
      }.sort
    end

    # Todos are sorted by start date
    def <=>(other)
      self.start_date <=> other.start_date
    end

    # Sends the service call to mark the corresponding event as complete on
    # Google Calendar
    #
    # params - The hash options containing information about the todo to update
    #          :id       - The unique id of the event according to Google Calendar
    #          :date     - A string date of the form "2012-01-02" which represents
    #                      the start date of the todo.
    #          :summary  - The string summary of the todo, kind of the 'title'
    #          :variable - A string that will be used to a replace a variable
    #                      portion of the summary, if it has one.
    #
    # Returns a truthy value if it was a success, or a falsey if not
    def self.mark_complete(params)
      summary = substitute_variable(params[:summary], params[:variable])
      event = service.update_event(params.merge(:color => :green, :summary => summary))
      Todo.new(event)
    end

    # Sends the service call to mark the corresponding event as incomplete on
    # Google Calendar
    #
    # params - The hash options containing information about the todo to update
    #          :id       - The unique id of the event according to Google Calendar
    #
    # Returns a truthy value if it was a success, or a falsey if not
    def self.mark_incomplete(params)
      !!service.update_event(params.merge(:color => :grey))
    end

    # Replaces the variable portion of a summary with a given value
    #
    # summary        - A string summary of the Todo, eg: "Run {minutes}"
    # variable_value - A string variable value eg: "30"
    #
    # Example
    #
    #    Todo.substitute_variable("Run {minutes}", "30")
    #    # => 'Run - 30 minutes'
    def self.substitute_variable(summary, value)
      if matches = summary.match(VARIABLE_EXPRESSION)
        "#{matches[:task].strip} - #{value} #{matches[:variable]}"
      else
        summary
      end
    end

    def initialize(event)
      self.event_id       = event[:id]
      self.summary        = event[:summary]
      self.start_date     = event[:start_date]
      self.end_date       = event[:end_date]
      self.event_color_id = event[:color_id]
    end

    def complete?
      event_color_id == GoogleCalendar::COLORS[:green]
    end

    def occurs_on?(other_date)
      DateTime.parse(self.start_date).to_date.to_s == other_date
    end

    def important?
      !!self.summary.match(IMPORTANT_TAG)
    end

    def summary_variable
      matches = summary.match(VARIABLE_EXPRESSION)
      matches ? matches[:variable] : ""
    end

    private
    # Returns the thread local Google Calendar API Client wrapper instance
    def self.service
      Thread.current['GoogleCalendar']
    end
  end
end
