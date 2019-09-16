# frozen_string_literal: true
ParameterType(
  name: 'number',
  regexp: /(√?[-+]?\d*(\.\d+)?)/,
  type: Numeric,
  transformer: lambda do |s|
    n = s.include?('.') ? Float(s.delete('√')) : Integer(s.delete('√'))
    s.include?('√') ? Math.sqrt(n) : n
  end
)

ParameterType(
  name: 'axis',
  regexp: /[xyzw]/,
  type: Symbol,
  transformer: ->(s) { s.to_sym }
)

ParameterType(
  name: 'operator',
  regexp: /[+\-*\/]/,
  type: Symbol,
  transformer: ->(s) { s.to_sym }
)
