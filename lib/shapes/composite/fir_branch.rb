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

      object = Group.new
      object.add_child(branch)

      (0...segments).each do |y|
        subgroup = Group.new
        (0...per_segment).each do |i|


        end
      end
    end
  end
end