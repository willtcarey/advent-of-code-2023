require "strscan"

# scores = File.open("input.txt").map do |line|
#   scanner = StringScanner.new(line.chomp)
#   scanner.scan("Card ")
#   card_id = scanner.scan_until(/:/).delete(":")
#   winning_numbers_str = scanner.scan_until(/\|/).delete("|").strip
#   winning_numbers = winning_numbers_str.split(" ").map(&:to_i)
#   my_numbers_str = scanner.rest.strip
#   my_numbers = my_numbers_str.split(" ").map(&:to_i)

#   # puts "Card #{card_id}: #{winning_numbers_str} | #{my_numbers_str}"

#   matches = winning_numbers & my_numbers
#   next 0 if matches.length == 0
#   2**(matches.length-1)
# end

# puts scores.sum

card_wins = Array.new(193, 0)
max_card = 0

File.open("input.txt").each do |line|
  scanner = StringScanner.new(line.chomp)
  scanner.scan("Card ")
  card_id = scanner.scan_until(/:/).delete(":").to_i
  max_card = card_id
  winning_numbers_str = scanner.scan_until(/\|/).delete("|").strip
  winning_numbers = winning_numbers_str.split(" ").map(&:to_i)
  my_numbers_str = scanner.rest.strip
  my_numbers = my_numbers_str.split(" ").map(&:to_i)

  # puts "Card #{card_id}: #{winning_numbers_str} | #{my_numbers_str}"

  matches = winning_numbers & my_numbers
  matches.count.times do |i|
    card_wins[card_id + i + 1] += card_wins[card_id] + 1
  end
end

puts max_card + card_wins.sum

