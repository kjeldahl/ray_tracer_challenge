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

Then("{var} = {scaling}") do |var, scaling|
  expect(get(var)).to eq scaling
end

Then("{var} = {translation}") do |var, translation|
  expect(get(var)).to eq translation
end

