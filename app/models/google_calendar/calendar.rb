require_relative 'event'

module Caldo
  module GoogleCalendar
    class Calendar
      attr_reader :client

      def initialize(api_client)
        @client = api_client
      end

      def find_events_on_date(date)
        date_to_find  = DateTime.parse(date)
        one_day_later = date_to_find + 1

        result = client.events({
          'timeMax' => client.format_date(one_day_later),
          'timeMin' => client.format_date(date_to_find)
        })

        return [] if result.nil?

        result.inject([]) { |events, attrs| events << Event.new(attrs) }
      end
    end
  end
end
