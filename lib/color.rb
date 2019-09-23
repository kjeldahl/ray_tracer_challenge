# frozen_string_literal: true

class Color
  attr_reader :red, :green, :blue

  def initialize(red, green, blue)
    @red = red
    @green = green
    @blue = blue
  end

  WHITE = Color.new(1.0, 1.0, 1.0)
  BLACK = Color.new(0.0, 0.0, 0.0)
  RED   = Color.new(1.0, 0.0, 0.0)

  def +(other)
    Color.new(red + other.red,
              green + other.green,
              blue + other.blue)
  end

  def -(other)
    Color.new(red - other.red,
              green - other.green,
              blue - other.blue)
  end

  def *(other)
    case other
    when Numeric
      Color.new(red * other,
                green * other,
                blue * other)
    when Color
      Color.new(red * other.red,
                green * other.green,
                blue * other.blue)
    else
      raise "Cannot multiply Tuple with #{other.class}"
    end
  end

  def ==(other)
    other.class == self.class &&
      other.red.round(4) == red.round(4) &&
      other.green.round(4) == green.round(4) &&
      other.blue.round(4) == blue.round(4)
  end

  alias eql? ==

  def hash
    @hash ||= [red, green, blue].hash
  end

end
