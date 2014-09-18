require_relative "chess_board"

class ChessMove
  attr_reader :start_pos, :end_pos, :color, :board

  def initialize(board, color, piece_type, start_pos, end_pos)
    @board = board
    @color, @piece_type = color, piece_type
    @start_pos, @end_pos = start_pos, end_pos
  end


  #------Top-level logic------#

  def board_after_move
    new_board = @board.dup
    new_board[end_pos], new_board[start_pos] = @board[start_pos].dup, nil
    new_board[end_pos].moved = true

    if attempting_castle_move?
      new_board[rook_castling_end_pos] = @board[rook_castling_start_pos].dup
      new_board[rook_castling_start_pos] = nil
      new_board[rook_castling_end_pos].moved = true
    end

    new_board[pos_of_pawn_passed] = nil if en_passant?
    new_board.en_passant = new_board_en_passant

    new_board
  end

  def is_valid_move?
    has_valid_piece? && end_pos_accessible? && valid_move_vect?
  end

  def is_valid_threat_for_check?
    has_valid_piece? && path_clear? && valid_aggressive_move_vect?
  end


  #------There is an appropriate piece to move at start_pos------#

  def has_valid_piece?
    piece_to_move && right_piece_type? && right_piece_color?
  end

  def right_piece_type?
    piece_to_move.piece_type == @piece_type
  end

  def right_piece_color?
    piece_to_move.color == @color
  end


  #------End_pos accessible?------#

  def end_pos_accessible?
    !taking_own_piece? && !moves_into_check? && path_clear?
  end

  def taking_own_piece?
    @board[end_pos] && @board[end_pos].color == @color
  end

  def moves_into_check?
    board_after_move.in_check?(color)
  end

  def path_clear?
    (1...num_steps).all? do |step|
      @board[partial_slide(step)].nil?
    end
  end


  #------Piece can make that move (assuming empty board)------#

  def valid_move_vect?
    valid_passive_move_vect? || valid_aggressive_move_vect?
  end

  def valid_passive_move_vect?
    ( piece_to_move.has_move_vect?(move_vect) && !@board.piece_at?(end_pos) ) ||
    ( attempting_castle_move? && valid_castle_move? )
  end

  def valid_aggressive_move_vect?
    piece_to_move.has_take_vect?(move_vect) &&
      (@board.piece_at?(end_pos) || en_passant?)
  end


  #------En passant------#

  def en_passant?
    @piece_type == :pawn && @board.en_passant == end_pos
  end

  def allows_en_passant_next_move?
    @piece_type == :pawn && move_vect[0].abs == 2
  end

  def pos_pawn_moves_through
    allows_en_passant_next_move? ? [(start_pos[0] + end_pos[0]) / 2, start_pos[1]] : nil
  end

  def new_board_en_passant
    allows_en_passant_next_move? ? pos_pawn_moves_through : nil
  end

  def pos_of_pawn_passed
    [end_pos[0] == 2 ? 3 : 4, end_pos[1]]
  end


  #------Castling------#

  def attempting_castle_move?
    @piece_type == :king && move_vect[1].abs == 2
  end

  def valid_castle_move?
    attempting_castle_move? && !king_moved? && !rook_moved? &&
      rook_castling_move.path_clear? && king_path_safe?
  end

  def king_moved?
    @board.piece_at(start_pos).moved?
  end

  def rook_moved?
    rook_to_move && rook_to_move.moved?
  end

  def rook_castling_start_pos
    [self.start_pos[0], ( self.end_pos[1] == 2 ? 0 : 7 )]
  end

  def rook_castling_end_pos
    [self.start_pos[0], ( self.end_pos[1] == 2 ? 3 : 5 )]
  end

  def rook_to_move
    @board.piece_at(rook_castling_start_pos)
  end

  def rook_castling_move
    ChessMove.new(@board, @color, :rook, rook_castling_start_pos, rook_castling_end_pos)
  end

  def king_path_safe?
    (1..num_steps).to_a.reverse.all? do |step|
      !ChessMove.new(@board, @color, :king, self.start_pos, partial_slide(step)).moves_into_check?
    end
  end


  #------Basic move info and operations------#

  def partial_slide(step)
    [start_pos[0] + move_dir[0] * step, start_pos[1] + move_dir[1] * step]
  end


  def takes_piece?
    @board[end_pos] || en_passant?
  end

  def piece_to_move
    @board[@start_pos]
  end

  def piece_to_take
    if @board[@end_pos] && @board[end_pos].color != @color
      @board[@end_pos]
    end
  end


  def promotes_pawn?
    @piece_type == :pawn && @end_pos[0] == promoted_pawn_rank
  end

  def promoted_pawn_file
    @end_pos[1]
  end

  def promoted_pawn_rank
    @color == :white ? 7 : 0
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
end


class InvalidMoveError < StandardError
end