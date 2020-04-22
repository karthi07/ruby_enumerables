module Enumerable
  def my_each
    return to_enum unless block_given?

    (0...size).each do |i|
      yield(to_a[i])
    end
  end

  def my_each_with_index
    return to_enum unless block_given?

    (0...size).each do |i|
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

  def my_map(args = nil)
    return to_enum unless block_given?

    res = []
    if args
      my_each { |x| res.append(args.call(x)) }
    else
      my_each { |x| res.append(yield(x)) }
    end
    res
  end

  def my_inject(*args) # rubocop:disable Metrics/CyclomaticComplexity
    # return to_enum unless block_given?
    res = args[0] if args[0].is_a?(Integer)
    operator = args[0].is_a?(Symbol) ? args[0] : args[1]
    li = is_a?(Range) ? to_a : self
    if operator
      li.my_each { |item| res = res ? res.send(operator, item) : item }
      return res
    end
    res = nil
    my_each { |item| res = res ? yield(res, item) : item }

    res
  end
end
