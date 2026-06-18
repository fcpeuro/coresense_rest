# frozen_string_literal: true

require "spec_helper"

RSpec.describe CoresenseRest do
  it "has a version" do
    expect(CoresenseRest::VERSION).to match(/\d+\.\d+\.\d+/)
  end

  describe "configuration" do
    it "applies the site and prefix to Base" do
      expect(CoresenseRest::Base.site.to_s).to eq("https://api-fcpuat.coresense.com")
      expect(CoresenseRest::Base.prefix).to eq("/v1/")
    end

    it "sets JWT auth headers from the token" do
      expect(CoresenseRest::Base.headers["X-Auth-Token"]).to eq("test-jwt-token")
      expect(CoresenseRest::Base.headers["Authorization"]).to eq("Bearer test-jwt-token")
    end

    it "honors a custom api_version in the prefix" do
      CoresenseRest.configure { |c| c.api_version = "v2" }
      expect(CoresenseRest::Base.prefix).to eq("/v2/")
    end

    it "falls back to CORESENSE_TOKEN from the environment" do
      CoresenseRest.reset_configuration!
      allow(ENV).to receive(:[]).and_call_original
      allow(ENV).to receive(:[]).with("CORESENSE_TOKEN").and_return("env-token")
      CoresenseRest.reset_configuration!
      expect(CoresenseRest::Base.headers["X-Auth-Token"]).to eq("env-token")
    end

    it "mints a JWT from user_id + sign_key when no pre-built token is set" do
      CoresenseRest.reset_configuration!
      CoresenseRest.configure do |c|
        c.user_id  = "user-9"
        c.sign_key = "k"
      end

      token = CoresenseRest::Base.headers["Authorization"].sub(/\ABearer /, "")
      seg = token.split(".")[1]
      payload = JSON.parse(Base64.urlsafe_decode64(seg + "=" * ((4 - seg.length % 4) % 4)))
      expect(payload["sub"]).to eq("user-9")
      expect(payload["exp"]).to be > Time.now.to_i
      expect(CoresenseRest::Base.headers["X-Auth-Token"]).to eq(token)
    end

    it "omits auth headers entirely when no credentials are configured" do
      CoresenseRest.reset_configuration!
      expect(CoresenseRest::Base.headers).not_to have_key("X-Auth-Token")
      expect(CoresenseRest::Base.headers).not_to have_key("Authorization")
    end
  end

  describe "path generation" do
    it "uses singular, extension-less collection paths" do
      expect(CoresenseRest::Product.collection_path).to eq("/v1/product")
    end

    it "uses singular, extension-less element paths" do
      expect(CoresenseRest::Product.element_path(123)).to eq("/v1/product/123")
    end

    it "maps multi-word resources via the live camelCase slug" do
      expect(CoresenseRest::OrderItem.element_name).to eq("orderItem")
      expect(CoresenseRest::OrderItem.collection_path).to eq("/v1/orderItem")
      expect(CoresenseRest::OrderItem.element_path(7)).to eq("/v1/orderItem/7")
    end

    it "preserves irregular (snake_case / PascalCase) slugs verbatim" do
      expect(CoresenseRest::ReorderPoint.collection_path).to eq("/v1/reorder_point")
      expect(CoresenseRest::LocationHierarchies.collection_path).to eq("/v1/location_hierarchies")
      expect(CoresenseRest::ShippingReturn.collection_path).to eq("/v1/ShippingReturn")
    end

    it "passes query options through the path builder" do
      path = CoresenseRest::Product.collection_path({}, page: 2, page_size: 50)
      expect(path).to eq("/v1/product?page=2&page_size=50")
    end
  end

  describe "request body encoding" do
    it "excludes server-owned id and uri from the encoded body" do
      product = CoresenseRest::Product.new(
        { "id" => 5, "uri" => "/v1/product/5", "name" => "Pad", "base_price" => 9.99 }, true
      )
      body = JSON.parse(product.encode)
      expect(body).to eq("name" => "Pad", "base_price" => 9.99)
      expect(body).not_to have_key("id")
      expect(body).not_to have_key("uri")
    end

    it "still honors a caller-supplied :except" do
      product = CoresenseRest::Product.new({ "name" => "Pad", "sku" => "X" }, true)
      body = JSON.parse(product.encode(except: ["sku"]))
      expect(body).to eq("name" => "Pad")
    end
  end

  describe "resource registry" do
    it "defines a constant for every manifest entry" do
      expect(CoresenseRest::RESOURCES.size).to eq(73)
      CoresenseRest::RESOURCES.each_key do |name|
        expect(CoresenseRest.const_get(name)).to be < CoresenseRest::Base
      end
    end
  end

  describe "requests", :request do
    it "GETs a single resource and sends the auth header" do
      stub = stub_request(:get, "https://api-fcpuat.coresense.com/v1/product/123")
             .with(headers: { "X-Auth-Token" => "test-jwt-token" })
             .to_return(
               status: 200,
               headers: { "Content-Type" => "application/json" },
               body: { id: 123, name: "Brake Pad Set" }.to_json
             )

      product = CoresenseRest::Product.find(123)

      expect(stub).to have_been_requested
      expect(product.id).to eq(123)
      expect(product.name).to eq("Brake Pad Set")
    end

    it "GETs a collection with pagination params" do
      stub = stub_request(:get, "https://api-fcpuat.coresense.com/v1/product")
             .with(query: { page: "1", page_size: "2" })
             .to_return(
               status: 200,
               headers: { "Content-Type" => "application/json" },
               body: [{ id: 1 }, { id: 2 }].to_json
             )

      products = CoresenseRest::Product.find(:all, params: { page: 1, page_size: 2 })

      expect(stub).to have_been_requested
      expect(products.map(&:id)).to eq([1, 2])
    end

    it "POSTs to the singular collection path on create" do
      stub = stub_request(:post, "https://api-fcpuat.coresense.com/v1/product")
             .to_return(
               status: 201,
               headers: { "Content-Type" => "application/json", "Location" => "/v1/product/9" },
               body: { id: 9 }.to_json
             )

      product = CoresenseRest::Product.create(name: "New Part")

      expect(stub).to have_been_requested
      expect(product.id).to eq(9)
    end
  end
end
