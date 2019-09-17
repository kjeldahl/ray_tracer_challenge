# frozen_string_literal: true
require 'canvas'
require 'color'
require 'tuple'

NUMBER_REGEXP = "(√?[-+]?(\\d+(\\.\\d+)?|\\.\\d+))" # Must have capture group on entire expression

# Converts a string matched by NUMBER_REGEXP to either an Integer or a Float
def aton(s)
  nn = s.delete('√')
  nn = nn == "" ? 0 : nn
  n = Float(nn)
  s.include?('√') ? Math.sqrt(n) : n
end

ParameterType(
  name: 'number',
  regexp: /#{NUMBER_REGEXP}/,
  type: Numeric,
  transformer: ->(s) { aton(s) }
)

ParameterType(
  name: 'axis',
  regexp: /[xyzw]/,
  type: Symbol,
  use_for_snippets: false,
  transformer: ->(s) { s.to_sym }
)

ParameterType(
  name: 'operator',
  regexp: /[+\-*\/]/,
  type: Symbol,
  transformer: ->(s) { s.to_sym }
)

ParameterType(
  name: 'primary_color',
  regexp: /red|green|blue/,
  type: Symbol,
  transformer: ->(s) { s.to_sym }
)

ParameterType(
  name: 'color',
  regexp: /color<#{NUMBER_REGEXP}, #{NUMBER_REGEXP}, #{NUMBER_REGEXP}>/,
  type: Color,
  transformer: ->(red, green, blue) { Color.new(aton(red), aton(green), aton(blue)) }
)

ParameterType(
  name: 'vector',
  regexp: /vector<#{NUMBER_REGEXP}, #{NUMBER_REGEXP}, #{NUMBER_REGEXP}>/,
  type: Tuple,
  transformer: ->(x, y, z) { Tuple.vector(aton(x), aton(y), aton(z)) }
)

ParameterType(
  name: 'point',
  regexp: /point<#{NUMBER_REGEXP}, #{NUMBER_REGEXP}, #{NUMBER_REGEXP}>/,
  type: Tuple,
  transformer: ->(x, y, z) { Tuple.point(aton(x), aton(y), aton(z)) }
)

ParameterType(
  name: 'tuple',
  regexp: /tuple<#{NUMBER_REGEXP}, #{NUMBER_REGEXP}, #{NUMBER_REGEXP}, #{NUMBER_REGEXP}>/,
  type: Tuple,
  transformer: ->(x, y, z, w) { Tuple.new(aton(x), aton(y), aton(z), aton(w)) }
)

ParameterType(
  name: 'canvas',
  regexp: /canvas<(\d+), (\d+)>/,
  type: Canvas,
  transformer: ->(width, height) { Canvas.new(Integer(width), Integer(height)) }
)
