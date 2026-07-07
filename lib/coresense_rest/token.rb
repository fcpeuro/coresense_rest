# frozen_string_literal: true

require "openssl"
require "base64"
require "json"

module CoresenseRest
  # Mints CoreSense CREST auth tokens: HMAC-signed JWTs built from a
  # CoreSense-provided user id (the `sub` claim) and sign key. Mirrors the
  # reference PHP implementation:
  #
  #   header  = { "alg" => "HS256" }
  #   payload = { "sub" => user_id, "exp" => time + ttl }
  #   token   = b64url(header) + "." + b64url(payload) + "." + b64url(hmac)
  #
  # Pure stdlib (openssl/base64/json) — no external JWT dependency.
  module Token
    # Supported HMAC algorithms -> OpenSSL digest name. (CREST also documents
    # RS256/384/512; those need an RSA private key and are out of scope here.)
    HMAC_DIGESTS = {
      "HS256" => "SHA256",
      "HS384" => "SHA384",
      "HS512" => "SHA512"
    }.freeze

    module_function

    # Build a signed JWT.
    #
    #   user_id   - the CoreSense-provided user id (JWT `sub`)
    #   sign_key  - the CoreSense-provided sign key (HMAC secret)
    #   ttl       - seconds until expiry (CREST max 1 day; default 1 hour)
    #   algorithm - one of HMAC_DIGESTS keys (default "HS256")
    #   now       - current epoch seconds (injectable for testing)
    def generate(user_id:, sign_key:, ttl: 3600, algorithm: "HS256", now: Time.now.to_i)
      raise ArgumentError, "user_id is required"  if user_id.nil? || user_id.to_s.empty?
      raise ArgumentError, "sign_key is required" if sign_key.nil? || sign_key.to_s.empty?

      digest = HMAC_DIGESTS.fetch(algorithm.to_s) do
        raise ArgumentError, "unsupported algorithm #{algorithm.inspect} (supported: #{HMAC_DIGESTS.keys.join(', ')})"
      end

      header  = { alg: algorithm.to_s }
      payload = { sub: user_id, exp: now.to_i + ttl.to_i }

      signing_input = "#{encode(header)}.#{encode(payload)}"
      signature     = OpenSSL::HMAC.digest(digest, sign_key.to_s, signing_input)

      "#{signing_input}.#{encode_bytes(signature)}"
    end

    # Base64url-encode a Ruby object as compact JSON, no padding.
    def encode(object)
      encode_bytes(JSON.generate(object))
    end

    # Base64url-encode raw bytes, no padding.
    def encode_bytes(bytes)
      Base64.urlsafe_encode64(bytes, padding: false)
    end
  end
end
