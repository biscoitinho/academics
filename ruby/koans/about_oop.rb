require_relative 'koans'

# Topic: Object-oriented programming in Ruby
# Source: ruby/oop_ruby.md

module OOPExamples
  class Dog
    def initialize(name)
      @name = name
    end

    def name
      @name
    end
  end

  class Cat
    attr_accessor :name
    def initialize(name)
      @name = name
    end
  end

  class Point
    attr_reader :x, :y
    def initialize(x, y)
      @x = x
      @y = y
    end
  end

  class Vehicle; end
  class Car < Vehicle; end

  class Animal; end
  class Bird < Animal; end

  class Calculator
    def add(a, b)
      a + b
    end
  end

  class Shape
    def description
      "I am a shape"
    end
  end

  class Circle < Shape; end

  class Base
    def greeting
      "Hello from base"
    end
  end

  class Derived < Base
    def greeting
      "Hello from derived"
    end
  end

  class Parent
    def introduce
      "I am the parent"
    end
  end

  class Child < Parent
    def introduce
      super + " and the child"
    end
  end

  class Counter
    @@count = 0

    def self.reset
      @@count = 0
    end

    def self.increment
      @@count += 1
    end

    def self.value
      @@count
    end
  end
end

class AboutOOP < Koans::TestCase
  def test_creating_an_object
    d = OOPExamples::Dog.new("Rex")
    assert_equal __, d.name
  end

  def test_attr_accessor
    c = OOPExamples::Cat.new("Whiskers")
    assert_equal __, c.name
    c.name = "Felix"
    assert_equal __, c.name
  end

  def test_attr_reader_is_read_only
    p = OOPExamples::Point.new(3, 4)
    assert_equal __, p.x
    assert_equal __, p.y
  end

  def test_object_class
    c = OOPExamples::Car.new
    assert_equal __, c.class
  end

  def test_superclass
    assert_equal __, OOPExamples::Car.superclass
  end

  def test_is_a
    b = OOPExamples::Bird.new
    assert_equal __, b.is_a?(OOPExamples::Bird)
    assert_equal __, b.is_a?(OOPExamples::Animal)
  end

  def test_respond_to
    c = OOPExamples::Calculator.new
    assert_equal __, c.respond_to?(:add)
    assert_equal __, c.respond_to?(:subtract)
  end

  def test_method_inheritance
    c = OOPExamples::Circle.new
    assert_equal __, c.description
  end

  def test_method_override
    assert_equal __, OOPExamples::Derived.new.greeting
    assert_equal __, OOPExamples::Base.new.greeting
  end

  def test_super_calls_parent_method
    assert_equal __, OOPExamples::Child.new.introduce
  end

  def test_class_method
    OOPExamples::Counter.reset
    OOPExamples::Counter.increment
    OOPExamples::Counter.increment
    assert_equal __, OOPExamples::Counter.value
  end
end
