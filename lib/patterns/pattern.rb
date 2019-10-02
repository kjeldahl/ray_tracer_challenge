class Pattern

  attr_accessor :transform

  def initialize(transform: MyMatrix.identity)
    @transform = transform
  end

  def pattern_at_shape(shape, world_point)
    shape_point = shape.world_to_object(world_point)
    pattern_point = transform.inverse * shape_point
    pattern_at(pattern_point)
  end


  def pattern_at(pattern_point)
    raise "Implement in sub class"
  end

end
