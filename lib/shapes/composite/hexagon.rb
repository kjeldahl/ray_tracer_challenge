class Hexagon

  class << self
    def build(transform: MyMatrix.identity, material: Material.default)
      Group.new(transform: transform, material: material).tap do |hexagon|
        6.times do |idx|
          side = side(MyMatrix.rotate(:y, idx * Math::PI / 3))
          hexagon.add_child(side)
        end
      end
    end

    def corner
      Sphere.new(transform: MyMatrix.scale(0.25, 0.25, 0.25).translate(0, 0, -1))
    end

    def edge
      Cylinder.new(min: 0, max: 1,
                   transform:
                        MyMatrix.
                          scale(0.25, 1, 0.25).
                          rotate(:z, -Math::PI / 2).
                          rotate(:y, -Math::PI / 6).
                          translate(0, 0, -1)
                   )
    end

    def side(transform, material: Material.default)
      Group.new(transform: transform, material: material).tap do |side|
        side.add_child(corner)
        side.add_child(edge)
      end
    end
  end
end