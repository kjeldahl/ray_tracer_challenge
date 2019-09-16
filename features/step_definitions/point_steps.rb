require 'tuple'

Given('p ← point<{number}, {number}, {number}>') do |x, y, z|
  @p = Tuple.point(x, y, z)
end

Given('p{int} ← point<{number}, {number}, {number}>') do |idx, x, y, z|
  @ps ||= []
  @ps[idx] = Tuple.point(x, y, z)
end

Then('p = tuple<{number}, {number}, {number}, {number}>') do |x, y, z, w|
  expect(@p).to eq(Tuple.build(x, y, z, w))
end

Then('p{int} - p{int} = vector<{number}, {number}, {number}>') do |idx1, idx2, x, y, z|
  expect(@ps[idx1] - @ps[idx2]).to eq(Tuple.vector(x, y, z))
end

Then('p - v = point<{number}, {number}, {number}>') do |x, y, z|
  expect(@p - @v).to eq(Tuple.point(x, y, z))
end