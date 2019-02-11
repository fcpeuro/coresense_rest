# coresense_rest
  
This is a fun little gem that tries to provide a simple object oriented access to the coresense api.

Implementation Caveat: This libarary does not offer support for multiple concurrent connections to different 
coresense servers, expecting only 1 base endpoint to be defined.
##Examples:

### Initialize a Client Object
```ruby
CoresenseRest::Client.host = 'Coresense Url'  
CoresenseRest::Client.user_id = 'USER ID'    
CoresenseRest::Client.key = 'KEY' 
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