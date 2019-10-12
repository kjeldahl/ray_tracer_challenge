require 'shapes/cube'

World(IVarHelper)

Given("{var} ← cube<>") do |var|
  set(var, Cube.new)
end


When("{var} ← local_normal_at<{var}, {var}>") do |var, cube_var, point_var|
  set(var, get(cube_var).send(:local_normal_at, get(point_var)))
end
