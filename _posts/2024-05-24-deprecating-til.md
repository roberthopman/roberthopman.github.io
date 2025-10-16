---
layout: post
title:  "T.I.L."
excerpt: "Today I Learned (TIL) is a collection of insights around debugging and prototyping."
tags: [ruby, debugging, prototyping, ai, til]
---

### General

<a href="https://ruby-doc.org/3.3.4/Kernel.html#method-i-tap">Kernel#tap</a> is a method that yields self to the block and returns self. It is useful for debugging or for chaining methods together.

{% highlight ruby %}
(1..10)
  .tap {|x| puts "original: #{x}" }
  .to_a
  .tap {|x| puts "array:    #{x}" }
  .select {|x| x.even? }
  .tap {|x| puts "evens:    #{x}" }
  .map {|x| x*x }
  .tap {|x| puts "squares:  #{x}" }

  # Output:
  # original: 1..10
  # array:    [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
  # evens:    [2, 4, 6, 8, 10]
  # squares:  [4, 16, 36, 64, 100]
  # => [4, 16, 36, 64, 100]
{% endhighlight %}

Fix failure due to architecture arm64:
{% highlight shell %}
bundle config build.gem_name "--with-cflags=-Wno-error=incompatible-function-pointer-types"
bundle install
{% endhighlight %}

### Prototyping with AI

- Create a new directory for a prototype
- Copy paste the requirements text to a spec.md file
- Based on the spec.md, let the AI agent create a single file
- Add gitignore with spec* (there might be more spec files)
- Git init, add, commit with message "Initial commit"

Build with the AI agent to complete a single new feature: 
- When it doesn't work, fix manually if it's a small change, otherwise ask it to fix the issue
- When it works, ask it to append the functionality to the spec.md file
- Commit the new feature
- Repeat several times to get towards the requirements as closely as possible

When AI agent fails to deliver multiple times in a row
- Based on all context, let it create a new and more integrated spec2.md
- Request it to forget everything and build an index2.html, based on the spec2.md


<details>
  <summary>Nothing but a toggle</summary>
  <div markdown=1>
    Inside the toggle.
  </div>
</details>

