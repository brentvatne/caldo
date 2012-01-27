require_relative 'event'

module Caldo
  module GoogleCalendar
    class Calendar
      def initialize(api_client)
        self.client = api_client
      end

      def default_options
        { 'calendarId' => 'primary' }
      end

      def find_event(id, start_date = nil)
        send_get_by_id_request(id)
      end

      def find_events_by_date(params)
        min = params[:min]
        max = params[:max]

        result = send_list_request({
          'timeMin' => format_date(min),
          'timeMax' => format_date(max),
          'singleEvents' => 'true',
          'maxResults' => '50'
        })

        return [] if result.nil?

        result.inject([]) { |events, attrs| events << Event.new(attrs) }
      end

      def update_event(params)
        send_update_request({
          'eventId'   => params[:id],
          'startDate' => params[:date],
          'colorId'   => params[:color]
        })
      end

      private
      attr_accessor :client

      def calendar_api
        @calendar_api ||= client.discovered_api('calendar', 'v3')
      end

      def send_get_by_id_request(id)
        client.execute(
          :api_method => calendar_api.events.get,
          :parameters => default_options.merge('eventId' => id)
        ).data
      end

      def send_update_request(params)
        event = find_event(params['eventId'], params['startDate'])

        event.color_id = params['colorId']

        result = client.execute!(
          :api_method  => calendar_api.events.update,
          :parameters  => default_options.merge('eventId' => event.id),
          :body_object => event,
          :headers => {'Content-Type' => 'application/json'}
        )

        result.data.updated
      end

      def format_date(date)
        date.to_time.xmlschema
      end

      def send_list_request(params)
        params.merge!(default_options)
        client.execute(:api_method => calendar_api.events.list,
                       :parameters => params).data.to_hash["items"]
      end
    end
  end
end
