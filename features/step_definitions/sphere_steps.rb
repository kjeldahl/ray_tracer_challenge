# frozen_string_literal: true

require 'sphere'

World(IVarHelper)

Given("{var} ← {sphere} with:") do |var, sphere, table|
  table.raw.each do |line| # line is an array
    prop, value = *line
    case prop
      when "material.color"
        sphere.material.color = Color.new(*value[1..-2].split(", ").map(&:to_f))
      when "material.diffuse"
        sphere.material.diffuse = Float(value)
      when "material.specular"
        sphere.material.specular = Float(value)
      when "transform"
        if value == "scaling<0.5, 0.5, 0.5>"
          sphere.transform = MyMatrix.scale(0.5, 0.5, 0.5)
        else
          raise "Unimplemented transform #{value}"
        end
      else
        raise "Unknown property: #{prop}"
    end
    set(var, sphere)
  end
end

When "{var} ← {sphere}" do |var, sphere|
  set(var, sphere)
end

When("{var} ← intersect<{var}, {var}>") do |var, sphere_var, ray_var|
  set(var, get(sphere_var).intersect(get(ray_var)))
end

When("set_transform<{var}, {var}>") do |sphere_var, transform_var|
  get(sphere_var).transform = get(transform_var)
end

When("set_transform<{var}, {scaling}>") do |sphere_var, scaling|
  get(sphere_var).transform = scaling
end

When("set_transform<{var}, {translation}>") do |sphere_var, scaling|
  get(sphere_var).transform = scaling
end

When("{var} ← normal_at<{var}, {point}>") do |var, sphere_var, point|
  set(var, get(sphere_var).normal_at(point))
end

When("{var} ← normal_at<{var}, point<{number}, {number}{operator}{number}, {number}{operator}{number}>>") do |var, sphere_var, x, y1, op_y, y2, z1, op_z, z2|
  set(var, get(sphere_var).normal_at(Tuple.point(x, y1.send(op_y, y2), z1.send(op_z, z2))))
end

When("{var} ← normal_at<{var}, point<{number}{operator}{number}, {number}{operator}{number}, {number}{operator}{number}>>") do |var, sphere_var, x1, op_x, x2, y1, op_y, y2, z1, op_z, z2|
  set(var, get(sphere_var).normal_at(Tuple.point(x1.send(op_x, x2), y1.send(op_y, y2), z1.send(op_z, z2))))
end

