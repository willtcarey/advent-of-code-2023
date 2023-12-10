require "strscan"

Path = Struct.new(:name, :left, :right) do
  def self.parse(str)
    scanner = StringScanner.new(str)
    name = scanner.scan(/\w+/)
    scanner.skip(/\s=\s\(/)
    left = scanner.scan(/\w+/)
    scanner.skip(/,\s/)
    right = scanner.scan(/\w+/)
    Path.new(name, left, right)
  end
end

input = File.read("input.txt")
input.split("\n\n") => instructions, paths_str

paths = paths_str.split("\n").map { Path.parse(_1) }
path_map = paths.map { [_1.name, _1] }.to_h
curr_paths = paths.select { _1.name[2] == "A" }
loop_lengths = curr_paths.map do |curr_path|
  counter = 0
  loop do
    instruction = instructions[counter % instructions.length]
    path_dir = case instruction
    in "L" then :left
    in "R" then :right
    end
    # puts new_path_name
    curr_path = path_map[curr_path.send(path_dir)]
    counter += 1
    # puts counter if counter % 100000 == 0
    if curr_path.name[2] == "Z"
      puts "Counter: #{counter}"
      break
    end
  end
  counter
end

puts loop_lengths.reduce(&:lcm)

