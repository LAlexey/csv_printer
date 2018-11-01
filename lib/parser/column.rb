class Parser::Column
  attr_accessor :width
  attr_reader :type

  AVAILABLE_TYPES = %i[int string money]
  RIGHT_ALIGNED_TYPES = %i[int money]

  def initialize(type)
    raise 'Unknown type' unless AVAILABLE_TYPES.include?(type)

    @type = type
  end

  def right_aligned?
    @right_aligned ||= RIGHT_ALIGNED_TYPES.include?(type)
  end

  def increase_width_if_needed(cell_width)
    self.width = [width.to_i, cell_width].max
  end
end
