# frozen_string_literal: true

require 'sphere'

World(IVarHelper)

When "{var} ← {sphere}" do |var, sphere|
  i_set(var, sphere)
end

When("{var} ← intersect<{var}, {var}>") do |var, sphere_var, ray_var|
  i_set(var, i_get(sphere_var).intersect(i_get(ray_var)))
end

