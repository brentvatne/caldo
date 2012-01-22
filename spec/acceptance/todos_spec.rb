require_relative '../acceptance_helper'

describe 'todo functionality' do
  describe 'listing' do
    it 'lists all of the events on the day' do
      VCR.use_cassette('today') do
        visit '/today'
        page.should have_content "run"
        page.should have_content "fish"
        page.should have_content "sail"
        page.should have_content "sleep"
      end
    end

    xit "works based on the calendar's timezone" do
    end
  end
end
