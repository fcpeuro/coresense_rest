#3rd Party Libs
require 'openssl'
require 'json'
require "base64"
require 'jwt'
require 'httparty'
require 'ostruct'
#Base Class
require_relative 'resources/Request_Read'
require_relative 'resources/Request_Write'
#Functional Modules
require_relative 'resources/Findable'
require_relative 'resources/Searchable'
require_relative 'resources/Creatable'
require_relative 'resources/Updatable'
require_relative 'resources/Deletable'
#Resource Definitions
require_relative 'resources/Resource'
require_relative 'resources/Resources'



module CoresenseRest
  class Client

    def self.host
      CoresenseRest::config.host
    end

    def self.user_id
      CoresenseRest::config.user_id
    end

    def self.key
      CoresenseRest::config.key
    end

    def self.get_token
      header = {
          'alg' => 'HS256'
      }
      payload = {
          'sub' => self.user_id,
          'exp' => Time.now.to_i + 3600,
      }

      t1 = Base64.urlsafe_encode64(header.to_json.encode("UTF-8"))
      t2 = Base64.urlsafe_encode64(payload.to_json.encode("UTF-8"))

      signeddata = t1 + '.' + t2
      signature = OpenSSL::HMAC.digest('SHA256', self.key, signeddata)
      t3 = Base64.urlsafe_encode64(signature)

      token = signeddata + '.' + t3
      token
    end

  end
end