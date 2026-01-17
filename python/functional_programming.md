Declarative approch insted of imperative


Writing a function

- must be deterministic
- free of side effects
        side effect is when fuction alter sme external variable
        goal is to minimize not elimiate side effects

example WITH side effects:

'''
ans = 0

def add(x, y):
    ans = x + y
'''

example WITHOUT side effects:

'''
ans = 0

def add(x, y):
    return x + y

ans = add(x, y)
'''

- function should always have all parameters passed and should not rely on the global state
- recursion insted of loops
- passing functions as arguments to other functions ("functions as first class citizens")

'''
def add(x, y):
    return x + y

def times3(a, b, function):
    return 3 * function(a,b)

add_times3 = times3(2, 4, add))
'''

