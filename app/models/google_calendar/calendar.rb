require 'date'
require 'time'

module GoogleCalendar
  class Calendar
    attr_reader :api_client, :calendar_api

    def initialize(api_client, calendar_api)
      @api_client   = api_client
      @calendar_api = calendar_api
    end

    def find_events_by_date(date)
      date_to_find = DateTime.parse(date)
      day_after    = date_to_find + 1

      api_client.execute(
        :api_method => @calendar_api.events.list,
        :parameters => {'calendarId' => 'primary',
                        'timeMax' => day_after.to_time.utc.xmlschema,
                        'timeMin' => date_to_find.to_time.utc.xmlschema })
    end
  end
end
