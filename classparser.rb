#!/usr/bin/env ruby
# coding: utf-8

require './gameparser'

class Prog
  def initialize(comps)
    @comps = comps
  end

  def evaluate()
    return @comps.evaluate()
  end
end

class Comps
  def initialize(comps)
    @comps = comps
  end

  def evaluate()

    for object in @comps
       temp = object.evaluate()

    end
    return temp
  end
end

class Comp
  def initialize(comp)
    @comp = comp
  end

  def evaluate()
    return @comp.evaluate()
  end
end

class Definition
  def initialize(object)
    @object = object
  end

  def evaluate()
    #@object.evaluate()
    nil
  end
end

class Statement
  def initialize(object)
    @object = object
  end

  def evaluate()
    return @object.evaluate()
  end
end

class Value
  def initialize(object)
    @object = object
  end


  def evaluate()
    return @object.evaluate()
  end
end

class Arry
  def initialize(list)
    @list = list
  end

  def evaluate()
    result_list = []

    for element in @list
      result_list << element.evaluate()
    end

    return result_list
  end
end

class And
  def initialize(lhs, rhs)
    @lhs = lhs
    @rhs = rhs
  end

  def evaluate()
    return (@lhs.evaluate() and @rhs.evaluate())
  end
end

class Or
  def initialize(lhs, rhs)
    @lhs = lhs
    @rhs = rhs
  end

  def evaluate()
    return (@lhs.evaluate() or @rhs.evaluate())
  end
end

class Not
  def initialize(object)
    @object = object
  end

  def evaluate()
    return (not @object.evaluate())
  end
end

class Less
  def initialize(lhs, rhs)
    @lhs = lhs
    @rhs = rhs
  end

  def evaluate()
    return @lhs.evaluate() < @rhs.evaluate()
  end
end

class LessEqual
  def initialize(lhs, rhs)
    @lhs = lhs
    @rhs = rhs
  end

  def evaluate()
    return @lhs.evaluate() <= @rhs.evaluate()
  end
end

class Greater
  def initialize(lhs, rhs)
    @lhs = lhs
    @rhs = rhs
  end

  def evaluate()
    return @lhs.evaluate() > @rhs.evaluate()
  end
end

class GreaterEqual
  def initialize(lhs, rhs)
    @lhs = lhs
    @rhs = rhs
  end

  def evaluate()
    return @lhs.evaluate() >= @rhs.evaluate()
  end

end


class Equal
  def initialize(lhs, rhs)
    @lhs = lhs
    @rhs = rhs
  end

  def evaluate()
    return @lhs.evaluate() == @rhs.evaluate()
  end

end

class NotEqual
  def initialize(lhs, rhs)
    @lhs = lhs
    @rhs = rhs
  end

  def evaluate()
    return @lhs.evaluate() != @rhs.evaluate()
  end

end

class Addition
  def initialize(lhs, rhs)
    @lhs = lhs
    @rhs = rhs
  end

  def evaluate()
    return @lhs.evaluate() + @rhs.evaluate()
  end

end

class Subtraction
  def initialize(lhs, rhs)
    @lhs = lhs
    @rhs = rhs
  end

  def evaluate()
    return @lhs.evaluate() - @rhs.evaluate()
  end

end

class Multiplication
  def initialize(lhs, rhs)
    @lhs = lhs
    @rhs = rhs

  end

  def evaluate()
    return @lhs.evaluate() * @rhs.evaluate()
  end

end

class Division
  def initialize(lhs, rhs)
    @lhs = lhs
    @rhs = rhs

  end

  def evaluate()
    return @lhs.evaluate() / @rhs.evaluate()
  end

end

class LiteralBool
  def initialize(value)
    if value == "true"
      @value = true
    else
      @value = false
    end

  end

  def evaluate()
    return @value
  end

end

class LiteralInteger
  def initialize(value)
    @value = value

  end

  def evaluate()
    return @value
  end

end

class LiteralString
  attr_accessor :str
  def initialize(st)
    @str = st
  end

  def evaluate()
    return @str
  end
end

class Variable
  attr_accessor :value
  def initialize(value)
    @value = value
  end

  def evaluate()
    @value
  end
end

class Function
  def initialize(params, block)
    #puts params
    #puts block
    @params = params
    @block = block
  end

  def evaluate(arguments)
    print "$variables before: ", $variables
    puts ""
    # print "Arguments: ", arguments
    # puts ""
    # for i in 0...@params.length
    #   $variables[@params[i]  = arguments[i]
    # end
    counter = 0
    @params.each do |p|
      #puts p
      $variables[p].value = arguments[counter].evaluate()
      #@params_hash[k] = arguments[counter]
      counter += 1
    end
    # print "params_list: ", @params
    # puts ""

    print "$variables after: ", $variables
    puts ""
    puts ""
    puts ""

    for object in @block
      print "Object is: ", object , "\n"
      m = object.evaluate()
      print "Result of evaluate is: ", m , "\n"
      puts "Variables after this iteration"
      puts $variables
      puts ""
    end
    print "Return from function is: ", m , "\n"
    return m
  end
end

class Assignment
  def initialize(lhs, rhs)
    # @lhs = Variable.new(0)
    # $variables[lhs] = @lhs
    @lhs = lhs
    @rhs = rhs
  end
  def evaluate()
    # $variables[@lhs] = @rhs
    # puts $variables
    $variables[@lhs] = @rhs.evaluate()
  end
end

# class Param
#   def initialize(name)
#     @name = name
#   end
#
#   def evaluate()
#     @name
#   end
# end

class Integer
  def evaluate()
    self
  end
end
class String
  def evaluate()
    self
  end
end

class TrueClass
  def evaluate()
    self
  end
end

class FalseClass
  def evaluate()
    self
  end
end
