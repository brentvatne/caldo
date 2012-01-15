require 'date'
require 'time'

module GoogleCalendar
  class Calendar
    attr_reader :api_client, :calendar_api

    def initialize(api_client, calendar_api)
      @api_client   = api_client
      @calendar_api = calendar_api
    end

    def find_events_on_date(date)
      date_to_find  = DateTime.parse(date)
      one_day_later = date_to_find + 1

      result = api_client.execute(
        :api_method => @calendar_api.events.list,
        :parameters => {'calendarId' => 'primary',
                        'timeMax' => one_day_later.to_time.utc.xmlschema,
                        'timeMin' => date_to_find.to_time.utc.xmlschema }
        ).data.to_hash["items"]

      return [] if result.nil?

      result.inject([]) do |events, attrs|
        events << Event.new(attrs)
      end
    end

  end
end
