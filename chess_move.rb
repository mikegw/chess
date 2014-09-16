class ChessMove
  def initialize(board, piece_type, start_pos, end_pos)
    @board  = board
    @piece_type = piece_type
    @start_pos, @end_pos = start_pos, end_pos
  end

  def move_vect
    start_row, start_col = @start_pos
    end_row, end_col = @end_pos

    [end_row - start_row, end_col - start_col]
  end

  def is_valid_move?
    right_piece_type? && valid_move_vect? && path_clear?
  end

  def right_piece_type?
    piece_to_move.piece_type == piece_type
  end

  def valid_move_vect?

    piece_to_move.has_move_vect?(move_vect)
  end

  def path_clear?

  end

  def piece_to_move
    @board[start_pos]
  end


end