from functools import reduce

# lambda example

def standard_func(a: int, b: int) -> int:
    return a + b

add = lambda a, b : a + b

print(standard_func(1,2))
print(add(1,2))

# map

l = [1,2,3,4,5]

mapper = map(lambda x : x + 1, l)
print(list(mapper))

# filter

#creates a list of elements for witch the function returns true

fil = filter(lambda x : x > 1, l)
print(list(fil))

# reduce

#useful for performing computation on a list and returning the result
# it performs a rolling computation to sequential pairs of values in a list

red = reduce((lambda x, y : x * y), l)
print(red)
