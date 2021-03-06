# frozen_string_literal: true

# Configuration
require_relative 'resources/configuration'
require_relative 'coresense_client'

module CoresenseRest
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

require_relative 'coresense_client'
