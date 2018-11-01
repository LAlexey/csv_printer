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
      @content ||= [*RawToFormattedCellConverter.new(@raw_content, @column.type).convert]
    end

    def increase_column_width_if_needed
      @column.increase_width_if_needed(column_size)
    end

    def right_aligned?
      @right_aligned ||= @column.right_aligned?
    end

    def internal_rows_size
      @internal_rows_size ||= content.is_a?(Array) ? content.size : 1
    end

    def column_size
      @column_size ||= content.is_a?(Array) ? content.max_by(&:size).size : content.size
    end
  end
end
