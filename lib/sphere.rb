require 'intersection'
require 'intersections'
require 'my_matrix'
require 'tuple'

# Note: This class is not immutable
class Sphere

  attr_reader :transform

  def initialize(transform: MyMatrix.identity)
    @center = Tuple.point(0.0, 0.0, 0.0)
    @transform = transform
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

  # Note: Assumes point is at surface of sphere
  def normal_at(world_point)
    # PERF: Page 226 in the book check for possible short cut
    object_point = transform.inverse * world_point
    object_normal = object_point - @center
    world_normal  = transform.inverse.transpose * object_normal
    # Basically setting w to zero and then normalize
    world_normal.to_vector.normalize
  end
end
