# frozen_string_literal: true

require 'canvas'
require 'color'
require 'my_matrix'
require 'tuple'

NUMBER_REGEXP = '(√?[-+]?(\\d+(\\.\\d+)?|\\.\\d+))' # Must have capture group on entire expression

# Converts a string matched by NUMBER_REGEXP to either an Integer or a Float
def aton(s)
  nn = s.delete('√')
  nn = nn == '' ? 0 : nn
  n  = Float(nn)
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
  regexp: %r{[+\-*/]},
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

ParameterType(
  name: 'translation',
  regexp: /translation<#{NUMBER_REGEXP}, #{NUMBER_REGEXP}, #{NUMBER_REGEXP}>/,
  type: MyMatrix,
  transformer: ->(x, y, z) { MyMatrix.translation(aton(x), aton(y), aton(z)) }
)

ParameterType(
  name: 'scaling',
  regexp: /scaling<#{NUMBER_REGEXP}, #{NUMBER_REGEXP}, #{NUMBER_REGEXP}>/,
  type: MyMatrix,
  transformer: ->(x, y, z) { MyMatrix.scaling(aton(x), aton(y), aton(z)) }
)

ParameterType(
  name: 'rotation',
  regexp: /rotation_([xyz])<π \/ #{NUMBER_REGEXP}>/,
  type: MyMatrix,
  transformer: ->(axis, radi) { MyMatrix.send("rotation_#{axis}".to_sym, Math::PI / aton(radi)) }
)

ParameterType(
  name: 'shearing',
  regexp: /shearing<#{NUMBER_REGEXP}, #{NUMBER_REGEXP}, #{NUMBER_REGEXP}, #{NUMBER_REGEXP}, #{NUMBER_REGEXP}, #{NUMBER_REGEXP}>/,
  type: MyMatrix,
  transformer: ->(xy, xz, yx, yz, zx, zy) { MyMatrix.shearing(aton(xy), aton(xz), aton(yx), aton(yz), aton(zx), aton(zy)) }
)
