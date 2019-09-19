require 'intersection'
require 'intersections'
require 'my_matrix'

# Note: This class is not immutable
class Sphere

  attr_reader :transform

  def initialize
    @center = Tuple.point(0.0, 0.0, 0.0)
    @transform = MyMatrix.identity
  end

  def transform=(new_transform)
    @transform = new_transform
  end

  def intersect(ray)
    t_ray = ray.transform(@transform.inverse)

    sphere_to_ray = t_ray.origin - @center
    a = t_ray.direction.dot(t_ray.direction)
    b = t_ray.direction.dot(sphere_to_ray) * 2
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
end
