Built-in data types:
dict, list, set, frozenset, tuple, str, bytes, bytearray

Mutable: lists, bytearray, set, dict

## Dict - dictionary
Key-Value pair object, iterable, mapping object, preserves order, mutable

```python
d = {key: value}
```

Also dict comprehensions are possible

## List
Iterable, mutable, ordered, allow duplicates

## Set
Unordered, unindexed, mutable, no duplicates, unchangeable
Once a set is created, you cannot change its items (no index)
But items can be added

```python
thisset = {"apple", "banana", "cherry"}
```

## Frozenset
Same thing as a set but immutable, hashable - can be used as keys in dict

```python
tup = (1, 2, 3, 4, 5, 6, 7, 8, 9)
froze_tup = frozenset(tup)
```

## Tuple
Immutable list, ordered, unchangeable, allow duplicates

```python
mytuple = ("apple", "banana", "cherry")
thistuple = ("apple",)
```

## Str
Strings are immutable arrays of bytes representing unicode characters

## Bytes
Immutable sequence of integers in the range 0 <= x < 256.
bytes is an immutable version of bytearray

```python
b'string'
```

## Bytearray
Mutable sequence of integers.
Always created by calling a constructor `bytearray()`
