# frozen_string_literal: true

require 'canvas'

World(IVarHelper)

Given('{var} ← {canvas}') do |var, canvas|
  i_set(var, canvas)
end

When('every pixel of {var} is set to {color}') do |canvas_var, color|
  canvas = i_get(canvas_var)
  (0...canvas.width).each do |x|
    (0...canvas.height).each do |y|
      canvas.write_pixel(x, y, color)
    end
  end
end

When('write_pixel<{var}, {int}, {int}, {var}>') do |canvas_var, x, y, col_var|
  i_get(canvas_var).write_pixel(x, y, i_get(col_var))
end

When('{var} ← canvas_to_ppm<{var}>') do |var, canvas_var|
  i_set(var, i_get(canvas_var).to_ppm)
end

Then('pixel_at<{var}, {int}, {int}> = {var}') do |canvas_var, x, y, col_var|
  expect(i_get(canvas_var).pixel_at(x, y)).to eq i_get(col_var)
end

And('every pixel of {var} is {color}') do |var, color|
  expect(i_get(var).pixels.all? { |p| p == color }).to eq true
end

Then('lines {int}-{int} of {var} are') do |line_start, line_end, var, string|
  line_range = (line_start - 1)...line_end
  expect(i_get(var).split("\n")[line_range].join("\n")).to eq string
end

Then("{var} ends with a newline character") do |var|
  expect(i_get(var)[-1]).to eq "\n"
end