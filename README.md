Implementation of a binary heap in Ruby.

Gem is published at: https://rubygems.org/gems/rb_binary_heap

```ruby
require 'rb_binary_heap'

# This array will be used in the examples below
array = [1, 3, 0, 8]

# Initialize min heap from array
min_heap = BinaryHeap.new(array.dup) 
# the same as BinaryHeap.new(array.dup, type: :min)

min_heap.each do |n|
  p n # prints 0, 1, 3, 8
end
# min_heap is now empty, iteration over heap pops its elements

# Initialize max heap from array
max_heap = BinaryHeap.new(array.dup, type: :max)

while max_heap.not_empty? do
  n = max_heap.pop
  p n # prints 8, 3, 1, 0
end

# Heap :type can be either :min or :max, 
# min compares elements with :<, popped elements will be in increasing order,
# max compares elements with :>, popped elements will be in decreasing order

# Also you can create an empty heap and push elements onto it

min_heap = BinaryHeap.new # the same as BinaryHeap.new(type: :min)

# push elements 
array.each do |n|
  min_heap.push n
end
# or like this
min_heap = array.inject(BinaryHeap.new) { |heap, n| heap.push n } 

# What if you need custom comparison for elements?
# For example, you want to create a heap of strings
# and it should be ordered by decreasing string size.
# For cases like this, you can use a block

custom_heap = BinaryHeap.new { |a, b| a.size > b.size }
# which also can be written like this
# custom_heap = BinaryHeap.new(type: :max, compare_attribute: :size)

# push calls can be chained
custom_heap.push("aa").push("aaa").push("a")

custom_heap.each do |s|
  p s # prints "aaa", "aa", "a"
end

# You can get a sorted array from heap with to_a
min_heap = BinaryHeap.new(array.dup)

p min_heap.to_a # prints 0, 1, 3, 8
# min_heap is now empty

# In all the examples above, where the heap was created from array,
# array.dup was used in heap initialization, like this:
# min_heap = BinaryHeap.new(array.dup)
# Because heap modifies the array passed to it, dup is used
# to copy the original array to prevent its modification.
# But if you don't care if original array is modified or not,
# you don't have to copy it with dup before passing it to Heap:

# Let Heap use the array, without copying it
min_heap = BinaryHeap.new(array) 

min_heap.each do |n|
  p n # prints 0, 1, 3, 8
end
# Both min_heap and array are now empty

# As a final example, let's solve a LeetCode problem 'Merge K sorted lists'
# https://leetcode.com/problems/merge-k-sorted-lists/description/

def merge_k_lists(lists)
  lists = lists.reject(&:nil?)
  heap = BinaryHeap.new(lists, compare_attribute: :val)
  # also can be equivalently defined like this
  # heap = BinaryHeap.new(lists) { |a, b| a.val < b.val }
  head, last = nil, nil
  while heap.not_empty?
    current = heap.pop
    if head.nil?
      head, last = current, current
    else
      last.next = current
      last = current
    end
    heap.push(current.next) if current.next
    last.next = nil
  end
  head
end
```
