---
layout: post
title: "Measuring Memory for Ruby Methods"
date: 2026-03-29
excerpt: "Use ObjectSpace.memsize_of_all to measure memory delta before and after a method runs. A real example: map on AR objects used 681 MB, pluck used 30 MB."
tags: [ruby, rails, performance, memory]
---

When a process uses more memory than expected, you need to know which method is
responsible. [`ObjectSpace.memsize_of_all`](#references) gives you a before/after delta.


## The Pattern

```ruby
require 'objspace'

GC.start
before = ObjectSpace.memsize_of_all
# ... run method here ...
after = ObjectSpace.memsize_of_all
puts "mem delta: #{((after - before) / 1024.0 / 1024.0).round(2)} MB"
```

[`GC.start`](#references) forces a garbage collection cycle before measuring so prior
allocations don't skew the result.


## A Real Example

Two approaches to build a list of 50,000 user records. Save as `measure_memory.rb`:

```ruby
require 'objspace'

# old approach - full AR objects with map
GC.start
before = ObjectSpace.memsize_of_all
scope = User.where.not(confirmed_at: nil).order(:id).limit(50000).offset(0)
out1 = scope.map { |u| { email: u.email, fields: { first_name: u.first_name.to_s } } }
after = ObjectSpace.memsize_of_all
puts "map (old): #{out1.size} records, mem delta: #{((after - before) / 1024.0 / 1024.0).round(2)} MB"

# new approach - pluck
GC.start
before = ObjectSpace.memsize_of_all
scope = User.where.not(confirmed_at: nil).order(:id).limit(50000).offset(0)
out2 = scope.pluck(:email, :first_name).map { |email, first_name| { email: email, fields: { first_name: first_name.to_s } } }
after = ObjectSpace.memsize_of_all
puts "pluck (new): #{out2.size} records, mem delta: #{((after - before) / 1024.0 / 1024.0).round(2)} MB"
```

Then run:

```bash
rails runner measure_memory.rb
```

Result:

```
map (old):    50000 records, mem delta: 681.47 MB
pluck (new):  50000 records, mem delta:  30.13 MB
```

`map` instantiates full ActiveRecord objects — each one carries attribute
hashes, dirty tracking, callbacks, and association caches. `pluck` returns
raw arrays with only the columns you asked for.

681 MB versus 30 MB. The fix is 22x more efficient.


## Why the Gap is so Large

`map` instantiates full ActiveRecord objects — each carries all columns, dirty
tracking, callbacks, and association caches — then extracts just two fields.
`pluck` issues a `SELECT email, first_name` and returns raw arrays with no AR
overhead.

Use `pluck` when you only need a few columns and don't need AR callbacks or
associations. Use `map` (or `find_each`) when you need the full object.


## References

- [ObjectSpace](https://docs.ruby-lang.org/en/master/ObjectSpace.html)
- [ObjectSpace.memsize_of_all](https://docs.ruby-lang.org/en/master/ObjectSpace.html#method-c-memsize_of_all)
- [GC](https://docs.ruby-lang.org/en/master/GC.html)
- [GC.start](https://docs.ruby-lang.org/en/master/GC.html#method-c-start)
