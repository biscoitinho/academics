require_relative 'koans'

# Temat: Struktury danych — mutowalnosc i niemutowalnosc
# Dokumentacja: ruby/data_structures.md

class AboutDataStructures < Koans::TestCase
  def test_string_jest_mutowalny
    s = "hello"
    s << " world"
    assert_equal __, s
  end

  def test_operator_shovel_modyfikuje_obiekt
    a = "original"
    b = a
    a << " modified"
    # b wskazuje na ten sam obiekt!
    assert_equal __, b
  end

  def test_symbol_jest_niemutowalny
    assert_equal __, :hello.frozen?
  end

  def test_liczby_sa_niemutowalne
    assert_equal __, 42.frozen?
  end

  def test_freeze_zamraza_obiekt
    s = "zamroz mnie".freeze
    assert_equal __, s.frozen?
  end

  def test_freeze_blokuje_modyfikacje
    s = "zamrozony".freeze
    assert_raise(FrozenError) { s << " tekst" }
    assert_equal __, s
  end

  def test_sort_bang_modyfikuje_tablice
    arr = [3, 1, 2]
    arr.sort!
    assert_equal __, arr
  end

  def test_sort_bez_bang_nie_modyfikuje
    arr = [3, 1, 2]
    arr.sort
    assert_equal __, arr
  end

  def test_push_dodaje_na_koniec
    arr = [1, 2]
    arr.push(3)
    assert_equal __, arr
  end

  def test_pop_usuwa_z_konca
    arr = [1, 2, 3]
    ostatni = arr.pop
    assert_equal __, ostatni
    assert_equal __, arr
  end

  def test_unshift_dodaje_na_poczatek
    arr = [2, 3]
    arr.unshift(1)
    assert_equal __, arr
  end

  def test_shift_usuwa_z_poczatku
    arr = [1, 2, 3]
    pierwszy = arr.shift
    assert_equal __, pierwszy
    assert_equal __, arr
  end

  def test_dup_tworzy_kopie
    oryginalna = [1, 2, 3]
    kopia = oryginalna.dup
    kopia << 4
    assert_equal __, oryginalna.size
    assert_equal __, kopia.size
  end

  def test_reverse_bang_modyfikuje_tablice
    arr = [1, 2, 3]
    arr.reverse!
    assert_equal __, arr
  end

  def test_map_bang_modyfikuje_tablice
    arr = [1, 2, 3]
    arr.map! { |n| n * 2 }
    assert_equal __, arr
  end
end
