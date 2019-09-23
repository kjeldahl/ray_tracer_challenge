require 'my_matrix'

World(IVarHelper)

Given("{var} ← {translation}") do |var, translation|
  set(var, translation)
end

Given("{var} ← {scaling}") do |var, scaling|
  set(var, scaling)
end

And("{var} ← {rotation}") do |var, rotation|
  set(var, rotation)
end

Given("{var} ← {shearing}") do |var, shearing|
  set(var, shearing)
end