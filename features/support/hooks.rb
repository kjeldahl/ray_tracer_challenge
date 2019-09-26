# frozen_string_literal: true

require 'intersection'
require 'my_matrix'

Before do
  set("identity_matrix", MyMatrix.identity)
  set("true", true)
  set("false", false)
  set("EPSILON", World::EPSILON)
end