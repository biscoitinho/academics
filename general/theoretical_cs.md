# Theoretical Computer Science

Foundational CS concepts with practical applications.

## Recursion & Dynamic Programming

### Recursion Basics

**Function calls itself** to solve smaller subproblems.

```python
# Factorial
def factorial(n):
    # Base case
    if n <= 1:
        return 1
    # Recursive case
    return n * factorial(n - 1)

factorial(5)  # 5 * 4 * 3 * 2 * 1 = 120
```

**Key parts**:
1. **Base case** - Stop condition
2. **Recursive case** - Call itself with smaller problem
3. **Progress** - Must move toward base case

### Fibonacci (Naive)

```python
def fib(n):
    if n <= 1:
        return n
    return fib(n-1) + fib(n-2)

fib(5)  # 5
```

**Problem**: Recalculates same values repeatedly.

```
fib(5)
├── fib(4)
│   ├── fib(3)
│   │   ├── fib(2)  # Calculated multiple times!
│   │   └── fib(1)
│   └── fib(2)
└── fib(3)  # Duplicated!
```

**Time complexity**: O(2^n) - exponential!

### Dynamic Programming

**Remember results** to avoid recalculation.

#### Top-Down (Memoization)

```python
def fib_memo(n, memo={}):
    if n in memo:
        return memo[n]  # Already calculated
    if n <= 1:
        return n

    memo[n] = fib_memo(n-1, memo) + fib_memo(n-2, memo)
    return memo[n]

fib_memo(100)  # Fast!
```

**Time complexity**: O(n) - each value calculated once

#### Bottom-Up (Tabulation)

```python
def fib_dp(n):
    if n <= 1:
        return n

    dp = [0] * (n + 1)
    dp[1] = 1

    for i in range(2, n + 1):
        dp[i] = dp[i-1] + dp[i-2]

    return dp[n]
```

**Space optimization**:
```python
def fib_optimal(n):
    if n <= 1:
        return n

    prev, curr = 0, 1
    for _ in range(2, n + 1):
        prev, curr = curr, prev + curr

    return curr
```

**Space complexity**: O(1) - constant space!

### Classic DP Problems

#### Coin Change

**Problem**: Minimum coins to make amount.

```python
def coin_change(coins, amount):
    dp = [float('inf')] * (amount + 1)
    dp[0] = 0  # 0 coins for amount 0

    for coin in coins:
        for x in range(coin, amount + 1):
            dp[x] = min(dp[x], dp[x - coin] + 1)

    return dp[amount] if dp[amount] != float('inf') else -1

coin_change([1, 2, 5], 11)  # 3 coins (5+5+1)
```

#### Longest Common Subsequence

```python
def lcs(s1, s2):
    m, n = len(s1), len(s2)
    dp = [[0] * (n + 1) for _ in range(m + 1)]

    for i in range(1, m + 1):
        for j in range(1, n + 1):
            if s1[i-1] == s2[j-1]:
                dp[i][j] = dp[i-1][j-1] + 1
            else:
                dp[i][j] = max(dp[i-1][j], dp[i][j-1])

    return dp[m][n]

lcs("ABCDGH", "AEDFHR")  # 3 ("ADH")
```

## Graph Theory

### Graph Representations

#### Adjacency List

```python
graph = {
    'A': ['B', 'C'],
    'B': ['A', 'D', 'E'],
    'C': ['A', 'F'],
    'D': ['B'],
    'E': ['B', 'F'],
    'F': ['C', 'E']
}
```

**Space**: O(V + E) - efficient for sparse graphs

#### Adjacency Matrix

```python
# For nodes 0, 1, 2, 3
graph = [
    [0, 1, 1, 0],  # Node 0 connects to 1, 2
    [1, 0, 0, 1],  # Node 1 connects to 0, 3
    [1, 0, 0, 1],  # Node 2 connects to 0, 3
    [0, 1, 1, 0]   # Node 3 connects to 1, 2
]
```

**Space**: O(V²) - better for dense graphs

### Graph Traversal

#### Depth-First Search (DFS)

```python
def dfs(graph, start, visited=None):
    if visited is None:
        visited = set()

    visited.add(start)
    print(start)

    for neighbor in graph[start]:
        if neighbor not in visited:
            dfs(graph, neighbor, visited)

    return visited
```

**Use cases**: Detecting cycles, topological sort, finding paths

#### Breadth-First Search (BFS)

```python
from collections import deque

def bfs(graph, start):
    visited = set([start])
    queue = deque([start])

    while queue:
        node = queue.popleft()
        print(node)

        for neighbor in graph[node]:
            if neighbor not in visited:
                visited.add(neighbor)
                queue.append(neighbor)

    return visited
```

**Use cases**: Shortest path (unweighted), level-order traversal

### Shortest Path Algorithms

#### Dijkstra's Algorithm

**Shortest path in weighted graph** (no negative weights).

```python
import heapq

def dijkstra(graph, start):
    distances = {node: float('inf') for node in graph}
    distances[start] = 0
    pq = [(0, start)]  # (distance, node)

    while pq:
        curr_dist, curr_node = heapq.heappop(pq)

        if curr_dist > distances[curr_node]:
            continue

        for neighbor, weight in graph[curr_node]:
            distance = curr_dist + weight

            if distance < distances[neighbor]:
                distances[neighbor] = distance
                heapq.heappush(pq, (distance, neighbor))

    return distances
```

**Time complexity**: O((V + E) log V)

#### Bellman-Ford

**Handles negative weights**.

```python
def bellman_ford(graph, start):
    distances = {node: float('inf') for node in graph}
    distances[start] = 0

    # Relax edges V-1 times
    for _ in range(len(graph) - 1):
        for node in graph:
            for neighbor, weight in graph[node]:
                if distances[node] + weight < distances[neighbor]:
                    distances[neighbor] = distances[node] + weight

    # Check for negative cycles
    for node in graph:
        for neighbor, weight in graph[node]:
            if distances[node] + weight < distances[neighbor]:
                raise ValueError("Negative cycle detected")

    return distances
```

**Time complexity**: O(VE)

### Minimum Spanning Tree

#### Kruskal's Algorithm

```python
class UnionFind:
    def __init__(self, n):
        self.parent = list(range(n))

    def find(self, x):
        if self.parent[x] != x:
            self.parent[x] = self.find(self.parent[x])
        return self.parent[x]

    def union(self, x, y):
        px, py = self.find(x), self.find(y)
        if px != py:
            self.parent[px] = py
            return True
        return False

def kruskal(n, edges):
    # edges: [(weight, u, v), ...]
    edges.sort()  # Sort by weight
    uf = UnionFind(n)
    mst = []
    total_weight = 0

    for weight, u, v in edges:
        if uf.union(u, v):
            mst.append((u, v, weight))
            total_weight += weight

    return mst, total_weight
```

### Real-World Applications

- **Social networks** - Friend connections
- **Maps** - Route finding
- **Dependencies** - Build systems, package managers
- **Web crawling** - Link traversal
- **Network routing** - Internet packets

## Complexity Theory

### P vs NP

#### P (Polynomial Time)

**Problems solvable in polynomial time**.

Examples:
- Sorting: O(n log n)
- Binary search: O(log n)
- Finding shortest path: O(V²) or O((V+E) log V)

**Can verify AND solve efficiently**.

#### NP (Nondeterministic Polynomial)

**Solutions verifiable in polynomial time**.

Examples:
- Sudoku - Easy to verify solution, hard to find
- Traveling Salesman - Easy to verify route length, hard to find optimal
- Boolean satisfiability (SAT)

**Can verify efficiently, solving might be hard**.

#### NP-Complete

**Hardest problems in NP** - if you solve one efficiently, you solve all.

Examples:
- Traveling Salesman Problem (TSP)
- Knapsack Problem
- Graph Coloring
- Boolean Satisfiability (SAT)

```
If P = NP (unproven):
  All NP problems can be solved efficiently

If P ≠ NP (likely):
  Some problems are inherently hard
```

### Big O Notation

**Describes algorithm growth rate**.

```
O(1)      - Constant      - Array access
O(log n)  - Logarithmic   - Binary search
O(n)      - Linear        - Array scan
O(n log n)- Linearithmic  - Efficient sort
O(n²)     - Quadratic     - Nested loops
O(2^n)    - Exponential   - Naive Fibonacci
O(n!)     - Factorial     - Permutations
```

**Rules**:
- Drop constants: O(2n) → O(n)
- Drop lower terms: O(n² + n) → O(n²)
- Different inputs: O(a + b) not O(n)

### Space Complexity

**Memory used by algorithm**.

```python
# O(1) space - constant
def sum_array(arr):
    total = 0  # Single variable
    for num in arr:
        total += num
    return total

# O(n) space - linear
def reverse_array(arr):
    return arr[::-1]  # Creates new array

# O(n) space - recursion stack
def factorial(n):
    if n <= 1:
        return 1
    return n * factorial(n - 1)  # n calls on stack
```

### Amortized Analysis

**Average time per operation over sequence**.

Example: Dynamic array append

```python
# Worst case: O(n) when array full, need to resize
# But happens rarely
# Amortized: O(1) per append
```

### Practical Implications

**When facing NP-Complete problem**:

1. **Approximate** - Good enough solution
```python
# TSP approximation
def greedy_tsp(cities):
    tour = [cities[0]]
    unvisited = set(cities[1:])

    while unvisited:
        last = tour[-1]
        nearest = min(unvisited, key=lambda c: distance(last, c))
        tour.append(nearest)
        unvisited.remove(nearest)

    return tour  # Not optimal, but fast!
```

2. **Heuristics** - Rules of thumb
3. **Reduce problem size** - Limit search space
4. **Accept exponential** - If problem small enough

## Real-World Examples

### Package Dependencies (Graph)

```python
# Topological sort for build order
def build_order(dependencies):
    # DFS-based topological sort
    visited = set()
    stack = []

    def dfs(pkg):
        visited.add(pkg)
        for dep in dependencies.get(pkg, []):
            if dep not in visited:
                dfs(dep)
        stack.append(pkg)

    for pkg in dependencies:
        if pkg not in visited:
            dfs(pkg)

    return stack[::-1]  # Reverse for correct order
```

### Cache with LRU (Linked List + Hash)

```python
from collections import OrderedDict

class LRUCache:
    def __init__(self, capacity):
        self.cache = OrderedDict()
        self.capacity = capacity

    def get(self, key):
        if key not in self.cache:
            return -1
        self.cache.move_to_end(key)  # Mark as recently used
        return self.cache[key]

    def put(self, key, value):
        if key in self.cache:
            self.cache.move_to_end(key)
        self.cache[key] = value
        if len(self.cache) > self.capacity:
            self.cache.popitem(last=False)  # Remove least recent
```

### Interview Problem Patterns

**Recognize problem types**:

- **Two pointers** - Sorted array problems
- **Sliding window** - Subarray problems
- **Binary search** - Sorted + find optimal
- **BFS** - Shortest path, level-order
- **DFS** - Explore all paths, backtracking
- **DP** - Overlapping subproblems
- **Greedy** - Local optimal → global optimal
- **Union-Find** - Connected components

## Key Takeaways

1. **Recursion** - Break problem into smaller subproblems
2. **Dynamic Programming** - Cache results to avoid recalculation
3. **Graphs** - Model relationships, many real-world uses
4. **DFS** - Go deep, use for cycles/paths
5. **BFS** - Go wide, use for shortest path
6. **P vs NP** - Some problems are inherently hard
7. **Big O** - Understand algorithm scalability
8. **NP-Complete** - Use approximations, don't seek perfect solution

**Remember**: Theory informs practice. Knowing these concepts helps you choose the right algorithm!
