# frozen_string_literal: true

require 'sphere'

World(IVarHelper)

When "{var} ← {sphere}" do |var, sphere|
  i_set(var, sphere)
end

When("{var} ← intersect<{var}, {var}>") do |var, sphere_var, ray_var|
  i_set(var, i_get(sphere_var).intersect(i_get(ray_var)))
end

When("set_transform<{var}, {var}>") do |sphere_var, transform_var|
  i_get(sphere_var).transform = i_get(transform_var)
end

When("set_transform<{var}, {scaling}>") do |sphere_var, scaling|
  i_get(sphere_var).transform = scaling
end

When("set_transform<{var}, {translation}>") do |sphere_var, scaling|
  i_get(sphere_var).transform = scaling
end

