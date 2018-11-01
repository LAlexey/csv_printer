class Parser
  class Table
    def initialize
      @row_index = 0
    end

    def each_row
      rows.each do |row|
        yield(row)
      end
    end

    def init_columns(column_types)
      @columns = column_types.map { |column_type| Column.new(column_type) }
    end

    def add_row(raw_cells)
      cells = raw_cells.map.with_index { |raw_cell, i| Cell.new(raw_cell, @columns[i]) }
      rows << Row.new(cells, @row_index += 1)

      cells.each(&:increase_column_width_if_needed)
    end

    def rows_count
      rows.count
    end

    def columns
      @columns ||= []
    end

    private

    def rows
      @rows ||= []
    end
  end
end

require_relative 'column'
require_relative 'row'
require_relative 'cell'
require_relative 'raw_to_formatted_cell_converter'
