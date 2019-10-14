# frozen_string_literal: true

require 'color'
require 'scene'
require 'my_matrix'
require 'patterns'
require 'renderer'
require 'shapes'

# Example demonstrating ray tracing with a plane
#
# Run:
#   bundle exec ruby -Ilib -e'require "reflection_and_refraction_world"'
# It will output the file 'reflection_and_refraction_world.ppm' in the CWD
#
class ReflectionAndRefractionWorld
  class << self
    def run
      t1 = Time.now
      ReflectionAndRefractionWorld.new.tap do |cam|
        cam.setup
        cam.draw
      end
      t2 = Time.now
      puts "Render time: #{t2-t1} seconds"
      puts "Call Statistics:"
      puts CallStatistics.to_s
    end
  end

  def setup
    SceneLoader.new("examples/mirrors.yml").tap do |loader|
      loader.load
      @renderer = Renderer.new(loader.camera, loader.world, dump_file: "mirrors.ppm")
    end
  end

  def draw
    @canvas = @renderer.render
  end

end

ReflectionAndRefractionWorld.run