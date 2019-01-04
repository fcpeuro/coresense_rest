#3rd Party Libs
require 'openssl'
require 'json'
require "base64"
require 'jwt'
require 'httparty'
#Base Class
require_relative 'resources/Request'
#Functional Modules
require_relative 'resources/Findable'
require_relative 'resources/Searchable'
#Resource Definitions
require_relative 'resources/Resource'
require_relative 'resources/Affiliate'

module CoresenseRest
  class Client

    def initialize(host, user_id, key)
      @host = host
      @token = get_token user_id, key
      @affiliate = Affiliate.new(@host, @token)
    end

    def affiliates
      @affiliate
    end

    private

    def get_token(user_id, key)
      header = {
          'alg' => 'HS256'
      }
      payload = {
          'sub' => user_id,
          'exp' => Time.now.to_i + 3600,
      }

      t1 = Base64.urlsafe_encode64(header.to_json.encode("UTF-8"))
      t2 = Base64.urlsafe_encode64(payload.to_json.encode("UTF-8"))

      signeddata = t1 + '.' + t2
      signature = OpenSSL::HMAC.digest('SHA256', key, signeddata)
      t3 = Base64.urlsafe_encode64(signature)

      token = signeddata + '.' + t3
      token
    end

  end
end