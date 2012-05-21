require 'spec_helper'
require_relative '../../../app/models/google_calendar/client'

module Caldo
  module GoogleCalendar
    describe "client" do
      let(:client) { Client.new }

      describe "access_token_expired?" do
        it "is true if time is after the token expirey time" do
          current_time_is     "2012-01-01 8:00pm"
          token_expiration_is "2012-01-01 7:00pm"
          client.access_token_expired?.should be_true
        end

        it "is false if time is before the token expirey time" do
          current_time_is     "2012-01-01 7:00pm"
          token_expiration_is "2012-01-01 8:00pm"
          client.access_token_expired?.should be_false
        end

        it "is true if time is within five minutes of expirey time" do
          current_time_is     "2012-01-01 6:55pm"
          token_expiration_is "2012-01-01 7:00pm"
          client.access_token_expired?.should be_true

          current_time_is     "2012-01-01 6:54pm"
          client.access_token_expired?.should be_false
        end
      end
    end
  end
end
