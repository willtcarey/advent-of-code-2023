def next_sequence_num(numbers)
  return 0 if numbers.all?(0)
  diffs = numbers.each_cons(2).map { _2 - _1 }
  numbers[0] - next_sequence_num(diffs)
end

next_nums = File.open("input.txt").map do |line|
  numbers = line.split(" ").map(&:to_i)
  puts numbers.inspect
  next_sequence_num(numbers)
end

puts next_nums.inspect
puts next_nums.sum