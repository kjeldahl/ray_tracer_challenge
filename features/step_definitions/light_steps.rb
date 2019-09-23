require 'phong_lighting'
require 'point_light'

When("{var} ← point_light<{var}, {var}>") do |var, position_var, intensity_var|
  i_set(var, PointLight.new(i_get(position_var), i_get(intensity_var)))
end

And("{var} ← point_light<{point}, {color}>") do |var, position, intensity|
  i_set(var, PointLight.new(position, intensity))
end

When("{var} ← lighting<{var}, {var}, {var}, {var}, {var}>") do |var, material_var, light_var, position_var, eyev_var, normal_var|
  i_set(var, PhongLighting.lighting(i_get(material_var), i_get(light_var), i_get(position_var), i_get(eyev_var), i_get(normal_var)))
end

