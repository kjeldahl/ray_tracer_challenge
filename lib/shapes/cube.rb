require 'scene/world'

class Cube < Shape

  def local_intersect(local_ray)
    xtmin, xtmax = *check_axis(local_ray.origin.x, local_ray.direction.x)
    ytmin, ytmax = *check_axis(local_ray.origin.y, local_ray.direction.y)
    ztmin, ztmax = *check_axis(local_ray.origin.z, local_ray.direction.z)

    tmin = [xtmin, ytmin, ztmin].max
    tmax = [xtmax, ytmax, ztmax].min

    if tmax > tmin
      Intersections.new(Intersection.new(tmin, self),
                        Intersection.new(tmax, self))
    else
      Intersections.empty
    end
  end

  def local_normal_at(local_point)
    if (local_point.x.abs - 1.0).abs < World::EPSILON
      Tuple.vector(local_point.x, 0.0, 0.0)
    elsif (local_point.y.abs - 1.0).abs < World::EPSILON
      Tuple.vector(0.0, local_point.y, 0.0)
    elsif (local_point.z.abs - 1.0).abs < World::EPSILON
      Tuple.vector(0.0, 0.0, local_point.z)
    end
  end

  def check_axis(origin, direction)
    tmin_nominator = (-1 - origin)
    tmax_nominator = (1 - origin)

    tmin = tmin_nominator / direction
    tmax = tmax_nominator / direction

    if tmin > tmax
      [tmax, tmin]
    else
      [tmin, tmax]
    end
  end
end