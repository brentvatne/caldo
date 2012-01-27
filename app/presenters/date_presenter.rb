require 'date'

module Caldo
  class DatePresenter
    def initialize(date)
      @date = DateTime.parse(date.to_s)
    end

    def humanize
      @date.strftime("%A, %B %d")
    end

    def portable
      @date.to_date.xmlschema
    end

    def path
      date_path(@date)
    end

    def next_date_path
      date_path(@date + 1)
    end

    def prev_date_path
      date_path(@date - 1)
    end

    private
    def date_path(date)
      "/" + date.to_date.to_s
    end
  end
end