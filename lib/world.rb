require 'intersections'

# NOTE: This class is not immutable
class World
  attr_accessor :light

  def initialize(light: nil)
    @light = light
    @objects = []
  end

  def objects
    @objects
  end

  def intersect(ray)
    intersections = @objects.flat_map { |o| o.intersect(ray).to_a }
    if intersections.empty?
      Intersections.empty
    else
      Intersections.new(*intersections)
    end
  end
end