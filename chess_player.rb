class ChessPlayer

  def self.parse(str, board, color)
    files = ('a'..'h').to_a
    ranks = (1..8).to_a.map(&:to_s)
    royal_court_pieces = {
      "K" => :king,
      "Q" => :queen,
      "R" => :rook,
      "B" => :bishop,
      "N" => :knight
    }

    other_color = ( color == :white ? :black : :white )

    ##return a move object
    ##to find the start pos, look at where a piece of the other color
    ##of the same type at end pos could move
    case str
    when /^[a-h][1-8]$/ #pawn move
      end_pos = [ranks.index(str[1]), files.index(str[0])]
      args = [other_color, :pawn, end_pos]
      test_board = create_test_board(board, *args)
      valid_test_moves = find_valid_test_moves(test_board, *args)

      move_if_unambiguous(board, valid_test_moves)

    when /^[a-h]x[a-h][1-8](e\.p\.)?$/ #pawn capture move
      end_pos = [ranks.index(str[3]), files.index(str[2])]
      valid_files = [files.index(str[0])]

      test_board = create_test_board(board, other_color, :pawn, end_pos)

      args = [
        test_board, other_color, piece_type, end_pos,
        {capturing: true, valid_files: valid_files}
      ]
      valid_test_moves = find_valid_test_moves(*args)

      move_if_unambiguous(board, valid_test_moves)

    when /^[KQRBN][a-h][1-8]$/ #royal court move (no ambiguity)
      # check royal court pieces (make sure only one)
      piece_type = royal_court_pieces[str[0]]
      end_pos = [ranks.index(str[2]), files.index(str[1])]

      args = [other_color, piece_type, end_pos]
      test_board = create_test_board(board, *args)
      valid_test_moves = find_valid_test_moves(test_board, *args)

      move_if_unambiguous(board, valid_test_moves)

    when /^[KQRBN][a-h][a-h][1-8]$/ #royal court move (no rank ambiguity)
      # check royal court pieces (make sure only one in rank)
      piece_type = royal_court_pieces[str[0]]
      end_pos = [ranks.index(str[3]), files.index(str[2])]
      valid_files = [files.index(str[1])]

      test_board = create_test_board(board, other_color, piece_type, end_pos)

      args = [
        test_board, other_color, piece_type, end_pos, {valid_files: valid_files}
      ]
      valid_test_moves = find_valid_test_moves(*args)

      move_if_unambiguous(board, valid_test_moves)

    when /^[KQRBN][1-8][a-h][1-8]$/ #royal court move (no file ambiguity)
      # check royal court pieces (make sure only one in file)
      piece_type = royal_court_pieces[str[0]]
      end_pos = [ranks.index(str[3]), files.index(str[2])]
      valid_ranks = [ranks.index(str[1])]

      test_board = create_test_board(board, other_color, piece_type, end_pos)

      args = [
        test_board, other_color, piece_type, end_pos, {valid_ranks: valid_ranks}
      ]
      valid_test_moves = find_valid_test_moves(*args)

      move_if_unambiguous(board, valid_test_moves)

    when /^[KQRBN][a-h][1-8][a-h][1-8]$/
      #return move
      piece_type = royal_court_pieces[str[0]]
      start_pos = [ranks.index(str[2]), files.index(str[1])]
      end_pos = [ranks.index(str[4]), files.index(str[3])]

      ChessMove.new(board, color, piece_type, start_pos, end_pos)

    when /^[KQRBN]x[a-h][1-8]$/ # rc capture move (no ambiguity)
      # make sure there's only one
      piece_type = royal_court_pieces[str[0]]
      end_pos = [ranks.index(str[3]), files.index(str[2])]

      args = [other_color, piece_type, end_pos]
      test_board = create_test_board(board, *args)
      valid_test_moves = find_valid_test_moves(test_board, *args)

      move_if_unambiguous(board, valid_test_moves)

    when /^[KQRBN][a-h]x[a-h][1-8]$/ #rc capture move (no rank ambiguity)
      # check royal court pieces (make sure only one in rank)
      piece_type = royal_court_pieces[str[0]]
      end_pos = [ranks.index(str[4]), files.index(str[3])]
      valid_files = [files.index(str[1])]

      test_board = create_test_board(board, other_color, piece_type, end_pos)

      args = [
        test_board, other_color, piece_type, end_pos,
        {valid_files: valid_files, capturing: true}
      ]
      valid_test_moves = find_valid_test_moves(*args)

      move_if_unambiguous(board, valid_test_moves)

    when /^[KQRBN][1-8]x[a-h][1-8]$/ #rc capture move (no file ambiguity)
      # check royal court pieces (make sure only one in file)
      piece_type = royal_court_pieces[str[0]]
      end_pos = [ranks.index(str[4]), files.index(str[3])]
      valid_ranks = [ranks.index(str[1])]

      test_board = create_test_board(board, other_color, piece_type, end_pos)

      args = [
        test_board, other_color, piece_type, end_pos,
        {valid_ranks: valid_ranks, capturing: true}
      ]
      valid_test_moves = find_valid_test_moves(*args)

      move_if_unambiguous(board, valid_test_moves)

    when /^[KQRBN][a-h][1-8]x[a-h][1-8]$/
      #return move
      piece_type = royal_court_pieces[str[0]]
      start_pos = [ranks.index(str[2]), files.index(str[1])]
      end_pos = [ranks.index(str[5]), files.index(str[4])]

      ChessMove.new(board, color, piece_type, start_pos, end_pos)

    else
      raise InvalidMoveError
    end
  end

  def self.create_test_board(board, other_color, piece_type, end_pos)
    test_piece_class = const_get(piece_type.to_s.capitalize)
    test_piece = test_piece_class.new(other_color)

    test_board = board.dup
    test_board[end_pos] = test_piece

    test_board
  end

  def self.find_valid_test_moves(test_board, other_color, piece_type, end_pos, options = {})
    defaults = {
      :capturing => false,
      :valid_ranks => (0..7).to_a,
      :valid_files => (0..7).to_a
    }
    options = defaults.merge(options)
    capturing = options[:capturing]
    valid_ranks = options[:valid_ranks]
    valid_files = options[:valid_files]

    test_piece = test_board[end_pos]


    vects = ( capturing ? test_piece.take_vects : test_piece.move_vects )

    vects.map do |vect|
      args = [test_board, other_color, piece_type, end_pos, vect_add(end_pos, vect)]
      ChessMove.new(*args)
    end.select do |test_move|
      if piece_type == :pawn
        valid_files.include?(test_move.end_pos[0]) &&
          test_board[test_move.end_pos] &&
          test_board[test_move.end_pos].piece_type == piece_type &&
          test_move.path_clear?
      else
        test_move.is_valid_move? &&
          valid_ranks.include?(test_move.end_pos[1]) &&
          valid_files.include?(test_move.end_pos[0]) &&
          test_board[test_move.end_pos] &&
          test_board[test_move.end_pos].piece_type == piece_type
      end
    end


  end

  def self.move_if_unambiguous(board, valid_test_moves)
    p valid_test_moves
    if valid_test_moves.count == 1
      test_move = valid_test_moves.first
      start_pos = test_move.end_pos
      end_pos = test_move.start_pos
      piece_type = test_move.piece_to_move.piece_type
      color = ( test_move.color == :white ) ? :black : :white

      ChessMove.new(board, color, piece_type, start_pos, end_pos)
    else
      raise InvalidMoveError
    end
  end

  def initialize
  end

  def get_move(board, color)
    puts "It's your turn, #{color}! Hurry up already..."
    ChessPlayer.parse(gets.chomp, board, color)
  end

end