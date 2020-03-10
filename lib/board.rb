require_relative 'cell'

class Board
  attr_reader :cells
  def initialize(height = 4, width = 4)
    @cells = {}
    @rows = ("A".."Z").to_a[0..(height - 1)]
    @columns = (1..26).to_a[0..(width - 1)]
    assemble_cells
  end

  def height
    @rows.length
  end

  def assemble_cells
    coordinates = @rows.product(@columns).map { |char, num| char + num.to_s}
    @cells = coordinates.reduce({}) do |filled_cells, coord|
      filled_cells[coord] = Cell.new(coord)
      filled_cells
    end
  end

  def render(show_ship = false)
    size = @rows.length
    cells = @cells.values.map {|v| v.render(show_ship)}
    if size > 10
      b = "___|_#{@columns[0..8].join("__")}_"
      said = b + "#{@columns[9..(size -1)].join("_")}_=_\n"
      size.times do |step|
        said += "-#{@rows[0 + step]}-| #{cells[0..(size - 1)].join("  ")} |\n"
        @rows.rotate!(size)
        cells.rotate!(size)
      end
    elsif size < 11
      said = "___|_#{@columns.join("_")}_=_\n"
      size.times do |step|
        said += "-#{@rows[0 + step]}-| #{cells[0..(size - 1)].join(" ")} |\n"
        @rows.rotate!(size)
        cells.rotate!(size)
      end
    end

    puts said
  end

  def place(ship, coordinates)
    coordinates.each do |coord|
      @cells[coord].place_ship(ship)
    end
  end

  def valid_coordinate?(coordinate)
    @cells.has_key?(coordinate)
  end

  def valid_placement?(ship, chosen_coordinates)
    exist = coordinates_exist?(chosen_coordinates)
    length = valid_length?(ship, chosen_coordinates)
    consec = consecutive_coordinates?(chosen_coordinates)[0]
    if exist && length & consec
      return true
    else
      false
    end
  end

  def valid_length?(ship, chosen_coordinates)
    if ship.length == chosen_coordinates.length
      true
    else
      false
    end
  end

  def coordinates_exist?(chosen_coordinates)
    chosen_coordinates.all? do |coord|
      valid_coordinate?(coord) && @cells[coord].ship == nil
    end
  end

  def consecutive_coordinates?(chosen_coordinates)
    length = chosen_coordinates.length
    char = chosen_coordinates.first.scan(/\D/).join
    num = chosen_coordinates.first.scan(/\d/).join
    compare = []
    linear_char_set = []
    linear_num_set = []
    ascend_char_set = (char.upcase.."Z").to_a[0..(length - 1)]
    descend_char_set = ("A"..char.upcase).to_a[0..(length - 1)]
    ascend_num_set = (num.."26").to_a[0..(length - 1)]
    descend_num_set = ("1"..num).to_a[0..(length - 1)]
    length.times { |step| linear_char_set << char}
    length.times { |step| linear_num_set << num}
    down = linear_char_set.zip(ascend_num_set).map{|pair|pair.join}
    right = ascend_char_set.zip(linear_num_set).map{|pair|pair.join}
    left = descend_char_set.zip(linear_num_set).map{|pair|pair.join}
    diagonal_dr = ascend_char_set.zip(ascend_num_set).map{|pair|pair.join}
    diagonal_ur = ascend_char_set.zip(descend_num_set.reverse).map{|pair|pair.join}
    diagonal_dl = descend_char_set.reverse.zip(ascend_num_set).map{|pair|pair.join}.reverse
    diagonal_ul = descend_char_set.zip(descend_num_set).map{|pair|pair.join}

    compare << down
    compare << right
    compare << left
    compare << diagonal_dr
    compare << diagonal_dl
    compare << diagonal_ur
    compare << diagonal_ul
    [compare.any?(chosen_coordinates), compare]
  end
end
