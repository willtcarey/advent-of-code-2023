require "strscan"

input = File.read("input.txt")
input.split("\n") => [time_str, distance_str]

# Part 1
# scanner = StringScanner.new(time_str)
# scanner.scan(/Time\:\s+/)
# times = []
# while scanner.scan_until(/\d+/)
#   times << scanner.matched.to_i
# end

# scanner = StringScanner.new(distance_str)
# scanner.scan(/Distance\:\s+/)
# distances = []
# while scanner.scan_until(/\d+/)
#   distances << scanner.matched.to_i
# end

# Part 2
times = [time_str.gsub("Time: ", "").gsub(" ", "").to_i]
distances = [distance_str.gsub("Distance: ", "").gsub(" ", "").to_i]

ways = times.zip(distances).map do |time, distance|
  puts "Time: #{time}, Distance: #{distance}"
  ways = (time + 1).times.select do |i|
    speed = i
    boat_distance = speed * (time - i)
    boat_distance > distance
  end
  ways.count
end

puts ways.inspect
puts ways.reduce(&:*)