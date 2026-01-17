'''
Curring is a process of transforming a function that takes multiple arguments into a series of functions
that each take a single argument - nesting functions
'''

def multiply(a, b, c):
    return a * b * c

print(multiply(2, 3, 4))

#curried

def curried_multiply(a):
    def next(b):
        def final(c):
            return a * b * c
        return final
    return next

print(curried_multiply(2)(3)(4))
