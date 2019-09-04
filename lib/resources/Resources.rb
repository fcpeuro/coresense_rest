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
    attr_accessor :barcode, :id, :product_id, :stamp
  end

  class BarcodeSKU < Resource
    extend Searchable
    extend Findable
    self.endpoint_override = 'barcodeSku'
    attr_accessor :barcode_id, :id, :quantity, :sku_id
  end

  class Brand < Resource
    extend Searchable
    extend Findable
    attr_accessor :custom_address, :custom_company_name, :custom_logo_url, :custom_main_email_address,
                  :custom_main_fax, :custom_main_phone, :custom_payment_processor_statement_description,
                  :custom_web_site_url, :fully_shipped_email_template, :id, :label, :partially_shipped_email_template,
                  :status, :website_gift_certificate_template
  end

  class Category < Resource
    extend Searchable
    extend Findable
    extend Creatable
    attr_accessor :active, :category, :custom_breadcrumb_parent, :custom_header_html, :custom_header_title,
                  :custom_position, :custom_thumbnail_image, :default_product_type, :description, :homepage_active,
                  :id, :label, :meta_abstract, :meta_description, :meta_keywords, :meta_title, :page_title,
                  :powerreviews_active, :root, :website_display_name
  end

  class Channel < Resource
    extend Searchable
    extend Findable
    attr_accessor :access_level, :brand_id, :channel_type, :data_table, :default_payment_processor_id,
                  :icon_location, :id, :label, :module_location, :module_type, :record_table, :tax_exempt_allowed,
                  :shippo_account_id
  end

  class Contact < Resource
    extend Searchable
    extend Findable
    extend Creatable
    attr_accessor :active, :address_line_1, :address_line_2, :business_phone, :city, :company, :country_id,
                  :customer_id, :date_of_birth, :email, :fax, :first_name, :id, :label, :last_name, :phone,
                  :postal_code, :requires_liftgate, :residential_address, :state_id, :verified
  end

  class Country < Resource
    extend Searchable
    extend Findable
    attr_accessor :code_iso_alpha_2, :code_iso_alpha_3, :code_un_numeric, :country, :id
  end

  class Customer < Resource
    extend Searchable
    extend Findable
    extend Creatable
    attr_accessor :id, :affiliate_id, :client_id, :currency_rate, :custom_account_manager,
                  :custom_attend_a_pop_trunk_show, :custom_box_number, :custom_customer_type,
                  :custom_default_payment_type, :custom_guest_shopper, :custom_host_a_pop_trunk_show,
                  :custom_school_address2, :custom_send_news_and_promotions, :custom_wishlist_temp_order_num,
                  :customer_billing_exported, :customer_shipping_exported, :customer_tier_id,
                  :default_billing_contact_id, :default_preorder_contact_id, :default_shipping_contact_id,
                  :employee_number, :last_key_code, :last_modified, :originating_brand_id,
                  :product_upsell_last_sent, :source_code, :stamp,
                  :custom_blocked, :custom_campaign_opt_in, :custom_channel

    def default_billing_contact
      Contact.find(default_billing_contact_id)
    end

    def default_shipping_contact
      Contact.find(default_shipping_contact_id)
    end

    def contacts
      RequestRead.new(Customer.full_path + '/' + id.to_s + '/contact', Contact.headers, Contact).select
    end
  end

  class Help < Resource
  end

  class Inventory < Resource
    extend Searchable
    extend Findable
    attr_accessor :assoc_entity, :assoc_entity_id, :build_type, :cogs,
        :description, :id, :inventory_id, :inventory_location_id, :manufacturer_id,
        :pos_order_num, :shipping_depth, :shipping_height, :shipping_weight, :shipping_width,
        :stamp, :status, :vendor_id, :warehouse_id
  end

  class Location < Resource
    extend Searchable
    extend Findable
    attr_accessor :active, :available_for_fulfillment, :description, :height, :id,
                  :inventory_location_type_id, :is_distribution_staging, :label,
                  :length, :parent_id, :stamp, :warehouse_id, :width
  end

  class LocationType < Resource
    extend Searchable
    extend Findable
    attr_accessor :depth, :description, :height, :id, :label, :warehouse_id, :width
  end

  class Manufacturer < Resource
    extend Searchable
    extend Findable
    attr_accessor :id, :name, :stamp
  end

  class OrderAdjustment < Resource
    extend Searchable
    extend Findable
    extend Creatable
    attr_accessor
  end

  class OrderFulfillment < Resource
    #action endpoint, use to fulfill orders
    attr_accessor
  end

  class OrderItemAdjustment < Resource
    extend Searchable
    extend Findable
    extend Creatable
    attr_accessor
  end

  class OrderItemDeal < Resource
    extend Searchable
    extend Findable
    attr_accessor
  end

  class OrderItem < Resource
    extend Searchable
    extend Findable
    attr_accessor
  end

  class OrderItemSalesTaxModifierType < Resource
    extend Searchable
    extend Findable
    attr_accessor
  end

  class Order < Resource
    extend Searchable
    extend Findable
    extend Creatable
    attr_accessor :id, :affiliate_id, :amazon_customer_id, :amazon_order_id, :amt_paid,
                  :billing_contact_id, :cancelled, :checked_out, :client_id, :closed,
                  :club_cc_reauthorization_sent, :cogs, :comments, :compliant,
                  :custom_fraudulent, :due_date, :google_financial_status,
                  :google_fulfillment_status, :google_order_num, :grand_total,
                  :ip_address, :key_code, :layaway_expiration_date, :layaway_policy_id,
                  :layaway_status, :locked, :mail_code, :order_exported, :order_num,
                  :order_status, :originating_brand_id, :originating_channel_id,
                  :originating_club_delivery_id, :originating_club_membership_id,
                  :paid_stamp, :payment_invoice_number, :payment_type, :personalization,
                  :refund_total, :salesman, :shipping_cost, :shipping_tax_total, :stamp,
                  :total, :viewed
    def shipments
      RequestRead.new( "#{Order.full_path}/#{id}/shipment", Product.headers, Shipment).select
    end
  end

  class OrderShippingDetail < Resource
    extend Searchable
    extend Findable
    attr_accessor :delayed_delivery_date, :estimated_delivery_date, :estimated_shipping_date, :id, :order_num,
                  :pickup_warehouse_id, :saved_shipping_tax_rate, :shipping_contact_id, :shipping_cost,
                  :shipping_method_id
  end

  class Payment < Resource
    extend Searchable
    extend Findable
    extend Creatable
    attr_accessor :assoc_entity, :assoc_entity_id, :payment, :receivable_type_id, :user, :client_id
  end

  class ProductConfigurationOption < Resource
    extend Searchable
    extend Findable
    attr_accessor :active, :cost, :id, :is_default, :label, :large_image, :legacy_option_id, :legacy_option_type_id,
                  :main_image, :position, :price, :product_configuration_option_type_id, :product_id, :stamp,
                  :swatch_image, :thumbnail_image, :weight
  end

  class ProductConfigurationOptionType < Resource
    extend Searchable
    extend Findable
    attr_accessor :id, :label, :order_data_field, :web_display_text
  end

  class ProductInventory < Resource
    extend Searchable
    extend Findable
    attr_accessor :active, :id, :inventory_type_id, :model_id, :quantity, :stamp, :type
  end

  class ProductInventoryStandard < Resource
    extend Searchable
    extend Findable
    attr_accessor :id, :option_id, :product_inventory_id, :active
  end

  class ProductInventoryUpgrade < Resource
    extend Searchable
    extend Findable
    attr_accessor :id, :option_id, :product_inventory_id, :active
  end

  class Product < Resource
    extend Searchable
    extend Findable
    attr_accessor :base_price, :default_base_cogs, :default_fulfillment, :default_needs_own_box,
                  :default_shipping_depth, :default_shipping_height, :default_shipping_method_id,
                  :default_shipping_weight, :default_shipping_width, :default_vendor_id, :description,
                  :digital_expiration_days, :digital_maximum_downloads, :globalshopex_country_of_origin,
                  :globalshopex_restricted, :grid_id, :id, :image_location, :last_modified_stamp,
                  :last_onthefly_id, :manufacturer_id, :media_enabled, :minimum_advertised_price,
                  :minimum_advertised_price_display, :name, :needs_own_box, :non_inventory, :part_num,
                  :personalization_image_uri, :personalization_template_id, :powerreviews_qa,
                  :powerreviews_rating, :powerreviews_reviews, :pre_order, :pre_order_available_date,
                  :pre_order_deadline, :pre_order_sale_date, :pricing_group_id, :product_class,
                  :production_time, :replaces, :sku_generation, :style_locator, :supports_recurring_orders,
                  :tax_code, :type, :void

    def product_prices(channel_id)
      RequestRead.new( "#{ProductPrice.full_path}/#{id}/channel/#{channel_id}", Product.headers, ProductPrice).select
    end
  end

  class ProductPrice < Resource
    attr_accessor :base_price, :base_price_after_rebate, :minimum_advertised_price, :rebate_amount
  end

  class ReceivableType < Resource
    extend Searchable
    extend Findable
    attr_accessor :abbrev, :class, :default_payment_processor_id, :id, :label, :payment_type_id
  end

  class Receiver < Resource
    extend Searchable
    extend Findable
    extend Creatable
    attr_accessor :comment, :exported, :id, :master_receiving_document_id, :stamp, :status
  end

  class Shipment < Resource
    extend Searchable
    extend Findable
    attr_accessor :arrival_date, :assoc_entity, :assoc_entity_id, :carrier_account_id,
                  :cod_tracking_num, :cost, :destination, :destination_id, :exported, :id,
                  :method_id, :needs_recalculation, :picked_up_date, :ship_date,
                  :smartpost_tracking_num, :source, :source_id, :stamp, :status, :tracking_num,
                  :transit_time, :validated, :workflow_state_id
  end

  class ShipmentBox < Resource
    extend Searchable
    extend Findable
    attr_accessor :depth, :height, :id, :shipment_id, :tracking_num, :weight, :width
  end

  class ShippingMethod < Resource
    extend Searchable
    extend Findable
    attr_accessor :active, :carrier_method_id, :cod, :code, :exclude_product, :force_volume_packing,
                  :handling_charge, :handling_charge_type_id, :id, :label, :malvern_method, :pos_method,
                  :production_cutoff_time, :production_time, :saturday_delivery, :shipping_cutoff_time,
                  :trueship_method, :type,
                  :export_to_worldship, :one_rate, :pickup, :shippo_method, :valid_for_po_apo_fpo
  end

  class Sku < Resource
    extend Searchable
    extend Findable
    attr_accessor :build_type, :default_product_id, :default_shipping_method_id,
                  :default_vendor_id, :description, :discontinued, :ean, :freight_class,
                  :generation, :id, :internal_sku, :isbn, :label, :manufacturer_id, :mpn,
                  :needs_own_box, :shipping_delivery_signature_type_id, :shipping_depth,
                  :shipping_height, :shipping_liftgate_delivery_required, :shipping_weight,
                  :shipping_width, :stamp, :upc
  end

  class SkuInventory < Resource
    extend Searchable
    #extend Findable #Since the id driven get returns a list and not the id of the resource, this does not have parity with AR's find function, opting to not implement
    attr_accessor :location_id, :quantity, :sku_id, :status, :warehouse_id
  end

  class SkuVendor < Resource
    extend Searchable
    #extend Findable #Since the id driven get returns a list and not the id of the resource, this does not have parity with AR's find function, opting to not implement
    attr_accessor :default_cost, :discount_percent, :drop_ship_cost, :id, :replenishment_cost,
                  :sku_id, :stamp, :status, :stock_qty, :stock_type, :vendor_id, :vendor_sku
  end

  class State < Resource
    extend Searchable
    extend Findable
    attr_accessor :id, :state, :state_code
  end

  class Transfer < Resource
    extend Searchable
    extend Findable
    extend Creatable
    attr_accessor :close_date, :destination_sublocation_id, :destination_warehouse_id,
                  :distribution_purchase_order_id ,:id, :issue_date, :medium, :medium_id,
                  :notes, :shipping_method_id, :source_sublocation_id, :source_warehouse_id,
                  :status, :transfer_reason_code_id, :verified
  end

  class Warehouse < Resource
    extend Findable
    extend Searchable
    attr_accessor :available_for_fulfillment, :default_damaged_inventory_location_id, :distribution_center_id,
                  :fedex_smartpost_hub_id, :fulfillment_priority, :id, :is_distribution_center, :label,
                  :lat, :location_hierarchy_id, :lon, :main_fax, :main_phone, :requires_liftgate,
                  :ship_address1, :ship_address2, :ship_city, :ship_country, :ship_state, :ship_zip,
                  :timezone, :type
  end
end