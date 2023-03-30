# frozen_string_literal: true

# Configuration
require_relative 'resources/configuration'
require_relative 'coresense_client'

module CoresenseRest
  class Error < StandardError
  end

  class HttpError < Error
    attr_reader :response

    def initialize(msg, response = nil)
      @response = response
      super msg
    end
  end

  class JSONParseError < HttpError
    # Because some projects are using MultiJson which this project doesn't use.
    # MultiJson overrides the ruby's json but throws different exceptions.
    class Rescuable
      CLASSES = ['MultiJson::ParseError', 'JSON::GeneratorError'].freeze

      def self.===(exception)
        exception.class.ancestors.any? { |klass| CLASSES.include?(klass.name) }
      end
    end

    def self.from(exception, response)
      msg = if exception.message == /line 1, column 1/
        "line 1, column 1: #{response.body.to_s.slice(0..100)}"
      else
        exception.message
      end

      JSONParseError.new(msg, response)
    end

    def original_exception
      cause
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
