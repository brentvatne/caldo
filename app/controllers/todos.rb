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

    post '/events/complete', :authenticates => true do
      update = calendar.update_event(:id => params[:id],
                                     :given_date => params[:given_date],
                                     :start_date => params[:start_date],
                                     :end_date => params[:end_date],
                                     :color => 2)
      response = if update
        { :updated => true }
      else
        { :updated => false }
      end

      params.to_json
    end
  end
end
