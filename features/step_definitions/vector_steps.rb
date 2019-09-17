require 'tuple'

Given("{word} ← {vector}") do |var, vector|
  i_set(var, vector)
end

When("{word} ← normalize<{word}>") do |var1, var2|
  i_set(var1, i_get(var2).normalize)
end

Then("{word} - {word} = {vector}") do |var1, var2, vector|
  expect(i_get(var1) - i_get(var2)).to eq(vector)
end

Then("magnitude<{word}> = {number}") do |var, magnitude|
  expect(i_get(var).magnitude).to eq(magnitude)
end

Then("normalize<{word}> = {vector}") do |var, vector|
  expect(i_get(var).normalize).to eq(vector)
end

Then("normalize<{word}> = approximately {vector}") do |var, vector|
  vector_approximately_equal(i_get(var).normalize, vector)
end

Then("dot<{word}, {word}> = {int}") do |v1, v2, result|
  expect(i_get(v1).dot(i_get(v2))).to eq(result)
end

Then("cross<{word}, {word}> = {vector}") do |v1, v2, vector|
  expect(i_get(v1).cross(i_get(v2))).to eq(vector)
end
