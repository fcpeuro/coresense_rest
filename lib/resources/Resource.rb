class String
  def uncapitalize
    self[0, 1].downcase + self[1..-1]
  end
end

module CoresenseRest
  class Resource < OpenStruct
    class << self; attr_accessor :endpoint_override end

    def self.endpoint
      if endpoint_override.nil?
        name.match(/::(.+)/)[1].uncapitalize
      else
        endpoint_override
      end
    end

    def self.full_path
      Client.host + '/' + endpoint
    end

    def self.headers
      {"X-Auth-Token" => Client.get_token}
    end

    def self.parse_self json_string
      JSON.parse(json_string, object_class: self)
    end

    def []= name, value
      send("#{name}=",value)
    end

  end
end