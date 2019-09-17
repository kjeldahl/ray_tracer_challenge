# frozen_string_literal: true
require 'color'
NUMBER_REGEXP = "(√?[-+]?\\d*(\\.\\d+)?)" # Must have capture group on entire expression

# Converts a string matched by NUMBER_REGEXP to either an Integer or a Float
def aton(s)
  n = s.include?('.') ? Float(s.delete('√')) : Integer(s.delete('√'))
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
