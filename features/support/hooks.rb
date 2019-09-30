# frozen_string_literal: true

require 'intersection'
require 'my_matrix'
require 'shapes'

Before do
  set("identity_matrix", MyMatrix.identity)
  set("test_cube", Cube.new)
  set("true", true)
  set("false", false)
  set("EPSILON", World::EPSILON)
end