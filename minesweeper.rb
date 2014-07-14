class Tile
  attr_accessor :flagged, :revealed
  attr_reader :bomb

  def initialize(bomb = false)
    @bomb = bomb
    @flagged = false
    @revealed = false
  end
end