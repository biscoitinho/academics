## Iterating and Enumerables in Ruby

Comprehensive guide to iterating over collections in Ruby.

### Basic iteration methods

#### each

The most basic iterator - doesn't return anything useful.

```ruby
[1, 2, 3].each { |num| puts num }
# Prints: 1, 2, 3
# Returns: [1, 2, 3]

# Multi-line form
[1, 2, 3].each do |num|
  puts num * 2
end
```

#### each_with_index

Get both the element and its index.

```ruby
['a', 'b', 'c'].each_with_index do |letter, index|
  puts "#{index}: #{letter}"
end
# 0: a
# 1: b
# 2: c
```

#### each_with_object

Iterate and build an object.

```ruby
[1, 2, 3].each_with_object({}) do |num, hash|
  hash[num] = num * 2
end
# {1 => 2, 2 => 4, 3 => 6}
```

### Transforming collections

#### map (or collect)

Transform each element and return new array.

```ruby
[1, 2, 3].map { |n| n * 2 }
# [2, 4, 6]

# With index
[1, 2, 3].map.with_index { |n, i| n * i }
# [0, 2, 6]

# Can transform types
['1', '2', '3'].map(&:to_i)
# [1, 2, 3]
```

#### flat_map (or collect_concat)

Map and flatten one level.

```ruby
[[1, 2], [3, 4]].flat_map { |arr| arr.map { |n| n * 2 } }
# [2, 4, 6, 8]

# Useful for nested structures
users = [
  { name: 'Alice', hobbies: ['reading', 'coding'] },
  { name: 'Bob', hobbies: ['gaming', 'music'] }
]
users.flat_map { |u| u[:hobbies] }
# ['reading', 'coding', 'gaming', 'music']
```

### Filtering collections

#### select (or find_all)

Keep only elements that match condition.

```ruby
[1, 2, 3, 4, 5].select { |n| n.even? }
# [2, 4]

[1, 2, 3, 4, 5].select(&:even?)
# [2, 4]
```

#### reject

Opposite of select - remove matching elements.

```ruby
[1, 2, 3, 4, 5].reject { |n| n.even? }
# [1, 3, 5]
```

#### grep

Filter using pattern matching.

```ruby
['apple', 'banana', 'apricot'].grep(/^a/)
# ['apple', 'apricot']

[1, 2, 3, 4, 5].grep(2..4)
# [2, 3, 4]
```

### Finding elements

#### find (or detect)

Return first matching element.

```ruby
[1, 2, 3, 4, 5].find { |n| n > 3 }
# 4

# Returns nil if not found
[1, 2, 3].find { |n| n > 10 }
# nil
```

#### find_all

Same as select.

```ruby
[1, 2, 3, 4, 5].find_all { |n| n > 2 }
# [3, 4, 5]
```

#### find_index

Return index of first match.

```ruby
[1, 2, 3, 4, 5].find_index { |n| n > 3 }
# 3

['a', 'b', 'c'].find_index('b')
# 1
```

### Reducing/Aggregating

#### reduce (or inject)

Combine all elements into single value.

```ruby
# Sum
[1, 2, 3, 4, 5].reduce(0) { |sum, n| sum + n }
# 15

# Product
[1, 2, 3, 4, 5].reduce(1, :*)
# 120

# Build hash
['a', 'b', 'c'].reduce({}) do |hash, letter|
  hash[letter] = letter.upcase
  hash
end
# {'a' => 'A', 'b' => 'B', 'c' => 'C'}
```

#### sum

Dedicated method for summing (Ruby 2.4+).

```ruby
[1, 2, 3, 4, 5].sum
# 15

[1, 2, 3].sum(10)  # With initial value
# 16
```

### Boolean checks

#### all?

Check if all elements match condition.

```ruby
[2, 4, 6].all?(&:even?)
# true

[1, 2, 3].all? { |n| n > 0 }
# true

[].all?
# true (empty array)
```

#### any?

Check if any element matches condition.

```ruby
[1, 2, 3].any?(&:even?)
# true

[1, 3, 5].any?(&:even?)
# false

[].any?
# false
```

#### none?

Check if no elements match condition.

```ruby
[1, 3, 5].none?(&:even?)
# true

[1, 2, 3].none? { |n| n > 10 }
# true
```

#### one?

Check if exactly one element matches.

```ruby
[1, 2, 3].one?(&:even?)
# true

[2, 4, 6].one?(&:even?)
# false
```

### Partitioning and grouping

#### partition

Split into two arrays based on condition.

```ruby
[1, 2, 3, 4, 5].partition(&:even?)
# [[2, 4], [1, 3, 5]]
```

#### group_by

Group elements by a key.

```ruby
[1, 2, 3, 4, 5].group_by { |n| n % 2 }
# {1 => [1, 3, 5], 0 => [2, 4]}

words = ['apple', 'apricot', 'banana', 'blueberry']
words.group_by { |w| w[0] }
# {'a' => ['apple', 'apricot'], 'b' => ['banana', 'blueberry']}
```

#### chunk

Group consecutive elements.

```ruby
[1, 1, 2, 2, 2, 3, 4, 4].chunk { |n| n }.to_a
# [[1, [1, 1]], [2, [2, 2, 2]], [3, [3]], [4, [4, 4]]]
```

#### slice_before / slice_after

Split array at certain points.

```ruby
[1, 2, 3, 4, 5].slice_before(&:even?).to_a
# [[1], [2, 3], [4, 5]]
```

### Sorting

#### sort

Sort array.

```ruby
[3, 1, 4, 1, 5].sort
# [1, 1, 3, 4, 5]

# Descending
[3, 1, 4, 1, 5].sort.reverse
# [5, 4, 3, 1, 1]

# Custom sort
words = ['apple', 'pie', 'Washington', 'book']
words.sort_by(&:length)
# ['pie', 'book', 'apple', 'Washington']
```

#### sort_by

More efficient for complex sorts.

```ruby
people = [
  { name: 'Alice', age: 30 },
  { name: 'Bob', age: 25 },
  { name: 'Charlie', age: 35 }
]

people.sort_by { |p| p[:age] }
# Sorted by age

# Multiple criteria
people.sort_by { |p| [p[:age], p[:name]] }
```

### Taking and dropping

#### first / last

Get first or last elements.

```ruby
[1, 2, 3, 4, 5].first
# 1

[1, 2, 3, 4, 5].last(2)
# [4, 5]
```

#### take / drop

Take or drop n elements from start.

```ruby
[1, 2, 3, 4, 5].take(3)
# [1, 2, 3]

[1, 2, 3, 4, 5].drop(3)
# [4, 5]
```

#### take_while / drop_while

Take/drop while condition is true.

```ruby
[1, 2, 3, 4, 1, 2].take_while { |n| n < 4 }
# [1, 2, 3]

[1, 2, 3, 4, 5].drop_while { |n| n < 4 }
# [4, 5]
```

### Counting and min/max

#### count

Count elements or matches.

```ruby
[1, 2, 3, 4, 5].count
# 5

[1, 2, 3, 2, 1].count(2)
# 2

[1, 2, 3, 4, 5].count(&:even?)
# 2
```

#### min / max

Find minimum or maximum.

```ruby
[3, 1, 4, 1, 5].min
# 1

[3, 1, 4, 1, 5].max
# 5

# By custom criteria
words = ['apple', 'pie', 'Washington']
words.min_by(&:length)
# 'pie'
```

#### minmax

Get both min and max.

```ruby
[3, 1, 4, 1, 5].minmax
# [1, 5]
```

### Zipping and cycling

#### zip

Combine multiple arrays.

```ruby
[1, 2, 3].zip(['a', 'b', 'c'])
# [[1, 'a'], [2, 'b'], [3, 'c']]

[1, 2].zip([3, 4], [5, 6])
# [[1, 3, 5], [2, 4, 6]]
```

#### cycle

Repeat elements infinitely (use with caution!).

```ruby
[1, 2, 3].cycle(2).to_a
# [1, 2, 3, 1, 2, 3]

# Infinite loop (need break condition)
[1, 2, 3].cycle do |n|
  puts n
  break if some_condition
end
```

### Lazy evaluation

Use `lazy` for memory-efficient operations on large collections.

```ruby
# Without lazy - processes entire array
(1..Float::INFINITY).map { |n| n * 2 }.first(5)
# Infinite loop!

# With lazy - only processes what's needed
(1..Float::INFINITY).lazy.map { |n| n * 2 }.first(5)
# [2, 4, 6, 8, 10]

# Chain operations efficiently
(1..1000000)
  .lazy
  .select(&:even?)
  .map { |n| n * 2 }
  .first(5)
# [4, 8, 12, 16, 20]
```

### Hash-specific iteration

```ruby
hash = { a: 1, b: 2, c: 3 }

# Iterate over keys and values
hash.each { |key, value| puts "#{key}: #{value}" }

# Just keys
hash.each_key { |key| puts key }

# Just values
hash.each_value { |value| puts value }

# Transform
hash.transform_values { |v| v * 2 }
# { a: 2, b: 4, c: 6 }

# Select
hash.select { |k, v| v > 1 }
# { b: 2, c: 3 }
```

### Method chaining

Combine multiple enumerable methods.

```ruby
[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
  .select(&:even?)
  .map { |n| n * 2 }
  .reduce(:+)
# 60

# More complex example
users = [
  { name: 'Alice', age: 30, active: true },
  { name: 'Bob', age: 25, active: false },
  { name: 'Charlie', age: 35, active: true }
]

users
  .select { |u| u[:active] }
  .map { |u| u[:name] }
  .sort
# ['Alice', 'Charlie']
```

### Symbol to_proc shorthand

```ruby
# Long form
[1, 2, 3].map { |n| n.to_s }

# Short form with &:method
[1, 2, 3].map(&:to_s)

# Works with any method
['apple', 'banana', 'cherry'].map(&:upcase)
# ['APPLE', 'BANANA', 'CHERRY']

[1, 2, 3, 4, 5].select(&:even?)
# [2, 4]
```
