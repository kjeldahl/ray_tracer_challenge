# frozen_string_literal: true

require 'tuple'

class Ray

  attr_reader :origin, :direction

  def initialize(origin, direction)
    @origin = origin
    @direction = direction
  end

  def position(t)
    @origin + @direction * t
  end

  def transform(transformation)
    transformed = transformation * [@origin, @direction]
    Ray.new(transformed[0], transformed[1])
    # Ray.new(transformation * @origin, transformation * @direction)
  end
end