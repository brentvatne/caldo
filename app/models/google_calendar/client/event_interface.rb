module Caldo
  module GoogleCalendar
    module EventInterface
      def calendar_api
        @calendar_api ||= delegate.discovered_api('calendar', 'v3')
      end

      def events(params)
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
