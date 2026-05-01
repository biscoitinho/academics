require_relative 'koans'

# Temat: Metody hashy w Ruby
# Dokumentacja: ruby/hash_methods.md

class AboutHashes < Koans::TestCase
  def test_dostep_po_kluczu
    h = { name: "Alice", age: 30 }
    assert_equal __, h[:name]
    assert_equal __, h[:age]
  end

  def test_brakujacy_klucz_zwraca_nil
    h = { name: "Alice" }
    assert_equal __, h[:nieistniejacy]
  end

  def test_klucze
    h = { a: 1, b: 2 }
    assert_equal __, h.keys
  end

  def test_wartosci
    h = { a: 1, b: 2 }
    assert_equal __, h.values
  end

  def test_rozmiar
    h = { a: 1, b: 2, c: 3 }
    assert_equal __, h.size
  end

  def test_pusty_hash
    assert_equal __, {}.empty?
    assert_equal __, { a: 1 }.empty?
  end

  def test_sprawdzenie_klucza
    h = { name: "Alice" }
    assert_equal __, h.key?(:name)
    assert_equal __, h.key?(:age)
  end

  def test_sprawdzenie_wartosci
    h = { name: "Alice" }
    assert_equal __, h.value?("Alice")
    assert_equal __, h.value?("Bob")
  end

  def test_fetch_istniejacy_klucz
    h = { age: 30 }
    assert_equal __, h.fetch(:age)
  end

  def test_fetch_z_domyslna_wartoscia
    h = { age: 30 }
    assert_equal __, h.fetch(:miasto, "Warszawa")
  end

  def test_merge
    h1 = { a: 1, b: 2 }
    h2 = { b: 3, c: 4 }
    wynik = h1.merge(h2)
    assert_equal __, wynik[:b]
    assert_equal __, wynik[:c]
    assert_equal __, h1[:b]
  end

  def test_merge_modyfikuje
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

  def test_konwersja_na_tablice
    h = { a: 1, b: 2 }
    assert_equal __, h.to_a
  end

  def test_dig_zagniezdzone
    dane = { user: { name: "Alice", city: "Krakow" } }
    assert_equal __, dane.dig(:user, :name)
    assert_equal __, dane.dig(:user, :kraj)
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
