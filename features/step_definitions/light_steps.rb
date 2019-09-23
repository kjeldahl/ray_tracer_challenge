require 'phong_lighting'
require 'point_light'

When("{var} ← point_light<{var}, {var}>") do |var, position_var, intensity_var|
  set(var, PointLight.new(get(position_var), get(intensity_var)))
end

And("{var} ← point_light<{point}, {color}>") do |var, position, intensity|
  set(var, PointLight.new(position, intensity))
end

When("{var} ← lighting<{var}, {var}, {var}, {var}, {var}>") do |var, material_var, light_var, position_var, eyev_var, normal_var|
  set(var, PhongLighting.lighting(get(material_var), get(light_var), get(position_var), get(eyev_var), get(normal_var)))
end

