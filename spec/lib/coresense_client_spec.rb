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

      it 'Can search affiliates affiliates' do
        fail
      end
    end

    context 'Barcode' do
      it 'needs to be scaffolded and implemented' do
        fail
      end
    end

    context 'BarcodeSKU' do
      it 'needs to be scaffolded and implemented' do
        fail
      end
    end

    context 'Brand' do
      it 'needs to be scaffolded and implemented' do
        fail
      end
    end

    context 'Category' do
      it 'needs to be scaffolded and implemented' do
        fail
      end
    end

    context 'Channel' do
      it 'needs to be scaffolded and implemented' do
        fail
      end
    end

    context 'Help' do
      it 'needs to be scaffolded and implemented' do
        fail
      end
    end

    context 'Contacts' do
      it 'needs to be scaffolded and implemented' do
        fail
      end
    end

    context 'Customers' do
      it 'needs to be scaffolded and implemented' do
        fail
      end
    end

    context 'Help' do
      it 'needs to be scaffolded and implemented' do
        fail
      end
    end

    context 'Inventory' do
      it 'needs to be scaffolded and implemented' do
        fail
      end
    end

    context 'Location' do
      it 'needs to be scaffolded and implemented' do
        fail
      end
    end

    context 'LocationType' do
      it 'needs to be scaffolded and implemented' do
        fail
      end
    end

    context 'Manufacturer' do
      it 'needs to be scaffolded and implemented' do
        fail
      end
    end

    context 'Order' do
      it 'needs to be scaffolded and implemented' do
        fail
      end
    end

    context 'Product' do
      it 'needs to be scaffolded and implemented' do
        fail
      end
    end

    context 'ProductPrice' do
      it 'Get a ProductPrice' do
        fail
      end
    end

    context 'ReceivableType' do
      it 'needs to be scaffolded and implemented' do
        fail
      end
    end

    context 'Receiver' do
      it 'needs to be scaffolded and implemented' do
        fail
      end
    end

    context 'Shipment' do
      it 'needs to be scaffolded and implemented' do
        fail
      end
    end

    context 'ShipmentBox' do
      it 'needs to be scaffolded and implemented' do
        fail
      end
    end

    context 'ShippingMethod' do
      it 'needs to be scaffolded and implemented' do
        fail
      end
    end

    context 'SKU' do
      it 'needs to be scaffolded and implemented' do
        fail
      end
    end

    context 'SKU Inventory' do
      it 'needs to be scaffolded and implemented' do
        fail
      end
    end

    context 'SKU Vendor' do
      it 'needs to be scaffolded and implemented' do
        fail
      end
    end

    context 'SKU Vendor' do
      it 'needs to be scaffolded and implemented' do
        fail
      end
    end

    context 'State' do
      it 'needs to be scaffolded and implemented' do
        fail
      end
    end

    context 'Transfer' do
      it 'needs to be scaffolded and implemented' do
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