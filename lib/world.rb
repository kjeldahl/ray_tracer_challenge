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

  def shade_hit(intersection_values)
    PhongLighting.lighting(intersection_values.object.material, @light, intersection_values.point, intersection_values.eye_vector, intersection_values.normal)
  end
end