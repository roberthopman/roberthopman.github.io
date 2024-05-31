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
- Documentation can be found at
  - [https://docs.ruby-lang.org/en/master/index.html](https://docs.ruby-lang.org/en/master/index.html)
  - [https://rubyapi.org](https://rubyapi.org).
  - via ruby info `ri` command in terminal, e.g. `ri Array#map` or `ri .map`
  - via `help` command in interactive ruby. First `irb` then `help Array#map` or `help .map`
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

#### Shebang on Unix
<hr>

The shebang is the `#!` at the beginning of a script. It tells the system what interpreter to use to run the script, e.g. file `hi.rb`:
```ruby
#!/usr/bin/env ruby
puts 'Hello, world!'
```

#### Reserved keywords
- Version: [3.3](https://docs.ruby-lang.org/en/3.3/keywords_rdoc.html)
- With definition: [https://ruby-doc.org/docs/keywords/1.9/](https://ruby-doc.org/docs/keywords/1.9/)

```md
__ENCODING__ 
The script encoding of the current file.

__LINE__
The line number of this keyword in the current file.

__FILE__
The path to the current file.

BEGIN
Runs before any other code in the current file. 

END
Runs after any other code in the current file. 

alias
Creates an alias between two methods (and other things). 

and
Short-circuit Boolean and with lower precedence than &&

begin
Starts an exception handling block. 

break
Leaves a block early. 

case
Starts a case expression. 

class
Creates or opens a class. 

def
Defines a method. 

defined?
Returns a string describing its argument. 

do
Starts a block.

else
The unhandled condition in case, if and unless expressions. 

elsif
An alternate condition for an if expression. 

end
The end of a syntax block. Used by classes, modules, methods, exception handling and control expressions.

ensure
Starts a section of code that is always run when an exception is raised. 

false
Boolean false. 

for
A loop that is similar to using the each method. 

if
Used for if and modifier if statements. 

in
Used to separate the iterable object and iterator variable in a for loop. It also serves as a pattern in a case expression. 

module
Creates or opens a module. 

next
Skips the rest of the block. 

nil
A false value usually indicating “no value” or “unknown”. 

not
Inverts the following boolean expression. Has a lower precedence than !

or
Boolean or with lower precedence than ||

redo
Restarts execution in the current block. 

rescue
Starts an exception section of code in a begin block. 

retry
Retries an exception block. 

return
Exits a method. If met in top-level scope, immediately stops interpretation of the current file.

self
The object the current method is attached to. 

super
Calls the current method in a superclass. 

then
Indicates the end of conditional blocks in control structures. 

true
Boolean true. 

undef
Prevents a class or module from responding to a method call. 

unless
Used for unless and modifier unless statements. 

until
Creates a loop that executes until the condition is true. 

when
A condition in a case expression. 

while
Creates a loop that executes while the condition is true. 

yield
Starts execution of the block sent to the current method. 
```

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
:pending, :"rejected", :"#{var}_name"

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

[Regex](https://docs.ruby-lang.org/en/master/Regexp.html)
```ruby
# Regular Expression
# A regular expression (also called a regex or regexp) 
# is a match pattern (also simply called a pattern). 
# Regex can be used for pattern matching and pattern replacement. 
re = /red/
re.match?('redirect') # => true   # Match at beginning of target.
re.match?('bored')    # => true   # Match at end of target.
re.match?('foo')      # => false  # No match.
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