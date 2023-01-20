# frozen_string_literal: true

require 'rb_binary_heap'

describe 'Heap' do
  it 'Correctly pushes elements' do
    10.times.each do
      random_size = rand(0...10_000)
      arr = Array.new(random_size) { rand(-100_000...100_000) }

      min_heap = arr.inject(BinaryHeap.new) { |h, n| h.push(n) }
      expect(min_heap.to_a).to eq(arr.sort)

      max_heap = arr.inject(BinaryHeap.new(type: :max)) { |h, n| h.push(n) }
      expect(max_heap.to_a).to eq(arr.sort.reverse)
    end
  end

  it 'Returns sorted array from to_a' do
    # to_a is implemented using repeated pop calls,
    # so we don't need to test pop separately
    10.times.each do
      random_size = rand(0...10_000)
      arr = Array.new(random_size) { rand(-100_000...100_000) }

      min_heap = BinaryHeap.new(arr.dup)
      expect(min_heap.to_a).to eq(arr.sort)

      max_heap = BinaryHeap.new(arr.dup, type: :max)
      expect(max_heap.to_a).to eq(arr.sort.reverse)
    end
  end

  it 'Satisfies empty heap invariants' do
    heaps = [
      BinaryHeap.new,
      BinaryHeap.new(type: :max),
      BinaryHeap.new(compare_attribute: :size),
      BinaryHeap.new { |a, b| a < b }
    ]
    heaps.each do |h|
      expect { h.pop }.to raise_error(RuntimeError)
      expect { h.top }.to raise_error(RuntimeError)
      expect(h.empty?).to be(true)
      expect(h.not_empty?).to be(false)
      expect(h.to_a).to eq([])
      expect(h.size).to be(0)
    end
  end

  it 'Satisfies non-empty heap invariants' do
    arr = [1, 2]
    heaps = [
      BinaryHeap.new(arr.dup),
      BinaryHeap.new(arr.dup, type: :max),
      BinaryHeap.new(arr.dup) { |a, b| a < b }
    ]
    heaps.each do |h|
      expect { h.pop }.not_to raise_error
      expect { h.top }.not_to raise_error
      expect(h.empty?).to be(false)
      expect(h.not_empty?).to be(true)
      expect(h.size).not_to be(0)
    end
  end

  it 'Rejects incorrect initialization parameters' do
    expect { BinaryHeap.new(type: :wrong) }.to raise_error(RuntimeError)
    # :type and :compare_attribute should not be specified if the block is given,
    # because element comparison is done inside a block
    expect { BinaryHeap.new(type: :min) { |a, b| a < b } }.to raise_error(RuntimeError)
    expect { BinaryHeap.new(compare_attribute: :size) { |a, b| a < b } }.to raise_error(RuntimeError)
  end

  it 'Becomes empty' do
    h = BinaryHeap.new([1])
    expect(h.empty?).to be(false)
    expect(h.not_empty?).to be(true)
    expect(h.pop).to eq(1)
    expect(h.empty?).to be(true)
    expect(h.not_empty?).to be(false)
  end

  it 'Becomes non-empty' do
    h = BinaryHeap.new([])
    expect(h.empty?).to be(true)
    expect(h.not_empty?).to be(false)
    h.push(1)
    expect(h.top).to eq(1)
    expect(h.empty?).to be(false)
    expect(h.not_empty?).to be(true)
  end

  it 'Correctly compares by attributes' do
    arr = %w[zzz c aa sifjlkjf 778687ihuk]

    min_heap = BinaryHeap.new(arr.dup, compare_attribute: :size)
    expect(min_heap.to_a).to eq(arr.sort_by(&:size))
    
    max_heap = BinaryHeap.new(arr.dup, type: :max, compare_attribute: :size)
    expect(max_heap.to_a).to eq(arr.sort_by(&:size).reverse)
  end

  it 'Correctly uses a block to compare elements' do
    10.times.each do
      random_size = rand(0...10_000)
      arr = Array.new(random_size) { rand(-100_000...100_000) }

      min_heap_no_block = BinaryHeap.new(arr.dup, type: :min)
      min_heap_with_block = BinaryHeap.new(arr.dup) { |a, b| a < b }
      expect(min_heap_no_block.to_a).to eq(min_heap_with_block.to_a)

      max_heap_no_block = BinaryHeap.new(arr.dup, type: :max)
      max_heap_with_block = BinaryHeap.new(arr.dup) { |a, b| a > b }
      expect(max_heap_no_block.to_a).to eq(max_heap_with_block.to_a)
    end
  end
end
