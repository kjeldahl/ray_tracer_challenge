class Intersection
  attr_reader :t, :object

  def initialize(t, object)
    @t = t
    @object = object
  end

  def precompute(ray, intersections = Intersections.new(self))
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

    n1, n2 = compute_n1_n2(intersections)

    Precomputed.new(self,
                    hit_point,
                    eye_direction,
                    normal,
                    inside,
                    reflectv,
                    n1,
                    n2)
  end

  private

  def compute_n1_n2(intersections)
    n1, n2 = 0, 0
    containers = []
    intersections.each do |is|
      if is == self
        n1 = containers.empty? ? 1.0 : containers.last.material.refractive_index
      end
      containers.include?(is.object) ? containers.delete(is.object) : containers << is.object
      if is == self
        n2 = containers.empty? ? 1.0 : containers.last.material.refractive_index
        break
      end
    end
    [n1, n2]
  end
end

class Precomputed
  EPSILON = 0.00001

  attr_reader :point, :eye_vector, :normal, :inside, :reflectv,
              :n1, :n2

  def initialize(intersection, point, eye_vector, normal, inside, reflectv, n1, n2)
    @intersection = intersection
    @point = point
    @eye_vector = eye_vector
    @normal = normal
    @inside = inside
    @reflectv = reflectv
    @n1 = n1
    @n2 = n2
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

  def under_point
    @under_point ||= @point - normal * EPSILON
  end

  # Aliases for satisfying features move to some helper if possible
  def eyev
    eye_vector
  end

  def normalv
    normal
  end
end
