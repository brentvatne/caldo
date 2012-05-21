require 'google/api_client'

module Caldo
  module GoogleCalendar
    class NoRefreshToken < StandardError; end

    # This class is a wrapper for the official Google API Client class to make
    # it easier to work with. It's responsibility is to ensure that the access
    # token is in a valid state and always able to make requests.
    #
    # In order to initialize it:
    #
    #   token_pair = TokenPair.first(:id => 1)
    #   service = GoogleCalendar::Client.new do |c|
    #     c.client_id     = GAPI_CLIENT_ID
    #     c.client_secret = GAPI_CLIENT_SECRET
    #     c.token_pair    = token_pair
    #   end
    #
    # TokenPair is a class whose instances respond to:
    #   refresh_token - A string corresponding to a Calendar API refresh token.
    #   access_token  - A string corresponding to a Calendar API access token.
    #   expires_at    - An integer that represents the time when the access
    #                   token expires. (eg: Time.now.to_i)
    #
    # The client itself is not very useful beyond proxying the execute method.
    # The Calendar class, which you can access through the calendar method on an
    # instance of Client, wraps other Calendar API methods for easier access.
    #
    # Returns an instance of the Client class
    class Client
      attr_reader :calendar

      def self.configure(*args, &block)
        client = new(*args, &block)
        client.calendar
      end

      def initialize
        self.delegate = Google::APIClient.new

        yield self if block_given?

        self.calendar = Calendar.new(self)
      end

      # Public: Delegate any undefined methods to the delegate object, which
      # is an instance of the official Google API Client class
      def method_missing(method, *args, &block)
        delegate.send(method, *args, &block)
      end

      # Public: 
      def execute(*args)
        if access_token_expired?
          get_fresh_access_token
        end

        delegate.send(:execute, *args)
      end

      # Set the local Client token pair values and update them if
      # necessary (and possible)
      def token_pair=(tokens)
        if tokens
          delegate.authorization.update_token!(tokens.to_hash)
        end
      end

      # Fetches a new access token and saves it
      #
      # Raises NoRefreshToken if a refresh token is somehow not available
      def get_fresh_access_token
        if refresh_token
          delegate.authorization.fetch_access_token!
          save_new_token
        else
          raise NoRefreshToken
        end
      end

      # Saves the current token information to the user
      def save_new_token(user = nil)
        user ||= User.first(Thread.current['uid'])
        user.update_token(delegate.authorization)
      end

      # Determines if the access token has expired
      #
      # Returns true if expired, false if not
      def access_token_expired?
        delegate.authorization.expired?
      end

      def token_pair
        delegate.authorization
      end

      def refresh_token
        token_pair.refresh_token
      end

      def access_token
        token_pair.access_token
      end

      def expires_at
        token_pair.expires_at
      end

      # The path visited before being redirected to authorization
      def path_before_signing_in
        delegate.authorization.state
      end

      # The following methods are used as part of the initialize dsl

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

      private
      attr_accessor :delegate
      attr_writer   :calendar
    end
  end
end
