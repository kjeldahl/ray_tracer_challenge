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

    def origin
      @origin ||= Tuple.point(0.0, 0.0, 0.0)
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

  def [](i)
    case i
      when 0; x
      when 1; y
      when 2; z
      when 3; w
      else
      raise "A tuple only has 4 elements"
    end
  end

  # region Vector methods
  def magnitude
    raise unless vector?

    @magnitude ||= Math.sqrt(x**2 + y**2 + z**2 + w**2)
  end

  def normalize
    # PERF: Could be cached
    raise("Not a vector") unless vector?

    Tuple.vector(x / magnitude, y / magnitude, z / magnitude)
  end

  def normal?
    (magnitude - 1).abs < World::EPSILON
  end

  def dot(other)
    raise "Not a vector! self: #{vector?}, other: #{other.vector?}" unless vector? && other.vector?

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

  def reflect(other)
    self - other * 2 * dot(other)
  end
  # endregion
  #
  def point?
    w.eql? 1.0
  end

  def vector?
    w.eql? 0.0
  end

  def to_vector
    Tuple.vector(x, y, z)
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
    Tuple.new(x == 0 ? x : -x,
              y == 0 ? y : -y,
              z == 0 ? z : -z,
              w == 0 ? w : -w)
  end

  def ==(other)
    round = 1
    other.class == self.class &&
      other.x.round(round) == x.round(round) &&
      other.y.round(round) == y.round(round) &&
      other.z.round(round) == z.round(round) &&
      other.w.round(round) == w.round(round)
  end

  alias eql? ==

  def hash
    @hash ||= [x, y, z, w].hash
  end

  def to_s
    "Tuple(#{x}, #{y}, #{z}, #{w})"
  end
end
