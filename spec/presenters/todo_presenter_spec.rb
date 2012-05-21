require 'spec_helper'
require_relative '../../app/presenters/todo_presenter'

describe Caldo::TodoPresenter do
  let(:todo) { Caldo::Todo.new(:summary => "Run {minutes} *important*",
                               :start_date => "2012-01-27 8:00PM") }
  subject { Caldo::TodoPresenter.new(todo) }

  describe "summary" do
    it "should not display the *important* tag" do
      subject.summary.should_not match(/\*important\*/)
    end

    it "should not display any variable tag" do
      subject.summary.should eq("Run")
    end
  end

  describe "date" do
    it "should only display the day" do
      subject.date.should eq("Friday")
    end
  end

  describe "time" do
    it "should display the time in the format: 8:00 PM" do
      subject.time.should eq("8:00 PM")
    end
  end
end
