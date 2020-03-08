class Ship
  attr_reader :ship_name, :length, :health
  def initialize(ship_name, length)
    @ship_name = ship_name
    @length = length
    @health = length
  end

  def sunk?
    @health == 0
  end

  def hit
    @health -= 1  
  end
end
