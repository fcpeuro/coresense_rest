# frozen_string_literal: true

require "json"

# Helpers for integration specs: query the live /v1/help/route index to decide
# which resources actually expose collection / element GET routes, so we only
# assert against endpoints the API really serves. Fetched once per process.
module CoresenseLive
  module_function

  def route_index
    @route_index ||= begin
      response = CoresenseRest::Base.connection.get("/v1/help/route", CoresenseRest::Base.headers)
      JSON.parse(response.body.to_s)
    end
  end

  # True if the API serves "GET /v1/<slug>" (a listable collection).
  def collection_get?(slug)
    route_index.include?("GET /v1/#{slug}")
  end

  # True if the API serves "GET /v1/<slug>/{...}" (fetch one by id).
  def element_get?(slug)
    route_index.any? { |route| route.start_with?("GET /v1/#{slug}/{") }
  end

  # True if the API serves "POST /v1/<slug>" (create).
  def collection_post?(slug)
    route_index.include?("POST /v1/#{slug}")
  end

  # True if the API serves "DELETE /v1/<slug>/{...}" (delete by id).
  def element_delete?(slug)
    route_index.any? { |route| route.start_with?("DELETE /v1/#{slug}/{") }
  end
end
