require 'intersections'
require 'phong_lighting'

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
    # TODO: Add support for multiple lights. call lighting for each and add colors
    PhongLighting.lighting(intersection_values.object.material, @light, intersection_values.point, intersection_values.eye_vector, intersection_values.normal)
  end

  def color_at(ray)
    intersections = intersect(ray)
    if intersections.any? && intersections.hit
      precomps = intersections.hit.precompute(ray)
      shade_hit(precomps)
    else
      Color::BLACK
    end
  end
end