# frozen_string_literal: true

require 'scene/canvas'
require 'my_matrix'
require 'ray'
require 'tuple'

# NOTE: Camera is not immutable
class Camera

  attr_reader :hsize, :vsize, :fov
  attr_reader :pixel_size
  attr_accessor :transform

  def initialize(hsize, vsize, fov)
    @hsize = Float(hsize)
    @vsize = Float(vsize)
    @fov = fov
    @transform = MyMatrix.identity
    pre_calc
  end

  alias field_of_view fov

  def ray_for_pixel(x, y)

    xoffset = (x + 0.5) * pixel_size
    yoffset = (y + 0.5) * pixel_size
    world_x = @half_width - xoffset
    world_y = @half_height - yoffset

    pixel = transform.inverse * Tuple.point(world_x, world_y, -1.0)

    ray_origin = transform.inverse * Tuple.origin
    ray_direction = (pixel - ray_origin).to_vector.normalize

    Ray.new(ray_origin, ray_direction)
  end

  def render(world)
    Canvas.new(hsize, vsize).tap do |canvas|
      (0...canvas.height).each do |y|
        (0...canvas.width).each do |x|
          ray = ray_for_pixel(x, y)
          canvas.write_pixel(x, y, world.color_at(ray))
        end
      end
    end
  end

  protected
  def pre_calc
    half_view = Math.tan(fov / 2.0)
    aspect = hsize / vsize
    if aspect > 1
      @half_height = half_view / aspect
      @half_width = half_view
    else
      @half_height = half_view
      @half_width = half_view * aspect
    end

    @pixel_size = (@half_width * 2.0 / hsize).round(4)
  end
end