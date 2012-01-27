require 'date'

module Caldo
  class TodoPresenter
    attr_accessor :todo

    def initialize(todo)
      self.todo = todo
    end

    def summary
      todo.summary.gsub('*important*','')
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
  end
end
