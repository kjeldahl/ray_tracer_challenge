# frozen_string_literal: true

# Note: This class is not immutable
class Sphere < Shape

  BOUNDS = Bounds.new(Tuple.point(-1, -1, -1), Tuple.point(1, 1, 1))

  def bounds
    BOUNDS
  end

  protected
    def local_intersect(local_ray)
      sphere_to_ray = local_ray.origin - @origin

      a = local_ray.direction.dot(local_ray.direction)
      b = local_ray.direction.dot(sphere_to_ray) * 2
      c = sphere_to_ray.dot(sphere_to_ray) - 1

      discriminant = b**2 - 4 * a * c
      if discriminant < 0
        Intersections.empty
      else
        t1 = (-b - Math.sqrt(discriminant)) / (2 * a)
        t2 = (-b + Math.sqrt(discriminant)) / (2 * a)
        Intersections.new(Intersection.new(t1, self),
                          Intersection.new(t2, self))
      end
    end

    def local_normal_at(local_point, intersection=nil)
      local_point - @origin
    end
end
