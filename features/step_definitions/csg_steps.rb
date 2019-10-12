require 'shapes/csg'

World(IVarHelper)

Given("{var} ← csg<{csg_op}, {sphere}, {cube}>") do |var, csg_op, sphere, cube|
  set(var, CSG.new(sphere, csg_op, cube))
end

When("{var} ← csg<{csg_op}, {var}, {var}>") do |var, op, left_var, right_var|
  set(var, CSG.new(get(left_var), op, get(right_var)))
end

When("{var} ← intersection_allowed<{csg_op}, {bool}, {bool}, {bool}>") do |var, csg_op, lhit, inl, inr|
  set(var, CSG.intersection_allowed(csg_op, lhit, inl, inr))
end

When("{var} ← filter_intersections<{var}, {var}>") do |var, csg_var, intersections_var|
  set(var, get(csg_var).filter_intersections(get(intersections_var)))
end

Then("{var}.{word} = {csg_op}") do |var, attr, csg_op|
  expect(get(var).send(attr.to_sym)).to eq csg_op
end