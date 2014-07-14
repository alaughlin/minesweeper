class Tile
  attr_accessor :flagged, :revealed
  attr_reader :bomb

  def initialize(bomb = false)
    @bomb = bomb
    @flagged = false
    @revealed = false
  end
end

class Board
  def initialize
    tiles = Array.new(9) { Array.new(9) { Tile.new(rand(5) > 1 ? false : true) } }
  end
end