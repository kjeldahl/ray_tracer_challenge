require 'canvas'
require 'my_matrix'
require 'tuple'
require 'ray'
require 'sphere'

# Example demonstrating simple ray tracing of a sphere
#
# Run:
#   bundle exec ruby -Ilib -Iexamples -e'require "first_ray"'
# It will output the file 'first_ray.ppm' in the CWD
#
class FirstRay

  class << self
    def run
      first_ray = FirstRay.new
      first_ray.draw
      first_ray.dump_canvas
    end
  end

  def initialize
    @canvas = Canvas.new(100, 100)
    @color = Color::RED
  end

  def draw
    @transform = MyMatrix.
                  scale(45, 45, 1).
                  #shear(0.5, 0.0, 0.5, 0.0, 0.0, 0.0).
                  translate(50, 50, 0)
    sphere = Sphere.new(transform: @transform)

    (0...@canvas.width).each do |x|
    (0...@canvas.height).each do |y|
      ray = Ray.new(Tuple.point(x, y, 0), Tuple.vector(0, 0, 1))
      if sphere.intersect(ray).any?
        @canvas.write_pixel(x, @canvas.height - y, @color)
      end
    end
    end
  end

  def dump_canvas
    File.open("first_ray.ppm", 'w') do |f|
      f << @canvas.to_ppm
    end
  end

end

FirstRay.run