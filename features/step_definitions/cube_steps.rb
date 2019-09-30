require 'shapes/cube'

World(IVarHelper)

Given("{var} ← ray<{var}, {var}>") do |var, var2, var3|
  pending # Write code here that turns the phrase above into concrete actions
end

Given("{var} ← {var}{operator}{var}") do |var, var2, operator, var3|
  pending # Write code here that turns the phrase above into concrete actions
end

When("{var} ← local_normal_at<{var}, {var}>") do |var, cube_var, point_var|
  set(var, get(cube_var).send(:local_normal_at, get(point_var)))
end
