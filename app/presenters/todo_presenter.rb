module Caldo
  class TodoPresenter
    attr_accessor :todo

    def initialize(todo)
      self.todo = todo
    end

    def summary
      todo.summary
    end

    def date
      todo.date
    end

    def time
      todo.time
    end
  end
end
