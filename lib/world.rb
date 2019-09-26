require 'intersections'
require 'phong_lighting'

# NOTE: This class is not immutable
class World
  EPSILON = 0.00001

  def initialize(light: nil, lights: [], shadows: true)
    @lights = [light, lights].compact.flatten.compact
    @objects = []
    @shadows = shadows
  end

  def light
    lights.first
  end

  def lights
    @lights
  end

  def objects
    @objects
  end

  # Are shadows enabled in this world
  def shadows?
    @shadows
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
    lights.map do |l|
      PhongLighting.lighting(intersection_values.object.material,
                             intersection_values.object,
                             l,
                             intersection_values.over_point,
                             intersection_values.eye_vector,
                             intersection_values.normal,
                             shadowed?(intersection_values.over_point, l))
    end.reduce(:+)
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

  def shadowed?(point, shadow_light = light)
    return false unless shadows?

    light_direction = shadow_light.position - point
    light_ray = Ray.new(point, light_direction.normalize)

    intersections = intersect(light_ray)
    if intersections.hit
      # Check if intersection is between the light and the point
      intersections.hit.t < light_direction.magnitude
    else
      false
    end
  end
end