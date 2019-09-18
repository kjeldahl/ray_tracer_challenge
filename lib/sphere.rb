

class Sphere

  def initialize
    @center = Tuple.point(0.0, 0.0, 0.0)
  end

  def intersect(ray)
    sphere_to_ray = ray.origin - @center
    a = ray.direction.dot(ray.direction)
    b = ray.direction.dot(sphere_to_ray) * 2
    c = sphere_to_ray.dot(sphere_to_ray) - 1

    discriminant = b**2 - 4 * a * c
    if discriminant < 0
      []
    else
      t1 = (-b - Math.sqrt(discriminant)) / (2 * a)
      t2 = (-b + Math.sqrt(discriminant)) / (2 * a)
      [t1, t2]
    end
  end
end
