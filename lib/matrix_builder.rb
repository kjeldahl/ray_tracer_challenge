# frozen_string_literal: true

require 'my_matrix'
require 'tuple'

class MatrixBuilder
  def initialize
    @data = []
  end

  def []=(i, j, v)
    (@data[i] ||= [])[j] = v
  end

  def [](i, j)
    (@data[i] ||= [])[j]
  end

  def to_matrix(width, height)
    # TODO: Make sure dimensions fit and that empty fields are set to zero
    MyMatrix.new(width, height, @data)
  end

  def to_tuple(height)
    # TODO: Make sure dimensions fit and that empty fields are set to zero
    Tuple.build(*(0...height).to_a.map { |c| self[c, 0] })
  end
end
