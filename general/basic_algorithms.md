# Basic Algorithms - Line by Line Explanations

Comprehensive guide to fundamental algorithms with detailed explanations and Python examples.

---

## Table of Contents

1. [Sorting Algorithms](#sorting-algorithms)
2. [Searching Algorithms](#searching-algorithms)
3. [Two Pointers Technique](#two-pointers-technique)
4. [Sliding Window](#sliding-window)
5. [String Algorithms](#string-algorithms)
6. [Array Algorithms](#array-algorithms)
7. [Linked List Algorithms](#linked-list-algorithms)
8. [Tree Traversals](#tree-traversals)
9. [Graph Algorithms](#graph-algorithms)
10. [Dynamic Programming](#dynamic-programming)
11. [Greedy Algorithms](#greedy-algorithms)
12. [Backtracking](#backtracking)

---

## Sorting Algorithms

### Bubble Sort

**Description**: Repeatedly steps through the list, compares adjacent elements, and swaps them if they're in wrong order.

**Time Complexity**: O(n²) | **Space Complexity**: O(1)

```python
def bubble_sort(arr):
    n = len(arr)                    # Get array length

    for i in range(n):              # Outer loop: n passes through array
        swapped = False             # Track if any swaps occurred

        for j in range(0, n-i-1):   # Inner loop: compare adjacent elements
                                    # n-i-1 because last i elements are sorted

            if arr[j] > arr[j+1]:   # If current > next, swap
                arr[j], arr[j+1] = arr[j+1], arr[j]
                swapped = True      # Mark that swap occurred

        if not swapped:             # If no swaps, array is sorted
            break                   # Early exit optimization

    return arr

# Example
numbers = [64, 34, 25, 12, 22, 11, 90]
print(bubble_sort(numbers))  # [11, 12, 22, 25, 34, 64, 90]
```

**Line-by-Line Breakdown**:
1. Store array length for iteration
2. Outer loop controls number of passes (maximum n passes)
3. Flag to detect if array is already sorted
4. Inner loop compares adjacent pairs
5. Reduce comparisons each pass (last i elements already sorted)
6. Compare current with next element
7. Swap if out of order (Python tuple unpacking)
8. Set flag to indicate swap happened
9. If no swaps in entire pass, array is sorted
10. Exit early to save time

---

### Selection Sort

**Description**: Divides array into sorted and unsorted regions. Repeatedly finds minimum from unsorted and moves to sorted.

**Time Complexity**: O(n²) | **Space Complexity**: O(1)

```python
def selection_sort(arr):
    n = len(arr)                        # Get array length

    for i in range(n):                  # Outer loop: position to fill
        min_idx = i                     # Assume current position has minimum

        for j in range(i+1, n):         # Inner loop: find actual minimum
                                        # Start from i+1 (unsorted portion)

            if arr[j] < arr[min_idx]:   # Found smaller element
                min_idx = j             # Update minimum index

        # Swap minimum with current position
        arr[i], arr[min_idx] = arr[min_idx], arr[i]

    return arr

# Example
numbers = [64, 25, 12, 22, 11]
print(selection_sort(numbers))  # [11, 12, 22, 25, 64]
```

**Line-by-Line Breakdown**:
1. Get array length
2. Outer loop: i is the position we're filling (sorted region grows)
3. Assume minimum is at current position
4. Inner loop: search unsorted portion (i+1 to end)
5. Compare each element with current minimum
6. Update minimum index if smaller element found
7. After finding minimum, swap it with position i
8. Now position i has correct value, move to next position

---

### Insertion Sort

**Description**: Builds sorted array one item at a time by inserting each element into its correct position.

**Time Complexity**: O(n²) average, O(n) best | **Space Complexity**: O(1)

```python
def insertion_sort(arr):
    for i in range(1, len(arr)):        # Start from second element (index 1)
        key = arr[i]                    # Current element to insert
        j = i - 1                       # Start comparing with previous elements

        # Shift elements greater than key one position right
        while j >= 0 and arr[j] > key:  # While not at start AND current > key
            arr[j + 1] = arr[j]         # Shift element to right
            j -= 1                      # Move left

        arr[j + 1] = key                # Insert key at correct position

    return arr

# Example
numbers = [12, 11, 13, 5, 6]
print(insertion_sort(numbers))  # [5, 6, 11, 12, 13]
```

**Line-by-Line Breakdown**:
1. Start from second element (first element is trivially sorted)
2. Store current element as key to insert
3. Start from previous element to compare
4. Shift elements greater than key to the right
5. Check boundaries and if element is greater than key
6. Move element one position right (making space)
7. Move to next left element
8. Insert key at the correct position (j+1 because j was decremented)

---

### Merge Sort

**Description**: Divide and conquer algorithm that divides array into halves, sorts them, and merges back.

**Time Complexity**: O(n log n) | **Space Complexity**: O(n)

```python
def merge_sort(arr):
    if len(arr) <= 1:                   # Base case: array of 0 or 1 element
        return arr                      # Already sorted

    mid = len(arr) // 2                 # Find middle point
    left = merge_sort(arr[:mid])        # Recursively sort left half
    right = merge_sort(arr[mid:])       # Recursively sort right half

    return merge(left, right)           # Merge sorted halves

def merge(left, right):
    result = []                         # Merged array
    i = j = 0                           # Pointers for left and right arrays

    # Compare elements from left and right, add smaller to result
    while i < len(left) and j < len(right):
        if left[i] <= right[j]:         # If left element is smaller
            result.append(left[i])      # Add it to result
            i += 1                      # Move left pointer
        else:                           # Right element is smaller
            result.append(right[j])     # Add it to result
            j += 1                      # Move right pointer

    # Add remaining elements (one array is exhausted)
    result.extend(left[i:])             # Add remaining from left
    result.extend(right[j:])            # Add remaining from right

    return result

# Example
numbers = [38, 27, 43, 3, 9, 82, 10]
print(merge_sort(numbers))  # [3, 9, 10, 27, 38, 43, 82]
```

**Line-by-Line Breakdown**:
1. Check if array has 0 or 1 element (base case)
2. Return as-is (already sorted)
3. Calculate middle index
4. Recursively sort left half (divide)
5. Recursively sort right half (divide)
6. Merge sorted halves (conquer)
7. Create result array
8. Initialize two pointers for traversing both arrays
9. While both arrays have elements
10. Compare current elements
11. Add smaller element to result
12. Move pointer in that array
13. Handle right array element being smaller
14. Add remaining elements from left (if any)
15. Add remaining elements from right (if any)

---

### Quick Sort

**Description**: Picks a pivot element and partitions array around it, then recursively sorts partitions.

**Time Complexity**: O(n log n) average, O(n²) worst | **Space Complexity**: O(log n)

```python
def quick_sort(arr, low=0, high=None):
    if high is None:                    # Initial call setup
        high = len(arr) - 1             # Set high to last index

    if low < high:                      # Base case: ensure valid range
        pi = partition(arr, low, high)  # Partition and get pivot index

        quick_sort(arr, low, pi - 1)    # Recursively sort left of pivot
        quick_sort(arr, pi + 1, high)   # Recursively sort right of pivot

    return arr

def partition(arr, low, high):
    pivot = arr[high]                   # Choose last element as pivot
    i = low - 1                         # Index of smaller element

    for j in range(low, high):          # Iterate through array
        if arr[j] <= pivot:             # If current element <= pivot
            i += 1                      # Increment index of smaller element
            arr[i], arr[j] = arr[j], arr[i]  # Swap

    # Place pivot in correct position
    arr[i + 1], arr[high] = arr[high], arr[i + 1]
    return i + 1                        # Return pivot index

# Example
numbers = [10, 7, 8, 9, 1, 5]
print(quick_sort(numbers))  # [1, 5, 7, 8, 9, 10]
```

**Line-by-Line Breakdown**:
1. Check if first call (high not provided)
2. Set high to last valid index
3. Ensure we have a valid range to sort
4. Partition array and get pivot's final position
5. Recursively sort elements before pivot
6. Recursively sort elements after pivot
7. Choose rightmost element as pivot
8. Initialize partition index (tracks smaller elements)
9. Loop through elements before pivot
10. Check if current element should be on left side
11. Move partition boundary right
12. Swap to move smaller element left
13. Place pivot in its final sorted position
14. Return pivot's final position

---

## Searching Algorithms

### Linear Search

**Description**: Sequentially checks each element until target is found or end is reached.

**Time Complexity**: O(n) | **Space Complexity**: O(1)

```python
def linear_search(arr, target):
    for i in range(len(arr)):           # Iterate through array
        if arr[i] == target:            # Check if current element matches
            return i                    # Return index if found
    return -1                           # Return -1 if not found

# Example
numbers = [2, 3, 4, 10, 40]
print(linear_search(numbers, 10))  # 3
print(linear_search(numbers, 99))  # -1
```

**Line-by-Line Breakdown**:
1. Loop through each index in array
2. Compare current element with target
3. Return index immediately if match found
4. Return -1 to indicate not found (after checking all)

---

### Binary Search

**Description**: Efficiently searches sorted array by repeatedly dividing search interval in half.

**Time Complexity**: O(log n) | **Space Complexity**: O(1)

```python
def binary_search(arr, target):
    left = 0                            # Left pointer at start
    right = len(arr) - 1                # Right pointer at end

    while left <= right:                # While search space exists
        mid = (left + right) // 2       # Calculate middle index

        if arr[mid] == target:          # Found target
            return mid                  # Return index

        elif arr[mid] < target:         # Target is in right half
            left = mid + 1              # Move left pointer right

        else:                           # Target is in left half
            right = mid - 1             # Move right pointer left

    return -1                           # Target not found

# Example
numbers = [2, 3, 4, 10, 40]
print(binary_search(numbers, 10))  # 3
print(binary_search(numbers, 99))  # -1
```

**Line-by-Line Breakdown**:
1. Initialize left boundary to first index
2. Initialize right boundary to last index
3. Continue while valid search space exists
4. Calculate middle point (avoids overflow with left + (right-left)//2)
5. Check if middle element is our target
6. Return index if found
7. If middle is less than target, target must be in right half
8. Eliminate left half by moving left pointer
9. Otherwise, target is in left half
10. Eliminate right half by moving right pointer
11. All possibilities exhausted, target not in array

---

## Two Pointers Technique

### Remove Duplicates from Sorted Array

**Description**: Use two pointers to track unique elements and overwrite duplicates in-place.

**Time Complexity**: O(n) | **Space Complexity**: O(1)

```python
def remove_duplicates(arr):
    if not arr:                         # Handle empty array
        return 0

    i = 0                               # Slow pointer: tracks unique elements

    for j in range(1, len(arr)):        # Fast pointer: explores array
        if arr[j] != arr[i]:            # Found different element (unique)
            i += 1                      # Move slow pointer forward
            arr[i] = arr[j]             # Place unique element at slow pointer

    return i + 1                        # Length of unique elements (i+1)

# Example
numbers = [1, 1, 2, 2, 2, 3, 4, 4, 5]
length = remove_duplicates(numbers)
print(numbers[:length])  # [1, 2, 3, 4, 5]
```

**Line-by-Line Breakdown**:
1. Check for empty array edge case
2. Initialize slow pointer at first element (always unique)
3. Fast pointer explores rest of array
4. Compare fast pointer with slow pointer element
5. Move slow pointer to next position
6. Copy unique element to slow pointer position
7. Return count of unique elements

---

### Two Sum (Sorted Array)

**Description**: Find two numbers that add up to target using two pointers from both ends.

**Time Complexity**: O(n) | **Space Complexity**: O(1)

```python
def two_sum_sorted(arr, target):
    left = 0                            # Pointer at start
    right = len(arr) - 1                # Pointer at end

    while left < right:                 # While pointers haven't crossed
        current_sum = arr[left] + arr[right]  # Calculate sum

        if current_sum == target:       # Found the pair
            return [left, right]        # Return indices

        elif current_sum < target:      # Sum too small
            left += 1                   # Move left pointer right (increase sum)

        else:                           # Sum too large
            right -= 1                  # Move right pointer left (decrease sum)

    return []                           # No solution found

# Example
numbers = [2, 7, 11, 15]
print(two_sum_sorted(numbers, 9))   # [0, 1] (2 + 7 = 9)
print(two_sum_sorted(numbers, 20))  # [] (no solution)
```

**Line-by-Line Breakdown**:
1. Start left pointer at beginning (smallest element)
2. Start right pointer at end (largest element)
3. Continue until pointers meet
4. Calculate sum of elements at both pointers
5. Check if sum matches target
6. Return indices if match found
7. If sum is less than target, need larger sum
8. Move left pointer right to get larger element
9. If sum is greater than target, need smaller sum
10. Move right pointer left to get smaller element
11. Exhausted all possibilities, no solution

---

## Sliding Window

### Maximum Sum Subarray of Size K

**Description**: Find maximum sum of any contiguous subarray of size k using sliding window.

**Time Complexity**: O(n) | **Space Complexity**: O(1)

```python
def max_sum_subarray(arr, k):
    if len(arr) < k:                    # Array smaller than window size
        return None

    # Calculate sum of first window
    window_sum = sum(arr[:k])           # Sum first k elements
    max_sum = window_sum                # Initialize max with first window

    # Slide window across array
    for i in range(k, len(arr)):        # Start from k-th element
        # Slide window: remove left element, add right element
        window_sum = window_sum - arr[i-k] + arr[i]
        max_sum = max(max_sum, window_sum)  # Update max if needed

    return max_sum

# Example
numbers = [2, 1, 5, 1, 3, 2]
print(max_sum_subarray(numbers, 3))  # 9 (subarray [5, 1, 3])
```

**Line-by-Line Breakdown**:
1. Validate that array has at least k elements
2. Calculate sum of first window (indices 0 to k-1)
3. Initialize maximum with first window's sum
4. Start sliding from k-th element to end
5. Slide window: subtract element leaving window (i-k)
6. Add element entering window (i)
7. Update maximum if current window sum is larger
8. Return maximum sum found

---

### Longest Substring Without Repeating Characters

**Description**: Find length of longest substring without duplicate characters using sliding window.

**Time Complexity**: O(n) | **Space Complexity**: O(min(n, m)) where m is charset size

```python
def length_of_longest_substring(s):
    char_set = set()                    # Track characters in current window
    left = 0                            # Left boundary of window
    max_length = 0                      # Maximum length found

    for right in range(len(s)):         # Right boundary expands
        # Shrink window while duplicate exists
        while s[right] in char_set:     # Character already in window
            char_set.remove(s[left])    # Remove leftmost character
            left += 1                   # Shrink window from left

        char_set.add(s[right])          # Add current character to window
        max_length = max(max_length, right - left + 1)  # Update max length

    return max_length

# Example
print(length_of_longest_substring("abcabcbb"))  # 3 ("abc")
print(length_of_longest_substring("bbbbb"))     # 1 ("b")
print(length_of_longest_substring("pwwkew"))    # 3 ("wke")
```

**Line-by-Line Breakdown**:
1. Create set to track unique characters in current window
2. Left pointer marks window start
3. Variable to track longest valid substring
4. Right pointer expands window
5. Check if current character creates duplicate
6. Remove leftmost character from window
7. Shrink window by moving left pointer
8. Add current character to window (now guaranteed unique)
9. Calculate current window size and update maximum
10. Return longest valid substring length

---

## String Algorithms

### Check Palindrome

**Description**: Check if string reads same forwards and backwards using two pointers.

**Time Complexity**: O(n) | **Space Complexity**: O(1)

```python
def is_palindrome(s):
    left = 0                            # Start pointer
    right = len(s) - 1                  # End pointer

    while left < right:                 # While pointers haven't met
        if s[left] != s[right]:         # Characters don't match
            return False                # Not a palindrome
        left += 1                       # Move left pointer right
        right -= 1                      # Move right pointer left

    return True                         # All characters matched

# Example
print(is_palindrome("racecar"))  # True
print(is_palindrome("hello"))    # False
```

**Line-by-Line Breakdown**:
1. Initialize left pointer at start
2. Initialize right pointer at end
3. Compare characters until pointers meet in middle
4. Check if characters at both pointers match
5. If mismatch found, not a palindrome
6. Move left pointer towards center
7. Move right pointer towards center
8. All comparisons passed, string is palindrome

---

### Reverse String In-Place

**Description**: Reverse string in-place using two pointers swap technique.

**Time Complexity**: O(n) | **Space Complexity**: O(1)

```python
def reverse_string(s):
    s = list(s)                         # Convert to list (strings immutable)
    left = 0                            # Left pointer
    right = len(s) - 1                  # Right pointer

    while left < right:                 # While pointers haven't crossed
        s[left], s[right] = s[right], s[left]  # Swap characters
        left += 1                       # Move left pointer right
        right -= 1                      # Move right pointer left

    return ''.join(s)                   # Convert back to string

# Example
print(reverse_string("hello"))  # "olleh"
```

**Line-by-Line Breakdown**:
1. Convert string to list for in-place modification
2. Initialize left pointer at start
3. Initialize right pointer at end
4. Continue until pointers meet
5. Swap characters at both pointers
6. Move left pointer towards center
7. Move right pointer towards center
8. Join list back to string and return

---

### Check Anagram

**Description**: Check if two strings are anagrams (same characters, different order).

**Time Complexity**: O(n) | **Space Complexity**: O(1) - fixed alphabet size

```python
def is_anagram(s1, s2):
    if len(s1) != len(s2):              # Different lengths can't be anagrams
        return False

    char_count = {}                     # Dictionary to count characters

    # Count characters in first string
    for char in s1:
        char_count[char] = char_count.get(char, 0) + 1

    # Subtract counts using second string
    for char in s2:
        if char not in char_count:      # Character not in first string
            return False
        char_count[char] -= 1           # Decrease count
        if char_count[char] < 0:        # More occurrences in s2
            return False

    return True

# Example
print(is_anagram("listen", "silent"))  # True
print(is_anagram("hello", "world"))    # False
```

**Line-by-Line Breakdown**:
1. Quick check: different lengths can't be anagrams
2. Create dictionary to track character frequencies
3. Loop through first string
4. Count each character occurrence (get returns 0 if not present)
5. Loop through second string
6. Check if character exists in first string
7. Decrement count for matching character
8. Check if count goes negative (more in s2 than s1)
9. All checks passed, strings are anagrams

---

## Array Algorithms

### Rotate Array

**Description**: Rotate array to the right by k steps using reversal algorithm.

**Time Complexity**: O(n) | **Space Complexity**: O(1)

```python
def rotate_array(arr, k):
    n = len(arr)                        # Get array length
    k = k % n                           # Handle k > n (k rotations = k%n rotations)

    # Helper function to reverse portion of array
    def reverse(start, end):
        while start < end:
            arr[start], arr[end] = arr[end], arr[start]
            start += 1
            end -= 1

    reverse(0, n - 1)                   # Step 1: Reverse entire array
    reverse(0, k - 1)                   # Step 2: Reverse first k elements
    reverse(k, n - 1)                   # Step 3: Reverse remaining elements

    return arr

# Example
numbers = [1, 2, 3, 4, 5, 6, 7]
print(rotate_array(numbers, 3))  # [5, 6, 7, 1, 2, 3, 4]
```

**Line-by-Line Breakdown**:
1. Store array length
2. Handle k larger than n (rotating n times = no change)
3. Helper function to reverse array segment
4. Swap elements from both ends moving inward
5. Move pointers towards center
6. Reverse entire array [7,6,5,4,3,2,1]
7. Reverse first k elements [5,6,7,4,3,2,1]
8. Reverse remaining elements [5,6,7,1,2,3,4]

**Algorithm Intuition**:
- [1,2,3,4,5,6,7] rotate right by 3
- Reverse all: [7,6,5,4,3,2,1]
- Reverse first 3: [5,6,7,4,3,2,1]
- Reverse last 4: [5,6,7,1,2,3,4] ✓

---

### Find Missing Number

**Description**: Find missing number in array containing n distinct numbers from 0 to n.

**Time Complexity**: O(n) | **Space Complexity**: O(1)

```python
def find_missing_number(arr):
    n = len(arr)                        # Array has n elements
    # Expected sum: 0 + 1 + 2 + ... + n = n*(n+1)/2
    expected_sum = n * (n + 1) // 2     # Sum formula
    actual_sum = sum(arr)               # Sum of elements in array
    return expected_sum - actual_sum    # Difference is missing number

# Example
numbers = [0, 1, 3, 4, 5]  # Missing 2
print(find_missing_number(numbers))  # 2
```

**Line-by-Line Breakdown**:
1. Get array length (n elements means range is 0 to n)
2. Calculate expected sum using formula n*(n+1)/2
3. Calculate actual sum of array elements
4. Missing number is difference between expected and actual

**Alternative XOR Approach**:
```python
def find_missing_number_xor(arr):
    n = len(arr)
    xor_all = 0                         # XOR of all numbers 0 to n
    xor_arr = 0                         # XOR of array elements

    # XOR all numbers from 0 to n
    for i in range(n + 1):
        xor_all ^= i

    # XOR all array elements
    for num in arr:
        xor_arr ^= num

    return xor_all ^ xor_arr            # XOR gives missing number

# XOR property: a ^ a = 0, a ^ 0 = a
# Missing number appears once in xor_all but zero times in xor_arr
```

---

## Linked List Algorithms

### Reverse Linked List

**Description**: Reverse a singly linked list iteratively by changing pointers.

**Time Complexity**: O(n) | **Space Complexity**: O(1)

```python
class ListNode:
    def __init__(self, val=0, next=None):
        self.val = val
        self.next = next

def reverse_linked_list(head):
    prev = None                         # Previous node (will become new tail)
    current = head                      # Current node being processed

    while current:                      # Traverse until end
        next_node = current.next        # Save next node (will lose reference)
        current.next = prev             # Reverse pointer to previous
        prev = current                  # Move prev forward
        current = next_node             # Move current forward

    return prev                         # prev is new head

# Example
# 1 -> 2 -> 3 -> None becomes 3 -> 2 -> 1 -> None
```

**Line-by-Line Breakdown**:
1. Initialize prev to None (new tail will point to None)
2. Start current at head
3. Loop through entire list
4. Store next node before changing pointer
5. Reverse current node's pointer to point backwards
6. Move prev to current node
7. Move current to next node (saved earlier)
8. Return prev (now pointing to original tail, new head)

**Visual Trace**:
```
Initial:  None <- 1 -> 2 -> 3 -> None
          prev  cur

Step 1:   None <- 1    2 -> 3 -> None
                prev  cur

Step 2:   None <- 1 <- 2    3 -> None
                      prev  cur

Step 3:   None <- 1 <- 2 <- 3   None
                           prev  cur

Return prev (3)
```

---

### Detect Cycle in Linked List

**Description**: Use Floyd's cycle detection (tortoise and hare) to detect if list has cycle.

**Time Complexity**: O(n) | **Space Complexity**: O(1)

```python
def has_cycle(head):
    if not head:                        # Empty list has no cycle
        return False

    slow = head                         # Slow pointer (moves 1 step)
    fast = head                         # Fast pointer (moves 2 steps)

    while fast and fast.next:           # While fast pointer is valid
        slow = slow.next                # Move slow 1 step
        fast = fast.next.next           # Move fast 2 steps

        if slow == fast:                # Pointers met
            return True                 # Cycle detected

    return False                        # Fast reached end, no cycle

# If there's a cycle, fast will eventually lap slow and meet
# If no cycle, fast will reach None
```

**Line-by-Line Breakdown**:
1. Handle empty list edge case
2. Initialize slow pointer at head
3. Initialize fast pointer at head
4. Continue while fast can move 2 steps
5. Move slow pointer one node forward
6. Move fast pointer two nodes forward
7. Check if pointers meet (same node)
8. Meeting indicates cycle exists
9. Fast reached end without meeting, no cycle

**Why it works**:
- In a cycle, fast gains 1 node per iteration on slow
- Eventually fast will be exactly 1 behind slow
- Next iteration they meet

---

## Tree Traversals

### Binary Tree Node Structure

```python
class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right
```

---

### Inorder Traversal (Left-Root-Right)

**Description**: Visit left subtree, then root, then right subtree. Gives sorted order for BST.

**Time Complexity**: O(n) | **Space Complexity**: O(h) where h is height

```python
def inorder_traversal(root):
    result = []                         # Store traversal result

    def traverse(node):
        if not node:                    # Base case: empty node
            return

        traverse(node.left)             # Recursively traverse left subtree
        result.append(node.val)         # Visit root (add to result)
        traverse(node.right)            # Recursively traverse right subtree

    traverse(root)                      # Start traversal from root
    return result

# Example tree:
#       1
#      / \
#     2   3
#    / \
#   4   5
# Inorder: [4, 2, 5, 1, 3]
```

**Line-by-Line Breakdown**:
1. Create list to store node values in order
2. Helper function for recursive traversal
3. Base case: if node is None, return
4. Recursively process left subtree first
5. Process current node (add to result)
6. Recursively process right subtree
7. Start recursive traversal from root
8. Return collected values

---

### Preorder Traversal (Root-Left-Right)

**Description**: Visit root first, then left subtree, then right subtree.

**Time Complexity**: O(n) | **Space Complexity**: O(h)

```python
def preorder_traversal(root):
    result = []

    def traverse(node):
        if not node:                    # Base case: empty node
            return

        result.append(node.val)         # Visit root first
        traverse(node.left)             # Then traverse left subtree
        traverse(node.right)            # Then traverse right subtree

    traverse(root)
    return result

# Example tree:
#       1
#      / \
#     2   3
#    / \
#   4   5
# Preorder: [1, 2, 4, 5, 3]
```

**Line-by-Line Breakdown**:
1. Base case: return if node is None
2. Process root first (add to result)
3. Recursively process left subtree
4. Recursively process right subtree

---

### Postorder Traversal (Left-Right-Root)

**Description**: Visit left subtree, then right subtree, then root last.

**Time Complexity**: O(n) | **Space Complexity**: O(h)

```python
def postorder_traversal(root):
    result = []

    def traverse(node):
        if not node:                    # Base case: empty node
            return

        traverse(node.left)             # Traverse left subtree first
        traverse(node.right)            # Then traverse right subtree
        result.append(node.val)         # Visit root last

    traverse(root)
    return result

# Example tree:
#       1
#      / \
#     2   3
#    / \
#   4   5
# Postorder: [4, 5, 2, 3, 1]
```

**Line-by-Line Breakdown**:
1. Base case: return if node is None
2. Recursively process left subtree first
3. Recursively process right subtree
4. Process root last (add to result)

---

### Level Order Traversal (Breadth-First)

**Description**: Visit nodes level by level from left to right using a queue.

**Time Complexity**: O(n) | **Space Complexity**: O(w) where w is max width

```python
from collections import deque

def level_order_traversal(root):
    if not root:                        # Handle empty tree
        return []

    result = []                         # Store result
    queue = deque([root])               # Initialize queue with root

    while queue:                        # While nodes to process
        level_size = len(queue)         # Number of nodes in current level
        level = []                      # Store current level values

        for i in range(level_size):     # Process all nodes in current level
            node = queue.popleft()      # Remove node from queue
            level.append(node.val)      # Add value to current level

            if node.left:               # Add left child to queue
                queue.append(node.left)
            if node.right:              # Add right child to queue
                queue.append(node.right)

        result.append(level)            # Add current level to result

    return result

# Example tree:
#       1
#      / \
#     2   3
#    / \
#   4   5
# Level order: [[1], [2, 3], [4, 5]]
```

**Line-by-Line Breakdown**:
1. Handle empty tree case
2. Initialize result list
3. Create queue and add root node
4. Process while queue has nodes
5. Count nodes in current level
6. List to store current level's values
7. Process each node in current level
8. Remove and get front node from queue
9. Add node's value to current level
10. Add left child to queue for next level
11. Add right child to queue for next level
12. Add completed level to result
13. Return all levels

---

## Graph Algorithms

### Graph Representation

```python
# Adjacency List representation
graph = {
    'A': ['B', 'C'],
    'B': ['A', 'D', 'E'],
    'C': ['A', 'F'],
    'D': ['B'],
    'E': ['B', 'F'],
    'F': ['C', 'E']
}
```

---

### Depth-First Search (DFS)

**Description**: Explore as far as possible along each branch before backtracking.

**Time Complexity**: O(V + E) | **Space Complexity**: O(V)

```python
def dfs(graph, start, visited=None):
    if visited is None:                 # Initialize visited set
        visited = set()

    visited.add(start)                  # Mark current node as visited
    print(start, end=' ')               # Process node

    for neighbor in graph[start]:       # Explore each neighbor
        if neighbor not in visited:     # If not yet visited
            dfs(graph, neighbor, visited)  # Recursively visit

    return visited

# Example
graph = {
    'A': ['B', 'C'],
    'B': ['D', 'E'],
    'C': ['F'],
    'D': [], 'E': [], 'F': []
}
dfs(graph, 'A')  # Output: A B D E C F
```

**Line-by-Line Breakdown**:
1. Initialize visited set on first call
2. Mark current node as visited
3. Process current node (print or other operation)
4. Loop through all neighbors of current node
5. Check if neighbor has been visited
6. Recursively explore unvisited neighbor
7. Return set of all visited nodes

**Iterative DFS** (using stack):
```python
def dfs_iterative(graph, start):
    visited = set()                     # Track visited nodes
    stack = [start]                     # Initialize stack with start

    while stack:                        # While stack not empty
        node = stack.pop()              # Pop node from stack (LIFO)

        if node not in visited:         # If not visited
            visited.add(node)           # Mark as visited
            print(node, end=' ')        # Process node

            # Add neighbors to stack (reverse for left-to-right order)
            for neighbor in reversed(graph[node]):
                if neighbor not in visited:
                    stack.append(neighbor)

    return visited
```

---

### Breadth-First Search (BFS)

**Description**: Explore all neighbors at current depth before moving to next level.

**Time Complexity**: O(V + E) | **Space Complexity**: O(V)

```python
from collections import deque

def bfs(graph, start):
    visited = set([start])              # Mark start as visited
    queue = deque([start])              # Initialize queue with start
    result = []                         # Store traversal order

    while queue:                        # While queue not empty
        node = queue.popleft()          # Dequeue node (FIFO)
        result.append(node)             # Process node

        for neighbor in graph[node]:    # Explore all neighbors
            if neighbor not in visited: # If not visited
                visited.add(neighbor)   # Mark as visited
                queue.append(neighbor)  # Add to queue

    return result

# Example
graph = {
    'A': ['B', 'C'],
    'B': ['D', 'E'],
    'C': ['F'],
    'D': [], 'E': [], 'F': []
}
print(bfs(graph, 'A'))  # ['A', 'B', 'C', 'D', 'E', 'F']
```

**Line-by-Line Breakdown**:
1. Initialize visited set with starting node
2. Create queue and add starting node
3. List to store traversal order
4. Process while queue has nodes
5. Remove front node from queue (FIFO)
6. Add node to result (process it)
7. Loop through all neighbors
8. Check if neighbor unvisited
9. Mark neighbor as visited
10. Add neighbor to queue for processing

**BFS vs DFS**:
- BFS: Uses queue (FIFO), explores level by level, finds shortest path
- DFS: Uses stack (LIFO), explores depth first, good for topological sort

---

### Shortest Path (BFS for unweighted graph)

**Description**: Find shortest path between two nodes in unweighted graph.

**Time Complexity**: O(V + E) | **Space Complexity**: O(V)

```python
from collections import deque

def shortest_path(graph, start, end):
    if start == end:                    # Start is end
        return [start]

    visited = {start}                   # Track visited nodes
    queue = deque([(start, [start])])   # Queue stores (node, path)

    while queue:                        # While nodes to explore
        node, path = queue.popleft()    # Get current node and path

        for neighbor in graph[node]:    # Explore neighbors
            if neighbor == end:         # Found destination
                return path + [neighbor]  # Return complete path

            if neighbor not in visited: # Not visited
                visited.add(neighbor)   # Mark as visited
                queue.append((neighbor, path + [neighbor]))  # Add with path

    return []                           # No path found

# Example
graph = {
    'A': ['B', 'C'],
    'B': ['A', 'D'],
    'C': ['A', 'D'],
    'D': ['B', 'C', 'E'],
    'E': ['D']
}
print(shortest_path(graph, 'A', 'E'))  # ['A', 'B', 'D', 'E'] or ['A', 'C', 'D', 'E']
```

**Line-by-Line Breakdown**:
1. Handle case where start equals end
2. Initialize visited set with start node
3. Queue stores tuples of (node, path to that node)
4. Process nodes in queue
5. Extract current node and path taken to reach it
6. Explore each neighbor
7. Check if we reached destination
8. Return complete path including destination
9. Check if neighbor already visited
10. Mark as visited
11. Add neighbor with updated path to queue
12. All nodes explored, no path exists

---

## Dynamic Programming

### Fibonacci with Memoization (Top-Down)

**Description**: Calculate Fibonacci number with caching to avoid redundant calculations.

**Time Complexity**: O(n) | **Space Complexity**: O(n)

```python
def fib_memo(n, memo=None):
    if memo is None:                    # Initialize memo dict
        memo = {}

    if n in memo:                       # Check if already calculated
        return memo[n]                  # Return cached result

    if n <= 1:                          # Base cases
        return n                        # fib(0)=0, fib(1)=1

    # Calculate and store in memo
    memo[n] = fib_memo(n-1, memo) + fib_memo(n-2, memo)
    return memo[n]                      # Return calculated value

# Example
print(fib_memo(10))  # 55
print(fib_memo(50))  # 12586269025 (fast with memoization!)
```

**Line-by-Line Breakdown**:
1. Initialize memoization dictionary on first call
2. Check if result already computed
3. Return cached result if available (avoid recomputation)
4. Handle base cases (fib(0)=0, fib(1)=1)
5. Return base case value
6. Calculate recursively: fib(n) = fib(n-1) + fib(n-2)
7. Store result in memo before returning
8. Return calculated value

**Without Memoization**: O(2^n) - exponential time
**With Memoization**: O(n) - linear time

---

### Fibonacci with Tabulation (Bottom-Up)

**Description**: Build solution iteratively from base cases up.

**Time Complexity**: O(n) | **Space Complexity**: O(n)

```python
def fib_tab(n):
    if n <= 1:                          # Handle base cases
        return n

    dp = [0] * (n + 1)                  # Create DP table
    dp[0] = 0                           # Base case: fib(0) = 0
    dp[1] = 1                           # Base case: fib(1) = 1

    for i in range(2, n + 1):           # Build up from bottom
        dp[i] = dp[i-1] + dp[i-2]       # Use previous results

    return dp[n]                        # Return final result

# Example
print(fib_tab(10))  # 55
```

**Line-by-Line Breakdown**:
1. Handle base cases directly
2. Create array to store all subproblem results
3. Initialize fib(0) = 0
4. Initialize fib(1) = 1
5. Iterate from 2 to n
6. Calculate fib(i) using previous two values
7. Return final result at index n

**Space Optimized** (O(1) space):
```python
def fib_optimized(n):
    if n <= 1:
        return n

    prev2 = 0                           # fib(i-2)
    prev1 = 1                           # fib(i-1)

    for i in range(2, n + 1):
        current = prev1 + prev2         # fib(i) = fib(i-1) + fib(i-2)
        prev2 = prev1                   # Update prev2
        prev1 = current                 # Update prev1

    return prev1

# Only need last two values, not entire array
```

---

### Coin Change Problem

**Description**: Find minimum number of coins needed to make target amount.

**Time Complexity**: O(amount * n) | **Space Complexity**: O(amount)

```python
def coin_change(coins, amount):
    # Initialize DP array with infinity (impossible to make)
    dp = [float('inf')] * (amount + 1)  # dp[i] = min coins for amount i
    dp[0] = 0                           # Base case: 0 coins for amount 0

    # Build up solutions for all amounts from 1 to target
    for i in range(1, amount + 1):      # For each amount
        for coin in coins:              # Try each coin
            if coin <= i:               # If coin value not too large
                # Min of: current solution OR (solution for i-coin) + 1
                dp[i] = min(dp[i], dp[i - coin] + 1)

    # Return result if possible, -1 if impossible
    return dp[amount] if dp[amount] != float('inf') else -1

# Example
coins = [1, 2, 5]
print(coin_change(coins, 11))  # 3 (5+5+1)
print(coin_change(coins, 3))   # 2 (2+1)
```

**Line-by-Line Breakdown**:
1. Create DP array, initialize with infinity (unreachable)
2. Base case: 0 coins needed for amount 0
3. Iterate through all amounts from 1 to target
4. For each amount, try using each coin
5. Check if coin value doesn't exceed current amount
6. Update dp[i] if using this coin gives better solution
7. Take minimum of current solution or solution using this coin
8. Return result if achievable, -1 if impossible

**Example Trace** (coins=[1,2,5], amount=11):
```
dp[0] = 0
dp[1] = 1 (1 coin of 1)
dp[2] = 1 (1 coin of 2)
dp[3] = 2 (1+2)
dp[4] = 2 (2+2)
dp[5] = 1 (1 coin of 5)
dp[6] = 2 (5+1)
...
dp[11] = 3 (5+5+1)
```

---

## Greedy Algorithms

### Activity Selection Problem

**Description**: Select maximum number of non-overlapping activities.

**Time Complexity**: O(n log n) | **Space Complexity**: O(1)

```python
def activity_selection(activities):
    # activities = [(start, end), ...]

    # Sort by end time (greedy choice: earliest finish first)
    activities.sort(key=lambda x: x[1])

    selected = []                       # Store selected activities
    last_end = 0                        # Track end time of last selected

    for start, end in activities:       # Iterate through sorted activities
        if start >= last_end:           # No overlap with last selected
            selected.append((start, end))  # Select this activity
            last_end = end              # Update last end time

    return selected

# Example
activities = [(1, 3), (2, 5), (4, 6), (6, 7), (5, 9), (8, 9)]
print(activity_selection(activities))
# Output: [(1, 3), (4, 6), (6, 7), (8, 9)]
```

**Line-by-Line Breakdown**:
1. Sort activities by end time (greedy strategy)
2. List to store selected activities
3. Track when last selected activity ends
4. Iterate through activities in sorted order
5. Check if activity starts after last one ends
6. Add non-overlapping activity to selection
7. Update end time for next comparison
8. Return maximum set of non-overlapping activities

**Why Greedy Works**:
- Always pick activity that finishes earliest
- Leaves maximum time for remaining activities
- Proves to give optimal solution

---

## Backtracking

### Generate All Permutations

**Description**: Generate all possible arrangements of elements using backtracking.

**Time Complexity**: O(n! * n) | **Space Complexity**: O(n)

```python
def permute(nums):
    result = []                         # Store all permutations

    def backtrack(current, remaining):
        if not remaining:               # Base case: no elements left
            result.append(current[:])   # Add copy of current permutation
            return

        for i in range(len(remaining)): # Try each remaining element
            # Choose: pick element at index i
            element = remaining[i]
            new_remaining = remaining[:i] + remaining[i+1:]

            # Explore: recurse with chosen element
            backtrack(current + [element], new_remaining)

            # No need to unchoose (implicitly done by recursion)

    backtrack([], nums)                 # Start with empty current, all remaining
    return result

# Example
print(permute([1, 2, 3]))
# Output: [[1,2,3], [1,3,2], [2,1,3], [2,3,1], [3,1,2], [3,2,1]]
```

**Line-by-Line Breakdown**:
1. Initialize result list for all permutations
2. Backtracking helper function
3. Base case: used all elements
4. Add completed permutation (copy to avoid reference issues)
5. Try each remaining element as next choice
6. Choose current element
7. Create new remaining list without chosen element
8. Recurse with updated current and remaining
9. Start backtracking with empty path and all elements

**Backtracking Template**:
```python
def backtrack(path, choices):
    if is_solution(path):
        result.append(path[:])  # Add copy
        return

    for choice in choices:
        # Make choice
        path.append(choice)

        # Explore
        backtrack(path, new_choices)

        # Undo choice (backtrack)
        path.pop()
```

---

### N-Queens Problem

**Description**: Place N queens on NxN board so none attack each other.

**Time Complexity**: O(N!) | **Space Complexity**: O(N²)

```python
def solve_n_queens(n):
    result = []                         # Store all solutions
    board = [['.'] * n for _ in range(n)]  # Initialize empty board

    def is_safe(row, col):
        # Check column
        for i in range(row):            # Check rows above
            if board[i][col] == 'Q':    # Queen in same column
                return False

        # Check diagonal (top-left)
        i, j = row - 1, col - 1
        while i >= 0 and j >= 0:        # Move diagonally up-left
            if board[i][j] == 'Q':      # Queen on diagonal
                return False
            i -= 1
            j -= 1

        # Check diagonal (top-right)
        i, j = row - 1, col + 1
        while i >= 0 and j < n:         # Move diagonally up-right
            if board[i][j] == 'Q':      # Queen on diagonal
                return False
            i -= 1
            j += 1

        return True                     # Safe position

    def backtrack(row):
        if row == n:                    # Placed all queens
            result.append([''.join(row) for row in board])  # Add solution
            return

        for col in range(n):            # Try each column in this row
            if is_safe(row, col):       # Check if safe to place
                board[row][col] = 'Q'   # Place queen
                backtrack(row + 1)      # Recurse to next row
                board[row][col] = '.'   # Remove queen (backtrack)

    backtrack(0)                        # Start from row 0
    return result

# Example
solutions = solve_n_queens(4)
for solution in solutions:
    for row in solution:
        print(row)
    print()

# Output (one solution):
# .Q..
# ...Q
# Q...
# ..Q.
```

**Line-by-Line Breakdown**:
1. Initialize result list
2. Create board filled with dots
3. Function to check if position is safe
4. Check if any queen in same column above
5. Check upper-left diagonal
6. Move diagonally up and left
7. Check for queen on diagonal
8. Check upper-right diagonal
9. Move diagonally up and right
10. Position is safe if all checks pass
11. Backtracking function for each row
12. Base case: placed queens in all rows
13. Add current board configuration to results
14. Try placing queen in each column
15. Check if position is safe
16. Place queen (make choice)
17. Recurse to place queen in next row
18. Remove queen (undo choice) for next iteration
19. Start backtracking from first row

---

## Key Takeaways

### Algorithm Selection Guide:

**Sorting**:
- Quick Sort: Average case performance, in-place
- Merge Sort: Guaranteed O(n log n), stable, uses extra space
- Insertion Sort: Best for small/nearly sorted arrays

**Searching**:
- Binary Search: O(log n) but requires sorted array
- Linear Search: Works on unsorted, O(n)

**String Operations**:
- Two Pointers: Palindromes, reversal
- Hash Maps: Anagrams, character frequency

**Graph Traversal**:
- BFS: Shortest path, level order
- DFS: Path finding, cycle detection, topological sort

**Optimization**:
- Dynamic Programming: Overlapping subproblems, optimal substructure
- Greedy: Local optimal leads to global optimal
- Backtracking: Generate all possibilities, pruning

### Complexity Cheat Sheet:

| Algorithm | Time (Avg) | Time (Worst) | Space |
|-----------|------------|--------------|-------|
| Bubble Sort | O(n²) | O(n²) | O(1) |
| Quick Sort | O(n log n) | O(n²) | O(log n) |
| Merge Sort | O(n log n) | O(n log n) | O(n) |
| Binary Search | O(log n) | O(log n) | O(1) |
| BFS/DFS | O(V+E) | O(V+E) | O(V) |
| Dijkstra | O(E log V) | O(E log V) | O(V) |

### Problem-Solving Patterns:

1. **Two Pointers**: Sorted arrays, palindromes, pair sums
2. **Sliding Window**: Subarray/substring problems
3. **Fast & Slow Pointers**: Cycle detection, middle element
4. **Divide & Conquer**: Merge sort, binary search
5. **Dynamic Programming**: Fibonacci, knapsack, coin change
6. **Backtracking**: Permutations, combinations, N-Queens
7. **Greedy**: Activity selection, Huffman coding
8. **BFS**: Shortest path, level order
9. **DFS**: Path existence, connected components

### Tips:

- **Always consider edge cases**: empty input, single element, duplicates
- **Optimize space when possible**: rolling arrays in DP
- **Think about tradeoffs**: time vs space, simplicity vs efficiency
- **Test with examples**: trace through algorithm step-by-step
- **Know your data structures**: right DS makes algorithm simpler
