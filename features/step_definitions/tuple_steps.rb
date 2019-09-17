# frozen_string_literal: true

require 'tuple'

module TupleHelper
  def vector_approximately_equal(v1, v2)
    expect(v1.x).to be_within(0.0001).of(v2.x)
    expect(v1.y).to be_within(0.0001).of(v2.y)
    expect(v1.z).to be_within(0.0001).of(v2.z)
  end
end

World(TupleHelper)
World(IVarHelper)

Given('{word} ← {tuple}') do |var, tuple|
  i_set(var,  tuple)
end

Then('{word} {operator} {word} = {tuple}') do |var1, op, var2, tuple|
  expect(i_get(var1).send(op, i_get(var2))).to eq(tuple)
end

Then('{word} {operator} {number} = {tuple}') do |var, operator, scalar, tuple|
  expect(i_get(var).send(operator, scalar)).to eq(tuple)
end

Then('-{word} = {tuple}') do |var, tuple|
  expect(-i_get(var)).to eq(tuple)
end

Then('{word} = {tuple}') do |var, tuple|
  expect(i_get(var)).to eq(tuple)
end

Then('{word}.{axis} = {number}') do |var, axis, float|
  expect(i_get(var).send(axis)).to eq(float)
end

Then('{word} is a point') do |var|
  expect(i_get(var).point?).to eq(true)
end

Then('{word} is not a vector') do |var|
  expect(i_get(var).vector?).to eq(false)
end

Then('{word} is not a point') do |var|
  expect(i_get(var).point?).to eq(false)
end

Then('{word} is a vector') do |var|
  expect(i_get(var).vector?).to eq(true)
end

