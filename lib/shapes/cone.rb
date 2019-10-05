class Cone < Shape

  attr_reader :minimum, :maximum
  attr_accessor :closed

  # @param [Float] min - not included in the cone
  # @param [Float] max - not included in the cone
  # @param [bool] closed
  # @return A newly instantiated cone with the given constraints
  def initialize(min: -Float::INFINITY, max: Float::INFINITY, closed: false, transform: MyMatrix.identity, material: Material.default)
    super(transform: transform, material: material)
    @minimum = min
    @maximum = max
    @closed = closed
  end

  def minimum=(min)
    @minimum = min
    @bounds = nil
  end

  def maximum=(max)
    @maximum = max
    @bounds = nil
  end

  def bounds
    return @bounds if @bounds

    abs_max = [@minimum.abs, @maximum.abs].max
    @bounds = Bounds.new(Tuple.point(-abs_max, @minimum, -abs_max),
                           Tuple.point(abs_max, @maximum, abs_max))
  end

  def local_intersect(local_ray)
    a = local_ray.direction.x**2 - local_ray.direction.y**2 + local_ray.direction.z**2
    b = 2 * local_ray.origin.x * local_ray.direction.x -
        2 * local_ray.origin.y * local_ray.direction.y +
        2 * local_ray.origin.z * local_ray.direction.z
    c = local_ray.origin.x**2 - local_ray.origin.y**2 + local_ray.origin.z**2


    # Parallel with cone half
    if a.abs < World::EPSILON
      return Intersections.empty if b.abs < World::EPSILON

      # One intersection
      t = -c / (2 * b)

      is = [Intersection.new(t, self)]
      intersect_caps(local_ray, is) if closed

      return Intersections.new(*is)
    end

    discriminant = b**2 - 4 * a * c

    # Ray miss
    return Intersections.empty if discriminant < 0

    t1 = (-b - Math.sqrt(discriminant)) / (2 * a)
    t2 = (-b + Math.sqrt(discriminant)) / (2 * a)

    # Constrain hits to height of cylinder
    y1 = local_ray.position(t1).y
    y2 = local_ray.position(t2).y

    is = []
    is << Intersection.new(t1, self) if minimum < y1 && y1 < maximum
    is << Intersection.new(t2, self) if minimum < y2 && y2 < maximum

    intersect_caps(local_ray, is) if closed

    if is.empty?
      Intersections.empty
    elsif is.size == 1
      Intersections.new(is[0], is[0])
    else
      Intersections.new(*is)
    end
  end

  def local_normal_at(local_point)
    if closed
      # Check if we are at the caps
      if (local_point.y - minimum).abs < World::EPSILON
        Tuple.vector(0.0, -1.0, 0.0)
      elsif (local_point.y - maximum).abs < World::EPSILON
        Tuple.vector(0.0, 1.0, 0.0)
      else
        y = local_point.x**2 + local_point.z**2
        y = -y.abs
        Tuple.vector(local_point.x, y, local_point.z)
      end
    else
      y = Math.sqrt(local_point.x**2 + local_point.z**2)
      y = -y if local_point.y > 0
      Tuple.vector(local_point.x, y, local_point.z)
    end
  end

  # Check if ray is intersecting cap at t
  def check_cap(ray, t, y)
    p = ray.position(t)
    p.x**2 + p.z**2 <= y.abs
  end

  def intersect_caps(local_ray, is)
    t1 = (minimum - local_ray.origin.y) / local_ray.direction.y
    t2 = (maximum - local_ray.origin.y) / local_ray.direction.y

    is << Intersection.new(t1, self) if check_cap(local_ray, t1, minimum)
    is << Intersection.new(t2, self) if check_cap(local_ray, t2, maximum)
  end
end