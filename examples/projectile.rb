require 'scene/canvas'
require 'color'
require 'tuple'

# Example demonstrating calculations using vectors and points
#
# Run:
#   bundle exec ruby -Ilib -Iexamples -e'require "projectile"; Scene.run'
# It will output the file 'projectile.ppm' in the CWD
#
class Projectile

  attr_reader :position, :velocity
  def initialize
    @position = Tuple.point(0.0, 1.0, 0.0)
    @velocity = Tuple.vector(1.0, 1.8, 0.0).normalize * 11.25
  end

  def update(velocity_change)
    @position = @position + @velocity
    @velocity = @velocity + velocity_change
  end
end

class Environment

  attr_reader :gravity, :wind

  def initialize
    @gravity = Tuple.vector(0.0, -0.1, 0.0)
    @wind    = Tuple.vector(-0.01, 0.0, 0.0)
  end

end

class Scene

  class << self
    def run
      scene = Scene.new
      while (scene.tick)
      end
      puts "Done."
    end
  end

  def initialize
    @projectile  = Projectile.new
    @environment = Environment.new
    @canvas      = Canvas.new(900, 550)
    @color       = Color.new(1.0, 0.5, 0.5)
  end

  def tick
    draw
    @projectile.update(@environment.gravity + @environment.wind)
    if @projectile.position.y < 0 || @projectile.position.x > @canvas.width
      dump_canvas
      false
    else
      true
    end
  end

  private

    def draw
      x = @projectile.position.x
      y = @canvas.height - @projectile.position.y # Invert y to have 0 at bottom
      @canvas.write_pixel(x, y, @color)
      @canvas.draw_box(Integer(x-2), Integer(y-2), 4, 4, color: @color, outline: false)
    end

    def dump_canvas
      File.open("projectile.ppm", 'w') do |f|
        f << @canvas.to_ppm
      end
    end
end