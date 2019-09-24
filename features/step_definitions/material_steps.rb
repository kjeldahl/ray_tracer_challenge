require 'material'

World(IVarHelper)

module MaterialHelper
  def default_material
    Material.new
  end
end
World(MaterialHelper)

Given("{var} ← material<>") do |var|
  set(var, Material.default)
end

Then("{var} = material<>") do |var|
  expect(get(var)).to eq(Material.default)
end