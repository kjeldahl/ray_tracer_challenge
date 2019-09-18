Then('{var}.{word} = {number}') do |var, attr, number|
  expect(i_get(var).send(attr.to_sym)).to eq(number)
end

