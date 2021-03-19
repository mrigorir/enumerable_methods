module Enumerable
  def my_each
    Enumerator.new(self) unless block_given?

    for i in 0...self.length
      if self.is_a Hash
      yield self[i]
      yield self[i]
      elsif self.is_a Array
        yield self[i]
      end
    end
  end
end

words = {:word1 => 'string1', :word2 => 'string2', :word3 => 'string3'}

words.my_each { |k, v| p "key: #{k}, value: #{v}"}