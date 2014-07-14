require 'yaml'

class Tile
  attr_accessor :bomb, :flagged, :revealed

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
  attr_accessor :tiles
  def initialize
    @tiles = Array.new(9) { Array.new(9) { Tile.new(rand(5) > 1 ? false : true) } }
  end

  def display
    @tiles.each do |row|
      row.each do |tile|
        print tile.revealed? ? tile.flagged? ? "f" : "_" : "*"
      end

      puts
    end
  end
end

class Game
  attr_accessor :board
  def initialize(saved_game = nil)
    @board = saved_game ? Game.load_game(saved_game) : Board.new
  end

  def self.load_game(file_name)
    if File.file?(file_name)
      YAML.load(File.open(file_name).read)
    else
      raise "File not found!"
    end
  end

  def save_game(file_name)
    File.open(file_name, 'w').write(@board.to_yaml)
  end
end

g = Game.new("game.txt")
g.save_game("game.txt")
g.board.display