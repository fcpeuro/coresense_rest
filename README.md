# coresense_rest
  
This is a fun little gem that tries to provide a simple object oriented access to the coresense api.
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