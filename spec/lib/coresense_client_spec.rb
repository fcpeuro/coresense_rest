require 'spec_helper'

module CoresenseRest
  describe 'client' do

    before(:all) do
      @host = 'Coresense Url'
      @user_id = 'USER ID'
      @key = 'KEY'
      @client = Client.new(@host, @user_id, @key)
    end

    context 'Request' do
      let(:request){Request.new("#{@host}/resource", {})}

      it "Creates requests correctly" do
        expect(request.current_path).to   eq("#{@host}/resource")
        expect(request.order('field').current_path).to   eq("#{@host}/resource?&order=field")
        expect(request.where("field1=15").current_path).to   eq("#{@host}/resource?&q[]=field1=15")
        expect(request.where('field1=15 AND field2=5').current_path).to   eq("#{@host}/resource?&q[]=field1=15&q[]=field2=5")
        expect(request.where({'field1'=>15, 'field2'=>5}).current_path).to   eq("#{@host}/resource?&q[]=field1=15&q[]=field2=5")
      end
    end

    context 'Affiliate' do
      it 'Can find an affiliate' do
        expect(@client.affiliates.find(1)).to eq(1)#not_to be_nil
      end

      it 'Can list all affiliates' do
        expect(@client.affiliates.select).be eq(1)#not_to be_empty
      end

      it 'Can search affiliates' do
        expect(@client.affiliates.where({'id' => 1}).select).be eq(1)
        expect(@client.affiliates.where({:id => 1}).select).be eq(1)
        expect(@client.affiliates.where('id= 1 ').select).be eq(1)
      end
    end

    context 'Barcode' do
      it 'Can find an barcode' do
        expect(@client.barcodes.find(1)).to eq(1)#not_to be_nil
      end

      it 'Can list all barcodes' do
        expect(@client.barcodes.select).be eq(1)#not_to be_empty
      end

      it 'Can search barcodes' do
        expect(@client.barcodes.where({'id' => 1}).select).be eq(1)
        expect(@client.barcodes.where({:id => 1}).select).be eq(1)
        expect(@client.barcodes.where('id= 1 ').select).be eq(1)
      end
    end

    context 'BarcodeSKU' do
      it 'Can find an barcode_sku' do
        expect(@client.barcode_skus.find(1)).to eq(1)#not_to be_nil
      end

      it 'Can list all barcode_skus' do
        expect(@client.barcode_skus.select).be eq(1)#not_to be_empty
      end

      it 'Can search barcode_skus' do
        expect(@client.barcode_skus.where({'id' => 1}).select).be eq(1)
        expect(@client.barcode_skus.where({:id => 1}).select).be eq(1)
        expect(@client.barcode_skus.where('id= 1 ').select).be eq(1)
      end
    end

    context 'Brand' do
      it 'Can find an brand' do
        expect(@client.brands.find(1)).to eq(1)#not_to be_nil
      end

      it 'Can list all brands' do
        expect(@client.brands.select).be eq(1)#not_to be_empty
      end

      it 'Can search brands' do
        expect(@client.brands.where({'id' => 1}).select).be eq(1)
        expect(@client.brands.where({:id => 1}).select).be eq(1)
        expect(@client.brands.where('id= 1 ').select).be eq(1)
      end
    end

    context 'Category' do
      it 'Can find an category' do
        expect(@client.categories.find(1)).to eq(1)#not_to be_nil
      end

      it 'Can list all categories' do
        expect(@client.categories.select).be eq(1)#not_to be_empty
      end

      it 'Can search categories' do
        expect(@client.categories.where({'id' => 1}).select).be eq(1)
        expect(@client.categories.where({:id => 1}).select).be eq(1)
        expect(@client.categories.where('id= 1 ').select).be eq(1)
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
      it 'Can find an channel' do
        expect(@client.channels.find(1)).to eq(1)#not_to be_nil
      end

      it 'Can list all channels' do
        expect(@client.channels.select).be eq(1)#not_to be_empty
      end

      it 'Can search channels' do
        expect(@client.channels.where({'id' => 1}).select).be eq(1)
        expect(@client.channels.where({:id => 1}).select).be eq(1)
        expect(@client.channels.where('id= 1 ').select).be eq(1)
      end

      xit 'Retrieve all products in a channel' do
        fail
      end

      xit 'Retrieve all shipments in a channel' do
        fail
      end
    end

    context 'Contact' do
      it 'Can find an contact' do
        expect(@client.contacts.find(1)).to eq(1)#not_to be_nil
      end

      it 'Can list all contacts' do
        expect(@client.contacts.select).be eq(1)#not_to be_empty
      end

      it 'Can search contacts' do
        expect(@client.contacts.where({'id' => 1}).select).be eq(1)
        expect(@client.contacts.where({:id => 1}).select).be eq(1)
        expect(@client.contacts.where('id= 1 ').select).be eq(1)
      end

      xit 'Can create a new contact' do
        fail
      end
    end

    context 'Country' do
      it 'Can find an country' do
        expect(@client.countries.find(1)).to eq(1)#not_to be_nil
      end

      it 'Can list all countries' do
        expect(@client.countries.select).be eq(1)#not_to be_empty
      end

      it 'Can search countries' do
        expect(@client.countries.where({'id' => 1}).select).be eq(1)
        expect(@client.countries.where({:id => 1}).select).be eq(1)
        expect(@client.countries.where('id= 1 ').select).be eq(1)
      end
    end

    context 'Customer' do
      it 'Can find an customer' do
        expect(@client.customers.find(1)).to eq(1)#not_to be_nil
      end

      it 'Can list all customers' do
        expect(@client.customers.select).be eq(1)#not_to be_empty
      end

      it 'Can search customers' do
        expect(@client.customers.where({'id' => 1}).select).be eq(1)
        expect(@client.customers.where({:id => 1}).select).be eq(1)
        expect(@client.customers.where('id= 1 ').select).be eq(1)
      end

      xit 'Can create a customer' do
        fail
      end

      xit 'Can list all customer contacts' do
        fail
      end
    end

    context 'Help' do
      it 'Retrieves all error codes.' do
        fail
      end

      it 'Pings the API to verify status. Can be used to check authentication credentials.' do
        fail
      end

      it 'Retrieves all currently available API routes.' do
        fail
      end
    end

    context 'Inventory' do
      it 'Can find an inventory_unit' do
        expect(@client.inventory_units.find(1)).to eq(1)#not_to be_nil
      end

      it 'Can list all inventory_units' do
        expect(@client.inventory_units.select).be eq(1)#not_to be_empty
      end

      it 'Can search inventory_units' do
        expect(@client.inventory_units.where({'id' => 1}).select).be eq(1)
        expect(@client.inventory_units.where({:id => 1}).select).be eq(1)
        expect(@client.inventory_units.where('id= 1 ').select).be eq(1)
      end
    end

    context 'Location' do
      it 'Can find an location' do
        expect(@client.inventory_units.find(1)).to eq(1)#not_to be_nil
      end

      it 'Can list all inventory_units' do
        expect(@client.inventory_units.select).be eq(1)#not_to be_empty
      end

      it 'Can search inventory_units' do
        expect(@client.inventory_units.where({'id' => 1}).select).be eq(1)
        expect(@client.inventory_units.where({:id => 1}).select).be eq(1)
        expect(@client.inventory_units.where('id= 1 ').select).be eq(1)
      end
    end

    context 'LocationType' do
      it 'Can find an location_type' do
        expect(@client.location_types.find(1)).to eq(1)#not_to be_nil
      end

      it 'Can list all location_types' do
        expect(@client.location_types.select).be eq(1)#not_to be_empty
      end

      it 'Can search location_types' do
        expect(@client.location_types.where({'id' => 1}).select).be eq(1)
        expect(@client.location_types.where({:id => 1}).select).be eq(1)
        expect(@client.location_types.where('id= 1 ').select).be eq(1)
      end
    end

    context 'Manufacturer' do
      it 'Can find an manufacturer' do
        expect(@client.manufacturers.find(1)).to eq(1)#not_to be_nil
      end

      it 'Can list all manufacturers' do
        expect(@client.manufacturers.select).be eq(1)#not_to be_empty
      end

      it 'Can search manufacturers' do
        expect(@client.manufacturers.where({'id' => 1}).select).be eq(1)
        expect(@client.manufacturers.where({:id => 1}).select).be eq(1)
        expect(@client.manufacturers.where('id= 1 ').select).be eq(1)
      end
    end

    context 'Order' do
      it 'Can find an order' do
        expect(@client.orders.find(1)).to eq(1)#not_to be_nil
      end

      it 'Can list all orders' do
        expect(@client.orders.select).be eq(1)#not_to be_empty
      end

      it 'Can search orders' do
        expect(@client.orders.where({'id' => 1}).select).be eq(1)
        expect(@client.orders.where({:id => 1}).select).be eq(1)
        expect(@client.orders.where('id= 1 ').select).be eq(1)
      end

      xit 'Can create a new order.' do
        fail
      end

      xit 'Retrieve all shipments for an order.' do
        fail
      end
    end

    context 'Product' do
      it 'Can find an product' do
        expect(@client.products.find(1)).to eq(1)#not_to be_nil
      end

      it 'Can list all products' do
        expect(@client.products.select).be eq(1)#not_to be_empty
      end

      it 'Can search products' do
        expect(@client.products.where({'id' => 1}).select).be eq(1)
        expect(@client.products.where({:id => 1}).select).be eq(1)
        expect(@client.products.where('id= 1 ').select).be eq(1)
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
      it 'Can find an receivable_type' do
        expect(@client.receivable_types.find(1)).to eq(1)#not_to be_nil
      end

      it 'Can list all receivable_types' do
        expect(@client.receivable_types.select).be eq(1)#not_to be_empty
      end

      it 'Can search receivable_types' do
        expect(@client.receivable_types.where({'id' => 1}).select).be eq(1)
        expect(@client.receivable_types.where({:id => 1}).select).be eq(1)
        expect(@client.receivable_types.where('id= 1 ').select).be eq(1)
      end
    end

    context 'Receiver' do
      it 'Can find an receiver' do
        expect(@client.receivers.find(1)).to eq(1)#not_to be_nil
      end

      it 'Can list all receivers' do
        expect(@client.receivers.select).be eq(1)#not_to be_empty
      end

      it 'Can search receivers' do
        expect(@client.receivers.where({'id' => 1}).select).be eq(1)
        expect(@client.receivers.where({:id => 1}).select).be eq(1)
        expect(@client.receivers.where('id= 1 ').select).be eq(1)
      end

      xit 'Create a new receiver.' do
        fail
      end

      xit 'Update a specific receiver.' do
        fail
      end
    end

    context 'Shipment' do
      it 'Can find an shipment' do
        expect(@client.shipments.find(1)).to eq(1)#not_to be_nil
      end

      it 'Can list all shipments' do
        expect(@client.shipments.select).be eq(1)#not_to be_empty
      end

      it 'Can search shipments' do
        expect(@client.shipments.where({'id' => 1}).select).be eq(1)
        expect(@client.shipments.where({:id => 1}).select).be eq(1)
        expect(@client.shipments.where('id= 1 ').select).be eq(1)
      end

      xit 'Update a specific shipment.' do
        fail
      end

      xit 'Retrieve all boxes for a shipment.' do
        fail
      end
    end

    context 'ShipmentBox' do
      it 'Can find an shipment_box' do
        expect(@client.shipment_boxes.find(1)).to eq(1)#not_to be_nil
      end

      it 'Can list all shipment_boxes' do
        expect(@client.shipment_boxes.select).be eq(1)#not_to be_empty
      end

      it 'Can search shipment_boxes' do
        expect(@client.shipment_boxes.where({'id' => 1}).select).be eq(1)
        expect(@client.shipment_boxes.where({:id => 1}).select).be eq(1)
        expect(@client.shipment_boxes.where('id= 1 ').select).be eq(1)
      end

      xit 'Retrieves all inventory for a shipment box.' do
        fail
      end
    end

    context 'ShippingMethod' do
      it 'Can find an shipping_method' do
        expect(@client.shipping_methods.find(1)).to eq(1)#not_to be_nil
      end

      it 'Can list all shipping_methods' do
        expect(@client.shipping_methods.select).be eq(1)#not_to be_empty
      end

      it 'Can search shipping_methods' do
        expect(@client.shipping_methods.where({'id' => 1}).select).be eq(1)
        expect(@client.shipping_methods.where({:id => 1}).select).be eq(1)
        expect(@client.shipping_methods.where('id= 1 ').select).be eq(1)
      end
    end

    context 'SKU' do
      it 'Can find an sku' do
        expect(@client.skus.find(1)).to eq(1)#not_to be_nil
      end

      it 'Can list all skus' do
        expect(@client.skus.select).be eq(1)#not_to be_empty
      end

      it 'Can search skus' do
        expect(@client.skus.where({'id' => 1}).select).be eq(1)
        expect(@client.skus.where({:id => 1}).select).be eq(1)
        expect(@client.skus.where('id= 1 ').select).be eq(1)
      end

      xit 'Retrieve all inventory for a SKU.' do
        fail
      end
    end

    context 'SKU Inventory' do
      it 'Can find an sku_inventory' do
        expect(@client.sku_inventory.find(1)).to eq(1)#not_to be_nil
      end

      it 'Can list all sku_inventory' do
        expect(@client.sku_inventory.select).be eq(1)#not_to be_empty
      end

      it 'Can search sku_inventory' do
        expect(@client.sku_inventory.where({'id' => 1}).select).be eq(1)
        expect(@client.sku_inventory.where({:id => 1}).select).be eq(1)
        expect(@client.sku_inventory.where('id= 1 ').select).be eq(1)
      end
    end

    context 'SKU Vendor' do
      it 'Can list all sku_vendors' do
        expect(@client.sku_vendors.select).be eq(1)#not_to be_empty
      end

      it 'Can search sku_vendors' do
        expect(@client.sku_vendors.where({'id' => 1}).select).be eq(1)
        expect(@client.sku_vendors.where({:id => 1}).select).be eq(1)
        expect(@client.sku_vendors.where('id= 1 ').select).be eq(1)
      end
    end

    context 'State' do
      it 'Can find an state' do
        expect(@client.states.find(1)).to eq(1)#not_to be_nil
      end

      it 'Can list all states' do
        expect(@client.states.select).be eq(1)#not_to be_empty
      end

      it 'Can search states' do
        expect(@client.states.where({'id' => 1}).select).be eq(1)
        expect(@client.states.where({:id => 1}).select).be eq(1)
        expect(@client.states.where('id= 1 ').select).be eq(1)
      end
    end

    context 'Transfer' do
      it 'Can find an transfer' do
        expect(@client.transfers.find(1)).to eq(1)#not_to be_nil
      end

      it 'Can list all transfers' do
        expect(@client.transfers.select).be eq(1)#not_to be_empty
      end

      it 'Can search transfers' do
        expect(@client.transfers.where({'id' => 1}).select).be eq(1)
        expect(@client.transfers.where({:id => 1}).select).be eq(1)
        expect(@client.transfers.where('id= 1 ').select).be eq(1)
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
      it 'needs to be scaffolded and implemented' do
        fail
      end
    end

  end
end