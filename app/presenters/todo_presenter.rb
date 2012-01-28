require 'date'

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

    def summary
      todo.summary.gsub(Caldo::IMPORTANT_TAG,'').gsub(Caldo::VARIABLE_TAG, '').strip
    end

    def date
      p todo.start_date
      DateTime.parse(todo.start_date).strftime("%A")
    end

    def time
      date_time = DateTime.parse(todo.start_date)
      if date_time.hour == 0 && date_time.minute == 0 && date_time.second == 0
        ""
      else
        date_time.strftime("%l:%M %p").strip
      end
    end

    def to_json
      return false.to_json if todo.nil?

      { :event_id   => todo.event_id,   :summary   => summary,
        :complete   => todo.complete,   :important => todo.important,
        :date       => date }.to_json
    end
  end
end
