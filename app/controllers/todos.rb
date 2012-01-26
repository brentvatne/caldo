require 'json'
require_relative 'authentication'
require_relative '../presenters/date'

module Caldo
  class App < Sinatra::Application
    get '/' do
      erb :unauthenticated
    end

    get '/today', :authenticates => true do
      redirect to("/#{Date.today.to_s}")
    end

    get %r{(\d{4}-\d{2}-\d{2})}, :authenticates => true do
      date   = params[:captures].first
      events = calendar.find_events_on_date(date)

      erb :todos, :locals => { :events => events,
                               :date => DatePresenter.new(date) }
    end

    get '/events/:id/complete', :authenticates => true do
      response = if calendar.update_event(:id => params[:id], :color => :green)
        { :updated => true }
      else
        { :updated => false }
      end

      response.to_json
    end
  end
end
