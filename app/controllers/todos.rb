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
      date = params[:captures].first

      erb :todos, :locals => { :todos => Todo.all_on_date(date),
                               :date  => DatePresenter.new(date) }
    end

    post '/todos/complete', :authenticates => true do
      (!! Todo.mark_complete(:id   => params[:id],
                             :date => params[:date],
                             :summary => params[:summary],
                             :variable => params[:variable])
      ).to_json
    end

    post '/todos/incomplete', :authenticates => true do
      (!! Todo.mark_incomplete(:id   => params[:id],
                               :date => params[:date])
      ).to_json
    end
  end
end
