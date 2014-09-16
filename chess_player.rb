class ChessPlayer

  def self.is_valid_move_string(str)

  end

  def self.parse(move_string, board)
    ##return a move object
  end

  def initialize
  end

  def board_after_move(board, color)
    #only for human
    begin
      move = get_move
      get_moved_board(board, color)
    rescue InvalidMoveError
      handle_invalid_move
      retry
    end
  end

  def get_move(board, color)
    ChessPlayer.parse(get_move_string, board)
  end

  def get_move_string
    puts "It's your turn, #{color}! Hurry up already..."
    move_string = gets.chomp

    raise InvalidMoveError unless is_valid_move_string(move_string)
  end



  def handle_invalid_move
    puts "You can't move there! Do you even know how to play this game?!"
  end

end