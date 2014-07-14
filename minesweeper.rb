class Tile
  def initialize(bomb = false)
    @bomb = bomb
    @flagged = false
    @revealed = false
  end

  def bomb?
    @bomb
  end

  def flagged=(val)
    @flagged = val
  end

  def flagged?
    @flagged
  end

  def revealed=(val)
    @revealed = val
  end

  def revealed?
    @revealed
  end
end

class Board
  def initialize
    @tiles = Array.new(9) { Array.new(9) { Tile.new(rand(5) > 1 ? false : true) } }
  end

  def display
    @tiles.each do |row|
      row.each do |tile|
        p tile.revealed?
      end
    end
  end
end