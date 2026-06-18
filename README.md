# CoresenseRest

An [ActiveResource](https://github.com/rails/activeresource) client for the
**CoreSense CREST API** (`https://api-fcpuat.coresense.com/`). Every API
resource is exposed as a model under the `CoresenseRest` namespace.

The client normalizes two CREST-specific conventions that differ from
ActiveResource defaults:

| Convention            | ActiveResource default | CREST / this gem        |
| --------------------- | ---------------------- | ----------------------- |
| Collection path       | `/products` (plural)   | `/v1/product` (singular)|
| Format extension      | `/products.json`       | `/v1/product` (none)    |
| Auth                  | none                   | HS256 JWT minted per request, via `X-Auth-Token` + `Authorization: Bearer` |

## Installation

Add to your `Gemfile`:

```ruby
gem "coresense_rest"
```

Then `bundle install`.

## Configuration & auth

CREST authenticates with a short-lived **HS256 JWT** signed from a
CoreSense-provided `user_id` (the `sub` claim) and `sign_key` (the HMAC secret).
Give the gem those two values and it mints a fresh, unexpired token for **every
request** automatically — no manual token juggling:

```ruby
CoresenseRest.configure do |c|
  c.site          = "https://api-uat.coresense.com" # default
  c.api_version   = "v1"                                # default -> prefix "/v1/"
  c.user_id       = ENV["CORESENSE_USER_ID"]            # JWT `sub`
  c.sign_key      = ENV["CORESENSE_SIGN_KEY"]           # HMAC secret
  c.token_ttl     = 3600                                # default 1h (CREST max 1 day)
  c.jwt_algorithm = "HS256"                             # or HS384 / HS512
  # c.token = "<pre-built jwt>"   # alternative: supply a token directly
  # c.timeout = 30
  # c.logger  = Rails.logger
end
```

All settings fall back to environment variables, so no code is required when
these are present:

- `CORESENSE_SITE` (default `https://api-fcpuat.coresense.com`)
- `CORESENSE_API_VERSION` (default `v1`)
- `CORESENSE_USER_ID`, `CORESENSE_SIGN_KEY`
- `CORESENSE_TOKEN_TTL` (default `3600`), `CORESENSE_JWT_ALGORITHM` (default `HS256`)
- `CORESENSE_TOKEN` (optional pre-built token; overrides `user_id`/`sign_key`)

The minted token is sent on every request as both `X-Auth-Token: <token>` and
`Authorization: Bearer <token>`. You can also mint one directly:

```ruby
CoresenseRest::Token.generate(user_id: "...", sign_key: "...", ttl: 3600)
```

> **Security:** the `sign_key` is a secret. Supply `user_id`/`sign_key` via
> environment variables or a secrets manager — never commit them.

### Verifying resource slugs against the live API

A read-only script reconciles the manifest with the real route index. Run it
yourself so credentials stay on your machine:

```bash
export CORESENSE_USER_ID='...'
export CORESENSE_SIGN_KEY='...'
bundle exec ruby script/verify_routes.rb
```

It performs only `GET` requests and prints the live route list plus a sample
collection response so any incorrect slug can be fixed in the manifest.

## Usage

```ruby
# Collection (with CREST pagination / filtering / sorting)
CoresenseRest::Product.find(:all, params: { page: 1, page_size: 50 })
CoresenseRest::Product.find(:all, params: { q: "name=Brake Pad", order: "-stamp" })

# Single resource
product = CoresenseRest::Product.find(123)
product.name

# Create  ->  POST /v1/product
CoresenseRest::Product.create(name: "New Part")

# Update  ->  PUT /v1/product/123
product.name = "Updated"
product.save

# Delete  ->  DELETE /v1/product/123
product.destroy
```

CREST query features map onto the `params:` hash:

| Feature       | Param                                   |
| ------------- | --------------------------------------- |
| Pagination    | `page`, `page_size` (default 10, max 100) |
| Filtering     | `q` (operators `=`, `!=`, `<`, `<=`, `>`, `>=`) |
| Sorting       | `order` (prefix `-` to reverse)         |
| Field limiting| `fields` (regex supported)              |

## Available resources

All 73 top-level resources from the CREST `/v1/help/route` index are defined as
constants under `CoresenseRest` — e.g. `CoresenseRest::Order`,
`CoresenseRest::OrderItem`, `CoresenseRest::Sku`, `CoresenseRest::Shipment`,
`CoresenseRest::Customer`, `CoresenseRest::PurchaseOrder`, …

The full list and the exact URL slug each maps to lives in one place:
[`lib/coresense_rest/resources.rb`](lib/coresense_rest/resources.rb). The slugs
were verified against the live `/v1/help/route` index (api-fcpuat, 2026-06-17).
The CREST convention is **lowerCamelCase** (`/v1/orderItem`, `/v1/barcodeSku`),
with a few irregulars preserved verbatim (`/v1/reorder_point`,
`/v1/location_hierarchies`, `/v1/ShippingReturn`). Class names are the
PascalCase form of the slug, which is the single source of truth — correct a
path by editing its value in the manifest.

Nested-only resources (e.g. `purchaseOrderSku` under
`/v1/purchaseOrder/{id}/purchaseOrderSku/{id}`, or `subcategory`,
`featuredProduct`, `role`) are not defined as top-level classes; reach them via
their parent or a custom prefix.

## Extending a resource

Each resource is a real, reopenable class. Add associations or methods:

```ruby
module CoresenseRest
  class Order
    def order_items
      OrderItem.find(:all, params: { q: "order_id=#{id}" })
    end
  end
end
```

## Collection responses

CREST collection endpoints return a **bare JSON array** (confirmed against
`GET /v1/product` on api-fcpuat, 2026-06-17), which ActiveResource parses
natively — no custom format is required. Pagination is controlled via the
`page` / `page_size` request params (the metadata is conveyed in response
headers / `Link`, not a body envelope).

## Writes & server-owned fields

CREST rejects server-owned fields in request bodies:

- `id` → `code 1003` ("Field \"id\" may not be written to") — it belongs in the path
- `uri` → `code 1016` ("Invalid field provided") — it's returned by create responses

`CoresenseRest::Base` strips both from every encoded `POST`/`PUT` body
(`NON_WRITABLE_ATTRIBUTES`), so the normal ActiveResource flow works:

```ruby
c = CoresenseRest::Category.create(category: "New", active: true) # POST /v1/category
c.category = "Renamed"
c.save                                                            # PUT /v1/category/{id}
c.destroy                                                         # DELETE /v1/category/{id}
```

If you hit another `code 1016` on a resource that exposes additional read-only
fields, add them to `NON_WRITABLE_ATTRIBUTES` or pass `except:` to `encode`.

## Validated against the live API (api-fcpuat, 2026-06-17)

The integration suite (`spec/integration`, opt-in) was run against UAT:

- **Read** — `find` / `find(:all)` / pagination / sorting / `ResourceNotFound`
  pass across all listable resources. Note these API shapes, surfaced by the run:
  - Several **child collections return `null` (or 500) when listed unscoped**
    (e.g. `orderDeal`, `orderItemDeal`, `dealCouponCode`, `creditCardToken`,
    `productMarkdown`, `return`) — they require a parent filter/scope.
  - `GET /v1/reorder_point/{id}` returns **405** (collection-only).
  - `GET /v1/skuVendor/{sku_id}` is a **foreign-key-scoped collection**, not a
    single-record fetch, so `find(id)` does not apply.
- **Write** — a full `create → update → delete` round-trip was validated against
  `Category`, including automatic cleanup.

## Development

```bash
bundle install
bundle exec rspec          # hermetic unit specs (WebMock-stubbed, no token)
```

The default run is fully stubbed — no live API calls or credentials.

### Integration specs (live, opt-in)

```bash
export CORESENSE_USER_ID='...' CORESENSE_SIGN_KEY='...'

# read-only coverage across all resources
CORESENSE_RUN_INTEGRATION=1 bundle exec rspec spec/integration/live_api_spec.rb

# write round-trip (create -> update -> delete); defaults to Category, always
# cleans up. Override target via CORESENSE_WRITE_RESOURCE/_PAYLOAD/_UPDATE.
CORESENSE_RUN_INTEGRATION=1 CORESENSE_RUN_WRITE=1 \
  bundle exec rspec spec/integration/write_api_spec.rb
```

Helper scripts (read-only): [`script/verify_routes.rb`](script/verify_routes.rb)
(reconcile manifest vs live routes), [`script/writable_resources.rb`](script/writable_resources.rb)
(resources supporting create+delete), [`script/inspect_resource.rb`](script/inspect_resource.rb)
(show a resource's fields).

## License

MIT
