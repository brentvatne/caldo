require 'date'

module Caldo
  module GoogleCalendar
    class Event
      attr_accessor :id, :summary, :description, :location, :start_date, :end_date, :color_id

      def initialize(attrs)
        self.id          = attrs.fetch("id", "")
        self.summary     = attrs.fetch("summary", "")
        self.description = attrs.fetch("description", "")
        self.location    = attrs.fetch("location", "")
        self.start_date  = attrs["start"]["date"] || attrs["start"]["dateTime"] || ""
        self.end_date    = attrs["end"]["date"]   || attrs["end"]["dateTime"]   || ""
        self.color_id    = attrs["colorId"]       || attrs["color_id"]          || ""
      end

      # Make the attributes also accessible like a hash for easier initialization
      def [](sym)
        self.send(sym)
      end
    end
  end
end
