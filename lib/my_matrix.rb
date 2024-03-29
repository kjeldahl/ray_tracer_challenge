# frozen_string_literal: true

require 'call_statistics'
require 'matrix_builder'
require 'tuple'

class MyMatrix
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

    # region Tranformation Methods
    def translation(x, y, z)
      MyMatrix.new(4, 4, [
        [1.0, 0.0, 0.0, x],
        [0.0, 1.0, 0.0, y],
        [0.0, 0.0, 1.0, z],
        [0.0, 0.0, 0.0, 1.0]
      ])
    end

    def scaling(x, y, z)
      MyMatrix.new(4, 4, [
        [x, 0.0, 0.0, 0.0],
        [0.0, y, 0.0, 0.0],
        [0.0, 0.0, z, 0.0],
        [0.0, 0.0, 0.0, 1.0]
      ])
    end

    def rotation_x(radi)
      MyMatrix.new(4, 4, [
        [1.0, 0.0, 0.0, 0.0],
        [0.0, Math.cos(radi), -Math.sin(radi), 0.0],
        [0.0, Math.sin(radi), Math.cos(radi), 0.0],
        [0.0, 0.0, 0.0, 1.0]
      ])
    end

    def rotation_y(radi)
      MyMatrix.new(4, 4, [
        [Math.cos(radi), 0.0, Math.sin(radi), 0.0],
        [0.0, 1.0, 0.0, 0.0],
        [-Math.sin(radi), 0.0, Math.cos(radi), 0.0],
        [0.0, 0.0, 0.0, 1.0]
      ])
    end

    def rotation_z(radi)
      MyMatrix.new(4, 4, [
        [Math.cos(radi), -Math.sin(radi), 0.0, 0.0],
        [Math.sin(radi), Math.cos(radi), 0.0, 0.0],
        [0.0, 0.0, 1.0, 0.0],
        [0.0, 0.0, 0.0, 1.0]
      ])
    end

    def rotation(axis, radi)
      case axis
        when :x
          rotation_x(radi)
        when :y
          rotation_y(radi)
        when :z
          rotation_z(radi)
        else
          raise "Unknown axis: '#{axis}'"
      end
    end

    def shearing(xy, xz, yx, yz, zx, zy)
      MyMatrix.new(4, 4, [
        [1.0,  xy,  xz, 0.0],
        [ yx, 1.0,  yz, 0.0],
        [ zx,  zy, 1.0, 0.0],
        [0.0, 0.0, 0.0, 1.0]
      ])
    end

    def view_transform(from, to, up)
      forward = (to - from).normalize
      left = forward.cross(up.normalize)
      true_up = left.cross(forward)

      view =
        MyMatrix.new(4, 4, [
          [    left.x,     left.y,     left.z, 0.0],
          [ true_up.x,  true_up.y,  true_up.z, 0.0],
          [-forward.x, -forward.y, -forward.z, 0.0],
          [       0.0,        0.0,        0.0, 1.0]
        ])

      view * translation(-from.x, -from.y, -from.z)
    end
    # endregion

    # region Consistent Transformation naming with instances
    def rotate(axis, radi)
      rotation(axis, radi)
    end

    def translate(x, y, z)
      translation(x, y, z)
    end

    def scale(x, y, z)
      scaling(x, y, z)
    end

    def shear(xy, xz, yx, yz, zx, zy)
      shearing(xy, xz, yx, yz, zx, zy)
    end
    # endregion
  end
  # region Transformations
  def rotate(axis, radi)
    self.class.rotation(axis, radi) * self
  end

  def translate(x, y, z)
    self.class.translation(x, y, z) * self
  end

  def scale(x, y, z)
    self.class.scaling(x, y, z) * self
  end

  def shear(xy, xz, yx, yz, zx, zy)
    self.class.shearing(xy, xz, yx, yz, zx, zy) * self
  end
  # endregion

  attr_reader :width, :height

  def initialize(width, height, data)
    @width  = width
    @height = height
    @data   = data
  end

  def [](i, j)
    # PERF: Leave out the check
    raise if i < 0 || width <= i
    raise if j < 0 || height <= j

    @data[i][j]
  end

  def transpose
    # PERF: Cache the transpose
    @transposed ||=
      MatrixBuilder.new.tap do |mb|
        (0...height).each do |i|
          (0...width).each do |j|
            mb[i, j] = self[j, i]
          end
        end
      end.to_matrix(height, width) # Height and width are switched on purpose
  end

  def determinant
    @determinant ||=
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

    return @inverse unless @inverse.nil?

    mb = MatrixBuilder.new
    (0...height).each do |i|
      (0...width).each do |j|
        c = cofactor(i, j)
        mb[j, i] = c / determinant # i and j are in reverse order to accomplish a transpose directly
      end
    end

    @inverse = mb.to_matrix(width, height)
  end

  def *(other)
    case other
      when MyMatrix
        raise('Can only multiply 4x4 matrices') unless [4] * 4 == [height, width, other.height, other.width]

        CallStatistics.add(:matrix_mul_matrix)
        MatrixBuilder.new.tap do |mb|
          (0...height).each do |i|
            (0...width).each do |j|
              v = 0
              (0...4).each do |c|
                next if self[i, c].zero? || other[c, j].zero? # TODO: Is this reasonable

                v += self[i, c] * other[c, j]
              end

              mb[i, j] = v
            end
          end
        end.to_matrix(width, height)
      when Tuple
        CallStatistics.add(:matrix_mul_tuple)
        MatrixBuilder.new.tap do |mb|
          (0...height).each do |i|
            j = 0
            v = 0
            (0...4).each do |c|
              oc  = other[c] # PERF: Gives about 1 sec on hexagon
              sic = self[i, c]
              next if oc.zero? || sic.zero? # TODO: Is this reasonable. It is here to solve Infinity * 0 => NaN

              v += sic * oc
            end

            mb[i, j] = v
          end

        end.to_tuple(height)
      when Array
        CallStatistics.add(:matrix_mul_tuples)
        o1, o2 = *other # TODO: We assume that it is Tuples
        mb1 = MatrixBuilder.new
        mb2 = MatrixBuilder.new
        (0...height).each do |i|
          j = 0
          v1 = 0
          v2 = 0
          (0...4).each do |c|
            o1c  = o1[c] # PERF: Gives about 1 sec on hexagon
            o2c  = o2[c] # PERF: Gives about 1 sec on hexagon
            sic = self[i, c]
            next if sic.zero? # TODO: Is this reasonable. It is here to solve Infinity * 0 => NaN

            v1 += sic * o1c unless o1c.zero?
            v2 += sic * o2c unless o2c.zero?
          end

          mb1[i, j] = v1
          mb2[i, j] = v2
        end

        [mb1.to_tuple(height), mb2.to_tuple(height)]
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

  def to_s
    "Matrix: \n#{data.map(&:to_s).join("\n")}"
  end

  protected

    attr_reader :data

end

