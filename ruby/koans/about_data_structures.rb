require_relative 'koans'

# Topic: Data structures — mutability and immutability
# Source: ruby/data_structures.md

class AboutDataStructures < Koans::TestCase
  def test_string_is_mutable
    s = "hello"
    s << " world"
    assert_equal __, s
  end

  def test_shovel_operator_modifies_object
    a = "original"
    b = a
    a << " modified"
    # b points to the same object!
    assert_equal __, b
  end

  def test_symbol_is_immutable
    assert_equal __, :hello.frozen?
  end

  def test_numbers_are_immutable
    assert_equal __, 42.frozen?
  end

  def test_freeze_freezes_object
    s = "freeze me".freeze
    assert_equal __, s.frozen?
  end

  def test_freeze_prevents_modification
    s = "frozen".freeze
    assert_raise(FrozenError) { s << " text" }
    assert_equal __, s
  end

  def test_sort_bang_modifies_array
    arr = [3, 1, 2]
    arr.sort!
    assert_equal __, arr
  end

  def test_sort_without_bang_does_not_modify
    arr = [3, 1, 2]
    arr.sort
    assert_equal __, arr
  end

  def test_push_adds_to_end
    arr = [1, 2]
    arr.push(3)
    assert_equal __, arr
  end

  def test_pop_removes_from_end
    arr = [1, 2, 3]
    last = arr.pop
    assert_equal __, last
    assert_equal __, arr
  end

  def test_unshift_adds_to_beginning
    arr = [2, 3]
    arr.unshift(1)
    assert_equal __, arr
  end

  def test_shift_removes_from_beginning
    arr = [1, 2, 3]
    first = arr.shift
    assert_equal __, first
    assert_equal __, arr
  end

  def test_dup_creates_a_copy
    original = [1, 2, 3]
    copy = original.dup
    copy << 4
    assert_equal __, original.size
    assert_equal __, copy.size
  end

  def test_reverse_bang_modifies_array
    arr = [1, 2, 3]
    arr.reverse!
    assert_equal __, arr
  end

  def test_map_bang_modifies_array
    arr = [1, 2, 3]
    arr.map! { |n| n * 2 }
    assert_equal __, arr
  end
end
