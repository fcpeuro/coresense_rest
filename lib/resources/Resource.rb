module CoresenseRest
  class Resource

    def initialize(host, token)
      @host = host
      @headers = {"X-Auth-Token" => token}
    end

    def full_path
      @host + '/' + self.class.name
    end

  end
end