# frozen_string_literal: true
require 'color'

class Canvas
  attr_reader :width, :height

  def initialize(width, height)
    @width = width
    @height = height
    @pixels = []
    (0...height).each { |y| @pixels[y] = [Color.new(0.0, 0.0, 0.0)] * width }
    @max_color = 255
  end

  def write_pixel(x, y, col)
    return if x < 0 || width <= x
    return if y < 0 || height <= y

    @pixels[y][x] = col
  end

  def pixel_at(x, y)
    return if x < 0 || width <= x
    return if y < 0 || height <= y

    @pixels[y][x]
  end

  # Returns all pixels in one array line by line
  def pixels
    @pixels.flatten
  end

  def draw_box(x,y,w,h, color: Color.WHITE, outline: true)
    if outline
      (x..(x+w)).each do |xx|
        write_pixel(xx, y, color)
        write_pixel(xx, y+h, color)
      end
      (y..(y+h)).each do |yy|
        write_pixel(x, yy, color)
        write_pixel(x+w, yy, color)
      end
    else
      (y..(y+h)).each do |yy|
        (x..(x+w)).each do |xx|
          write_pixel(xx, yy, color)
        end
      end
    end
  end

  def to_ppm
    header = ["P3", "#{width} #{height}", @max_color]

    body = @pixels.map do |line|
      line.flat_map do |p|
        [clamp(p.red), clamp(p.green), clamp(p.blue)]
      end.join(" ")
    end

    (header + body).join("\n") + "\n"
  end
  
  private

  def clamp(c)
    cc = (c * @max_color).round
    cc = cc > @max_color ? @max_color : cc
    cc <= 0 ? 0 : cc
  end
end
