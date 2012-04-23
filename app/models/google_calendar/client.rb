require 'google/api_client'
require_relative 'calendar'

module Caldo
  module GoogleCalendar
    class Client
      attr_reader :calendar

      def initialize
        self.delegate = Google::APIClient.new
        yield self if block_given?
        self.calendar = Calendar.new(self)
      end

      def method_missing(method, *args, &block)
        delegate.send(method, *args, &block)
      end

      def authorization_details
        delegate.authorization
      end

      # This is the url that was requested before redirecting to authorization
      def path_before_signing_in
        delegate.authorization.state
      end

      def has_valid_access_token?
        # use Time.at(expires_at) compared to current time
        access_token?
      end

      def access_token?
        delegate.authorization.access_token
      end

      # should be called refresh_access_token
      def fetch_access_token
        delegate.authorization.fetch_access_token!
        # find the user
        # update their token to the given token
        # here i do not update the local tokenpair persisted
        # to the db!
        #
        # put code here to update it properly!
        # need to set the new attributes from client
      end

      def token_pair=(new_token_pair)
        if new_token_pair
          delegate.authorization.update_token!(new_token_pair.to_hash)

          if refresh_token? && delegate.authorization.expired?
            fetch_access_token
          end
        end
      end

      def token_pair
        delegate.authorization
      end

      def client_id=(new_client_id)
        delegate.authorization.client_id = new_client_id
      end

      def client_secret=(new_client_secret)
        delegate.authorization.client_secret = new_client_secret
      end

      def scope=(new_scope)
        delegate.authorization.scope = new_scope
      end

      def redirect_uri=(new_redirect_uri)
        delegate.authorization.redirect_uri = new_redirect_uri
      end

      def code=(new_code)
        delegate.authorization.code = new_code if new_code
      end

      def state=(new_state)
        delegate.authorization.state = new_state
      end

      # Set the expiration time of the token (to the second)
      #
      # new_expire_time - An integer representing a time
      #
      # Returns a Time object instantiated from the given time integer
      def token_expiration=(new_expire_time)
        @expires_at = Time.at(new_expire_time)
      end

      # Determines if the access token has expired
      #
      # If it's 5 minutes before the expiration date, it is considered expired.
      #
      # Returns true if expired, false if not
      def access_token_expired?
        !!(Time.now >= (expires_at - 5 * 60))
      end

      private
      attr_accessor :delegate
      attr_reader   :expires_at
      attr_writer   :calendar

      def refresh_token?
        delegate.authorization.refresh_token
      end
    end
  end
end
