require 'shapes/triangle'

World(IVarHelper)

Given("{var} ← triangle<{var}, {var}, {var}>") do |var, point_var1, point_var2, point_var3|
  set(var, Triangle.new(get(point_var1), get(point_var2), get(point_var3)))
end

Given("{var} ← triangle<{point}, {point}, {point}>") do |var, point1, point2, point3|
  set(var, Triangle.new(point1, point2, point3))
end

Then("{var} = {var}.{word}") do |var, var2, attr|
  expect(get(var)).to eq get(var2).send(attr.to_sym)
end