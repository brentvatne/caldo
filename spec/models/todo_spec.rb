require 'spec_helper'

describe Caldo::Todo do
  let(:todo) { Caldo::Todo.new(:summary => "Hello", :start => "today", :end => "tomorrow") }

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
  end
end
