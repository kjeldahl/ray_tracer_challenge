# frozen_string_literal: true

require 'camera'

World(IVarHelper)

Given("{var} ← {camera}") do |var, camera|
  set(var, camera)
end

When("{var} ← ray_for_pixel<{var}, {number}, {number}>") do |var, camera_var, x, y|
  set(var, get(camera_var).ray_for_pixel(x, y))
end

When("{var} ← camera<{var}, {var}, {var}>") do |var, var3, var4, var5|
  set(var, Camera.new(get(var3), get(var4), get(var5)))
end

When("{var} ← render<{var}, {var}>") do |var, camera_var, world_var|
  set(var, get(camera_var).render(get(world_var)))
end

Then("pixel_at<{var}, {int}, {int}> = {color}") do |image_var, x, y, color|
  expect(get(image_var).pixel_at(x, y)).to eq color
end