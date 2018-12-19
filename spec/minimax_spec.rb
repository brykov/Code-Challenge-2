require_relative 'spec_helper'
require_relative '../src/game'
require_relative '../src/../src/strategies/minimax'

RSpec.describe Strategies::Minimax do
  it 'works' do
    game = Game.new(3, 3, 3, Game::COMPUTER_PLAYER_STRATEGY_MINIMAX)

    game.board.move(1, 'X')
    game.board.move(2, 'O')
    game.board.move(1, 'X')

    expect(Strategies::Minimax.perform(game)).to eq 1
  end
end