require 'material'

Given("{var} ← material<>") do |var|
  i_set(var, Material.default)
end

Then("{var} = material<>") do |var|
  expect(i_get(var)).to eq(Material.default)
end