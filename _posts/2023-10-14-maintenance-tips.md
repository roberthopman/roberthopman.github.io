---
layout: post
title:  "A set of precisely defined rules, potentially enforceable, to guide and regulate behavior in coding"
---

**General tips**

- Limit lines to 80 characters.
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
- [ruby-style-guide](https://github.com/rubocop/ruby-style-guide)
- [rails-style-guide](https://github.com/rubocop/rails-style-guide)

## Quick reference

Structure:
- [Read documentation (API)](#read-documentation)
- [Debugging](#debugging)
- [Literals](#literals)
- [Variables](#variables)
- [Control flow](#control-flow)
- [Methods](#methods)

#### Read documentation
<hr>
- Documentation is a representation of the language (im)possibilities. 
- Documentation can be found at [https://docs.ruby-lang.org/en/master/index.html](https://docs.ruby-lang.org/en/master/index.html) and at [https://rubyapi.org](https://rubyapi.org).
- ruby-lang.org search shows more results from the documentation, rubyapi.org shows less results.
- Class methods are called on the class itself and are defined with self. Instance methods are called on an instance of a class and are defined without self.
- `::` is a scope resolution operator. It is used to reference a constant, module, or class defined within another class or module. It is documented as a class method.
- `#` is a method call operator. It is documented as an instance method.

#### Debugging
<hr>
For debugging use `p` instead of `puts`. 
- `p` (print the value of the expression, including the value of the expression)
- `pp` (pretty print the value of the expression)
- `print` (prints without trailing new line)
- `puts` (prints expression and nil)

#### Literals
<hr>
[Literals at https://docs.ruby-lang.org](https://docs.ruby-lang.org/en/master/syntax/literals_rdoc.html)

A literal is any notation that lets you represent a fixed value in source code. 

Basic literals:
```ruby
# Numbers: Integers and Floats
1, 2, 3.00, 4e2

# Strings
'That\'s right', "double quotes", "Interpolation like #{2+2}"

# Symbols (immutable strings)
:pending, :"rejected", :"#{'var'}_name"

# Arrays
[1, 2, 3, 4, 5]

# Hashes
{ key1: 'value1', key2: 'value2' }

# Ranges
1..100, 'a'..'z'

# Boolean: 
true, false

# Nil
nil

# Here Document or Heredoc
a_variable = <<HEREDOC
  This is a heredoc
  It is used for multi-line strings
HEREDOC
```

Type conversion:
```ruby
# to string
1.to_s 
# to integer
'1'.to_i
```

Expressions and Return Values:
```ruby
# Expression is evaluated
1 + 1
# and will return a value
1 + 1 
=> 2
# => is called a hash rocket
# 2 is returned

puts 1+1
2
=> nil
# expression puts 1+1 is evaluated
# 2 is printed
# nil is returned
```

#### Variables
<hr>
[Variables at https://docs.ruby-lang.org](https://docs.ruby-lang.org/en/master/doc/syntax/assignment_rdoc.html)

A variable is a name that refers to a value. A local variable name may contain letters, numbers, an _ (underscore or low line) or a character with the eighth bit set.

Examples:
```ruby
$global_variable
@@class_variable
@instance_variable
CONSTANT
::TOP_LEVEL_CONSTANT
OtherClass::CONSTANT
local_variable
```