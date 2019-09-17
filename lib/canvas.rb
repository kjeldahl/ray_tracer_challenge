# frozen_string_literal: true

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
    @pixels[y][x] = col
  end

  def pixel_at(x, y)
    @pixels[y][x]
  end

  # Returns all pixels in one array line by line
  def pixels
    @pixels.flatten
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
