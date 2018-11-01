class Parser::Printer
  ANGLE_SYM   = '+'
  ROW_SYM     = '-'
  BORDER_SYM  = '|'

  def initialize(table)
    @table = table
    @row_index = 0
  end

  def print
    @table.each_row do |row|
      render_row(row)
    end
  end

  private

  def render_row(row)
    puts header(row.size) if first_row?

    row.internal_height.times { puts(build_internal_row(row)) }

    puts rows_delimiter

    @row_index += 1
  end

  def build_internal_row(row)
    built_cells = row.map_cells(&method(:build_cell)).join(BORDER_SYM)
    "#{BORDER_SYM}#{built_cells}#{BORDER_SYM}"
  end

  def build_cell(cell)
    current_content = cell.content.shift
    return ' ' * cell.column_width unless current_content

    align_size = cell.column_width - current_content.size
    space_alignment = ' ' * align_size

    if cell.right_aligned?
      "#{space_alignment}#{current_content}"
    else
      "#{current_content}#{space_alignment}"
    end
  end

  def first_row?
    @row_index.zero?
  end

  def header(row_size)
    "#{ANGLE_SYM}#{ROW_SYM*(row_size + @table.columns.count - 1)}#{ANGLE_SYM}"
  end

  def rows_delimiter
    columns_footer = @table.columns.map(&:width).map { |col_width| '-'*col_width }.join(ANGLE_SYM)
    "#{ANGLE_SYM}#{columns_footer}#{ANGLE_SYM}"
  end
end
