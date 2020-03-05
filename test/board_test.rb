require './test/test_helper'

class BoardTest < Minitest::Test

  def setup
    @board = Board.new
  end

  def test_it_exists
    assert_instance_of Board, @board
  end

  def test_it_has_attributes
    expected = {}
    assert_equal expected, @board.cells
  end

  def test_it_create_cells_4_x_4_default
    expected = {}
    @board.assemble_cells
    assert_instance_of Cell, @board.cells["A1"]
    assert_equal 4, @board.cells.keys.length
    assert_equal 4, @board.cells.values.length
  end

  def test_custom_board_size
    @board_1 = Board.new(10,10)
    @board_1.assemble_cells
    assert_instance_of Cell, @board_1.cells["A1"]
    assert_equal 10, @board_1.cells.keys.length
    assert_equal 10, @board_1.cells.values.length
  end
end
