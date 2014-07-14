require 'yaml'

class Tile
  attr_accessor :bombed, :flagged, :revealed, :adjacent_bombs

  def initialize(bombed = false)
    @bombed = bombed
    @flagged = false
    @revealed = false
    @adjacent_bombs = 0
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
  attr_accessor :tiles, :bomb_revealed

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

  NUMBER_PICS = {
    1 => "➀",
    2 => "➁",
    3 => "➂",
    4 => "➃",
    5 => "➄",
    6 => "➅",
    7 => "➆",
    8 => "➇",
    9 => "➈"
  }

  def initialize(size = 9)
    @tiles = Array.new(size) { Array.new(size) { Tile.new(rand(7) > 1 ? false : true) } }
    (0...@tiles.length).each do |x|
      (0...@tiles.length).each do |y|
        if get_tile([x, y]).bombed?
          adjacent_coords([x, y]).each do |coord|
            tile = get_tile(coord)
            tile.adjacent_bombs += 1 if tile
          end
        end
      end
    end
  end

  def size
    @tiles.length
  end

  def over?
    over = true
    @tiles.flatten.each do |tile|
      #return @bomb_revealed = true if tile.revealed? && tile.bombed?
      raise "Revealed bomb, lost!" if tile.revealed? && tile.bombed?
      if tile.bombed?
        over = false if !tile.flagged?
      else
        over = false if !tile.revealed? || tile.flagged?
      end
    end

    over
  end

  def get_tile(coord)
    return nil if coord.any? { |c| c < 0 || c >= @tiles.length }
    @tiles[coord[0]][coord[1]]
  end

  def reveal(coord)
    return if get_tile(coord).revealed?
    coord_array = [coord]

    until coord_array.empty?
      c = coord_array.shift
      tile = get_tile(c)
      if tile
        tile.revealed = true
        if tile.adjacent_bombs < 1
          coord_array += adjacent_coords(c).select do |pos|
            get_tile(pos) && !get_tile(pos).revealed? && !get_tile(pos).bombed?
          end
        end
      end
    end
  end

  def reveal_all
    @tiles.each do |row|
      row.each do |tile|
        tile.revealed = true
      end
    end
  end

  def flag(coord)
    tile = get_tile(coord)
    tile.flagged = !tile.flagged if tile
  end

  def adjacent_coords(coord)
    coord_array = []
    DELTAS.each do |delta|
      coord_array << [delta[0] + coord[0], delta[1] + coord[1]]
    end
    coord_array
  end

  def display
    @tiles.each do |row|
      row.each do |tile|
        if tile.revealed?
          if tile.bombed?
            #print 'ó '
            print "☠ "
          else
            if tile.adjacent_bombs > 0
              print NUMBER_PICS[tile.adjacent_bombs] + " "
            else
              print '_ '
            end
          end
        else
          print tile.flagged? ? 'F ' : '* '
        end
      end

      puts
    end
  end
end

class Game
  attr_accessor :board
  def initialize(size = 9, saved_game = nil)
    @board = saved_game ? Game.load_game(saved_game) : Board.new(size)
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
    puts "Game saved to #{filename}!"
  end

  def play
    begin
      until @board.over?
        @board.display
        action = 'b'
        while action == 'b'
          action = get_action
          if !action == 's'
            coord = get_coord
          end
        end
        case action
        when 'b'
          next
        when 'f'
          @board.flag(coord)
        when 'r'
          @board.reveal(coord)
        when 's'
          print "Enter a filename to save as: "
          save_game(gets.chomp)
        end
      end

      @board.display
      puts "You won"
    rescue
      @board.reveal_all
      @board.display
      puts "You lost!"
    end
  end

  def get_coord
    coord = [-1, -1]
    while coord.any? { |c| c < 0 || c >= @board.size }
      print "Enter a valid coordinate to check: "
      coord = YAML.load(gets.chomp)
    end

    coord.reverse
  end

  def get_action
    action = ''
    until ['b', 'f', 'r', 's'].include?(action)
      print "Enter an action ([r]eveal, [f]lag, [b]ack, or [s]ave): "
      action = gets.chomp.downcase
    end

    action
  end
end

g = Game.new(9)
g.play