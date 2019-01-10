module CoresenseRest

  class Affiliate < Resource
    extend Findable
    extend Searchable
    attr_accessor :active,:address1,:address2,:city,:commission_rate_id,:company_name,
                  :contact_first_name,:contact_last_name,:country_id,:email,:fax,:id,
                  :password,:payment_notification_template_id,:phone,:sale_notification,
                  :sale_notification_template_id, :state_id, :url,:username, :zip
  end

  class Barcode < Resource
    extend Searchable
    extend Findable
  end

  class BarcodeSKU < Resource
    extend Searchable
    extend Findable
  end

  class Brand < Resource
    extend Searchable
    extend Findable
  end

  class Category < Resource
    extend Searchable
    extend Findable
  end

  class Channel < Resource
    extend Searchable
    extend Findable
  end

  class Contact < Resource
    extend Searchable
    extend Findable
  end

  class Country < Resource
    extend Searchable
    extend Findable
  end

  class Customer < Resource
    extend Searchable
    extend Findable
  end

  class Help < Resource
  end

  class Inventory < Resource
    extend Searchable
    extend Findable
  end

  class Location < Resource
    extend Searchable
    extend Findable
  end

  class LocationType < Resource
    extend Searchable
    extend Findable
  end

  class Manufacturer < Resource
    extend Searchable
    extend Findable
  end

  class Order < Resource
    extend Searchable
    extend Findable
  end

  class Product < Resource
    include Searchable
    include Findable
  end

  class ProductPrice < Resource
    extend Findable
  end

  class ReceivableType < Resource
    extend Searchable
    extend Findable
  end

  class Receiver < Resource
    extend Searchable
    extend Findable
  end

  class Shipment < Resource
    extend Searchable
    extend Findable
  end

  class ShipmentBox < Resource
    extend Searchable
    extend Findable
  end

  class ShippingMethod < Resource
    extend Searchable
    extend Findable
  end

  class SKU < Resource
    extend Searchable
    extend Findable
  end

  class SkuInventory < Resource
    extend Searchable
    extend Findable
  end

  class SkuVendor < Resource
    extend Searchable
    #extend Findable #Since the id driven get returns a list and not the id of the resource, this does not have parity with AR's find function, opting to not implement
  end

  class State < Resource
    extend Searchable
    extend Findable
  end

  class Transfer < Resource
    extend Searchable
    extend Findable
  end

  class Warehouse < Resource
    extend Findable
  end
end