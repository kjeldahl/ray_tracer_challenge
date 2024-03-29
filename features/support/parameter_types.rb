# frozen_string_literal: true

require 'scene'
require 'color'
require 'my_matrix'
require 'tuple'
require 'shapes'

NUMBER_REGEXP = '((-?√?[-+]?(\\d+(\\.\\d+)?|\\.\\d+))|-?∞)' # Must have capture group on entire expression

# Converts a string matched by NUMBER_REGEXP to either an Integer or a Float
def aton(s)
  neg = s[0] == "-"
  s = s.slice(neg ? 1 : 0, s.length)
  nn = s.delete('√')
  nn = nn == '' ? 0 : nn
  if nn == "∞"
    neg ? -Float::INFINITY : Float::INFINITY
  else
    n  = Float(nn)
    (s.include?('√') ? Math.sqrt(n) : n) * (neg ? -1 : 1)
  end
end

ParameterType(
  name: 'attr',
  regexp: /[a-zA-Z][a-zA-Z_\d]*/,
  type: Symbol,
  use_for_snippets: false,
  transformer: ->(s) { s.to_sym }
)

ParameterType(
  name: 'var',
  regexp: /[a-zA-Z][a-zA-Z_\d]*/,
  type: String,
  transformer: ->(s) { s }
)

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
  name: 'camera',
  regexp: /camera<(\d+), (\d+), π\/(\d+)>/,
  type: Camera,
  transformer: ->(hsize, vsize, fov) { Camera.new(Integer(hsize), Integer(vsize), Math::PI/Float(fov)) }
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
  regexp: /rotation_([xyz])<π ?\/ ?#{NUMBER_REGEXP}>/,
  type: MyMatrix,
  transformer: ->(axis, radi) { MyMatrix.rotate(axis.to_sym, Math::PI / aton(radi)) }
)

ParameterType(
  name: 'shearing',
  regexp: /shearing<#{NUMBER_REGEXP}, #{NUMBER_REGEXP}, #{NUMBER_REGEXP}, #{NUMBER_REGEXP}, #{NUMBER_REGEXP}, #{NUMBER_REGEXP}>/,
  type: MyMatrix,
  transformer: ->(xy, xz, yx, yz, zx, zy) { MyMatrix.shearing(aton(xy), aton(xz), aton(yx), aton(yz), aton(zx), aton(zy)) }
)

ParameterType(
  name: 'sphere',
  regexp: /sphere<>/,
  type: Sphere,
  transformer: ->(s) { Sphere.new }
)

ParameterType(
  name: 'cube',
  regexp: /cube<>/,
  type: Cube,
  transformer: ->(s) { Cube.new }
)

ParameterType(
  name: 'glass_sphere',
  regexp: /glass_sphere<>/,
  type: Sphere,
  transformer: ->(s) { Sphere.new(material: Material.new(transparency: 1.0, refractive_index: 1.5)) }
)

ParameterType(
  name: 'order_number',
  regexp: /first|second|third/,
  type: Integer,
  transformer: ->(number) do
    {"first": 1, "second": 2, "third": 3}[number.to_sym]
  end
)

ParameterType(
  name: 'csg_op',
  regexp: /"(union|intersection|difference)"/,
  type: Symbol,
  transformer: ->(op) { op.to_sym }
)

ParameterType(
  name: 'bool',
  regexp: /true|false/,
  type: Object,
  transformer: ->(bool) { bool == "true" }
)

