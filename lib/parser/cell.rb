class Parser::Cell
  DELIMITED_REGEX = /(\d)(?=(\d\d\d)+(?!\d))/
  RIGHT_ALIGNED_TYPES = %i[int money]

  def initialize(raw_content, column)
    @raw_content = raw_content
    @column = column
  end

  def type
    @column.type
  end

  def column_width
    @column.width
  end

  def content
    @content ||= begin
      result = case type
               when :string
                 @raw_content.split(/\W/)
               when :money
                 left, right = @raw_content.to_s.split('.')
                 left.gsub!(DELIMITED_REGEX) do |digit_to_delimit|
                   "#{digit_to_delimit} "
                 end
                 right = right[0..1] if right
                 [left, right].compact.join(',')
               else
                 @raw_content
               end
      [*result]
    end
  end

  def increase_column_width_if_needed
    @column.increase_width_if_needed(column_size)
  end

  def right_aligned?
    @right_aligned ||= RIGHT_ALIGNED_TYPES.include?(type)
  end

  def internal_rows_size
    @internal_rows_size ||= content.is_a?(Array) ? content.size : 1
  end

  def column_size
    @column_size ||= content.is_a?(Array) ? content.max_by(&:size).size : content.size
  end
end
