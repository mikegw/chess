class ChessMoveParser
  FILES = ('a'..'h').to_a
  RANKS = (1..8).to_a.map(&:to_s)
  ROYAL_COURT = {
    "K" => :king,
    "Q" => :queen,
    "R" => :rook,
    "B" => :bishop,
    "N" => :knight
  }

  def initialize(str, board, color_to_move)
    @str, @board, @color_to_move = str, board, color_to_move
  end

  def parse
    can_parse? ? move_to_return : raise ParsingError
  end

  private

  # Check for ParsingError

  def can_parse?
    valid_capturing_state? && unambiguous? && appropriate_str_length?
  end

  def unambigous?
    move_candidates.length == 1
  end

  def valid_capturing_state?
    (capturing == board.piece_at(end_pos))
  end

  def capturing?
    @str.include?('x')
  end

  def appropriate_str_length?
    start_pos_str.length <= 2
  end

  # Move Candidate

  def move_to_return
    move_candidates[0]
  end

  def move_candidates
    test_moves.select(&:is_valid_move?)
  end

  def test_moves
    test_pieces_with_pos.map do |test_piece, test_start_pos|
      ChessMove.new(@board, @color, piece_type, test_start_pos, end_pos)
    end
  end

  def test_pieces_with_pos
    @board.each_piece_with_pos.select do |test_piece, test_start_pos|
      valid_start_pos?(test_start_pos)
    end
  end

  # Valid Start Pos

  def valid_start_pos?(test_start_pos)
    valid_start_rank(test_start_pos) && valid_start_file(test_start_pos)
  end

  def valid_start_rank(test_start_pos)
    test_start_pos[0] == start_pos_rank if start_pos_rank
  end

  def valid_start_file(test_start_pos)
    test_start_pos[1] == start_pos_file if start_pos_file
  end

  # Parsing Basic Move Info

  def piece_type
    ROYAL_COURT.include?(@str[0]) ? ROYAL_COURT[@str[0]] : :pawn
  end

  def start_pos
    #coordinates possibly nil!
    [start_pos_rank, start_pos_file]
  end

  def end_pos
    [end_pos_rank, end_pos_file]
  end

  def start_pos_rank
    RANKS.index(start_pos_str[-1])
  end

  def start_pos_file
    FILES.index(start_pos_str[0])
  end

  def end_pos_rank
    RANKS.index(end_pos_str[1]])
  end

  def end_pos_file
    FILES.index(end_pos_str[0])
  end

  def start_pos_str
    pos_info_str[0..-3]
  end

  def end_pos_str
    pos_info_str[-2..-1]
  end

  def pos_info_str
    @str.length > 2 ? @str[1..-1].delete('x') : @str.delete('x')
  end
end

class ParsingError < IOError
end