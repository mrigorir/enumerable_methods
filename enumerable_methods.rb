module Enumerable
  def my_each
    return to_enum unless block_given?

    for i in 0...size
      yield to_a[i]
    end
    self
  end

  def my_each_with_index
    return to_enum unless block_given?

    for i in 0...size
      yield to_a[i], i
    end
    self
  end

  def my_select
    return to_enum unless block_given?

    selected_el = []
    my_each { |sel| selected_el << sel if yield sel }
    selected_el
  end

  def my_all?(*args)
    check = true
    if block_given?
      my_each { |el| check = false if yield(el) == false }
    elsif args.size.positive? # have argument - for matching
      if args[0].class == Regexp
        my_each { |el| check = false unless el.match(args[0]) }
      else
        my_each { |el| check = false unless [el.class, el.class.superclass].include?(args[0]) }
      end
    else
      my_each { |el| check = false if [nil, false].include?(el) }
    end
    check
  end

  def my_any?(*args)
    check = false
    if block_given?
      my_each { |el| check = true if yield(el) == true }
    elsif args.size.positive? # have argument - for matching
      if args[0].class == Regexp
        my_each { |el| check = true if el.match(args[0]) }
      else
        my_each { |el| check = true if [el.class, el.class.superclass].include?(args[0]) }
      end
    else
      check = 0
      my_each { |el| check += 1 if el == true }
      return true if check.positive?

      return false
    end
    check
  end

  def my_none?(*args)
    count = 0
    if block_given?
      my_each { |el| count += 1 if yield(el) == false }
    elsif args.size.positive? # have argument - for matching
      if args[0].class == Regexp
        my_each { |el| count += 1 unless el.match(args[0]) }
      else
        my_each { |el| count += 1 unless [el.class, el.class.superclass].include?(args[0]) }
      end
    else
      my_each { |el| count += 1 if [nil, false].include?(el) }
    end
    return true if count == size

    false
  end

  def my_count(*args)
    count = 0
    if block_given?
      my_each { |el| count += 1 if yield(el) == true }
    elsif args.size.positive?
      my_each { |el| count += 1 if el == args[0] }
    else
      count = size
    end
    count
  end

  def my_map(prc = nil, &blk)
    return to_enum unless !prc.nil? || block_given?
    new_array = []
    prc.nil? ? my_each { |n| new_array << blk.call(n) } : my_each { |n| new_array << prc.call(n) }
    new_array
  end

  def my_inject(*args)
    arr = self.to_a
    result = arr[0]
    n = arr[1]
    i = 0
    if block_given?
      arr = to_a
      result = arr[0]
      n = arr[1]
      i = 0
      while i < arr.size - 1
        result = yield(result, n)
        n = arr[i + 2]
        i += 1
      end
      result
    end
  end
end

# my_each
=begin
a = [ "a", "b", "c" ]
p "Array my_each with block #{a.my_each {|x| print x, " -- " }}"
p "Array my_each without block #{a.my_each}"

h = { "a" => 100, "b" => 200 }
p "Hash my_each with block #{h.my_each {|key, value| puts "#{key} is #{value}" }}"
p "Hash my_each without block #{h.my_each}"

# my_each_with_index
hash = Hash.new
p "Hash each_with_index with block #{%w(cat dog wombat).my_each_with_index { |item, index|
  hash[item] = index
}}"
p hash
# hash   #=> {"cat"=>0, "dog"=>1, "wombat"=>2}

p "Hash each_with_index with block #{%w(cat dog wombat).my_each_with_index }"

# my_select
p "my_select with block #{(1..10).my_select { |i|  i % 3 == 0 }}"   #=> [3, 6, 9]

p "my_select with block #{[1,2,3,4,5].my_select { |num|  num.even?  }}"   #=> [2, 4]

p "my_select with block #{[:foo, :bar].my_select { |x| x == :foo }}"   #=> [:foo]

p "my_select without block #{(1..10).my_select}"   #=> enumerator

p "my_select without block #{[1,2,3,4,5].my_select}"   #=> enumerator

p "my_select without block #{[:foo, :bar].my_select}"    #=> enumerator

# my_all?
p "%w[ant bear cat].my_all? { |word| word.length >= 3 } #{%w[ant bear cat].my_all? { |word| word.length >= 3 }}" #=> true
p "%w[ant bear cat].my_all? { |word| word.length >= 4 } #{%w[ant bear cat].my_all? { |word| word.length >= 4 }}" #=> false
p "%w[ant bear cat].my_all?(/t/)                        #{%w[ant bear cat].my_all?(/t/)}"                        #=> false
p "[1, 2i, 3.14].my_all?(Numeric)                       #{[1, 2i, 3.14].my_all?(Numeric)}"                       #=> true
p "[nil, true, 99].my_all?                              #{[nil, true, 99].my_all?}"                              #=> false
p "[].my_all?                                           #{[].my_all?}"                                           #=> true

#my_any?
p "%w[ant bear cat].my_any? { |word| word.length >= 3 } #{%w[ant bear cat].my_any? { |word| word.length >= 3 }}" #=> true
p "%w[ant bear cat].my_any? { |word| word.length >= 4 } #{%w[ant bear cat].my_any? { |word| word.length >= 4 }}" #=> true
p "%w[ant bear cat].my_any?(/d/)                        #{%w[ant bear cat].my_any?(/d/) }"                       #=> false
p "[nil, true, 99].my_any?(Integer)                     #{[nil, true, 99].my_any?(Integer)}"                     #=> true
p "[nil, true, 99].my_any?                              #{[nil, true, 99].my_any? }"                             #=> true
p "[].my_any?                                           #{[].my_any?}"                                           #=> false

#my_none?
p "%w{ant bear cat}.my_none? { |word| word.length == 5 } #{%w{ant bear cat}.my_none? { |word| word.length == 5 }}" #=> true
p "%w{ant bear cat}.my_none? { |word| word.length >= 4 } #{%w{ant bear cat}.my_none? { |word| word.length >= 4 }}" #=> false
p "%w{ant bear cat}.my_none?(/d/)                        #{%w{ant bear cat}.my_none?(/d/)}"                        #=> true
p "[1, 3.14, 42].my_none?(Float)                         #{[1, 3.14, 42].my_none?(Float)}"                         #=> false
p "[].my_none?                                           #{[].my_none?}"                                           #=> true
p "[nil].my_none?                                        #{[nil].my_none?}"                                        #=> true
p "[nil, false].my_none?                                 #{[nil, false].my_none?}"                                 #=> true
p "[nil, false, true].my_none?                           #{[nil, false, true].my_none?}"                           #=> false

#my_count
ary = [1, 2, 4, 2]
p "ary.my_count                    #{ary.my_count}"                  #=> 4
p "ary.my_count(2)                 #{ary.my_count(2)}"               #=> 2
p "ary.my_count{ |x| x%2==0 }      #{ary.my_count{ |x| x%2==0 }}"    #=> 3

#my_map
p "(1..4).my_map { |i| i*i }      #{(1..4).my_map { |i| i*i }}"           #=> [1, 4, 9, 16]
p "(1..4).my_map { 'cat'  }   #{(1..4).my_map { 'cat' }}"        #=> ["cat", "cat", "cat", "cat"]

p "(1..4).my_map      #{(1..4).my_map}"           #=> enumerator
p "(1..4).my_map   #{(1..4).my_map}"      #=> enumerator

#my_inject
# Same using a block and inject
p (5..10).my_inject { |sum, n| sum + n }            #=> 45

# Same using a block
p (5..10).my_inject(1) { |product, n| product * n } #=> 151200
 #find the longest word
longest = %w{ cat sheep bear }.my_inject do |memo, word|
   memo.length > word.length ? memo : word
end
p longest                                        #=> "sheep"


def multiply_els(arr)
  arr.my_inject { |memo, n| memo * n }
end

p multiply_els([2,4,5]) #=> 40


prc_1 = proc { |n| n * 2 }
p [1, 2, 3].my_map{ |m| m * 3 }
=end