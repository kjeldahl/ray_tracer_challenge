require 'tuple'

Given('{word} ← point<{number}, {number}, {number}>') do |var, x, y, z|
  i_set(var,  Tuple.point(x, y, z))
end

Then('p = tuple<{number}, {number}, {number}, {number}>') do |x, y, z, w|
  expect(@p).to eq(Tuple.build(x, y, z, w))
end

Then('p - v = point<{number}, {number}, {number}>') do |x, y, z|
  expect(@p - @v).to eq(Tuple.point(x, y, z))
end