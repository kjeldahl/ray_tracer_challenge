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
    @intersections.reject { |i| i.t < 0 }.min_by(&:t)
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

  def any?
    @intersections.count > 0
  end

  def empty?
    @intersections.count == 0
  end

  def to_a
    @intersections.dup
  end
end