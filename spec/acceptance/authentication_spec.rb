require_relative '../acceptance_helper'

describe 'authorization' do
  before(:each) do
    # visit '/sign_out'
  end

  describe 'sign in' do
    it 'lets users with valid google accounts sign in' do
      # Capybara.current_driver = :selenium
      # visit '/'
      # click_link 'Sign in'
      # fill_in 'Email',    :with => test_account
      # fill_in 'Password', :with => test_password
      # click_button 'Sign in'
      # click_button 'Allow access'
      # page.should have_content 'January 15'
    end
  end

  describe 'sign out' do
    it 'should sign a user out' do
      # visit '/sign_out'
      # current_path.should == '/'
      # page.should have_content 'signed out'
    end
  end
end
