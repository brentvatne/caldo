module GoogleCalendar
  class Event
    attr_accessor :id, :summary, :description, :location, :start_time, :end_time

    def initialize(attrs)
      @id          = attrs["id"]
      @summary     = attrs["summary"]
      @description = attrs["description"] || ""
      @location    = attrs["location"] || ""
      @start_time  = attrs["start"] || ""
      @end_time    = attrs["end"] || ""
    end
  end
end
