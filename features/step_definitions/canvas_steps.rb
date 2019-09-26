# frozen_string_literal: true

require 'scene'

World(IVarHelper)

Given('{var} ← {canvas}') do |var, canvas|
  set(var, canvas)
end

When('every pixel of {var} is set to {color}') do |canvas_var, color|
  canvas = get(canvas_var)
  (0...canvas.width).each do |x|
    (0...canvas.height).each do |y|
      canvas.write_pixel(x, y, color)
    end
  end
end

When('write_pixel<{var}, {int}, {int}, {var}>') do |canvas_var, x, y, col_var|
  get(canvas_var).write_pixel(x, y, get(col_var))
end

When('{var} ← canvas_to_ppm<{var}>') do |var, canvas_var|
  set(var, get(canvas_var).to_ppm)
end

Then('pixel_at<{var}, {int}, {int}> = {var}') do |canvas_var, x, y, col_var|
  expect(get(canvas_var).pixel_at(x, y)).to eq get(col_var)
end

And('every pixel of {var} is {color}') do |var, color|
  expect(get(var).pixels.all? { |p| p == color }).to eq true
end

Then('lines {int}-{int} of {var} are') do |line_start, line_end, var, string|
  line_range = (line_start - 1)...line_end
  expect(get(var).split("\n")[line_range].join("\n")).to eq string
end

Then("{var} ends with a newline character") do |var|
  expect(get(var)[-1]).to eq "\n"
end