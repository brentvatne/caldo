module Caldo
  module GoogleCalendar
    class Event
      attr_accessor :id, :summary, :description, :location, :start_time, :end_time

      def initialize(attrs)
        self.id          = attrs["id"]
        self.summary     = attrs["summary"]
        self.description = attrs["description"] || ""
        self.location    = attrs["location"] || ""
        self.start_time  = attrs["start"] || ""
        self.end_time    = attrs["end"] || ""
      end
    end
  end
end
