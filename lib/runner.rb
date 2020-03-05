require_relative 'game'
require_relative 'cell'
require_relative 'ship'
require_relative 'board'




@game = Game.new("Colin")
@game.welcome_loop


@board = Board.new(10,10)
@cruiser = Ship.new("Cruiser", 3)
@submarine = Ship.new("Submarine", 2)

@board.place(@cruiser, ["A1", "A2", "A3"])

@board.render

@board.render(show_ship = true)
