require 'scene'

When("{var} ← point_light<{var}, {var}>") do |var, position_var, intensity_var|
  set(var, PointLight.new(get(position_var), get(intensity_var)))
end

And("{var} ← point_light<{point}, {color}>") do |var, position, intensity|
  set(var, PointLight.new(position, intensity))
end

And("{var}.light ← point_light<{point}, {color}>") do |var, position, intensity|
  get(var).lights[0] = PointLight.new(position, intensity)
end

When("{var} ← lighting<{var}, {var}, {var}, {var}, {var}>") do |var, material_var, light_var, position_var, eyev_var, normal_var|
  set(var, PhongLighting.lighting(get(material_var), Sphere.new, get(light_var), get(position_var), get(eyev_var), get(normal_var)))
end

When("{var} ← lighting<{var}, {var}, {var}, {var}, {var}, {var}>") do |var, material_var, light_var, position_var, eyev_var, normal_var, in_shadow|
  set(var, PhongLighting.lighting(get(material_var), Sphere.new, get(light_var), get(position_var), get(eyev_var), get(normal_var), get(in_shadow)))
end

When("{var} ← lighting<{var}, {var}, {point}, {var}, {var}, {var}>") do |var, material_var, light_var, position, eyev_var, normal_var, in_shadow|
  set(var, PhongLighting.lighting(get(material_var), Sphere.new, get(light_var), position, get(eyev_var), get(normal_var), get(in_shadow)))
end

