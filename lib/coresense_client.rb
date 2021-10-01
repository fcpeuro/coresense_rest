# frozen_string_literal: true

# 3rd Party Libs
require 'openssl'
require 'json'
require 'base64'
require 'jwt'
require 'httparty'
require 'ostruct'
# Base Class
require_relative 'resources/request_read'
require_relative 'resources/request_write'
# Functional Modules
require_relative 'resources/findable'
require_relative 'resources/searchable'
require_relative 'resources/creatable'
require_relative 'resources/updatable'
require_relative 'resources/deletable'
# Resource Definitions
require_relative 'resources/resource'
require_relative 'resources/resources'

module CoresenseRest
  class Client
    def self.host
      CoresenseRest.config.host
    end

    def self.user_id
      CoresenseRest.config.user_id
    end

    def self.key
      CoresenseRest.config.key
    end

    def self.get_token
      header = {
        'alg' => 'HS256'
      }
      payload = {
        'sub' => user_id,
        'exp' => Time.now.to_i + 3600
      }

      t1 = Base64.urlsafe_encode64(header.to_json.encode('UTF-8'))
      t2 = Base64.urlsafe_encode64(payload.to_json.encode('UTF-8'))

      signeddata = t1 + '.' + t2
      signature = OpenSSL::HMAC.digest('SHA256', key, signeddata)
      t3 = Base64.urlsafe_encode64(signature)

      token = signeddata + '.' + t3
      token
    end
  end
end
