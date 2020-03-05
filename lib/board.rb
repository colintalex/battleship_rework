require_relative 'cell'

class Board
  attr_reader :cells
  def initialize(height = 4, width = 4)
    @cells = {}
    @height = height - 1
    @width = width - 1
  end

  def assemble_cells
    rows = ("A".."Z").to_a[0..@height]
    columns = (1..26).to_a[0..@width]
    coordinates = rows.zip(columns).map { |coord| coord[0] + coord[1].to_s}
    @cells = coordinates.reduce({}) do |filled_cells, coord|
      filled_cells[coord] = Cell.new(coord)
      filled_cells
    end
  end
end
