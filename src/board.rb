class Board

  DIRECTION_MATRIX = [
      [1, 0],
      [-1, 0],
      [0, 1],
      [0, -1],
      [1, 1],
      [-1, -1],
      [-1, 1],
      [1, -1]
  ]

  # @param [Integer] num_columns
  # @param [Integer] num_cells
  def initialize(num_columns, num_cells)
    @num_columns = num_columns
    @num_cells = num_cells
    @board = num_columns.times.map {[]}
  end

  def to_s
    out = ['-' * (@num_columns * 2 + 3)]
    @num_cells.times do |row|
      line = '| '
      @num_columns.times do |col|
        line << '%s ' % (@board[col][@num_cells - row - 1] || ' ')
      end
      line << '|'
      out << line
    end
    out << '-' * (@num_columns * 2 + 3)
    out << '  %s' % @num_columns.times.map {|i| '%d ' % i}.join
    out.join("\n")
  end

  # @param [Integer] column_index
  # @param [String] player_symbol
  def move(column_index, player_symbol)
    raise RangeError.new('Column index should be from %d to %d' % [0, @num_columns - 1]) if column_index > @num_columns - 1
    raise RangeError.new('Column #%d is full' % column_index) unless @board[column_index].length < @num_cells
    @board[column_index] << player_symbol
  end

  # @param [Integer] column_index
  def cancel_move(column_index)
    @board[column_index].pop
  end

  def available_moves
    @num_columns.times.select {|col| @board[col].count < @num_cells}
  end


  # @param [Integer] col
  # @param [Integer] num
  def detect_winner(col, num)
    row = @board[col].count - 1
    sym = @board[col][row]

    helper = lambda do |_dir, _dir_id, _offset, _idx|
      col_offset = DIRECTION_MATRIX[_dir_id * 2 + _offset][0] * _idx
      row_offset = DIRECTION_MATRIX[_dir_id * 2 + _offset][1] * _idx
      if !_dir[_offset].frozen? && col + col_offset >= 0 && row + row_offset >= 0 && @board[col + col_offset]
        if @board[col + col_offset][row + row_offset] == sym
          _dir[_offset][0] += 1
        else
          _dir[_offset].freeze
        end
      end
    end

    ret = num.times.inject(4.times.map {[[0], [0]]}) do |c, idx|
      idx += 1
      c.each_with_index.map do |dir, dir_id|
        helper.(dir, dir_id, 0, idx)
        helper.(dir, dir_id, 1, idx)
        dir
      end
    end
    ret.any? {|el| el[0][0] + el[1][0] >= num - 1}
  end

end