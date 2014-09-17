class ChessPiece
  attr_reader :move_dirs, :color, :max_distance

  def initialize(color)
    @color = color
  end

  def has_move_vect?(move_vect)
    move_vects.include? move_vect
  end

  def has_take_vect?(take_vect)
    take_vects.include? take_vect
  end

  def piece_type
    self.class.name.downcase.to_sym
  end

  def to_s
    self.class.chars[self.color]
  end

  def move_vects
    (1..max_distance).map do |distance|
      self.move_dirs.map do |dir|
        [distance * dir[0], distance * dir[1]]
      end
    end.flatten(1)
  end

  def take_vects
    self.move_vects
  end
end


class SteppingPiece < ChessPiece
  def initialize(color)
    super
    @max_distance = 1
  end
end

class SlidingPiece < ChessPiece
  def initialize(color)
    super
    @max_distance = 7
  end
end

class King < SteppingPiece
  def self.chars
    {white: "♔", black: "♚"}
  end

  def initialize(color)
    super
    @move_dirs = [
      [1, 0], [0, 1], [-1, 0], [0, -1],
      [1, 1], [-1, 1], [-1, -1], [1, -1]
    ]
  end
end

class Queen < SlidingPiece
  def self.chars
    {white: "♕", black: "♛"}
  end

  def initialize(color)
    super
    @move_dirs = [
      [1, 0], [0, 1], [-1, 0], [0, -1],
      [1, 1], [-1, 1], [-1, -1], [1, -1]
    ]
  end
end

class Rook < SlidingPiece
  def self.chars
    {white: "♖", black: "♜"}
  end

  def initialize(color)
    super
    @move_dirs = [[1, 0], [0, 1], [-1, 0], [0, -1]]
  end
end

class Bishop < SlidingPiece
  def self.chars
    {white: "♗", black: "♝"}
  end

  def initialize(color)
    super
    @move_dirs = [[1, 1], [-1, 1], [-1, -1], [1, -1]]
  end
end

class Knight < SteppingPiece
  def self.chars
    {white: "♘", black: "♞"}
  end

  def initialize(color)
    super
    @move_dirs = [
      [1, 2], [1, -2], [-1, 2], [-1, -2],
      [2, 1], [2, -1], [-2, 1], [-2, -1]
    ]
  end
end

class Pawn < SteppingPiece
  def self.chars
    {white: "♙", black: "♟"}
  end

  def initialize(color)
    super
    @move_dirs = [
      [direction_to_move, 0]
    ]
    @moved = false
  end

  def direction_to_move
    color == :white ? 1 : -1
  end

  def moved?
    @moved
  end

  def max_distance
    moved? ? 1 : 2
  end

  def take_vects
    [[direction_to_move, 1], [direction_to_move, -1]]
  end

end
