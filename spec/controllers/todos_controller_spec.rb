require 'spec_helper'
require_relative '../support/authenticates_faker'
require_relative '../../app/controllers/todos_controller'

describe "Todos actions" do
  include Rack::Test::Methods

  def app
    Caldo::App
  end

  describe "GET /:date" do
    it "should fetch a list for the date" do
      Caldo::Todo.expects(:all_on_date).with("2012-01-12").once
      get '/2012-01-12'
    end
  end

  describe "GET /todos/:date/:id" do
    it "should fetch the todo with the given id" do
      Caldo::Todo.expects(:find).with("some_id").once
      get '/todos/2012-01-12/some_id'
    end
  end

  describe "GET /todos/:date" do
    it "should fetch the todos for the given date" do
      Caldo::Todo.expects(:all_on_date).with("2012-01-12").once
      get '/todos/2012-01-12'
    end
  end
end
