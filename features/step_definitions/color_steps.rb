require 'color'

module TupleHelper
  def color_approximately_equal(c1, c2)
    expect(c1.red).to be_within(0.0001).of(c2.red)
    expect(c1.green).to be_within(0.0001).of(c2.green)
    expect(c1.blue).to be_within(0.0001).of(c2.blue)
  end
end

World(TupleHelper)

Given('{word} ← {color}') do |var, color|
  i_set(var, color)
end

Then("{word}.{primary_color} = {number}") do |var, p_color, val|
  expect(i_get(var).send(p_color.to_sym)).to eq val
end

Then("{word} {operator} {word} = {color}") do |c1, operator, c2, color|
  expect(i_get(c1).send(operator, i_get(c2))).to eq color
end

Then("{word} {operator} {number} = {color}") do |c1, operator, scalar, color|
  expect(i_get(c1).send(operator, scalar)).to eq color
end

Then("{word} {operator} {word} = approximately {color}") do |c1, operator, c2, color|
  color_approximately_equal(i_get(c1).send(operator, i_get(c2)), color)
end

Then("{word} {operator} {number} = approximately {color}") do |c1, operator, scalar, color|
  color_approximately_equal(i_get(c1).send(operator, scalar), color)
end