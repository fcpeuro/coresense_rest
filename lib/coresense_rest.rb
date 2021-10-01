# frozen_string_literal: true

# Configuration
require_relative 'resources/configuration'
require_relative 'coresense_client'

module CoresenseRest
  class Error < StandardError
  end

  class HttpError < Error
    attr_reader :response

    def self.new(msg, response = nil)
      @response = response
      super msg
    end
  end

  class JSONParseError < HttpError
    attr_writer :original_exception

    def self.new(msg, original_exception=nil, response = nil)
      @response = response
      @json = json
      super msg
    end
  end

  class << self
    attr_accessor :configuration
  end

  def self.config
    @configuration ||= Configuration.new
  end

  def self.reset
    @configuration = Configuration.new
  end

  def self.configure
    yield(config)
  end
end
