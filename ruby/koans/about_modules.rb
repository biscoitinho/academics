require_relative 'koans'

# Topic: Modules and mixins
# Source: ruby/modules_mixins.md

module Greetable
  def greet
    "Hello, I am #{name}"
  end
end

class PersonWithModule
  include Greetable
  attr_reader :name
  def initialize(name)
    @name = name
  end
end

module Sprinter; end

class Athlete
  include Sprinter
end

module Swimmer; end

class Contestant
  include Swimmer
end

module ClassHelper
  def description
    "I am a class-level helper method"
  end
end

class Tool
  extend ClassHelper
end

module Geometry
  class Circle
    def shape
      "circle"
    end
  end
end

module MathConstants
  PI = 3.14159
end

module Drivable
  def drive
    "driving"
  end
end

module Flyable
  def fly
    "flying"
  end
end

class FlyingCar
  include Drivable
  include Flyable
end

module M1; end
module M2; end

class BaseWithModules
  include M1
  include M2
end

class AboutModules < Koans::TestCase
  def test_include_adds_instance_methods
    p = PersonWithModule.new("Alice")
    assert_equal __, p.greet
  end

  def test_is_a_with_module
    a = Athlete.new
    assert_equal __, a.is_a?(Sprinter)
  end

  def test_ancestors_include_module
    assert_equal __, Contestant.ancestors.include?(Swimmer)
  end

  def test_extend_adds_class_methods
    assert_equal __, Tool.description
  end

  def test_module_as_namespace
    c = Geometry::Circle.new
    assert_equal __, c.shape
  end

  def test_constant_in_module
    assert_equal __, MathConstants::PI
  end

  def test_multiple_modules
    fc = FlyingCar.new
    assert_equal __, fc.drive
    assert_equal __, fc.fly
  end

  def test_ancestor_order
    # ancestors: [BaseWithModules, M2, M1, Object, ...]
    # the last included module takes precedence in lookup
    assert_equal __, BaseWithModules.ancestors.first
    assert_equal __, BaseWithModules.ancestors[1]
  end

  def test_module_cannot_be_instantiated
    assert_raise(NoMethodError) { MathConstants.new }
  end
end
