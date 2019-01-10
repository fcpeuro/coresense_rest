module CoresenseRest
  class RequestWrite
    include HTTParty

    def initialize(root, headers, data)
      @headers = headers
      @root = root
      @data = data
    end


    def create
      response = HTTParty.post(@root, :body => data.to_json, :headers => @headers, format: :json)
      raise response.parsed_response.to_s unless response.code == 200
      JSON.parse(response.parsed_response)
    end

    def update
      response = HTTParty.put(@root, :body => data.to_json, :headers => @headers, format: :json)
      raise response.parsed_response.to_s unless response.code == 200
      JSON.parse(response.parsed_response)
    end

    def delete
      response = HTTParty.delete(@root, :body => data.to_json, :headers => @headers, format: :json)
      raise response.parsed_response.to_s unless response.code == 200
      JSON.parse(response.parsed_response)
    end

  end
end
