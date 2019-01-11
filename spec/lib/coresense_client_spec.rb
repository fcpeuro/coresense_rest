require 'spec_helper'

module CoresenseRest
  describe 'client' do

    before(:all) do
      CoresenseRest::Client.host = '<CORESENSE URL>'
      CoresenseRest::Client.user_id = '<USER ID>'
      CoresenseRest::Client.key = '<KEY>'
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

    context 'Affiliate' do
      it 'Hits the Correct Endpoint' do
        expect(Affiliate.full_path).to   eq("#{CoresenseRest::Client.host}/affiliate")
      end

      it "Can find an affiliate" do
        affiliate = Affiliate.find(1)
        expect(affiliate).to be_an_instance_of(Affiliate)
        expect(affiliate.id).to eq(1)
      end

      it 'Can list all affiliates' do
        expect(Affiliate.select).to be_an_instance_of(Array)
        expect(Affiliate.select[0]).to be_an_instance_of(Affiliate)
        expect(Affiliate.select[0].id).to eq(1)
      end

      it 'Can search affiliates' do
        expect(Affiliate.where({'id' => 1}).select[0].id).to eq(1)
        expect(Affiliate.where({:id => 1}).select[0].id).to eq(1)
        expect(Affiliate.where('id= 1 ').select[0].id).to eq(1)
      end
    end

    context 'Barcode' do
      it 'Hits the Correct Endpoint' do
        expect(Barcode.full_path).to   eq("#{CoresenseRest::Client.host}/barcode")
      end

      it 'Can find a barcode' do
        expect(Barcode.find(1).id).to eq(1)#not_to be_nil
      end

      it 'Can list all barcodes' do
        expect(Barcode.select[0].id).to eq(1)#not_to be_empty
      end

      it 'Can search barcodes' do
        expect(Barcode.where({'id' => 1}).select[0].id).to eq(1)
        expect(Barcode.where({:id => 1}).select[0].id).to eq(1)
        expect(Barcode.where('id= 1 ').select[0].id).to eq(1)
      end
    end

    context 'BarcodeSKU' do
      it 'Hits the Correct Endpoint' do
        expect(BarcodeSKU.full_path).to   eq("#{CoresenseRest::Client.host}/barcodeSku")
      end

      it 'Can find an barcode_sku' do
        expect(BarcodeSKU.find(1).id).to eq(1)#not_to be_nil
      end

      it 'Can list all barcode_skus' do
        expect(BarcodeSKU.select[0].id).to eq(1)#not_to be_empty
      end

      it 'Can search barcode_skus' do
        expect(BarcodeSKU.where({'id' => 1}).select[0].id).to eq(1)
        expect(BarcodeSKU.where({:id => 1}).select[0].id).to eq(1)
        expect(BarcodeSKU.where('id= 1 ').select[0].id).to eq(1)
      end
    end

    context 'Brand' do
      it 'Hits the Correct Endpoint' do
        expect(Brand.full_path).to   eq("#{CoresenseRest::Client.host}/brand")
      end

      it 'Can find an brand' do
        expect(Brand.find(1).id).to eq(1)#not_to be_nil
      end

      it 'Can list all brands' do
        expect(Brand.select[0].id).to eq(1)#not_to be_empty
      end

      it 'Can search brands' do
        expect(Brand.where({'id' => 1}).select[0].id).to eq(1)
        expect(Brand.where({:id => 1}).select[0].id).to eq(1)
        expect(Brand.where('id= 1 ').select[0].id).to eq(1)
      end
    end

    context 'Category' do
      it 'Hits the Correct Endpoint' do
        expect(Category.full_path).to   eq("#{CoresenseRest::Client.host}/category")
      end

      it 'Can find an category' do
        expect(Category.find(1).id).to eq(1)#not_to be_nil
      end

      it 'Can list all categories' do
        expect(Category.select[0].id).to eq(1)#not_to be_empty
      end

      it 'Can search categories' do
        expect(Category.where({'id' => 1}).select[0].id).to eq(1)
        expect(Category.where({:id => 1}).select[0].id).to eq(1)
        expect(Category.where('id= 1 ').select[0].id).to eq(1)
      end

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

    context 'Channel' do
      it 'Hits the Correct Endpoint' do
        expect(Channel.full_path).to   eq("#{CoresenseRest::Client.host}/channel")
      end

      it 'Can find an channel' do
        expect(Channel.find(1).id).to eq(1)#not_to be_nil
      end

      it 'Can list all channels' do
        expect(Channel.select[0].id).to eq(1)#not_to be_empty
      end

      it 'Can search channels' do
        expect(Channel.where({'id' => 1}).select[0].id).to eq(1)
        expect(Channel.where({:id => 1}).select[0].id).to eq(1)
        expect(Channel.where('id= 1 ').select[0].id).to eq(1)
      end

      xit 'Retrieve all products in a channel' do
        fail
      end

      xit 'Retrieve all shipments in a channel' do
        fail
      end
    end

    context 'Contact' do
      it 'Hits the Correct Endpoint' do
        expect(Contact.full_path).to   eq("#{CoresenseRest::Client.host}/contact")
      end

      it 'Can find an contact' do
        expect(Contact.find(1).id).to eq(1)#not_to be_nil
      end

      it 'Can list all contacts' do
        expect(Contact.select[0].id).to eq(1)#not_to be_empty
      end

      it 'Can search contacts' do
        expect(Contact.where({'id' => 1}).select[0].id).to eq(1)
        expect(Contact.where({:id => 1}).select[0].id).to eq(1)
        expect(Contact.where('id= 1 ').select[0].id).to eq(1)
      end

      xit 'Can create a new contact' do
        fail
      end
    end

    context 'Country' do
      it 'Hits the Correct Endpoint' do
        expect(Country.full_path).to   eq("#{CoresenseRest::Client.host}/country")
      end

      it 'Can find an country' do
        expect(Country.find(1).id).to eq(1)#not_to be_nil
      end

      it 'Can list all countries' do
        expect(Country.select[0].id).to eq(1)#not_to be_empty
      end

      it 'Can search countries' do
        expect(Country.where({'id' => 1}).select[0].id).to eq(1)
        expect(Country.where({:id => 1}).select[0].id).to eq(1)
        expect(Country.where('id= 1 ').select[0].id).to eq(1)
      end
    end

    context 'Customer' do
      it 'Hits the Correct Endpoint' do
        expect(Customer.full_path).to   eq("#{CoresenseRest::Client.host}/customer")
      end

      it 'Can find an customer' do
        expect(Customer.find(1).client_id).to eq(1)#not_to be_nil
      end

      it 'Can list all customers' do
        expect(Customer.select[0].client_id).to eq(1)#not_to be_empty
      end

      it 'Can search customers' do
        expect(Customer.where({'client_id' => 1}).select[0].client_id).to eq(1)
        expect(Customer.where({:client_id => 1}).select[0].client_id).to eq(1)
        expect(Customer.where('client_id= 1 ').select[0].client_id).to eq(1)
      end

      xit 'Can create a customer' do
        fail
      end

      xit 'Can list all customer contacts' do
        fail
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

    context 'Inventory' do
      it 'Hits the Correct Endpoint' do
        expect(Inventory.full_path).to   eq("#{CoresenseRest::Client.host}/inventory")
      end

      it 'Can find an inventory_unit' do
        expect(Inventory.find(2).id).to eq(2)#not_to be_nil
      end

      it 'Can list all inventory_units' do
        expect(Inventory.select[0].id).to eq(2)#not_to be_empty
      end

      it 'Can search inventory_units' do
        expect(Inventory.where({'id' => 2}).select[0].id).to eq(2)
        expect(Inventory.where({:id => 2}).select[0].id).to eq(2)
        expect(Inventory.where('id= 2 ').select[0].id).to eq(2)
      end
    end

    context 'Location' do
      it 'Hits the Correct Endpoint' do
        expect(Location.full_path).to   eq("#{CoresenseRest::Client.host}/location")
      end

      it 'Can find an location' do
        expect(Location.find(1).id).to eq(1)#not_to be_nil
      end

      it 'Can list all inventory_units' do
        expect(Location.select[0].id).to eq(1)#not_to be_empty
      end

      it 'Can search inventory_units' do
        expect(Location.where({'id' => 1}).select[0].id).to eq(1)
        expect(Location.where({:id => 1}).select[0].id).to eq(1)
        expect(Location.where('id= 1 ').select[0].id).to eq(1)
      end
    end

    context 'LocationType' do
      it 'Hits the Correct Endpoint' do
        expect(LocationType.full_path).to   eq("#{CoresenseRest::Client.host}/locationType")
      end

      it 'Can find an location_type' do
        expect(LocationType.find(1).id).to eq(1)#not_to be_nil
      end

      it 'Can list all location_types' do
        expect(LocationType.select[0].id).to eq(1)#not_to be_empty
      end

      it 'Can search location_types' do
        expect(LocationType.where({'id' => 1}).select[0].id).to eq(1)
        expect(LocationType.where({:id => 1}).select[0].id).to eq(1)
        expect(LocationType.where('id= 1 ').select[0].id).to eq(1)
      end
    end

    context 'Manufacturer' do
      it 'Hits the Correct Endpoint' do
        expect(Manufacturer.full_path).to   eq("#{CoresenseRest::Client.host}/manufacturer")
      end

      it 'Can find an manufacturer' do
        expect(Manufacturer.find(1).id).to eq(1)#not_to be_nil
      end

      it 'Can list all manufacturers' do
        expect(Manufacturer.select[0].id).to eq(1)#not_to be_empty
      end

      it 'Can search manufacturers' do
        expect(Manufacturer.where({'id' => 1}).select[0].id).to eq(1)
        expect(Manufacturer.where({:id => 1}).select[0].id).to eq(1)
        expect(Manufacturer.where('id= 1 ').select[0].id).to eq(1)
      end
    end

    context 'Order' do
      it 'Hits the Correct Endpoint' do
        expect(Order.full_path).to   eq("#{CoresenseRest::Client.host}/order")
      end

      it 'Can find an order' do
        expect(Order.find(1000).order_num).to eq(1000)#not_to be_nil
      end

      it 'Can list all orders' do
        expect(Order.select[0].order_num).to eq(1000)#not_to be_empty
      end

      it 'Can search orders' do
        expect(Order.where({'order_num' => 1000}).select[0].order_num).to eq(1000)
        expect(Order.where({:order_num => 1000}).select[0].order_num).to eq(1000)
        expect(Order.where('order_num= 1000 ').select[0].order_num).to eq(1000)
      end

      xit 'Can create a new order.' do
        fail
      end

      xit 'Retrieve all shipments for an order.' do
        fail
      end
    end

    context 'Product' do
      it 'Hits the Correct Endpoint' do
        expect(Product.full_path).to   eq("#{CoresenseRest::Client.host}/product")
      end

      it 'Can find an product' do
        expect(Product.find(1).id).to eq(1)#not_to be_nil
      end

      it 'Can list all products' do
        expect(Product.select[0].id).to eq(1)#not_to be_empty
      end

      it 'Can search products' do
        expect(Product.where({'id' => 1}).select[0].id).to eq(1)
        expect(Product.where({:id => 1}).select[0].id).to eq(1)
        expect(Product.where('id= 1 ').select[0].id).to eq(1)
      end

      xit 'Retrieves all product locations.' do
        fail
      end

      context 'ProductPrice' do
        it 'list ProductPrices of products' do
          fail
        end

        it 'list ProductPrices of products' do
          fail
        end
      end
    end

    context 'ReceivableType' do
      it 'Hits the Correct Endpoint' do
        expect(ReceivableType.full_path).to   eq("#{CoresenseRest::Client.host}/receivableType")
      end

      it 'Can find an ReceivableType' do
        expect(ReceivableType.find(1).id).to eq(1)#not_to be_nil
      end

      it 'Can list all ReceivableType' do
        expect(ReceivableType.select[0].id).to eq(1)#not_to be_empty
      end

      it 'Can search ReceivableType' do
        expect(ReceivableType.where({'id' => 1}).select[0].id).to eq(1)
        expect(ReceivableType.where({:id => 1}).select[0].id).to eq(1)
        expect(ReceivableType.where('id= 1 ').select[0].id).to eq(1)
      end
    end

    context 'Receiver' do
      it 'Hits the Correct Endpoint' do
        expect(Receiver.full_path).to   eq("#{CoresenseRest::Client.host}/receiver")
      end

      it 'Can find an Receiver' do
        expect(Receiver.find(1).id).to eq(1)#not_to be_nil
      end

      it 'Can list all Receiver' do
        expect(Receiver.select[0].id).to eq(1)#not_to be_empty
      end

      it 'Can search Receiver' do
        expect(Receiver.where({'id' => 1}).select[0].id).to eq(1)
        expect(Receiver.where({:id => 1}).select[0].id).to eq(1)
        expect(Receiver.where('id= 1 ').select[0].id).to eq(1)
      end

      xit 'Create a new Receiver.' do
        fail
      end

      xit 'Update a specific Receiver.' do
        fail
      end
    end

    context 'Shipment' do
      it 'Hits the Correct Endpoint' do
        expect(Shipment.full_path).to   eq("#{CoresenseRest::Client.host}/shipment")
      end

      it 'Can find an shipment' do
        expect(Shipment.find(142).id).to eq(142)#not_to be_nil
      end

      it 'Can list all shipments' do
        expect(Shipment.select[0].id).to eq(142)#not_to be_empty
      end

      it 'Can search shipments' do
        expect(Shipment.where({'id' => 142}).select[0].id).to eq(142)
        expect(Shipment.where({:id => 142}).select[0].id).to eq(142)
        expect(Shipment.where('id= 142 ').select[0].id).to eq(142)
      end

      xit 'Update a specific shipment.' do
        fail
      end

      xit 'Retrieve all boxes for a shipment.' do
        fail
      end
    end

    context 'ShipmentBox' do
      it 'Hits the Correct Endpoint' do
        expect(ShipmentBox.full_path).to   eq("#{CoresenseRest::Client.host}/shipmentBox")
      end

      it 'Can find an shipment_box' do
        expect(ShipmentBox.find(145).id).to eq(145)#not_to be_nil
      end

      it 'Can list all shipment_boxes' do
        expect(ShipmentBox.select[0].id).to eq(145)#not_to be_empty
      end

      it 'Can search shipment_boxes' do
        expect(ShipmentBox.where({'id' => 145}).select[0].id).to eq(145)
        expect(ShipmentBox.where({:id => 145}).select[0].id).to eq(145)
        expect(ShipmentBox.where('id= 145 ').select[0].id).to eq(145)
      end

      xit 'Retrieves all inventory for a shipment box.' do
        fail
      end
    end

    context 'ShippingMethod' do
      it 'Hits the Correct Endpoint' do
        expect(ShippingMethod.full_path).to   eq("#{CoresenseRest::Client.host}/shippingMethod")
      end

      it 'Can find an shipping_method' do
        expect(ShippingMethod.find(1).id).to eq(1)#not_to be_nil
      end

      it 'Can list all shipping_methods' do
        expect(ShippingMethod.select[0].id).to eq(1)#not_to be_empty
      end

      it 'Can search shipping_methods' do
        expect(ShippingMethod.where({'id' => 1}).select[0].id).to eq(1)
        expect(ShippingMethod.where({:id => 1}).select[0].id).to eq(1)
        expect(ShippingMethod.where('id= 1 ').select[0].id).to eq(1)
      end
    end

    context 'SKU' do
      it 'Hits the Correct Endpoint' do
        expect(Sku.full_path).to   eq("#{CoresenseRest::Client.host}/sku")
      end

      it 'Can find an sku' do
        expect(Sku.find(1).id).to eq(1)#not_to be_nil
      end

      it 'Can list all skus' do
        expect(Sku.select[0].id).to eq(1)#not_to be_empty
      end

      it 'Can search skus' do
        expect(Sku.where({'id' => 1}).select[0].id).to eq(1)
        expect(Sku.where({:id => 1}).select[0].id).to eq(1)
        expect(Sku.where('id= 1 ').select[0].id).to eq(1)
      end

      xit 'Retrieve all inventory for a SKU.' do
        fail
      end
    end

    context 'SKU Inventory' do
      it 'Hits the Correct Endpoint' do
        expect(SkuInventory.full_path).to   eq("#{CoresenseRest::Client.host}/skuInventory")
      end

      it 'Can list all sku_inventory' do
        expect(SkuInventory.select[0].sku_id).to eq(0)#not_to be_empty
      end

      it 'Can search sku_inventory' do
        expect(SkuInventory.where({'sku_id' => 1}).select[0].sku_id).to eq(1)
        expect(SkuInventory.where({:sku_id => 1}).select[0].sku_id).to eq(1)
        expect(SkuInventory.where('sku_id= 1 ').select[0].sku_id).to eq(1)
      end
    end

    context 'SKU Vendor' do
      it 'Hits the Correct Endpoint' do
        expect(SkuVendor.full_path).to   eq("#{CoresenseRest::Client.host}/skuVendor")
      end

      it 'Can list all sku_vendors' do
        expect(SkuVendor.select[0].id).to eq(15575)#not_to be_empty
      end

      it 'Can search sku_vendors' do
        expect(SkuVendor.where({'id' => 15575}).select[0].id).to eq(15575)
        expect(SkuVendor.where({:id => 15575}).select[0].id).to eq(15575)
        expect(SkuVendor.where('id= 15575 ').select[0].id).to eq(15575)
      end
    end

    context 'State' do
      it 'Hits the Correct Endpoint' do
        expect(State.full_path).to   eq("#{CoresenseRest::Client.host}/state")
      end

      it 'Can find an state' do
        expect(State.find(1).id).to eq(1)#not_to be_nil
      end

      it 'Can list all states' do
        expect(State.select[0].id).to eq(1)#not_to be_empty
      end

      it 'Can search states' do
        expect(State.where({'id' => 1}).select[0].id).to eq(1)
        expect(State.where({:id => 1}).select[0].id).to eq(1)
        expect(State.where('id= 1 ').select[0].id).to eq(1)
      end
    end

    context 'Transfer' do
      it 'Hits the Correct Endpoint' do
        expect(Transfer.full_path).to   eq("#{CoresenseRest::Client.host}/transfer")
      end

      it 'Can find an transfer' do
        expect(Transfer.find(1).id).to eq(1)#not_to be_nil
      end

      it 'Can list all transfers' do
        expect(Transfer.select[0].id).to eq(1)#not_to be_empty
      end

      it 'Can search transfers' do
        expect(Transfer.where({'id' => 1}).select[0].id).to eq(1)
        expect(Transfer.where({:id => 1}).select[0].id).to eq(1)
        expect(Transfer.where('id= 1 ').select[0].id).to eq(1)
      end

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

    context 'Warehouse' do
      it 'Hits the Correct Endpoint' do
        expect(Warehouse.full_path).to   eq("#{CoresenseRest::Client.host}/warehouse")
      end

      it 'Can find an Warehouse' do
        expect(Warehouse.find(1).id).to eq(1)#not_to be_nil
      end

      it 'Can list all Warehouse' do
        expect(Warehouse.select[0].id).to eq(1)#not_to be_empty
      end

      it 'Can search Warehouse' do
        expect(Warehouse.where({'id' => 1}).select[0].id).to eq(1)
        expect(Warehouse.where({:id => 1}).select[0].id).to eq(1)
        expect(Warehouse.where('id= 1 ').select[0].id).to eq(1)
      end

      xit 'Can pull on locations in warehouse' do
        fail
      end
    end

  end
end