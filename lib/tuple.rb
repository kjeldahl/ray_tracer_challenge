# frozen_string_literal: true

class Tuple
  attr_reader :x, :y, :z, :w
  class << self
    def build(x, y, z, w)
      new(Float(x), Float(y), Float(z), Float(w))
    end

    def point(x, y, z)
      new(x, y, z, 1.0)
    end

    def vector(x, y, z)
      new(x, y, z, 0.0)
    end
  end

  def initialize(x, y, z, w)
    @x = x
    @y = y
    @z = z
    @w = w
  end

  # region Vector methods
  def magnitude
    raise unless vector?

    @magnitude ||= Math.sqrt(x**2 + y**2 + z**2 + w**2)
  end

  def normalize
    raise unless vector?

    Tuple.vector(x / magnitude, y / magnitude, z / magnitude)
  end

  def dot(other)
    raise unless vector? && other.vector?

    x * other.x + y * other.y + z * other.z
  end

  def cross(other)
    raise unless vector? && other.vector?

    Tuple.vector(
      y * other.z - z * other.y,
      z * other.x - x * other.z,
      x * other.y - y * other.x
    )
  end

  # endregion
  #
  def point?
    w.eql? 1.0
  end

  def vector?
    w.eql? 0.0
  end

  def +(other)
    Tuple.new(x + other.x,
              y + other.y,
              z + other.z,
              w + other.w)
  end

  def -(other)
    Tuple.new(x - other.x,
              y - other.y,
              z - other.z,
              w - other.w)
  end

  def *(other)
    case other
    when Numeric
      Tuple.new(x * other,
                y * other,
                z * other,
                w * other)
    else
      raise "Cannot multiply Tuple with #{other.class}"
    end
  end

  def /(other)
    case other
    when Numeric
      Tuple.new(x / other,
                y / other,
                z / other,
                w / other)
    else
      raise "Cannot multiply Tuple with #{other.class}"
    end
  end

  def -@
    Tuple.new(-x,
              -y,
              -z,
              -w)
  end

  def ==(other)
    other.class == self.class &&
      other.x == x &&
      other.y == y &&
      other.z == z &&
      other.w == w
  end

  alias eql? ==

  def hash
    @hash ||= [x, y, z, w].hash
  end
end
