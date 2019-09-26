require 'scene/material'

World(IVarHelper)

module MaterialHelper
  def default_material
    Material.new
  end
end
World(MaterialHelper)

Given("{var} ← material<>") do |var|
  set(var, default_material)
end

Then("{var} = material<>") do |var|
  expect(get(var)).to eq(default_material)
end