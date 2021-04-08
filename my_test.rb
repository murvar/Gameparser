class Test
  attr_accessor :value
  def initialize(value)
    @value = value
  end
 
end

class Father
  attr_accessor :t
  def initialize(t)
    @t = t
  end
end

t1 = Test.new(25)
f1 = Father.new(t1)

h = Hash.new()

h["var"] = t1

puts h
puts f1.t.value

puts ""

h["var"].value = 100

puts h
puts f1.t.value
puts t1.value
