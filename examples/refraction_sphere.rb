# frozen_string_literal: true

require 'color'
require 'scene'
require 'my_matrix'
require 'patterns'
require 'shapes'

# Example demonstrating ray tracing refraction of a glass sphere with an air bubble
#
# Run:
#   bundle exec ruby -Ilib -e'require "refraction_sphere"'
# It will output the file 'refraction_sphere.ppm' in the CWD
#
class RefractionSphere
  class << self
    def run
      t1 = Time.now
      RefractionSphere.new.tap do |cam|
        cam.setup
        cam.draw
        cam.dump_canvas
      end
      t2 = Time.now
      puts "Render time: #{t2 - t1} seconds"
    end
  end

  def setup
    @camera = Camera.new(200, 200, Math::PI / 3)

    @camera.transform = MyMatrix.view_transform(Tuple.point(0.0, 0.0, -5.0),
                                                Tuple.point(0.0, 0.0, 0.0),
                                                Tuple.vector(0.0, 1.0, 0.0))

    lights = []
    lights << PointLight.new(Tuple.point(-2.0, 14.0, -10.0), Color::WHITE * 0.7)
    # lights << PointLight.new(Tuple.point(0.0, 10.0, -10.0), Color::WHITE * 0.35)
    # lights << PointLight.new(Tuple.point(10.0, 5.0, -10.0), Color::WHITE * 0.5)

    @world = World.new(lights: lights)

    @wall = Plane.new(transform: MyMatrix
                                   .rotate(:x, Math::PI / 2)
                                   .translate(0.0, 0.0, 50.0),
                      material:  Material.new(color:   Color::WHITE,
                                              pattern: CheckersPattern.new(Color::WHITE * 0.8, Color::BLACK + 0.2,
                                                                           transform: MyMatrix.scale(9, 9, 9))))

    @glass = Sphere.new(transform: MyMatrix
                                     .scale(2.0, 2.0, 2.0),
                        material:  Material.new(color:      Color::WHITE,
                                                diffuse:    0.3,
                                                specular:   1.0,
                                                reflective: 0.9,
                                                shininess:  200,
                                                transparency: 1.0,
                                                refractive_index: 1.52))

    @air = Sphere.new(transform: MyMatrix
                                   .scale(1.0, 1.0, 1.0),
                                   #.translate(1.5, 0.5, -0.5),
                      material:  Material.new(color:      Color::WHITE,
                                              diffuse:    0.0,
                                              specular:   0.0,
                                              reflective: 0.1,
                                              transparency: 1.0,
                                              refractive_index: 1.00029))

    @world.objects << @wall
    @world.objects << @glass
    @world.objects << @air
  end

  def draw
    @canvas = @camera.render(@world)
  end

  def dump_canvas
    File.open("refraction_sphere.ppm", 'w') do |f|
      f << @canvas.to_ppm
    end
  end
end

RefractionSphere.run