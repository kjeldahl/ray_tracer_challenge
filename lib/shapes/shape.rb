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

  def initialize(transform: MyMatrix.identity, material: Material.default)
    @origin = Tuple.origin
    @transform = transform
    @material  = material
  end

  def intersect(ray)
    local_ray = ray.transform(@transform.inverse)

    local_intersect(local_ray)
  end

  # Note: Assumes point is at surface of shape
  def normal_at(world_point)
    object_point = world_to_object(world_point)

    object_normal = local_normal_at(object_point)

    normal_to_world(object_normal)
  end

  def world_to_object(point)
    if parent
      point = parent.world_to_object(point)
    end

    # PERF: Page 226 in the book check for possible short cut
    transform.inverse * point
  end

  def normal_to_world(vector)
    world_normal  = transform.inverse.transpose * vector
    # Basically setting w to zero and then normalize
    world_normal = world_normal.to_vector.normalize

    if parent
      parent.normal_to_world(world_normal)
    else
      world_normal
    end
  end

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

    def local_normal_at(local_point)
      raise "Implement in sub class"
    end
end