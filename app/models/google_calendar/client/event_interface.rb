module Caldo
  module GoogleCalendar
    module EventInterface
      def calendar_api
        @calendar_api ||= delegate.discovered_api('calendar', 'v3')
      end

      def default_params
        { 'calendarId' => 'primary' }
      end

      def find_event(id)
        delegate.execute(
          :api_method => calendar_api.events.get,
          :parameters => default_params.merge('eventId' => id)
        ).data
      end

      def update_event(params)
        event = find_event(params['eventId'])
        # if event.recurrence.empty?

        event.color_id = params['colorId']

        result = delegate.execute(
          :api_method  => calendar_api.events.update,
          :parameters  => default_params.merge('eventId' => event.id),
          :body_object => event,
          :headers => {'Content-Type' => 'application/json'}
        )

        print result.data.updated
        result.data.updated
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
