require 'date'

module Caldo
  # This class is responsible for any date presentation logic used within views.
  class DatePresenter

    # Accepts any Date object that responds to to_s with a parseable date string
    # (even a string like '2012-01-02' is acceptable)
    def initialize(date)
      @date = DateTime.parse(date.to_s)
    end

    # Returns the date as a string in the format 'Friday, January 27'
    def humanize
      @date.strftime("%A, %B %d")
    end

    # Returns the date (without time) in the RFC standard date format, to
    # be read by Google's Calendar API.
    def portable
      @date.to_date.xmlschema
    end

    # Returns the Caldo path to the date
    def path
      date_path(@date)
    end

    # Returns the Caldo path to the day after the date
    def next_date_path
      date_path(@date + 1)
    end

    # Returns the Caldo path to the day before the date
    def prev_date_path
      date_path(@date - 1)
    end

    private
    # Converts a given DateTime object to a Caldo path
    #
    # date - A DateTime instance
    #
    # Returns a string path, for example "/2012-01-28"
    def date_path(date)
      "/" + date.to_date.to_s
    end
  end
end
