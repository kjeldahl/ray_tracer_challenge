require 'tuple'

Given("{var} ← {vector}") do |var, vector|
  set(var, vector)
end

When("{var} ← vector<{number}{operator}{number}, {number}{operator}{number}, {number}>") do |var, x1, op_x, x2, y1, op_y, y2, z|
  set(var, Tuple.vector(x1.send(op_x, x2), y1.send(op_y, y2), z))
end

When("{var} ← vector<{number}, {number}{operator}{number}, {number}{operator}{number}>") do |var, x, y1, op_y, y2, z1, op_z, z2,|
  set(var, Tuple.vector(x, y1.send(op_y, y2), z1.send(op_z, z2)))
end

When("{var} ← normalize<{var}>") do |var1, var2|
  set(var1, get(var2).normalize)
end

When("{var} ← normalize<{vector}>") do |var1, vector|
  set(var1, vector.normalize)
end

When("{var} ← reflect<{var}, {var}>") do |var, param_var1, param_var2|
  set(var, get(param_var1).reflect(get(param_var2)))
end

Then("{var} = {vector}") do |var, vector|
  expect(get(var)).to eq(vector)
end

Then("{var} {operator} {var} = {vector}") do |var1, operator, var2, vector|
  expect(get(var1).send(operator, get(var2))).to eq vector
end

Then("{var} = vector<{number}{operator}{number}, {number}{operator}{number}, {number}{operator}{number}>") do |var, x1, op_x, x2, y1, op_y, y2, z1, op_z, z2|
  expect(get(var)).to eq Tuple.vector(x1.send(op_x, x2), y1.send(op_y, y2), z1.send(op_z, z2))
end

Then("magnitude<{var}> = {number}") do |var, magnitude|
  expect(get(var).magnitude).to eq(magnitude)
end

Then("normalize<{var}> = {vector}") do |var, vector|
  expect(get(var).normalize).to eq(vector)
end

Then("{var} = normalize<{var}>") do |var, var2|
  expect(get(var)).to eq(get(var2).normalize)
end

Then("normalize<{var}> = approximately {vector}") do |var, vector|
  vector_approximately_equal(get(var).normalize, vector)
end

Then("dot<{var}, {var}> = {int}") do |v1, v2, result|
  expect(get(v1).dot(get(v2))).to eq(result)
end

Then("cross<{var}, {var}> = {vector}") do |v1, v2, vector|
  expect(get(v1).cross(get(v2))).to eq(vector)
end

Then("{var}.{word} = {vector}") do |var, attr, vector|
  expect(get(var).send(attr.to_sym)).to eq vector
end

Then("{var}.{word}.{word} = {vector}") do |var, attr, attr2, vector|
  expect(get(var).send(attr.to_sym).send(attr2.to_sym)).to eq vector
end

Then("{var}.{word} = vector<{number}{operator}{number}, {number}, {number}{operator}{number}>") do |var, attr, x1, op_x, x2, y, z1, op_z, z2|
  expect(get(var).send(attr.to_sym)).to eq Tuple.vector(x1.send(op_x, x2), y, z1.send(op_z, z2))
end

Then("{var}.{word} = vector<{number}, {number}{operator}{number}, {number}{operator}{number}>") do |var, attr, x, y1, op_y, y2, z1, op_z, z2|
  expect(get(var).send(attr.to_sym)).to eq Tuple.vector(x, y1.send(op_y, y2), z1.send(op_z, z2))
end


