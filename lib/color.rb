# frozen_string_literal: true

class Color
  attr_reader :red, :green, :blue

  def initialize(red, green, blue)
    @red = red
    @green = green
    @blue = blue
  end

  def +(other)
    case other
      when Color
        Color.new(red + other.red,
                  green + other.green,
                  blue + other.blue)
      when Numeric
        Color.new(red + other,
                  green + other,
                  blue + other)
      else
        raise "Cannot add #{other} to color"
    end
  end

  def -(other)
    case other
      when Color
        Color.new(red - other.red,
                  green - other.green,
                  blue - other.blue)
      when Numeric
        Color.new(red - other,
                  green - other,
                  blue - other)
      else
        raise "Cannot add #{other} to color"
    end
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
    round = 2
    other.class == self.class &&
      other.red.round(round) == red.round(round) &&
      other.green.round(round) == green.round(round) &&
      other.blue.round(round) == blue.round(round)
  end

  alias eql? ==

  def hash
    @hash ||= [red, green, blue].hash
  end

  WHITE  = Color.new(1.0, 1.0, 1.0)
  BLACK  = Color.new(0.0, 0.0, 0.0)
  RED    = Color.new(1.0, 0.0, 0.0)
  GREEN  = Color.new(0.0, 1.0, 0.0)
  BLUE   = Color.new(0.0, 0.0, 1.0)
  YELLOW  = RED + GREEN
  MAGENTA = RED + BLUE
  CYAN    = GREEN + BLUE

end
