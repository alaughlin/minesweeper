require 'yaml'

class Tile
  attr_accessor :bombed, :flagged, :revealed

  def initialize(bombed = false)
    @bombed = bombed
    @flagged = false
    @revealed = false
  end

  def bombed?
    @bombed
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

  DELTAS = [
    [ 0, 1],
    [ 1, 1],
    [ 1, 0],
    [ 1,-1],
    [ 0,-1],
    [-1,-1],
    [-1, 0],
    [-1, 1]
  ]
  def initialize
    @tiles = Array.new(9) { Array.new(9) { Tile.new(rand(5) > 1 ? false : true) } }
  end

  def over?
    not_over = false
    @tiles.each do |row|
      row.each do |tile|
        return true if tile.revealed? && tile.bombed?
        if tile.bombed?
          not_over = true if !tile.flagged?
        else
          not_over = true if !tile.revealed? || tile.flagged?
        end
      end
    end

    not_over
  end

  def reveal(coord)
    return if (@tiles[coord[0]][coord[1]].revealed?)

  end

  def flag(coord)
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

  def play
    until @board.over?
      action = 'b'
      while action == 'b'
        coord = get_coord
        action = get_action
      end

    end
  end

  def get_coord
    coord = [-1, -1]
    while coord.any? { |c| c < 0 || c > 8 }
      print "Enter a valid coordinate to check: "
      coord = YAML.load(gets.chomp)
    end

    coord
  end

  def get_action
    action = ''
    until ['f', 'r'].include?(action)
      print "Enter an action ([r]eveal, [f]lag or [b]ack): "
      action = gets.chomp.downcase
    end

    action
  end

  def reveal
end

g = Game.new("game.txt")
g.board.display