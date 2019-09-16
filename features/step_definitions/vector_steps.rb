require 'tuple'

Given("v ← vector<{number}, {number}, {number}>") do |x, y, z|
  @v = Tuple.vector(x, y, z)
end

Given("v{int} ← vector<{number}, {number}, {number}>") do |idx, x, y, z|
  @vs ||= []
  @vs[idx] = Tuple.vector(x, y, z)
end

Given("zero ← vector<0, 0, 0>") do
  @zero_vector = Tuple.vector(0.0, 0.0, 0.0)
end

When("norm ← normalize<v>") do
  @norm = @v.normalize
end

Then("v = tuple<{number}, {number}, {number}, {number}>") do |x, y, z, w|
  expect(@v).to eq(Tuple.build(x, y, z, w))
end

Then("v{int} - v{int} = vector<{number}, {number}, {number}>") do |idx1, idx2, x, y, z|
  expect(@vs[idx1] - @vs[idx2]).to eq(Tuple.vector(x, y, z))
end

Then("zero - v = vector<{number}, {number}, {number}>") do |x, y, z|
  expect(@zero_vector - @v).to eq(Tuple.vector(x, y, z))
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