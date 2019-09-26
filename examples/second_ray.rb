require 'scene'
require 'my_matrix'
require 'ray'
require 'shapes'
require 'tuple'

# Example demonstrating ray tracing with shading of a sphere
#
# Run:
#   bundle exec ruby -Ilib -Iexamples -e'require "second_ray"'
# It will output the file 'second_ray.ppm' in the CWD
#
class SecondRay

  class << self
    def run
      first_ray = SecondRay.new
      first_ray.setup
      first_ray.draw
      first_ray.dump_canvas
    end
  end

  def initialize
    @canvas = Canvas.new(100, 100)
  end

  def setup
    @transform = MyMatrix.identity
      # .scale(1.0, 1.0, 1.0)
      # .shear(0.5, -0.5, 0.5, 0.0, 0.0, 0.0)
      # .rotate(:z, Math::PI/10)
      # .translate(0.5, 1.0, 0)
    @material = Material.default.tap { |c| c.color = Color.new(1.0, 0.2, 1.0) }
    @sphere = Sphere.new(transform: @transform, material: @material)

    @light_position = Tuple.point(-10.0, 10.0, -10.0)
    @light_color = Color.new(1.0,1.0,1.0)
    @light = PointLight.new(@light_position, @light_color)
  end

  def draw
    @ray_origin = Tuple.point(0.0,0.0,-5.0)
    @wall_z = 10.0
    @wall_size = 7.0
    @pixel_size = @wall_size / @canvas.width
    half = @wall_size / 2

    (0...@canvas.height).each do |y|
      world_y = half - (y * @pixel_size)
      (0...@canvas.width).each do |x|
        world_x = -half + (x * @pixel_size)
        wall_target = Tuple.point(world_x, world_y, @wall_z)
        ray_direction = (wall_target - @ray_origin).normalize
        ray = Ray.new(@ray_origin, ray_direction)
        intersections = @sphere.intersect(ray)

        next unless intersections.any?

        hit = intersections.hit
        hit_point = ray.position(hit.t)
        normal = hit.object.normal_at(hit_point)
        eye_direction = -(ray.direction)

        point_color = PhongLighting.lighting(hit.object.material, @light, hit_point, eye_direction, normal)

        @canvas.write_pixel(x, y, point_color)
      end
    end
  end

  def dump_canvas
    File.open("second_ray.ppm", 'w') do |f|
      f << @canvas.to_ppm
    end
  end

end

SecondRay.run