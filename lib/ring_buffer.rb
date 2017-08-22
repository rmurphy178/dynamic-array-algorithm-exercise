
require_relative "static_array"

class RingBuffer
  attr_reader :length

  def initialize
    @store = StaticArray.new(8)
    @length = 0
    @capacity = 8
    @start_idx = 0
  end

  # O(1)
  def [](index)
    if index >= length
      raise "index out of bounds"

    else
      store[check_index(index)]
    end
  end

  # O(1)
  def []=(index, val)
    if index >= length
      raise "index out of bounds"
      
    else
      store[check_index(index)] = val
    end
  end

  # O(1)
  def pop
    raise "index out of bounds" if length == 0
    @length -= 1
    return_val = store[check_index(length)]
    store[check_index(length)] = nil
    return_val
  end

  # O(1) ammortized
  def push(val)
    resize! if length == capacity
    store[check_index(length)] = val
    @length += 1
  end

  # O(1)
  def shift
    raise "index out of bounds" if length == 0
    return_val = store[start_idx]
    store[start_idx] = nil
    @start_idx = (@start_idx + 1) % capacity
    @length -= 1
    return_val
  end

  # O(1) ammortized
  def unshift(val)
    resize! if length == capacity
    @start_idx = (@start_idx - 1) % capacity
    store[start_idx] = val
    @length += 1
  end

  protected

  attr_accessor :capacity, :start_idx, :store
  attr_writer :length

  def check_index(index)
    (index + start_idx) % capacity
  end

  def resize!
    @capacity *= 2
    old_store = store
    @store = StaticArray.new(capacity)
    i = 0
    while i < length
      store[i] = old_store[(start_idx + i) % length]
      i += 1
    end
    @start_idx = 0
  end
end
