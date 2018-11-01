class Parser::Row
  include Enumerable

  attr_reader :line

  def initialize(cells, line)
    @cells = cells
    @line = line
  end

  def each_cell(&block)
    @cells.each(&block)
  end

  def size
    @cells.map(&:column_width).sum
  end

  def cells_count
    @cells.count
  end

  def height
    @height ||= @cells.max_by(&:internal_rows_size).internal_rows_size
  end
end
