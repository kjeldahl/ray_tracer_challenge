require 'tuple'

Given('{word} ← {point}') do |var, point|
  i_set(var, point)
end

Then('{word} {operator} {word} = {point}') do |var1, op, var2, point|
  expect(i_get(var1).send(op, i_get(var2))).to eq(point)
end