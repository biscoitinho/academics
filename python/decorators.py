'''
decorator is a function that takes
another function and extends the behavior
of the latter function without explicitly modifying it.
'''

import time

def timer(func):
    def wrapper():
        t1 = time.time()
        func()
        t2 = time.time() - t1
        print(f'It took {t2} seconds')
    return wrapper

@timer
def sleeper():
    time.sleep(1.3)

sleeper()
print('done')

