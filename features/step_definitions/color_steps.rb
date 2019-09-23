require 'color'

module ColorHelper
  def color_approximately_equal(c1, c2)
    expect(c1.red).to be_within(0.0001).of(c2.red)
    expect(c1.green).to be_within(0.0001).of(c2.green)
    expect(c1.blue).to be_within(0.0001).of(c2.blue)
  end
end

World(ColorHelper)

Given('{var} ← {color}') do |var, color|
  set(var, color)
end

Then("{var} {operator} {var} = {color}") do |c1, operator, c2, color|
  expect(get(c1).send(operator, get(c2))).to eq color
end

Then("{var} {operator} {number} = {color}") do |c1, operator, scalar, color|
  expect(get(c1).send(operator, scalar)).to eq color
end

Then("{var} {operator} {var} = approximately {color}") do |c1, operator, c2, color|
  color_approximately_equal(get(c1).send(operator, get(c2)), color)
end

Then("{var} {operator} {number} = approximately {color}") do |c1, operator, scalar, color|
  color_approximately_equal(get(c1).send(operator, scalar), color)
end

Then('{var}.{word} = {color}') do |var, attr, color|
  expect(get(var).send(attr.to_sym)).to eq(color)
end

Then("{var} = {color}") do |var, color|
  expect(get(var)).to eq(color)
end

