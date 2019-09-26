# frozen_string_literal: true

# Note: This class is not immutable
class Material
  attr_accessor :color, :ambient, :diffuse, :specular, :shininess, :pattern

  def initialize(color:     Color::WHITE,
                 ambient:   0.1,
                 diffuse:   0.9,
                 specular:  0.9,
                 shininess: 200.0,
                 pattern:   nil)
    @color = color
    @ambient = ambient
    @diffuse = diffuse
    @specular = specular
    @shininess = shininess
    @pattern = pattern
  end

  def ==(other)
    other.class == self.class &&
      other.color == color &&
      other.ambient == ambient &&
      other.diffuse == diffuse &&
      other.specular == specular &&
      other.shininess == shininess &&
      other.pattern == pattern
  end

  alias eql? ==

  def hash
    [color, ambient, diffuse, specular, shininess, pattern].hash
  end
end
