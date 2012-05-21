require 'spec_helper'
require_relative '../../app/models/todo'

describe Caldo::Todo do
  let(:todo_params) { { :id => 1234, :summary => "Hello", :start_date => "today", :end_date => "tomorrow", :color_id => 1 } }
  let(:todo) { Caldo::Todo.new(todo_params) }

  describe "Todo.update" do
    it "calls the service with the right parameters" do
      fake_service = stub(:update_event)
      Caldo::Todo.stubs(:service).returns(fake_service)
      fake_service.expects(:update_event).with(:color => :green, :id => 1234).returns(todo_params)
      Caldo::Todo.update(:complete => true, :event_id => 1234)
    end
  end

  describe "summary variable" do
    it "should detect the summary variable" do
      todo.summary = "some summary {a var}"
      todo.summary_variable.should eq("a var")
    end

    it "should not raise an error when there is no variable" do
      todo.summary = "no variable here"
      expect { todo.summary_variable }.to_not raise_error
    end

    it "should replace it" do
      summary = "Run {minutes}"
      minutes = "30"
      Caldo::Todo.substitute_variable(summary, minutes).should eq("Run - 30 minutes")
    end

    it "should not detect a variable if it's not at the end of the summary" do
      todo.summary = "{minutes} Run"
      todo.summary_variable.should eq("")
    end

    it "should not replace a variable if it's not at the end of the summary" do
      summary = "{minutes} Run"
      minutes = "30"
      Caldo::Todo.substitute_variable(summary, minutes).should eq(summary)
    end
  end
end
