---
layout: post
title:  "Net::HTTP versus HTTParty"
---

A short comparison of the pros and cons of two popular libraries for making HTTP requests in Ruby: `Net::HTTP` and `HTTParty`. These libraries serve similar purposes but have some differences in terms of ease of use, features, and community support.

### Net::HTTP

Pros:

Built-in: Net::HTTP is part of the Ruby standard library, you don't need to install any additional gems to use it!

```ruby
require 'net/http'

uri = URI('https://api.example.com/data')
http = Net::HTTP.new(uri.host, uri.port)
request = Net::HTTP::Get.new(uri)
response = http.request(request)
```

Low-Level Control: It provides low-level control over HTTP requests and responses, allowing you to customize requests in detail.
```ruby
# Custom headers and body
request = Net::HTTP::Post.new(uri)
request['Content-Type'] = 'application/json'
request.body = JSON.generate({ 'key' => 'value' })

# Handling redirects manually
http.max_redirects = 0

# Accessing response details
response = http.request(request)
status_code = response.code
```

Performance: Since it's part of the standard library, it may be slightly faster than external gems like HTTParty because it doesn't have the overhead of gem loading.

Cons:

Complexity: It can be more complex to use, especially for simple HTTP requests. Building requests, handling responses, and managing error cases can require more code compared to higher-level libraries.

```ruby
# Handling redirects manually
http = Net::HTTP.new(uri.host, uri.port)
request = Net::HTTP::Get.new(uri)
response = http.request(request)

if response.code == '301' || response.code == '302'
  # Handle redirects manually by extracting the 'Location' header
  new_location = response['Location']
  # Make a new request to the new location...
end
```

Verbose: Writing code with Net::HTTP can be verbose and may require boilerplate code for common tasks like JSON parsing and error handling.

Limited Features: It lacks some convenient features provided by higher-level libraries, such as automatic JSON parsing, response handling, and exception handling for common HTTP errors.

```ruby
# No automatic JSON parsing
response = http.request(request)
json_data = JSON.parse(response.body)
```

### HTTParty

Pros:

Simplicity: HTTParty is designed to simplify making HTTP requests in Ruby. It provides a more intuitive and user-friendly API for making HTTP requests.

Concise Code: It reduces boilerplate code, making it easier to read and maintain. For example, it can automatically parse JSON responses into Ruby objects.

```ruby
require 'httparty'

response = HTTParty.get('https://api.example.com/data')
# Automatic JSON parsing
json_data = response.parsed_response
```

Built-in Error Handling: It offers built-in error handling for common HTTP errors, making it easier to handle exceptions.

```ruby
begin
  response = HTTParty.get('https://api.example.com/nonexistent-endpoint')
  json_data = response.parsed_response
rescue HTTParty::ResponseError => e
  puts "HTTP error: #{e.message}"
end
```

Middleware: HTTParty allows you to define custom middleware to intercept and modify requests and responses, adding flexibility to the library.

Active Community: It has an active community, which means you can find plenty of resources, documentation, and third-party extensions to enhance its functionality.

Cons:

External Dependency: You need to add HTTParty as a gem dependency to your project, which may introduce some overhead in terms of gem management and updates.

Less Low-Level Control: While it provides a simpler and more convenient API, it may not offer the same level of low-level control over HTTP requests as Net::HTTP. If you have very specific requirements, you might need to work around its abstractions.

### Conclusion
The choice between Net::HTTP and HTTParty depends on your project's requirements and your preference for simplicity versus low-level control.

### BONUS - Track-POD implementation

The implementation for a logistics project that requested integrating with [Track-POD](https://www.track-pod.com/) required simplicity for the sake of time and the lack of need for low-level control. 

It could:

- be added at: `lib/classes/transport.rb`
- in the controller: `require 'classes/transport'` 
- in the method: `trackpod = TrackPod.new` with `response = trackpod.add_transport(@order)`

```ruby
class TrackPod
  include HTTParty
  base_uri 'https://api.track-pod.com'

  def initialize
    api_key = ''
    @auth = { "X-Api-Key" => "#{api_key}", "Content-Type" => "application/json"}
  end

  def add_transport(order)
    sanitize_credentials(order)
    sanitize_goodslist(order)
    post_order(@client, @address, @contact_name, @phone, @email, @goodslist)
  end

  def sanitize_credentials(order)
    # some code e.g.
    @client = order.shipping_address.name
  end

  def sanitize_goodslist(order)
    @goodslist = Array.new
    order.order_items.each do |item|
      @goodslist << { 
        # some code e.g.
        GoodsName: item.product.name, 
      }
    end
  end

  def post_order(client, address, contact_name, phone, email, goodslist)
    body = { 
      # some code e.g.
      "Client" => client
    }.to_json

    options = { headers: @auth, body: body}
    self.class.post('/order', options)
  end
end
```