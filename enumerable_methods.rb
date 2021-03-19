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


end


ary = [1, 2, 4, 2]
p ary.my_count              #=> 4
p ary.count(2)                #=> 2
p ary.count{ |x| x % 2 == 0 } #=> 3