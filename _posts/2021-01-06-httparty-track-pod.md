---
layout: post
title:  "How to send a POST request to an external API within an existing rails application? Bonus: Track-Pod example"
---

Pick a POST request solution `Net::HTTP` vs `HTTParty` [source](https://github.com/palkan/gem-check/blob/master/src/pages/en.md#api-design)

```ruby
# Net::HTTP get JSON with query string
uri = URI('http://example.com/index.json')
params = { limit: 10, page: 3 }
uri.query = URI.encode_www_form(params)

res = Net::HTTP.get_response(uri)
puts JSON.parse(res.body) if res.is_a?(Net::HTTPSuccess)

# HTTParty
puts HTTParty.get('http://example.com/index.json', limit: 10, page: 3)
```

HTTParty is the winner.

### Bonus

The implementation snippet of [Track-POD](https://www.track-pod.com/)

- can be added at: `lib/classes/transport.rb`
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