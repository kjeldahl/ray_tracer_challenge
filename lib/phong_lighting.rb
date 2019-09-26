require 'color'

class PhongLighting
  
  class << self
    def lighting(material, light, position, eyev, normal, in_shadow=false)
      effective_color = material.color * light.intensity

      ambient = effective_color * material.ambient

      return ambient if in_shadow

      # Find direction to light source
      light_vector = (light.position - position).normalize

      # light_dot_normal represents the cosine of the angle between the​
      # light vector and the normal vector. A negative number means the​
      # light is on the other side of the surface.​
      light_dot_normal = light_vector.dot(normal)

      if light_dot_normal < 0
        diffuse = Color::BLACK
        specular = Color::BLACK
      else
        # compute the diffuse contribution​
        diffuse = effective_color * material.diffuse * light_dot_normal

        # reflect_dot_eye represents the cosine of the angle between the​
        # reflection vector and the eye vector. A negative number means the​
        # light reflects away from the eye.​
        reflect_vector = -light_vector.reflect(normal)
        reflect_dot_eye = reflect_vector.dot(eyev)

        if reflect_dot_eye <= 0
          specular = Color::BLACK
        else
          # compute the specular contribution​
          factor = reflect_dot_eye**material.shininess
          specular = light.intensity * material.specular * factor
        end
      end

      # Add the three contributions together to get the final shading​
      ambient + diffuse + specular
    end
  end
end