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

  def display_board

  end

  def move_happens
    move = @players[@color_to_move].get_move
    @board = @board.apply_move(move)
    piece_taken = move.piece_to_take

    if piece_taken
      #stuff in display
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
    display_board
    congratulate(winning_color)
  end

  def congratulate(color)
  end

  def other_player_color
    @color_to_move == :white ? :black : :white
  end


end