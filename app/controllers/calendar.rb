require_relative 'google_authentication'

class Caldo < Sinatra::Application
  get '/' do
    events = calendar.find_events_by_date("2012-01-01")

    body = ""
    body += events.data.to_json
    body += events.data.methods.join(" ")
    body += "<br><br>"
    body += events.data.to_hash.keys.join(" ")
    body += "<br><br>"
    body += events.data.to_hash["items"].inspect
    body += "<br><br>"

    events.data.to_hash["items"].each do |item|
      body += item.keys.join(" ") + "<br>"
    end

    [200, {'Content-Type' => 'text/html'}, body ]
  end

end
