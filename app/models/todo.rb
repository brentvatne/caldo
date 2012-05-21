require 'date'

module Caldo
  # A variable can appear in the summary of a Todo, for example "Run {minutes}"
  VARIABLE_TAG        = /(\{)(?<variable>[\w\s]+)(\})/
  VARIABLE_EXPRESSION = /(?<task>.*?)#{VARIABLE_TAG}\s*$/

  # The important tag *important* causes an event to be displayed on several days
  # before when it actually occurs
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

    def self.all_within_range_of(date)
      events = service.find_events_by_date(:min => DateTime.parse(date) - 4,
                                           :max => DateTime.parse(date) + 7)

      events.inject([]) { |todos, event| todos << new(event) }.sort
    end

    def self.find(id)
      new(service.find_event(id))
    end

    def self.update(params)
      params[:color] = if params[:complete] == true then :green else :grey end
      params[:id]    = params[:event_id]
      params.delete(:event_id)
      params.delete(:complete)
      params.delete(:summary)
      event = service.update_event(params)
      Todo.new(event)
    end

    # Todos are sorted by start date
    def <=>(other)
      self.start_date <=> other.start_date
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

    # Gets a variable name from the summary, if one is given
    #
    # Returns the variable name string if there is one, or an empty string.
    def summary_variable
      matches = summary.match(VARIABLE_EXPRESSION)
      matches ? matches[:variable] : ""
    end

    private

    # Returns the thread local Google Calendar API Client wrapper instance
    def self.service
      @service ||= GoogleCalendar::Client.configure do |credentials|
        credentials.client_id     = GAPI_CLIENT_ID
        credentials.client_secret = GAPI_CLIENT_SECRET
        credentials.token_pair    = User.token_pair_for(Thread.current['uid'])
      end
    end
  end
end
