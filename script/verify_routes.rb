#!/usr/bin/env ruby
# frozen_string_literal: true

# Read-only verification of the resource manifest against the live CREST API.
#
# Run it yourself so your credentials never leave your machine:
#
#   export CORESENSE_USER_ID='<your user id>'
#   export CORESENSE_SIGN_KEY='<your sign key>'
#   # optional: export CORESENSE_SITE='https://api-fcpuat.coresense.com'
#   bundle exec ruby script/verify_routes.rb
#
# It performs only GET requests:
#   GET /v1/help/route         (the route index)
#   GET /v1/product?page_size=1 (one record, to inspect the collection envelope)
#
# Output: the discovered route slugs, any mismatches with RESOURCES, and a
# sample collection response shape. Paste the summary back to reconcile slugs.

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "coresense_rest"
require "json"

unless CoresenseRest.configuration.credentials?
  abort "Set CORESENSE_USER_ID and CORESENSE_SIGN_KEY (or CORESENSE_TOKEN) first."
end

def get(path)
  # NB: pass Base.headers explicitly — the low-level connection does not attach
  # the class headers (and therefore the auth token) on its own; only the model
  # methods (find/save) do. Without this the request goes out unauthenticated.
  #
  # connection.get returns the raw Net::HTTP response, so read & parse .body.
  response = CoresenseRest::Base.connection.get(path, CoresenseRest::Base.headers)
  body = response.body.to_s
  parsed = body.empty? ? nil : (JSON.parse(body) rescue body)
  { status: response.code, parsed: parsed, raw: body }
rescue ActiveResource::ConnectionError => e
  code = e.respond_to?(:response) && e.response ? e.response.code : "?"
  warn "  ! #{path} -> #{e.message} (HTTP #{code})"
  nil
end

def show(result, max_lines:)
  return unless result

  puts "HTTP #{result[:status]}"
  parsed = result[:parsed]
  if parsed.nil?
    puts "(empty body)"
  elsif parsed.is_a?(String)
    puts "(non-JSON body)"
    puts result[:raw].lines.first(max_lines).join
  else
    puts "Top-level type: #{parsed.class}"
    puts "Top-level keys: #{parsed.keys.inspect}" if parsed.respond_to?(:keys)
    pretty = JSON.pretty_generate(parsed)
    puts pretty.lines.first(max_lines).join
    puts "...(truncated, #{pretty.lines.size} lines total)" if pretty.lines.size > max_lines
  end
end

puts "Site: #{CoresenseRest::Base.site}#{CoresenseRest::Base.prefix}"
puts "Auth: minted JWT (sub from user_id), sent as X-Auth-Token + Bearer"
puts

routes = get("/v1/help/route")
puts "== GET /v1/help/route =="
show(routes, max_lines: 8)
puts

puts "== Sample collection: GET /v1/product?page_size=1 =="
sample = get("/v1/product?page_size=1")
puts "Collection top-level type: #{sample && sample[:parsed].class} " \
     "(#{sample && sample[:parsed].is_a?(Array) ? 'bare array — no envelope' : 'ENVELOPED — needs custom parser'})"
puts

# --- Reconcile the manifest against the live routes -------------------------
if routes && routes[:parsed].is_a?(Array)
  # Each line looks like "METHOD /v1/<slug>/{id}/...". Grab the first path
  # segment after the version prefix: that is the top-level resource slug.
  slugs = routes[:parsed].filter_map do |line|
    m = line.match(%r!\A[A-Z]+\s+/[^/]+/([^/{?\s]+)!)
    m && m[1]
  end.reject { |s| s == "help" }.uniq.sort

  manifest = CoresenseRest::RESOURCES.values.sort

  puts "== Authoritative top-level resource slugs (#{slugs.size}) =="
  puts slugs.join("\n")
  puts
  missing = manifest - slugs
  extra   = slugs - manifest
  puts "In manifest but NOT in API (#{missing.size}): #{missing.join(', ')}"
  puts
  puts "In API but NOT in manifest (#{extra.size}): #{extra.join(', ')}"
else
  puts "Could not parse the route index as an array; cannot reconcile."
end
