class Game
  attr_reader :name
  def initialize(player_name)
    @name =  player_name
    @computer_board = nil
    @user_board = nil
  end

  def welcome_message
    puts "Welcome #{name}, to BATTLESHIP"
    puts "Enter p to play. Enter q to quit."
    play = gets.chomp
  end

  def exit_game
    p "Goodbye!"
  end

  def start_game
    board_size
    place_computer_ships(create_ships)
  end

  def board_size
    p "Let's get started."
    p "The default board size is 4x4."
    p "If you want a larger board, type 'y' and hit ENTER"
    p "If 4x4 works for you, just hit ENTER!"
    user_input = gets.chomp
    if user_input == "y"
      p "Enter the board height you want:"
      height = gets.chomp
      p "Enter the board width you want:"
      width = gets.chomp
      create_boards(height, width)
      p "Let's play!"
    elsif user_input != "y"
      create_boards()
      p "Let's play!"
    end
  end

  def create_boards(height = 4, width = 4)
    @user_board = Board.new(height.to_i, width.to_i)
    @computer_board = Board.new(height.to_i, width.to_i)
  end

  def place_computer_ships(ships)
    ships.each do |ship|
      @computer_board.place
    end
  end

  def create_coordinates(length)
    
  end

  def create_ships
    ship_count = (@user_board.height / 3)
    ships = []
    ship_count.times do |step|
      ships << Ship.new("Cruiser", 3)
      ships << Ship.new("Submarine", 3)
      if ship_count > 3
        ships << Ship.new("Carrier", 4)
      end
    end
    ships
  end

  # def board_size
  #   p "Let's get started."
  #   p "The default board size is 4x4."
  #   p "If you want a larger board, type 'y' and hit ENTER"
  #   p "If 4x4 works for you, just hit ENTER!"
  #   user_input = gets.chomp
  #   if user_input == "y"
  #     p "Enter the board height you want:"
  #     height = gets.chomp
  #     p "Enter the board width you want:"
  #     width = gets.chomp
  #     @board = Board.new(height.to_i, width.to_i)
  #   elsif user_input != "y"
  #     p "Let's play!"
  #     @board = Board.new
  #   end
  # end
end
