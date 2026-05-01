require_relative 'koans'

# Topic: Hash methods in Ruby
# Source: ruby/hash_methods.md

class AboutHashes < Koans::TestCase
  def test_access_by_key
    h = { name: "Alice", age: 30 }
    assert_equal __, h[:name]
    assert_equal __, h[:age]
  end

  def test_missing_key_returns_nil
    h = { name: "Alice" }
    assert_equal __, h[:nonexistent]
  end

  def test_keys
    h = { a: 1, b: 2 }
    assert_equal __, h.keys
  end

  def test_values
    h = { a: 1, b: 2 }
    assert_equal __, h.values
  end

  def test_size
    h = { a: 1, b: 2, c: 3 }
    assert_equal __, h.size
  end

  def test_empty_hash
    assert_equal __, {}.empty?
    assert_equal __, { a: 1 }.empty?
  end

  def test_key_check
    h = { name: "Alice" }
    assert_equal __, h.key?(:name)
    assert_equal __, h.key?(:age)
  end

  def test_value_check
    h = { name: "Alice" }
    assert_equal __, h.value?("Alice")
    assert_equal __, h.value?("Bob")
  end

  def test_fetch_existing_key
    h = { age: 30 }
    assert_equal __, h.fetch(:age)
  end

  def test_fetch_with_default
    h = { age: 30 }
    assert_equal __, h.fetch(:city, "Warsaw")
  end

  def test_merge
    h1 = { a: 1, b: 2 }
    h2 = { b: 3, c: 4 }
    result = h1.merge(h2)
    assert_equal __, result[:b]
    assert_equal __, result[:c]
    assert_equal __, h1[:b]
  end

  def test_merge_modifies_in_place
    h1 = { a: 1 }
    h1.merge!({ b: 2 })
    assert_equal __, h1.size
  end

  def test_delete
    h = { a: 1, b: 2 }
    h.delete(:a)
    assert_equal __, h.key?(:a)
    assert_equal __, h.size
  end

  def test_convert_to_array
    h = { a: 1, b: 2 }
    assert_equal __, h.to_a
  end

  def test_dig_nested
    data = { user: { name: "Alice", city: "Warsaw" } }
    assert_equal __, data.dig(:user, :name)
    assert_equal __, data.dig(:user, :country)
  end

  def test_select
    h = { a: 1, b: 2, c: 3 }
    assert_equal __, h.select { |_k, v| v > 1 }
  end

  def test_transform_values
    h = { a: 1, b: 2 }
    assert_equal __, h.transform_values { |v| v * 10 }
  end
end
