module Strategies
  class Base

    # @param [Game] game
    def self.perform(game)
      raise NotImplementedError
    end

  end
end