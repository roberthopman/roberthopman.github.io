---
layout: post
title:  "A set of precisely defined rules, potentially enforceable, to guide and regulate behavior in coding"
---

**General tips**

- Pass no more than four parameters into a method. Hash options are parameters.
- Methods can be no longer than five lines of code.
- Classes can be no longer than one hundred lines of code.
- Controllers can instantiate only one object. Therefore, views can only know about one instance variable and views should only send messages to that object (@object.collaborator.value is not allowed).

**References**

- [https://github.com/hopsoft/rails_standards/tree/rails-4-X](https://github.com/hopsoft/rails_standards/tree/rails-4-X)
- [https://github.com/leahneukirchen/styleguide/blob/master/RUBY-STYLE](https://github.com/leahneukirchen/styleguide/blob/master/RUBY-STYLE)
- [https://github.com/thoughtbot/guides/blob/main/ruby/README.md](https://github.com/thoughtbot/guides/blob/main/ruby/README.md)
- [https://thoughtbot.com/blog/sandi-metz-rules-for-developers#only-instantiate-one-object-in-the-controller](https://thoughtbot.com/blog/sandi-metz-rules-for-developers#only-instantiate-one-object-in-the-controller)
- [https://zenspider.com/ruby/quickref.html](https://zenspider.com/ruby/quickref.html)