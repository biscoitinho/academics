require_relative 'koans'

# Topic: Truthiness and falsiness in Ruby
# Source: ruby/truthiness.md
#
# In Ruby ONLY nil and false are falsy.
# Everything else — including 0, "" and [] — is truthy.

class AboutTruthiness < Koans::TestCase
  def test_nil_is_falsy
    assert_equal __, !!nil
  end

  def test_false_is_falsy
    assert_equal __, !!false
  end

  def test_zero_is_truthy
    assert_equal __, !!0
  end

  def test_empty_string_is_truthy
    assert_equal __, !!""
  end

  def test_empty_array_is_truthy
    assert_equal __, !![]
  end

  def test_empty_hash_is_truthy
    assert_equal __, !!{}
  end

  def test_nil_is_nil
    assert_equal __, nil.nil?
  end

  def test_zero_is_not_nil
    assert_equal __, 0.nil?
  end

  def test_double_negation_returns_boolean
    assert_equal __, !!42
    assert_equal __, !!nil
  end

  def test_conditional_assignment
    x = nil
    x ||= "default"
    assert_equal __, x
  end

  def test_conditional_assignment_does_not_overwrite
    x = "already set"
    x ||= "default"
    assert_equal __, x
  end

  def test_safe_navigation_on_nil
    # &. does not call the method when the receiver is nil — returns nil
    assert_equal __, nil&.upcase
  end

  def test_safe_navigation_on_value
    assert_equal __, "hello"&.upcase
  end

  def test_unless_as_inverse_of_if
    result = unless false
      "executed"
    end
    assert_equal __, result
  end

  def test_and_operator
    assert_equal __, (true && "value")
    assert_equal __, (nil && "value")
  end

  def test_or_operator
    assert_equal __, (nil || "fallback")
    assert_equal __, (false || "fallback")
    assert_equal __, ("first" || "fallback")
  end
end
