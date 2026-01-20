# Data Structures

## Array / List

Sequential collection of elements.

```python
# Python list (dynamic array)
arr = [1, 2, 3, 4, 5]

# Access
print(arr[0])    # 1 (first)
print(arr[-1])   # 5 (last)

# Modify
arr[0] = 10

# Add
arr.append(6)    # [10, 2, 3, 4, 5, 6]
arr.insert(0, 0) # [0, 10, 2, 3, 4, 5, 6]

# Remove
arr.pop()        # Remove last
arr.remove(10)   # Remove first occurrence

# Search
print(3 in arr)  # True
print(arr.index(3))  # Index of 3

# Slice
print(arr[1:4])  # Elements 1-3
```

```ruby
# Ruby array
arr = [1, 2, 3, 4, 5]

# Access
puts arr[0]     # 1
puts arr[-1]    # 5

# Add
arr << 6        # [1, 2, 3, 4, 5, 6]
arr.push(7)
arr.unshift(0)  # Add to beginning

# Remove
arr.pop         # Remove last
arr.shift       # Remove first

# Search
puts arr.include?(3)  # true
puts arr.index(3)     # Index of 3
```

**Operations:**
- Access: O(1)
- Search: O(n)
- Insert at end: O(1) amortized
- Insert at beginning: O(n)
- Delete: O(n)

## Stack (LIFO)

Last In, First Out.

```python
# Using list
stack = []

# Push
stack.append(1)
stack.append(2)
stack.append(3)

# Pop
print(stack.pop())  # 3
print(stack.pop())  # 2

# Peek
print(stack[-1])  # 1 (without removing)

# Check empty
print(len(stack) == 0)
```

```ruby
# Using array
stack = []

# Push
stack.push(1)
stack.push(2)
stack.push(3)

# Pop
puts stack.pop  # 3
puts stack.pop  # 2

# Peek
puts stack.last  # 1

# Empty?
puts stack.empty?
```

**Use cases:**
- Function call stack
- Undo/redo
- Expression evaluation
- Backtracking

## Queue (FIFO)

First In, First Out.

```python
from collections import deque

# Using deque (efficient)
queue = deque()

# Enqueue
queue.append(1)
queue.append(2)
queue.append(3)

# Dequeue
print(queue.popleft())  # 1
print(queue.popleft())  # 2

# Peek
print(queue[0])  # 3
```

```ruby
# Using array
queue = []

# Enqueue
queue.push(1)
queue.push(2)
queue.push(3)

# Dequeue
puts queue.shift  # 1
puts queue.shift  # 2

# Peek
puts queue.first  # 3
```

**Use cases:**
- Task scheduling
- BFS (breadth-first search)
- Print queue
- Message queues

## Linked List

Nodes connected by pointers.

```python
class Node:
    def __init__(self, data):
        self.data = data
        self.next = None

class LinkedList:
    def __init__(self):
        self.head = None

    def append(self, data):
        new_node = Node(data)
        if not self.head:
            self.head = new_node
            return
        current = self.head
        while current.next:
            current = current.next
        current.next = new_node

    def print_list(self):
        current = self.head
        while current:
            print(current.data, end=" -> ")
            current = current.next
        print("None")

# Usage
ll = LinkedList()
ll.append(1)
ll.append(2)
ll.append(3)
ll.print_list()  # 1 -> 2 -> 3 -> None
```

**Operations:**
- Access: O(n)
- Search: O(n)
- Insert at beginning: O(1)
- Insert at end: O(n) or O(1) with tail pointer
- Delete: O(n)

## Hash Table / Dictionary

Key-value pairs with fast lookup.

```python
# Python dict
d = {}

# Add/Update
d['name'] = 'Alice'
d['age'] = 30

# Access
print(d['name'])  # Alice
print(d.get('email', 'N/A'))  # N/A (default)

# Delete
del d['age']

# Check key
print('name' in d)  # True

# Iterate
for key, value in d.items():
    print(f"{key}: {value}")

# Keys/Values
print(d.keys())    # dict_keys(['name'])
print(d.values())  # dict_values(['Alice'])
```

```ruby
# Ruby hash
h = {}

# Add/Update
h[:name] = 'Alice'
h[:age] = 30

# Access
puts h[:name]  # Alice
puts h.fetch(:email, 'N/A')  # N/A

# Delete
h.delete(:age)

# Check key
puts h.key?(:name)  # true

# Iterate
h.each do |key, value|
  puts "#{key}: #{value}"
end
```

**Operations:**
- Access: O(1) average
- Insert: O(1) average
- Delete: O(1) average
- Search: O(1) average

## Set

Unique elements, no duplicates.

```python
# Python set
s = {1, 2, 3}
s = set([1, 2, 2, 3])  # {1, 2, 3}

# Add
s.add(4)

# Remove
s.remove(2)  # Raises KeyError if not found
s.discard(2) # No error if not found

# Check membership
print(3 in s)  # True

# Set operations
s1 = {1, 2, 3}
s2 = {3, 4, 5}

print(s1 | s2)  # {1, 2, 3, 4, 5} (union)
print(s1 & s2)  # {3} (intersection)
print(s1 - s2)  # {1, 2} (difference)
print(s1 ^ s2)  # {1, 2, 4, 5} (symmetric difference)
```

```ruby
require 'set'

# Ruby set
s = Set.new([1, 2, 3])

# Add
s.add(4)
s << 5

# Remove
s.delete(2)

# Check membership
puts s.include?(3)  # true

# Set operations
s1 = Set[1, 2, 3]
s2 = Set[3, 4, 5]

puts (s1 | s2).inspect  # #<Set: {1, 2, 3, 4, 5}>
puts (s1 & s2).inspect  # #<Set: {3}>
puts (s1 - s2).inspect  # #<Set: {1, 2}>
```

## Binary Tree

Hierarchical structure.

```python
class TreeNode:
    def __init__(self, val):
        self.val = val
        self.left = None
        self.right = None

# Build tree
#     1
#    / \
#   2   3
#  / \
# 4   5

root = TreeNode(1)
root.left = TreeNode(2)
root.right = TreeNode(3)
root.left.left = TreeNode(4)
root.left.right = TreeNode(5)

# Inorder traversal (Left, Root, Right)
def inorder(node):
    if node:
        inorder(node.left)
        print(node.val, end=" ")
        inorder(node.right)

inorder(root)  # 4 2 5 1 3

# Preorder (Root, Left, Right)
def preorder(node):
    if node:
        print(node.val, end=" ")
        preorder(node.left)
        preorder(node.right)

preorder(root)  # 1 2 4 5 3

# Postorder (Left, Right, Root)
def postorder(node):
    if node:
        postorder(node.left)
        postorder(node.right)
        print(node.val, end=" ")

postorder(root)  # 4 5 2 3 1
```

## Binary Search Tree (BST)

Ordered binary tree (left < root < right).

```python
class BST:
    def __init__(self, val):
        self.val = val
        self.left = None
        self.right = None

    def insert(self, val):
        if val < self.val:
            if self.left:
                self.left.insert(val)
            else:
                self.left = BST(val)
        else:
            if self.right:
                self.right.insert(val)
            else:
                self.right = BST(val)

    def search(self, val):
        if val == self.val:
            return True
        elif val < self.val:
            return self.left.search(val) if self.left else False
        else:
            return self.right.search(val) if self.right else False

# Usage
bst = BST(5)
bst.insert(3)
bst.insert(7)
bst.insert(1)
bst.insert(9)

print(bst.search(7))  # True
print(bst.search(6))  # False
```

**Operations** (balanced):
- Search: O(log n)
- Insert: O(log n)
- Delete: O(log n)

## Heap (Priority Queue)

Complete binary tree with heap property.

```python
import heapq

# Min heap (default)
heap = []

# Add elements
heapq.heappush(heap, 5)
heapq.heappush(heap, 1)
heapq.heappush(heap, 3)

# Get minimum
print(heapq.heappop(heap))  # 1
print(heapq.heappop(heap))  # 3

# Convert list to heap
arr = [5, 1, 3, 9, 2]
heapq.heapify(arr)
print(arr)  # [1, 2, 3, 9, 5]

# Max heap (negate values)
max_heap = []
heapq.heappush(max_heap, -5)
heapq.heappush(max_heap, -1)
heapq.heappush(max_heap, -3)
print(-heapq.heappop(max_heap))  # 5
```

**Operations:**
- Find min/max: O(1)
- Insert: O(log n)
- Delete min/max: O(log n)

## Graph

Nodes (vertices) connected by edges.

```python
# Adjacency list representation
graph = {
    'A': ['B', 'C'],
    'B': ['A', 'D', 'E'],
    'C': ['A', 'F'],
    'D': ['B'],
    'E': ['B', 'F'],
    'F': ['C', 'E']
}

# BFS (Breadth-First Search)
from collections import deque

def bfs(graph, start):
    visited = set()
    queue = deque([start])
    visited.add(start)

    while queue:
        node = queue.popleft()
        print(node, end=" ")

        for neighbor in graph[node]:
            if neighbor not in visited:
                visited.add(neighbor)
                queue.append(neighbor)

bfs(graph, 'A')  # A B C D E F

# DFS (Depth-First Search)
def dfs(graph, node, visited=None):
    if visited is None:
        visited = set()

    visited.add(node)
    print(node, end=" ")

    for neighbor in graph[node]:
        if neighbor not in visited:
            dfs(graph, neighbor, visited)

dfs(graph, 'A')  # A B D E F C
```

```ruby
# Graph representation
graph = {
  'A' => ['B', 'C'],
  'B' => ['A', 'D', 'E'],
  'C' => ['A', 'F'],
  'D' => ['B'],
  'E' => ['B', 'F'],
  'F' => ['C', 'E']
}

# BFS
def bfs(graph, start)
  visited = Set.new
  queue = [start]
  visited.add(start)

  until queue.empty?
    node = queue.shift
    print "#{node} "

    graph[node].each do |neighbor|
      unless visited.include?(neighbor)
        visited.add(neighbor)
        queue << neighbor
      end
    end
  end
end

bfs(graph, 'A')
```

## Trie (Prefix Tree)

Tree for storing strings with common prefixes.

```python
class TrieNode:
    def __init__(self):
        self.children = {}
        self.is_end = False

class Trie:
    def __init__(self):
        self.root = TrieNode()

    def insert(self, word):
        node = self.root
        for char in word:
            if char not in node.children:
                node.children[char] = TrieNode()
            node = node.children[char]
        node.is_end = True

    def search(self, word):
        node = self.root
        for char in word:
            if char not in node.children:
                return False
            node = node.children[char]
        return node.is_end

    def starts_with(self, prefix):
        node = self.root
        for char in prefix:
            if char not in node.children:
                return False
            node = node.children[char]
        return True

# Usage
trie = Trie()
trie.insert("apple")
trie.insert("app")

print(trie.search("apple"))      # True
print(trie.search("app"))        # True
print(trie.search("appl"))       # False
print(trie.starts_with("app"))   # True
```

**Use cases:**
- Autocomplete
- Spell checker
- IP routing

## Deque (Double-ended Queue)

Queue with operations at both ends.

```python
from collections import deque

dq = deque([1, 2, 3])

# Add to right
dq.append(4)  # [1, 2, 3, 4]

# Add to left
dq.appendleft(0)  # [0, 1, 2, 3, 4]

# Remove from right
print(dq.pop())  # 4

# Remove from left
print(dq.popleft())  # 0

print(dq)  # deque([1, 2, 3])
```

## Choosing Data Structure

```
Need fast lookup by key?
→ Hash table (dict)

Need ordered data?
→ List/Array

Need unique elements?
→ Set

Need LIFO (undo/redo)?
→ Stack

Need FIFO (task queue)?
→ Queue

Need priority?
→ Heap

Need hierarchical data?
→ Tree

Need relationships?
→ Graph

Need prefix matching?
→ Trie

Need both ends access?
→ Deque
```

## Time Complexities Summary

```
Array/List:
  Access: O(1)
  Search: O(n)
  Insert: O(n)
  Delete: O(n)

Linked List:
  Access: O(n)
  Search: O(n)
  Insert: O(1)
  Delete: O(1) (if node known)

Hash Table:
  Access: O(1) avg
  Search: O(1) avg
  Insert: O(1) avg
  Delete: O(1) avg

Binary Search Tree (balanced):
  Access: O(log n)
  Search: O(log n)
  Insert: O(log n)
  Delete: O(log n)

Heap:
  Find min: O(1)
  Insert: O(log n)
  Delete min: O(log n)
```

## Space Complexity

```python
# Array
arr = [1, 2, 3, 4, 5]  # O(n)

# Hash table
d = {'a': 1, 'b': 2}  # O(n)

# Graph (adjacency list)
graph = {
    'A': ['B', 'C'],
    'B': ['A']
}  # O(V + E) where V = vertices, E = edges

# Linked list
# O(n) + pointer overhead

# Tree
# O(n) + pointer overhead
```

## Practical Examples

### LRU Cache

```python
from collections import OrderedDict

class LRUCache:
    def __init__(self, capacity):
        self.cache = OrderedDict()
        self.capacity = capacity

    def get(self, key):
        if key not in self.cache:
            return -1
        # Move to end (most recent)
        self.cache.move_to_end(key)
        return self.cache[key]

    def put(self, key, value):
        if key in self.cache:
            self.cache.move_to_end(key)
        self.cache[key] = value
        if len(self.cache) > self.capacity:
            # Remove oldest
            self.cache.popitem(last=False)

# Usage
cache = LRUCache(2)
cache.put(1, 1)
cache.put(2, 2)
print(cache.get(1))  # 1
cache.put(3, 3)      # Evicts key 2
print(cache.get(2))  # -1 (not found)
```

### Find Duplicates

```python
# Using set - O(n)
def has_duplicates(arr):
    seen = set()
    for num in arr:
        if num in seen:
            return True
        seen.add(num)
    return False

print(has_duplicates([1, 2, 3, 4]))  # False
print(has_duplicates([1, 2, 2, 3]))  # True
```

### Group Anagrams

```python
from collections import defaultdict

def group_anagrams(words):
    groups = defaultdict(list)
    for word in words:
        # Sort word as key
        key = ''.join(sorted(word))
        groups[key].append(word)
    return list(groups.values())

words = ["eat", "tea", "tan", "ate", "nat", "bat"]
print(group_anagrams(words))
# [['eat', 'tea', 'ate'], ['tan', 'nat'], ['bat']]
```
