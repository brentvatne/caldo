require_relative 'event'

module Caldo
  module GoogleCalendar
    class Calendar
      def initialize(api_client)
        self.client = api_client
      end

      def calendar_api
        @calendar_api ||= client.discovered_api('calendar', 'v3')
      end

      def default_options
        { 'calendarId' => 'primary' }
      end

      def find_event(id, start_date = nil)
        event = send_get_by_id_request(id)

        unless event.recurrence.empty?
          event = find_recurring_event(id, start_date)
        end

        event
      end

      def find_recurring_event(id, start_date)
        instance = recurring_event_instances(id).detect do |i|
          instance_date = i["start"]["date"] || i["start"]["dateTime"]
          instance_date = DateTime.parse(instance_date).to_date.xmlschema
          instance_date == start_date
        end
        find_event(instance["id"])
      end

      def recurring_event_instances(id)
        client.execute(
          :api_method => calendar_api.events.instances,
          :parameters => default_options.merge('eventId' => id)
        ).data.items
      end

      def format_date(date)
        date.to_time.xmlschema
      end

      def update_event(params)
        puts "update_event #{params[:date]}"
        send_update_request({
          'eventId'   => params[:id],
          'startDate' => params[:date],
          'colorId'   => params[:color]
        })
      end

      def find_events_on_date(date)
        date          = DateTime.parse(date)
        date_to_find  = DateTime.new(date.year,date.month,date.day,0,0,0,'-8')
        one_day_later = DateTime.new(date.year,date.month,date.day,23,59,59,'-8')

        result = send_list_request({
          'timeMin' => format_date(date_to_find),
          'timeMax' => format_date(one_day_later)
        })

        return [] if result.nil?

        result = result.inject([]) { |events, attrs| events << Event.new(attrs) }
        clean_up_completed_recurrences(result)
      end

      private
      attr_accessor :client
      def send_get_by_id_request(id)
        client.execute(
          :api_method => calendar_api.events.get,
          :parameters => default_options.merge('eventId' => id)
        ).data
      end

      def send_update_request(params)
        event = find_event(params['eventId'], params['startDate'])

        event.color_id = params['colorId']

        result = client.execute(
          :api_method  => calendar_api.events.update,
          :parameters  => default_options.merge('eventId' => event.id),
          :body_object => event,
          :headers => {'Content-Type' => 'application/json'}
        )

        result.data.updated
      end

      def send_list_request(params)
        params.merge!(default_options)
        client.execute(:api_method => calendar_api.events.list,
                       :parameters => params).data.to_hash["items"]
      end

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
