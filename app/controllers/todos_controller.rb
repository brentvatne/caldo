require 'json'
require_relative '../presenters/date_presenter'
require_relative '../presenters/todo_presenter'

module Caldo
  class App < Sinatra::Application
    get '/' do
      erb :unauthenticated
    end

    get '/today', :authenticates => true do
      date = Date.today.to_s

      todos = Todo.all_within_reasonable_range_of(date).map { |todo|
        TodoPresenter.new(todo).to_hash
      }.to_json

      erb :todos, :locals => { :todos => todos }
    end

    get %r{^\/(\d{4}-\d{2}-\d{2})}, :authenticates => true do
      date = params[:captures].first

      todos = Todo.all_within_reasonable_range_of(date).map { |todo|
        TodoPresenter.new(todo).to_hash
      }.to_json

      erb :todos, :locals => { :todos => todos }
    end

    get '/todos/:date', :authenticates => true do
      content_type 'application/json', :charset => 'utf-8'

      Todo.all_within_reasonable_range_of(params[:date]).map { |todo|
        TodoPresenter.new(todo).to_hash
      }.to_json
    end

    put '/todos/:date/:id', :authenticates => true do
      content_type 'application/json', :charset => 'utf-8'

      record = JSON.parse(request.body.read).symbolize_keys!
      todo = Todo.update(record)
      TodoPresenter.new(todo).to_hash.to_json
    end
  end
end
