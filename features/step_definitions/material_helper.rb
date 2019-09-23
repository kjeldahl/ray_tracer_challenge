require 'material'

Given("{var} ← material<>") do |var|
  set(var, Material.default)
end

Then("{var} = material<>") do |var|
  expect(get(var)).to eq(Material.default)
end