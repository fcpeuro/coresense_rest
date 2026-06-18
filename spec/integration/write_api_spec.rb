# frozen_string_literal: true

require "spec_helper"
require "json"

# Live WRITE validation: create -> (optional) update -> delete round-trip.
#
# This MUTATES the UAT environment, so it requires a second opt-in on top of the
# integration flag, AND you must name a resource + payload you know is safe to
# create in UAT (the gem can't know each resource's required fields):
#
#   export CORESENSE_USER_ID='...' CORESENSE_SIGN_KEY='...'
#   export CORESENSE_WRITE_RESOURCE='Comment'
#   export CORESENSE_WRITE_PAYLOAD='{"...":"..."}'      # valid create body
#   export CORESENSE_WRITE_UPDATE='{"...":"..."}'       # optional: fields to PUT
#   CORESENSE_RUN_INTEGRATION=1 CORESENSE_RUN_WRITE=1 \
#     bundle exec rspec spec/integration/write_api_spec.rb
#
# The created record is ALWAYS deleted in an ensure block, even if an assertion
# fails, so a failed run does not leave junk behind.
RSpec.describe "CREST live API (write path)", :integration, :write do
  # Validated default: Category is self-contained (no required foreign keys) and
  # supports POST + DELETE, so it round-trips cleanly. Override any of these via
  # CORESENSE_WRITE_RESOURCE / _PAYLOAD / _UPDATE to target another resource.
  DEFAULT_WRITE = {
    "resource" => "Category",
    "create"   => { "category" => "CREST gem smoke test", "active" => true },
    "update"   => { "category" => "CREST gem smoke test (updated)" }
  }.freeze

  let(:custom_resource?) { !(ENV["CORESENSE_WRITE_RESOURCE"].nil? || ENV["CORESENSE_WRITE_RESOURCE"].empty?) }
  let(:resource_name) { custom_resource? ? ENV["CORESENSE_WRITE_RESOURCE"] : DEFAULT_WRITE["resource"] }

  # Defaults apply only when targeting the default resource; a custom resource
  # must bring its own payload (else the run skips).
  let(:create_payload) { parse_json(ENV["CORESENSE_WRITE_PAYLOAD"]) || (custom_resource? ? nil : DEFAULT_WRITE["create"]) }
  let(:update_payload) { parse_json(ENV["CORESENSE_WRITE_UPDATE"]) || (custom_resource? ? nil : DEFAULT_WRITE["update"]) }

  def parse_json(raw)
    raw && !raw.empty? ? JSON.parse(raw) : nil
  end

  # ActiveResource's 4xx exceptions hide the response body; surface it so the
  # API's own validation message is visible.
  def with_api_error(action)
    yield
  rescue ActiveResource::ConnectionError => e
    code = e.respond_to?(:response) && e.response ? e.response.code : "?"
    body = e.respond_to?(:response) && e.response ? e.response.body.to_s : ""
    raise "#{action} failed: HTTP #{code} -> #{body}"
  end

  before do
    if create_payload.nil?
      skip "custom CORESENSE_WRITE_RESOURCE=#{resource_name} requires CORESENSE_WRITE_PAYLOAD (JSON)"
    end

    unless CoresenseRest.const_defined?(resource_name)
      skip "unknown resource #{resource_name.inspect}"
    end

    slug = CoresenseRest.const_get(resource_name).element_name

    # Safety: never create a record the API can't delete — that would leave junk
    # in UAT with no way to clean it up.
    unless CoresenseLive.collection_post?(slug)
      skip "API exposes no 'POST /v1/#{slug}' (create) route"
    end
    unless CoresenseLive.element_delete?(slug)
      skip "API exposes no 'DELETE /v1/#{slug}/{id}' route — refusing to create a record " \
           "that cannot be cleaned up"
    end
  end

  it "creates, optionally updates, then deletes a record" do
    klass  = CoresenseRest.const_get(resource_name)
    record = nil

    begin
      # CREATE -> POST /v1/<slug>
      record = with_api_error("create #{resource_name}") { klass.create(create_payload) }
      expect(record.persisted?).to(be(true),
        -> { "create rejected: #{record.errors.full_messages.join('; ')}" })
      expect(record.id).not_to be_nil
      warn "created #{resource_name} id=#{record.id}"

      # UPDATE -> PUT /v1/<slug>/{id}  (only if fields were supplied)
      # The natural ActiveResource pattern: mutate the record and save. The gem
      # strips server-owned fields (id/uri) from the body, so CREST accepts it.
      if update_payload
        update_payload.each { |attr, value| record.public_send("#{attr}=", value) }
        with_api_error("update #{resource_name}") do
          expect(record.save).to(be(true),
            -> { "update rejected: #{record.errors.full_messages.join('; ')}" })
        end

        reloaded = klass.find(record.id)
        update_payload.each do |attr, value|
          expect(reloaded.public_send(attr).to_s).to eq(value.to_s)
        end
      end
    ensure
      # DELETE -> always attempt cleanup
      if record&.id
        begin
          klass.delete(record.id)
        rescue StandardError => e
          warn "CLEANUP FAILED: could not delete #{resource_name} #{record.id}: #{e.message}"
        end
      end
    end

    # Confirm the delete took effect.
    expect { klass.find(record.id) }.to raise_error(ActiveResource::ResourceNotFound)
  end
end
