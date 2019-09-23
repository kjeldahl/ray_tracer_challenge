# frozen_string_literal: true

require 'my_matrix'

module MatrixHelper
  def read_matrix(table)
    raw       = table.raw
    converted = []
    raw.each do |line|
      converted << line.map { |v| aton(v) }
    end
    MyMatrix.new(converted.first.size, converted.size, converted)
  end
end

World(IVarHelper)
World(MatrixHelper)

Given('the following {int}x{int} matrix {var}:') do |_width, _height, var, table|
  set(var, read_matrix(table))
end

Given('the following matrix {var}:') do |var, table|
  set(var, read_matrix(table))
end

Given("{var} ← transpose<{var}>") do |var, var2|
  set(var, get(var2).transpose)
end

And("{var} ← submatrix<{var}, {int}, {int}>") do |var1, var2, row, column|
  set(var1, get(var2).submatrix(row, column))
end

And("minor<{var}, {int}, {int}> = {int}") do |var, row, column, val|
  expect(get(var).minor(row, column)).to eq val
end

And("{var} ← inverse<{var}>") do |var1, var2|
  set(var1, get(var2).inverse)
end

Then('{var} {operator} {var} is the following {int}x{int} matrix:') do |var1, operator, var2, _width, _height, table|
  expect(get(var1).send(operator, get(var2))).to eq read_matrix(table)
end

Then("transpose<{var}> is the following matrix:") do |var, table|
  expect(get(var).transpose).to eq read_matrix(table)
end

Then("determinant<{var}> = {int}") do |var, val|
  expect(get(var).determinant).to eq val
end

Then("submatrix<{var}, {int}, {int}> is the following {int}x{int} matrix:") do |var, row, column, _int3, _int4, table|
  # table is a Cucumber::MultilineArgument::DataTable
  expect(get(var).submatrix(row, column)).to eq(read_matrix(table))
end

Then("cofactor<{var}, {int}, {int}> = {int}") do |var, row, column, val|
  expect(get(var).cofactor(row, column)).to eq val
end

Then("{var} is invertible") do |var|
  expect(get(var).invertible?).to be true
end

Then("{var} is not invertible") do |var|
  expect(get(var).invertible?).to be false
end

Then("{var} is the following {int}x{int} matrix:") do |var, _width, _height, table|
  expect(get(var)).to eq read_matrix(table)
end

Then("inverse<{var}> is the following {int}x{int} matrix:") do |var, int, int2, table|
  expect(get(var).inverse).to eq read_matrix(table)
end

Then("{var} {operator} inverse<{var}> = {var}") do |var1, operator, var2, var3|
  expect(get(var1).send(operator, get(var2).inverse)).to eq get(var3)
end