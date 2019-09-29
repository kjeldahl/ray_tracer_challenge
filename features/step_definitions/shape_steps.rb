# frozen_string_literal: true

require 'intersections'
require 'shapes'

World(IVarHelper)

# Helper class for testing the Shape class
class TestShape < Shape

  attr_reader :saved_ray

  def local_intersect(local_ray)
    @saved_ray = local_ray
    Intersections.empty
  end

  def local_normal_at(local_point)
    local_point.to_vector
  end

end

Given("{var} ← test_shape<>") do |var|
  set(var, TestShape.new)
end

Given("{var} has:") do |var, table|
  shape = get(var)
  table.raw.each do |line| # line is an array
    prop, value = *line
    case prop
      when "material.color"
        shape.material.color = Color.new(*value[1..-2].split(", ").map(&:to_f))
      when "material.ambient"
        shape.material.ambient = Float(value)
      when "material.diffuse"
        shape.material.diffuse = Float(value)
      when "material.specular"
        shape.material.specular = Float(value)
      when "material.reflective"
        shape.material.reflective = Float(value)
      when "material.transparency"
        shape.material.transparency = Float(value)
      when "material.refractive_index"
        shape.material.refractive_index = Float(value)
      when "material.pattern"
        case value
          when "test_pattern<>"
            shape.material.pattern = TestPattern.new
          else
            raise "Unknown pattern: #{value}"
        end
      when "transform"
        case value
          when "translation<0, -1, 0>"
            shape.transform = MyMatrix.translate(0.0, -1.0, 0.0)
          when "translation<0, 1, 0>"
            shape.transform = MyMatrix.translate(0.0, 1.0, 0.0)
          else
            raise "Unimplemented transform #{value}"
        end
      else
        raise "Unknown property: #{prop}"
    end
    set(var, shape)
  end
end


When("{var} ← intersect<{var}, {var}>") do |var, shape_var, ray_var|
  set(var, get(shape_var).intersect(get(ray_var)))
end

When("set_transform<{var}, {var}>") do |shape_var, transform_var|
  get(shape_var).transform = get(transform_var)
end

When("set_transform<{var}, {scaling}>") do |shape_var, scaling|
  get(shape_var).transform = scaling
end

When("set_transform<{var}, {translation}>") do |shape_var, scaling|
  get(shape_var).transform = scaling
end

When("{var} ← normal_at<{var}, {point}>") do |var, shape_var, point|
  set(var, get(shape_var).normal_at(point))
end

When("{var} ← normal_at<{var}, point<{number}, {number}{operator}{number}, {number}{operator}{number}>>") do |var, shape_var, x, y1, op_y, y2, z1, op_z, z2|
  set(var, get(shape_var).normal_at(Tuple.point(x, y1.send(op_y, y2), z1.send(op_z, z2))))
end

When("{var} ← normal_at<{var}, point<{number}{operator}{number}, {number}{operator}{number}, {number}{operator}{number}>>") do |var, shape_var, x1, op_x, x2, y1, op_y, y2, z1, op_z, z2|
  set(var, get(shape_var).normal_at(Tuple.point(x1.send(op_x, x2), y1.send(op_y, y2), z1.send(op_z, z2))))
end

