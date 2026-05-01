require_relative 'koans'

# Temat: Metody stringow w Ruby
# Dokumentacja: ruby/string_methods.md

class AboutStrings < Koans::TestCase
  def test_interpolacja
    imie = "Ruby"
    assert_equal __, "Czesc, #{imie}!"
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

  def test_mnozenie_stringa
    assert_equal __, "ha" * 3
  end

  def test_split
    assert_equal __, "hello world".split(" ")
  end

  def test_split_po_znaku
    assert_equal __, "a,b,c".split(",")
  end

  def test_chars
    assert_equal __, "hi".chars
  end

  def test_length
    assert_equal __, "hello".length
  end

  def test_indeksowanie
    assert_equal __, "hello"[0]
    assert_equal __, "hello"[-1]
    assert_equal __, "hello"[1..3]
  end

  def test_gsub
    assert_equal __, "hello world".gsub("o", "0")
  end

  def test_sub_zastepuje_pierwsze_wystapienie
    assert_equal __, "aaa".sub("a", "b")
  end

  def test_konwersja_na_integer
    assert_equal __, "42".to_i
  end

  def test_konwersja_na_float
    assert_equal __, "3.14".to_f
  end

  def test_laczenie_stringow
    assert_equal __, "hello" + " " + "world"
  end

  def test_index
    assert_equal __, "hello".index("l")
  end

  def test_count_znakow
    assert_equal __, "hello".count("l")
  end
end
