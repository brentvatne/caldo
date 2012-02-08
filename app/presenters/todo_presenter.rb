require 'date'
require_relative '../models/todo'

module Caldo
  # This class is responsible for any todo presentation logic used within views.
  class TodoPresenter
    attr_accessor :todo

    # Instantiates the presenter from a todo instance
    #
    # todo - An instance of Caldo::Todo
    def initialize(todo)
      self.todo = todo
    end

    # Removes any tags from the Todo name
    def summary
      todo.summary.gsub(Caldo::IMPORTANT_TAG,'').gsub(Caldo::VARIABLE_TAG, '').strip
    end

    # Only returns the day, exaple: "Monday"
    def date
      DateTime.parse(todo.start_date).strftime("%A")
    end

    # Returns an empty string if a time is not given, or the time formatted
    # as "5:00 PM" if it is.
    def time
      date_time = DateTime.parse(todo.start_date)
      if date_time.hour == 0 && date_time.minute == 0 && date_time.second == 0
        ""
      else
        date_time.strftime("%l:%M %p").strip
      end
    end

    # Serializes the Todo instance to a JSON string
    def to_json
      return false.to_json if todo.nil?

      { :event_id   => todo.event_id,   :summary   => summary,
        :complete   => todo.complete?,  :important => todo.important?,
        :date       => date }.to_json
    end
  end
end
