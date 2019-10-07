require 'intersections'
require 'scene/phong_lighting'

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

  def add_light(light)
    @lights << light
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
      CallStatistics.add(:world_intersect_miss)
      Intersections.empty
    else
      CallStatistics.add(:world_intersect_hit)
      Intersections.new(*intersections)
    end
  end

  # Calculates the color of an intersection, taking all lights into account
  #
  def shade_hit(intersection_values, remaining = 1)
    lights.map do |l|
      obj_material = intersection_values.object.material

      surface =
        PhongLighting.lighting(obj_material,
                               intersection_values.object,
                               l,
                               intersection_values.over_point,
                               intersection_values.eye_vector,
                               intersection_values.normal,
                               shadowed?(intersection_values.over_point, l))

      reflection = reflected_color(intersection_values, remaining)

      refracted_color = refracted_color(intersection_values, remaining)

      # Handle transparent and reflective surface
      if obj_material.transparency > 0 &&
        obj_material.reflective > 0

        reflectance = intersection_values.schlick
        reflection *= reflectance
        refracted_color *= (1 - reflectance)
      end

      surface + reflection + refracted_color
    end.reduce(:+)
  end

  # Intersects the world with the given ray and returns the color
  def color_at(ray, remaining = 5)
    intersections = intersect(ray)
    if intersections.any? && intersections.hit
      precomps = intersections.hit.precompute(ray, intersections)
      shade_hit(precomps, remaining)
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

  def reflected_color(precomputed, remaining=1)
    return Color::BLACK if remaining == 0

    if precomputed.object.material.reflective > 0
      reflection_ray = Ray.new(precomputed.over_point, precomputed.reflectv)

      color_at(reflection_ray, remaining - 1) * precomputed.object.material.reflective
    else
      Color::BLACK
    end
  end

  def refracted_color(precomputed, remaining=1)
    return Color::BLACK if remaining == 0

    if precomputed.object.material.transparency > 0
      # Snell's law for internal reflection
      n_ratio = precomputed.n1 / precomputed.n2
      cos_i = precomputed.eye_vector.dot(precomputed.normal)
      sin2_t = n_ratio**2 * (1 - cos_i**2)

      if sin2_t > 1.0 # Total internal reflection
        Color::BLACK # TODO: Why not create a new ray here?
      else
        # Send new refracted ray
        cos_t = Math.sqrt(1.0 - sin2_t)

        direction = precomputed.normal * (n_ratio * cos_i - cos_t) - precomputed.eye_vector * n_ratio

        refracted_ray = Ray.new(precomputed.under_point, direction)

        color_at(refracted_ray, remaining - 1) * precomputed.object.material.transparency
      end
    else
      Color::BLACK
    end
  end
end