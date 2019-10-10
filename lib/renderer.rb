class Renderer

  def initialize(camera, world, dump_file: nil)
    @camera = camera
    @world = world
    @dump_file = dump_file
  end

  def render
    render_parallel
  end

  def render_serial
    Canvas.new(@camera.hsize, @camera.vsize).tap do |canvas|

      random_pixels(canvas).each_with_index do |xy, idx|
        x, y = *xy
        ray = @camera.ray_for_pixel(x, y)
        canvas.write_pixel(x, y, @world.color_at(ray))

        if idx % @camera.hsize == 0
          puts "Rendered line: #{Integer(idx / @camera.hsize)}"
          if idx % (@camera.hsize * 10) == 0 && @dump_file
            Thread.new do
              puts "Dumping Canvas"
              dump_canvas(canvas)
            end
          end
        end
      end
    end
  end

  def render_parallel
    Canvas.new(@camera.hsize, @camera.vsize).tap do |canvas|

      num_threads = 8
      threads = []
      random_pixels(canvas).
        each_slice(Integer(@camera.hsize * @camera.vsize / num_threads)) do |slice|
        threads << Thread.new do
          slice.each_with_index do |xy, idx|
            x, y = *xy
            ray = @camera.ray_for_pixel(x, y)
            canvas.write_pixel(x, y, @world.color_at(ray))
            # if idx % @camera.hsize == 0
            #   puts "Rendered line: #{Integer(idx / @camera.hsize)}"
            # end
          end
        end
      end

      while threads.any?(&:alive?) do
        threads.find(&:alive?)&.join(10)
        puts "Dumping Canvas"
        dump_canvas(canvas)
      end
      puts "Dumping Canvas"
      dump_canvas(canvas)
    end
  end

  def line_by_line_pixels(canvas)
    px = []
    (0...canvas.height).each do |y|
      (0...canvas.width).each do |x|
        px << [x,y]
      end
    end
    px
  end

  def random_pixels(canvas)
    px = []
    (0...canvas.height).each do |y|
      (0...canvas.width).each do |x|
        px << [x,y]
      end
    end
    px.shuffle!
    px
  end

  def dump_canvas(canvas)
    File.open(@dump_file, 'w') do |f|
      f << canvas.to_ppm
    end
  end
end