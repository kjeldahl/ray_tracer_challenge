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

Given("{var} ← intersections<{var}>") do |var, param1|
  set(var, Intersections.new(get(param1)))
end

Given("{var} ← intersections<{var}, {var}, {var}, {var}>") do |var, param1, param2, param3, param4|
  set(var, Intersections.new(get(param1), get(param2), get(param3), get(param4)))
end

And("{var} ← intersections<{number}:{var}, {number}:{var}, {number}:{var}, {number}:{var}, {number}:{var}, {number}:{var}>") do |var, number2, var2, number3, var3, number4, var4, number5, var5, number6, var6, number7, var7|
  set(var,
      Intersections.new(Intersection.new(number2, get(var2)),
                        Intersection.new(number3, get(var3)),
                        Intersection.new(number4, get(var4)),
                        Intersection.new(number5, get(var5)),
                        Intersection.new(number6, get(var6)),
                        Intersection.new(number7, get(var7))
                       ))
end

And("{var} ← intersections<{number}:{var}, {number}:{var}>") do |var, number2, var2, number3, var3|
  set(var,
      Intersections.new(Intersection.new(number2, get(var2)),
                        Intersection.new(number3, get(var3))
                       ))
end

And("{var} ← intersections<{number}:{var}>") do |var, number2, var2|
  set(var,
      Intersections.new(Intersection.new(number2, get(var2))))
end

And("{var} ← intersections<{number}:{var}, {number}:{var}, {number}:{var}, {number}:{var}>") do |var, number2, var2, number3, var3, number4, var4, number5, var5|
  set(var,
      Intersections.new(Intersection.new(number2, get(var2)),
                        Intersection.new(number3, get(var3)),
                        Intersection.new(number4, get(var4)),
                        Intersection.new(number5, get(var5))
                       ))
end

And("{var} ← intersections<{number}{operator}{number}:{var}, {number}{operator}{number}:{var}>") do |var, num1_1, op_1, num1_2, var1, num2_1, op_2, num2_2, var2|
  set(var,
      Intersections.new(Intersection.new(num1_1.send(op_1, num1_2), get(var1)),
                        Intersection.new(num1_2.send(op_2, num2_2), get(var2))
                       ))
end

When("{var} ← intersection_with_uv<{number}, {var}, {number}, {number}>") do |var, number, var3, number2, number3|
  set(var, Intersection.new(number, get(var3), u: number2, v: number3))
end

When("{var} ← hit<{var}>") do |var, var2|
  set(var, get(var2).hit)
end

When("{var} ← prepare_computations<{var}, {var}>") do |var, intersection_var, ray_var|
  set(var, get(intersection_var).precompute(get(ray_var)))
end

When("{var} ← prepare_computations<{var}[{int}], {var}, {var}>") do |var, intersections_var, index, ray_var, intersections_var2|
  set(var, get(intersections_var)[index].precompute(get(ray_var), get(intersections_var2)))
end

When("{var} ← prepare_computations<{var}, {var}, {var}>") do |var, intersections_var, ray_var, intersections_var2|
  set(var, get(intersections_var).precompute(get(ray_var), get(intersections_var2)))
end

When("{var} ← schlick<{var}>") do |var, comps_var|
  set(var, get(comps_var).schlick)
end