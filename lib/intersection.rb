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

    if ray.direction.dot(normal) < 0
      inside = false
    else
      inside = true
      normal = -normal
    end

    Precomputed.new(self, hit_point, eye_direction, normal, inside)
  end
end

class Precomputed
  attr_reader :point, :eye_vector, :normal, :inside

  def initialize(intersection, point, eye_vector, normal, inside)
    @intersection = intersection
    @point = point
    @eye_vector = eye_vector
    @normal = normal
    @inside = inside
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

  # Aliases for satisfying features move to some helper if possible
  def eyev
    eye_vector
  end

  def normalv
    normal
  end
end