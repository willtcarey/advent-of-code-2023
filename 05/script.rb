def take_first(arr, &block)
  i = 0
  while i < arr.length
    result = block.call(arr[i])
    return result if result
    i += 1
  end
  nil
end

# ActiveSupport Range#overlaps?
module RangeOverlap
  refine Range do
    def _empty_range?(b, e, excl)
      return false if b.nil? || e.nil?
    
      comp = b <=> e
      comp.nil? || comp > 0 || (comp == 0 && excl)
    end

    def overlap?(other)
      raise TypeError unless other.is_a? Range
    
      self_begin = self.begin
      other_end = other.end
      other_excl = other.exclude_end?
    
      return false if _empty_range?(self_begin, other_end, other_excl)
    
      other_begin = other.begin
      self_end = self.end
      self_excl = self.exclude_end?
    
      return false if _empty_range?(other_begin, self_end, self_excl)
      return true if self_begin == other_begin
    
      return false if _empty_range?(self_begin, self_end, self_excl)
      return false if _empty_range?(other_begin, other_end, other_excl)
    
      true
    end
  end
end

using RangeOverlap


ConversionRange = Struct.new(:destination, :source, :length) do
  def range
    @range ||= source..(source + length)
  end

  def convert_seed(seed_range)
    return nil unless range.overlap?(seed_range)
    # Get overlap range
    overlap_range = [seed_range.begin, range.begin].max..[seed_range.end, range.end].min
    leftover_ranges = [
      (seed_range.begin..(overlap_range.begin-1) if seed_range.begin < overlap_range.begin),
      ((overlap_range.end+1)..seed_range.end if overlap_range.end < seed_range.end)
    ].compact

    shift = destination - source
    new_range = (overlap_range.begin + shift)..(overlap_range.end + shift)
    [new_range, *leftover_ranges]

    # part 1
    # destination + (seed - source)
  end
end

input = File.read("input.txt")
input.split("\n\n") => [seeds_str, *conversion_strs]
seeds = seeds_str.gsub("seeds: ", "").split(" ").map(&:to_i)
seeds = seeds.each_slice(2).map { |(start, length)| start..(start + length) }
puts seeds.inspect

conversion_strs.each do |conversion_str|
  lines = conversion_str.split("\n").drop(1)
  ranges = lines.map { _1.split(" ").map(&:to_i) }.map { ConversionRange.new(*_1) }
  i = 0
  while i < seeds.length
    seed_range = seeds[i]
    new_ranges = take_first(ranges) { _1.convert_seed(seed_range) } || [seed_range]
    seeds.delete_at(i)
    seeds.insert(i, *new_ranges)
    i += 1
  end
end

puts seeds.map(&:begin).min



