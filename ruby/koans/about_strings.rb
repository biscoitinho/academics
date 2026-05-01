require_relative 'koans'

# Topic: String methods in Ruby
# Source: ruby/string_methods.md

class AboutStrings < Koans::TestCase
  def test_interpolation
    name = "Ruby"
    assert_equal __, "Hello, #{name}!"
  end

  def test_upcase
    assert_equal __, "hello".upcase
  end

  def test_downcase
    assert_equal __, "HELLO".downcase
  end

  def test_capitalize
    assert_equal __, "hello world".capitalize
  end

  def test_swapcase
    assert_equal __, "Hello".swapcase
  end

  def test_include
    assert_equal __, "hello world".include?("world")
    assert_equal __, "hello world".include?("xyz")
  end

  def test_start_with
    assert_equal __, "hello".start_with?("he")
  end

  def test_end_with
    assert_equal __, "hello".end_with?("lo")
  end

  def test_empty
    assert_equal __, "".empty?
    assert_equal __, "a".empty?
  end

  def test_strip
    assert_equal __, "  hello  ".strip
    assert_equal __, "  hello  ".lstrip
    assert_equal __, "  hello  ".rstrip
  end

  def test_reverse
    assert_equal __, "hello".reverse
  end

  def test_string_multiplication
    assert_equal __, "ha" * 3
  end

  def test_split
    assert_equal __, "hello world".split(" ")
  end

  def test_split_on_character
    assert_equal __, "a,b,c".split(",")
  end

  def test_chars
    assert_equal __, "hi".chars
  end

  def test_length
    assert_equal __, "hello".length
  end

  def test_indexing
    assert_equal __, "hello"[0]
    assert_equal __, "hello"[-1]
    assert_equal __, "hello"[1..3]
  end

  def test_gsub
    assert_equal __, "hello world".gsub("o", "0")
  end

  def test_sub_replaces_first_occurrence
    assert_equal __, "aaa".sub("a", "b")
  end

  def test_convert_to_integer
    assert_equal __, "42".to_i
  end

  def test_convert_to_float
    assert_equal __, "3.14".to_f
  end

  def test_string_concatenation
    assert_equal __, "hello" + " " + "world"
  end

  def test_index
    assert_equal __, "hello".index("l")
  end

  def test_count_characters
    assert_equal __, "hello".count("l")
  end
end
