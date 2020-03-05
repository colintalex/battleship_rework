class Cell
  attr_reader :coordinate, :ship
  def initialize(coordinate)
    @coordinate = coordinate
    @ship = nil
    @fired_on = false
  end

  def empty?
    @ship == nil
  end

  def place_ship(ship)
    @ship = ship
  end

  def fire_upon
      @fired_on = true
      @ship.hit if !empty?
  end

  def fired_upon?
    @fired_on
  end

  def render(show_ship = false)

    if fired_upon? == true && empty? == true
      "M"
    elsif fired_upon? == true && empty? == false && @ship.sunk? == false
      "H"
    elsif fired_upon? == true && empty? == false && @ship.sunk?
      "X"
    elsif fired_upon? == false && show_ship == true && empty? == false
      "S"
    elsif fired_upon? == false
      "."
    end
  end
end
