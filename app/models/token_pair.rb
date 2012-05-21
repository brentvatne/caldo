require_relative "../../config/data_mapper"
require 'ostruct'

module Caldo

  # It is considered a "TokenPair" because there are two tokens: the access token
  # and the refresh token. The access token has a relatively short life to protect
  # against it getting stolen, and the refresh token allows us to grab
  # another access token if the authorization has expired.
  class TokenPair
    include DataMapper::Resource

    belongs_to :user, :required => false

    property :id,            Serial
    property :refresh_token, String
    property :access_token,  String
    property :expires_at,    Integer

    def initialize(params)
      update_token(params)
    end

    def update_token(params)
      attrs = attributes_for(params)
      self.refresh_token = attrs.refresh_token unless attrs.refresh_token.nil?
      self.access_token  = attrs.access_token
      self.expires_at    = attrs.expires_at
    end

    def to_hash
      { :refresh_token => refresh_token,
        :access_token  => access_token,
        :expires_at    => Time.at(expires_at) }
    end

    private

    # Converts a hash or hash-like object that indexes elements on strings or
    # symbols to an object that provides access to attributes through dot
    # notation.
    #
    # Returns an OpenStruct instance
    def attributes_for(params)
      if params.kind_of?(Hash)
        attrs = OpenStruct.new
        attrs.refresh_token = params[:refresh_token] || params['refresh_token']
        attrs.access_token  = params[:access_token]  || params['token']
        attrs.expires_at    = params[:expires_at]    || params['expires_at']

        params = attrs
      end
      params
    end
  end
end
