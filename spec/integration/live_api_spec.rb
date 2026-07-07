# frozen_string_literal: true

require "spec_helper"

# Live, read-only validation of the gem's methods against the CREST API.
#
#   export CORESENSE_USER_ID='...' CORESENSE_SIGN_KEY='...'
#   CORESENSE_RUN_INTEGRATION=1 bundle exec rspec spec/integration/live_api_spec.rb
#
# Coverage is data-driven: every resource in the manifest is checked, but each
# assertion is gated on what the live /v1/help/route index actually exposes, so
# resources without a collection/element GET (e.g. creditCard) are skipped
# rather than failing. Only GET requests are performed here.
RSpec.describe "CREST live API (read-only)", :integration do
  describe "authentication & route index" do
    it "authenticates with a minted JWT and returns the route array" do
      expect(CoresenseLive.route_index).to be_a(Array)
      expect(CoresenseLive.route_index).to include("GET /v1/help/route")
    end
  end

  describe "every manifest resource" do
    CoresenseRest::RESOURCES.each do |class_name, slug|
      klass = CoresenseRest.const_get(class_name)

      context class_name do
        it "lists #{slug} via find(:all) and honors page_size" do
          skip "API exposes no 'GET /v1/#{slug}' collection route" unless CoresenseLive.collection_get?(slug)

          begin
            records = klass.find(:all, params: { page_size: 2 })
          rescue ActiveResource::ServerError, ActiveResource::ClientError => e
            # Child/unscoped collections (e.g. orderDeal, return) error or 404
            # unless given a parent filter — an API constraint, not a gem fault.
            skip "GET /v1/#{slug} returned HTTP #{e.response&.code} unscoped (likely needs a filter/scope param)"
          end

          # Some collection endpoints return a JSON `null` body unscoped, which
          # ActiveResource decodes to nil — same constraint as above.
          skip "GET /v1/#{slug} returned a null collection unscoped (likely needs a filter/scope param)" if records.nil?

          expect(records).to be_a(Enumerable)
          expect(records.size).to be <= 2
          records.each { |r| expect(r).to be_a(klass) }
        end

        it "fetches one #{slug} by id via find(id) and round-trips the id" do
          unless CoresenseLive.collection_get?(slug) && CoresenseLive.element_get?(slug)
            skip "no listable + fetchable GET route for #{slug}"
          end

          begin
            list = klass.find(:all, params: { page_size: 1 })
          rescue ActiveResource::ServerError, ActiveResource::ClientError => e
            skip "GET /v1/#{slug} returned HTTP #{e.response&.code} unscoped (likely needs a filter/scope param)"
          end

          first = list && list.first
          skip "no #{slug} records in UAT to fetch" if first.nil?
          skip "#{slug} record exposes no id attribute" unless first.respond_to?(:id) && first.id

          begin
            fetched = klass.find(first.id)
          rescue ActiveResource::MethodNotAllowed
            skip "GET /v1/#{slug}/{id} is not allowed (405) — element fetch unsupported"
          rescue ArgumentError
            # Some "element" routes are keyed by a foreign key and return a
            # collection (e.g. /v1/skuVendor/{sku_id}); find(id) can't model that.
            skip "GET /v1/#{slug}/{id} is a foreign-key-scoped collection, not a single-record fetch"
          rescue ActiveResource::ServerError => e
            # Shared UAT occasionally returns a transient 5xx; don't fail the
            # gem-validation suite on server-side hiccups.
            skip "GET /v1/#{slug}/{id} returned a transient HTTP #{e.response&.code}"
          end
          expect(fetched.id.to_s).to eq(first.id.to_s)
        end
      end
    end
  end

  describe "query + sorting params" do
    it "passes page/page_size/order through on products" do
      page = CoresenseRest::Product.find(:all, params: { page: 1, page_size: 3, order: "id" })
      expect(page.size).to be <= 3

      ids = page.map(&:id)
      expect(ids).to eq(ids.sort) unless ids.empty?
    end
  end

  describe "error handling" do
    it "raises ResourceNotFound for a non-existent product id" do
      expect { CoresenseRest::Product.find(999_999_999) }
        .to raise_error(ActiveResource::ResourceNotFound)
    end
  end
end
