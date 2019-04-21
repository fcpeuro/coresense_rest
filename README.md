# coresense_rest
  
This is a fun little gem that tries to provide a simple object oriented access to the coresense api.

Implementation Caveat: This libarary does not offer support for multiple concurrent connections to different 
coresense servers, expecting only 1 base endpoint to be defined.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'coresense_rest', github: 'coresense_rest'
```


##Examples:

### Configure the Coresense Connection
```ruby
CoresenseRest.configure do |config|
    config.host = '<CORESENSE URL>'
    config.user_id = '<USER ID>'
    config.key = '<KEY>'
end
```
### Resources
#### Affiliates
##### Find an Affiliate
```ruby
CoresenseRest::Client.find(1)
```
##### Search Affiliates 
```ruby
CoresenseRest::Client.select
CoresenseRest::Client.where({'id' => 1}).select
CoresenseRest::Client.where('id= 1 ').select
```


# Riskified API Client

Ruby client for the [Riskified API](https://apiref.riskified.com) using [Faraday](https://github.com/technoweenie/faraday).  Ruby > 2.0 is required.

## Installation

Add this line to your application's Gemfile:

    $ gem 'riskified_ruby', github: 'fcpeuro/riskified_ruby'

## Usage

### API keys

Credentials must be configured before you make API calls using the gem.

```ruby
Riskified.configure do |config|
  config.auth_token = 'rw342fdj534'
  config.default_referrer = 'www.example.com'
  config.sandbox_mode = true
end
```

* `config.auth_token` - your Riskified access key
* `config.default_referrer` - Default referrer
* `config.sandbox_mode` - Decide whether or not to use the sandbox endpoint

The keys are available to you throughout your application as:

```ruby
Riskified.configuration.auth_token
Riskified.configuration.default_referrer
Riskified.configuration.sandbox_mode
```

### Creating the client

```ruby
client = Riskified::Client.new
client.checkout_create(order)
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request