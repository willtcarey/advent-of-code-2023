$card_sort_order = ["J", "2", "3", "4", "5", "6", "7", "8", "9", "T", "Q", "K", "A"].map.with_index { |c, i| [c, i] }.to_h

def compare_hands(a, b)
  # puts a.inspect, b.inspect
  return b[1] <=> a[1] if a[1] != b[1]

  a[0].chars.zip(b[0].chars).each do |c, d|
    return $card_sort_order[d] <=> $card_sort_order[c] if c != d
  end
end

hands = File.open("input.txt").map do |line|
  hand, bid = line.split(" ")
  tallied = hand.chars.tally
  sorted_hand = hand.chars.sort_by { |c| [tallied[c], $card_sort_order[c]] }.reverse
  puts sorted_hand.inspect if hand == "A3AJA"
  strength = case sorted_hand
  # 5 of a kind
  in [a, ^a, ^a, ^a, ^a] then 6
  in [a, ^a, ^a, ^a, "J"] then 6
  in [a, ^a, ^a, "J", "J"] then 6
  in ["J", "J", "J", a, ^a] then 6
  in ["J", "J", "J", "J", a] then 6
  # 4 of a kind
  in [a, ^a, ^a, ^a, b] then 5
  in [a, ^a, ^a, b, "J"] then 5
  in ["J", "J", "J", a, b] then 5
  in [a, ^a, "J", "J", b] then 5
  # Full house
  in [a, ^a, ^a, b, ^b] then 4
  in [a, ^a, b, ^b, "J"] then 4
  # 3 of a kind
  in [a, ^a, ^a, b, c] then 3
  in [a, ^a, b, c, "J"] then 3
  in ["J", "J", a, b, c] then 3
  # 2 pairs
  in [a, ^a, b, ^b, c] then 2
  # 1 pair
  in [a, ^a, b, c, d] then 1
  in [a, b, c, d, "J"] then 1
  # High card
  in [a, b, c, d, e] then 0
  end

  if hand.include?("J")
    puts [hand, strength].inspect
  end

  [hand, strength, bid]
end

ranked_hands = hands.sort { compare_hands(_1, _2) }.reverse
puts ranked_hands.map.with_index { |hand, i| hand[2].to_i * (i + 1) }.sum
