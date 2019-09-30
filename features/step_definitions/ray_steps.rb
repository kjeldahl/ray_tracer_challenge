# frozen_string_literal: true

require 'ray'

World(IVarHelper)

Given("{var} ← ray<{point}, {vector}>") do |var, origin, direction|
  set(var, Ray.new(origin, direction))
end

When("{var} ← ray<{var}, {var}>") do |var, origin, direction|
  set(var, Ray.new(get(origin), get(direction)))
end

When("{var} ← ray<{point}, {var}>") do |var, origin, direction|
  set(var, Ray.new(origin, get(direction)))
end

When("{var} ← transform<{var}, {var}>") do |var, ray_var, transform_var|
  set(var, get(ray_var).transform(get(transform_var)))
end

Then("position<{var}, {number}> = {point}") do |var, t, point|
  expect(get(var).position(t)).to eq point
end