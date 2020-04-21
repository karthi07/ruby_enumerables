# frozen_string_literal: true

module Enumerable
  def my_each
    return to_enum unless block_given?

    (0...size).each do |i|
      yield(self[i])
    end
  end

  def my_each_with_index
    return to_enum unless block_given?

    (0...size).each do |i|
      yield(self[i], i)
    end
    nil
  end

  def my_select
    return to_enum unless block_given?

    res = []
    my_each do |x|
      res.append(x) if yield(x)
    end
    res
  end

  def my_all
    return to_enum unless block_given?

    my_each do |x|
      return false unless yield(x)
    end
    true
  end

  def my_any
    return to_enum unless block_given?

    my_each do |x|
      return true if yield(x)
    end
    false
  end

  def my_none
    return to_enum unless block_given?

    my_each do |x|
      return false if yield(x)
    end
    true
  end

  def my_count(args = nil)
    #    return to_enum unless block_given?

    return size unless block_given?
    return size if args.length == 1
  end
end

list1 = [11, 12, 13, 14, 15]

#
# list1.each{ |x| print x," " }
# print("\n")
# list1.my_each{ |x| print x+2," "}
#
# print("\nMy_each with index\n")
#
#  list1.my_each_with_index{ |x,index| print x + index," " }
# print("\n")
# p [11, 12, 13, 14, 15].each_with_index{|x,index| print x + index," " }
#
#
#
# p list1.select(&:even?)
# p list1.my_select(&:even?)

# p list1.my_all { |x| x > 8 }

# p %w[ant bear cat].my_all { |word| word.length >= 4 }
# p %w[ant bear cat].my_any { |word| word.length >= 4 }

# p %w[ant bear cat].my_none { |word| word.length >= 3 }
p list1.my_count

p list1.my_count(2)
