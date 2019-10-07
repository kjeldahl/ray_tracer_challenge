# frozen_string_literal: true

class Bounds

  attr_reader :min, :max

  class << self
    def bounds_of_bounds(*bounds)
      xmm = bounds.flat_map{ |b| [b.min.x, b.max.x] }.minmax
      ymm = bounds.flat_map{ |b| [b.min.y, b.max.y] }.minmax
      zmm = bounds.flat_map{ |b| [b.min.z, b.max.z] }.minmax

      Bounds.new(Tuple.point(xmm.first, ymm.first, zmm.first), Tuple.point(xmm.last, ymm.last, zmm.last))
    end

    def empty
      @empty ||= Bounds.new(Tuple.origin, Tuple.origin).tap do |empty_bounds|
        def empty_bounds.local_intersect(_local_ray)
          Intersections.empty
        end
      end
    end
  end

  def initialize(min, max)
    @min = min
    @max = max
  end

  # @return a new Bounds object which contains this object after being transformed
  def transform(transformation)
    CallStatistics.add(:bounds_transform)
    tc = corners.map { |c| transformation * c }
    xmm = tc.map(&:x).minmax
    ymm = tc.map(&:y).minmax
    zmm = tc.map(&:z).minmax
    Bounds.new(Tuple.point(xmm.first, ymm.first, zmm.first), Tuple.point(xmm.last, ymm.last, zmm.last))
  end

  # Check for intersection of a local ray
  def local_intersect(local_ray)
    CallStatistics.add(:bounds_local_intersect)
    xtmin, xtmax = *check_axis(min.x, max.x, local_ray.origin.x, local_ray.direction.x)
    ytmin, ytmax = *check_axis(min.y, max.y, local_ray.origin.y, local_ray.direction.y)
    ztmin, ztmax = *check_axis(min.z, max.z, local_ray.origin.z, local_ray.direction.z)

    tmin = [xtmin, ytmin, ztmin].max
    tmax = [xtmax, ytmax, ztmax].min

    if tmax > tmin
      CallStatistics.add(:bounds_local_intersect_hit)
      Intersections.new(Intersection.new(tmin, self),
                        Intersection.new(tmax, self))
    else
      CallStatistics.add(:bounds_local_intersect_miss)
      Intersections.empty
    end
  end

  def to_s
    "Bounds(#{min}, #{max})"
  end

  protected
  def corners
    [min,
     Tuple.point(max.x, min.y, min.z),
     Tuple.point(min.x, max.y, min.z),
     Tuple.point(min.x, min.y, max.z),
     Tuple.point(max.x, max.y, min.z),
     Tuple.point(max.x, min.y, max.z),
     Tuple.point(min.x, max.y, max.z),
     max]
  end

  def check_axis(bb_min, bb_max, ray_origin, ray_direction)
    tmin_nominator = (bb_min - ray_origin)
    tmax_nominator = (bb_max - ray_origin)

    tmin = tmin_nominator / ray_direction
    tmax = tmax_nominator / ray_direction

    if tmin > tmax
      [tmax, tmin]
    else
      [tmin, tmax]
    end
  end

end