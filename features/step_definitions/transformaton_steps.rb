require 'my_matrix'

World(IVarHelper)

Given("{var} ← {translation}") do |var, translation|
  i_set(var, translation)
end

Given("{var} ← {scaling}") do |var, scaling|
  i_set(var, scaling)
end

And("{var} ← {rotation}") do |var, rotation|
  i_set(var, rotation)
end

Given("{var} ← {shearing}") do |var, shearing|
  i_set(var, shearing)
end