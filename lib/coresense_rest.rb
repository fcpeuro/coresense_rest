# frozen_string_literal: true

require_relative "coresense_rest/version"
require_relative "coresense_rest/configuration"
require_relative "coresense_rest/token"
require_relative "coresense_rest/base"
require_relative "coresense_rest/resources"

# Ruby client for the CoreSense CREST API built on ActiveResource.
#
#   CoresenseRest.configure do |c|
#     c.token = ENV["CORESENSE_TOKEN"]   # or set CORESENSE_TOKEN in the env
#   end
#
#   CoresenseRest::Product.find(:all, params: { page: 1, page_size: 50 })
#   CoresenseRest::Product.find(123)
module CoresenseRest
  class << self
    # The current Configuration, memoized.
    def configuration
      @configuration ||= Configuration.new
    end

    # Yields the configuration for editing, then pushes it onto the resource
    # classes. Returns the configuration.
    #
    #   CoresenseRest.configure do |c|
    #     c.site  = "https://api-fcpuat.coresense.com"
    #     c.token = "<jwt>"
    #   end
    def configure
      yield(configuration) if block_given?
      apply_configuration!
      configuration
    end

    # Resets configuration to defaults (useful in tests).
    def reset_configuration!
      @configuration = Configuration.new
      @token_cache   = nil
      apply_configuration!
    end

    # Applies the current configuration to CoresenseRest::Base. Because every
    # resource is a subclass of Base, they all inherit these settings.
    #
    # Auth headers are NOT set here — they are computed per request by
    # CoresenseRest::Base.headers via #access_token so tokens never expire.
    def apply_configuration!
      @token_cache      = nil
      Base.site         = configuration.site
      Base.prefix       = configuration.prefix
      Base.proxy        = configuration.proxy        if configuration.proxy
      Base.timeout      = configuration.timeout      if configuration.timeout
      Base.open_timeout = configuration.open_timeout if configuration.open_timeout
      Base.logger       = configuration.logger       if configuration.logger
      Base
    end

    # The current auth token, or nil if no credentials are configured.
    #
    # If a pre-built +token+ is configured it is returned as-is. Otherwise a JWT
    # is minted from +user_id+/+sign_key+ and cached until shortly before it
    # expires, then transparently regenerated.
    def access_token
      c = configuration
      return c.token if c.token && !c.token.to_s.empty?
      return nil unless c.user_id && c.sign_key && !c.user_id.to_s.empty? && !c.sign_key.to_s.empty?

      now = Time.now.to_i
      cache_key = [c.user_id, c.sign_key, c.jwt_algorithm, c.token_ttl]
      if @token_cache && @token_cache[:key] == cache_key && @token_cache[:exp] > now + 30
        return @token_cache[:token]
      end

      token = Token.generate(
        user_id: c.user_id, sign_key: c.sign_key,
        ttl: c.token_ttl, algorithm: c.jwt_algorithm, now: now
      )
      @token_cache = { token: token, exp: now + c.token_ttl, key: cache_key }
      token
    end
  end
end

# Apply environment-based defaults at load time so the gem is usable without an
# explicit configure block when CORESENSE_* env vars are present.
CoresenseRest.apply_configuration!
