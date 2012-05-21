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

      # Public: Finds a specific event given its ID
      #
      # id - A String ID corresponding to a Google Calendar Event ID.
      #      eg: "0e9ft9c6gk7tm29srrjcupp94c_20120520"
      #
      # Returns an Event instance if found, or false if not.
      def find_event(id)
        response = send_get_by_id_request(id)

        if response
          Event.new(response)
        else
          false
        end
      end

      # Public: Gets a list of events between a given date range.
      #
      # params
      #   :min         - The beginning of a date/time range. A DateTime object.
      #   :max         - The end of a date/time range. A DateTime object.
      #   :max_results - Optional, an integer that specifies the maximum number
      #                  of events to return.
      #
      # Returns an Array of Events or an empty Array if no Events were found
      # in the given date range.
      def find_events_by_date(params)
        response = send_list_request({
          'timeMin'      => format_date(params[:min]),
          'timeMax'      => format_date(params[:max]),
          'maxResults'   => params.fetch(:max_results, 50).to_s,
          'singleEvents' => 'true'
        })

        if response
          response.inject([]) { |events, attrs|
            events << Event.new(attrs)
          }
        else
          []
        end
      end

      # Public: Updates an event with the given attributes
      #
      # params
      #   :id      - The Google Calendar ID for the event.
      #   :date    - A Date String eg "2012-05-21"
      #   :color   - A color id as understood by Google Calendar. A String,
      #              eg: "2" corresponds to a shade of green.
      #   :summary - A String short description of the Event, eg "Bike 2 miles"
      #              Some people might call this the title of the Event, but
      #              I stuck with summary to keep consistent with Google's
      #              terminology.
      #
      # Returns the updated Event instance if successful, false if not.
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
        )
      end

      def send_update_request(params)
        event = send_get_by_id_request(params['eventId']).data

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

      # Private: Formats a given Date, Time, or DateTime to the xmlschema
      # standard time format understood by Google Calendar API.
      #
      # Returns the date and time of the passed in object as a string
      # formatted according to XML schema: eg: "2012-05-21T13:19:08-07:00"
      def format_date(date)
        date.to_time.xmlschema
      end

      # Private: Converts a Google Calendar API schema object to a hash.
      #
      # This is a weird part of the system, not sure how I should handle the
      # date and datetime - currently I don't care much about them so I just
      # throw either under the 'date' key.
      #
      # Returns a hash or nil if no schema is given.
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
