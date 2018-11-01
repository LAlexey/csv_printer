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
    puts "#{ANGLE_SYM}#{ROW_SYM*(row.size + @table.columns.count - 1)}#{ANGLE_SYM}" if first_row?

    row_string = ""
    row.height.times do
      row_string << BORDER_SYM

      row.each_cell do |cell|
        row_string << "#{render_cell(cell)}#{BORDER_SYM}"
      end

      puts row_string
      row_string = ""
    end

    puts "|#{@table.columns.map(&:width).map { |col_width| '-'*col_width }.join(ANGLE_SYM)}|" if last_row?

    @row_index += 1
  end

  def render_cell(cell)
    cell_string = ''
    current_content = cell.content.shift
    if current_content
      if cell.right_aligned?
        cell_string << (' '*(cell.column_width - current_content.size) + current_content)
      else
        cell_string << (current_content + ' '*(cell.column_width - current_content.size))
      end
    else
      cell_string << (' '*cell.column_width)
    end
  end

  def first_row?
    @row_index.zero?
  end

  def last_row?
    @row_index == @table.rows_count - 1
  end
end
