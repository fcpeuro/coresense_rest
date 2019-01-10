module CoresenseRest
  class Resource

    def self.full_path
      Client.host + '/' + name.match(/::(.+)/)[1].downcase
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