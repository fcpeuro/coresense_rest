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
      response = HTTParty.post(@root, body: @data.to_json, headers: @headers, format: :json, timeout: 240)
      raise response_error(response) unless response.code >= 200 && response.code < 300
      raise HttpError.new('No id returned, object creation failed', response) if response.parsed_response['id'].nil?

      @request_class.find(response.parsed_response['id'])
    end

    def update
      response = HTTParty.put(@root, body: @data.to_json, headers: @headers, format: :json)
      raise response_error(response) unless response.code == 200

      JSON.parse(response.parsed_response)
    rescue JSON::UnparserError => e
      raise JSONParseError.new(e.message, e, response)
    end

    def delete
      response = HTTParty.delete(@root, body: @data.to_json, headers: @headers, format: :json)
      raise response_error(response) unless response.code == 200

      JSON.parse(response.parsed_response)
    rescue JSON::UnparserError => e
      raise JSONParseError.new(e.message, e, response)
    end

    private

    def response_error(response)
      msg = "#{response.parsed_response} code: #{response.code}"
      HttpError.new(msg, response)
    end
  end
end
