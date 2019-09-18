# frozen_string_literal: true

require 'ray'

World(IVarHelper)

Given("{var} ← ray<{point}, {vector}>") do |var, origin, direction|
  i_set(var, Ray.new(origin, direction))
end

When("{var} ← ray<{var}, {var}>") do |var, origin, direction|
  i_set(var, Ray.new(i_get(origin), i_get(direction)))
end
When("{var} ← transform<{var}, {var}>") do |var, ray_var, transform_var|
  i_set(var, i_get(ray_var).transform(i_get(transform_var)))
end

# TODO: Move to general steps
Then('{var}.{word} = {var}') do |var, attr, var2|
  expect(i_get(var).send(attr.to_sym)).to eq(i_get(var2))
end

Then('{var}.origin = {point}') do |var, point|
  expect(i_get(var).origin).to eq(point)
end

Then('{var}.direction = {vector}') do |var, vector|
  expect(i_get(var).direction).to eq(vector)
end

Then("position<{var}, {number}> = {point}") do |var, t, point|
  expect(i_get(var).position(t)).to eq point
end