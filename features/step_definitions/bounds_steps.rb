require 'bounds'

World(IVarHelper)

Given("{var} ← bounds<point<{number},{number},{number}>, point<{number},{number},{number}>>") do |var, number, number2, number3, number4, number5, number6|
  set(var, Bounds.new(Tuple.point(number, number2, number3), Tuple.point(number4, number5, number6)))
end

When("{var} ← bounds<{var}, {var}>") do |var, min_var, max_var|
  set(var, Bounds.new(get(min_var), get(max_var)))
end

When("{var} ← {var}.transform<{var}>") do |var, bounds_var, transformation_var|
  set(var, get(bounds_var).transform(get(transformation_var)))
end

When("{var} ← bounds_of_bounds<{var}, {var}>") do |var, bounds_var1, bounds_var2|
  set(var, Bounds.bounds_of_bounds(get(bounds_var1), get(bounds_var2)))
end