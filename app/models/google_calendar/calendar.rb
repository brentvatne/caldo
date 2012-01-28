require_relative 'event'

module Caldo
  module GoogleCalendar
    COLORS = { :green => "2", :grey => "8" }

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
        response = send_update_request({
          'eventId'   => params[:id],
          'startDate' => params[:date],
          'colorId'   => COLORS[params[:color]] || COLORS[:grey],
          'summary'   => params[:summary]
        })

        p response

        if response
          Event.new(response)
        else
          false
        end
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
        event.summary  = params['summary'] if params['summary']

        schema_to_hash(client.execute!(
          :api_method  => calendar_api.events.update,
          :parameters  => default_options.merge('eventId' => event.id),
          :body_object => event,
          :headers => {'Content-Type' => 'application/json'}
        ).data)
      end

      def format_date(date)
        date.to_time.xmlschema
      end

      def send_list_request(params)
        params.merge!(default_options)
        client.execute(:api_method => calendar_api.events.list,
                       :parameters => params).data.to_hash["items"]
      end

      def schema_to_hash(schema)
        if schema
          { "id"          => schema.id,
            "summary"     => schema.summary,
            "description" => schema.description,
            "location"    => schema.location,
            "start"       => { "date" => schema.start.date || schema.start.dateTime },
            "end"         => { "date" => schema.end.date   || schema.start.dateTime },
            "color_id"    => schema.color_id }
        else
          nil
        end
      end
    end
  end
end
