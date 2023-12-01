TOKEN_REGEXP = /\d|one|two|three|four|five|six|seven|eight|nine/

require "strscan"

def token_to_numeral(token)
  case token
  when "0".."9"then token.to_i
  when "one" then 1
  when "two" then 2
  when "three" then 3
  when "four" then 4
  when "five" then 5
  when "six" then 6
  when "seven" then 7
  when "eight" then 8
  when "nine" then 9
  else
    raise "bad token", token
  end
end

nums = File.open("input.txt").map do |line|
  scanner = StringScanner.new(line)
  tokens = []
  puts line
  loop do
    scanner.scan_until(TOKEN_REGEXP)
    break unless scanner.matched
    tokens << scanner.matched
    # Account for cases where the line could have
    # multiple numbers merged
    if scanner.matched.length > 1
      scanner.pos = scanner.pos - scanner.matched.length + 1
    end
  end

  "#{token_to_numeral(tokens.first)}#{token_to_numeral(tokens.last)}".to_i
end

puts nums.sum