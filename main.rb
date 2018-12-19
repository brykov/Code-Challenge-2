require_relative 'src/game'
require 'tty/prompt'
prompt = TTY::Prompt.new
strategy = prompt.select('Choose computer player strategy', [
    Game::COMPUTER_PLAYER_STRATEGY_RANDOM,
    Game::COMPUTER_PLAYER_STRATEGY_MINIMAX
])

game = Game.new(3, 3, 3, strategy)

game.run