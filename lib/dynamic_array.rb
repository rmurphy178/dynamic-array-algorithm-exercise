require_relative "static_array"

class DynamicArray
  attr_reader :length

  def initialize
    @store = StaticArray.new(8)
    @length = 0
    @capacity = 8
  end

  # O(1)
  def [](index)
    if index >= length
      raise "index out of bounds"
    else
      store[index]
    end
  end

  # O(1)
  def []=(index, value)
    if index >= length
      raise "index out of bounds"
    else
      store[index] = value
    end
  end

  # O(1)
  def pop
    raise "index out of bounds" if length == 0
    @length -= 1
    temp = store[length]
    store[length] = nil
    temp
  end

  # O(1) ammortized; O(n) worst case. Variable because of the possible
  # resize.
  def push(val)
    resize! if length == capacity
    store[length] = val
    @length += 1
  end

  # O(n): has to shift over all the elements.
  def shift
    raise "index out of bounds" if length == 0
    old_store = store
    @store = StaticArray.new(capacity)
    i = 0
    while i < length
      store[i + 1] = old_store[i]
      i += 1
    end
    @length -= 1
  end

  # O(n): has to shift over all the elements.
  def unshift(val)
    resize! if length == capacity
    old_store = store
    @store = StaticArray.new(capacity)
    store[0] = val
    i = 0
    while i < length
      store[i + 1] = old_store[i]
      i += 1
    end
    @length += 1
  end

  protected

  attr_accessor :capacity, :store
  attr_writer :length

  # O(n): has to copy over all the elements to the new store.
  def resize!
    @capacity *= 2
    old_store = store
    @store = StaticArray.new(capacity)
    i = 0
    while i < length
      store[i] = old_store[i]
      i += 1
    end
  end

end
