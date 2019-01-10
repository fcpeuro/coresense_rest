#3rd Party Libs
require 'openssl'
require 'json'
require "base64"
require 'jwt'
require 'httparty'
#Base Class
require_relative 'resources/Request_Read'
#Functional Modules
require_relative 'resources/Findable'
require_relative 'resources/Searchable'
#Resource Definitions
require_relative 'resources/Resource'
require_relative 'resources/Resources'

module CoresenseRest
  class Client

    class << self; attr_accessor :host, :user_id, :key end

=begin
    def affiliates
      Affiliate
    end

    def barcodes
      Barcode
    end

    def barcode_skus
      BarcodeSKU
    end

    def brands
      Brand
    end

    def catergories
      Category
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
=end

    def self.get_token
      header = {
          'alg' => 'HS256'
      }
      payload = {
          'sub' => self.user_id,
          'exp' => Time.now.to_i + 3600,
      }

      t1 = Base64.urlsafe_encode64(header.to_json.encode("UTF-8"))
      t2 = Base64.urlsafe_encode64(payload.to_json.encode("UTF-8"))

      signeddata = t1 + '.' + t2
      signature = OpenSSL::HMAC.digest('SHA256', self.key, signeddata)
      t3 = Base64.urlsafe_encode64(signature)

      token = signeddata + '.' + t3
      token
    end

  end
end