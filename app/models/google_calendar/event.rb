module Caldo
  module GoogleCalendar
    class Event
      attr_accessor :id, :summary, :description, :location,
                    :start_date, :end_date, :color_id

      def initialize(attrs)
        self.id          = attrs["id"]
        self.summary     = attrs["summary"]
        self.description = attrs["description"] || ""
        self.location    = attrs["location"] || ""
        self.start_date  = attrs["start"]["date"] || attrs["start"]["dateTime"]
        self.end_date    = attrs["end"]["date"] || attrs["end"]["dateTime"]
        self.color_id    = attrs["colorId"]
      end

      def complete?
        color_id == "2"
      end
    end
  end
end
