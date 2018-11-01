class Parser
  class Cell
    def initialize(raw_content, column)
      @raw_content = raw_content
      @column = column
    end

    def column_width
      @column.width
    end

    def content
      @content ||= [*converter.convert]
    end

    def increase_column_width_if_needed
      @column.increase_width_if_needed(column_size)
    end

    def right_aligned?
      @right_aligned ||= @column.right_aligned?
    end

    def internal_rows_size
      @internal_rows_size ||= content.size
    end

    def column_size
      @column_size ||= content.max_by(&:size).size
    end

    private

    def converter
      @converter ||= RawToFormattedCellConverter.new(@raw_content, @column.type)
    end
  end
end
