require "strscan"

$max_width = 0
$max_height = 0

Sym = Struct.new(:symbol, :x, :y)
Part = Struct.new(:digit, :x, :y) do
  def adjacent?(x, y)
    adjacent_points.include?([x, y])
  end

  def adjacent_points
    points = []
    points << [x-1, y] # left
    points << [x+digit.length, y] # right
    
    # top
    digit.length.times do |i|
      points << [x+i, y-1]
    end

    # bottom
    digit.length.times do |i|
      points << [x+i, y+1]
    end

    points << [x-1, y-1] # top left diag
    points << [x+digit.length, y-1] # top right diag
    points << [x-1, y+1] # bottom left diag
    points << [x+digit.length, y+1] # bottom right diag

    points
  end
end

syms = []
parts = []

File.open("input.txt").each.with_index do |line, y|
  buffer = ""
  line.chars.each.with_index do |char, x|
    if char =~ /\d/
      buffer += char
    else
      if buffer != ""
        parts << Part.new(buffer, x - buffer.length, y)
        buffer = ""
      end
      next if char == "." || char == "\n"
      syms << Sym.new(char, x, y)
    end
  end
end

# part 1
# valid_parts = syms.map do |sym|
#   parts.select { _1.adjacent?(sym.x, sym.y) }
# end.flatten

# puts valid_parts.map(&:digit).map(&:to_i).sum

potential_gears = syms.select { _1.symbol == "*" }
ratios = potential_gears.map do |gear|
  puts gear
  adjacent_parts = parts.select { _1.adjacent?(gear.x, gear.y) }
  next unless adjacent_parts.count == 2
  adjacent_parts.map(&:digit).map(&:to_i).reduce(:*)
end.compact

puts ratios.sum
