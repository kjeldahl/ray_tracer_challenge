require "shapes/group"
require "shapes/triangle"
require "tuple"

class ObjLoader

  attr_reader :ignored_lines
  attr_reader :vertices, :groups, :normals

  NUMBER_REGEXP = "([-+]?\\d+(\\.\\d+)?)"
  FACE_ELEM_REGEXP = "(\\d+)(\\/(\\d*)\\/(\\d+))?"

  class << self
    def load(filename)
      parser = ObjLoader.new
      parser.parse(File.read(filename))
      if parser.ignored_lines.any?
        STDERR.puts "Ignoring the following lines"
        STDERR.puts parser.ignored_lines.map{|l,n| "#{n}: #{l}"}
      end
      parser.obj_to_group
    end
  end

  def parse(obj_file_content)
    @ignored_lines = []
    @current_group = "DefaultGroup"
    obj_file_content.split("\n").each_with_index do |line, line_number|
      case line.strip
        when /\Av\s+#{NUMBER_REGEXP} #{NUMBER_REGEXP} #{NUMBER_REGEXP}\z/
          add_vertex(Float($1), Float($3), Float($5))

        when /\Avn\s+#{NUMBER_REGEXP} #{NUMBER_REGEXP} #{NUMBER_REGEXP}\z/
          add_vertex_normal(Float($1), Float($3), Float($5))

        when /\Af\s+(\d+) (\d+) (\d+)\z/
          add_face(Integer($1), Integer($2), Integer($3))

        when /\Af\s+#{FACE_ELEM_REGEXP} #{FACE_ELEM_REGEXP} #{FACE_ELEM_REGEXP}\z/
          #1,3,4   5,7,8   9,11,12
          add_face(Integer($1), Integer($5), Integer($9), n1: Integer($4), n2: Integer($8), n3: Integer($12))

        when /\Af\s*((\s#{FACE_ELEM_REGEXP}){4,}+)\z/
          add_polygon(*$1.split(" ").map{|i| i.split("/").map(&:to_i)})

        when /\Af\s*((\s\d+){4,}+)\z/
          add_polygon(*$1.split(" ").map{|i| Integer(i)})

        when /\Ag\s+(\w+)\z/
          @current_group = $1

        when "", /\A#/
          # NOOP Ignore blank lines and comments
        else
          @ignored_lines << [line, line_number + 1]
      end
    end
  end

  def obj_to_group
    Group.new.tap do |group|
      groups.each_value do |child_group|
        group.add_child(child_group) unless child_group.empty?
      end
    end
  end

  def default_group
    group("DefaultGroup")
  end

  def add_vertex(x, y, z)
    (@vertices ||= [nil]) << Tuple.point(x, y, z) # One indexed
  end

  def add_vertex_normal(x, y, z)
    (@normals ||= [nil]) << Tuple.vector(x, y, z) # One indexed
  end

  def add_face(v1, v2, v3, n1: nil, n2: nil, n3: nil, group_name: @current_group)
    if n1
      group(group_name).add_child(SmoothTriangle.new(vertices[v1], vertices[v2], vertices[v3],
                                                     normals[n1], normals[n2], normals[n3]))
    else
      group(group_name).add_child(Triangle.new(vertices[v1], vertices[v2], vertices[v3]))
    end
  end

  def add_polygon(*vertices)
    with_normals = vertices[0].is_a? Array
    (2...vertices.size).each do |idx|
      if with_normals
        add_face(vertices[0][0], vertices[idx-1][0], vertices[idx][0],
                 n1: vertices[0][2], n2: vertices[idx-1][2], n3: vertices[idx][2])
      else
        add_face(vertices[0], vertices[idx-1], vertices[idx])
      end
    end
  end

  def group(name)
    @groups ||= {"DefaultGroup" => Group.new}
    @groups[name] ||= Group.new
  end
end