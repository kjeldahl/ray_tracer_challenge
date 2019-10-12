class Intersections

  class << self
    def empty
      @empty ||= Intersections.new
    end
  end

  def initialize(*intersections)
    @intersections = intersections.sort_by!(&:t)
  end

  def hit
    # PERF: Cache hit
    @hit ||=
      @intersections.
        reject { |i| i.t < 0 }.
        min_by(&:t)
  end

  def shadow_hit
    @intersections.
      reject { |i| i.t < 0 }.
      select { |i| i.object.shadow }.
      min_by(&:t)
  end

  def count
    @intersections.count
  end

  def index(v)
    @intersections.index(v)
  end

  def [](idx)
    @intersections[idx]
  end

  def each(&block)
    @intersections.each(&block)
  end

  def select(&block)
    @intersections.select(&block)
  end

  def any?
    @intersections.count > 0
  end

  def empty?
    @intersections.count == 0
  end

  def combine(other_intersections)
    Intersections.new(*(@intersections + other_intersections.to_a))
  end

  def to_a
    @intersections.dup
  end
end