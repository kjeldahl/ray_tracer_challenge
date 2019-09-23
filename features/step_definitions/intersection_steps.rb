# frozen_string_literal: true

require 'intersection'
require 'intersections'

World(IVarHelper)

Given("{var} ← intersection<{number}, {var}>") do |var, t, param|
  set(var, Intersection.new(t, get(param)))
end

Given("{var} ← intersections<{var}, {var}>") do |var, param1, param2|
  set(var, Intersections.new(get(param1), get(param2)))
end

Given("{var} ← intersections<{var}, {var}, {var}, {var}>") do |var, param1, param2, param3, param4|
  set(var, Intersections.new(get(param1), get(param2), get(param3), get(param4)))
end

When("{var} ← hit<{var}>") do |var, var2|
  set(var, get(var2).hit)
end