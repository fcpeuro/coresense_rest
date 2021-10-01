# coresense_rest
  
This is a fun little gem that tries to provide a simple object oriented access to the coresense api.

Implementation Caveat: This libarary does not offer support for multiple concurrent connections to different 
coresense servers, expecting only 1 base endpoint to be defined.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'coresense_rest', github: 'fcpeuro/coresense_rest'
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

#### Coresense API

* https://api-fcpuat.coresense.com/

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
