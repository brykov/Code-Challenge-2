require_relative 'base'

module Strategies
  class Random < Strategies::Base

    # @param [Game] game
    def self.perform(game)
      game.board.available_moves.sample
    end

  end
end
