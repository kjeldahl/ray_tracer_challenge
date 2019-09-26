# frozen_string_literal: true

require 'shapes'

World(IVarHelper)

Given("{var} ← plane<>") do |var|
  set(var, Plane.new)
end

When("{var} ← local_normal_at<{var}, {point}>") do |var, plane_var, point|
  set(var, get(plane_var).send(:local_normal_at, point))
end

When("{var} ← local_intersect<{var}, {var}>") do |var, plane_var, ray_var|
  set(var, get(plane_var).send(:local_intersect, get(ray_var)))
end