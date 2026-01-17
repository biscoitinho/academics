Basic syntax:

`new_list = [expression for member in iterable]`
or with conditional statement
`new_list = [expression for member in iterable if conditional]`

for loop example:

'''
arr = [1,2,3,4,5]

for _ in arr:
    print(_**_)
'''

list comprehention:
'''
[ n**n for n in arr]
'''

map:
'''
list(map(lambda n: n**n, arr))
'''

list comprehention with conditional:
'''
[n**n for n in arr if n > 0]
'''

with a function:
'''
def make_it_big(num):
   return num**num

[make_it_big(n) for n in arr]
'''

set/dict comprehentions:

set:
'''
{n**n for n in arr}
'''

dict:
'''
{n: n**n for n in arr}
'''

matrix:
'''
[[n for n in range(3)] for i in range(3)]
'''
output=>
[
    [0,1,2],
    [0,1,2],
    [0,1,2]
]
