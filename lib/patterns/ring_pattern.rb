class RingPattern < Pattern

  attr_reader :color1, :color2

  def initialize(color1, color2, transform: MyMatrix.identity)
    super(transform: transform)
    @color1 = color1
    @color2 = color2
  end

  def pattern_at(pattern_point)
    Math.sqrt(pattern_point.x**2 + pattern_point.z**2) % 2 < 1 ? @color1 : @color2
  end
end