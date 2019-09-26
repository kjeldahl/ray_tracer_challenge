class PointLight
  attr_reader :position, :intensity

  def initialize(position, intensity)
    @position = position
    @intensity = intensity
  end

  def ==(other)
    other.class == self.class &&
      other.intensity == intensity &&
      other.position == position
  end

  alias eql? ==

  def hash
    @hash ||= [intensity, position].hash
  end

end