require 'yaml'
require 'color'
require 'my_matrix'
require 'patterns'
require 'scene'
require 'shapes'

class SceneLoader
  attr_reader :world, :camera, :definitions, :output

  def initialize(file_path, output: STDOUT)
    @file_path = file_path
    @definitions = {}
    @output = output
  end

  def load
    @world = World.new
    YAML.load_file(@file_path).tap do |yml|
      yml.each do |instr|
        case instr.first.first
          when 'add'
            add_stuff(instr)
          when 'define'
            define_stuff(instr)
          else
            output.puts "Ignoring #{instr.first.first}"
        end
      end
    end
  end


  def add_stuff(instr)
    case instr.first[1]
      when "camera"
        add_camera(instr)
      when "light"
        add_light(instr)
      when "plane"
        add_plane(instr)
      when "sphere"
        add_sphere(instr)
      else
        output.puts "Ignoring add of #{instr.first[1]}"
    end
  end

  def define_stuff(instr)
    name = instr.first[1]
    value = instr['value']
    # TODO: Hard coded for now

    @definitions[name] = Material.new(ambient: value['ambient'],
                                      diffuse: value['diffuse'],
                                      specular: value['specular'],
                                      reflective: value['reflective'],
                                      pattern: pattern(value['pattern'])
                                      )
  end

  def add_camera(instr)
    @camera = Camera.new(instr['width'], instr['height'], instr['field-of-view'],
                         transform: MyMatrix.view_transform(point(instr['from']),
                                                            point(instr['to']),
                                                            vector(instr['up'])))
  end

  def add_light(instr)
    @world.add_light PointLight.new(point(instr['at']),
                                    color(instr['intensity']))
  end

  def add_plane(instr)
    @world.objects <<
      Plane.new(transform: transform(instr['transform']),
                material: material(instr['material']))
  end

  def add_sphere(instr)
    @world.objects <<
      Sphere.new(transform: transform(instr['transform']),
                 material: material(instr['material']))
  end

  protected
  def point(coords)
    Tuple.point(*coords)
  end
  def vector(coords)
    Tuple.vector(*coords)
  end
  def color(coords)
    coords ? Color.new(*coords) : nil
  end
  def pattern(v)
    return nil unless v

    case v['type']
      when 'stripes'
        StripePattern.new(color(v['colors'][0]),
                          color(v['colors'][1]),
                          transform: transform(v['transform']))
      when 'checkers'
        CheckersPattern.new(color(v['colors'][0]),
                            color(v['colors'][1]),
                            transform: transform(v['transform']))
      when nil
        nil
      else
        output.puts "Unknown pattern: #{v['type']}"
        nil
    end
  end

  def transform(v)
    return MyMatrix.identity unless v

    transform = MyMatrix.identity
    v.each do |t|
      case t.first
        when 'scale'
          transform = transform.scale(*t[1..-1])
        when 'rotate-x'
          transform = transform.rotate(:x, *t[1..-1])
        when 'rotate-y'
          transform = transform.rotate(:y, *t[1..-1])
        when 'rotate-z'
          transform = transform.rotate(:z, *t[1..-1])
        when 'translate'
          transform = transform.translate(*t[1..-1])

        else
          output.puts "Unknown transformation: #{t.first}"
      end
    end
    transform
  end

  def material(v)
    case v
      when Hash
        Material.new(color: color(v['color']) || Color::WHITE,
                     ambient: v['ambient'] || 0.1,
                     diffuse: v['diffuse'] || 0.9,
                     specular: v['specular'] || 0.9,
                     shininess: v['shininess'] || 200.0,
                     reflective: v['reflective'] || 0.0,
                     transparency: v['transparency'] || 0.0,
                     refractive_index: v['refractive-index'] || 1.0,
                     pattern: pattern(v['pattern'])
        )
      when String
        @definitions[v]
      else
        output.puts "Unknown material: #{v}"
        nil
    end
  end
end

SceneLoader.new("examples/reflection_and_refraction.yaml").tap do |sl|
  sl.load
  puts "Camera: #{sl.camera.inspect}"
  puts "World: #{sl.world.inspect}"
  puts "Definitions: #{sl.definitions.inspect}"
end