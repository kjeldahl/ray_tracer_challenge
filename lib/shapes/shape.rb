# frozen_string_literal: true

require 'scene/material'
require 'my_matrix'
require 'tuple'

# Note: This class is not immutable
class Shape

  attr_accessor :transform, :material

  def initialize(transform: MyMatrix.identity, material: Material.new)
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
    # PERF: Page 226 in the book check for possible short cut
    object_point = transform.inverse * world_point

    object_normal = local_normal_at(object_point)

    world_normal  = transform.inverse.transpose * object_normal
    # Basically setting w to zero and then normalize
    world_normal.to_vector.normalize
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