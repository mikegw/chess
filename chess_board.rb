def vect_add(vect1, vect2)
  [vect1[0] + vect2[0], vect1[1] + vect2[1]]
end

class ChessBoard
  def initialize
    @rows = Array.new(8) {Array.new(8)}
    fill_royal_court(:white, 0)
    fill_pawns(:white, 1)
    fill_pawns(:black, 6)
    fill_royal_court(:black, 7)
  end

  def fill_royal_court(color, row_idx)
    self[[row_idx, 0]] = Rook.new(color)
    self[[row_idx, 1]] = Knight.new(color)
    self[[row_idx, 2]] = Bishop.new(color)
    self[[row_idx, 3]] = Queen.new(color)
    self[[row_idx, 4]] = King.new(color)
    self[[row_idx, 5]] = Bishop.new(color)
    self[[row_idx, 6]] = Knight.new(color)
    self[[row_idx, 7]] = Rook.new(color)
  end

  def fill_pawns(color, row_idx)
    8.times { |col_idx| self[[row_idx, col_idx]] = Pawn.new(color) }
  end

  def apply_move(move)
    new_board = self.dup
    new_board.apply_move!(move)

    new_board
  end

  def [](pos)
    row, col = pos
    @rows[row][col]
  end

  def piece_at?(pos)
    !self[pos].nil?
  end

  def each_piece(&prc)
    pieces = self.rows.flatten.each {|piece| prc.call(piece)}
    pieces.select(&:nil?)
  end

  def each_pos(&prc)
    8.times do |rank|
      8.times do |file|
        prc.call([rank, file])
      end
    end
  end


  def to_s
    render
  end

  def inspect
    render
  end

  def render
    @rows.map do |row|
      row.map { |piece| piece || " " }.join
    end.reverse.join("\n")
  end

  def over?(color_to_move)
    # TO DO
    false
  end

  def dup
    new_board = ChessBoard.new
    new_board.rows = self.rows.map(&:dup)
    new_board
  end


  def []=(pos, piece)
    row, col = pos
    @rows[row][col] = piece
  end

  protected
  attr_accessor :rows

  def apply_move!(move)
    raise InvalidMoveError unless move.is_valid_move?
    self[move.end_pos], self[move.start_pos] = self[move.start_pos], nil
  end
end