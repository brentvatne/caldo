module Caldo
  module GoogleCalendar
    module EventInterface
      def calendar_api
        @calendar_api ||= delegate.discovered_api('calendar', 'v3')
      end

      def default_params
        { 'calendarId' => 'primary' }
      end

      def update_event(params)
        event = find_event(params['eventId'], params['startDate'])

        event.color_id = params['colorId']

        result = delegate.execute(
          :api_method  => calendar_api.events.update,
          :parameters  => default_params.merge('eventId' => event.id),
          :body_object => event,
          :headers => {'Content-Type' => 'application/json'}
        )

        result.data.updated
      end

      def find_event(id, start_date = nil)
        event = delegate.execute(
          :api_method => calendar_api.events.get,
          :parameters => default_params.merge('eventId' => id)
        ).data

        unless event.recurrence.empty?
          event = find_recurring_event(id, start_date)
        end

        event
      end

      def find_recurring_event(id, start_date)
        instances = delegate.execute(
          :api_method => calendar_api.events.instances,
          :parameters => default_params.merge('eventId' => id)
        ).data.items
        instance = instances.detect { |i| i["start"]["date"] == start_date }

        find_event(instance["id"])
      end

      def list_events(params)
        params.merge!('calendarId' => 'primary')
        delegate.execute(:api_method => calendar_api.events.list,
                         :parameters => params).data.to_hash["items"]
      end

      def format_date(date)
        date.to_time.xmlschema
      end
    end
  end
end
