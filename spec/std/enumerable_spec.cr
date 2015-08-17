require "spec"

describe "Enumerable" do

  describe "all? with block" do
    it "returns true" do
      ["ant", "bear", "cat"].all? { |word| word.length >= 3 }.should be_true
    end

    it "returns false" do
      ["ant", "bear", "cat"].all? { |word| word.length >= 4 }.should be_false
    end
  end

  describe "all? without block" do
    it "returns true" do
      [15].all?.should be_true
    end

    it "returns false" do
      [nil, true, 99].all?.should be_false
    end
  end

  describe "any? with block" do
    it "returns true if at least one element fulfills the condition" do
      ["ant", "bear", "cat"].any? { |word| word.length >= 4 }.should be_true
    end

    it "returns false if all elements dose not fulfill the condition" do
      ["ant", "bear", "cat"].any? { |word| word.length > 4 }.should be_false
    end
  end

  describe "any? without block" do
    it "returns true if at least one element is truthy" do
      [nil, true, 99].any?.should be_true
    end

    it "returns false if all elements are falsey" do
      [nil, false].any?.should be_false
    end
  end

  describe "compact map" do
    assert { Set { 1, nil, 2, nil, 3 }.compact_map { |x| x.try &.+(1) }.should eq([2, 3, 4]) }
  end

  describe "count without block" do
    it "returns the number of elements in the Enumerable" do
      (1..3).count.should eq 3
    end
  end

  describe "count with block" do
    it "returns the number of the times the item is present" do
      %w(a b c a d A).count("a").should eq 2
    end
  end

  describe "each_cons" do
    it "returns running pairs" do
      array = [] of Array(Int32)
      [1, 2, 3, 4].each_cons(2) { |pair| array << pair }
      array.should eq([[1, 2], [2, 3], [3, 4]])
    end

    it "returns running triples" do
      array = [] of Array(Int32)
      [1, 2, 3, 4, 5].each_cons(3) { |triple| array << triple }
      array.should eq([[1, 2, 3], [2, 3, 4], [3, 4, 5]])
    end

    it "returns each_cons iterator" do
      iter = [1, 2, 3, 4, 5].each_cons(3)
      iter.next.should eq([1, 2, 3])
      iter.next.should eq([2, 3, 4])
      iter.next.should eq([3, 4, 5])
      iter.next.should be_a(Iterator::Stop)

      iter.rewind
      iter.next.should eq([1, 2, 3])
    end
  end

  describe "each_slice" do
    it "returns partial slices" do
      array = [] of Array(Int32)
      [1, 2, 3].each_slice(2) { |slice| array << slice }
      array.should eq([[1, 2], [3]])
    end

    it "returns full slices" do
      array = [] of Array(Int32)
      [1, 2, 3, 4].each_slice(2) { |slice| array << slice }
      array.should eq([[1, 2], [3, 4]])
    end

    it "returns each_slice iterator" do
      iter = [1, 2, 3, 4, 5].each_slice(2)
      iter.next.should eq([1, 2])
      iter.next.should eq([3, 4])
      iter.next.should eq([5])
      iter.next.should be_a(Iterator::Stop)

      iter.rewind
      iter.next.should eq([1, 2])
    end
  end

  describe "each_with_index" do
    it "yields the element and the index" do
      collection = [] of {String, Int32}
      ["a", "b", "c"].each_with_index do |e, i|
        collection << {e, i}
      end
      collection.should eq [{"a", 0}, {"b", 1}, {"c", 2}]
    end

    it "gets each_with_index iterator" do
      iter = [1, 2].each_with_index
      iter.next.should eq({1, 0})
      iter.next.should eq({2, 1})
      iter.next.should be_a(Iterator::Stop)

      iter.rewind
      iter.next.should eq({1, 0})
    end
  end

  describe "each_with_object" do
    it "yields the element and the given object" do
      collection = [] of {Int32, String}
      object = "a"
      (1..3).each_with_object(object) do |e, o|
        collection << {e, o}
      end
      collection.should eq [{1, object}, {2, object}, {3, object}]
    end

    it "gets each_with_object iterator" do
      iter = [1, 2].each_with_object("a")
      iter.next.should eq({1, "a"})
      iter.next.should eq({2, "a"})
      iter.next.should be_a(Iterator::Stop)

      iter.rewind
      iter.next.should eq({1, "a"})
    end
  end

  describe "first" do
    it "gets first" do
      (1..3).first.should eq(1)
    end

    it "raises if enumerable empty" do
      expect_raises EmptyEnumerable do
        (1...1).first
      end
    end
  end

  describe "first?" do
    it "gets first?" do
      (1..3).first?.should eq(1)
    end

    it "returns nil if enumerable empty" do
      (1...1).first?.should be_nil
    end
  end

  describe "find" do
    it "finds" do
      [1, 2, 3].find { |x| x > 2 }.should eq(3)
    end

    it "doesn't find" do
      [1, 2, 3].find { |x| x > 3 }.should be_nil
    end

    it "doesn't find with default value" do
      [1, 2, 3].find(-1) { |x| x > 3 }.should eq(-1)
    end
  end

  describe "first" do
    assert { [-1, -2, -3].first.should eq(-1) }
    assert { [-1, -2, -3].first(1).should eq([-1]) }
    assert { [-1, -2, -3].first(4).should eq([-1, -2, -3]) }
  end

  describe "flat_map" do
    it "does example 1" do
      [1, 2, 3, 4].flat_map { |e| [e, -e] }.should eq([1, -1, 2, -2, 3, -3, 4, -4])
    end

    it "does example 2" do
      [[1, 2], [3, 4]].flat_map { |e| e + [100] }.should eq([1, 2, 100, 3, 4, 100])
    end
  end

  describe "group_by" do
    assert { [1, 2, 2, 3].group_by { |x| x == 2 }.should eq({true => [2, 2], false => [1, 3]}) }
  end

  describe "in_groups_of" do
    assert { [1, 2, 3].in_groups_of(1).should eq([[1], [2], [3]]) }
    assert { [1, 2, 3].in_groups_of(2).should eq([[1, 2], [3, nil]]) }
    assert { ([] of Int32).in_groups_of(2).should eq([] of Array(Array(Int32 | Nil))) }
    assert { [1, 2, 3].in_groups_of(2, "x").should eq([[1, 2], [3, "x"]]) }

    it "raises argument error if size is less than 0" do
      expect_raises ArgumentError, "size must be positive" do
        [1, 2, 3].in_groups_of(0)
      end
    end

    it "takes a block" do
      sums = [] of Int32
      [1, 2, 4].in_groups_of(2, 0) { |a| sums << a.sum }
      sums.should eq([3, 4])
    end
  end

  describe "inject" do
    assert { [1, 2, 3].inject { |memo, i| memo + i }.should eq(6) }
    assert { [1, 2, 3].inject(10) { |memo, i| memo + i }.should eq(16) }

    it "raises if empty" do
      expect_raises EmptyEnumerable do
        ([] of Int32).inject { |memo, i| memo + i }
      end
    end
  end

  describe "join" do
    it "joins with separator and block" do
      str = [1, 2, 3].join(", ") { |x| x + 1 }
      str.should eq("2, 3, 4")
    end

    it "joins without separator and block" do
      str = [1, 2, 3].join { |x| x + 1 }
      str.should eq("234")
    end

    it "joins with io and block" do
      str = StringIO.new
      [1, 2, 3].join(", ", str) { |x, io| io << x + 1 }
      str.to_s.should eq("2, 3, 4")
    end
  end

  describe "min" do
    assert { [1, 2, 3].min.should eq(1) }

    it "raises if empty" do
      expect_raises EmptyEnumerable do
        ([] of Int32).min
      end
    end
  end

  describe "max" do
    assert { [1, 2, 3].max.should eq(3) }

    it "raises if empty" do
      expect_raises EmptyEnumerable do
        ([] of Int32).max
      end
    end
  end

  describe "minmax" do
    assert { [1, 2, 3].minmax.should eq({1, 3}) }

    it "raises if empty" do
      expect_raises EmptyEnumerable do
        ([] of Int32).minmax
      end
    end
  end

  describe "min_by" do
    assert { [1, 2, 3].min_by { |x| -x }.should eq(3) }
  end

  describe "min_of" do
    assert { [1, 2, 3].min_of { |x| -x }.should eq(-3) }
  end

  describe "max_by" do
    assert { [-1, -2, -3].max_by { |x| -x }.should eq(-3) }
  end

  describe "max_of" do
    assert { [-1, -2, -3].max_of { |x| -x }.should eq(3) }
  end

  describe "minmax_by" do
    assert { [-1, -2, -3].minmax_by { |x| -x }.should eq({-1, -3}) }
  end

  describe "minmax_of" do
    assert { [-1, -2, -3].minmax_of { |x| -x }.should eq({1, 3}) }
  end

  describe "none?" do
    assert { [1, 2, 2, 3].none? { |x| x == 1 }.should eq(false) }
    assert { [1, 2, 2, 3].none? { |x| x == 0 }.should eq(true) }
  end

  describe "none? without block" do
    assert { [nil, false].none?.should be_true }
    assert { [nil, false, true].none?.should be_false }
  end

  describe "one?" do
    assert { [1, 2, 2, 3].one? { |x| x == 1 }.should eq(true) }
    assert { [1, 2, 2, 3].one? { |x| x == 2 }.should eq(false) }
    assert { [1, 2, 2, 3].one? { |x| x == 0 }.should eq(false) }
  end

  describe "partition" do
    assert { [1, 2, 2, 3].partition { |x| x == 2 }.should eq({[2, 2], [1, 3]}) }
  end

  describe "reject" do
    it "rejects the values for which the block returns true" do
      [1, 2, 3, 4].reject(&.even?).should eq([1, 3])
    end
  end

  describe "select" do
    it "selects the values for which the block returns true" do
      [1, 2, 3, 4].select(&.even?).should eq([2, 4])
    end
  end

  describe "skip" do
    it "returns an array without the skipped elements" do
      [1, 2, 3, 4, 5, 6].skip(3).should eq [4, 5, 6]
    end

    it "returns an empty array when skipping more elements than array size" do
      [1, 2].skip(3).should eq [] of Int32
    end

    it "raises if count is negative" do
      expect_raises(ArgumentError) do
        [1, 2].skip(-1)
      end
    end
  end

  describe "skip_while" do
    it "skips elements while the condition holds true" do
      result = [1, 2, 3, 4, 5, 0].skip_while {|i| i < 3}
      result.should eq [3, 4, 5, 0]
    end

    it "returns an empty array if the condition is always true" do
      [1, 2, 3].skip_while {true}.should eq [] of Int32
    end

    it "returns the full Array if the the first check is false" do
      [5, 0, 1, 2, 3].skip_while {|x| x < 4}.should eq [5, 0, 1, 2, 3]
    end

    it "does not yield to the block anymore once it returned false" do
      called = 0
      [1, 2, 3, 4, 4].skip_while do |i|
        called += 1
        i < 3
      end
      called.should eq 3
    end
  end

  describe "sum" do
    assert { ([] of Int32).sum.should eq(0) }
    assert { [1, 2, 3].sum.should eq(6) }
    assert { [1, 2, 3].sum(4).should eq(10) }
    assert { [1, 2, 3].sum(4.5).should eq(10.5) }
    assert { (1..3).sum { |x| x * 2 }.should eq(12) }
    assert { (1..3).sum(1.5) { |x| x * 2 }.should eq(13.5) }

    it "uses zero from type" do
      typeof([1, 2, 3].sum).should eq(Int32)
      typeof([1.5, 2.5, 3.5].sum).should eq(Float64)
      typeof([1, 2, 3].sum(&.to_f)).should eq(Float64)
    end
  end

  describe "take" do
    assert { [-1, -2, -3].take(1).should eq([-1]) }
    assert { [-1, -2, -3].take(4).should eq([-1, -2, -3]) }

    it "raises if count is negative" do
      expect_raises(ArgumentError) do
        [1, 2].take(-1)
      end
    end
  end

  describe "take_while" do
    it "keeps elements while the block returns true" do
      [1, 2, 3, 4, 5, 0].take_while {|i| i < 3}.should eq [1, 2]
    end

    it "returns the full Array if the condition is always true" do
      [1, 2, 3, -3].take_while {true}.should eq [1, 2, 3, -3]
    end

    it "returns an empty Array if the block is false for the first element" do
      [1, 2, -1, 0].take_while {|i| i <= 0}.should eq [] of Int32
    end

    it "does not call the block again once it returned false" do
      called = 0
      [1, 2, 3, 4, 0].take_while do |i|
        called += 1
        i < 3
      end
      called.should eq 3
    end
  end

  describe "to_a" do
    it "converts to an Array" do
      (1..3).to_a.should eq [1, 2, 3]
    end
  end

  describe "to_h" do
    it "for tuples" do
      hash = Tuple.new({:a, 1}, {:c, 2}).to_h
      hash.should be_a(Hash(Symbol, Int32))
      hash.should eq({a: 1, c: 2})
    end

    it "for array" do
      [[:a, :b], [:c, :d]].to_h.should eq({a: :b, c: :d})
    end
  end

  it "indexes by" do
    ["foo", "hello", "goodbye", "something"].index_by(&.length).should eq({
        3 => "foo",
        5 => "hello",
        7 => "goodbye",
        9 => "something",
      })
  end
end
