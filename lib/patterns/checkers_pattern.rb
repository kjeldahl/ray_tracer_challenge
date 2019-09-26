class CheckersPattern < Pattern

  attr_reader :color1, :color2

  def initialize(color1, color2, transform: MyMatrix.identity)
    super(transform: transform)
    @color1 = color1
    @color2 = color2
  end

  def pattern_at(pattern_point)
    (pattern_point.x.abs + pattern_point.y.abs + pattern_point.z.abs).floor % 2 == 0 ? @color1 : @color2
  end
end