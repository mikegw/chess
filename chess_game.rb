class ChessGame
  PLAYERS = [:white, :black]

  def initialize
    @board = ChessBoard.new
    @players = { :white => ChessPlayer.new, :black => ChessPlayer.new}
    @color_to_move = :white
  end

  def play
    begin_game

    until over?
      display_board
      move_happens
      switch_players
    end

    end_game
  end

  private

  def move_happens
    @board = @players[@color_to_move].make_move(@board, @color_to_move)
  end

  def switch_players
    @color_to_move = other_color
  end

  def over?
    @board.over?(@color_to_move)
  end

  def begin_game

  end


  def end_game
    display_board
    congratulate(winning_color)
  end

  def congratulate(color)
  end

  def other_color
    @color_to_move == :white ? :black : :white
  end


end