class ChessPlayer

  FILES = ('a'..'h').to_a
  RANKS = (1..8).to_a.map(&:to_s)
  ROYAL_COURT = {
    "K" => :king,
    "Q" => :queen,
    "R" => :rook,
    "B" => :bishop,
    "N" => :knight
  }

  def self.parse(str, board, color)

    if ROYAL_COURT.include?(str[0])
      #they're moving a royal
      piece_type = ROYAL_COURT[str[0]]
      str = str[1..-1]
    else
      piece_type = :pawn
      str = str[1..-1] if str.length > 2 # to account for exd4
    end

    #let the move class deal with aggressive or passive move
    str = str[1..-1] if str[0] == 'x'

    end_pos = parse_pos(str[-2..-1])
    move_candidates = []

    #find move candidates
    board.each_pos do |pos|
      #p pos
      next unless board[pos]
      next unless valid_piece?(board, pos, piece_type, str)
      test_move = ChessMove.new(board, color, piece_type, pos, end_pos)
      move_candidates << test_move  if test_move.is_valid_move?
    end
    raise InvalidMoveError unless move_candidates.length == 1

    move_candidates[0]
  end

  def self.parse_pos(pos_str)
    raise InvalidMoveError unless rank_of(pos_str) && file_of(pos_str)
    [rank_of(pos_str), file_of(pos_str)]
  end

  def self.valid_piece?(board, pos, piece_type, str)
    test_piece = board[pos]
    test_piece && test_piece.piece_type == piece_type && correct_line(pos, str)
  end

  def self.correct_line(pos, str)
    case str.length
    when 2
      return true
    when 3
      return line_specified(str, pos)
    when 4
      return parse_pos(str) == pos
    else
      raise InvalidMoveError
    end
  end

  def self.line_specified(str, pos)
    FILES.include?(str[0]) ? file_of(str) == pos[0] : rank_of(str) == pos[1]
  end

  def self.file_of(pos_str)
    FILES.index(pos_str[-2])
  end

  def self.rank_of(pos_str)
    RANKS.index(pos_str[-1])
  end

  def initialize
  end

  def get_move(board, color)
    puts "It's your turn, #{color}! Hurry up already..."
    ChessPlayer.parse(gets.chomp, board, color)
  end

end
