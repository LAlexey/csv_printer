require 'csv'

class BetterParser
  attr_reader :file_path

  def initialize(file_path)
    @file_path = file_path
  end

  def print
    table = []
    row_heights = []
    column_widths = []

    row_index = 0
    CSV.foreach(file_path, headers: true, header_converters: :symbol, converters: converter, col_sep: ';') do |csv|
      row = csv.fields
      row_heights[row_index] = row.max_by { |column| column[2] }[2]

      row.each_with_index { |cell, i| column_widths[i] = [column_widths[i].to_i, cell[3]].max }

      table << row

      row_index += 1
    end

    puts "+#{'-'*(column_widths.sum - 1 + column_widths.size)}+"
    table.each_with_index do |row, row_index|
      height = row_heights[row_index]
      row_string = ""

      height.times do |internal_row_index|
        row_string << "|"

        row.each_with_index do |cell, column_index|
          width = column_widths[column_index]
          header = cell[0]
          if internal_row_index > 0 && header != :string
            row_string << (' '*width)
            row_string << "|"
            next
          end

          value = cell[1]
          if header == :string
            word = value.shift
            row_string << (word + ' '*(width - word.size))
          else
            row_string << (' '*(width - value.size) + value)
          end

          row_string << "|"
        end

        puts row_string
        row_string = ""
      end

      puts "+#{column_widths.map { |w| '-'*w }.join('+')}+"
    end
  end

  DELIMITED_REGEX = /(\d)(?=(\d\d\d)+(?!\d))/
  def converter
    lambda do |value, field_info|
      header = field_info.header

      case header
      when :string
        words = value.split(/\W/)
        rows = words.size
        columns = words.max_by(&:size).size

        [header, words, rows, columns]
      when :money
        left, right = value.to_s.split('.')
        left.gsub!(DELIMITED_REGEX) do |digit_to_delimit|
          "#{digit_to_delimit} "
        end
        right = right[0..1] if right
        formatted = [left, right].compact.join(',')

        [header, formatted, 1, formatted.size]
      else
        [header, value, 1, value.size]
      end
    end
  end
end

BetterParser.new('test_file.csv').print
