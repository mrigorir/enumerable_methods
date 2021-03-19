module Enumerable
  def my_each(&blk)
    Enumerator.new(self) unless block_given?
    
    if blk.parameters.size == 1 # Array
      for i in 0...self.size
        yield self[i]
      end
    elsif blk.parameters.size == 2 # Hash
      for i in 0...self.size
        
      end
    end

  end
end

words = {
  :plane => 51, 
  :tree => 12, 
  :car => 32
}

words.my_each { |k, v| p "key: #{k}, value: #{v}"}