class CallStatistics
  class << self
    def add(name)
      @stats ||= {}
      @stats[name] = (@stats[name] || 0) + 1
    end

    def to_s
      if @stats
        @stats.map{|k,v| "#{k}: #{v}"}.join("\n")
      else
        "n/a"
      end
    end
  end
end