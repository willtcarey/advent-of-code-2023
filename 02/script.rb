Game = Struct.new(:id, :rounds, keyword_init: true) do
  def self.parse(str)
    game_id, game = str.split(": ")
    game_id = game_id.gsub("Game ", "").to_i

    rounds = game.split(";").map { Round.parse(_1) }
    
    Game.new(id: game_id, rounds: rounds)
  end

  def valid?(piece_counts)
    rounds.all? { _1.valid?(piece_counts) }
  end

  def minimum_pieces
    pieces = rounds.map(&:pieces).flatten
    piece_groups = pieces.group_by(&:color)
    piece_groups.map do |color, pieces|
      pieces.map(&:count).max
    end
  end
end

Round = Struct.new(:pieces, keyword_init: true) do
  def self.parse(str)
    pieces = str.split(", ")
    Round.new(pieces: pieces.map { PieceCount.parse(_1) })
  end

  def valid?(piece_counts)
    pieces.all? do |piece_count|
      game_piece = piece_counts.detect { _1.color == piece_count.color }
      next false unless game_piece
      game_piece.count >= piece_count.count
    end
  end
end

PieceCount = Struct.new(:count, :color, keyword_init: true) do
  def self.parse(str)
    count, color = str.split(" ")
    PieceCount.new(count: count.to_i, color:)
  end
end

# Part 1
# valid_game_ids = File.open("input.txt").map do |line|
#   game = Game.parse(line)
#   valid = game.valid?([
#     PieceCount.new(count: 12, color: "red"),
#     PieceCount.new(count: 13, color: "green"),
#     PieceCount.new(count: 14, color: "blue")
#   ])

#   valid ? game.id : nil
# end.compact

# puts valid_game_ids.sum


# Part 2
powers = File.open("input.txt").map do |line|
  game = Game.parse(line)
  minimum_counts = game.minimum_pieces
  minimum_counts.reduce(:*)
end

puts powers.sum
