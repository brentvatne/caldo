require_relative 'authentication'
require_relative '../presenters/date'

module Caldo
  class App < Sinatra::Application
    get '/' do
      erb :unauthenticated
    end

    get '/today' do
      require_authentication

      redirect to("/#{Date.today.to_s}")
    end

    # Matches the route /2012-01-14
    get %r{(\d{4}-\d{2}-\d{2})} do
      require_authentication

      date   = params[:captures].first
      events = calendar.find_events_on_date(date)

      erb :todos, :locals => { :events => events,
                               :date => DatePresenter.new(date) }
    end
  end
end
