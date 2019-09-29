# frozen_string_literal: true

require 'shapes'

World(IVarHelper)

Given("{var} ← plane<>") do |var|
  set(var, Plane.new)
end

Given("{var} ← plane<> with:") do |var, table|
  plane = Plane.new
  table.raw.each do |line| # line is an array
    prop, value = *line
    case prop
      when "material.color"
        plane.material.color = Color.new(*value[1..-2].split(", ").map(&:to_f))
      when "material.diffuse"
        plane.material.diffuse = Float(value)
      when "material.specular"
        plane.material.specular = Float(value)
      when "material.transparency"
        plane.material.transparency = Float(value)
      when "material.refractive_index"
        plane.material.refractive_index = Float(value)
      when "material.reflective"
        plane.material.reflective = Float(value)
      when "transform"
        case value
          when "translation<0, -1, 0>"
            plane.transform = MyMatrix.translate(0.0, -1.0, 0.0)
          when "translation<0, 1, 0>"
            plane.transform = MyMatrix.translate(0.0, 1.0, 0.0)
          else
            raise "Unimplemented transform #{value}"
        end
      else
        raise "Unknown property: #{prop}"
    end
    set(var, plane)
  end
end


When("{var} ← local_normal_at<{var}, {point}>") do |var, plane_var, point|
  set(var, get(plane_var).send(:local_normal_at, point))
end

When("{var} ← local_intersect<{var}, {var}>") do |var, plane_var, ray_var|
  set(var, get(plane_var).send(:local_intersect, get(ray_var)))
end