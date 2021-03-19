module Enumerable
  def my_each
    return Enumerable.new(self) unless block_given?
    for i in 0...to_a.length
      yield to_a[i]
    end
  end
end
