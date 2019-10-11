class Triangle < Shape

  attr_reader :p1, :p2, :p3
  attr_reader :e1, :e2, :normal

  def initialize(point1, point2, point3, transform: MyMatrix.identity, material: Material.default, shadow: true)
    super(transform: transform, material: material, shadow: shadow)
    @p1 = point1
    @p2 = point2
    @p3 = point3
    @e1 = p2 - p1
    @e2 = p3 - p1
    @normal = e2.cross(e1).normalize
  end

  # TODO: Check if this is correct
  def bounds
    return @bounds if @bounds

    tc = [p1, p2, p3]
    xmm = tc.map(&:x).minmax
    ymm = tc.map(&:y).minmax
    zmm = tc.map(&:z).minmax
    Bounds.new(Tuple.point(xmm.first, ymm.first, zmm.first),
               Tuple.point(xmm.last, ymm.last, zmm.last))
  end

  def local_intersect(local_ray)
    dir_cross_e2 = local_ray.direction.cross(e2)
    det = e1.dot(dir_cross_e2)
    return Intersections.empty if det.abs < World::EPSILON

    f = 1 / det

    p1_to_origin = local_ray.origin - p1
    u = f * p1_to_origin.dot(dir_cross_e2)
    return Intersections.empty if u < 0 || u > 1

    origin_cross_e1 = p1_to_origin.cross(e1)
    v = f * local_ray.direction.dot(origin_cross_e1)
    return Intersections.empty if v < 0 || (u + v) > 1

    t = f * e2.dot(origin_cross_e1)
    Intersections.new(Intersection.new(t, self, u: u, v: v))
  end

  def local_normal_at(local_point, intersection=nil)
    @normal
  end

end