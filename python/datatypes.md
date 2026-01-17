Build-in data types:
dict, list, set, frozenset, tuple, str, bytes, bytearray

Mutable: lists, bytearray, set, dict

Dict - dictionary
Key-Value pair object, iterable, mapping object, preserves order, mutable
d = {key: value}
Also dict comprehensions are possible

List
iterable, mutable, ordered, allow duplicates

Set
Unordered, unindexed, mutable, no duplicates, unchangable
Once a set is created, you cannot change its items (no index)
But items can be added
`thisset = {"apple", "banana", "cherry"}`


Frozenset
same thing as a set but immutable, hashable - can be used as keys in dict
`tup = (1, 2, 3, 4, 5, 6, 7, 8, 9)`
`froze_tup = frozenset(tup)`

Tuple
Immutable list, ordered, unchangable, allow duplicates
`mytuple = ("apple", "banana", "cherry")`
`thistuple = ("apple",)`

Str
Strings are immutable arrays of bytes representing unicode characters

Bytes
immutable sequence of integers in the range 0 <= x < 256.
bytes is an immutable version of bytearray
`b'string'`

Bytearray
mutable sequence of integers.
always created by calling a constructor `bytearray()`
