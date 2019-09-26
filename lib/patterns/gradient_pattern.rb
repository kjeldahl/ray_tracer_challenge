class GradientPattern < Pattern

  attr_reader :color1, :color2

  def initialize(color1, color2, transform: MyMatrix.identity)
    super(transform: transform)
    @color1 = color1
    @color2 = color2
  end

  def pattern_at(pattern_point)
    @color1 + (@color2 - @color1) * (pattern_point.x - pattern_point.x.floor)
  end
end