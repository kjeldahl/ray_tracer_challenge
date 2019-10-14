class CSG < Shape

  attr_reader :left, :right, :operation

  # TODO: Need to implement bounds

  def initialize(left, op, right, transform: MyMatrix.identity, material: Material.default, bounds_check: true, shadow: true)
    super(transform: transform, material: material, shadow: shadow)
    @bounds_check = bounds_check
    @left = left
    @operation = op
    @right = right

    left.parent = self
    right.parent = self
  end

  def filter_intersections(intersections)
    inl = false
    inr = false
    filtered_intersections =
      intersections.select do |i|
        lhit = left.include?(i.object)
        if CSG.intersection_allowed(@operation, lhit, inl, inr)
          lhit ? inl = !inl : inr = !inr
          true
        else
          lhit ? inl = !inl : inr = !inr
          false
        end
      end
    Intersections.new(*filtered_intersections)
  end

  def include?(child)
    @left.include?(child) || @right.include?(child)
  end

  def local_intersect(local_ray)
    left_i = @left.intersect(local_ray)
    right_i = @right.intersect(local_ray)
    filter_intersections(left_i.combine(right_i))
  end

  def local_normal_at(local_point, intersection=nil)
    raise "Should not be called"
  end


  class << self
    def intersection_allowed(op, lhit, inl, inr)
      rhit = !lhit
      case op
        when :union
          return (lhit && !inr) || (rhit && !inl)
        when :intersection
          return (lhit && inr) || (rhit && inl)
        when :difference
          return (lhit && !inr) || (rhit && inl)
        else
          raise "Unknown operation: #{op}"
      end

    end
  end
end