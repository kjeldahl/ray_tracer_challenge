require 'shapes/group'

World(IVarHelper)

Given("{var} ← group<>") do |var|
  set(var, Group.new)
end

When("add_child<{var}, {var}>") do |group_var, child_var|
  get(group_var).add_child(get(child_var))
end

Then("{var} includes {var}") do |group_var, child_var|
  expect(get(group_var).include?(get(child_var))).to eq true
end

When("{var} ← {order_number} child of {var}") do |var, number, group_var|
  set(var, get(group_var).child_at(number))
end