# frozen_string_literal: true

class BinaryHeap
  include Enumerable

  def initialize(array = [], type: nil, compare_attribute: nil, &block)
    @array = array

    comparison_method_name = :compare

    if block_given?
      if type || compare_attribute
        raise 'Heap: :type and :compare_attribute should not be defined if the block is given'
      end

      define_singleton_method(comparison_method_name) do |a, b|
        block.call a, b
      end
    else
      type = :min if type.nil?

      op = heap_type_to_comparison_operator type

      if compare_attribute.nil?
        define_singleton_method(comparison_method_name) do |a, b|
          a.send(op, b)
        end
      else
        define_singleton_method(comparison_method_name) do |a, b|
          a_value = a.send(compare_attribute)
          b_value = b.send(compare_attribute)
          a_value.send(op, b_value)
        end
      end
    end

    heapify
  end

  def top
    raise "Heap: Can't get the top element, heap is empty" if @array.empty?
    @array.first
  end

  def push(value)
    @array.push value
    sift_up_from_last
    self
  end

  def pop
    raise "Heap: Can't pop, heap is empty" if @array.empty?
    return @array.pop if @array.size == 1

    result = @array.first
    last_element = @array.pop
    @array[0] = last_element
    
    sift_down_from_first
    result
  end

  def not_empty?
    !empty?
  end

  def empty?
    @array.empty?
  end

  def each
    yield pop while not_empty?
  end

  def size
    @array.size
  end

  private

  def heapify
    i = @array.size / 2
    while i >= 0
      sift_down_from i
      i -= 1
    end
  end

  def sift_up_from_last
    sift_up_from @array.size - 1
  end

  def sift_down_from_first
    sift_down_from 0
  end

  def sift_up_from(i)
    while i.positive?
      parent = (i - 1) / 2

      break if compare(@array[parent], @array[i])

      swap i, parent
      
      i = parent
    end
  end

  def sift_down_from(i)
    while (left = 2 * i + 1) < @array.size
      largest = i

      largest = left if !compare(@array[largest], @array[left])

      right = 2 * i + 2

      if right < @array.size && !compare(@array[largest], @array[right])
        largest = right
      end

      break if largest == i

      swap i, largest

      i = largest
    end
  end

  def swap(i, j)
    @array[i], @array[j] = @array[j], @array[i]
  end

  def heap_type_to_comparison_operator(type)
    case type
    when :min then :<
    when :max then :>
    else
      raise 'Heap: :type should be either :min or :max'
    end
  end
end

