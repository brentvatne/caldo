require_relative 'google_authentication'
require 'date'

class Caldo < Sinatra::Application
  get '/' do
    redirect to("/#{Date.today.to_s}")
  end

  # Matches the route /2012-01-14
  get %r{(\d{4}-\d{2}-\d{2})} do
    date   = params[:captures].first
    events = calendar.find_events_by_date(date)

    body = events.inject("") do |text, event|
      text += "<h2> #{event.summary} </h2> <p>#{event.description}</p>"
    end

    "<h1>" + DateTime.parse(date).strftime("%A, %B %d") + "</h1>" + body
  end

  get '/debug' do
    [200, {'Content-Type' => 'text/html'}, "use this to debug" ]
  end
end
