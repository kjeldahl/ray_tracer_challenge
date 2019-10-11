require 'shapes/triangle'

class SmoothTriangle < Triangle

  attr_reader :n1, :n2, :n3

  def initialize(point1, point2, point3, v1, v2, v3, transform: MyMatrix.identity, material: Material.default, shadow: true)
    super(point1, point2, point3, transform: transform, material: material, shadow: shadow)
    @n1 = v1
    @n2 = v2
    @n3 = v3
  end

  def local_normal_at(local_point, intersection)
    n2 * intersection.u +
      n3 * intersection.v +
      n1 * (1 - intersection.u - intersection.v)
  end

end