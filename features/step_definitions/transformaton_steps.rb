require 'my_matrix'

World(IVarHelper)

Given("{word} ← {translation}") do |var, translation|
  i_set(var, translation)
end

Given("{word} ← {scaling}") do |var, scaling|
  i_set(var, scaling)
end

And("{word} ← {rotation}") do |var, rotation|
  i_set(var, rotation)
end

Then("{word} {operator} {word} = {vector}") do |var1, operator, var2, vector|
  expect(i_get(var1).send(operator, i_get(var2))).to eq vector
end

Then("{word} {operator} {word} = point<{number}{operator}{number}, {number}{operator}{number}, {number}{operator}{number}>") do |var, operator, var2, x1, op_x, x2, y1, op_y, y2, z1, op_z, z2|
    expect(i_get(var).send(operator, i_get(var2))).to eq Tuple.point(x1.send(op_x, x2), y1.send(op_y, y2), z1.send(op_z, z2))
end