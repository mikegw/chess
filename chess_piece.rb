class ChessPiece
  attr_accessor :moved
  attr_reader :move_dirs, :color, :max_distance

  def initialize(color)
    @color = color
    @moved = false
  end

  #------General validity-tests for all pieces------#

  ## A "move_vect" is the integer vector between ending and starting positions of a move in which no piece is captured. A "take_vect" is the corresponding vector for a move that captures a piece.

  ## A "move_dir" is the integer vector in the same direction as a move_vect (or take_vect) whose coordinates have no common factors


  def has_move_vect?(move_vect)
    move_vects.include? move_vect
  end

  def has_take_vect?(take_vect)
    take_vects.include? take_vect
  end


  ## We calculate a move_vect based on the "distance" travelled along it (i.e. the multiple of the move_dir)

  ## We calculate the valid move_vects of a piece base on its valid move_dirs and the maximum distance it can move, i.e. 1 for a "stepping piece" (Knight or King), 7 for a "sliding piece" (Queen, Rook, or Bishop), and either 1 or 2 for a pawn depending whether or not it has moved.

  ## This does not take into account castling, which involves more than once piece and their relative positions, and thus is handled by the board.

  ## It does, however, still handle en passant captures

  def move_vects
    (1..max_distance).map do |distance|
      self.move_dirs.map do |dir|
        [distance * dir[0], distance * dir[1]]
      end
    end.flatten(1)
  end


  ## For all pieces except the pawn, the move_vects and take_vects are the same. For the Pawn, we hard-code the take_vects, making the Pawn's max_distance only relevant in the non-capturing case.

  def take_vects
    self.move_vects
  end


  #------Basic operations------#

  def dup
    new_piece = self.class.new(@color)
    new_piece.moved = @moved
    new_piece
  end

  def to_s
    self.class.chars[self.color]
  end


  #------Basic piece info------#

  def piece_type
    self.class.name.downcase.to_sym
  end

  def moved?
    @moved
  end
end


#------Categories of pieces------#

## We call the Knight and King "SteppingPieces", because they can only make a single step along their move_dirs. We also classify Pawns this way, and overwrite this behavior when they have not yet moved.

class SteppingPiece < ChessPiece
  def initialize(color)
    super
    @max_distance = 1
  end
end


## We call the Queen, Rook, and Bishop "SlidingPieces" because they can slide as large a distance they want along their move_dirs. Because the board is 8-by-8, the largest distance between two pieces along a non-zero move_dir is 7.

class SlidingPiece < ChessPiece
  def initialize(color)
    super
    @max_distance = 7
  end
end


#------Individual pieces------#

#------King (remember that the Board deals with castling)------#

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


#------Queen------#

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

#------Rook------#

class Rook < SlidingPiece
  def self.chars
    {white: "♖", black: "♜"}
  end

  def initialize(color)
    super
    @move_dirs = [[1, 0], [0, 1], [-1, 0], [0, -1]]
  end
end


#------Bishop------#

class Bishop < SlidingPiece
  def self.chars
    {white: "♗", black: "♝"}
  end

  def initialize(color)
    super
    @move_dirs = [[1, 1], [-1, 1], [-1, -1], [1, -1]]
  end
end


#------Knight------#

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


#------Pawn------#

class Pawn < SteppingPiece
  def self.chars
    {white: "♙", black: "♟"}
  end

  def initialize(color)
    super
    @move_dirs = [
      [direction_to_move, 0]
    ]
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

#------Helper method (accessible everywhere)------#

def sym_to_class(piece_type_sym)
  Kernel.const_get(piece_type_sym.to_s.split('_').map(&:capitalize).join)
end
