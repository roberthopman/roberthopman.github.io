---
layout: default
title:  Syntax
description: Describing the Ruby language structure
---

# Syntax

Language consists of a system:

- [Semantics](https://en.wikipedia.org/wiki/Semantics) studies the aspects of meaning.
- [Syntax](https://en.wikipedia.org/wiki/Syntax) studies the structure, principles and relationships.

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
- [Inheritance](#inheritance)
- [Modules](#modules)
- [Exceptions](#exceptions)
- [Input and output](#input-and-output)
- [Concurrency](#concurrency)
- [General rules](#general-rules)
- [References](#references)

## Read documentation

- Documentation is a representation of the language (im)possibilities. 
- Documentation can be found at
  - [https://docs.ruby-lang.org/en/master/index.html](https://docs.ruby-lang.org/en/master/index.html)
  - [https://docs.ruby-lang.org/en/master/table_of_contents.html](https://docs.ruby-lang.org/en/master/table_of_contents.html)
  - [https://rubyreferences.github.io/rubyref/](https://rubyreferences.github.io/rubyref/)
  - [https://rubyapi.org](https://rubyapi.org)
  - via ruby info `ri` command in terminal, e.g. `ri Array#map` or `ri .map`
  - via `help` command in interactive ruby. First `irb` then `help Array#map` or `help .map`
- `ruby-lang.org` search shows more results from the documentation, `rubyapi.org` shows less results.
- Class methods are called on the class itself and are defined with self. Instance methods are called on an instance of a class and are defined without self.
- `::` is a scope resolution operator. It is used to reference a constant, module, or class defined within another class or module. It is documented as a class method.
- `#` is a method call operator. It is documented as an instance method.

## Debugging

For debugging use `p` instead of `puts`:
- `p` (print the value of the expression, including the value of the expression)
- `pp` (pretty print the value of the expression)
- `print` (prints without trailing new line)
- `puts` (prints expression and nil)

### Reserved keywords

<details>
  <summary>Keywords</summary>
  <div markdown=1>

```
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
  </div>
</details>

- Version: [3.3](https://docs.ruby-lang.org/en/3.3/keywords_rdoc.html)
- With definition: [https://ruby-doc.org/docs/keywords/1.9/](https://ruby-doc.org/docs/keywords/1.9/)


## Literals

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

### Regular Expression - [Regex](https://docs.ruby-lang.org/en/master/Regexp.html)
A regular expression (also called a regex or regexp) is pattern that can be matched against a string. It is a way of specifying a set of characters that matches a string or part of a string. It is a match pattern (also simply called a pattern). Regex can be used for pattern matching and pattern replacement. Specific patterns can be defined with: Anchors, word boundaries, character classes, repetition, alternation and grouping.

```ruby
re = /red/ # or %r{red}
re.match?('redirect') # => true   # Match at beginning of target.
re.match?('bored')    # => true   # Match at end of target.
re.match?('foo')      # => false  # No match.
"bored".match?(re)    # => true  
```

The following are metacharacters with specific meaning: `. ? - + * ^ \ | $ ( ) [ ] { }`

[https://docs.ruby-lang.org/en/master/Regexp.html#class-Regexp-label-Special+Characters](https://docs.ruby-lang.org/en/master/Regexp.html#class-Regexp-label-Special+Characters)

Operater =~ returns characters offset of beginning:
```ruby
/cat/ =~ 'dog and cat' # => 8
/cat/ =~ 'cat' # => 0
'cat' =~ /cat/ # => 0
```

!~ is the negative match operator, which returns true if the string does not match the pattern:
```ruby
/cat/ !~ 'dog and cat' # => false
```
Changing strings with patterns: .sub, .gsub, .sub!, and .gsub!. Sub is for the first match, gsub is for all matches.

Regex has modifiers, with the `x` at the last example below, you can add newlines, whitespace and comments inside to make it more readable:
```ruby
/cat/i # => case insensitive
/cat/m # => multiline
/cat/s # => single line
%r{(\d{5}),         # 5 digits followed by comma
        \s,         # a whitespace
    ([A-Z])         # 1 character
  }x # => extended
```

After a succesful match via Regexp#match or =~ it returns a MatchData object, which is a collection of information about the match:
https://docs.ruby-lang.org/en/master/MatchData.html
```ruby
/all/.match("all things")
=> #<MatchData "all">
```

### Numbers
Ruby supports integers, floating-point, rational and complex numbers. Intergers are assumed to be decimal base 10, but can be specified with a leading sign, as base indicatar: 0 for octal, 0x for hexadecimal and 0b for binary (and 0d for decimal), followed by a string of digits in the appropriate base.

```ruby
12345       => 12345  # base 10
0d12345     => 12345  # base 10
123_456     => 123456 # base 10
-543        => -543   # base 10
0xaabb      => 43707  # base 16 (hexadecimal)
0377        => 255    # base 8  (octal)
-0b10_1010  => -42    # base 2  (binary)
1_2_3       => 123    # base 10
```

BigDecimal is Ruby's high-precision decimal number class.

Rational numbers are the ratio of two integers (they are fractions) and therefor have an exact representation:
```ruby
3/4             #=> 0
3/4r            #=> (3/4)
0.75r           #=> (3/4)
"3/4".to_r      #=> (3/4)
Rational(3,4)   #=> (3/4)
Rational("3/4") #=> (3/4)
```
Complex numbers represent points on the complex plane, and have 2 components: the real and imaginary parts.
```ruby
1+2i            # => (1+2i)
"1+2i".to_c     # => (1+2i)
Complex(1,2)    # => (1+2i)
Complex("1+2i") # => (1+2i)
```

Looping using Numbers
```ruby
3.times { print "A " }
1.upto(5) { |i| print i, " " }
99.downto(97) { |i| print i, " " }
50.step(60, 5) { |i| print i, " " }

# A A A 1 2 3 4 5 99 98 97 50 55 60
```

### Strings
Ruby strings are sequences of characters and instances of class `String`.

Usually strings are created using string literals - sequences of characters between single or double quotes (delimiters). How the string literal is created, defines the amount of processing that is done on the characters in the string. 

Escaping characters inside single-quote is a form of processing:
```ruby
'hi \\' # => hi \
'that\'s right' # => that's right
'hi "\\"' # => hi "\"
```

Double-quoted strings support
- many escape sequences, e.g. `\n` the newline character.
- string interpolation, which means you can use any ruby code into a string using `#{ expression }`.
- global, class or instance variables: #$foo, #@@foo or #@foo.

Not recommended:
```ruby
puts "now is #{ 
  def the(a)
    'the ' + a
  end
  the('time')
} for all bad coders..."
```
Produces: `now is the time for all bad coders...`

Some style guides prefer single quotes, if interpolation isn't used, because they are faster.

Syntax to create a string literal can also be as follows, with any nonalphanumeric or nonmultibyte character: 
```ruby
%q/abc/         #=> abc
%Q!abc!         #=> abc
%Q{abc #{2*3}}  #=> abc 6
%!abc!          #=> abc
%{abc #{2*3}}   #=> abc 6
# usually current style guides suggest this:
%q(abc)         #=> abc 
```

Finally, you can construct a string using a here document, or heredoc. 
```ruby
string = <<END_OF_STRING
  This is a string
  with two lines.
END_OF_STRING

# with a minus sign, you can indent the terminator
string = <<-END_OF_STRING
This is a string
with two lines.
  END_OF_STRING

# with tilde, ruby will strip the indentation, to enable long strings
string = <<~END_OF_STRING
  This is a string
  with two lines.
END_OF_STRING

# Or generally considered super confusing:
print <<-S1, <<-S2
  Concat
    S1
  enate
  S2
```

Type conversion:
```ruby
# to string
1.to_s 
# to integer
'1'.to_i
```

### Encoding
Encoding is a mechanism for translating bits into characters. For many years, most developers who used English used ASCII, a 7-bit encoding of English characters, such as binary 101 to capital A. Later, an 8-bit representation called Latin-1 that included most characters in European languages became common. All of these were superseded by Unicode, a global standard for all text characters used in all languages: https://home.unicode.org/

### Struct
A `Struct` is a class that is used to create objects that have attributes.

### Ranges
Ranges represent a range of values. Ruby uses ranges to implement sequences and intervals.

```ruby
arr = [1,2,3,4,5]
arr[..2] # => [1,2,3]
arr[2..] # => [3,4,5]
arr === 3 # => true
arr === 6 # => false
arr.include?(3) # => true
```

## Blocks
A code block is a chunk of code that can be passed to a method. You can think of a block as somewhat like the body of an anonymous method, as if the block were another parameter passed to that method. Usually between braces on one line and do/end when block spans multiple lines. Parameters to a block are separated by commas, and they are always local to the block. You can define block-local variables using the `;` character in the block's parameter list. 

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
```
The act of doing something to all objects in a collection is called enumeration in Ruby; in other languages it is called iteration. e.g. [each](https://ruby-doc.org/3.3.4/Enumerator.html#method-i-each), [find](https://ruby-doc.org/3.3.4/Enumerable.html#method-i-find), map, sort_by, group_by, map, reduce. 

Ruby remembers the context of an object, local variables, block, and so on, this is called `binding`. Within the method, the block may be invoked, using the `yield` statement. A block returns a value to the method that yields to it. The value of the last expressions evaluated in the block is passed back to the method as the value of the yield expression.

```ruby
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

- https://docs.ruby-lang.org/en/master/Proc.html
- https://docs.ruby-lang.org/en/master/Kernel.html#method-i-lambda

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
# => Hello, Dave!

# shorter
def create_block_object(&block)
  block
end
bl = create_block_object { |x| puts "Hello, #{x}!" }
bl.call('Dave')
# => Hello, Dave!

# shortest
# stabby lambda
bl = -> (param) { puts "you called with #{param}" }
bl.call("Dave")
# => Hello, Dave!

# short: lambda (Ruby Kernal method)
bl = lambda { |param| puts "you called with #{param}" }
bl.call("Dave")
# => Hello, Dave!

# short: Kernal method proc
bl = proc { |param| puts "you called with #{param}" }
bl.call("Dave")
# => Hello, Dave!

# Proc.new (not the preferred method)
bl = Proc.new { |param| puts "you called with #{param}" }
bl.call("Dave")
# => Hello, Dave!
```

### Blocks as closures
Variables in the surrounding scope that are referenced in a block remain accessible for the life of that block and the life of any Proc object created from that block. This is called a closure. More on closures: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Closures

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

### Enumerators
Can iterate over two collections in parallel. Enumerator class is not to be confused with the Enumerable module. The Enumerator class is used to create custom external iterator.
```ruby
short_enum = [1,2,3].to_enum
long_enum = ('a'..'z').to_enum
loop do 
  # will end after the 3rd iteration, this will terminate cleanly
  puts "#{short_enum.next} - #{long_enum.next}"
end
```

## Control Flow and Expressions

[https://docs.ruby-lang.org/en/master/syntax/control_expressions_rdoc.html](https://docs.ruby-lang.org/en/master/syntax/control_expressions_rdoc.html)

Ruby has a variety of ways to control execution. All the expressions described here return a value.

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

- Basic Operator Expressions: `+ - * / % **`
- Command Expressions: string with backquotes or backticks will be executed as command by OS. `ls`.split will give array of content of the current folder. Copying , using `` `echo 'hi' | pbcopy` `` will copy the output of echo to clipboard, which is the same as `system("echo '123' | pbcopy")`. 
Copying resource attributes: `` `echo "#{User.first.id}" | pbcopy` ``.
- Assignment is setting the lvalue (left value) to refer to the rvalue (right value), and returns rvalue. Ruby has 2 forms of assignment: first an object reference to a variable or constant, ABC = 4. Second is object attribute or element reference on the left side of the assignment operator, ABC[1] = 4. Also possible, is the rightward assignment, since ruby 3.0: data => variable (e.g. 2=>x). 
- For parallel assignment, to swap vales: 
```ruby
a, b = 1, 2 
a, b = b, a
```
- Splats and assignment: 
  - for rvalues `a,b,c,d,e = *(1..2), 3 # a=1, b=2, c=3, d=nil, e=nil` 
  - greedy for splat for lvalue:

```ruby
a, *b = 1,2,3,4,5 
# a=1, b=[2,3,4,5]

*a, b = 1,2,3,4,5 
# a=[1,2,3,4], b=5

first, *, last = [1,2,3,4,5] 
# first=1, last=5 
```    

- Nested assignments: 

```ruby
a, (b, c) = 1, [2, 3] 
# a=1, b=2, c=3

a, (b, c), d = 1, [2, 3, 4], 5 
# a=1, b=2, c=3, d=5
```

### Conditional Execution
- boolean expressions: Ruby has simple definition of truth: any value that is 1. not `nil`, or 2. the constant `false`, is true. So, `"c", 9, 0, :a`, are true, also, `"", [], {}` are true. The set of false values are sometimes referred to as falsey and set of true values are referred to as truthy. `nil && 99` returns `nil`, `"c" && 99` returns `99`. When it's false, the first argument is returned, when it's truee, the second argument is returned (short circuit evaluation). There is a difference in using `&&` and `and`, terms of precedence compared to the assignment. Examples: `result = "" && [], which returns the #=> []`, and will show `result #=> []`, however `result = "" and [] which returns the #=> []` and will show `result # => ""`.
- the `defined?` Keyword: `defined? 1 #=> "expression"` and `defined? a #=> nil` and `defined? a = 1 #=> "assignment"`.
- Comparing objects: == equal value, ===, <=>, <, >, <=, >=, =~, eql? (equal type and value), equal? (same object id).
- if and unless: 

```ruby
# then is optional
if condition then 
  # code
elsif condition2 then
  # code
else
  # code
end

# also possible
if condition then #code
elsif condition2 then #code
else #code
end

# assignment
variable = 
  if condition then #code
  elsif condition2 then #code
  else #code
  end

# ternary operator
condition ? true_value : false_value

# unless. Negated if statement. As reminder: if not
unless expression
  # some code to be executed if the expression is FALSE
else
  # some code to be executed if the expression is true
end

# also possible
if not false then true end #=> true
```
Safe navigation operator: `&.`, also called the lonely operator. It returns nil if the object is nil.

### Loops and iterators:

[https://docs.ruby-lang.org/en/master/Kernel.html#method-i-loop](https://docs.ruby-lang.org/en/master/Kernel.html#method-i-loop)

```ruby
# a method defined in Kernel, but it looks like a control structure.
# loop
# e.g. iteration over api endpoint that is paginated
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
- Use `break` to leave a block early.
- Use `next` to skip the rest of the current iteration.

```ruby
loop do
  next if condition_1
  break if condition_2
end
```

Iterators:
```ruby
2.times do; puts 'Hello' end # => Hello Hello
2.times { puts 'Hello' } # => Hello Hello
0.upto(5) { |i| puts i } # => 0 1 2 3 4 5
0.step(10, 2) { |i| puts i } # => 0 2 4 6 8 10
```

A different way to write an each loop with a Ruby built-in looping primitive:
```ruby
for i in 0..5
  puts i
end
# => 0 1 2 3 4 5
```

Block local variables: 
```ruby
square = 'start'
[1,2].each do |i; square| # square is now also a block local variable
  square = i * i
end
puts square # => start
```

### Pattern Matching

[https://docs.ruby-lang.org/en/master/doc/syntax/pattern_matching_rdoc.html](https://docs.ruby-lang.org/en/master/doc/syntax/pattern_matching_rdoc.html)

Pattern matching compares a target which can be any Ruby object to a pattern. If the target matches the pattern, the target is deconstructed into the pattern, setting the value of those variables.

```ruby
"abc" in "abc" # => true
"abc" in "def" # => false
3 in 3 # => true
3 in 4 # => false
3 in 1..5 # => true
"abc" in String # => true
"abc" in Integer # => false
[1,2,3] in [Integer, Integer, Integer] # => true
{a: 1, b: "3"} in {a: Integer, b: String } # => true

# or
[1,2] in [Integer, Integer] | [Integer, String] # => true
```

Variable binding: Assign values in the target to variables in the pattern and then use those variables in the pattern.
```ruby
value in pattern => variable
puts variable # => value

# example
"aaa" in String => var
puts var # => aaa

# short
"baa" => var
puts var # => baa

# another way
"abc" in var
puts var # => abc
```

Case pattern matching:
```ruby
# case, with when clause
case expression
when condition1 then # code
when condition2
  # code
else # code
end

# case, with in clause
case expression
in condition1 then # code
in condition2 then # code
else # code
end

# pinning values, in a case statemen. With the pin operator ^ : It will pin the value to the part of the pattern..
def get_status(idea_to_look_for, status_to_look_for, list)
  case list
  in [*, {idea: ^idea_to_look_for, status: }, *] then puts "#{idea_to_look_for} is #{status_to_look_for}"
  in [*, {idea:, status: ^status_to_look_for}, *] then puts "second"
  else # code
end

puts get_status('idea1', 'status1', 
  [{idea: 'idea1', status: 'status1'}, 
  {idea: 'idea2', status: 'status2'}
])
#=> idea1 is status1

# guard clause, additionally to the pattern matching, it checks the condition
case expression
in pattern if condition # code
else # code
end

# pattern matching against a class, requires a deconstruct_keys or deconstruct
class MyClass
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def deconstruct_keys(keys)
    {name: @name}
  end
end

my_object = MyClass.new('my_object')

case my_object
in {name: /^my/} then puts "starts with my"
in {name: /^your/} then puts "starts with your"
else # code
end
```

## Variables

[https://docs.ruby-lang.org/en/master/doc/syntax/assignment_rdoc.html](https://docs.ruby-lang.org/en/master/doc/syntax/assignment_rdoc.html)

A variable is an identifier that is assigned to an object, and which may hold a value. A variable is not an object in Ruby, so it is a reference to an object. A local variable name may contain letters, numbers, an _ (underscore or low line) or a character with the eighth bit set.

Assignment aliases objects, potentially giving multiple variables that reference the same object. String#dup will create a new string object with the same content. String#freeze will make a string immutable. Numbers and symbols are always frozen (immutable) in Ruby.

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

### Pseudo Variables
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

### Pre-defined global variables

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

## Methods 

https://docs.ruby-lang.org/en/master/syntax/methods_rdoc.html

Defined by keyword `def`. You can undefine by `undef`.

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

### rule: If in doubt, use parentheses. 

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


# https://ruby-doc.org/3.3.4/Object.html#method-i-method
# objects have a method named method, which takes a symbol and returns the object's method of the same name
number = 2
method = number.method(:*)
(1..3).map(&method)
# => [2, 4, 6]
```

## Classes

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

### Object and attributes

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

### Specifying access control

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


### Reopening Classes

`Monkey-patching`: Process of reopening classes to add or change (utility) methods. Use with caution.

## Collections

Most real programs manage collections of data. Ruby has a number of built-in classes for managing collections: arrays and hashes. Both classes have large interfaces and many methods.

### Arrays

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

### Hashes
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

### Override methods:

```ruby
def Child
  def initialize(name)
    @name = name
  end

  def to_s
    "the name: #{@name}"
  end
end
puts Child.new('Foo') # => "the name: Foo"
```

### Digging
`dig` is a method that allows you to access nested elements of a hash. It is a safe way to access nested elements. It will return nil if any intermediate element is nil. A method on a hash, array, or struct.


## Inheritance
### Sharing functionality: Inheritance, Modules, and Mixins

inheritance allows you to create a class that's a specialization of another class: e.g. subclass and superclass, child and parent.

```ruby
def Child < Parent
end
Child.superclass # => Parent
Parent.superclass # => Object
Object.superclass # => BasicObject
BasicObject.superclass # => nil
# BasicObject is the root class eventually of any ruby application.

# To use subclassing is common. E.g. with `ActionController::Base` from Ruby on Rails.

# Instead of:

def chatty_string(resource)
  case resource.element
  when "fire" then "I bring light"
  when "water" then "I bring water"
  when "earth" then "I provide ground"
  end
end

# we can have a module.rb
class Element
  def self.for(element_string)
    case element_string
    when "fire" then Fire.new
    when "water" then Water.new
    when "earth" then Earth.new
    end
  end

  def hot? = false

  def chatty_string = raise NotImplementedError
end

class Fire < Element
  def to_s = "fire"

  def hot? = true

  def chatty_string = "I bring fire"
end

class Water < Element
  def to_s = "water"

  def chatty_string = "I bring water"
end

class Earth < Element
  def to_s = "earth"

  def chatty_string = "I provide earth"
end

# Element.for(resource.element).chatty_string
# if there is a Parent, like Element, having `def chatty_string raise NotImplementedError` it signals that subclasses must define this method.
```

## Modules
Modules can do everything a class can do, except create instances. They are a way to group methods, classes and constants. Two benefits: 1. a namespace and prevent name clashes, 2. can be included in other classes, known as a `mixin`. Module names are like class names, both are global constants with an initial uppercase letter. use them with the require or require_relative method. Module constants are referenced using two colons, the `scope resultion operator`, e.g. Thing::SAY.

An `include` is a method of the Module class. The `require` call is at the file level, the `include` call is at the class level. 

Example module is `Kernel` which is included in `Object`. Another is Comparable, which assumes that any class that uses it  defines the method `<=>` (the `spaceship operator`).

Some Object-Oriented languages like Python support multiple inheritance (Powerful and dangerous), some like JavaScript support single inheritance (cleaner and easier to implement). Ruby is a single inheritance language, which mixins to support controlled multiple-inheritance-like capability.


```ruby
module Thing
  SAY = "word"
  def self.method_1; end
end

module OtherThing
  def self.method_1; end
end

module Debug
  def who_am_i?
    "#{self.class.name} (id: #{self.object_id}): #{self.name}"
  end
end

class Child
  include Debug

  attr_reader :name

  def initialize(name)
    @name = name
  end
end

Child.new("FOO").who_am_i? # => "Child (id: 123456789): FOO"
```

Ruby provides two mechanisms for mixing in module behaviour. The first is `include`, which is used to add methods as instance methods to a class, and those will be looked up after the class itself is checked for a method. The second is `extend`, which is used to add methods directly to the receiver of extend rather than as instance methods of a class. Ruby also provides another mechanism, `prepend`, which is used to add methods as class methods to a class, and those will be looked up before the class itself is checked for a method. Prepend is often used for logging or other logistical information to classes.

In general, a mixin that requires its own state isn't a mixin, it should be written as a class.

### Method lookup

With multiple ways to define methods, Ruby will look for a method in the following order:
1. methods specifically added to that instance using `foo=Foo.new` and 1. `def foo.bar; end`, or via 2. `class << foo; def bar; end; end`
2. Any module added to the receiver's class using `prepend`, the last module added is checked first.
3. Methods defined in the receiver's class.
4. Modules added in the receiver's class using `include`, the last module added is checked first.
5. If not found, the same loop will happen in the receiver's superclass.

This continues until the method is found or the end of the inheritance structure is reached. If the method is not found, Ruby will try again from the receiver's class, now looking for `method_missing`, if no `method_missing` is found to handle the message, a `NameError` is thrown. Entire list of classes and modules in this lookup path can be accessed by calling the method `foo.ancestors`.

### Super lookup

when executing a method, if Ruby encounters keyword `super`, it method lookup for `super` starts one step after the points where the method being executed is lcoated. (e.g. if in step 2, it will start at step 3). If `super` has no argument list, Ruby will pass the arguments that were passed to the method that called `super`. If `super` has an argument list, even an empty one, those arguments will be passed.

```ruby
module Sound
  def execute
    puts "zing"
    super
  end
end

module Process
  def execute
    puts "start"
    super
  end
end

class Animal
  def execute
    puts "animal"
  end
end

class Zebra < Animal
  prepend Sound
  include Process

  def execute
    puts "zebra"
    super
  end
end

puts Zebra.new.execute
=> zing
=> zebra
=> start
=> animal
```

References:
- https://www.rafaelmontas.com/ruby-method-lookup-path/
- https://gist.github.com/robturtle/b20c5e1077ef6ab1cb73605aff0d6b1c
- https://gist.github.com/damien-roche/351bf4e7991449714533

### Inheritance, Mixins, and Design

For subclassing look for `is-a` relationships or hierarchies. However, for `has-a` or `uses-a` relationships, use composition. Ruby on Rails makes use of inheritance, e.g. with Person inheriting from a DatabaseWrapper class (ActiveRecord). As inheritance represents an incredibly tight coupling, it should be used sparingly. It's easy to break. Composition is more flexible, however can get messy fast.

```ruby
# Composition
class Person
  include Persistable
  # ..
end

# Inheritance
class Person < DatabaseWrapper
  # ..
end
```

## Exceptions

Ruby uses exceptions to solve the problem of responding to errors in a program. They let you package information about an error into an object, in ruby of class `Exception` or in one of `Exception` subclasses. Documentation is https://docs.ruby-lang.org/en/master/Exception.html. Most important subclass is `StandardError`, which along with its subclasses, should be used to capture all errors in code. The other subclasses are used to indicate specific types of errors, e.g. Ruby internals or system-level problems.

Every `Exception` object has: 
- The type (the exception’s class): StandardError, RuntimeError, etc.
- Optional message: "This is the message"
- Optional backtrace: An array of strings, e.g. ["file:line", "file:line", ...] https://docs.ruby-lang.org/en/master/Exception.html#method-i-backtrace

How to raise an exception:
```sh
irb # or rails console
raise StandardError.new("This is a test error")
# => StandardError: This is a test error
raise "This is a test error"
# => RuntimeError: This is a test error
```

### Handling exceptions

We enclose the code that could raise an exception in a `begin/end` block and use one or more `rescue` clauses to handle the types of exceptions.

Below is an example of a `begin/rescue/end` block. We catch all exceptions related to `StandardError` and its children, and re-raise them. The global variable `$!` contains the exception object. The `warn` method is used to print to standard error. The `raise` method is used to re-raise the exception. The exclamation point `!` presumably is used to indicate our surprise that _our_ code failed. You can have multiple `rescue` clauses, and the first one that matches will be executed. The `rescue` clause can have a variable name, which will be assigned the exception object, usually named `e`, like: `rescue StandardError => e`. If you write `rescue` without a parameter, it will default to catch all StandardError exceptions. If you need to guarantee that a certain processing is done at the end of a block of code, with or without an exception being raised, use `ensure`. The `else` clause is only executed if no exceptions are raised.

If no rescue clause matches or if an exception is raised outside of a `begin/end` block, Ruby moves up the stack, looking for an exception handler in the caller, and so on until it finds one. If no exception handler is found, the program typically halts.

Sometimes you want to use the `retry` clause. This will repeat the entire `begin/end` block, so can create infinitie loops and therefor best used with a counter.

```ruby
begin
  puts 0/0
rescue SyntaxError => e
  $stderr.warn "Failed #{$!}" 
  # warn "Failed #{$!}"
  # warn "Failed #{e}"
  raise
rescue StandardError => e
  print "Error: #{e}"
  raise
else
  puts "No errors"
ensure
  puts "This is always executed"
end
```

### Raising exceptions

You can raise exception with `raise` or `fail`. 

```ruby
raise
raise "keyboard failed"
raise InterfaceError, "keyboard failed"
raise InterfaceError, "keyboard failed", caller
```
`raise` simple reraises the exception. `raise` with a string argument will create a new RuntimeError exception. `raise` with a class name will create a new exception of that class, with the second argument as the message. `raise` with a class name, a message, and a `Kernel#caller` stack trace, will allow to edit the stack backtrace as well: `raise InterfaceError, "keyboard failed", caller[0..-2]`.

You can also define your own exceptions by subclassing `Exception` or one of its subclasses, to hold more information about the error, or possibly add additional behavior.

### Using Catch and Throw
`catch` defines a block that is labeled with given name (Symbol or String) and is normally executed until a `throw` is encountered. When throw is encountered, the block is exited and returns nil or, when second parameter is passed, that value is returned.
```ruby
catch(:done) do
  while true
    print "Input: "
    line = gets
    throw :done if line =~ /quit/i
    throw(:done, line) if line.size > 3
  end
end
```

## Input and output

https://docs.ruby-lang.org/en/master/IO.html

I/O or IO methods are implemented in the Kernel module, including `gets, open, print, printf, putc, puts ,readline, readlines`, and `test`.
These are available to all objects. There is also Ruby's `IO` class, with subclasses `File` and `BasicSocket` with more specialized methods. The IO object is a bidirectional stream between a Ruby program and some external resource.

### Open and Close files

```ruby
# file = File.new("file_name", "mode string")
# mode string lets you declare if you're opening the file for reading, writing or both.

file = File.new("testfile", "r")
# ... process the file
file.close

# or File.open, 
# which will close the file automatically, also when an exception is raised
File.open("testfile", "r") do |file|
  # ... process the file
end
```

### Read and Write files

`Kernel#gets` reads a line from the standard input (or from a specified file), `File#gets` reads a line from a file.

Reading from console:
```ruby
# copy.rb
while (line = gets)
  puts line
end
```

Reading from a file, line by line:
```ruby
File.open("testfile") do |file|
  while line = (file.gets)
    puts line
  end
end
```

From a file with `IO#each_line` with `String#dump` to show the line:
```ruby
File.open("testfile") do |file|
  file.each_line { |line| puts "Got #{line.dump}" }
end
=> Got "This is line one\n"
```

Giving `each_line` an argument will split the line on that argument:
```ruby
File.open("testfile") do |file|
  file.each_line("e") { |line| puts "Got #{line}" }
end
=> Got "This is line"
=> Got " one\n"
```

Iterator with autoclosing block feature:
```ruby
File.foreach("testfile") { |line| puts "Got #{line}" }
```

Reading a file into a string:
```ruby
str = IO.read("testfile")
str.length # => ..
str[0, 8] # => "This..."
```

Reading a file into an array:
```ruby
arr = IO.readlines("testfile")
arr.length # => ..
arr[0] # => "This is line one\n"
```

Writing to a file:
```ruby
File.open("output.txt", "w") do |file|
  file.puts "Hi"
  file.puts "1 + 2 = #{1+2}"
end
puts File.read("output.txt")
# Hi
# 1 + 2 = 3
```

Every object you pass to `puts` is converted to a string with `to_s` method. Note: `puts` adds newline after the output, `print` does not. 

```ruby
File.open("output.txt", "w") do |file|
  file.write "Hi"
  file.write "1 + 2 = #{1+2}"
end
puts File.read("output.txt")
# Hi1 + 2 = 3
```

### Find files
```ruby
__FILE__ relative name of the file
__dir__ absolute pathname of that file
File.realpath returns absolute path to a file
File.realpath(__FILE_) gives absolute path to the current file
```

StringIO behaves like other IO objects, but they read and write strings, not files. https://docs.ruby-lang.org/en/master/StringIO.html

```ruby
require 'stringio'
io = StringIO.new("abc")
io.read # => "abc"
io.write("def")
io.string # => "abcdef"
io.close
io.closed? # => true
```

### Talking to Networks

At the network level, Ruby comes with a set of classes in the the socket library. https://docs.ruby-lang.org/en/master/Socket.html These give access to TCP, UDP, SOCKS, and Unix domain sockets, and additional socket types. At a higher level of the OSI model, the "lib/net" here https://docs.ruby-lang.org/en/master/Net.html and https://github.com/ruby/ruby/tree/master/lib/net, provides application level protocols (such as HTTP, HTTPS, FTP, POP, IMAP, and SMTP). `Net::HTTP` for example: https://docs.ruby-lang.org/en/master/Net/HTTP.html or at a higher-level the `open-uri` library is a wrapper for Net::HTTP, Net::HTTPS and Net::FTP, and handles redirects automatically: https://docs.ruby-lang.org/en/master/OpenURI.html

IO is however slow and blocks programs, a common workaround is to use threading to do multiple things at once.

## Concurrency

When writing programs that are doing multiple things at once, each thing is called a thread. And the goal is to have thread safety, meaning the code will execute correctly no matter what order the threads operate. When the order of operations matters, we call it a race condition, and it's bad because it can lead to hard-to-find bugs. Ruby programs have a Global Interpreter Lock (GIL), which means that only one thread can executed by Ruby at any time. This is one way to protect thread safety and prevent race conditions.

The `Thread` class is the basic unit of multithreaded behavior in Ruby. Ruby also allows you to spawn processes out to the underlying operating system, and mulithread those processes. `Fibers` are an additional abstraction, to suspend the executation of one part of a program and run some other part. The `Ractor` library allows you to bypass the GIL and have 'true' multiple threading using Ruby.

### Threads

https://docs.ruby-lang.org/en/master/Thread.html

The lowest-level mechanism is the `Thread` class. Mostly you will see one thread executing, and another waiting on an I/O operation. A thread shares all global, instance, and local variables that are in existence and available at the time the thread starts. Threads are immediately executed. Local variables created in the thread's block are truly local ot that thread. Thread.join will ensure the main program waits for the threads to finish, you can also give the thread a timeout, and it will return nil if the thread does not finish in time. Normally, building timing dependencies in a multithreaded program is a bad idea. However, if you need to do this, you can use the `Mutex` (mutually exclusive) class, which creates areas of code that can only be accessed by one thread at a time. Some of the relevant methods to enable this: Mutex#lock, Mutex#unlock, and the block version Mutex#synchronize, and the Mutex#try_lock method.

### Multiple external processes

Kernel#system executes given commmand in a subprocess and returns true if the command was found and executed properly. If it fails, it returns false and the subprocess's exit code is in `$?`.

```ruby
system(`tar xzf test.tgz`) #=> false
span("date")               #=> "Mon Jan 20 23:04:23 UTC 2025\n"
`date`                     #=> "Mon Jan 20 23:04:23 UTC 2025\n"
```

When we want to have more control, we can use the IO.popen method, which returns an IO object.

```ruby
reader = IO.popen("cat", "w+") 
reader.puts "hello world"
reader.close_write
puts reader.gets

# or, give it a command as argument and optional block
IO.popen("date") { |f| puts "Date is #{f.gets}" }
```

Sometimes we can run a subprocess independently:

```ruby
pid = spawn("sort textfile.txt > output.txt")
# carry on with the program
Process.wait(pid)

# or if you want to be notified when the subprocess terminates
trap("CLD") do 
  pid = Process.wait
  puts "Child #{pid}: terminated"
end
spawn("sort textfile.txt > output.txt")
# do other things
# returns:
Child pid 3828: terminated
```

### Fibers

https://docs.ruby-lang.org/en/master/Fiber.html

Fibers are a block of code that can be stopped and restarted, which is sometimes called a coroutine. They are cooperatively multitasked, meaning that the responsibility of control is with the fibers and not the OS. Fibers are not immediately executed. When `resume` is called, the fiber will execute until it hits a `yield` statement, which suspends execution. The last expression evaluted will be the return value of the Fiber.

### Ractors

https://docs.ruby-lang.org/en/master/Ractor.html

Ractors are a way to bypass the GIL and have 'true' multiple threading using Ruby. Ractor is a chunk of code that has a single input port and a single output port. So like a physical room, with a single entrance and a single exit door. The entrance door could have a queue to get in. Ractor is created via Ractor.new and is `isolated`, the code inside the block won't be able to acces any variables that aren't defined in the block (no globals and no external locals).

## Testing

Why?

- To ensure maintenance and ongoing changes are not breaking existing code.

The options for testing are:

### No framework, just Ruby:

```ruby
# ./roman.rb
class Roman
  def initialize(value)
    @value = value
  end

  def to_s
    @value
  end
end

# ./test_no_framework.rb
require_relative "roman.rb"
r = Roman.new(1)
fail "'I' expected but got #{r.to_s}" if r.to_s != 'I'

# produces
ruby test_no_framework.rb
Traceback (most recent call last):
test_no_framework.rb:3:in `<main>': 'I' expected but got 1 (RuntimeError)
```

### Minitest

Gives you three facilities wrapped into a package:
- a way of expressing individual tests
- framework for organizing tests
- flexible ways of invoking tests

Instead of `if` or `unless`, we write assertions.

The minitest/autorun module includes minitest itself, which has most of the features we've talked about and call `Minitest.autorun`, which calls the test runner. Test files are being executed as plain Ruby files. Unit tests are organized into higher-level groupings, called test cases (around of facility or feature). Test cases are organized into test suites. 
Classes that represent test cases must be subclasses of `Minitest::Test`. Methods that begin with `test_` are test methods. We can use shared code in `setup` and `teardown` methods, which for setup will run before each and every test method, or with teardown, after each test method finishes.

The idea of unit tests is fast-running, context-independent, and easy to maintain.

```ruby
require_relative "roman.rb"
require "minitest/autorun"

# initial test with duplication
class TestRoman < Minitest::Test
  def test_simple
    assert_equal("I", Roman.new(1).to_s)
    assert_equal("II", Roman.new(2).to_s)
    assert_equal("IV", Roman.new(4).to_s)
    assert_equal("V", Roman.new(5).to_s)
  end
end

# refactored to make it DRY, with a custom assertion
class TestRoman < Minitest::Test
  def assert_roman_value(roman_value, arabic_numeral)
    assert_equal(roman_value, Roman.new(arabic_numeral).to_s)
  end

  def test_simple
    assert_roman_value("I", 1)
    assert_roman_value("II", 2)
    assert_roman_value("IV", 4)
    assert_roman_value("V", 5)
  end
end
```

Minitest allows you to create `mock objects`, which simulate the API of an (existing) object, providing a canned response instead of a more expensive or context-dependent real response. Mock objects can be verified to ensure that they were called with the correct parameters. We test the behavior of the object, not the return value.

[From the minitest repository:](https://github.com/minitest/minitest?tab=readme-ov-file#mocks-)

```ruby
# test_meme_asker.rb
class Meme
  def i_can_has_cheezburger?
    "OHAI!"
  end

  def will_it_blend?
    "YES!"
  end
end

class MemeAsker
  def initialize(meme)
    @meme = meme
  end

  def ask(question)
    method = question.tr(" ", "_") + "?"
    @meme.__send__(method)
  end
end

require "minitest/autorun"

class TestMemeAsker < Minitest::Test
  def test_asks_unpunctuated_question_mock
    @meme = Minitest::Mock.new
    @meme_asker = MemeAsker.new(@meme)
    @meme.expect(:will_it_blend?, :return_value)

    @meme_asker.ask("will it blend")

    @meme.verify 
  end
end
```

Minitest mock objects can take an optional third argument, which is an array of arguments, and an optional block argument.
If those arguments are used, then the mock object only accepts the method calls that match the arguments and block. If not, it raises an `MockExpectationError`. More documentation in the [minitest mock class](https://github.com/minitest/minitest/blob/master/lib/minitest/mock.rb#L62)

It's common to want to orride one method on an existing object rather than create an entire mock object. In minitest, you can do this with the `stub` method, which is added to `Object`, so it's available to all objects. More documentation in the [minitest Object class extension with stub](https://github.com/minitest/minitest/blob/master/lib/minitest/mock.rb#L279)

The first argument to `stub` is the name of the method you want to intercept, as a symbol. The second argument is the value that should be returned, or you can pass a block argument. The return value of the stub is one of these:
 - value returned of the the block
 - result of the `second_arg.call`, if `second_arg` responds to `call`, meaning it's usually a `Proc` or `lambda`
 - the second argument itself, if neither of the above

```ruby
# with Meme and MemeAsker classes
# test_meme_asker.rb
class TestMemeAsker < Minitest::Test
  def test_asks_unpunctuated_question_stub_with_singleton_method
    meme = Meme.new
    def meme.will_it_blend?; :no; end
    
    result = MemeAsker.new(meme).ask("will it blend")
    
    assert_equal :no, result
  end
end
```

To have control over the depth of runnin tests, be able to run tests with: 

- an exact match: `test test_file_name.rb -n exact_match`
- a pattern: `test test_file_name.rb -n /all_with_pattern/`
- a single file: `test test_file_name.rb`
- a group of files into a test suite; create a file with a name for a test suite and require the test files: `test test_suite_name.rb`

### RSpec

Some history: [https://stevenrbaker.com/tech/history-of-rspec.html](https://stevenrbaker.com/tech/history-of-rspec.html)

RSpec started as a teaching tool, but it was so popular that it became a real tool. The goal of RSpec is to express thinking as close to natural language. RSpec is concerned with driving the design, as such, words like expectation and specifcation are used, and usually RSpec is used before you write the implementation. A 'spec' is a specification, a description of how something should work, and written before implementation, an 'assertion' is used to test what already exists. 

To be clear, you can use both RSpec after you write code, and Minitest (also with specs) before you write code.

An example specification file: 
- that describes how a Roman class should behave
- that groups based on 'converting arabic numerals to roman numerals':
- the group shows 4 expectations that start with 'it'

```ruby
# ./ex1_rspec.rb
RSpec.describe "Roman" do 
  describe "converting arabic numerals to roman numerals" do
    it "converts 1 to I"
    it "converts 2 to II"
    it "converts 4 to IV"
    it "converts 5 to V"
  end
end
```

It is helpful to see With parenthesis and implicit `self` message receivers (self.describe, self.it, self.expect, and self.eq):

```ruby
# ./ex2_rspec.rb
require_relative "roman.rb"
RSpec.describe(Roman) do  
  self.describe("converting arabic numerals to roman numerals") do
    self.it("converts 1 to I") do 
      roman = Roman.new
      self.expect(roman.convert(1)).to(self.eq("I"))
    end

    self.it("converts 2 to II")
    self.it("converts 4 to IV")
    self.it("converts 5 to V")
  end
end
```
The `expect(something).to eq(something_else)` is the most common way to write an expectation in RSpec. The result of a call to `eq` is a `matcher`. More in Github rspec expectations: [https://github.com/rspec/rspec-expectations?tab=readme-ov-file#built-in-matchers](https://github.com/rspec/rspec-expectations?tab=readme-ov-file#built-in-matchers)

Using a `before` method is first step to prevent duplication in setup of tests.

```ruby
before(:example) do 
  @roman = Roman.new
end
```

However, RSpec gives the `let` method as alternative and preferred way to setup tests. The `let` block is only evaluated when the variable is used, and the block is evaluated once, and further uses use the value of the first evaluation.

```ruby
RSpec.describe Roman do  
  describe "converting arabic numerals to roman numerals" do
    let(:roman) { Roman.new }
    
    it "converts 1 to I" do 
      expect(roman.convert(1)).to eq("I")
    end
  end
end
```

In RSpec, the term for a fake object is `test double`, the object that stands in for the real object (stunt double) [https://github.com/rspec/rspec-mocks?tab=readme-ov-file#test-doubles](https://github.com/rspec/rspec-mocks?tab=readme-ov-file#test-doubles). You can create a double and assign it a method to respond to, and a value to return, with `allow`. You can limit the arguments to the method with `with`. You can also define multiple methods with `receive_messages`. In Minitest we validated a mock being called, in RSpec we manage this by using `expect`. `Expect` behaves the same as `allow`, however RSpec automatically verifies that the method was called, if not it fails the spec. However this is implicit and at the end, so might be harder to find. You can also use `allow` and `expect` as `stub` on object that are not test-doubles.

```ruby
obj = double
allow(obj).to receive(:some_method).and_return(:a_value)
allow(obj).to receive(:some_other_method).with("table").and_return(:b_value)
allow(obj).to receive_messages(what: :c_value, why: :d_value)
expect(obj).to receive(:must_be_called).and_return(:some_value)
obj.some_method
obj.some_other_method("table")
obj.what
obj.why
obj.must_be_called

# Or simplify to:
obj2 = double(some_method: :a_value, some_other_method: :b_value)

# with explicit validation of mock method calls
allow(obj2).to receive(:must_be_called).and_return(:some_value)
obj2.must_be_called
expect(obj2).to have_received(:must_be_called)

# stubbing
meme = Meme.new
allow(meme).to receive(:meme_url).and_return("url")
meme.meme_url
```

----

Besides the syntax, we can have general rules to describe common sense.

## General rules

- Line:        limit lines to 80 characters.
- Parameters:  no more than 4 parameters into a method. Hash options are parameters.
- Methods:     can be no longer than 5 lines of code.
- Classes:     can be no longer than 100 lines of code.
- Controllers: can instantiate only 1 object. Therefore, views can only know about one instance variable and views should only send messages to that object (@object.collaborator.value is not allowed).

Organizing a Model:

```ruby
class MyModel < ActiveRecord::Base
  # extends ...................................................................
  # includes ..................................................................
  # relationships .............................................................
  # validations ...............................................................
  # callbacks .................................................................
  # scopes ....................................................................
  # additional config (i.e. accepts_nested_attribute_for etc...) ..............
  # class methods .............................................................
  # public instance methods ...................................................
  # protected instance methods ................................................
  # private instance methods ..................................................
end
```


## References

- [cookpad ruby styleguide](https://github.com/cookpad/styleguide/blob/master/ruby.en.md)
- [rubocop ruby styleguide](https://github.com/rubocop/ruby-style-guide)
- [shopify ruby styleguide](https://github.com/Shopify/ruby-style-guide)
- [thoughtbot ruby styleguide](https://github.com/thoughtbot/guides/blob/main/ruby/README.md)
- [rails styleguide](https://github.com/rubocop/rails-style-guide)
- [https://github.com/hopsoft/rails_standards/tree/rails-4-X](https://github.com/hopsoft/rails_standards/tree/rails-4-X)
- [https://github.com/leahneukirchen/styleguide/blob/master/RUBY-STYLE](https://github.com/leahneukirchen/styleguide/blob/master/RUBY-STYLE)
- [https://thoughtbot.com/blog/sandi-metz-rules-for-developers#only-instantiate-one-object-in-the-controller](https://thoughtbot.com/blog/sandi-metz-rules-for-developers#only-instantiate-one-object-in-the-controller)
- [https://zenspider.com/ruby/quickref.html](https://zenspider.com/ruby/quickref.html)
