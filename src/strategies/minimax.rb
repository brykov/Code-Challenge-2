require_relative 'base'
module Strategies
  class Minimax < Strategies::Base

    # @param [Game] game
    def self.perform(game)
      self.minimax(game, true, 7)[0]
    end

    private

    # @param [Game] game
    # @param [Boolean] max_player
    # @param [Integer] depth
    # @param [Integer] last_move
    def self.minimax(game, max_player, depth, last_move = nil)
      return [last_move, 0] if depth == 0

      if last_move && game.board.detect_winner(last_move, game.win_num)
        return [last_move, max_player ? -depth : depth]
      end

      moves = game.board.available_moves

      return [last_move, 0] if moves.none?

      moves.map! do |move|
        game.board.move(move, max_player ? 'O' : 'X')
        score = self.minimax(game, !max_player, depth - 1, move)[1]
        game.board.cancel_move(move)
        [move, score]
      end
      moves.sort_by{rand}.send(max_player ? :max_by : :min_by) do |move|
        move[1]
      end
    end
  end
end
