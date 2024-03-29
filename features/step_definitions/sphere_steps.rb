# frozen_string_literal: true

require 'shapes'

World(IVarHelper)

Given("{var} ← {glass_sphere}") do |var, sphere|
  set(var, sphere)
end

Given("{var} ← {sphere} with:") do |var, sphere, table|
  table.raw.each do |line| # line is an array
    prop, value = *line
    case prop
      when "material.color"
        sphere.material.color = Color.new(*value[1..-2].split(", ").map(&:to_f))
      when "material.diffuse"
        sphere.material.diffuse = Float(value)
      when "material.ambient"
        sphere.material.ambient = Float(value)
      when "material.specular"
        sphere.material.specular = Float(value)
      when "transform"
        case value
          when "scaling<0.5, 0.5, 0.5>"
            sphere.transform = MyMatrix.scale(0.5, 0.5, 0.5)
          when "translation<0, 0, 10>"
            sphere.transform = MyMatrix.translate(0.0, 0.0, 10)
          when "translation<0, 0, 1>"
            sphere.transform = MyMatrix.translate(0.0, 0.0, 1.0)
          when "translation<0, -3.5, -0.5>"
            sphere.transform = MyMatrix.translate(0.0, -3.5, -0.5)
          else
            raise "Unimplemented transform #{value}"
        end
      else
        raise "Unknown property: #{prop}"
    end
    set(var, sphere)
  end
end

Given("{var} ← {glass_sphere} with:") do |var, sphere, table|
  table.raw.each do |line| # line is an array
    prop, value = *line
    case prop
      when "material.refractive_index"
        sphere.material.refractive_index = Float(value)
      when "transform"
        case value
          when "scaling<2, 2, 2>"
            sphere.transform = MyMatrix.scale(2.0, 2.0, 2.0)
          when "translation<0, 0, -0.25>"
            sphere.transform = MyMatrix.translate(0.0, 0.0, -0.25)
          when "translation<0, 0, 0.25>"
            sphere.transform = MyMatrix.translate(0.0, 0.0, 0.25)
          when "translation<0, 0, 1>"
            sphere.transform = MyMatrix.translate(0.0, 0.0, 1.0)
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

