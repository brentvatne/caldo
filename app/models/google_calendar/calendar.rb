require_relative 'event'

module Caldo
  module GoogleCalendar
    class Calendar
      def initialize(api_client)
        self.client = api_client
      end

      def update_event(params)
        client.update_event({
          'eventId'   => params[:id],
          'startDate' => params[:given_date],
          'colorId'   => '2'
        })
      end

      def find_events_on_date(date)
        date          = DateTime.parse(date)
        date_to_find  = DateTime.new(date.year,date.month,date.day,0,0,0,'-8')
        one_day_later = DateTime.new(date.year,date.month,date.day,23,59,59,'-8')

        result = client.list_events({
          'timeMin' => client.format_date(date_to_find),
          'timeMax' => client.format_date(one_day_later)
        })

        # if events include an instance of a recurring event, hide the recurring event

        return [] if result.nil?

        result = result.inject([]) { |events, attrs| events << Event.new(attrs) }
        clean_up_completed_recurrences(result)
      end

      private
      attr_accessor :client

      def clean_up_completed_recurrences(events)
        unique_recurring_instances = events.inject([]) do |uniques, event|
          uniques << event.id.split("_").first if event.id.match(/_/)
          uniques
        end

        events.inject([]) do |without_general_recurring, event|
          matches = false
          unique_recurring_instances.each do |unique|
            matches = true if event.id == unique
          end
          without_general_recurring << event unless matches
          without_general_recurring
        end
      end
    end
  end
end
