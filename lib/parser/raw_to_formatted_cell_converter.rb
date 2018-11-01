class Parser::RawToFormattedCellConverter
  DELIMITED_REGEX = /(\d)(?=(\d\d\d)+(?!\d))/

  def initialize(raw_content, type)
    @raw_content = raw_content
    @type = type
  end

  def convert
    case @type
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
  end
end
