# frozen_string_literal: true

module CoresenseRest
  # Holds connection settings for the CoreSense CREST API.
  #
  # Values fall back to environment variables so the gem can be configured
  # without code in deploy/CI contexts:
  #
  #   CORESENSE_SITE           (default: https://api-fcpuat.coresense.com)
  #   CORESENSE_API_VERSION    (default: v1)
  #   CORESENSE_USER_ID        (JWT `sub` claim)
  #   CORESENSE_SIGN_KEY       (HMAC secret used to sign the JWT)
  #   CORESENSE_TOKEN_TTL      (token lifetime in seconds, default 3600)
  #   CORESENSE_JWT_ALGORITHM  (default HS256)
  #   CORESENSE_TOKEN          (optional: a pre-built JWT, overrides user_id/sign_key)
  #
  # Auth: supply +user_id+ and +sign_key+ and the gem mints a fresh, short-lived
  # JWT for every request. Alternatively set a pre-built +token+ directly.
  class Configuration
    DEFAULT_SITE          = "https://api-fcpuat.coresense.com"
    DEFAULT_API_VERSION   = "v1"
    DEFAULT_TOKEN_TTL     = 3600   # 1 hour (CREST allows up to 1 day)
    DEFAULT_JWT_ALGORITHM = "HS256"

    attr_accessor :site, :api_version, :user_id, :sign_key, :token,
                  :token_ttl, :jwt_algorithm, :timeout, :open_timeout,
                  :proxy, :logger

    def initialize
      @site          = ENV.fetch("CORESENSE_SITE", DEFAULT_SITE)
      @api_version   = ENV.fetch("CORESENSE_API_VERSION", DEFAULT_API_VERSION)
      @user_id       = ENV["CORESENSE_USER_ID"]
      @sign_key      = ENV["CORESENSE_SIGN_KEY"]
      @token         = ENV["CORESENSE_TOKEN"]
      @token_ttl     = Integer(ENV.fetch("CORESENSE_TOKEN_TTL", DEFAULT_TOKEN_TTL))
      @jwt_algorithm = ENV.fetch("CORESENSE_JWT_ALGORITHM", DEFAULT_JWT_ALGORITHM)
      @timeout       = nil
      @open_timeout  = nil
      @proxy         = nil
      @logger        = nil
    end

    # The ActiveResource +prefix+ for every request, e.g. "/v1/".
    def prefix
      "/#{api_version.to_s.delete_prefix("/").delete_suffix("/")}/"
    end

    # True when enough is configured to authenticate.
    def credentials?
      present?(token) || (present?(user_id) && present?(sign_key))
    end

    private

    def present?(value)
      !value.nil? && !value.to_s.empty?
    end
  end
end
