class Group < Shape

  def initialize
    super
    @children = []
  end

  def add_child(child)
    @children << child
    child.parent = self
  end

  def include?(child)
    @children.include?(child)
  end

  def empty?
    @children.empty?
  end

  def local_intersect(local_ray)
    intersections = @children.flat_map { |o| o.intersect(local_ray).to_a }
    if intersections.empty?
      Intersections.empty
    else
      Intersections.new(*intersections)
    end
  end
end