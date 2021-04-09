require './lib/enumerable_methods'

describe Enumerable do
  let(:array) { %w[apple Orange Watermelon Banana] }
  let(:hash) { { fruit: 'banana', phone: 'apple' } }
  let(:number_array) { [1, 2, 3, 4] }
  let(:arr) { [] }
  let(:false_arr) { [false] }
  let(:true_arr) { [1, 3, 5] }
  let(:varied_array) { [nil, true, 99] }
  let(:animal_array) { %w[ant bear cat] }
  let(:float_array) { [2.34, 3.14, 20, 78, 6.82] }
  let(:nil_array) { [nil] }
  let(:true_array) { [nil, true, false] }
  let(:range) { (5..10) }
  let(:range2) { (1..15) }

  describe '#my_each' do
    it 'returns the array' do
      expect(array.my_each { |fruit| fruit }).to eql(array)
    end

    it 'returns the numbers if they are even' do
      expect(number_array.my_each { |number| number if number.even? })
        .to eql(number_array.each { |number| number if number.even? })
    end

    it 'my_each when self is a hash' do
      expect(hash.my_each { |keys, value| keys if value == 'banana' })
        .to eql(hash.each { |keys, value| keys if value == 'banana' })
    end

    it 'does not return a transformed array' do
      expect(number_array.my_each { |n| n * 2 }).not_to eq([2, 4, 6, 8])
    end
  end

  describe '#my_each_with_index' do
    it 'returns the doubled indexes for an array' do
      expect(number_array.my_each_with_index { |_number, index| index * 2 })
        .to eql(number_array.each_with_index { |_number, index| index * 2 })
    end

    it 'returns all elements that are even index' do
      expect(number_array.my_each_with_index { |number, index| number if index.even? })
        .to eql(number_array.each_with_index { |number, index| number if index.even? })
    end

    it 'returns hash if an index for key is 1' do
      expect(hash.my_each_with_index { |hash, index| hash if index == 1 })
        .to eql(hash.each_with_index { |hash, index| hash if index == 1 })
    end

    it 'does not return a transformed array' do
      expect(number_array.my_each_with_index { |n, index| n * 2 if index.even? }).not_to eq([2, 2, 6, 4])
    end
  end

  describe '#my_all?' do
    it 'returns true if all of the elements matches the condition' do
      expect(array.my_all? { |word| word.length >= 5 }).to be true
    end

    it 'returns false if all of the elements does not match the condition' do
      expect(array.my_all? { |word| word.length >= 20 }).to be false
    end

    it 'returns true if all elements has the letter a' do
      expect(array.my_all?(/a/)).to be true
    end

    it 'returns false if all elements does not have the letter y' do
      expect(array.my_all?(/y/)).to be false
    end

    it 'returns true if all of the elements are numeric' do
      expect(number_array.my_all?(Numeric)).to be true
    end

    it 'returns true if we don\'t have a block' do
      expect(arr.my_all?).to be true
    end

    it 'returns false for unmatched statements' do
      expect(varied_array.my_all?).to be false
    end
  end

  describe '#my_select' do
    it 'returns elements with 6 letters' do
      expect(array.my_select { |word| word if word.length == 6 }).to eq(%w[Orange Banana])
    end

    it 'return elements with letters lesser than 6 and highger than 6' do
      expect(array.my_select { |word| word if word.length < 6 || word.length > 6 }).to eq(%w[apple Watermelon])
    end

    it 'returns all the numbers divisible by 2' do
      expect(number_array.my_select { |number| number if number.even? }).to eq([2, 4])
    end

    it 'doens\'t modify the original array' do
      test_array = [1, 2, 4]
      new_array = test_array.my_select { |n| n * 2 }
      expect(new_array).to eq(test_array)
    end
  end

  describe '#my_any?' do
    it 'returns true if there\'s at least one word with 3 letters' do
      expect(animal_array.my_any? { |word| word.length >= 3 }).to be true
    end

    it 'returns false if there\'s not at least one word with letter d' do
      expect(animal_array.my_any?(/d/)).to be false
    end

    it 'returns true if there\'s at least one integer' do
      expect(varied_array.my_any?(Integer)).to be true
    end

    it 'returns false if we don\'t have a block' do
      expect(arr.my_any?).to be false
    end

    it 'returns true if at least one element exists' do
      expect(varied_array.my_any?).to be true
    end
  end

  describe '#my_none?' do
    it 'returns true if there are no words with 5 letters' do
      expect(animal_array.my_none? { |word| word.length >= 5 }).to be true
    end

    it 'returns true if there are no words with letter d' do
      expect(animal_array.my_none?(/d/)).to be true
    end

    it 'returns true if we don\'t have anything inside the array' do
      expect(arr.my_none?).to be true
    end

    it 'returns true if the values inside the array are nil' do
      expect(nil_array.my_none?).to be true
    end

    it 'returns false if there\'s at least, a true boolean' do
      expect(true_array.my_none?).to be false
    end
  end

  describe '#my_count' do
    it 'returns the number of elements' do
      expect(number_array.my_count).to eql(4)
    end

    it 'returns the number of times an element appears in the array' do
      expect(number_array.my_count(4)).to eql(1)
    end

    it 'returns the number of elements witch are equal to 5' do
      expect(number_array.my_count { |x| x if x == 5 }).to eql(0)
    end
  end

  describe '#my_map' do
    it 'modifies the elements in the array depending on the condition' do
      expect(number_array.my_map { |number| number * 2 }).to eql([2, 4, 6, 8])
    end

    it 'repeats the elements N times as indicated' do
      expect((1..3).my_map { 'hello' }).to eql(%w[hello hello hello])
    end

    it 'modifies the words between arrays' do
      foods = ['Small hamburger', 'Small soda', 'Small potatos']
      expected = ['extraHyperUltraBig hamburger', 'extraHyperUltraBig soda', 'extraHyperUltraBig potatos']
      expect(foods.my_map { |foodie| foodie.gsub('Small', 'extraHyperUltraBig') }).to eq(expected)
    end

    it 'doens\'t change the initial array' do
      array = %w[hello hey]
      new_array = array.my_map { |el| el * 3 }
      expect(array).not_to eq(new_array)
    end

    describe '#my_inject' do
      it 'returns the outcome of summing many elements' do
        expect(range.my_inject(:+)).to eql(45)
      end

      it 'sums all of the elements using a block' do
        expect(range2.my_inject { |sum, n| sum + n }).to eql(120)
      end

      it 'multiply all elements and returns the outcome' do
        expect(range.my_inject(1, :*)).to eql(151_200)
      end

      it 'returns the outcome of all multiplied elements using a block' do
        expect(range.my_inject(1) { |el, n| el * n }).to eql(151_200)
      end

      it 'returns the longest word' do
        longest = array.my_inject { |memo, word| memo.length > word.length ? memo : word }
        expect(longest).to eql('Watermelon')
      end
    end

    describe '#multiply_els' do
      it 'multiplies all the elements of the array' do
        expect(number_array.my_inject { |el, n| el * n }).to eql(24)
      end
    end
  end
end
