require 'util/obj_loader'

World(IVarHelper)

Given("{var} ← a file containing:") do |var, string|
  set(var, string)
end

Given("{var} ← the file {string}") do |var, file_name|
  set(var, File.readlines(File.join(File.dirname(__FILE__), "..", "files", file_name)).join("\n"))
end

When("{var} ← parse_obj_file<{var}>") do |var, var2|
  ObjLoader.new.tap do |obj|
    set(var, obj)
    obj.parse(get(var2))
  end
end

When("{var} ← {string} from {var}") do |var, string, parser_var|
  set(var, get(parser_var).groups[string])
end

When("{var} ← obj_to_group<{var}>") do |var, var2|
  set(var, get(var2).obj_to_group)
end

Then("{var} should have ignored {int} lines") do |var, int|
  expect(get(var).ignored_lines.size).to eq int
end

Then("{var} includes {string} from {var}") do |group_var, group_name, parse_var|
  expect(get(group_var).include?(get(parse_var).groups[group_name])).to eq true
end