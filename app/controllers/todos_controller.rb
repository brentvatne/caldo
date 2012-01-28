require 'json'
require_relative 'authentication_controller'
require_relative '../presenters/date_presenter'
require_relative '../presenters/todo_presenter'

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
      # TODO: Replace :id => .. to :event_id => params[:event_id]
      content_type 'application/json', :charset => 'utf-8'
      todo = Todo.mark_complete(:id       => params[:id],
                                :date     => params[:date],
                                :summary  => params[:summary],
                                :variable => params[:variable])
      TodoPresenter.new(todo).to_json
    end

    post '/todos/incomplete', :authenticates => true do
      content_type 'application/json', :charset => 'utf-8'
      (Todo.mark_incomplete(:id   => params[:id],
                            :date => params[:date])
      ).to_json
    end
  end
end
