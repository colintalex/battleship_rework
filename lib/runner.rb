require_relative 'game'
require_relative 'cell'
require_relative 'ship'
require_relative 'board'



  @cruiser = Ship.new("Cruiser", 3)
  @submarine = Ship.new("Submarine", 2)
  @game = Game.new("Colin")
  if @game.welcome_message == "p"
    @game.start_game
  elsif @game.welcome_message == "q"
    @game.exit_game
  end
