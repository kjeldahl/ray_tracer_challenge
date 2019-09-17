# frozen_string_literal: true

require 'tuple'

module TupleHelper
  def approximately_equal(v1, v2)
    expect(v1.x).to be_within(0.0001).of(v2.x)
    expect(v1.y).to be_within(0.0001).of(v2.y)
    expect(v1.z).to be_within(0.0001).of(v2.z)
  end

  def i_get(s)
    instance_variable_get("@#{s}")
  end

  def i_set(s, v)
    instance_variable_set("@#{s}", v)
  end
end

World(TupleHelper)

Given('{word} ← tuple<{number}, {number}, {number}, {number}>') do |var, x, y, z, w|
  i_set(var,  Tuple.build(x, y, z, w))
end

Then('{word} {operator} {word} = tuple<{number}, {number}, {number}, {number}>') do |var1, op, var2, x, y, z, w|
  expect(i_get(var1).send(op, i_get(var2))).to eq(Tuple.build(x, y, z, w))
end

Then('{word} {operator} {number} = tuple<{number}, {number}, {number}, {number}>') do |var, operator, scalar, x, y, z, w|
  expect(i_get(var).send(operator, scalar)).to eq(Tuple.build(x, y, z, w))
end

Then('-a = tuple<{number}, {number}, {number}, {number}>') do |x, y, z, w|
  expect(-@a).to eq(Tuple.build(x, y, z, w))
end

Then('a.{axis} = {number}') do |axis, float|
  expect(@a.send(axis)).to eq(float)
end

Then('a is a point') do
  expect(@a.point?).to eq(true)
end

Then('a is not a vector') do
  expect(@a.vector?).to eq(false)
end

Then('a is not a point') do
  expect(@a.point?).to eq(false)
end

Then('a is a vector') do
  expect(@a.vector?).to eq(true)
end

