# frozen_string_literal: true

require "active_resource"

module CoresenseRest
  # Base class for every CoreSense CREST resource.
  #
  # The CREST API differs from ActiveResource's defaults in two ways that this
  # class normalizes:
  #
  #   1. Collection paths are *singular*  -> GET /v1/product, GET /v1/product/:id
  #      (ActiveResource would otherwise pluralize to /v1/products).
  #   2. Paths carry no format extension  -> /v1/product (not /v1/product.json).
  #
  # Site, prefix and auth headers are inherited from this class by every
  # resource subclass and are populated by CoresenseRest.apply_configuration!.
  class Base < ActiveResource::Base
    self.format               = :json
    self.include_root_in_json = false

    # Attributes the CREST API owns/assigns and rejects in request bodies:
    #   * "id"  -> supplied in the path; PUT body returns code 1003 ("may not be written to")
    #   * "uri" -> returned by create responses; PUT body returns code 1016 ("invalid field")
    # Excluded from every encoded POST/PUT body so normal save/update works.
    NON_WRITABLE_ATTRIBUTES = %w[id uri].freeze

    # Strip server-owned attributes from the request body. Path building still
    # uses #id (a method), so element paths are unaffected.
    def encode(options = {})
      except = Array(options[:except]).map(&:to_s) | NON_WRITABLE_ATTRIBUTES
      super(options.merge(except: except))
    end

    # Drop the ".json" suffix from generated paths when the option exists
    # (rails/activeresource >= 6.0). Guarded so older versions still load.
    self.include_format_in_path = false if respond_to?(:include_format_in_path=)

    class << self
      # CREST uses the singular resource name in collection paths.
      def collection_name
        element_name
      end

      # Belt-and-suspenders for activeresource versions that build paths with a
      # private #format_extension helper rather than #include_format_in_path.
      def format_extension
        ""
      end

      # Inject a freshly-minted (unexpired) JWT into the headers ActiveResource
      # sends on every request. Computed per-call so a long-lived process never
      # sends an expired token. Returns the inherited headers untouched when no
      # credentials are configured.
      def headers
        base = super
        token = CoresenseRest.access_token
        return base unless token

        base.merge("X-Auth-Token" => token, "Authorization" => "Bearer #{token}")
      end
    end
  end
end
