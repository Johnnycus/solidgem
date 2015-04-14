def fact num
  num > 1 ? num * fact(num - 1) : 1
end

puts fact(3)
