require 'my_matrix'

World(IVarHelper)

Given("{var} ← {translation}") do |var, translation|
  set(var, translation)
end

Given("{var} ← {scaling}") do |var, scaling|
  set(var, scaling)
end

Given("{var} ← {rotation}") do |var, rotation|
  set(var, rotation)
end

Given("{var} ← {shearing}") do |var, shearing|
  set(var, shearing)
end

Given("{var} ← view_transform<{var}, {var}, {var}>") do |var, from, to, up|
  set(var, MyMatrix.view_transform(get(from), get(to), get(up)))
end

Given("{var}.transform ← view_transform<{var}, {var}, {var}>") do |var, from, to, up|
  get(var).transform = MyMatrix.view_transform(get(from), get(to), get(up))
end

When("{var}.{word} ← {rotation} {operator} {translation}") do |var, attr, rotation, operator, translation|
  get(var).send("#{attr}=", rotation.send(operator, translation))
end

When("{var} ← {scaling} {operator} {rotation}") do |var, scaling, operator, rotation|
  set(var, scaling.send(operator, rotation))
end

Then("{var} = {scaling}") do |var, scaling|
  expect(get(var)).to eq scaling
end

Then("{var} = {translation}") do |var, translation|
  expect(get(var)).to eq translation
end

Then("{var}.{word} = {translation}") do |var, attr, translation|
  expect(get(var).send(attr.to_sym)).to eq translation
end

