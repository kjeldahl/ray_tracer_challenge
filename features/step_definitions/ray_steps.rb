require 'ray'

World(IVarHelper)

Given("{word} ← ray<{point}, {vector}>") do |var, origin, direction|
  i_set(var, Ray.new(origin, direction))
end

When("{word} ← ray<{word}, {word}>") do |var, origin, direction|
  i_set(var, Ray.new(i_get(origin), i_get(direction)))
end
When("{word} ← transform<{word}, {word}>") do |var, ray_var, transform_var|
  i_set(var, i_get(ray_var).transform(i_get(transform_var)))
end

Then('{word}.{word} = {word}') do |var, attr, var2|
  expect(i_get(var).send(attr.to_sym)).to eq(i_get(var2))
end

Then('{word}.origin = {point}') do |var, point|
  expect(i_get(var).origin).to eq(point)
end

Then('{word}.direction = {vector}') do |var, vector|
  expect(i_get(var).direction).to eq(vector)
end

Then("position<{word}, {number}> = {point}") do |var, t, point|
  expect(i_get(var).position(t)).to eq point
end