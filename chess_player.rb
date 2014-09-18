require_relative 'chess_move_parser'

class ChessPlayer

  def get_move(board, color_playing_as)
    puts "It's your turn, #{color_playing_as}! Hurry up already..."
    ChessMoveParser.new(gets.chomp, board, color_playing_as).parse
  end

  def get_promotion_type
    puts "What sort of piece would you like in place of your pawn? (Q/R/B/N)"
    ChessMoveParser.royal_court(gets[0].upcase)
  end


end
