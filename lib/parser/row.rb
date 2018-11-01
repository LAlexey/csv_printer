class Parser::Row
  attr_reader :line

  def initialize(cells, line)
    @cells = cells
    @line = line
  end

  def each_cell(&block)
    @cells.each(&block)
  end

  def map_cells(&block)
    @cells.map(&block)
  end

  def size
    @cells.map(&:column_width).sum
  end

  def cells_count
    @cells.count
  end

  def internal_height
    @internal_height ||= @cells.max_by(&:internal_rows_size).internal_rows_size
  end
end
