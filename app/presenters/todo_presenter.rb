require 'date'

module Caldo
  class TodoPresenter
    attr_accessor :todo

    def initialize(todo)
      self.todo = todo
    end

    def summary
      todo.summary.gsub('*important*','').gsub(Caldo::VARIABLE_TAG, '').strip
    end

    def date
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
      { :event_id   => todo.event_id,   :summary   => summary,
        :complete   => todo.complete,   :important => todo.important,
        :date       => date }.to_json
    end
  end
end
