# frozen_string_literal: true

require 'intersection'
require 'my_matrix'
require 'shapes'

Before do
  set("identity_matrix", MyMatrix.identity)
  set("infinity", Float::INFINITY)
  set("test_cube", Cube.new)
  set("test_cylinder", Cylinder.new)
  set("test_cone", Cone.new)
  set("true", true)
  set("false", false)
  set("EPSILON", World::EPSILON)
end