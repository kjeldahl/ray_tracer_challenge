require 'my_matrix'

World(IVarHelper)

Given("{word} ← {translation}") do |var, translation|
  i_set(var, translation)
end

Given("{word} ← {scaling}") do |var, scaling|
  i_set(var, scaling)
end

And("{word} ← {rotation}") do |var, rotation|
  i_set(var, rotation)
end

Given("{word} ← {shearing}") do |var, shearing|
  i_set(var, shearing)
end