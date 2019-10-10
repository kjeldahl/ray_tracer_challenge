class FirBranch

  class << self
    def build(transform: MyMatrix.identity, material: Material.default)
      length = 2.0
      radius = 0.025
      segments = 20
      per_segment = 24

      branch = Cylinder.new(min: 0.0, max: length, closed: true,
                            transform: MyMatrix.scale(radius, 1, radius),
                            material: Material.new(color: Color.new(0.5, 0.35, 0.26),
                                                   ambient: 0.2,
                                                   specular: 0.0,
                                                   diffuse: 0.6))

      seg_size = length / (segments - 1)

      theta = 2.1 * Math::PI / per_segment

      max_length = 20.0 * radius

      Group.new(transform: transform, material: material).tap do |object|
        object.add_child(branch)

        (0...segments).each do |y|
          subgroup = Group.new
          object.add_child(subgroup)
          (0...per_segment).each do |i|
            y_base = seg_size * y + rand * seg_size
            y_tip = y_base - rand * seg_size

            y_angle = i * theta + rand * theta
            needle_length = max_length / 2 * (1 + rand)

            ofs = radius / 2

            p1 = Tuple.point(ofs, y_base, ofs)
            p2 = Tuple.point(-ofs, y_base, ofs)
            p3 = Tuple.point(0.0, y_tip, needle_length)

            tri = Triangle.new(p1, p2, p3,
                               transform: MyMatrix.rotate(:y, y_angle),
                               material: Material.new(color: Color.new(0.26, 0.36, 0.16),
                                                      specular: 0.1))

            subgroup.add_child(tri)
          end
        end
      end
    end
  end
end