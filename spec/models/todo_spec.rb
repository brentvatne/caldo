require 'spec_helper'

describe Caldo::Todo do
  let(:event) { Caldo::GoogleCalendar::Event.new( "summary" => "hi",
     "start" => {"date" => "today"}, "end" => {"date" => "tomorrow"}) }

  let(:todo) { Caldo::Todo.new(event) }

  describe "summary variable" do
    it "should detect the summary variable" do
      todo.summary = "some summary {a var}"
      todo.summary_variable.should eq("a var")
    end

    it "should replace it" do
      Caldo::Todo.substitute_variable("hi {a var}", "sup").should eq("hi sup")
    end
  end
end
