# coresense_rest
  
This is a fun little gem that tries to provide a simple object oriented access to the coresense api.

Implementation Caveat: This libarary does not offer support for multiple concurrent connections to different 
coresense servers, expecting only 1 base endpoint to be defined.
##Examples:

### Initialize a Client Object
```ruby
@host = 'Coresense Url'  
@user_id = 'USER ID'    
@key = 'KEY'    
@client = Client.new(@host, @user_id, @key)
```
### Resources
#### Affiliates
##### Find an Affiliate
```ruby
@client.affiliates.find(1)
```
##### Search Affiliates 
```ruby
@client.affiliates.select
@client.affiliates.where({'id' => 1}).select
@client.affiliates.where('id= 1 ').select
```