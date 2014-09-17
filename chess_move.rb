class ChessMove

  attr_reader :start_pos, :end_pos, :color, :board
  def initialize(board, color, piece_type, start_pos, end_pos)
    @board  = board
    @color, @piece_type = color, piece_type
    @start_pos, @end_pos = start_pos, end_pos
    #p color, start_pos, end_pos
  end


  def is_valid_move?
    has_valid_piece? && valid_move_vect? && path_clear? && !taking_own_piece?
  end


  # there is an appropriate piece to move at start_pos

  def has_valid_piece?
    piece_to_move && right_piece_type? && right_piece_color?
  end

  def right_piece_type?
    piece_to_move.piece_type == @piece_type
  end

  def right_piece_color?
    piece_to_move.color == @color
  end


  # piece can make that move (assuming empty board)

  def valid_move_vect?
    valid_passive_move_vect? || valid_aggressive_move_vect?
  end

  def valid_passive_move_vect?
    piece_to_move.has_move_vect?(move_vect) && @board[end_pos].nil?
  end

  def valid_aggressive_move_vect?
    piece_to_move.has_take_vect?(move_vect) && @board[end_pos]
  end


  # no pieces in betwen start_pos and end_pos other than a piece to take

  def path_clear?
    (1...num_steps).all? do |step|
      @board[partial_slide(step)].nil?
    end
  end

  def taking_own_piece?
    @board[end_pos] && @board[end_pos].color == @color
  end




  # move info

  def piece_to_move
    @board[@start_pos]
  end

  def piece_to_take
    @board[@end_pos] if @board[end_pos].color == @color
  end

  def move_vect
    start_row, start_col = @start_pos
    end_row, end_col = @end_pos

    [end_row - start_row, end_col - start_col]
  end

  def move_dir
    move_vect.map{ |coord| coord / num_steps }
  end

  def num_steps
    move_vect[0].gcd move_vect[1]
  end

  def partial_slide(step)
    [start_pos[0] + move_dir[0] * step, start_pos[1] + move_dir[1] * step]
  end
end

class InvalidMoveError < StandardError
end

