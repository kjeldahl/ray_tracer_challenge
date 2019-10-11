require 'shapes/triangle'
require 'shapes/smooth_triangle'

World(IVarHelper)

Given("{var} ← triangle<{var}, {var}, {var}>") do |var, point_var1, point_var2, point_var3|
  set(var, Triangle.new(get(point_var1), get(point_var2), get(point_var3)))
end

Given("{var} ← triangle<{point}, {point}, {point}>") do |var, point1, point2, point3|
  set(var, Triangle.new(point1, point2, point3))
end

When("{var} ← smooth_triangle<{var}, {var}, {var}, {var}, {var}, {var}>") do |var, point1, point2, point3, v1, v2, v3|
  set(var, SmoothTriangle.new(get(point1), get(point2), get(point3), get(v1), get(v2), get(v3)))
end

When("{var} ← normal_at<{var}, {point}, {var}>") do |var, tri_var, point, hit_var|
  set(var, get(tri_var).normal_at(point, get(hit_var)))
end

Then("{var} = {var}.{word}") do |var, var2, attr|
  expect(get(var)).to eq get(var2).send(attr.to_sym)
end