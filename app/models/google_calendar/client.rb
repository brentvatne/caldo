require 'google/api_client'
require 'date'
require 'time'

module Caldo
  module GoogleCalendar
    class Client
      attr_reader :token_pair

      def initialize(params)
        self.delegate      = Google::APIClient.new
        self.client_id     = params[:client_id]
        self.client_secret = params[:client_secret]
        self.scope         = params[:scope] || default_options[:scope]
        self.redirect_uri  = params[:redirect_uri]
        self.code          = params[:code]
        self.token_pair    = params[:token_pair]
      end

      def events(params)
        params.merge!('calendarId' => 'primary')
        delegate.execute(:api_method => calendar_api.events.list,
                         :parameters => params).data.to_hash["items"]
      end

      def authorization_details
        delegate.authorization
      end

      def authorization_uri
        enable_auto_approval(authorization_details.authorization_uri.to_s)
      end

      def format_date(date)
        date.to_time.utc.xmlschema
      end

      def has_access_token?
        delegate.authorization.access_token
      end

      def fetch_access_token!
        delegate.authorization.fetch_access_token!
      end

      private
      attr_accessor :delegate

      def calendar_api
        @calendar_api ||= delegate.discovered_api('calendar', 'v3')
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

      def token_pair=(new_token_pair)
        if new_token_pair
          delegate.authorization.update_token!(new_token_pair.to_hash)
          fetch_new_token_if_needed
        end
      end

      def fetch_new_token_if_needed
        if delegate.authorization.refresh_token && delegate.authorization.expired?
          self.fetch_access_token!
        end
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
