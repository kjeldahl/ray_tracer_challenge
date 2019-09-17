# frozen_string_literal: true

require 'matrix_builder'
require 'tuple'

class MyMatrix
  attr_reader :width, :height

  class << self
    def identity(size = 4)
      raise 'Only 4x4 identity supported' unless size == 4

      (@identities ||= [])[size] = MyMatrix.new(size, size, [
                                                  [1.0, 0.0, 0.0, 0.0],
                                                  [0.0, 1.0, 0.0, 0.0],
                                                  [0.0, 0.0, 1.0, 0.0],
                                                  [0.0, 0.0, 0.0, 1.0]
                                                ])
    end
  end

  def initialize(width, height, data)
    @width  = width
    @height = height
    @data   = data
  end

  def [](i, j)
    raise if i < 0 || width <= i
    raise if j < 0 || height <= j

    @data[i][j]
  end

  def transpose
    mb = MatrixBuilder.new
    (0...height).each do |i|
      (0...width).each do |j|
        mb[i, j] = self[j, i]
      end
    end
    mb.to_matrix(height, width) # Height and width are switched on purpose
  end

  def determinant
    # PERF: Cache this value
    if height == 2 && width == 2
      self[0, 0] * self[1, 1] - self[0, 1] * self[1, 0]
    else
      (0...width).sum do |j|
        self[0, j] * cofactor(0, j)
      end
    end
  end

  def submatrix(row, column)
    mb = MatrixBuilder.new

    ii = 0
    (0...height).each do |i|
      next if i == row

      jj = 0
      (0...width).each do |j|
        next if j == column

        mb[ii, jj] = self[i, j]
        jj += 1
      end
      ii += 1
    end

    mb.to_matrix(width - 1, height - 1)
  end

  def minor(row, column)
    # PERF: Probably no need to actually calculate the submatrix
    submatrix(row, column).determinant
  end

  def cofactor(row, column)
    minor(row, column) * ((row + column).odd? ? -1 : 1)
  end

  def invertible?
    determinant != 0
  end

  def inverse
    raise "Cannot invert non-invertible matrix" unless invertible?

    mb = MatrixBuilder.new
    (0...height).each do |i|
      (0...width).each do |j|
        c = cofactor(i, j)
        mb[j, i] = c / determinant
      end
    end

    mb.to_matrix(width, height)
  end

  def *(other)
    case other
    when MyMatrix
      raise('Can only multiply 4x4 matrices') unless [4] * 4 == [height, width, other.height, other.width]

      mb = MatrixBuilder.new
      (0...height).each do |i|
        (0...width).each do |j|
          v = 0
          (0...4).each do |c|
            v += self[i, c] * other[c, j]
          end

          mb[i, j] = v
        end
      end
      mb.to_matrix(width, height)
    when Tuple
      mb = MatrixBuilder.new
      (0...height).each do |i|
        (0...1).each do |j|
          v = 0
          (0...4).each do |c|
            v += self[i, c] * other[c]
          end

          mb[i, j] = v
        end
      end
      mb.to_tuple(height)

    else
      raise "Cannot multiply Tuple with #{other.class}"
    end
  end

  def ==(other)
    other.class == self.class &&
      other.width == @width &&
      other.height == @height &&
      (0...width).all? do |i|
        (0...height).all? do |j|
          self[i, j].round(5) == other[i, j].round(5)
        end
      end
  end

  alias eql? ==

  def hash
    @hash ||= data.hash
  end

  protected

  attr_reader :data
end
