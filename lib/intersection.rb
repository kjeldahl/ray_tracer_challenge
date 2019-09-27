class Intersection

  attr_reader :t, :object

  def initialize(t, object)
    @t = t
    @object = object
  end

  def precompute(ray)
    hit_point = ray.position(t)
    normal = object.normal_at(hit_point)
    eye_direction = -ray.direction

    reflectv = ray.direction.reflect(normal.normalize)

    if ray.direction.dot(normal) < 0
      inside = false
    else
      inside = true
      normal = -normal
    end

    Precomputed.new(self, hit_point, eye_direction, normal, inside, reflectv)
  end
end

class Precomputed
  EPSILON = 0.00001

  attr_reader :point, :eye_vector, :normal, :inside, :reflectv

  def initialize(intersection, point, eye_vector, normal, inside, reflectv)
    @intersection = intersection
    @point = point
    @eye_vector = eye_vector
    @normal = normal
    @inside = inside
    @reflectv = reflectv
  end

  def t
    @intersection.t
  end

  def object
    @intersection.object
  end

  def inside?
    !!inside
  end

  def over_point
    @over_point ||= @point + normal * EPSILON
  end

  # Aliases for satisfying features move to some helper if possible
  def eyev
    eye_vector
  end

  def normalv
    normal
  end
end