# frozen_string_literal: true

require 'tuple'

module ApproximationHelper
  def approximately_equal(v1, v2)
    expect(v1.x).to be_within(0.0001).of(v2.x)
    expect(v1.y).to be_within(0.0001).of(v2.y)
    expect(v1.z).to be_within(0.0001).of(v2.z)
  end
end

World(ApproximationHelper)

Given('a ← tuple<{number}, {number}, {number}, {number}>') do |x, y, z, w|
  @a = Tuple.build(x, y, z, w)
end

Given('a{int} ← tuple<{number}, {number}, {number}, {number}>') do |idx, x, y, z, w|
  @as ||= []
  @as[idx] = Tuple.build(x, y, z, w)
end

Then('a{int} + a{int} = tuple<{number}, {number}, {number}, {number}>') do |idx1, idx2, x, y, z, w|
  expect(@as[idx1] + @as[idx2]).to eq(Tuple.build(x, y, z, w))
end

Then('a{int} - a{int} = tuple<{number}, {number}, {number}, {number}>') do |idx1, idx2, x, y, z, w|
  expect(@as[idx1] - @as[idx2]).to eq(Tuple.build(x, y, z, w))
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

Then('a {operator} {number} = tuple<{number}, {number}, {number}, {number}>') do |operator, scalar, x, y, z, w|
  expect(@a.send(operator, scalar)).to eq(Tuple.build(x, y, z, w))
end
