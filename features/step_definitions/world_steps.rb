require 'world'

World(IVarHelper)

module WorldHelper
  def default_world
    world = World.new(light: PointLight.new(Tuple.point(-10.0, 10.0, -10.0), Color::WHITE))
    world.objects << Sphere.new(material: Material.new(color: Color.new(0.8, 1.0, 0.6),
                                                       diffuse: 0.7,
                                                       specular: 0.2))
    world.objects << Sphere.new(transform: MyMatrix.scale(0.5, 0.5, 0.5))
    world
  end
end

World(WorldHelper)

Given("{var} ← world<>") do |var|
  set(var, World.new)
end

When("{var} ← default_world<>") do |var|
  set(var, default_world)
end

When("{var} ← intersect_world<{var}, {var}>") do |var, world_var, ray_var|
  set(var, get(world_var).intersect(get(ray_var)))
end

When("{var} ← the first object in {var}") do |var, world_var|
  set(var, get(world_var).objects.first)
end

When("{var} ← the second object in {var}") do |var, world_var|
  set(var, get(world_var).objects[1])
end

When("{var} ← shade_hit<{var}, {var}>") do |var, world_var, comps_var|
  set(var, get(world_var).shade_hit(get(comps_var)))
end

When("{var} ← color_at<{var}, {var}>") do |var, world_var, ray_var|
  set(var, get(world_var).color_at(get(ray_var)))
end

Then("{var} contains no objects") do |var|
  expect(get(var).objects).to be_empty
end

Then("{var} contains {var}") do |var, object_var|
  expect(get(var).objects).to include(get(object_var))
end

Then("{var} has no light source") do |var|
  expect(get(var).light).to be_nil
end
