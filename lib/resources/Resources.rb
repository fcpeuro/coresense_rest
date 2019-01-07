module CoresenseRest

  class Affiliate < Resource
    include Searchable
    include Findable
  end

  class Barcode < Resource
    include Searchable
    include Findable
  end

  class BarcodeSKU < Resource
    include Searchable
    include Findable
  end

  class Brand < Resource
    include Searchable
    include Findable
  end

  class Category < Resource
    include Searchable
    include Findable
  end

  class Channel < Resource
    include Searchable
    include Findable
  end

  class Contact < Resource
    include Searchable
    include Findable
  end

  class Country < Resource
    include Searchable
    include Findable
  end

  class Customer < Resource
    include Searchable
    include Findable
  end

  class Help < Resource
  end

  class Inventory < Resource
    include Searchable
    include Findable
  end

  class Location < Resource
    include Searchable
    include Findable
  end

  class LocationType < Resource
    include Searchable
    include Findable
  end

  class Manufacturer < Resource
    include Searchable
    include Findable
  end

  class Order < Resource
    include Searchable
    include Findable
  end

  class Product < Resource
    include Searchable
    include Findable
  end

  class ProductPrice < Resource
    include Findable
  end

  class ReceivableType < Resource
    include Searchable
    include Findable
  end

  class Receiver < Resource
    include Searchable
    include Findable
  end

  class Shipment < Resource
    include Searchable
    include Findable
  end

  class ShipmentBox < Resource
    include Searchable
    include Findable
  end

  class ShippingMethod < Resource
    include Searchable
    include Findable
  end

  class SKU < Resource
    include Searchable
    include Findable
  end

  class SkuInventory < Resource
    include Searchable
    include Findable
  end

  class SkuVendor < Resource
    include Searchable
    #include Findable #Since the id driven get returns a list and not the id of the resource, this does not have parity with AR's find function, opting to not implement
  end

  class State < Resource
    include Searchable
    include Findable
  end

  class Transfer < Resource
    include Searchable
    include Findable
  end

  class Warehouse < Resource
    include Findable
  end
end