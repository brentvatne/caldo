require_relative 'google_authentication'

class Caldo < Sinatra::Application
  get '/' do
    result = google_api_client.execute(:api_method => oauth.userinfo.get)
    status, _, _ = result.response
    [status, {'Content-Type' => 'application/json'}, result.data.to_json]
  end
end

# result = @client.execute(:api_method => @calendar.events.list,
#                          :parameters => {'calendarId' => 'primary',
#                                          'timeMax' => Time.parse('2012-01-02').utc.xmlschema,
#                                          'timeMin' => Time.parse('2012-01-01').utc.xmlschema })
