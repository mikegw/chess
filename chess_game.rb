require_relative 'chess_piece'
require_relative 'chess_board'
require_relative 'chess_move'

require_relative 'chess_move_parser'
require_relative 'chess_player'


class ChessGame
  PLAYERS = [:white, :black]

  def self.color_str(color)
    color.to_s.capitalize
  end

  def initialize
    @board = ChessBoard.new
    @players = { :white => ChessPlayer.new, :black => ChessPlayer.new}
    @color_to_move = :white
    @next_move_messages = ["Welcome to chess"]
  end

  def play
    begin_game

    until over?
      display
      move_happens
      switch_players
    end

    end_game
  end

  private


  def begin_game
    @next_move_messages << "It looks like you're going to play chess."
    @next_move_messages << "Don't think you'll impress me."
  end


  #------Before each move------#

  def over?
    @board.no_valid_moves?(@color_to_move)
  end

  def display
    system('clear')
    display_board
    puts @next_move_messages
  end

  def display_board
    puts @board
  end


  #------What happens each move------#

  def move_happens
    puts "It's #{ChessGame.color_str(@color_to_move)}'s turn. Maybe you'll surprise us. But probably not."

    move = next_move
    @board = move.board_after_move
    promote_pawn(move) if move.promotes_pawn?

    prepare_next_move_messages(move)
  end

  def next_move
    begin
      next_move = player_to_move.get_move(@board, @color_to_move)
      raise InvalidMoveError unless next_move.is_valid_move?
    rescue InvalidMoveError, ParseError
      handle_invalid_move
      retry
    end

    next_move
  end

  def promote_pawn(move)
    promotion_type = player_to_move.get_promotion_type
    @board[move.end_pos] = sym_to_class(promotion_type).new(@color_to_move)
  end

  def prepare_next_move_messages(move)
    @next_move_messages = []

    if move.takes_piece?
      @next_move_messages <<  "#{ChessGame.color_str(@color_to_move)} took a #{move.piece_to_take.class.name}."
    end

    if @board.in_check?(other_player_color) && !@board.no_valid_moves?(other_player_color)
      @next_move_messages << "Check."
    end

    if move.en_passant?
      @next_move_messages << "En passant."
    end
  end

  def handle_invalid_move
    puts "You can't move there! Do you even know how to play this game?!"
  end


  #------Switching_players------#

  def switch_players
    @color_to_move = other_player_color
  end

  def other_player_color
    @color_to_move == :white ? :black : :white
  end

  def player_to_move
    @players[@color_to_move]
  end


  #------Endgame behavior------#

  def end_game
    checkmate? ? congratulate_winner : end_in_stalemate
    display
  end

  def congratulate_winner
    @next_move_messages <<  "Checkmate."
    @next_move_messages <<  "Maybe #{ChessGame.color_str(other_player_color)} does have a brain-cell or two."
    @next_move_messages <<  "#{ChessGame.color_str(@color_to_move)} certainly doesn't..."
  end

  def checkmate?
    @board.checkmate?(@color_to_move)
  end

  def end_in_stalemate
    @next_move_messages <<  "A stalemate. You're both losers really."
    @next_move_messages <<  "How boring..."
  end
end


#------Run the game! (if running as script)------#

if __FILE__ == $PROGRAM_NAME
  game = ChessGame.new
  game.play
end