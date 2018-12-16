require_relative 'board'
class Game
  COMPUTER_PLAYER_STRATEGY_RANDOM = 'Random'
  COMPUTER_PLAYER_STRATEGY_MINIMAX = 'Minimax'

  attr_reader :board, :win_num

  # @param [Integer] board_num_columns
  # @param [Integer] board_num_cells
  # @param [Integer] win_num
  # @param [Strategies::Base] computer_player_strategy
  def initialize(board_num_columns, board_num_cells, win_num, computer_player_strategy)
    # @type [Board]
    @board = Board.new(board_num_columns, board_num_cells)

    @win_num = win_num

    require_relative 'strategies/' + computer_player_strategy.downcase
    @computer_strategy = Object.const_get('Strategies::' + computer_player_strategy)

    @players_turn = true
  end

  def run
    prompt = TTY::Prompt.new
    puts @board.to_s
    loop do
      available_moves = @board.available_moves
      if available_moves.none?
        puts 'No available moves left. Quitting.'
        exit
      end
      if @players_turn
        move = prompt.select('Make a move', Hash[available_moves.map{ |i| [i.to_s, i] }])
        @board.move(move, 'X')
        @players_turn = false
      else
        move = @computer_strategy.perform(self)
        @board.move(move, 'O')
        @players_turn = true
      end

      puts @board.to_s
      winner = @board.detect_winner(move, @win_num)
      if winner
        puts ({false => 'You win!', true => 'You lose!'})[@players_turn]
        exit
      end
    end
  end



end