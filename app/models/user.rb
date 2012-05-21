require_relative "../../config/data_mapper"

module Caldo
  class User
    include DataMapper::Resource

    has 1, :token_pair

    property :id,    Serial
    property :email, String, :unique => true

    def self.find_or_create_from_omniauth(params)
      email = params['info']['email']

      if user = first(:email => email)
        user
      else
        credentials = params['credentials']

        create(:email => email,
               :token_pair => TokenPair.create(credentials))
      end
    end

    def self.token_pair_for(email)
      first(:email => email).token_pair
    end

    def update_token(params)
      token_pair.update_token(params)
      save
    end
  end
end
