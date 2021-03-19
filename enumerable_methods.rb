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

  def my_all?
    return self.to_enum unless block_given?

  end
end

words = {word1: 'string1', word2: 'string2', word3: 'string3'}

array = [1, 2, 3]

friends = ['Marco', 'Adriana', 'Felon']

#p words.my_each { |k, v| p "key: #{k} value: #{v}" }

#p array.my_each_with_index { |el, i|  puts "el: #{el} index: #{i+1}" } 
# ------------------
#p array.my_select { |n| n > 1}

#p friends.my_select { |f| f != 'Felon'}

#p words.my_select { |w, s| s == 'string1' }


#p [1, 5, 7].each { |el| p el * 10 }