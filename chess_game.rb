require_relative 'new_chess_player'
require_relative 'chess_move'
require_relative 'chess_board'
require_relative 'chess_piece'

class ChessGame
  PLAYERS = [:white, :black]

  def self.color_str(color)
    color.to_s.capitalize
  end

  def initialize
    @board = ChessBoard.new
    @players = { :white => ChessPlayer.new, :black => ChessPlayer.new}
    @color_to_move = :white
    @display_messages = ["Welcome to chess"]
  end

  def play
    begin_game

    until over?
      system('clear')
      display
      move_happens
      switch_players
    end

    end_game
  end

  private

  def display
    display_board
    puts @display_messages
  end


  def display_board
    puts @board
  end

  def move_happens
    puts "It's #{ChessGame.color_str(@color_to_move)}'s turn. Maybe he'll surprise us. But probably not."
    begin
      move = @players[@color_to_move].get_move(@board, @color_to_move)
      @board = @board.apply_move(move)

      piece_taken = move.piece_to_take if move.takes_piece?
      @display_messages = []
      if piece_taken
        @display_messages <<  "#{ChessGame.color_str(@color_to_move)} took a #{piece_taken.class.name}."
        @display_messages <<  "#{ChessGame.color_str(other_player_color)} better get their act together..."
      end

    rescue InvalidMoveError
      handle_invalid_move
      retry
    end
  end

  def switch_players
    @color_to_move = other_player_color
  end

  def over?
    @board.over?(@color_to_move)
  end

  def begin_game
  end


  def end_game
    congratulate(winning_color)
    display_board
  end

  def congratulate(color)
    if color.nil?
      display_messages <<  "A stalemate. You're both losers really."
      display_messages <<  "How boring..."
    else
      display_messages <<  "#{ChessGame.color_str(color)} wins. Maybe he does have a brain-cell or two."
      display_messages <<  "#{ChessGame.color_str(other_player_color)} certainly doesn't..."
    end
  end

  def other_player_color
    @color_to_move == :white ? :black : :white
  end


  def handle_invalid_move
    puts "You can't move there! Do you even know how to play this game?!"
  end
end


if __FILE__ == $PROGRAM_NAME
  game = ChessGame.new
  game.play
end