require 'date'

class Caldo < Sinatra::Application
  get '/' do
    redirect to("/#{Date.today.to_s}")
  end

  # Matches the route /2012-01-14
  get %r{(\d{4}-\d{2}-\d{2})} do
    date       = params[:captures].first
    events     = calendar.find_events_by_date(date)

    erb :events, :locals => { :events => events, :date => date }
  end

  helpers do
    def human_date(date)
      DateTime.parse(date).strftime("%A, %B %d")
    end

    def next_date_path(date)
      "/" + (DateTime.parse(date) + 1).to_date.to_s
    end

    def prev_date_path(date)
      "/" + (DateTime.parse(date) - 1).to_date.to_s
    end
  end
end
