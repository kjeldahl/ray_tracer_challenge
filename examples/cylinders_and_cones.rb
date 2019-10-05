# frozen_string_literal: true

require 'color'
require 'scene'
require 'my_matrix'
require 'patterns'
require 'shapes'

# Example demonstrating ray tracing with a plane
#
# Run:
#   bundle exec ruby -Ilib -e'require "cylinders_and_cones"'
# It will output the file 'cylinders_and_cones.ppm' in the CWD
#
class CylindersAndCones
  class << self
    def run
      t1 = Time.now
      CylindersAndCones.new.tap do |cam|
        cam.setup
        cam.draw
        cam.dump_canvas
      end
      t2 = Time.now
      puts "Render time: #{t2-t1} seconds"
    end
  end

  def setup
    @camera = Camera.new(6200, 300, Math::PI / 3)

    @camera.transform = MyMatrix.view_transform(Tuple.point(0.0, 5.5, -15.0),
                                                Tuple.point(0.0, 3.0, 0.0),
                                                Tuple.vector(0.0, 1.0, 0.0))

    lights = []
    lights << PointLight.new(Tuple.point(-10.0, 10.0, -10.0), Color::WHITE)
    # lights << PointLight.new(Tuple.point(0.0, 10.0, -10.0), Color::WHITE * 0.35)
    # lights << PointLight.new(Tuple.point(10.0, 5.0, -10.0), Color::WHITE * 0.5)

    @world = World.new(lights: lights)

    @floor = Plane.new(material: Material.new(color: Color.new(1.0, 0.9, 0.9),
                                              specular: 0.0,
                                              reflective: 0.4,
                                              pattern: CheckersPattern.new(Color::WHITE * 0.8, Color::BLACK + 0.2,
                                                                           transform: MyMatrix.scale(0.25, 0.25, 0.25))))

    @rocket_top = Cone.new(material:  Material.new(color:      Color::YELLOW,
                                                   specular:   0.2,
                                                   reflective: 0.2),
                           transform: MyMatrix.scale(0.5, 1.0, 0.5).translate(0, 5, 0),
                           min:       -2.0,
                           max:       0.0
    )

    @rocket_body = Cylinder.new(material:  Material.new(color:      Color::RED,
                                                        specular:   0.2,
                                                        reflective: 0.001,
                                                        shininess: 10,
                                                        pattern:    CheckersPattern.new(Color::RED, Color::WHITE)),
                                transform: MyMatrix.scale(0.95, 3, 0.95),
                                min:       0.0,
                                max:       1.0
    )


    @left_wall = Plane.new(transform: MyMatrix
                                         .rotate(:x, Math::PI / 2)
                                         .rotate(:y, -Math::PI / 4)
                                         .translate(0.0, 0.0, 5.0),
                           material: Material.new(color: Color.new(1.0, 0.9, 0.9),
                                                  specular: 0.0,
                                                  reflective: 0.07,
                                                  pattern: StripePattern.new(Color::WHITE * 0.8, Color::BLACK + 0.2,
                                                                             transform: MyMatrix.scale(0.25, 0.25, 0.25).rotate(:y, Math::PI/2))))

    @right_wall = Plane.new(transform: MyMatrix
                                          .rotate(:x, Math::PI / 2)
                                          .rotate(:y, Math::PI / 4)
                                          .translate(0.0, 0.0, 5.0),
                            material: @left_wall.material)

    @middle = Sphere.new(transform: MyMatrix.translate(-0.5, 1.0, 0.5),
                         material: Material.new(color: Color.new(1.0, 0.3, 0.3),
                                                diffuse: 0.7,
                                                specular: 0.1,
                                                reflective: 0.05,
                                                shininess: 20))

    @right = Sphere.new(transform: MyMatrix.scale(0.5, 0.5, 0.5).translate(1.5, 0.5, -0.5),
                        material: Material.new(color: Color.new(0.5, 1.0, 0.1),
                                               diffuse: 0.7,
                                               specular: 0.3,
                                               reflective: 0.6))

    @left = Sphere.new(transform: MyMatrix.scale(0.33, 0.33, 0.33).translate(-1.5, 0.33, -0.75),
                       material: Material.new(color: Color.new(1.0, 0.8, 0.1),
                                              diffuse: 0.7,
                                              specular: 0.3,
                                              reflective: 0.7))

    @world.objects << @floor
    # @world.objects << @right_wall
    # @world.objects << @left_wall
    # @world.objects << @left
    # @world.objects << @right
    # @world.objects << @middle
    @world.objects << @rocket_top
    @world.objects << @rocket_body
  end

  def draw
    @canvas = @camera.render(@world)
  end

  def dump_canvas
    File.open("cylinders_and_cones.ppm", 'w') do |f|
      f << @canvas.to_ppm
    end
  end
end

CylindersAndCones.run