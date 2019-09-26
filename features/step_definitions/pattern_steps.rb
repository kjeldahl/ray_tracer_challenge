# frozen_string_literal: true

require 'color'
require 'gradient_pattern'
require 'stripe_pattern'
require 'ring_pattern'

# Helper for scenarios that reference the colors as a and b
class StripePattern
  def a
    @color1
  end

  def b
    @color2
  end

  alias_method(:stripe_at, :pattern_at)
  alias_method(:stripe_at_object, :pattern_at_shape)

end

class Pattern
  alias_method(:pattern_at_object, :pattern_at_shape)
end

class TestPattern < Pattern
  def pattern_at(local_point)
    Color.new(local_point.x, local_point.y, local_point.z)
  end

end

World(IVarHelper)

Given("{var} ← stripe_pattern<{var}, {var}>") do |var, color1_var, color2_var|
  set(var, StripePattern.new(get(color1_var), get(color2_var)))
end

Given("{var} ← stripe_pattern<{color}, {color}>") do |var, color1, color2|
  set(var, StripePattern.new(color1, color2))
end

Given("{var}.{word} ← stripe_pattern<{color}, {color}>") do |var, attr, color1, color2|
  get(var).send("#{attr}=".to_sym, StripePattern.new(color1, color2))
end

Given("{var} ← test_pattern<>") do |var|
  set(var, TestPattern.new)
end

Given("{var} ← gradient_pattern<{var}, {var}>") do |var, var1, var2 |
  set(var, GradientPattern.new(get(var1), get(var2)))
end

Given("{var} ← ring_pattern<{var}, {var}>") do |var, var1, var2 |
  set(var, RingPattern.new(get(var1), get(var2)))
end

When("{var} ← stripe_at_object<{var}, {var}, {point}>") do |var, pattern_var, object_var, point|
  set(var, get(pattern_var).stripe_at_object(get(object_var), point))
end

When("{var} ← pattern_at_shape<{var}, {var}, {point}>") do |var, pattern_var, object_var, point|
  set(var, get(pattern_var).pattern_at_shape(get(object_var), point))
end

When("set_pattern_transform<{var}, {scaling}>") do |pattern_var, transform|
  get(pattern_var).transform = transform
end

When("set_pattern_transform<{var}, {translation}>") do |pattern_var, transform|
  get(pattern_var).transform = transform
end

Then("stripe_at<{var}, {point}> = {var}") do |pattern_var,point, color_var|
  expect(get(pattern_var).stripe_at(point)).to eq get(color_var)
end

Then("pattern_at<{var}, {point}> = {var}") do |pattern_var, point, color_var|
  expect(get(pattern_var).pattern_at(point)).to eq get(color_var)
  end

Then("pattern_at<{var}, {point}> = {color}") do |pattern_var, point, color|
  expect(get(pattern_var).pattern_at(point)).to eq color
end