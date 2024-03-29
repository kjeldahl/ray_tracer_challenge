require 'tuple'

Given('{var} ← {point}') do |var, point|
  set(var, point)
end

Given("{var} ← point<{number}, {number}, {number}{operator}{number}>") do |var, x1, y1, z1, op_z, z2|
  set(var, Tuple.point(x1, y1, z1.send(op_z, z2)))
end


Then('{var} {operator} {var} = {point}') do |var1, op, var2, point|
  expect(get(var1).send(op, get(var2))).to eq(point)
end

Then("{var} {operator} {var} = point<{number}{operator}{number}, {number}{operator}{number}, {number}{operator}{number}>") do |var, operator, var2, x1, op_x, x2, y1, op_y, y2, z1, op_z, z2|
  expect(get(var).send(operator, get(var2))).to eq Tuple.point(x1.send(op_x, x2), y1.send(op_y, y2), z1.send(op_z, z2))
end

Then("{var}.{attr} = point<{number}{operator}{number}, {number}{operator}{number}, {number}{operator}{number}>") do |var, attr, x1, op_x, x2, y1, op_y, y2, z1, op_z, z2|
  expect(get(var).send(attr)).to eq Tuple.point(x1.send(op_x, x2), y1.send(op_y, y2), z1.send(op_z, z2))
end

Then("{var}.{word}[{int}] = {point}") do |var, attr, idx, point|
  expect(get(var).send(attr.to_sym)[idx]).to eq point
end

Then("{var} = {point}") do |var, point|
  expect(get(var)).to eq point
end

Then("{var}.{word} = {point}") do |var, attr, point|
  expect(get(var).send(attr.to_sym)).to eq point
end

Then("{var}.{word}.{word} = {point}") do |var, attr, attr2, point|
  expect(get(var).send(attr.to_sym).send(attr2.to_sym)).to eq point
end
