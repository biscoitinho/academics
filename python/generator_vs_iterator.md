Every generator is na iterator
Not every iterator is a generator

Iterator is more of a low level approch

Easiest way to make a custom iterator is by using a generator

To implement an iterator there has to be a custom class
with __iter__ and __next__

Iterator is a concept to make a iterable object

Example a function generating a fibonacci sequence can be a standard function
or be implemented as an iterator

Iterator as well as a generators has a low memory footprint

Iterators don’t use any variables to iterate whereas generators
use local variables and store the state of those variables
whenever the loop is paused by the yield statement.

Iterators are mostly used to convert iterables and iterate
such iterables but generators are mostly used to create iterators
and generate new values in a loop without disturbing the iteration of that loop.

Iterators in Python

Implemented using Class
No yield statement
Use the iter() function
Local variables are not used
They are mostly used to convert iterables into iterators
All iterators are not generators

Generators in Python

Implemented using Function
Use yield statement
Do not use the iter() function.
Local variables are used
They are mostly used to create iterators
All generators are iterators

TO DO: iterator example
