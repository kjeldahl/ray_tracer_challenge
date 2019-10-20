require "shapes/group"
require "shapes/triangle"
require "tuple"

class ObjLoader

  attr_reader :ignored_lines
  attr_reader :vertices, :groups, :normals

  NUMBER_REGEXP = "([-+]?\\d+(\\.\\d+)?)"
  FACE_ELEM_REGEXP = "(\\d+)(\\/(\\d*)\\/(\\d+))?"

  class << self
    def load(filename, grouping: false)
      parser = ObjLoader.new
      parser.parse(File.read(filename), grouping: grouping)
      if parser.ignored_lines.any?
        STDERR.puts "Ignoring the following lines"
        STDERR.puts parser.ignored_lines.map{|l,n| "#{n}: #{l}"}
      end
      parser.obj_to_group.tap do |obj_group|
        STDERR.puts(obj_group.bounds)
        STDERR.puts "#{@group_nr} groups in OBJ file" if grouping
      end
    end
  end

  def parse(obj_file_content, grouping: false)
    @grouping = grouping
    @ignored_lines = []
    @current_group = "DefaultGroup"
    @group_nr = 0
    create_new_group = grouping

    obj_file_content.split("\n").each_with_index do |line, line_number|
      case line.strip
        when /\Av\s+#{NUMBER_REGEXP} #{NUMBER_REGEXP} #{NUMBER_REGEXP}\z/
          if create_new_group
            @current_group = "Grouping-#{group_nr}"
            @group_nr += 1
            create_new_group = false
          end
          add_vertex(Float($1), Float($3), Float($5))

        when /\Avn\s+#{NUMBER_REGEXP} #{NUMBER_REGEXP} #{NUMBER_REGEXP}\z/
          add_vertex_normal(Float($1), Float($3), Float($5))

        when /\Af\s*((\s#{FACE_ELEM_REGEXP})+)\z/
          create_new_group = grouping
          add_polygon(*$1.split(" ").map{|i| i.split("/").map(&:to_i)})

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