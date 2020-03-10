require_relative 'game'
require_relative 'cell'
require_relative 'ship'
require_relative 'board'
  @game = Game.new("")
  puts "\n\n\n"
  input = @game.welcome_message
  if input == "p"
    @game.start_game
  elsif input == "q"
    @game.exit_game
  end
