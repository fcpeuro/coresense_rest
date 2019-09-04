require 'spec_helper'
require 'byebug'

module CoresenseRest

  shared_examples "a Resource" do |endpoint|
    it 'Hits the Correct Endpoint' do
      expect(described_class.full_path).to eq("#{CoresenseRest::Client.host}/#{endpoint}")
    end
  end

  shared_examples "a Findable class" do |input, output|
    it ".find" do
      VCR.use_cassette("#{described_class.name.split('::').last}/find_#{input}") do
        klass_instance = described_class.find(input)
        expect(klass_instance).to be_an_instance_of(described_class)
        expect(klass_instance.id).to eq(output)
      end
    end
  end

  shared_examples "a Searchable class" do |input, output|

    it '.select (all)' do
      VCR.use_cassette("#{described_class.name.split('::').last}/select_all") do
        expect(described_class.select).to be_an_instance_of(Array)
        expect(described_class.select[0]).to be_an_instance_of(described_class)
      end
    end

    case described_class.name
    when Customer.name
      it ".select (client_id=#{input})" do
        VCR.use_cassette("#{described_class.name.split('::').last}/select_client_id=#{input}") do
          expect(described_class.where({'client_id' => input}).select[0].id).to eq(output)
          expect(described_class.where({:client_id => input}).select[0].id).to eq(output)
          expect(described_class.where("client_id= #{input} ").select[0].id).to eq(output)
        end
      end
    when Order.name
      it ".select (order_num=#{input})" do
        VCR.use_cassette("#{described_class.name.split('::').last}/select_order_num=#{input}") do
          expect(described_class.where({'order_num' => input}).select[0].id).to eq(output)
          expect(described_class.where({:order_num => input}).select[0].id).to eq(output)
          expect(described_class.where("order_num= #{input} ").select[0].id).to eq(output)
        end
      end
    when SkuInventory.name
      it ".select (sku_id=#{input})" do
        VCR.use_cassette("#{described_class.name.split('::').last}/select_sku_id=#{input}") do
          expect(described_class.where({'sku_id' => input}).select[0].sku_id).to eq(output)
          expect(described_class.where({:sku_id => input}).select[0].sku_id).to eq(output)
          expect(described_class.where("sku_id= #{input} ").select[0].sku_id).to eq(output)
        end
      end
    else
      it ".select (id=#{input})" do
        VCR.use_cassette("#{described_class.name.split('::').last}/select_id=#{input}") do
          expect(described_class.where({'id' => input}).select[0].id).to eq(output)
          expect(described_class.where({:id => input}).select[0].id).to eq(output)
          expect(described_class.where("id= #{input} ").select[0].id).to eq(output)
        end
      end
    end
  end

  shared_examples "a Creatable class" do |creation_hash|
    it ".create" do
      VCR.use_cassette("#{described_class.name.split('::').last}/create") do
        expect(described_class.create(creation_hash)).to be_an_instance_of(described_class)
      end
    end
  end

  describe 'CREST API' do

    before(:all) do
      creds = YAML.load(File.read("#{__dir__}/../../../credentials.yml"))
      CoresenseRest.configure do |config|
        config.host = creds['endpoint']
        config.user_id = creds['user_id']
        config.key = creds['key']
      end
    end

    context 'Request' do
      let(:request){RequestRead.new("#{CoresenseRest::Client.host}/resource", {}, Resource)}

      it "Creates requests correctly" do
        expect(request.current_path).to   eq("#{CoresenseRest::Client.host}/resource")
        expect(request.order('field').current_path).to   eq("#{CoresenseRest::Client.host}/resource?&order=field")
        expect(request.where("field1=15").current_path).to   eq("#{CoresenseRest::Client.host}/resource?&q[]=field1=15")
        expect(request.where('field1=15 AND field2=5').current_path).to   eq("#{CoresenseRest::Client.host}/resource?&q[]=field1=15&q[]=field2=5")
        expect(request.where({'field1'=>15, 'field2'=>5}).current_path).to   eq("#{CoresenseRest::Client.host}/resource?&q[]=field1=15&q[]=field2=5")
      end
    end

    describe "Resources:" do

      context Affiliate do

        it_should_behave_like "a Resource", "affiliate"

        it_should_behave_like "a Findable class", 1, 1

        it_should_behave_like "a Searchable class", 1, 1

      end

      context Barcode do

        it_should_behave_like "a Resource", "barcode"

        it_should_behave_like "a Findable class", 1, 1

        it_should_behave_like "a Searchable class", 1, 1

      end

      context BarcodeSKU do

        it_should_behave_like "a Resource", "barcodeSku"

        it_should_behave_like "a Findable class", 1, 1

        it_should_behave_like "a Searchable class", 1, 1

      end

      context Brand do

        it_should_behave_like "a Resource", "brand"

        it_should_behave_like "a Findable class", 1, 1

        it_should_behave_like "a Searchable class", 1, 1

      end

      context Category do

        it_should_behave_like "a Resource", "category"

        it_should_behave_like "a Findable class", 1, 1

        it_should_behave_like "a Searchable class", 1, 1


        xit 'Can create a new categoy' do
          fail
        end

        xit 'Can update a new categoy' do
          fail
        end

        xit 'Can delete a new categoy' do
          fail
        end

        xit 'Can fetch all categoy products' do
          fail
        end

        xit 'Can fetch all featured categoy products' do
          fail
        end

        xit 'Can fetch all categoy subcategories' do
          fail
        end
      end

      context Channel do

        it_should_behave_like "a Resource", "channel"

        it_should_behave_like "a Findable class", 1, 1

        it_should_behave_like "a Searchable class", 1, 1

        xit 'Retrieve all products in a channel' do
          fail
        end

        xit 'Retrieve all shipments in a channel' do
          fail
        end
      end

      context Contact do

        it_should_behave_like "a Resource", "contact"

        it_should_behave_like "a Findable class", 1, 1

        it_should_behave_like "a Searchable class", 1, 1

        it_should_behave_like "a Creatable class", {
            :last_name => 'test', :first_name => 'testy', :customer_id => 1
        }
      end

      context Country do

        it_should_behave_like "a Resource", "country"

        it_should_behave_like "a Findable class", 1, 1

        it_should_behave_like "a Searchable class", 1, 1

      end

      context Customer do

        it_should_behave_like "a Resource", "customer"

        it_should_behave_like "a Findable class", 1, 1.to_s

        it_should_behave_like "a Searchable class", 1, 1.to_s

        it_should_behave_like "a Creatable class", {
            :default_billing_contact => {:last_name => 'test', :first_name => 'testy', :email => "account@email.com"},
            :default_shipping_contact => {:last_name => 'test', :first_name => 'testy', :email => "account@email.com"}
        }

        it 'Can list all customer contacts' do
          cust = Customer.find(1)
          contacts = cust.contacts
          expect(contacts).to be_an_instance_of(Array)
          expect(contacts[0]).to be_an_instance_of(Contact)
        end
      end

      context 'Help' do

        xit 'Hits the Correct Endpoint' do
          expect(Affiliate.full_path).to   eq("#{CoresenseRest::Client.host}/help")
        end

        xit 'Retrieves all error codes.' do
          fail
        end

        xit 'Pings the API to verify status. Can to used to check authentication credentials.' do
          fail
        end

        xit 'Retrieves all currently available API routes.' do
          fail
        end
      end

      context Inventory do

        it_should_behave_like "a Resource", "inventory"

        it_should_behave_like "a Findable class", 2, 2

        it_should_behave_like "a Searchable class", 2, 2

      end

      context Location do

        it_should_behave_like "a Resource", "location"

        it_should_behave_like "a Findable class", 1, 1

        it_should_behave_like "a Searchable class", 1, 1

      end

      context LocationType do

        it_should_behave_like "a Resource", "locationType"

        it_should_behave_like "a Findable class", 1, 1

        it_should_behave_like "a Searchable class", 1, 1

      end

      context Manufacturer do

        it_should_behave_like "a Resource", "manufacturer"

        it_should_behave_like "a Findable class", 1, 1

        it_should_behave_like "a Searchable class", 1, 1

      end

      context Order do

        it_should_behave_like "a Resource", "order"

        it_should_behave_like "a Findable class", 1000, 1000.to_s

        it_should_behave_like "a Searchable class", 1000, 1000.to_s

        it_should_behave_like "a Creatable class", {
            :customer_id => 1,
            :channel_id => 10,
            :billing_contact_id => 1,
            :items => [
                {
                    :product_id => 1,
                    :quantity => 2,
                    :shipping_method_id => 1,
                    :shipping_contact_id => 1,
                    :unit_price => 65.99
                },
                {
                    :product_id => 534,
                    :quantity => 1,
                    :shipping_method_id => 1,
                    :shipping_contact_id => 1,
                    :unit_price => 35.99
                }
            ]
        }

        it 'Can add payment to order' do
          fail
        end

        it 'Retrieve all shipments for an order.' do
          order = Order.find(9000)
          expect(order.shipments[0].id).to eq(40056)
        end
      end

      context Payment do
        it_should_behave_like "a Resource", "payment"

        it_should_behave_like "a Findable class", 1000, 1000

        it_should_behave_like "a Searchable class", 1000, 1000

        it_should_behave_like "a Creatable class", {
            assoc_entity: "order",
            assoc_entity_id: 1000,
            payment: 0.01,
            receivable_type_id: 12
        }
      end

      context Product do

        it_should_behave_like "a Resource", "product"

        it_should_behave_like "a Findable class", 1, 1

        it_should_behave_like "a Searchable class", 1, 1

        xit 'Retrieves all product locations.' do
          fail
        end

        context ProductPrice do
          xit 'get Channel ProductPrice of product' do
            product = Product.find(1)
            expect(product).to be_an_instance_of(Product)
            product_price = product.product_prices(8)
            expect(product_price).to be_an_instance_of(ProductPrice)
            expect(product_price.base_price).to eq(63.99)
            fail 'ticket opened with coresense due to unexpected return value.'
          end
        end
      end

      context ReceivableType do

        it_should_behave_like "a Resource", "receivableType"

        it_should_behave_like "a Findable class", 1, 1

        it_should_behave_like "a Searchable class", 1, 1

      end

      context Receiver do

        it_should_behave_like "a Resource", "receiver"

        it_should_behave_like "a Findable class", 1, 1

        it_should_behave_like "a Searchable class", 1, 1

        xit 'Create a new Receiver.' do
          fail
        end

        xit 'Update a specific Receiver.' do
          fail
        end
      end

      context Shipment do

        it_should_behave_like "a Resource", "shipment"

        it_should_behave_like "a Findable class", 142, 142

        it_should_behave_like "a Searchable class", 142, 142

        xit 'Update a specific shipment.' do
          fail
        end

        xit 'Retrieve all boxes for a shipment.' do
          fail
        end
      end

      context ShipmentBox do

        it_should_behave_like "a Resource", "shipmentBox"

        it_should_behave_like "a Searchable class", 145, 145

        xit 'Retrieves all inventory for a shipment box.' do
          fail
        end
      end

      context ShippingMethod do

        it_should_behave_like "a Resource", "shippingMethod"

        it_should_behave_like "a Findable class", 1, 1

        it_should_behave_like "a Searchable class", 1, 1

      end

      context Sku do

        it_should_behave_like "a Resource", "sku"

        it_should_behave_like "a Findable class", 1, 1

        it_should_behave_like "a Searchable class", 1, 1

        xit 'Retrieve all inventory for a SKU.' do
          fail
        end
      end

      context SkuInventory do

        it_should_behave_like "a Resource", "skuInventory"

        it_should_behave_like "a Searchable class", 0, 0

      end

      context SkuVendor do

        it_should_behave_like "a Resource", "skuVendor"

        it_should_behave_like "a Searchable class", 15575, 15575

      end

      context State do

        it_should_behave_like "a Resource", "state"

        it_should_behave_like "a Findable class", 1, 1

        it_should_behave_like "a Searchable class", 1, 1

      end

      context Transfer do

        it_should_behave_like "a Resource", "transfer"

        it_should_behave_like "a Findable class", 1, 1

        it_should_behave_like "a Searchable class", 1, 1

        xit 'Create a new transfer.' do
          fail
        end

        xit 'Update a specific transfer.' do
          fail
        end

        context 'Transfer Recievers' do
          xit 'Creates a receiver for a transfer.' do
            fail
          end

          xit 'Retrieves all receivers for a transfer.' do
            fail
          end
        end

        xit 'Retrieves all inventory for a transfer.' do
          fail
        end
      end

      context Warehouse do

        it_should_behave_like "a Resource", "warehouse"

        it_should_behave_like "a Findable class", 1, 1

        it_should_behave_like "a Searchable class", 1, 1

        xit 'Can pull on locations in warehouse' do
          fail
        end
      end
    end
  end
end