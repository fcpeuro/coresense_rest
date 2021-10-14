# frozen_string_literal: true

module CoresenseRest
  class Resource < OpenStruct
    class << self; attr_accessor :endpoint_override; end

    def self.endpoint
      return endpoint_override if endpoint_override

      name_to_endpoint(name)
    end

    def self.full_path
      Client.host + '/' + endpoint
    end

    def self.parse_self(json_string)
      JSON.parse(json_string, object_class: self)
    end

    def self.headers
      { 'X-Auth-Token' => Client.get_token }
    end

    def self.name_to_endpoint(name)
      str = name.split('::').last
      # Coresense does camelCase names for the REST objects. First letter is always lowercase
      str[0] = str[0].downcase
      str
    end

    def [](name)
      send(name.to_s)
    end

    def []=(name, value)
      send("#{name}=", value)
    end
  end
end
