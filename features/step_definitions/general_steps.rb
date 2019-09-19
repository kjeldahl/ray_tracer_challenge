Then('{var} = {var}') do |var1, var2|
  expect(i_get(var1)).to eq i_get(var2)
end

Then('{var} != {var}') do |var1, var2|
  expect(i_get(var1)).not_to eq i_get(var2)
end

Then('{var}.{word} = {number}') do |var, attr, number|
  expect(i_get(var).send(attr.to_sym)).to eq(number)
end

Then("{var}[{int}] = {number}") do |var, idx, result|
  expect(i_get(var)[idx]).to eq result
end

Then('{var}[{int},{int}] = {number}') do |var, x, y, result|
  expect(i_get(var).[](x, y)).to eq result
end

Then("{var}[{int}].{word} = {var}") do |var, idx, attr, result|
  expect(i_get(var)[idx].send(attr.to_sym)).to eq i_get(result)
end

Then("{var}[{int}].{word} = {number}") do |var, idx, attr, result|
  expect(i_get(var)[idx].send(attr.to_sym)).to eq result
end

Then("{var} is nothing") do |var|
  expect(i_get(var)).to be_nil
end

Then("{var} {operator} {var} = {var}") do |var1, operator, var2, var3|
  expect(i_get(var1).send(operator, i_get(var2))).to eq i_get(var3)
end

And("{var} ← {var} {operator} {var}") do |var1, var2, operator, var3|
  i_set(var1, i_get(var2).send(operator, i_get(var3)))
end

Then("{var}[{int},{int}] = {number}{operator}{number}") do |var, i, j, counter, operator, quotient|
  expect(i_get(var).[](i, j)).to eq counter.send(operator, quotient)
end

Then('{var}.{word} = {var}') do |var, attr, var2|
  expect(i_get(var).send(attr.to_sym)).to eq(i_get(var2))
end

