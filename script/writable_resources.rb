#!/usr/bin/env ruby
# frozen_string_literal: true

# Read-only: list resources that support a full create -> delete round-trip,
# i.e. expose BOTH "POST /v1/<slug>" and "DELETE /v1/<slug>/{id}". These are the
# safe candidates for the write-path integration spec.
#
#   export CORESENSE_USER_ID='...' CORESENSE_SIGN_KEY='...'
#   bundle exec ruby script/writable_resources.rb

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "coresense_rest"
require "json"

abort "Set CORESENSE_USER_ID + CORESENSE_SIGN_KEY (or CORESENSE_TOKEN)" unless CoresenseRest.configuration.credentials?

resp = CoresenseRest::Base.connection.get("/v1/help/route", CoresenseRest::Base.headers)
routes = JSON.parse(resp.body.to_s)

# slug -> set of methods that have a collection (POST) or element (DELETE) route
post   = routes.select { |r| r.start_with?("POST /v1/") }
delete = routes.select { |r| r.start_with?("DELETE /v1/") }

slug_for = ->(name) { CoresenseRest.const_get(name).element_name if CoresenseRest.const_defined?(name) }

rows = CoresenseRest::RESOURCES.keys.filter_map do |class_name|
  slug = slug_for.call(class_name)
  next unless slug

  can_create = post.include?("POST /v1/#{slug}")
  can_delete = delete.any? { |r| r.start_with?("DELETE /v1/#{slug}/{") }
  can_read   = routes.include?("GET /v1/#{slug}")
  next unless can_create && can_delete

  [class_name, slug, can_read]
end

puts "Resources supporting a create -> delete round-trip (#{rows.size}):"
puts format("  %-26s %-26s %s", "ClassName", "slug", "inspectable (GET list)?")
rows.sort_by { |r| r[1] }.each do |class_name, slug, can_read|
  puts format("  %-26s %-26s %s", class_name, slug, can_read ? "yes" : "no")
end
puts
puts "Pick one (ideally 'inspectable: yes' so we can read its fields), then run:"
puts "  RESOURCE=<ClassName> bundle exec ruby script/inspect_resource.rb"
