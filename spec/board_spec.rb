require_relative 'spec_helper'
require_relative '../src/board'

RSpec.describe Board do
  it 'allows to make a move' do
    board = Board.new(2, 2)

    expect {board.move(2, 'X')}.to raise_error(RangeError)

    board.move(0, 'A')
    expect(board.instance_variable_get(:@board)).to eq [%w(A), []]

    board.move(0, 'B')
    expect(board.instance_variable_get(:@board)).to eq [%w(A B), []]

    board.move(1, 'C')
    expect(board.instance_variable_get(:@board)).to eq [%w(A B), %w(C)]

    board.move(1, 'D')
    expect(board.instance_variable_get(:@board)).to eq [%w(A B), %w(C D)]

    expect {board.move(0, 'X')}.to raise_error(RangeError)
  end

  it 'calculates available moves' do
    board = Board.new(3, 3)
    expect(board.available_moves).to eq [0, 1, 2]

    board.move(1, 'X')
    board.move(2, 'O')
    board.move(1, 'X')

    expect(board.available_moves).to eq [0, 1, 2]

    board.move(2, 'O')
    board.move(1, 'X')

    expect(board.available_moves).to eq [0, 2]

  end

  it 'detects horizontal winner' do
    board = Board.new(4, 4)

    board.move(0, 'O')
    board.move(1, 'X')
    board.move(2, 'X')
    board.move(3, 'X')

    expect(board.detect_winner(0, 3)).to be_falsey
    expect(board.detect_winner(1, 3)).to be_truthy
    expect(board.detect_winner(2, 3)).to be_truthy
    expect(board.detect_winner(3, 3)).to be_truthy
    expect(board.detect_winner(2, 4)).to be_falsey
  end

  it 'detects vertical winner' do
    board = Board.new(4, 4)

    board.move(0, 'O')
    board.move(0, 'X')
    board.move(0, 'X')
    board.move(0, 'X')

    expect(board.detect_winner(0, 3)).to be_truthy
    expect(board.detect_winner(0, 4)).to be_falsey
  end

  it 'detects diagonal winner 1' do
    board = Board.new(3, 3)

    board.move(0, 'X')
    board.move(1, 'O')
    board.move(2, 'X')
    board.move(2, 'O')
    board.move(2, 'X')
    board.move(0, 'O')
    board.move(1, 'X')

    expect(board.detect_winner(1, 3)).to be_truthy
    expect(board.detect_winner(2, 3)).to be_truthy
  end

  it 'detects diagonal winner 2' do
    board = Board.new(3, 3)

    board.move(0, 'C')
    board.move(1, 'B')
    board.move(2, 'A')

    board.move(0, 'B')
    board.move(1, 'C')
    board.move(2, 'F')

    board.move(0, 'H')
    board.move(1, 'G')
    board.move(2, 'C')


    expect(board.detect_winner(2, 3)).to be_truthy
  end

  it 'detects diagonal winner 3' do
    board = Board.new(8, 7)

    [%w(X . . O),
     %w(O X . X),
     %w(O O X X),
     %w(O O X X X O)].reverse_each { |row| row.each_with_index {|c, i| board.move(i, c) unless c == '.'}}

    expect(board.detect_winner(0, 4)).to be_truthy
    expect(board.detect_winner(1, 4)).to be_truthy
    expect(board.detect_winner(2, 4)).to be_truthy
  end

  it 'presents itself' do
    board = Board.new(2, 2)

    board.move(0, 'X')
    board.move(1, 'O')
    board.move(1, 'X')
    board.move(0, 'O')

    expect(board.to_s).to eq "-------\n| O X |\n| X O |\n-------\n  0 1 "

  end
end
