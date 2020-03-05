require './test/test_helper'

class CellTest < Minitest::Test

  def setup
    @cell = Cell.new("B4")
    @cruiser = Ship.new("Cruiser", 3)

    @cell_1 = Cell.new("B4")
    @cell_2 = Cell.new("C3")
  end

  def test_it_exists
    assert_instance_of Cell, @cell
  end

  def test_it_has_attributes
    assert_equal "B4", @cell.coordinate
    assert_nil @cell.ship
    assert_equal true, @cell.empty?
    assert_equal false, @cell.fired_upon?
  end

  def test_it_can_place_ship_in_itself
    @cell.place_ship(@cruiser)
    assert_equal @cruiser, @cell.ship
    assert_equal false, @cell.empty?
  end

  def test_it_can_be_fired_on_empty
    assert_equal false, @cell.fired_upon?
    @cell.fire_upon
    assert_equal true, @cell.fired_upon?
  end

  def test_when_fired_on_with_ship_that_damage_is_dealt
    @cell.place_ship(@cruiser)
    assert_equal 3, @cell.ship.health
    @cell.fire_upon
    assert_equal 2, @cell.ship.health
    assert_equal true, @cell.fired_upon?
  end

  def test_render_empty_fired_on
    assert_equal ".", @cell_1.render
    @cell_1.fire_upon
    assert_equal "M", @cell_1.render
  end

  def test_render_show_ship_and_gets_hit
    @cell_2.place_ship(@cruiser)
    assert_equal ".", @cell_2.render
    assert_equal "S", @cell_2.render(true)
    @cell_2.fire_upon
    assert_equal "H", @cell_2.render(true)
    assert_equal "H", @cell_2.render
  end

  def test_render_shows_sunken_ship
    @cell_2.place_ship(@cruiser)
    @cell_2.fire_upon
    @cell_2.fire_upon
    @cell_2.fire_upon
    assert_equal true, @cruiser.sunk?
    assert_equal "X", @cell_2.render
  end
end
