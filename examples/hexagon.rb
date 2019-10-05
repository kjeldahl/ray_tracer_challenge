# frozen_string_literal: true

require 'call_statistics'
require 'color'
require 'scene'
require 'my_matrix'
require 'patterns'
require 'shapes'

# Example demonstrating ray tracing with a plane
#
# Run:
#   bundle exec ruby -Ilib -e'require "hexagon"'
# It will output the file 'hexagon.ppm' in the CWD
#
class Hexagon
  class << self
    def run
      t1 = Time.now
      Hexagon.new.tap do |cam|
        cam.setup
        cam.draw
        cam.dump_canvas
      end
      t2 = Time.now
      puts "Render time: #{t2-t1} seconds"
      puts "Call Statistics:"
      puts CallStatistics.to_s
    end
  end

  def setup
    @camera = Camera.new(300, 150, Math::PI / 3)

    @camera.transform = MyMatrix.view_transform(Tuple.point(0.0, 2.5, -5.0),
                                                Tuple.point(0.0, 1.0, 0.0),
                                                Tuple.vector(0.0, 1.0, 0.0))

    lights = []
    lights << PointLight.new(Tuple.point(-10.0, 10.0, -10.0), Color::WHITE)
    # lights << PointLight.new(Tuple.point(0.0, 10.0, -10.0), Color::WHITE * 0.35)
    # lights << PointLight.new(Tuple.point(10.0, 5.0, -10.0), Color::WHITE * 0.5)

    @world = World.new(lights: lights)

    @floor = Plane.new(material: Material.new(color: Color.new(1.0, 0.9, 0.9),
                                              specular: 0.0,
                                              #reflective: 0.4,
                                              pattern: CheckersPattern.new(Color::WHITE * 0.8, Color::BLACK + 0.2,
                                                                           transform: MyMatrix.scale(0.25, 0.25, 0.25))))

    @hexagon = Hexagon.build(material:  Material.new(color:      Color::YELLOW,
                                                     specular:   0.2,
                                                     #reflective: 0.2,
                                                     pattern: CheckersPattern.new(Color::BLUE, Color::YELLOW,
                                                                                  transform: MyMatrix.scale(0.25, 0.25, 0.25))),
                             transform: MyMatrix.
                               scale(1.0, 1.0, 1.0).
                               translate(0, 1, 0)
    )

    @world.objects << @floor
    @world.objects << @hexagon
  end

  def draw
    @canvas = @camera.render(@world)
  end

  def dump_canvas
    File.open("hexagon.ppm", 'w') do |f|
      f << @canvas.to_ppm
    end
  end
end

Hexagon.run