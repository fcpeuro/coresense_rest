#3rd Party Libs
require 'openssl'
require 'json'
require "base64"
require 'jwt'
require 'httparty'
#Base Class
require_relative 'resources/Request'
#Functional Modules
require_relative 'resources/Findable'
require_relative 'resources/Searchable'
#Resource Definitions
require_relative 'resources/Resource'
require_relative 'resources/Resources'

module CoresenseRest
  class Client

    def initialize(host, user_id, key)
      @host = host
      @token = get_token user_id, key
      @affiliate = Affiliate.new(@host, @token)
      @barcode = Barcode.new(@host, @token)
      @barcode_sku = BarcodeSKU.new(@host, @token)
      @brand = Brand.new(@host, @token)
      @category = Category.new(@host, @token)
      @channel = Channel.new(@host, @token)
      @contact = Contact.new(@host, @token)
      @country = Country.new(@host, @token)
      @customer = Customer.new(@host, @token)
      @help = Help.new(@host, @token)
      @inventory = Inventory.new(@host, @token)
      @location = Location.new(@host, @token)
      @location_type = LocationType.new(@host, @token)
      @manufacturer = Manufacturer.new(@host, @token)
      @order = Order.new(@host, @token)
      @product = Product.new(@host, @token)
      @product_price = ProductPrice.new(@host, @token)
      @receivable_type = ReceivableType.new(@host, @token)
      @receiver = Receiver.new(@host, @token)
      @shipment = Shipment.new(@host, @token)
      @shipment_box = ShipmentBox.new(@host, @token)
      @shipping_method = ShippingMethod.new(@host, @token)
      @sku = SKU.new(@host, @token)
      @sku_inventory = SkuInventorySKU.new(@host, @token)
      @sku_vendor = SkuVendor.new(@host, @token)
      @state = State.new(@host, @token)
      @transfer = Transfer.new(@host, @token)
      @warehouse = Warehouse.new(@host, @token)
    end

    def affiliates
      @affiliate
    end

    def barcodes
      @barcode
    end

    def barcode_skus
      @barcode_sku
    end

    def brands
      @brand
    end

    def catergories
      @category
    end

    def channels
      @channel
    end

    def contacts
      @contact
    end

    def countries
      @country
    end

    def customers
      @customer
    end

    def help
      @help
    end

    def inventory_units
      @inventory
    end

    def locations
      @location
    end

    def location_types
      @location_type
    end

    def manufacturers
      @manufacturer
    end

    def orders
      @orders
    end

    def products
      @product
    end

    def receivable_types
      @receivable_type
    end

    def receivers
      @receiver
    end

    def shipments
      @shipment
    end

    def shipment_boxes
      @shipment_box
    end

    def shipping_methods
      @shipping_method
    end

    def skus
      @sku
    end

    def sku_inventory
      @sku_inventory
    end

    def sku_vendors
      @sku_vendor
    end

    def states
      @state
    end

    def transfers
      @transfer
    end

    def warehouses
      @warehouse
    end

    private

    def get_token(user_id, key)
      header = {
          'alg' => 'HS256'
      }
      payload = {
          'sub' => user_id,
          'exp' => Time.now.to_i + 3600,
      }

      t1 = Base64.urlsafe_encode64(header.to_json.encode("UTF-8"))
      t2 = Base64.urlsafe_encode64(payload.to_json.encode("UTF-8"))

      signeddata = t1 + '.' + t2
      signature = OpenSSL::HMAC.digest('SHA256', key, signeddata)
      t3 = Base64.urlsafe_encode64(signature)

      token = signeddata + '.' + t3
      token
    end

  end
end