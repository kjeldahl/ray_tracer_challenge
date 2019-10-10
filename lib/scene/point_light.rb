class PointLight
  attr_reader :position, :intensity
  attr_reader :intensity_diffuse, :intensity_ambient

  def initialize(position, intensity, intensity_diffuse: 1.0, intensity_ambient: 1.0)
    @position = position
    @intensity = intensity
    @intensity_diffuse = intensity_diffuse
    @intensity_ambient = intensity_ambient
  end

  def ==(other)
    other.class == self.class &&
      other.intensity == intensity &&
      other.position == position
  end

  alias eql? ==

  def hash
    @hash ||= [intensity, position, intensity_diffuse, intensity_ambient].hash
  end

end