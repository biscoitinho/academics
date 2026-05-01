require_relative 'koans'

# Topic: Iteration and Enumerable
# Source: ruby/iterating_enumerables.md

class AboutEnumerables < Koans::TestCase
  def test_map_transforms_elements
    assert_equal __, [1, 2, 3].map { |n| n * 2 }
  end

  def test_select_filters_elements
    assert_equal __, [1, 2, 3, 4].select { |n| n.even? }
  end

  def test_reject_is_inverse_of_select
    assert_equal __, [1, 2, 3, 4].reject { |n| n.even? }
  end

  def test_reduce_sums
    assert_equal __, [1, 2, 3, 4].reduce(:+)
  end

  def test_reduce_with_initial_value
    assert_equal __, [1, 2, 3].reduce(10, :+)
  end

  def test_sum
    assert_equal __, [1, 2, 3].sum
  end

  def test_find_returns_first_match
    assert_equal __, [1, 2, 3, 4].find { |n| n > 2 }
  end

  def test_all_checks_all_elements
    assert_equal __, [2, 4, 6].all? { |n| n.even? }
    assert_equal __, [2, 3, 6].all? { |n| n.even? }
  end

  def test_any_checks_at_least_one
    assert_equal __, [1, 2, 3].any? { |n| n > 2 }
    assert_equal __, [1, 2, 3].any? { |n| n > 10 }
  end

  def test_none_checks_no_matches
    assert_equal __, [1, 3, 5].none? { |n| n.even? }
    assert_equal __, [1, 2, 5].none? { |n| n.even? }
  end

  def test_count_matching_elements
    assert_equal __, [1, 2, 3, 4].count { |n| n.even? }
  end

  def test_sort_sorts
    assert_equal __, [3, 1, 2].sort
  end

  def test_sort_by_criterion
    words = ["banana", "apple", "fig"]
    assert_equal __, words.sort_by { |s| s.length }
  end

  def test_min_and_max
    assert_equal __, [3, 1, 4, 1, 5].min
    assert_equal __, [3, 1, 4, 1, 5].max
  end

  def test_min_by_and_max_by
    words = ["a", "bbb", "cc"]
    assert_equal __, words.min_by { |s| s.length }
    assert_equal __, words.max_by { |s| s.length }
  end

  def test_flat_map_flattens_result
    assert_equal __, [[1, 2], [3, 4]].flat_map { |arr| arr }
  end

  def test_each_with_index
    results = []
    ["a", "b", "c"].each_with_index { |el, i| results << "#{i}:#{el}" }
    assert_equal __, results
  end

  def test_group_by
    assert_equal __, [1, 2, 3, 4].group_by { |n| n.even? ? :even : :odd }
  end

  def test_partition
    evens, odds = [1, 2, 3, 4].partition { |n| n.even? }
    assert_equal __, evens
    assert_equal __, odds
  end

  def test_symbol_to_proc
    assert_equal __, ["hello", "world"].map(&:upcase)
  end

  def test_first_and_last
    arr = [1, 2, 3, 4, 5]
    assert_equal __, arr.first
    assert_equal __, arr.last
    assert_equal __, arr.first(2)
  end

  def test_take_and_drop
    assert_equal __, [1, 2, 3, 4].take(2)
    assert_equal __, [1, 2, 3, 4].drop(2)
  end
end
