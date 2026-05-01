require_relative 'koans'

# Temat: Iteracja i Enumerable
# Dokumentacja: ruby/iterating_enumerables.md

class AboutEnumerables < Koans::TestCase
  def test_map_transformuje_elementy
    assert_equal __, [1, 2, 3].map { |n| n * 2 }
  end

  def test_select_filtruje_elementy
    assert_equal __, [1, 2, 3, 4].select { |n| n.even? }
  end

  def test_reject_odwrotnosc_select
    assert_equal __, [1, 2, 3, 4].reject { |n| n.even? }
  end

  def test_reduce_sumuje
    assert_equal __, [1, 2, 3, 4].reduce(:+)
  end

  def test_reduce_z_wartoscia_poczatkowa
    assert_equal __, [1, 2, 3].reduce(10, :+)
  end

  def test_sum
    assert_equal __, [1, 2, 3].sum
  end

  def test_find_zwraca_pierwszy_pasujacy
    assert_equal __, [1, 2, 3, 4].find { |n| n > 2 }
  end

  def test_all_sprawdza_wszystkie
    assert_equal __, [2, 4, 6].all? { |n| n.even? }
    assert_equal __, [2, 3, 6].all? { |n| n.even? }
  end

  def test_any_sprawdza_czy_choc_jeden
    assert_equal __, [1, 2, 3].any? { |n| n > 2 }
    assert_equal __, [1, 2, 3].any? { |n| n > 10 }
  end

  def test_none_sprawdza_brak_pasujacych
    assert_equal __, [1, 3, 5].none? { |n| n.even? }
    assert_equal __, [1, 2, 5].none? { |n| n.even? }
  end

  def test_count_zlicza_pasujace
    assert_equal __, [1, 2, 3, 4].count { |n| n.even? }
  end

  def test_sort_sortuje
    assert_equal __, [3, 1, 2].sort
  end

  def test_sort_by_sortuje_wedlug_kryterium
    slowa = ["banan", "jablko", "fig"]
    assert_equal __, slowa.sort_by { |s| s.length }
  end

  def test_min_i_max
    assert_equal __, [3, 1, 4, 1, 5].min
    assert_equal __, [3, 1, 4, 1, 5].max
  end

  def test_min_by_i_max_by
    slowa = ["a", "bbb", "cc"]
    assert_equal __, slowa.min_by { |s| s.length }
    assert_equal __, slowa.max_by { |s| s.length }
  end

  def test_flat_map_splaszcza_wynik
    assert_equal __, [[1, 2], [3, 4]].flat_map { |arr| arr }
  end

  def test_each_with_index
    wyniki = []
    ["a", "b", "c"].each_with_index { |el, i| wyniki << "#{i}:#{el}" }
    assert_equal __, wyniki
  end

  def test_group_by
    assert_equal __, [1, 2, 3, 4].group_by { |n| n.even? ? :parzyste : :nieparzyste }
  end

  def test_partition
    parzyste, nieparzyste = [1, 2, 3, 4].partition { |n| n.even? }
    assert_equal __, parzyste
    assert_equal __, nieparzyste
  end

  def test_symbol_to_proc
    assert_equal __, ["hello", "world"].map(&:upcase)
  end

  def test_first_i_last
    arr = [1, 2, 3, 4, 5]
    assert_equal __, arr.first
    assert_equal __, arr.last
    assert_equal __, arr.first(2)
  end

  def test_take_i_drop
    assert_equal __, [1, 2, 3, 4].take(2)
    assert_equal __, [1, 2, 3, 4].drop(2)
  end
end
