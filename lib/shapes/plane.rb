require 'intersection'
require 'intersections'

class Plane < Shape
  PLANE_NORMAL = Tuple.vector(0.0, 1.0, 0.0).freeze

  # PERF: The normal does not change anyway so no need to convert for all points
  def normal_at(world_point)
    @plane_normal ||= super(world_point)
  end

  protected

    def local_intersect(local_ray)
      if local_ray.direction.y.abs < World::EPSILON
        Intersections.empty
      else
        t = -local_ray.origin.y / local_ray.direction.y
        Intersections.new(Intersection.new(t, self))
      end
    end

    def local_normal_at(_)
      PLANE_NORMAL
    end
end