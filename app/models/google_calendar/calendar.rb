require_relative 'event'

module Caldo
  module GoogleCalendar
    class Calendar
      def initialize(api_client)
        self.client = api_client
      end

      def update_event(params)
        client.update_event({
          'eventId' => params[:id],
          'colorId' => '2'
        })
      end

      def find_events_on_date(date)
        date          = DateTime.parse(date)
        date_to_find  = DateTime.new(date.year,date.month,date.day,0,0,0,'-8')
        one_day_later = date_to_find + 1

        result = client.list_events({
          'timeMin' => client.format_date(date_to_find),
          'timeMax' => client.format_date(one_day_later)
        })

        return [] if result.nil?

        result.inject([]) { |events, attrs| events << Event.new(attrs) }
      end

      private
      attr_accessor :client

    end
  end
end
