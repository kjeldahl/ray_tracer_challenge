Given("{var}.{var}.{var} ← {number}") do |var, attr1, attr2, number|
  get(var).send(attr1.to_sym).send("#{attr2}=", number)
end

Given("{var} ← {int}") do |var, int|
  set(var, int)
end

Given("{var} ← {var}") do |var, var2|
  set(var, get(var2))
end

Given("{var} ← π{operator}{int}") do |var1, operator, var3|
  set(var1, Math::PI.send(operator, var3))
end

When("{var} ← {var} {operator} {var}") do |var1, var2, operator, var3|
  set(var1, get(var2).send(operator, get(var3)))
end

When("{var} ← {var}.{word}") do |var1, var2, attr|
  set(var1, get(var2).send(attr.to_sym))
end

When("{var}.{word} ← {var}") do |var1, attr, var2|
  get(var1).send("#{attr}=".to_sym, get(var2))
end

When("{var}.{word} ← {number}") do |var1, attr, num|
  get(var1).send("#{attr}=".to_sym, num)
end

Then('{var} = {var}') do |var1, var2|
  expect(get(var1)).to eq get(var2)
end

Then('{var} != {var}') do |var1, var2|
  expect(get(var1)).not_to eq get(var2)
end

Then('{var}.{word} = {number}') do |var, attr, number|
  expect(get(var).send(attr.to_sym)).to eq(number)
end

Then("{var}.{word} = π{operator}{number}") do |var, attr, operator, number|
  expect(get(var).send(attr.to_sym)).to eq(Math::PI.send(operator, number))
end

Then("{var}[{int}] = {number}") do |var, idx, result|
  expect(get(var)[idx]).to eq result
end

Then('{var}[{int},{int}] = {number}') do |var, x, y, result|
  expect(get(var).[](x, y)).to eq result
end

Then("{var}[{int}].{word} = {var}") do |var, idx, attr, result|
  expect(get(var)[idx].send(attr.to_sym)).to eq get(result)
end

Then("{var}[{int}].{word} = {number}") do |var, idx, attr, result|
  expect(get(var)[idx].send(attr.to_sym)).to eq result
end

Then("{var} is nothing") do |var|
  expect(get(var)).to be_nil
end

Then("{var} {operator} {var} = {var}") do |var1, operator, var2, var3|
  expect(get(var1).send(operator, get(var2))).to eq get(var3)
end

Then("{var} = {number}") do |var, number|
  expect(get(var).round(4)).to eq number.round(4)
end

Then("{var}[{int},{int}] = {number}{operator}{number}") do |var, i, j, counter, operator, quotient|
  expect(get(var).[](i, j)).to eq counter.send(operator, quotient)
end

Then('{var}.{word} = {var}') do |var, attr, var2|
  expect(get(var).send(attr.to_sym)).to eq(get(var2))
end

Then("{var}.{word} = {var}.{word}") do |var1, attr1, var2, attr2|
  expect(get(var1).send(attr1.to_sym)).to eq get(var2).send(attr2.to_sym)
end

Then("{var} = {var}.{var}.{var}") do |var, var2, attr1, attr2|
  expect(get(var)).to eq get(var2).send(attr1.to_sym).send(attr2.to_sym)
end

Then("{var}.{word}.{word} < {var}{operator}{number}") do |var, attr1, attr2, var4, operator, number|
  expect(get(var).send(attr1.to_sym).send(attr2.to_sym)).to be < get(var4).send(operator, number)
end

Then("{var}.{word}.{word} = {number}") do |var, attr1, attr2, number|
  expect(get(var).send(attr1.to_sym).send(attr2.to_sym)).to eq number
end

Then("{var}.{word}.{word} < {var}.{word}.{word}") do |var, attr1, attr2, var4, attr3, attr4|
  expect(get(var).send(attr1.to_sym).send(attr2.to_sym)).to be < get(var4).send(attr3.to_sym).send(attr4.to_sym)
end

Then("{var}.{word}.{word} > {var}{operator}{number}") do |var, attr1, attr2, var4, operator, number|
  expect(get(var).send(attr1.to_sym).send(attr2.to_sym)).to be > get(var4).send(operator, number)
end

Then("{var}.{word}.{word} > {var}.{word}.{word}") do |var, attr1, attr2, var4, attr3, attr4|
  expect(get(var).send(attr1.to_sym).send(attr2.to_sym)).to be > get(var4).send(attr3.to_sym).send(attr4.to_sym)
end

Then("{var} is empty") do |var|
  expect(get(var)).to be_empty
end