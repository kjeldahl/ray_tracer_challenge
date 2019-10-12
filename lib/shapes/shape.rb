# frozen_string_literal: true

require 'bounds'
require 'intersection'
require 'intersections'
require 'my_matrix'
require 'scene/material'
require 'tuple'

# Note: This class is not immutable
class Shape

  attr_accessor :transform, :material
  attr_accessor :parent
  attr_accessor :shadow

  def initialize(transform: MyMatrix.identity, material: Material.default, shadow: true)
    @origin    = Tuple.origin
    @transform = transform
    @material  = material
    @shadow    = shadow
  end

  def material
    if @material.default? && parent
      parent.material # TODO: Consider transformation on material. Should it be transformed to the child?
    else
      @material
    end
  end

  def intersect(ray)
    local_ray = ray.transform(@transform.inverse)

    local_intersect(local_ray)
  end

  # Note: Assumes point is at surface of shape
  def normal_at(world_point, intersection=nil)
    object_point = world_to_object(world_point)

    object_normal = local_normal_at(object_point, intersection)

    normal_to_world(object_normal)
  end

  def world_to_object(point)
    @transform_with_parents ||= calculate_transforms_with_parents(self)
    @transform_with_parents * point
  end

  def include?(child)
    self == child
  end

  protected

    def calculate_transforms_with_parents(shape)
      if shape.parent
        shape.transform.inverse * calculate_transforms_with_parents(shape.parent)
      else
        shape.transform.inverse
      end
    end

  public

    def normal_to_world(vector)
      # PERF: Page 226 in the book check for possible short cut. Which could avoid the normalization call
      @transform_transposed_with_parents ||= calculate_transposed_transforms_with_parents(self)
      (@transform_transposed_with_parents * vector).to_normalized_vector
    end

  protected

    def calculate_transposed_transforms_with_parents(shape)
      if shape.parent
        calculate_transposed_transforms_with_parents(shape.parent) * shape.transform.inverse.transpose
      else
        shape.transform.inverse.transpose
      end
    end

  public


    def bounds
      raise "Implement in subclass"
    end

    def ==(other)
      other.class == self.class &&
        other.transform == transform &&
        other.material == material
    end

    alias eql? ==

    def hash
      @hash ||= [transform, material].hash
    end

  protected

    def local_intersect(local_ray)
      raise "Implement in sub class"
    end

    def local_normal_at(local_point, intersection=nil)
      raise "Implement in sub class"
    end
end