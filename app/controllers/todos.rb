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
      events = Todo.all_on_date(date)

      erb :todos, :locals => { :events => events,
                               :date => DatePresenter.new(date) }
    end

    post '/events/complete', :authenticates => true do
      update = Todo.mark_complete(:id => params[:id], :date => params[:date])

      { :updated => !!update }.to_json
    end
  end
end
