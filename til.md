---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: default
title: T.I.L.
---

<div class="main">
  <div class="title">T.I.L.</div>
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
</div>