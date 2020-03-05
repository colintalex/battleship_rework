require './test/test_helper'

class BoardTest < Minitest::Test

  def setup
    @board = Board.new
    @cruiser = Ship.new("Cruiser", 3)
    @submarine = Ship.new("Submarine", 2)
  end

  def test_it_exists
    assert_instance_of Board, @board
  end

  def test_it_has_attributes
    assert_instance_of Hash, @board.cells
  end

  def test_it_create_cells_4_x_4_default
    expected = {}
    assert_instance_of Cell, @board.cells["A1"]
    assert_instance_of Cell, @board.cells["A2"]
    assert_instance_of Cell, @board.cells["B1"]
    assert_instance_of Cell, @board.cells["D4"]
    expected = ["A1", "A2", "A3", "A4", "B1", "B2", "B3", "B4",
                "C1", "C2", "C3", "C4", "D1",  "D2", "D3", "D4"]
    assert_equal expected, @board.cells.keys
  end

  def test_custom_board_size
    @board_1 = Board.new(10,10)
    assert_instance_of Cell, @board_1.cells["A1"]
    assert_equal 100, @board_1.cells.keys.length
    assert_equal 100, @board_1.cells.values.length
  end

  def test_valid_coordinates
    assert @board.valid_coordinate?("A1")
    assert @board.valid_coordinate?("D4")
    refute @board.valid_coordinate?("A5")
    refute @board.valid_coordinate?("A5")
    refute @board.valid_coordinate?("A22")
  end

  def test_valid_placement_coords_match_ship_length
    refute @board.valid_placement?(@cruiser, ["A1", "A2"])
    refute @board.valid_placement?(@submarine, ["A2", "A3", "A4"])
  end

  def test_consecutive_placement
    refute @board.valid_placement?(@cruiser, ["A1", "A2", "A4"])
    refute @board.valid_placement?(@cruiser, ["A1", "A2", "A4"])
    refute @board.valid_placement?(@submarine, ["A1", "C1"])
    refute @board.valid_placement?(@submarine, ["C1", "B1"])
    assert @board.valid_placement?(@submarine, ["A1", "A2"])
    assert @board.valid_placement?(@cruiser, ["B1", "C1", "D1"])
  end

  def test_placing_ships
    @board.place(@cruiser, ["A1", "A2", "A3"])
    @cell_1 = @board.cells["A1"]
    @cell_2 = @board.cells["A2"]
    @cell_3 = @board.cells["A3"]
    assert_equal @cruiser, @cell_1.ship
    assert_equal @cruiser, @cell_2.ship
    assert_equal @cruiser, @cell_3.ship
    assert_equal @cell_2.ship, @cell_3.ship
  end
end
