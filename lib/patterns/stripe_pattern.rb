# frozen_string_literal: true
class StripePattern < Pattern

  attr_reader :color1, :color2

  def initialize(color1, color2, transform: MyMatrix.identity)
    super(transform: transform)
    @color1 = color1
    @color2 = color2
  end

  def pattern_at(local_point)
    local_point.x % 2 < 1 ? @color1 : @color2
  end

  def ==(other)
    other.class == self.class &&
      other.color1 == color1 &&
      other.color2 == color2 &&
      other.transform == transform
  end

  alias eql? ==

  def hash
    [color1, color2, transform].hash
  end

end