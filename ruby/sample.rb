#!/usr/bin/env ruby

class SampleClass
  def hello
    puts 'hello'
  end

  def length=(val)
    @length = val
  end
  def length
    @length
  end
end

module SampleModule
end

0.upto(9) do |n|
  printf "%d", n
end
puts

0.upto(9) { |n| printf "%d", n }
puts

def hello(names)
  names.each do |name|
    puts "HELLO, #{name.upcase}"
  end
end

hello(["A", "B"])

$global = "global"

CONST_VALUE=123
puts CONST_VALUE

if true
  puts 'true'
else
  puts 'false'
end

n = 2
puts n.even? ? 'even' : 'odd'

obj = SampleClass.new

obj.hello

obj.length = 123
puts obj.length

class Ruler
  attr_accessor :length

  def display_lenth
    puts length
  end

  def set_default_length
    # length = 30 はローカル変数となってしまう
    self.length = 40
  end

end

ruler = Ruler.new
ruler.length = 30
ruler.display_lenth
ruler.set_default_length
ruler.display_lenth

class MyClass
  @@var = 'class method'

  def self.class_method
    @@var
  end
end
puts MyClass.class_method


class Parent
  def hello
    puts 'hello'
  end
end

class Child < Parent
  def hello
    super

    puts 'world'
  end
end

child = Child.new
child.hello
