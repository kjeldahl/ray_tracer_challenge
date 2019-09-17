require 'tuple'

Given("{word} ← vector<{number}, {number}, {number}>") do |var, x, y, z|
  i_set(var, Tuple.vector(x, y, z))
end

When("norm ← normalize<v>") do
  @norm = @v.normalize
end

Then("v = tuple<{number}, {number}, {number}, {number}>") do |x, y, z, w|
  expect(@v).to eq(Tuple.build(x, y, z, w))
end

Then("{word} - {word} = vector<{number}, {number}, {number}>") do |var1, var2, x, y, z|
  expect(i_get(var1) - i_get(var2)).to eq(Tuple.vector(x, y, z))
end

Then("magnitude<v> = {number}") do |magnitude|
  expect(@v.magnitude).to eq(magnitude)
end

Then("normalize<v> = vector<{number}, {number}, {number}>") do |x, y, z|
  expect(@v.normalize).to eq(Tuple.vector(x, y, z))
end

Then("normalize<v> = approximately vector<{number}, {number}, {number}>") do |x, y, z|
  approximately_equal(@v.normalize, Tuple.vector(x, y, z))
end

Then("magnitude<norm> = {number}") do |magnitude|
  expect(@norm.magnitude).to eq(magnitude)
end
