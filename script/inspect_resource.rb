#!/usr/bin/env ruby
# frozen_string_literal: true

# Read-only: fetch one record of a resource and print its fields, to help build
# a valid create/update payload.
#
#   export CORESENSE_USER_ID='...' CORESENSE_SIGN_KEY='...'
#   RESOURCE=Comment bundle exec ruby script/inspect_resource.rb
#
# Optionally show the raw POST help if the API documents required fields:
#   RESOURCE=Comment ID=123 bundle exec ruby script/inspect_resource.rb   # fetch a specific id

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "coresense_rest"
require "json"

name = ENV["RESOURCE"] or abort "Set RESOURCE=<ClassName>, e.g. RESOURCE=Comment"
abort "Set CORESENSE_USER_ID + CORESENSE_SIGN_KEY (or CORESENSE_TOKEN)" unless CoresenseRest.configuration.credentials?

unless CoresenseRest.const_defined?(name)
  abort "Unknown resource #{name.inspect}. Known: #{CoresenseRest::RESOURCES.keys.join(', ')}"
end
klass = CoresenseRest.const_get(name)
slug  = klass.element_name

def get(path)
  resp = CoresenseRest::Base.connection.get(path, CoresenseRest::Base.headers)
  JSON.parse(resp.body.to_s)
rescue ActiveResource::ConnectionError => e
  code = e.respond_to?(:response) && e.response ? e.response.code : "?"
  body = e.respond_to?(:response) && e.response ? e.response.body.to_s : ""
  abort "  ! #{path} -> HTTP #{code} #{body}"
end

record =
  if ENV["ID"]
    get("/v1/#{slug}/#{ENV['ID']}")
  else
    list = get("/v1/#{slug}?page_size=1")
    list.is_a?(Array) ? list.first : list
  end

abort "No #{slug} record found to inspect." if record.nil?

puts "#{name}  (slug: #{slug})"
puts "Fields:"
record.sort_by { |k, _| k.to_s }.each do |key, value|
  preview = value.is_a?(String) && value.length > 50 ? "#{value[0, 50]}..." : value.inspect
  puts format("  %-36s %s", key, preview)
end
puts
puts "Use these field names to build CORESENSE_WRITE_PAYLOAD (id/stamp-style fields are"
puts "typically server-assigned and should be omitted from a create body)."
