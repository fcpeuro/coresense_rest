# frozen_string_literal: true

module CoresenseRest
  class RequestWrite
    include HTTParty

    def initialize(root, headers, request_class, data)
      @headers = headers
      @root = root
      @request_class = request_class
      @data = data
    end

    def create
      response = HTTParty.post(@root, body: @data.to_json, headers: @headers, format: :json, timeout: 120)
      raise "#{response.parsed_response} code: #{response.code} \n payload: #{@data.to_json}" unless response.code >= 200 && response.code < 300

      @request_class.find(response.parsed_response['id'])
      # RequestRead.new(response.parsed_response['uri'], @headers, @request_class).select
    end

    def update
      response = HTTParty.put(@root, body: @data.to_json, headers: @headers, format: :json)
      raise "#{response.parsed_response} code: #{response.code}" unless response.code == 200

      JSON.parse(response.parsed_response)
    end

    def delete
      response = HTTParty.delete(@root, body: @data.to_json, headers: @headers, format: :json)
      raise "#{response.parsed_response} code: #{response.code}" unless response.code == 200

      JSON.parse(response.parsed_response)
    end
  end
end
