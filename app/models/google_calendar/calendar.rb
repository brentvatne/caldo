require_relative 'event'

module Caldo
  module GoogleCalendar
    COLORS = { :green => "2", :grey => "8" }

    # The Calendar class wraps Google Calendar API v3 methods / parameters to
    # provide a more ruby-like interface, and delegates the execution and parsing
    # of results to the Client class (which in turn delegates to the official
    # Google Calendar API client).
    class Calendar
      def initialize(api_client)
        self.client = api_client
      end

      def default_options
        { 'calendarId' => 'primary' }
      end

      def find_events_by_date(params)
        response = send_list_request({
          'timeMin' => format_date(params[:min]),
          'timeMax' => format_date(params[:max]),
          'singleEvents' => 'true',
          'maxResults' => '50'
        })

        if response
          response.inject([]) { |events, attrs|
            events << Event.new(attrs)
          }
        else
          []
        end
      end

      def update_event(params)
        response = send_update_request({
          'eventId'   => params[:id],
          'startDate' => params[:date],
          'colorId'   => COLORS[params[:color]] || COLORS[:grey],
          'summary'   => params[:summary]
        })

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

      def send_list_request(params)
        params.merge!(default_options)
        client.execute(:api_method => calendar_api.events.list,
                       :parameters => params).data.to_hash["items"]
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

        response = client.execute(
          :api_method  => calendar_api.events.update,
          :parameters  => default_options.merge('eventId' => event.id),
          :body_object => event,
          :headers     => {'Content-Type' => 'application/json'}
        )

        if response
          schema_to_hash(response.data)
        else
          false
        end
      end

      def find_event(id, start_date = nil)
        send_get_by_id_request(id)
      end

      # Private: Formats a given Date, Time, or DateTime to the xmlschema
      # standard time format understood by Google Calendar API.
      #
      # Returns the date and time of the passed in object as a string
      # formatted according to XML schema: eg: "2012-05-21T13:19:08-07:00"
      def format_date(date)
        date.to_time.xmlschema
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
