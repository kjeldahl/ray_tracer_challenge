# frozen_string_literal: true

require 'color'
require 'scene'
require 'my_matrix'
require 'patterns'
require 'renderer'
require 'shapes'

# Run:
#   bundle exec ruby -Ilib -e'require "SceneRenderer"' -- scene.yml
# It will output the file 'scene.ppm' in the CWD
#
class SceneRenderer
  class << self
    def run(scene_file)
      t1 = Time.now
      SceneRenderer.new(scene_file).tap do |cam|
        cam.setup
        cam.draw
      end
      t2 = Time.now
      puts "Render time: #{t2-t1} seconds"
      puts "Call Statistics:"
      puts CallStatistics.to_s
      puts "Press enter to re-render or enter filename to render"
      s = STDIN.readline.strip
      if s != "" && File.exists?(File.join("examples", s))
        scene_file = s
        puts "Loading new scene: #{s}"
      else
        puts "Could not find file: #{File.join("examples", s)}"
      end
      run(scene_file)
    end
  end

  def initialize(scene_file)
    @scene_file = scene_file
  end

  def setup
    SceneLoader.new(File.join("examples", @scene_file)).tap do |loader|
      loader.load
      @renderer = Renderer.new(loader.camera, loader.world, dump_file: @scene_file + ".ppm")
    end
  end

  def draw
    @canvas = @renderer.render
  end

end

if ARGV[0]
  SceneRenderer.run(ARGV[0])
else
  STDERR.puts "Usage: scene_renderer <scene_file>"
end