require 'json'
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

    get %r{^\/(\d{4}-\d{2}-\d{2})}, :authenticates => true do
      date = params[:captures].first

      erb :todos, :locals => { :todos => Todo.all_on_date(date),
                               :date  => DatePresenter.new(date) }
    end

    # get '/todos/:date/:id', :authenticates => true do
    #   content_type 'application/json', :charset => 'utf-8'

    #   Todo.find(params[:id]).to_json
    # end

    get '/todos/:date', :authenticates => true do
      content_type 'application/json', :charset => 'utf-8'

      Todo.all_on_date(params[:date]).to_json
    end


    # Change this to todo /date/id/complete
    post '/todos/complete', :authenticates => true do
      content_type 'application/json', :charset => 'utf-8'

      todo = Todo.mark_complete(:event_id => params[:event_id],
                                :date     => params[:date],
                                :summary  => params[:summary],
                                :variable => params[:variable])

      TodoPresenter.new(todo).to_json
    end

    post '/todos/incomplete', :authenticates => true do
      content_type 'application/json', :charset => 'utf-8'

      (Todo.mark_incomplete(:event_id => params[:event_id],
                            :date     => params[:date])
      ).to_json
    end
  end
end
