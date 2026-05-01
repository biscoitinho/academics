require_relative 'koans'

# Topic: Symbols in Ruby
# Source: ruby/symbols.md
#
# Symbols are immutable, lightweight identifiers.
# The same symbol always has the same object_id — they are shared in memory.

class AboutSymbols < Koans::TestCase
  def test_symbol_class
    assert_equal __, :hello.class
  end

  def test_symbol_to_string
    assert_equal __, :hello.to_s
  end

  def test_string_to_symbol
    assert_equal __, "hello".to_sym
  end

  def test_intern_same_as_to_sym
    assert_equal __, "hello".intern
  end

  def test_symbols_are_shared_in_memory
    # The same symbol always has an identical object_id
    assert_equal __, :foo.object_id == :foo.object_id
  end

  def test_strings_are_not_shared
    # Each new string is a new object
    assert_equal __, "foo".object_id == "foo".object_id
  end

  def test_symbols_are_immutable
    assert_equal __, :hello.frozen?
  end

  def test_symbol_length
    assert_equal __, :hello.length
  end

  def test_symbol_upcase
    assert_equal __, :hello.upcase
  end

  def test_symbol_capitalize
    assert_equal __, :ruby.capitalize
  end

  def test_symbol_as_hash_key
    h = { name: "Alice", age: 30 }
    assert_equal __, h[:name]
  end

  def test_symbol_equality
    assert_equal __, :abc == :abc
    assert_equal __, :abc == :def
  end

  def test_symbol_in_case_statement
    status = :active
    result = case status
             when :active   then "is active"
             when :inactive then "is inactive"
             end
    assert_equal __, result
  end
end
