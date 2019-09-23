require 'tuple'

Given("{var} ← {vector}") do |var, vector|
  i_set(var, vector)
end

When("{var} ← vector<{number}{operator}{number}, {number}{operator}{number}, {number}>") do |var, x1, op_x, x2, y1, op_y, y2, z|
  i_set(var, Tuple.vector(x1.send(op_x, x2), y1.send(op_y, y2), z))
end

When("{var} ← vector<{number}, {number}{operator}{number}, {number}{operator}{number}>") do |var, x, y1, op_y, y2, z1, op_z, z2,|
  i_set(var, Tuple.vector(x, y1.send(op_y, y2), z1.send(op_z, z2)))
end

When("{var} ← normalize<{var}>") do |var1, var2|
  i_set(var1, i_get(var2).normalize)
end

When("{var} ← reflect<{var}, {var}>") do |var, param_var1, param_var2|
  i_set(var, i_get(param_var1).reflect(i_get(param_var2)))
end

Then("{var} = {vector}") do |var, vector|
  expect(i_get(var)).to eq(vector)
end

Then("{var} {operator} {var} = {vector}") do |var1, operator, var2, vector|
  expect(i_get(var1).send(operator, i_get(var2))).to eq vector
end

Then("{var} = vector<{number}{operator}{number}, {number}{operator}{number}, {number}{operator}{number}>") do |var, x1, op_x, x2, y1, op_y, y2, z1, op_z, z2|
  expect(i_get(var)).to eq Tuple.vector(x1.send(op_x, x2), y1.send(op_y, y2), z1.send(op_z, z2))
end

Then("magnitude<{var}> = {number}") do |var, magnitude|
  expect(i_get(var).magnitude).to eq(magnitude)
end

Then("normalize<{var}> = {vector}") do |var, vector|
  expect(i_get(var).normalize).to eq(vector)
end

Then("{var} = normalize<{var}>") do |var, var2|
  expect(i_get(var)).to eq(i_get(var2).normalize)
end

Then("normalize<{var}> = approximately {vector}") do |var, vector|
  vector_approximately_equal(i_get(var).normalize, vector)
end

Then("dot<{var}, {var}> = {int}") do |v1, v2, result|
  expect(i_get(v1).dot(i_get(v2))).to eq(result)
end

Then("cross<{var}, {var}> = {vector}") do |v1, v2, vector|
  expect(i_get(v1).cross(i_get(v2))).to eq(vector)
end
