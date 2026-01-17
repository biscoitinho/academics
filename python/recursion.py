'''
def fn():
    if condition:
        stop calling itself
    else:
        fn()
'''

#easiest example

def counter(start):
    print(start)
    next = start - 1
    if next > 0:
        counter(next)

counter(3)

#sum of a sequence

def adder(n):
    if n > 0:
        return n + adder(n - 1)
    return 0

print(adder(10))
