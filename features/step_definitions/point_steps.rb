require 'tuple'

Given('{word} ← {point}') do |var, point|
  i_set(var, point)
end

Then('{word} {operator} {word} = {point}') do |var1, op, var2, point|
  expect(i_get(var1).send(op, i_get(var2))).to eq(point)
end

Then("{word} {operator} {word} = point<{number}{operator}{number}, {number}{operator}{number}, {number}{operator}{number}>") do |var, operator, var2, x1, op_x, x2, y1, op_y, y2, z1, op_z, z2|
  expect(i_get(var).send(operator, i_get(var2))).to eq Tuple.point(x1.send(op_x, x2), y1.send(op_y, y2), z1.send(op_z, z2))
end

Then("{word} = {point}") do |var, point|
  expect(i_get(var)).to eq point
end