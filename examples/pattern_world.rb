# frozen_string_literal: true

require 'color'
require 'scene'
require 'my_matrix'
require 'patterns'
require 'shapes'

# Example demonstrating ray tracing using a camera
#
# Run:
#   bundle exec ruby -Ilib -e'require "pattern_world"'
# It will output the file 'pattern_world.ppm' in the CWD
#
class PatternWorld
  class << self
    def run
      t1 = Time.now
      PatternWorld.new.tap do |cam|
        cam.setup
        cam.draw
        cam.dump_canvas
      end
      t2 = Time.now
      puts "Render time: #{t2-t1} seconds"
    end
  end

  def setup
    @camera = Camera.new(200, 100, Math::PI / 3)

    @camera.transform = MyMatrix.view_transform(Tuple.point(0.0, 1.5, -5.0),
                                                Tuple.point(0.0, 1.0, 0.0),
                                                Tuple.vector(0.0, 1.0, 0.0))

    lights = []
    lights << PointLight.new(Tuple.point(-10.0, 10.0, -10.0), Color::WHITE)
    # lights << PointLight.new(Tuple.point(0.0, 10.0, -10.0), Color::WHITE * 0.35)
    # lights << PointLight.new(Tuple.point(10.0, 5.0, -10.0), Color::WHITE * 0.35)

    @world = World.new(lights: lights)

    @floor = Sphere.new(transform: MyMatrix.scaling(10.0, 0.01, 10.0),
                        material: Material.new(color: Color.new(1.0, 0.9, 0.9),
                                               specular: 0.0,
                                               pattern: StripePattern.new(Color::RED, Color::WHITE)))

    @left_wall = Sphere.new(transform: MyMatrix
                                         .scale(10.0, 0.01, 10.0)
                                         .rotate(:x, Math::PI / 2)
                                         .rotate(:y, -Math::PI / 4)
                                         .translate(0.0, 0.0, 5.0),
                            material:  @floor.material)

    @right_wall = Sphere.new(transform: MyMatrix
                                          .scale(10.0, 0.01, 10.0)
                                          .rotate(:x, Math::PI / 2)
                                          .rotate(:y, Math::PI / 4)
                                          .translate(0.0, 0.0, 5.0),
                             material:  @floor.material)

    @middle = Sphere.new(transform: MyMatrix.shear(0.80, 0.0, 0.50, 0.0, 0.0, 1.0)
                                            .rotate(:x, Math::PI/-2)
                                            .translate(-0.5, 1.0, 0.5),
                         material: Material.new(color: Color.new(0.1, 1.0, 0.5),
                                                diffuse: 0.7,
                                                specular: 0.3,
                                                pattern: StripePattern.new(Color::YELLOW, Color::BLUE,
                                                                           transform: MyMatrix.rotate(:y, Math::PI/2).scale(0.5,0.5,0.5))))

    @right = Sphere.new(transform: MyMatrix.scale(0.5, 0.5, 0.5).translate(1.5, 0.5, -0.5),
                        material:  Material.new(color:    Color.new(0.5, 1.0, 0.1),
                                                diffuse:  0.7,
                                                specular: 0.3,
                                                pattern: GradientPattern.new(Color::WHITE, Color::BLACK,
                                                                             transform: MyMatrix.scale(0.5, 0.1, 0.1).
                                                                             rotate(:y, Math::PI/4))))

    @left = Sphere.new(transform: MyMatrix.scale(0.33, 0.33, 0.33).translate(-1.5, 0.33, -0.75),
                       material:  Material.new(color:    Color.new(1.0, 0.8, 0.1),
                                               diffuse:  0.7,
                                               specular: 0.3,
                                               pattern: RingPattern.new(Color::GREEN, Color::WHITE,
                                                                        transform: MyMatrix.scale(0.1, 1.0, 0.1))))

    @world.objects << @floor
    @world.objects << @right_wall
    @world.objects << @left_wall
    @world.objects << @left
    @world.objects << @right
    @world.objects << @middle
  end

  def draw
    @canvas = @camera.render(@world)
  end

  def dump_canvas
    File.open("pattern_world.ppm", 'w') do |f|
      f << @canvas.to_ppm
    end
  end
end

PatternWorld.run