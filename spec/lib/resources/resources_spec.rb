# frozen_string_literal: true

require 'spec_helper'
require 'byebug'

module CoresenseRest
  shared_examples 'a Resource' do |endpoint|
    it 'Hits the Correct Endpoint' do
      expect(described_class.full_path).to eq("#{CoresenseRest::Client.host}/#{endpoint}")
    end
  end

  shared_examples 'a Findable class' do |input, output|
    it '.find' do
      VCR.use_cassette("#{described_class.name.split('::').last}/find_#{input}") do
        klass_instance = described_class.find(input)
        expect(klass_instance).to be_an_instance_of(described_class)
        expect(klass_instance.id).to eq(output)
      end
    end
  end

  shared_examples 'a Searchable class' do |input, output|
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
          expect(described_class.where('client_id' => input).select[0].id).to eq(output)
          expect(described_class.where(client_id: input).select[0].id).to eq(output)
          expect(described_class.where("client_id= #{input} ").select[0].id).to eq(output)
        end
      end
    when Order.name
      it ".select (order_num=#{input})" do
        VCR.use_cassette("#{described_class.name.split('::').last}/select_order_num=#{input}") do
          expect(described_class.where('order_num' => input).select[0].id).to eq(output)
          expect(described_class.where(order_num: input).select[0].id).to eq(output)
          expect(described_class.where("order_num= #{input} ").select[0].id).to eq(output)
        end
      end
    when SkuInventory.name
      it ".select (sku_id=#{input})" do
        VCR.use_cassette("#{described_class.name.split('::').last}/select_sku_id=#{input}") do
          expect(described_class.where('sku_id' => input).select[0].sku_id).to eq(output)
          expect(described_class.where(sku_id: input).select[0].sku_id).to eq(output)
          expect(described_class.where("sku_id= #{input} ").select[0].sku_id).to eq(output)
        end
      end
    else
      it ".select (id=#{input})" do
        VCR.use_cassette("#{described_class.name.split('::').last}/select_id=#{input}") do
          expect(described_class.where('id' => input).select[0].id).to eq(output)
          expect(described_class.where(id: input).select[0].id).to eq(output)
          expect(described_class.where("id= #{input} ").select[0].id).to eq(output)
        end
      end
    end
  end

  shared_examples 'a Creatable class' do |creation_hash|
    it '.create' do
      VCR.use_cassette("#{described_class.name.split('::').last}/create") do
        expect(described_class.create(creation_hash)).to be_an_instance_of(described_class)
      end
    end
  end

  shared_examples 'an Updatable class' do |id, update_hash|
    it '.update' do
      VCR.use_cassette("#{described_class.name.split('::').last}/update") do
        klass_instance = described_class.find(id)
        expect(klass_instance).to be_an_instance_of(described_class)
        expect(klass_instance.update(update_hash)).to be_an_instance_of(described_class)
      end
    end
  end

  describe 'CREST API' do
    before(:all) do
      creds = YAML.safe_load(File.read("#{__dir__}/../../../credentials.yml"))
      CoresenseRest.configure do |config|
        config.host = creds['endpoint']
        config.user_id = creds['user_id']
        config.key = creds['key']
      end
    end

    context 'Request' do
      let(:request) { RequestRead.new("#{CoresenseRest::Client.host}/resource", {}, Resource) }

      it 'Creates requests correctly' do
        expect(request.current_path).to   eq("#{CoresenseRest::Client.host}/resource")
        expect(request.order('field').current_path).to eq("#{CoresenseRest::Client.host}/resource?&order=field")
        expect(request.where('field1=15').current_path).to eq("#{CoresenseRest::Client.host}/resource?&q[]=field1%3D15")
        expect(request.where('field1=15 AND field2=5').current_path).to eq("#{CoresenseRest::Client.host}/resource?&q[]=field1%3D15&q[]=field2%3D5")
        expect(request.where('field1' => 15, 'field2' => 5).current_path).to eq("#{CoresenseRest::Client.host}/resource?&q[]=field1=15&q[]=field2=5")
      end
    end

    describe 'Resources:' do
      context Affiliate do
        it_should_behave_like 'a Resource', 'affiliate'

        it_should_behave_like 'a Findable class', 1, 1

        it_should_behave_like 'a Searchable class', 1, 1
      end

      context Barcode do
        it_should_behave_like 'a Resource', 'barcode'

        it_should_behave_like 'a Findable class', 1, 1

        it_should_behave_like 'a Searchable class', 1, 1
      end

      context BarcodeSku do
        it_should_behave_like 'a Resource', 'barcodeSku'

        it_should_behave_like 'a Findable class', 1, 1

        it_should_behave_like 'a Searchable class', 1, 1
      end

      context Brand do
        it_should_behave_like 'a Resource', 'brand'

        it_should_behave_like 'a Findable class', 1, 1

        it_should_behave_like 'a Searchable class', 1, 1
      end

      context Category do
        it_should_behave_like 'a Resource', 'category'

        it_should_behave_like 'a Findable class', 1, 1

        it_should_behave_like 'a Searchable class', 1, 1

        xit 'Can create a new categoy' do
          raise
        end

        xit 'Can update a new categoy' do
          raise
        end

        xit 'Can delete a new categoy' do
          raise
        end

        xit 'Can fetch all categoy products' do
          raise
        end

        xit 'Can fetch all featured categoy products' do
          raise
        end

        xit 'Can fetch all categoy subcategories' do
          raise
        end
      end

      context Channel do
        it_should_behave_like 'a Resource', 'channel'

        it_should_behave_like 'a Findable class', 1, 1

        it_should_behave_like 'a Searchable class', 1, 1

        xit 'Retrieve all products in a channel' do
          raise
        end

        xit 'Retrieve all shipments in a channel' do
          raise
        end
      end

      context Comment do
        it_should_behave_like 'a Resource', 'comment'

        it_should_behave_like 'a Findable class', 1662535, 1662535

        it_should_behave_like 'a Searchable class', 1662535, 1662535

        it_should_behave_like 'a Creatable class',
                              message: 'test message', rep: 'website', type: 'Other', assoc_entity: 'order', assoc_entity_id: 1728371, privacy: 'private'
      end

      context Contact do
        it_should_behave_like 'a Resource', 'contact'

        it_should_behave_like 'a Findable class', 1, 1

        it_should_behave_like 'a Searchable class', 1, 1

        it_should_behave_like 'a Creatable class',
                              last_name: 'test', first_name: 'testy', customer_id: 1
      end

      context Country do
        it_should_behave_like 'a Resource', 'country'

        it_should_behave_like 'a Findable class', 1, 1

        it_should_behave_like 'a Searchable class', 1, 1
      end

      context Customer do
        it_should_behave_like 'a Resource', 'customer'

        it_should_behave_like 'a Findable class', 1, 1.to_s

        it_should_behave_like 'a Searchable class', 1, 1.to_s

        it_should_behave_like 'a Creatable class',
                              default_billing_contact: { last_name: 'test', first_name: 'testy', email: 'account@email.com' },
                              default_shipping_contact: { last_name: 'test', first_name: 'testy', email: 'account@email.com' }

        it 'Can list all customer contacts' do
          VCR.use_cassette("#{described_class.name.split('::').last}/list_customers") do
            cust = Customer.find(1)
            contacts = cust.contacts
            expect(contacts).to be_an_instance_of(Array)
            expect(contacts[0]).to be_an_instance_of(Contact)
          end
        end
      end

      context 'Help' do
        xit 'Hits the Correct Endpoint' do
          expect(Affiliate.full_path).to eq("#{CoresenseRest::Client.host}/help")
        end

        xit 'Retrieves all error codes.' do
          raise
        end

        xit 'Pings the API to verify status. Can to used to check authentication credentials.' do
          raise
        end

        xit 'Retrieves all currently available API routes.' do
          raise
        end
      end

      context Inventory do
        it_should_behave_like 'a Resource', 'inventory'

        it_should_behave_like 'a Findable class', 2, 2

        it_should_behave_like 'a Searchable class', 2, 2
      end

      context Location do
        it_should_behave_like 'a Resource', 'location'

        it_should_behave_like 'a Findable class', 1, 1

        it_should_behave_like 'a Searchable class', 1, 1
      end

      context LocationType do
        it_should_behave_like 'a Resource', 'locationType'

        it_should_behave_like 'a Findable class', 1, 1

        it_should_behave_like 'a Searchable class', 1, 1
      end

      context Manufacturer do
        it_should_behave_like 'a Resource', 'manufacturer'

        it_should_behave_like 'a Findable class', 1, 1

        it_should_behave_like 'a Searchable class', 1, 1
      end

      context OrderAdjustment do
        it_should_behave_like 'a Resource', 'orderAdjustment'

        it_should_behave_like 'a Findable class', 2, 2

        it_should_behave_like 'a Searchable class', 2, 2

        it_should_behave_like 'a Creatable class',
                              amount: 2, description: 'coupon', order_num: 1001, type: 3, recalculate_tax: 0
        # recalculate_tax => 0, do not recalculate sales tax
        # recalculate_tax => 1, recalculate sales tax
      end

      context OrderFulfillment do
        pending 'OrderFulfillment'
        # it_should_behave_like "a Resource", "productConfigurationOption"

        # it_should_behave_like "a Findable class", 1, 1

        # it_should_behave_like "a Searchable class", 1, 1
      end

      context OrderItemAdjustment do
        pending 'OrderItemAdjustment'

        # it_should_behave_like "a Resource", "orderItemAdjustment"

        # it_should_behave_like "a Findable class", 1, 1 #Order Item Adjustments have never been made

        # it_should_behave_like "a Searchable class", 1, 1 #Order Item Adjustments have never been made

        # it_should_behave_like "a Creatable class", {}
      end

      context OrderItemDeal do
        pending 'OrderItemDeal'
      #   it_should_behave_like 'a Resource', 'orderItemDeal'

      #   it_should_behave_like 'a Findable class', 1, 1 # Order Item Deals have never been made

      #   it_should_behave_like 'a Searchable class', 1, 1 # Order Item Deals have never been made
      end

      context OrderItem do
        it_should_behave_like 'a Resource', 'orderItem'

        it_should_behave_like 'a Findable class', 67, 67

        it_should_behave_like 'a Searchable class', 67, 67
      end

      context OrderItemSalesTaxModifierType do
        pending 'OrderItemSalesTaxModifierType'
      #   it_should_behave_like 'a Resource', 'orderItemSalesTaxModifierType'

      #   it_should_behave_like 'a Findable class', 1, 1 # Order orderItemSalesTaxModifierType have never been made

      #   it_should_behave_like 'a Searchable class', 1, 1 # Order orderItemSalesTaxModifierType have never been made
      end

      context Order do
        it_should_behave_like 'a Resource', 'order'

        it_should_behave_like 'a Findable class', 1000, 1000.to_s

        it_should_behave_like 'a Searchable class', 1000, 1000.to_s

        it_should_behave_like 'a Creatable class',
                              customer_id: 513674,
                              channel_id: 8,
                              billing_contact_id: 1508077,
                              order_status: 1,comments: 'Payment identifier: R907928159-JJ5F5T4R  Delivery between 01/31 - 02/03',
                              items: [{product_id: 184846,quantity: 2,shipping_method_id: 1,shipping_contact_id: 1508077,unit_price: '148.0',
                                       sales_tax_rate: '0.06808'
                                      },{product_id: 423873,quantity: 1,shipping_method_id: 1,shipping_contact_id: 1508077,unit_price: '279.95',
                                         sales_tax_rate: '0.06808'
                                      },{product_id: 210444,quantity: 1,shipping_method_id: 1,shipping_contact_id: 1508077,unit_price: '157.21',
                                         sales_tax_rate: '0.06808'
                                      }],
                              shipping_price: '7.99',
                              due_date: '2020-04-29 12:49:11',
                              shipping_tax_rate: '0.07009'


        it 'Retrieve all shipments for an order.' do
          VCR.use_cassette("#{described_class.name.split('::').last}/list_shipments") do
            order = Order.find(9000)
            shipments = order.shipments
            expect(shipments).to be_an_instance_of(Array)
            expect(shipments[0]).to be_an_instance_of(Shipment)
          end
        end
      end

      context OrderShippingDetail do
        it_should_behave_like 'a Resource', 'orderShippingDetail'

        it_should_behave_like 'a Findable class', 1000, 1000

        it_should_behave_like 'a Searchable class', 1000, 1000
      end

      context Payment do
        it_should_behave_like 'a Resource', 'payment'

        it_should_behave_like 'a Findable class', 1000, 1000

        it_should_behave_like 'a Searchable class', 1000, 1000

        it_should_behave_like 'a Creatable class',
                              assoc_entity: 'order',
                              assoc_entity_id: 1000,
                              payment: 0.21,
                              payment_process_message: 'xyz23-R2324',
                              receivable_type_id: 12
      end

      context ProductConfigurationOption do
        pending 'ProductConfigurationOption'
      #   it_should_behave_like 'a Resource', 'productConfigurationOption'

      #   it_should_behave_like 'a Findable class', 1, 1

      #   it_should_behave_like 'a Searchable class', 1, 1
      end

      context ProductConfigurationOptionType do
        it_should_behave_like 'a Resource', 'productConfigurationOptionType'

        it_should_behave_like 'a Findable class', 1, 1 # productConfigurationOptionType have never been made

        it_should_behave_like 'a Searchable class', 1, 1 # productConfigurationOptionType have never been made
      end

      context ProductInventory do
        it_should_behave_like 'a Resource', 'productInventory'

        it_should_behave_like 'a Findable class', 1, 1

        it_should_behave_like 'a Searchable class', 1, 1
      end

      context ProductInventoryStandard do
        it_should_behave_like 'a Resource', 'productInventoryStandard'

        it_should_behave_like 'a Findable class', 5, 5

        it_should_behave_like 'a Searchable class', 5, 5
      end

      context ProductInventoryUpgrade do
        it_should_behave_like 'a Resource', 'productInventoryUpgrade'

        it_should_behave_like 'a Findable class', 1, 1

        it_should_behave_like 'a Searchable class', 1, 1
      end

      context Product do
        it_should_behave_like 'a Resource', 'product'

        it_should_behave_like 'a Findable class', 1, 1

        it_should_behave_like 'a Searchable class', 1, 1

        xit 'Retrieves all product locations.' do
          raise
        end

        context ProductPrice do
          xit 'get Channel ProductPrice of product' do
            product = Product.find(1)
            expect(product).to be_an_instance_of(Product)
            product_price = product.product_prices(8)
            expect(product_price).to be_an_instance_of(ProductPrice)
            expect(product_price.base_price).to eq(63.99)
            raise 'ticket opened with coresense due to unexpected return value.'
          end
        end
      end

      context ReceivableType do
        it_should_behave_like 'a Resource', 'receivableType'

        it_should_behave_like 'a Findable class', 1, 1

        it_should_behave_like 'a Searchable class', 1, 1
      end

      context Receiver do
        it_should_behave_like 'a Resource', 'receiver'

        it_should_behave_like 'a Findable class', 1, 1

        it_should_behave_like 'a Searchable class', 1, 1

        xit 'Create a new Receiver.' do
          raise
        end

        xit 'Update a specific Receiver.' do
          raise
        end
      end

      context Shipment do
        it_should_behave_like 'a Resource', 'shipment'

        it_should_behave_like 'a Findable class', 142, 142

        it_should_behave_like 'a Searchable class', 142, 142

        xit 'Update a specific shipment.' do
          raise
        end

        xit 'Retrieve all boxes for a shipment.' do
          raise
        end
      end

      context ShipmentBox do
        it_should_behave_like 'a Resource', 'shipmentBox'

        it_should_behave_like 'a Searchable class', 145, 145

        xit 'Retrieves all inventory for a shipment box.' do
          raise
        end
      end

      context ShippingMethod do
        it_should_behave_like 'a Resource', 'shippingMethod'

        it_should_behave_like 'a Findable class', 1, 1

        it_should_behave_like 'a Searchable class', 1, 1
      end

      context Sku do
        it_should_behave_like 'a Resource', 'sku'

        it_should_behave_like 'a Findable class', 1, 1

        #it_should_behave_like 'a Searchable class', 1, 1

        xit 'Retrieve all inventory for a SKU.' do
          raise
        end
      end

      context SkuInventory do
        it_should_behave_like 'a Resource', 'skuInventory'

        it_should_behave_like 'a Searchable class', 0, 0
      end

      context SkuVendor do
        pending 'SkuVendor'
        # it_should_behave_like 'a Resource', 'skuVendor'

        # it_should_behave_like 'a Searchable class', 15_575, 15_575
      end

      context State do
        it_should_behave_like 'a Resource', 'state'

        it_should_behave_like 'a Findable class', 1, 1

        it_should_behave_like 'a Searchable class', 1, 1
      end

      context Transfer do
        it_should_behave_like 'a Resource', 'transfer'

        it_should_behave_like 'a Findable class', 1, 1

        it_should_behave_like 'a Searchable class', 1, 1

        xit 'Create a new transfer.' do
          raise
        end

        xit 'Update a specific transfer.' do
          raise
        end

        context 'Transfer Recievers' do
          xit 'Creates a receiver for a transfer.' do
            raise
          end

          xit 'Retrieves all receivers for a transfer.' do
            raise
          end
        end

        xit 'Retrieves all inventory for a transfer.' do
          raise
        end
      end

      context Warehouse do
        it_should_behave_like 'a Resource', 'warehouse'

        it_should_behave_like 'a Findable class', 1, 1

        it_should_behave_like 'a Searchable class', 1, 1

        xit 'Can pull on locations in warehouse' do
          raise
        end
      end
    end
  end
end
