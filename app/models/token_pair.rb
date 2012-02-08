require_relative "../../config/data_mapper"
require 'ostruct'

module Caldo

  # It is considered a "TokenPair" because there are two tokens: the access token
  # and the refresh token. The access token has a relatively short life to protect
  # against it getting stolen, and the refresh token allows us to grab
  # another access token if the authorization has expired.
  class TokenPair
    include DataMapper::Resource

    property :id, Serial
    property :refresh_token, String, :length => 255
    property :access_token, String, :length => 255
    property :expires_in, Integer
    property :issued_at, Integer

    def initialize(attrs)
      if (attrs.kind_of?(Hash))
        new_object = OpenStruct.new
        new_object.refresh_token = attrs[:refresh_token] || attrs['refresh_token']
        new_object.access_token  = attrs[:access_token]  || attrs['access_token']
        new_object.expires_in    = attrs[:expires_in]    || attrs['expires_in']
        new_object.issued_at     = attrs[:issued_at]     || attrs['issued_at']
        attrs = new_object
      end
      update_token!(attrs)
    end

    # Only set the refresh token once.
    def update_token!(object)
      self.refresh_token = self.refresh_token || object.refresh_token
      self.access_token  = object.access_token
      self.expires_in    = object.expires_in
      self.issued_at     = object.issued_at
    end

    def to_hash
      { :refresh_token => refresh_token,
        :access_token  => access_token,
        :expires_in    => expires_in,
        :issued_at     => Time.at(issued_at) }
    end
  end
end

DataMapper.finalize
DataMapper.auto_upgrade!
