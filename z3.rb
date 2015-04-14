require 'benchmark'

class Array
  def find(count = 2)
    self.bin_find count
  end

  def bin_find(count, index_difference = 0)
    elements = []

    mid = size / 2
    mid_difference = mid + index_difference

    go_right = 1
    go_left = count + 1
    go_both = count

    if self[mid] - mid_difference == go_left       # go left
      if size == 1
        new_elements = [self[mid] - 1]
        (count - 1).times { new_elements.unshift(new_elements.first - 1) } if count > 1

        return elements + new_elements
      end

      self[0...mid].bin_find count, index_difference

    elsif self[mid] - mid_difference == go_right   # go right
      if size == 1
        new_elements = [self[mid] + 1]
        (count - 1).times { new_elements.push(new_elements.last + 1) } if count > 1

        return elements + new_elements
      end

      self[mid..size].bin_find count, mid_difference  # compensate index difference when going right

    else #if self[mid] - mid_difference == go_both    # go left and right
      missing_at_left = self[mid] - mid_difference - 1
      missing_at_right = count - missing_at_left

      left_part, right_part = self[0...mid], self[mid..size]

      elements += (left_part.empty? ? self : left_part).bin_find(missing_at_left, index_difference)
      elements += right_part.bin_find(missing_at_right, mid_difference + missing_at_left)

      return elements
    end
  end

end

k = 1000000
arr = (1..k).to_a

count = 2
count.times { arr.delete arr.sample }

puts 'slow implementation:'
puts Benchmark.measure {
  p (1..k).to_a - arr
}

puts "\nfast implementation:"
puts Benchmark.measure {
  p arr.find(count)
}
