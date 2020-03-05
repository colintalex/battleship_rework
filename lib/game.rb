class Game
  attr_reader :name
  def initialize(player_name)
    @name =  player_name
  end

  def welcome_loop
    user_input = nil
    while user_input == nil
    puts "Welcome #{name}, to BATTLESHIP"
    puts "Enter p to play. Enter q to quit."
    user_input = gets.chomp
    end
  end

  def start_game

  end
end
