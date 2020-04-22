# frozen_string_literal: true

module Enumerable
  def my_each
    return to_enum unless block_given?
    for i in 0...size
      yield(to_a[i])
    end
  end

  def my_each_with_index
    return to_enum unless block_given?

    for i in 0...size
      yield(to_a[i], i)
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
    mcount = 0
    if block_given?
      my_each { |x| mcount += 1 if yield(x) }
      return mcount
    else
      return size if args.nil?

      if args
        my_each { |x| mcount += 1 if x == args }
        return mcount
      end
    end
  end

  def my_map(args=nil)
    return to_enum unless block_given?

    res = []
    if args
      my_each { |x| res.append(args.call(x)) }  
    else
      my_each { |x| res.append(yield(x)) }
    end
    res
    
  end

  def my_inject(*args)
    #return to_enum unless block_given?
    res = args[0] if args[0].is_a?(Integer)
    operator = args[0].is_a?(Symbol) ? args[0] : args[1]
    li = is_a?(Range) ? to_a : self
    if operator
      li.my_each { |item| res = res ? res.send(operator, item) : item }
      return res
    end
    res = nil
    my_each { |item| res = res ? yield(res, item) : item }

    return res
  end
end


def test_enumerables

list1 = [11, 12, 13, 14, 15]

list2 = [1, 2, 4, 2, 3, 4, 2]


puts "Test my_each"
print("\n")
list1.my_each{ |x| print x+2," "}

print("\nMy_each with index\n")

list1.my_each_with_index{ |x,index| print x + index," " }
print("\n")


puts "Test my_select"

p list1.select(&:even?)
p list1.my_select(&:even?)

puts "Test my_all"
p list1.my_all { |x| x > 8 }

p %w[ant bear cat].my_all { |word| word.length >= 4 }

puts "Test my_any"
p %w[ant bear cat].my_any { |word| word.length >= 4 }
puts "Test my_none"
p %w[ant bear cat].my_none { |word| word.length >= 3 }

puts "Test my_count"
p list2.my_count

p list2.my_count(2)

p list1.my_count(&:even?)

puts "Test my_map"
list1 = list1.my_map { |x| x + x }
print list1

p (1..4).my_map { |i| i * i } #=> [1, 4, 9, 16]
p (1..4).my_map { 'cat' }

puts "Test my_inject"
p (1..3).my_inject { |sum, n| sum + n }
p (1..3).inject { |sum, n| sum + n }

list3 = [1,2,3,4,5]
p (5..10).my_inject(:+)

p (5..10).my_inject(1, :*)
p (5..10).my_inject(1) { |product, n| product * n }

longest = %w{ cat sheep bear }.inject do |memo, word|
 memo.length > word.length ? memo : word
end

p longest

test_proc = proc do |item|
  "proc"
end
puts 'test my_map with proc and block'
output = (1..2).my_map(test_proc) do |x|
  "block"
end
print output
puts
puts 'test my_map with block'

output = (1..2).my_map do |item|
  "block"
end
print output
puts

end

test_enumerables