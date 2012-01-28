require 'google/api_client'
require_relative 'calendar'
require 'date'
require 'time'

module Caldo
  module GoogleCalendar
    class Client
      attr_reader :calendar

      def initialize
        self.delegate = Google::APIClient.new
        self.scope    = default_options[:scope]
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

      def authorization_uri
        if access_token? && !refresh_token?
          forced_authorization_uri
        else
          auto_approval_uri
        end
      end

      def forced_authorization_uri
        authorization_details.authorization_uri.to_s
      end

      def auto_approval_uri
        enable_auto_approval(authorization_details.authorization_uri.to_s)
      end

      def has_valid_access_token?
        access_token? && !delegate.authorization.expired?
      end

      def access_token?
        delegate.authorization.access_token
      end

      def fetch_access_token
        delegate.authorization.fetch_access_token!
      end

      def token_pair=(new_token_pair)
        if new_token_pair
          delegate.authorization.update_token!(new_token_pair.to_hash)

          if refresh_token? && delegate.authorization.expired?
            delegate.authorization.fetch_access_token!
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

      private
      attr_accessor :delegate
      attr_writer   :calendar

      def refresh_token?
        delegate.authorization.refresh_token
      end

      def enable_auto_approval(path)
        path.gsub("&approval_prompt=force","")
      end

      def default_options
        { :scope => 'https://www.googleapis.com/auth/calendar' }
      end
    end
  end
end
