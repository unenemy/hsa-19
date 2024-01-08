require "benchmark"

def counting_sort(arr)
  # Find the range of values
  min_val = arr.min
  max_val = arr.max

  # Create and initialize the counting array
  counting_array = Array.new(max_val - min_val + 1, 0)

  # Count occurrences of each element
  arr.each { |num| counting_array[num - min_val] += 1 }

  # Calculate cumulative counts
  (1...counting_array.length).each { |i| counting_array[i] += counting_array[i - 1] }

  # Build the sorted array
  sorted_array = Array.new(arr.length)
  arr.reverse_each do |num|
    counting_array[num - min_val] -= 1
    sorted_array[counting_array[num - min_val]] = num
  end

  sorted_array
end

huge_array_small_range = 1_000_000.times.map { rand(10) }

small_array_huge_range = [200_000_000, 1]

Benchmark.bm do |x|
  x.report("Huge Array Small Range") { counting_sort(huge_array_small_range) }
  x.report("Small Array Huge Range") { counting_sort(small_array_huge_range) }
end
