# frozen_string_literal: true

require 'intersection'
require 'intersections'

World(IVarHelper)

Given("{var} ← intersection<{number}, {var}>") do |var, t, param|
  i_set(var, Intersection.new(t, i_get(param)))
end

Given("{var} ← intersections<{var}, {var}>") do |var, param1, param2|
  i_set(var, Intersections.new(i_get(param1), i_get(param2)))
end

Given("{var} ← intersections<{var}, {var}, {var}, {var}>") do |var, param1, param2, param3, param4|
  i_set(var, Intersections.new(i_get(param1), i_get(param2), i_get(param3), i_get(param4)))
end

When("{var} ← hit<{var}>") do |var, var2|
  i_set(var, i_get(var2).hit)
end