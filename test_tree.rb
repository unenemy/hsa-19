require "./tree.rb"
require "benchmark"
require "json"

buckets = {}

10_000.step(100_000, 10_000).each do |size|
  buckets[size] = 10.times.map do 
    values = []
    tree = AVLTree.new
    size.times do |i|
      value = rand(1_000_000_000)
      tree.add(value)
      values << value
    end
    {
      tree: tree,
      samples: values.sample(1000)
    }
  end
end

benchmark_results = { insert: {}, find: {}, remove: {} }

buckets.each do |size, batch|
  Benchmark.benchmark("Insert - Bucket Size #{size}\n", 10, nil, ">avg:") do |x|
    res = batch.map.with_index do |bucket, i|
      x.report("Test #{i}") { 1000.times { bucket[:tree].add(rand(1_000_000_000)) } }
    end
    [res.reduce(&:+) / res.size].tap { |x| benchmark_results[:insert][size] = x.first.real }
  end
end

buckets.each do |size, batch|
  Benchmark.benchmark("Find - Bucket Size #{size}\n", 10, nil, ">avg:") do |x|
    res = batch.map.with_index do |bucket, i|
      x.report("Test #{i}") {  1000.times { |j| bucket[:tree].find(bucket[:samples][j]) }  }
    end
    [res.reduce(&:+) / res.size].tap { |x| benchmark_results[:find][size] = x.first.real }
  end
end

buckets.each do |size, batch|
  Benchmark.benchmark("Find - Bucket Size #{size}\n", 10, nil, ">avg:") do |x|
    res = batch.map.with_index do |bucket, i|
      x.report("Test #{i}") {  1000.times { |j| bucket[:tree].remove(bucket[:samples][j]) }  }
    end
    [res.reduce(&:+) / res.size].tap { |x| benchmark_results[:remove][size] = x.first.real }
  end
end

puts JSON.pretty_generate(benchmark_results)