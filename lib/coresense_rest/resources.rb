# frozen_string_literal: true

require_relative "base"

module CoresenseRest
  # Every top-level CREST resource, mapped to the exact URL slug used in its
  # path:  CoresenseRest::Product -> /v1/product, CoresenseRest::OrderItem ->
  # /v1/orderItem.
  #
  # These slugs were verified against the live /v1/help/route index
  # (api-fcpuat, 2026-06-17). The CREST convention is lowerCamelCase, with a
  # handful of irregulars preserved verbatim:
  #
  #   * "reorder_point", "location_hierarchies", "location_hierarchy_types"
  #     use snake_case (and the last two are plural)
  #   * "ShippingReturn" is the lone PascalCase slug
  #
  # Class names are the PascalCase form of the slug (a 1:1 mapping), so the slug
  # is the single source of truth -- correct a path by editing its value here.
  #
  # NOTE: nested-only resources are intentionally NOT defined as top-level
  # classes (e.g. purchaseOrderSku is reached via
  # /v1/purchaseOrder/{id}/purchaseOrderSku/{id}, and subcategory/featuredProduct
  # /role/etc. are sub-resources). Access them through their parent or with a
  # custom prefix. To customize/extend a resource, just reopen it:
  #
  #   module CoresenseRest
  #     class Order
  #       def items
  #         OrderItem.find(:all, params: { q: "order_id=#{id}" })
  #       end
  #     end
  #   end
  RESOURCES = {
    "Affiliate"                      => "affiliate",
    "Barcode"                        => "barcode",
    "BarcodeSku"                     => "barcodeSku",
    "Brand"                          => "brand",
    "Category"                       => "category",
    "Channel"                        => "channel",
    "Comment"                        => "comment",
    "CommentCode"                    => "commentCode",
    "Contact"                        => "contact",
    "Country"                        => "country",
    "CreditCard"                     => "creditCard",
    "CreditCardToken"                => "creditCardToken",
    "Customer"                       => "customer",
    "CustomerCredit"                 => "customerCredit",
    "Deal"                           => "deal",
    "DealCouponCode"                 => "dealCouponCode",
    "Inventory"                      => "inventory",
    "InventoryAdjustment"            => "inventoryAdjustment",
    "Location"                       => "location",
    "LocationHierarchies"            => "location_hierarchies",
    "LocationHierarchyTypes"         => "location_hierarchy_types",
    "LocationType"                   => "locationType",
    "Manufacturer"                   => "manufacturer",
    "MasterPurchaseOrder"            => "masterPurchaseOrder",
    "MerchandiseHierarchies"         => "merchandiseHierarchies",
    "ModelStock"                     => "modelStock",
    "ModelStockLevel"                => "modelStockLevel",
    "ModelStockLocation"             => "modelStockLocation",
    "NeededItem"                     => "neededItem",
    "Order"                          => "order",
    "OrderAdjustment"                => "orderAdjustment",
    "OrderDeal"                      => "orderDeal",
    "OrderFulfillment"               => "orderFulfillment",
    "OrderItem"                      => "orderItem",
    "OrderItemAdjustment"            => "orderItemAdjustment",
    "OrderItemDeal"                  => "orderItemDeal",
    "OrderItemSalesTaxModifierType"  => "orderItemSalesTaxModifierType",
    "OrderItemShippingDetail"        => "orderItemShippingDetail",
    "OrderShippingDetail"            => "orderShippingDetail",
    "OrderStatus"                    => "orderStatus",
    "OrderVoid"                      => "orderVoid",
    "Payment"                        => "payment",
    "PriceAdjustmentType"            => "priceAdjustmentType",
    "Product"                        => "product",
    "ProductConfigurationOption"     => "productConfigurationOption",
    "ProductConfigurationOptionType" => "productConfigurationOptionType",
    "ProductInventory"               => "productInventory",
    "ProductInventoryStandard"       => "productInventoryStandard",
    "ProductInventoryUpgrade"        => "productInventoryUpgrade",
    "ProductMarkdown"                => "productMarkdown",
    "ProductPrice"                   => "productPrice",
    "PurchaseOrder"                  => "purchaseOrder",
    "ReceivableType"                 => "receivableType",
    "Receiver"                       => "receiver",
    "Reordering"                     => "reordering",
    "ReorderPoint"                   => "reorder_point",
    "Return"                         => "return",
    "SavedPurchaseOrder"             => "savedPurchaseOrder",
    "Shipment"                       => "shipment",
    "ShipmentBox"                    => "shipmentBox",
    "ShipmentPickerPacker"           => "shipmentPickerPacker",
    "ShippingMethod"                 => "shippingMethod",
    "ShippingReturn"                 => "ShippingReturn",
    "Sku"                            => "sku",
    "SkuInventory"                   => "skuInventory",
    "SkuVendor"                      => "skuVendor",
    "State"                          => "state",
    "Transfer"                       => "transfer",
    "User"                           => "user",
    "UserAccount"                    => "userAccount",
    "Vendor"                         => "vendor",
    "Warehouse"                      => "warehouse",
    "WebData"                        => "webData"
  }.freeze

  # Define a concrete ActiveResource subclass for each resource. Each becomes a
  # real constant (CoresenseRest::Product, ...) that can be reopened/extended.
  RESOURCES.each do |class_name, slug|
    next if const_defined?(class_name, false)

    klass = const_set(class_name, Class.new(Base))
    klass.element_name = slug
  end
end
