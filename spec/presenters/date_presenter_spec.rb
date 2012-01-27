require 'spec_helper'

describe Caldo::DatePresenter do
  let(:date) { DateTime.parse("2012-01-27 8:00PM") }
  subject { Caldo::DatePresenter.new(date) }

  describe "humanize" do
    it "should be in the human readable form 'Friday, January 27'" do
      subject.humanize.should eq("Friday, January 27")
    end
  end

  describe "portable" do
    it "should encode the date but not the time in the rfc standard form readable by google api" do
      subject.portable.should eq("2012-01-27")
    end
  end

  describe "path" do
    it "should turn the date into a path" do
      subject.path.should eq("/2012-01-27")
    end
  end

  describe "next date path" do
    it "should get the path for the following day" do
      subject.next_date_path.should eq("/2012-01-28")
    end
  end

  describe "prev date path" do
    it "should get the path for the previous day" do
      subject.prev_date_path.should eq("/2012-01-26")
    end
  end
end
