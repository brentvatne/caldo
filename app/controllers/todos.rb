require_relative 'authentication'
require_relative '../presenters/date'

module Caldo
  class App < Sinatra::Application
    get '/' do
      erb :unauthenticated
    end

    get '/today', :requires_authentication => true do
      redirect to("/#{Date.today.to_s}")
    end

    # Matches the route /2012-01-14
    get %r{(\d{4}-\d{2}-\d{2})}, :requires_authentication => true do
      date   = params[:captures].first
      events = calendar.find_events_on_date(date)

      erb :todos, :locals => { :events => events,
                               :date => DatePresenter.new(date) }
    end

    get '/todo/complete/:id' do
      content_type :json

      if calendar.update_event(:id => id, :color => :green)
        # success
      else
        # failure
      end.to_json
    end
  end
end
