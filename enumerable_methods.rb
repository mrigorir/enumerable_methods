module Enumerable
  def my_each
    return self.to_enum unless block_given?

    for i in 0...self.length
      yield to_a[i]
    end
    self
  end

  def my_each_with_index
    return self.to_enum unless block_given?

    for i in 0...self.length
      yield to_a[i], i
    end
    self
  end

  def my_select
    return self.to_enum unless block_given?

    selected_el = Array.new
    my_each { |sel| selected_el << sel if yield sel }
    selected_el
  end

  def my_all?(*args)
    if block_given?
      check = true
      my_each { |el| check = false if yield(el) == false }
      return check
    elsif args.size > 0 # have argument - for matching
      check = true
      if args[0].class == Regexp
        my_each { |el| check = false unless el === args[0] }
        return check
      else
        my_each { |el| check = false unless [el.class, el.class.superclass].include?(args[0]) }
        return check
      end 
    else
      check = true
      my_each do |el| 
        check = false if el == nil || el == false 
      end
      check
    end
  end

  def my_any?(*args)
    if block_given?
      check = false
      my_each { |el| check = true if yield(el) == true }
      return check
    elsif args.size > 0 # have argument - for matching
      check = false
      if args[0].class == Regexp
        my_each { |el| check = true if el === args[0] }
        return check
      else
        my_each { |el| check = true if [el.class, el.class.superclass].include?(args[0]) }
        return check
      end 
    else
      check = 0
      my_each { |el| check += 1 if el == true }
      check > 0 ? true : false
    end
  end

  def my_none?(*args)
    count = 0
    if block_given?
      my_each { |el| count += 1 if yield(el) == false }
      if count == self.size
        return true
      else
        return false
      end
    elsif args.size > 0 # have argument - for matching
      if args[0].class == Regexp
        my_each { |el| count += 1 unless el === args[0] }
        if count == self.size
          return true
        else
          return false
        end
      else
        my_each { |el| count += 1 unless [el.class, el.class.superclass].include?(args[0]) }
        if count == self.size
          return true
        else
          return false
        end
      end 
    else
      my_each { |el| count += 1 if el == false || el == nil }
      count == self.size ? true : false
    end
  end

  def my_count(*args)
    count = 0
    if block_given?
      my_each { |el| count += 1 if yield(el) == true }
      return count
    elsif args.size > 0
      my_each { |el| count += 1 if el == args[0] }
      return count
    else
      my_each { |n| count += 1 }
      count
    end 
  end

  def my_map
    return self.to_enum unless block_given?
    new_array = []
    my_each { |el| new_array << yield(el) }
    new_array
  end
  def my_inject(*args)
    arr = self.to_a
    result = arr[0]
    n = arr[1]
    i = 0
    if block_given?
      while i < arr.size - 1
        result = yield(result, n)
        n = arr[i + 2]
        i += 1
      end
      result
    end
  end
end



# Same using a block and inject
p (5..10).my_inject { |sum, n| sum + n }            #=> 45

# Same using a block
p (5..10).my_inject(1) { |product, n| product * n } #=> 151200
 #find the longest word
longest = %w{ cat sheep bear }.my_inject do |memo, word|
   memo.length > word.length ? memo : word
end
p longest                                        #=> "sheep"