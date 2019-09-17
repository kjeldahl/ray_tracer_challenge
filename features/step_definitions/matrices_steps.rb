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

Given('the following {int}x{int} matrix {word}:') do |_width, _height, var, table|
  i_set(var, read_matrix(table))
end

Given('the following matrix {word}:') do |var, table|
  i_set(var, read_matrix(table))
end

Given("{word} ← transpose<{word}>") do |var, var2|
  i_set(var, i_get(var2).transpose)
end

And("{word} ← submatrix<{word}, {int}, {int}>") do |var1, var2, row, column|
  i_set(var1, i_get(var2).submatrix(row, column))
end

And("minor<{word}, {int}, {int}> = {int}") do |var, row, column, val|
  expect(i_get(var).minor(row, column)).to eq val
end

And("{word} ← inverse<{word}>") do |var1, var2|
  i_set(var1, i_get(var2).inverse)
end

And("{word} ← {word} {operator} {word}") do |var1, var2, operator, var3|
  i_set(var1, i_get(var2).send(operator, i_get(var3)))
end

Then('{word}[{int},{int}] = {number}') do |var, x, y, result|
  expect(i_get(var).[](x, y)).to eq result
end

Then("{word}[{int},{int}] = {number}{operator}{number}") do |var, i, j, counter, operator, quotient|
  expect(i_get(var).[](i, j)).to eq counter.send(operator, quotient)
end

Then('{word} = {word}') do |var1, var2|
  expect(i_get(var1)).to eq i_get(var2)
end

Then('{word} != {word}') do |var1, var2|
  expect(i_get(var1)).not_to eq i_get(var2)
end

Then('{word} {operator} {word} is the following {int}x{int} matrix:') do |var1, operator, var2, _width, _height, table|
  # table is a Cucumber::MultilineArgument::DataTable
  expect(i_get(var1).send(operator, i_get(var2))).to eq read_matrix(table)
end

Then("{word} {operator} {word} = {word}") do |var1, operator, var2, var3|
  expect(i_get(var1).send(operator, i_get(var2))).to eq i_get(var3)
end

Then("transpose<{word}> is the following matrix:") do |var, table|
  # table is a Cucumber::MultilineArgument::DataTable
  expect(i_get(var).transpose).to eq read_matrix(table)
end

Then("determinant<{word}> = {int}") do |var, val|
  expect(i_get(var).determinant).to eq val
end

Then("submatrix<{word}, {int}, {int}> is the following {int}x{int} matrix:") do |var, row, column, _int3, _int4, table|
  # table is a Cucumber::MultilineArgument::DataTable
  expect(i_get(var).submatrix(row, column)).to eq(read_matrix(table))
end

Then("cofactor<{word}, {int}, {int}> = {int}") do |var, row, column, val|
  expect(i_get(var).cofactor(row, column)).to eq val
end

Then("{word} is invertible") do |var|
  expect(i_get(var).invertible?).to be true
end

Then("{word} is not invertible") do |var|
  expect(i_get(var).invertible?).to be false
end

Then("{word} is the following {int}x{int} matrix:") do |var, _width, _height, table|
  expect(i_get(var)).to eq read_matrix(table)
end

Then("inverse<{word}> is the following {int}x{int} matrix:") do |var, int, int2, table|
  expect(i_get(var).inverse).to eq read_matrix(table)
end

Then("{word} {operator} inverse<{word}> = {word}") do |var1, operator, var2, var3|
  expect(i_get(var1).send(operator, i_get(var2).inverse)).to eq i_get(var3)
end