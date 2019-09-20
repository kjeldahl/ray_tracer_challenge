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

When("{var} ← normal_at<{var}, {point}>") do |var, sphere_var, point|
  i_set(var, i_get(sphere_var).normal_at(point))
end

When("{var} ← normal_at<{var}, point<{number}, {number}{operator}{number}, {number}{operator}{number}>>") do |var, sphere_var, x, y1, op_y, y2, z1, op_z, z2|
  i_set(var, i_get(sphere_var).normal_at(Tuple.point(x, y1.send(op_y, y2), z1.send(op_z, z2))))
end

When("{var} ← normal_at<{var}, point<{number}{operator}{number}, {number}{operator}{number}, {number}{operator}{number}>>") do |var, sphere_var, x1, op_x, x2, y1, op_y, y2, z1, op_z, z2|
  i_set(var, i_get(sphere_var).normal_at(Tuple.point(x1.send(op_x, x2), y1.send(op_y, y2), z1.send(op_z, z2))))
end

