---
layout: default
title:  Syntax
---

# Syntax rules

Language consists of a system:

- [Semantics](https://en.wikipedia.org/wiki/Semantics) studies the aspects of meaning.
- [Syntax](https://en.wikipedia.org/wiki/Syntax) studies the structure, principles and relationships.

Besides the syntax, we can have general guidelines to describe common knowledge.

**General rules**

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
- [Classes](#classes)
- [Collections](#collections)

#### Read documentation
<hr>

- Documentation is a representation of the language (im)possibilities. 
- Documentation can be found at
  - [https://docs.ruby-lang.org/en/master/index.html](https://docs.ruby-lang.org/en/master/index.html)
  - [https://docs.ruby-lang.org/en/master/table_of_contents.html](https://docs.ruby-lang.org/en/master/table_of_contents.html)
  - [https://rubyreferences.github.io/rubyref/](https://rubyreferences.github.io/rubyref/)
  - [https://rubyapi.org](https://rubyapi.org)
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
[https://docs.ruby-lang.org/en/master/syntax/literals_rdoc.html](https://docs.ruby-lang.org/en/master/syntax/literals_rdoc.html)


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
# is a way of specifying a set of characters that matches a string or part of a string.
# It is a match pattern (also simply called a pattern).
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

Blocks
Code block is a chunk of code that can be passed to a method. You can think of a block as somewhat like the body of an anonymous method, as if the block were another parameter passed to that method. Usually between braces on one line and do/end when block spans multiple lines. Parameters to a block are separated by commas, and they are always local to the block. You can define block-local variables using the `;` character in the block's parameter list. 

```ruby
# general syntax
[1,2].each { puts 'x' }
[1,2].each do puts 'x' end
[1,2].each { |x| puts x }
[1,2].each { puts _1 } # _1 first positional argument, _2, _3 etc.

# block-local variable y (syntax is rare)
y = 100
sum = 0
[1,2].each do |x; y| 
  y = x*x
  sum += y
end
puts sum
puts y

# method say first, then parameters, only one block after.
object.say("dave") { puts 'hello' }

# The act of doing something to all objects in a collection is called enumeration in Ruby; in other languages it is called iteration.
# e.g. each, find, map, sort_by, group_by, map, reduce 
# https://ruby-doc.org/3.3.4/Enumerator.html#method-i-each
# https://ruby-doc.org/3.3.4/Enumerable.html#method-i-find
# (https://ruby-doc.org/3.3.4/IO.html#method-i-print)[https://ruby-doc.org/3.3.4/IO.html#method-i-print]
names.each { |x| print(name, " ") }

# Ruby remembers the context of an object, local variables, block, and so on, this is called `binding`. Within the method, the block may be invoked, using the `yield` statement. A block returns a value to the method that yields to it. The value of the last expressions evaluated in the block is passed back to the method as the value of the yield expression.
def two_times 
  yield
  yield
end
two_times { puts "Hello" }
Hello 
Hello

`.tap` # is a no-op, it taps into the object and returns the object. It is useful for debugging e.g.: 
`.tap { |result| puts "result: #{result}\n\n" }`

# map implementation looks something like this, which constructs a new array
class Array
  def map
    result = []
    each do |value| 
      result << yield(value) 
    end
    result 
  end
end
```

If the last parameter is prefixed by `&` (such as `&action`), that code block is converted to an object of class `Proc`. The `Proc` object is then assigned to the parameter. This allows you to pass a code block to a method as if it were a regular parameter. 

https://docs.ruby-lang.org/en/master/Proc.html
https://docs.ruby-lang.org/en/master/Kernel.html#method-i-lambda

```ruby
# Long
class ProcObject
  def pass_in(&action)
    @stored_proc = action
  end

  def use_proc(parameter)
    @stored_proc.call(parameter)
  end
end
foo = ProcObject.new
foo.pass_in{ |paramz| puts "Hello, #{paramz}!" }
foo.use_proc("Dave")

# shorter
def create_block_object(&block)
  block
end
bl = create_block_object { |x| puts "Hello, #{x}!" }
bl.call('Dave')

# shortest
# stabby lambda
bl = -> (param) { puts "you called with #{param}" }
bl.call("Dave")

# short: lambda (Ruby Kernal method)
bl = lambda { |param| puts "you called with #{param}" }
bl.call("Dave")

# short: Kernal method proc
bl = proc { |param| puts "you called with #{param}" }
bl.call("Dave")

# Proc.new (not the preferred method)
bl = Proc.new { |param| puts "you called with #{param}" }
bl.call("Dave")
```

Blocks as closures
Variables in the surrounding scope that are referenced in a block remain acessible for the life of that block and the life of any Proc object created from that block. 
```ruby
def n_times(thing)
  ->(n) { puts thing * n }
end
p1 = n_times("Hello,")
p1.call(3)
# => Hello,Hello,Hello,

# Parameter list
# it can take default values, splat arguments, keywords arguments, and block parameters.
-> (parameter list) { block }

# Example
proc2 = -> (x, *y, &z) do 
  puts x
  puts y
  z.call
end

proc2.call(1, 2, 3, 4) { puts "Hello, World!" }
# => 1
# => [2, 3, 4]
# => Hello, World!
```

Enumerators: can iterate over two collections in parallel.
Enumerator class is not to be confused with the Enumerable module. The Enumerator class is used to create custom external iterator.
```ruby
short_enum = [1,2,3].to_enum
long_enum = ('a'..'z').to_enum
loop do 
  # will end after the 3rd iteration, this will terminate cleanly
  puts "#{short_enum.next} - #{long_enum.next}"
end
```

# Control flow

[https://ruby-doc.org/3.3.4/syntax/control_expressions_rdoc.html](https://ruby-doc.org/3.3.4/syntax/control_expressions_rdoc.html)


Conditional branches:
```ruby
# if/elsif/else
if condition1
  # code
elsif condition2
  # code
else
  # code
end

# ternary operator
condition ? true_value : false_value

# unless. As reminder: if not
unless expression
  # some code to be executed if the expression is FALSE
else
  # some code to be executed if the expression is true
end

# case
case expression
when condition1
  # code
when condition2
  # code
else
  # code
end
```

Loops:

[https://ruby-doc.org/3.3.4/Kernel.html#method-i-loop](https://ruby-doc.org/3.3.4/Kernel.html#method-i-loop)
```ruby
# a method defined in Kernel, but it looks like a control structure.
# loop
# iteration over api endpoint that is paginated
page = 1
collection = []
loop do
  # response = send_request(:get, '/endpoint', page)
  # collection += response[:data]
  # page += 1
  # break if page > response.dig(:pagination, :total_pages)
end

# while (do keyword is optional)
a = 0
while a < 10 do
  p a
  a += 1
end
p a

# until. As reminder: while not
until condition
  # loop as long as condition is false
end
```
Break, next:
- Use break to leave a block early.
- Use next to skip the rest of the current iteration.

```ruby
loop do
  next if condition_1
  break if condition_2
end
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

[https://docs.ruby-lang.org/en/master/doc/syntax/assignment_rdoc.html](https://docs.ruby-lang.org/en/master/doc/syntax/assignment_rdoc.html)

A variable is an identifier that is assigned to an object, and which may hold a value. A local variable name may contain letters, numbers, an _ (underscore or low line) or a character with the eighth bit set.

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

In a file:

```ruby
# Defining variables
# global variable, can be mutated
$some_global_variable = "accessible everywhere"
# Top level constant, can not be mutated
TOP_LEVEL_CONSTANT = "accessible everywhere"

class Toy
  CONSTANT = "Some value"
end

class Human
  # A class variable is shared by all instances of this class.
  @@species = 'H. sapiens'
  # Constant is a variable that is set only once and never changed.
  A_CONSTANT = 1

  # Basic initializer
  def initialize(name, age = 0)
    # Assign the argument (name) to the '@name' instance variable for the instance.
    @name = name
    # If no age given, we will fall back to the default in the arguments list (age=0).
    @age = age
  end

  def some_method
    # local_variable is only accessible within this method
    local_variable = 1 
  end

  def some_other_method
    # TOP_LEVEL_CONSTANT can be accessed from anywhere in the program using :: prefix
    ::TOP_LEVEL_CONSTANT
  end

  def some_last_method
    # From another class
    Toy::CONSTANT
  end
end

# Showing variables
p $some_global_variable
Human.class_variable_get(:@@species)
Human::A_CONSTANT
h = Human.new('foo', 10)
h.instance_variable_get(:@name)
h.instance_variable_get(:@age)
h.some_method
h.some_other_method
h.some_last_method
```

```ruby
# Aliasing global variables
$some_global_variable = "accessible everywhere"
alias $b $some_global_variable
p $b # => 'accessible everywhere'

# parallel variable assignment
x, y, z = 100, 200, 500
```

#### Pseudo Variables
They provide information about the program's execution environment or serve specific purposes within Ruby.
Characteristics: Predefined, read-only and available throughout the program.

```ruby
self  # The receiver object of the current method.
super # The receiver object of the current method in the superclass.
true  # boolean; singleton; TrueClass
false # boolean; singleton; FalseClass
nil   # empty; uninitialized; NilClass; falsey; singleton
__FILE__ # The name of the current source file.
__LINE__ # The current line number in the source file.
```

#### Pre-defined global variables

- [https://docs.ruby-lang.org/en/master/globals_rdoc.html](https://docs.ruby-lang.org/en/master/globals_rdoc.html)
- [https://github.com/ruby/ruby/blob/HEAD/spec/ruby/language/predefined_spec.rb](https://github.com/ruby/ruby/blob/HEAD/spec/ruby/language/predefined_spec.rb)
- [https://github.com/ruby/ruby/blob/HEAD/lib/English.rb](https://github.com/ruby/ruby/blob/HEAD/lib/English.rb)

In irb:
```ruby
global_variables.count
# => 43
global_variables.sort.inspect
# => "[:$!, :$\", :$$, :$&, :$', :$*, :$+, :$,, :$-0, :$-F, :$-I, :$-W, :$-a, :$-d, :$-i, :$-l, :$-p, :$-v, :$-w, :$., :$/, :$0, :$:, :$;, :$<, :$=, :$>, :$?, :$@, :$DEBUG, :$DEBUG_RDOC, :$FILENAME, :$LOADED_FEATURES, :$LOAD_PATH, :$PROGRAM_NAME, :$VERBOSE, :$\\, :$_, :$`, :$stderr, :$stdin, :$stdout, :$~]"

Exceptions 
  $! (Exception)
  $@ (Backtrace)

Pattern Matching 
  $~ (MatchData)
  $& (Matched Substring)
  $` (Pre-Match Substring)
  $' (Post-Match Substring)
  $+ (Last Matched Group)
  $1, $2, Etc. (Matched Group)

Separators 
  $/ (Input Record Separator)
  $; (Input Field Separator)
  $\ (Output Record Separator)

Streams 
  $stdin (Standard Input)
  $stdout (Standard Output)
  $stderr (Standard Error)
  $< (ARGF or $stdin)
  $> (Default Standard Output)
  $. (Input Position)
  $_ (Last Read Line)

Processes 
  $0
  $* (ARGV)
  $$ (Process ID)
  $? (Child Status)
  $LOAD_PATH (Load Path)
  $LOADED_FEATURES

Debugging 
  $FILENAME
  $DEBUG
  $VERBOSE

Other Variables 
  $-a
  $-i
  $-l
  $-p

Deprecated 
  $=
  $,
```

Pre-defined global constants

```ruby
Streams 
  STDIN
  STDOUT
  STDERR

Environment 
  ENV
  ARGF
  ARGV
  TOPLEVEL_BINDING
  RUBY_VERSION
  RUBY_RELEASE_DATE
  RUBY_PLATFORM
  RUBY_PATCHLEVEL
  RUBY_REVISION
  RUBY_COPYRIGHT
  RUBY_ENGINE
  RUBY_ENGINE_VERSION
  RUBY_DESCRIPTION

Embedded Data 
  DATA
```

# Methods

https://docs.ruby-lang.org/en/master/syntax/methods_rdoc.html

Defined by keyword `def`. You can undefine by `undef`

Can begin with lowercase or underscore, followed by letters, numbers or underscores. May end with ?, !, =. 

- `Predicate` methods end with a ? and return a boolean result. 
- `Bang` methods end with a ! and modify the object in some way. E.g. String .reverse or .reverse!. The first one returns a modified string and the second one modifies the receiver in place.
- `Assignment` methods end with = and modify the object in some way.

Parentheses are optional: `def hello; end` is the same as `def hello() end`.

A method is invoked using dot syntax: `receiver.method`

In other words: 
- We ask the object to perform an action.
- The object receives a message.
- We send a message to the object.

Preference to use parentheses in all but the simplest cases. This would be idiomatic, it means in line with the language's conventions.

```ruby
def hello
  puts 'hi'
end

Since Ruby 3.0 endless method:
def a_method(arg) = puts arg
```

### Method arguments

```ruby
def hello(greeting = "hi", name = "bob", question, *args)
  puts "#{greeting} #{name} #{question} #{args}"
end

- `greeting` is a default argument.
- `name` is a default argument.
- `question` is a required argument.
- `args` is a splat argument. It collects all remaining arguments into an array.
```

A class method: `def self.method_name` and an instance method: `def method_name`.

Positional arguments: are passed to the method based on their position.
Keyword arguments: are passed based on the keyword and can be listed in any order.
Keyword arguments: `def method_name(city: "value", state:)` When calling the method, you can pass the arguments in any order, but each keyword argument must be part of the call: `method_name(state: "CA", city: "San Francisco")`. 

Collect arguments into Hash with double-splat, or **: `def method_name(**args)`. A bare single splat will catch positional arguments, bare double splat will catch keyword arguments.

```ruby
def do_stuff(*)
  # anonymous splat parameter 
  do_stuff_2(*)
end

def do_stuff_2(*array_args)
  array_args
end

def do_stuff_3(first, *, last)
  puts "first: #{first}, last: #{last}"
end

# passing bare & character to pass block
class Child < Parent
  def do_it(&)
    do_it_2(&)
  end
end

# will catch all arguments.
def do_it(*args, **kwargs, &block); end 

# the triple dot syntax will catch and pass all arguments, in a simpler anonymous way.
def do_it(...)
  do_it_2(...)
end
```

Calling a method.

```ruby
connection.download_mp3("jazz", speed: :slow) { |p| show_progress(p) }
# receiver.method(postional_parameter, keyword_parameter: "value") { |block_parameter| block_code(block_parameter) }
# 1. object invokes method
# 2. inside that method, self is set to that (receiver) object
# 3. method body is executed, possibly the block is called as well

# Ruby allows you to omit the receiver, in which case Ruby will default to use `self`.
class Thing
  def hello
    self.greet
    greet
  end

  private def greet
    puts 'hi'
  end
end
Thing.new.hello
# "hi"
# "hi"
# => nil
```
Method calls without parentheses are sometimes called commands.

## rule: If in doubt, use parentheses. 

A `return` statement exists from the currently executing method. It can be used to return a value from a method. If no value is specified, nil is returned.

```ruby
def method_name(city:, country:)
  puts city
  puts country
end
data = {city: "ab", country: "bb"}
method_name(**data)
#ok

city = "cc"
country = "aac"
method_name(city:, country:)
#ok

# Passing block arguments:
["a", "f"].map(&:upcase)
# take the argument to this proc, and call the method whose name matches this symbol.
# the class Symbol implements the to_proc method, returning a Proc method.
```

# Classes

In object oriented programming, a class is a blueprint for a domain concept.

Instances are created by a constructor. The standard constructor method is called `new`. When you call Bike.new, Ruby holds an uninitialized object and calls that objects `initialize` method, passing all arguments from `.new`. This sets up the object's state. Instances have a unique object_id (object identifier).

`#<Class:object_id>` is the default string representation of an object.

```ruby
class Bike
  def initialize(price)
    @price = price
  end
end
bike = Bike.new(100)
puts bike 
#<Bike:0x000000011063ea50>
p bike
#<Bike:0x000000011063ea50 @price="100">
```
`p` calls the inspect method on the object. It's a good way to see the object's state.

```ruby
class Bike
  def initialize(price)
    @price = Float(price)
  end

  def to_s
    "I'm a bike and my price is #{@price} hours of work."
  end
end
bike = Bike.new(100)
puts bike 
#I'm a bike and my price is 100.0 hours of work.
```

## Object and attributes

Creating an `accesor` method is a common pattern in Ruby. Below, the `def price` is a getter method, which can also be rewritten to the shortcut `attr_reader :price`. It allows you to read the value of an instance variable. Below, `def price=(price)` is a setter method, shortcut (but rare) `attr_writer :price`. It allows you to write to the value of an instance variable. Generally, use `attr_accessor :price` for both reading and writing, for a given attribute (e.g. an instance variable). Below as example `price_in_cents` is a virtual instance variable or calculated value. An attribute is just a method that is called when you use dot syntax and is an implementation of the `uniform access principle`. 

As summary:
- State is held in instance variables. 
- External state is exposed through methods via attributes. 
- Other actions your class can perform are just regular methods. 

```ruby
# bike.rb
class Bike
  attr_reader :price

  def initialize(price)
    @price = Float(price)
  end

  def price
    @price
  end

  def price=(new_price)
    @price = price
  end

  def price_in_cents
    (price * 100).round
  end

  def price_in_cents=(cents)
    @price = cents / 100.0
  end
end
```

Classes working with other classes:

With the following `1.csv` file:
```
price
123
321
```

We look at the following `bike_stats.rb` file:
```ruby
require 'csv'
require_relative 'bike'

bikes = []

ARGV.each do |csv|
  $stderr.puts "Processing file: #{csv}"
  CSV.foreach(csv, headers: true) do |row|
    $stderr.puts "Processing row: #{row}"
    bike = Bike.new(row['price'])
    bikes << bike
  end
end

p bikes.count

# run with:
# ruby bike_stats.rb 1.csv
```
`require_relative` means that the file is loaded relative to the path of the current file.
`ARGV` is an array of command line arguments.
`$stderr` is the standard error stream.

## Specifying access control

Classes increasingly depending on other classes is called coupling. Coupling is a bad thing. It makes it hard to change one class without breaking another. Ruby gives 3 levels of access control: public methods, private methods, and protected methods (rare).

`Public methods` can be called by anyone, no access control is enforced.
`Protected methods` can be called only by objects of the defining class or subclasses. Access is within the family.
`Private methods` can not be called with an explicit receiver, it is always in the context of the current object, known as `self`.

```ruby
class Door
  def initialize(locked)
    @locked = locked
  end

  # subsequent methods will be public again
  def open 
    unlock
    walking 
  end
  
  def close
    lock 
  end

  def next_is_locked?(other)
    if locked?
      "you can only see the current door"
    else
      other.locked?
    end
  end

  protected
  # subsequent methods will be protected, only usable to class or subclass
  def locked?
    @locked
  end
  
  private
  # subsequent methods will be private, only usable within the instance
  def unlock
    @locked = false
  end

  def lock
    @locked = true
    return 'locked'
  end

  public
  # subsequent methods will be public again, usually public is not needed

  # this private is preferred, because it's more explicit
  # also possible, only usable within the instance
  private def walking
    puts 'walking'
  end
end
# door = Door.new(true)
# door.open
# door.close
# door.next_is_open?(Door.new(true))
```

### preference: per method explicit access control

## Variables
A variable is not an object in Ruby. It is a reference to an object.
Assignment aliases objects, potentially giving multiple variables that reference the same object.

String#dup will create a new string object with the same content.
String#freeze will make a string immutable.
Numbers and symbols are always frozen (immutable) in Ruby.

## Reopening Classes

`Monkey-patching`: Process of reopening classes to add or change (utility) methods. Use with caution.

# Collections

Most real programs manage collections of data. Ruby has a number of built-in classes for managing collections: arrays and hashes. Both classes have large interfaces and many methods.

## Arrays

Array.new, Array.[], create a new array.
```ruby
# class methods
a = Array.new(1,2,3)
b = Array.[](1, 2, 3)

# instance methods below
b[0] or b.[](0) are both fine, though b[0] will be much more common.

# assignment
b[0]=4 or b.[]=(0, 4) are both fine, though b[0]=4 will be much more common.
```
Some assignments:
```ruby
b[1, 0] = [5, 6] # at index 1, for 0 elements, will insert 5 and 6, shifting the rest of the array to the right.
b[1, 1] = [5, 6] # at index 1, for 1 element, will replace, with 5 and 6.
b[0, 2] = [5, 6] # at index 0 for 2 elements, will replace, with 5 and 6.
b[0..1] = [] # at index 0 to 1, will remove the elements.
b[6..7] = 99, 98 # will insert 99 and 98 at index 6 and 7 e.g. [1, 2, 3, nil, nil, nil, 99, 98]
```

Reminder: array of words = %w{one two three}, array of symbols = %i{one two three}

## Hashes
Hashes known as associative arrays, maps, dictionaries, key-value stores. They are collections of key-value pairs. The index in a hash is called a key. The value or entry is the object that the key points to. Retrieve the entry by indexing the hash with the key value.

hash literals are created with curly braces, e.g. {:key => "value", "key_2" => "value_2"}
`=>` is called hashrocket.

```ruby
foo = "bar"
baz = {foo:} 
# ruby will assume the key and value are the same
puts baz
# => {:foo=>"bar"}
```

## Digging
`dig` is a method that allows you to access nested elements of a hash. It is a safe way to access nested elements. It will return nil if any intermediate element is nil. A method on a hash, array, or struct.

----

Abbreviations:
- CSV = Comma Separated Values