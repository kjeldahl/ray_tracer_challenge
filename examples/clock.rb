require 'scene'
require 'my_matrix'
require 'tuple'

# Example demonstrating translation scaling and rotation
#
# Run:
#   bundle exec ruby -Ilib -Iexamples -e'require "clock"; Clock.run'
# It will output the file 'clock.ppm' in the CWD
#
class Clock

  class << self
    def run
      clock = Clock.new
      clock.draw
      clock.dump_canvas
    end
  end

  def initialize
    @canvas = Canvas.new(100, 100)
    @color = Color::WHITE
  end

  def draw
    @point = Tuple.point(0.0, 1.0, 0.0)
    @transform = MyMatrix.
                  scale(45, 45, 1).
                  translate(50, 50, 0)
    (1..12).each do |t|
      rotation = MyMatrix.rotation_z((Math::PI * 2 / 12) * t )
      draw_point = @transform * rotation * @point

      @canvas.write_pixel(draw_point.x, @canvas.height - draw_point.y, @color)
    end
  end

  def dump_canvas
    File.open("clock.ppm", 'w') do |f|
      f << @canvas.to_ppm
    end
  end

end