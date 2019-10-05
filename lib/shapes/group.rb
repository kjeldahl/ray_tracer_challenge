# frozen_string_literal: true

class Group < Shape

  def initialize(transform: MyMatrix.identity, material: Material.default)
    super(transform: transform, material: material)
    @children = []
  end

  def bounds
    return @bounds if @bounds

    if empty?
      @bounds = Bounds.empty
    else
      child_bounds = @children.map do |child|
        child.bounds.transform(child.transform)
      end
      @bounds      = Bounds.bounds_of_bounds(*child_bounds)
    end
  end

  def add_child(child)
    @children << child
    child.parent = self
    @bounds      = nil
  end

  def include?(child)
    @children.include?(child)
  end

  def empty?
    @children.empty?
  end

  def local_intersect(local_ray)
    if bounds.local_intersect(local_ray)
      CallStatistics.add(:group_bounds_hit)
      intersections = @children.flat_map { |o| o.intersect(local_ray).to_a }
      if intersections.empty?
        CallStatistics.add(:group_child_miss)
        Intersections.empty
      else
        CallStatistics.add(:group_child_hit)
        Intersections.new(*intersections)
      end
    else
      CallStatistics.add(:group_bounds_miss)
      Intersections.empty
    end
  end
end