# frozen_string_literal: true

# Note: This class is not immutable
class Material
  attr_accessor :color, :ambient, :diffuse, :specular, :shininess,
                :reflective, :transparency, :refractive_index,
                :pattern

  def initialize(color:     Color::WHITE,
                 ambient:   0.1,
                 diffuse:   0.9,
                 specular:  0.9,
                 shininess: 200.0,
                 reflective: 0.0,
                 transparency: 0.0,
                 refractive_index: 1.0,
                 pattern:   nil)
    @color = color
    @ambient = ambient
    @diffuse = diffuse
    @specular = specular
    @shininess = shininess
    @reflective = reflective
    @transparency = transparency
    @refractive_index = refractive_index
    @pattern = pattern
  end

  def ==(other)
    other.class == self.class &&
      other.color == color &&
      other.ambient == ambient &&
      other.diffuse == diffuse &&
      other.specular == specular &&
      other.shininess == shininess &&
      other.reflective == reflective &&
      other.pattern == pattern
  end

  alias eql? ==

  def hash
    [color, ambient, diffuse, specular, shininess, reflective, pattern].hash
  end
end
