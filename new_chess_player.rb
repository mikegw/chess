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
    end_pos = parse_pos(str[-2..-1])
    capturing = str.include?('x')

    raise InvalidMoveError unless capturing == board.piece_at?(end_pos)

    piece_type = ( ROYAL_COURT.include?(str[0]) ? ROYAL_COURT[str[0]] : :pawn )
    pos_info_str = ( str.length > 2 ? str[1..-1].delete('x') : str.delete('x') )

    #let the move class deal with aggressive or passive move


    move_candidates = []

    #find move candidates
    board.each_pos do |test_start_pos|
      #p pos
      next unless board.piece_at?(test_start_pos)
      next unless right_piece_type?(board, piece_type, test_start_pos)
      next unless valid_start_pos?(test_start_pos, pos_info_str)
      test_move = ChessMove.new(board, color, piece_type, test_start_pos, end_pos)
      move_candidates << test_move  if test_move.is_valid_move?
    end
    raise InvalidMoveError unless move_candidates.length == 1

    move_candidates[0]
  end

  def self.parse_pos(pos_str)
    rank, file = RANKS.index(pos_str[0]), FILES.index(pos_str[1])
    raise InvalidMoveError unless rank && file
    [rank_of(pos_str), file_of(pos_str)]
  end

  def self.right_piece_type?(board, piece_type, test_start_pos)
    board[test_start_pos].piece_type == piece_type
  end

  def self.valid_start_pos?(start_pos, pos_info_str)
    case pos_info_str.length
    when 2
      true
    when 3
      start_line_str = pos_info_str[0]
      correct_single_line?(start_line_str, start_pos)
    when 4
      return parse_pos(pos_info_str) == start_pos
    else
      raise InvalidMoveError
    end
  end

  def self.correct_single_line?(str, pos)
    #str is one or two characters, representing a rank or file or whole pos
    FILES.include?(str[0]) ? file_of(str) == pos[0] : rank_of(str) == pos[1]
  end

  def self.file_of(str)
    #str is one or two characters, representing a rank or file or whole pos
    FILES.index(str[0])
  end

  def self.rank_of(str)
    #str is one or two characters, representing a rank or file or whole pos
    RANKS.index(str[-1])
  end

  def check_if_capturing(str)
  end

  def initialize
  end

  def get_move(board, color)
    puts "It's your turn, #{color}! Hurry up already..."
    ChessPlayer.parse(gets.chomp, board, color)
  end

end
