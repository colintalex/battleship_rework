require 'bundler/inline'

gemfile true do
 source 'http://rubygems.org'
 gem 'colorize'
end
require 'colorize'
require_relative 'module/screenable'

class Game
  include Screen
  attr_reader :name
  def initialize(player_name)
    @name =  player_name
    @computer_board = nil
    @user_board = nil
    @turns = {}
  end

  def welcome_message
    Screen.clear
    puts "__________ Welcome to BATTLESHIP __________".light_red
    puts "- - Enter p to play. Enter q to quit. - -".green
    puts ">".green
    play_input = $stdin.gets.chomp
    until play_input == "p" || play_input == "q" do
      Screen.clear
      puts "Incorrect entry. Try again!"
      puts "Enter p to play. Enter q to quit."
      play_input = $stdin.gets.chomp
    end
    play_input
  end

  def user_name
    Screen.clear
    puts "Enter player name.\n>".green
    user_input = $stdin.gets.chomp
    Screen.clear
    puts "You entered:  #{user_input}. Is this correct? (y/n)\n>".green
    name_input = $stdin.gets.chomp
    user_name if name_input != "y"
    @name = user_input if name_input == "y"
  end

  def exit_game
    Screen.clear
    p "Goodbye!"
    exit
  end

  def start_game
    user_name
    board_size
    place_computer_ships(create_ships)
    place_human_ships(create_ships)
    render_boards
    puts "Ready to play?"
    puts "PS: I always go first. Not because I have to.\n Because I can."
    puts "Hit ENTER to start!"
    puts ">"
    input = gets.chomp
    if input != nil
      play_game
    end
  end

  def play_game
    Screen.clear
    turn_count = 0
    until game_over?
      turn_count += 1
      render_boards
      take_turns
      Screen.clear
    end
  end_game
  end

  def take_turns
    puts "My turn!"
    cpu_hit_or_miss = nil
    user_hit_or_miss = nil
    sample = @user_board.cells.keys.sample
    @user_board.cells[sample].fire_upon
    if @user_board.cells[sample].ship != nil
      cpu_hit_or_miss = "hit"
    else
      cpu_hit_or_miss = "miss"
    end
    Screen.clear
    render_boards
    puts "I fired on #{sample} and it was a #{cpu_hit_or_miss}!"

    puts "Your turn."
    puts "Enter the cell you want to fire on:"
    fire_input = gets.chomp.upcase
    until @computer_board.valid_coordinate?(fire_input) do
      puts "Invalid coordinate! Try again."
      fire_input = gets.chomp.upcase
    end
    @computer_board.cells.fetch(fire_input).fire_upon
    if @computer_board.cells[fire_input.upcase].ship != nil
      user_hit_or_miss = "hit"
    else
      user_hit_or_miss = "miss"
    end
    Screen.clear
    render_boards
    puts "You shot at #{fire_input.upcase} and it was a #{user_hit_or_miss}!"
  end

  def game_over?
    cpu_ships_afloat.empty? || user_ships_afloat.empty?
  end

  def end_game
    cpu_string = "CPU => Shots:#{cpu_count[:fires]} H:#{cpu_count[:hits]} M: #{cpu_count[:misses]}"
    user_string = "User => Shots:#{user_count[:fires]} H:#{user_count[:hits]} M: #{user_count[:misses]}"
    cpu_percent = "CPU: #{(cpu_count[:hits].to_f.round(2) / cpu_count[:fires]) * 100}%"
    user_percent = "User: #{(user_count[:hits].to_f.round(2) / user_count[:fires]) * 100}%"
    render_boards
    puts "Game over! You win!".light_green if cpu_ships_afloat.empty?
    puts "Game over! I win!".light_green if user_ships_afloat.empty?
    puts "\n====================== GAME STATS ======================\n".green
    puts " #{cpu_string} //// #{user_string}"
    puts " Hit Percentage => CPU: #{cpu_percent} User: #{user_percent}"
    puts "\n========================================================\n".green
    puts "Want to play again? (y/n)".light_green
    input = $stdin.gets.chomp
    start_game if input.downcase == "y"
    exit_game if input.downcase == "n"
  end

  def user_ships_afloat
    cells_with_ships = @user_board.cells.values.find_all do |value|
      value.ship != nil
    end
    cells_with_ships.map {|cell| cell.ship}.uniq
  end

  def cpu_ships_afloat
    cells_with_ships = @computer_board.cells.values.find_all do |value|
      value.ship != nil && value.ship.sunk? == false
    end
    cells_with_ships.map {|cell| cell.ship}.uniq
  end

  def user_count
    fires = @computer_board.cells.values.find_all {|cell| cell.fired_upon?}
    hits = fires.find_all {|cell| cell.ship != nil}
    {hits: hits.count, fires: fires.count, misses: fires.count - hits.count}
  end

  def cpu_count
    fires = @user_board.cells.values.find_all {|cell| cell.fired_upon?}
    hits = fires.find_all {|cell| cell.ship != nil}
    {hits: hits.count, fires: fires.count, misses: fires.count - hits.count}
  end

  def board_size
    Screen.clear
    puts "Let's get started! First we need to decide on board size.".light_magenta
    puts "========== The default board size is 4x4. ==========\n".magenta
    puts "If you want a LARGER board, type 'y' and hit ENTER.\n".light_magenta
    puts "If the default 4x4 works for you, just hit ENTER!".magenta
    user_input = gets.chomp
    if user_input == "y"
      puts "Enter the board height you want:".green
      height = gets.chomp
      puts "Enter the board width you want:".green
      width = gets.chomp
      create_boards(height, width)
      puts "Let's play!".cyan
    elsif user_input != "y"
      create_boards()
      p "Let's play!".cyan
    end
  end

  def create_boards(height = 4, width = 4)
    @user_board = Board.new(height.to_i, width.to_i)
    @computer_board = Board.new(height.to_i, width.to_i)
  end

  def render_boards
    puts "\n==================== COMPUTER BOARD ====================\n".blue
    @computer_board.render
    puts "\n===================== HUMAN BOARD ======================\n".blue
    @user_board.render(true)
    puts "\n........................................................\n".light_blue
    puts "\n Computer ships floating: #{cpu_ships_afloat.count} /// User ships flaoting: #{user_ships_afloat.count}".light_blue
    puts "\n........................................................\n".light_blue
  end

  def place_computer_ships(ships)
    Screen.clear
    ships.each do |ship|
      @computer_board.place(ship, create_coordinates(@computer_board, ship))
    end
    puts "I have now placed all my ships."
    puts "It is now your turn!"
  end

  def place_human_ships(ships)
    @user_board.render(true)
    puts "Do you want to manually place your ships? (y/n)"
    manual_input = $stdin.gets.chomp

    if manual_input == "y"
      puts "Type in the coordinates you want to place your ship. Remember:
        - Number of coordinates must equal ship length.
        - Coordinates must be in consecutive or diagonal order.
        - You can not place a ship where another ship is currently placed.
        - Type your coordinates in now, each pair spaced from the other.
        - Example => a1 a2 a3,    b2 c3 d4,    etc"
      ships.each do |ship|
        puts "This ship is a #{ship.ship_name}, it is #{ship.length} units long."
        puts ">"
        input = gets.chomp.upcase
        until @user_board.valid_placement?(ship, input.split(" "))
          puts "Try again"
          puts ">"
          input = gets.chomp.upcase
        end
        @user_board.place(ship, input.split(" "))
        print "\e[2J\e[f"
        @user_board.render(true)
      end
    elsif manual_input == "n"
      ships.each do |ship|
        coords = create_coordinates(@user_board, ship)
        @user_board.place(ship, coords)
      end
    end
    puts "All finished placing ships."
    puts "You're all set, now let's BATTLE!"
    Screen.clear
  end

  def create_coordinates(board, ship)
    lead = Array.new(ship.length, board.cells.keys.sample())
    option = board.consecutive_coordinates?(lead)[1].sample()
    fits = board.valid_length?(ship, option)
    exists = board.coordinates_exist?(option)
    if fits && exists
      return option
    else
      create_coordinates(board, ship)
    end
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
end
