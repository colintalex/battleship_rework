require './test/test_helper'

class ShipTest < Minitest::Test

  def setup
    @cruiser = Ship.new("Cruiser", 3)
  end

  def test_it_exists
    assert_instance_of Ship, @cruiser
  end

  def test_it_has_attributes
    assert_equal "Cruiser", @cruiser.ship_name
    assert_equal 3, @cruiser.length
    assert_equal 3, @cruiser.health
  end

  def test_ship_hit
    assert_equal 3, @cruiser.health
    @cruiser.hit
    assert_equal 2, @cruiser.health
  end

  def test_ship_sunk
    assert_equal false, @cruiser.sunk?
    @cruiser.hit
    @cruiser.hit
    assert_equal false, @cruiser.sunk?
    assert_equal 1, @cruiser.health
    @cruiser.hit
    assert_equal true, @cruiser.sunk?
    assert_equal 0, @cruiser.health
  end
end
