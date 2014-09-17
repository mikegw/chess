class ChessPlayer

  def get_move(board, color_playing_as)
    puts "It's your turn, #{color}! Hurry up already..."
    ChessMoveParser.new(gets.chomp, board, color_playing_as).parse
  end

end
