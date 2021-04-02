#!/usr/bin/env ruby
# coding: utf-8

#require "rdparse"

class Prog
  def initialize(comps)
    @comps = comps
  end

  def evaluate()
    return @comps.evaluate()
  end
end

class Comps
  def initialize(comps, comp)
    @comps = comps
    @comp = comp
  end

  def evaluate()
    if @comps != nil
      return @comps.evaluate(), @comp.evaluate()
    else
      return @comp.evaluate()
    end
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
  def initialize(type, event)
    @type = type
    @event = event
  end

  def evaluate()
    return 0
  end
end

class Statement
  def initialize(object)
    @object = object
  end

  def evaluate()
    return object.evaluate()
  end
end

# " a = 22 should return 22"
# class Assignments
#   def initialize(assignments, assignment)
#     @assignments = assignments
#     @assignment = assignment
#   end

#   def evaluate()
#     return assignments.evaluate(), assignments.evaluate()
#   end
# end

class Assignment
  def initialize(lhs, rhs)
    @lhs = lhs
    @rhs = rhs
  end

  def evaluate()
    return @lhs.evaluate()
  end
end

class Value
  def initialize(object)
    @object = object
  end
  
  def evalulate()
    return @object.evaluate()
  end
end

class Arry
  def initialize(elements)
    @elements = elements
  end
  
  def evalulate()
    result_list = []
    for element in @elements
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
  
  def evalulate()
    return (@lhs.evaluate() and @rhs.evaluate())
  end
end

class Or
  def initialize(lhs, rhs)
    @lhs = lhs
    @rhs = rhs
  end
  
  def evalulate()
    return (@lhs.evaluate() or @rhs.evaluat())
  end
end
  
class Not
  def initialize(object)
    @object = object
  end

  def evalulate()
    return @object.evaluate()
  end
end

class Less
  def initialize(lhs, rhs)
    @lhs = lhs
    @rhs = rhs
  end

  def evalulate()
    return @lhs.evaluate() < @rhs.evaluate()
  end
end

class LessEqual
  def initialize(lhs, rhs)
    @lhs = lhs
    @rhs = rhs
  end
  
  def evalulate()
    return @lhs.evaluate() <= @rhs.evaluate()
  end
end

class Greater
  def initialize(lhs, rhs)
    @lhs = lhs
    @rhs = rhs
  end
  
  def evalulate()
    return @lhs.evaluate() > @rhs.evaluate()
  end
end

class GreaterEqual
  def initialize(lhs, rhs)
    @lhs = lhs
    @rhs = rhs
  end
  
  def evalulate()
    return @lhs.evaluate() >= @rhs.evaluate()
  end

end


class Equal
  def initialize(lhs, rhs)
    @lhs = lhs
    @rhs = rhs
  end
  
  def evalulate()
    return @lhs.evaluate() == @rhs.evaluate()
  end

end

class NotEqual
  def initialize(lhs, rhs)
    @lhs = lhs
    @rhs = rhs
  end
  
  def evalulate()
    return @lhs.evaluate() != @rhs.evaluate()
  end

end

class Addition
  def initialize(lhs, rhs)
    @lhs = lhs
    @rhs = rhs
  end
  
  def evalulate()
    return @lhs.evaluate() + @rhs.evaluate()
  end

end

class Subtraction
  def initialize(lhs, rhs)
    @lhs = lhs
    @rhs = rhs
  end
  
  def evalulate()
    return @lhs.evaluate() - @rhs.evaluate()
  end

end

class Multiplication
  def initialize(lhs, rhs)
    @lhs = lhs
    @rhs = rhs
    
  end
  
  def evalulate()
    return @lhs.evaluate() * @rhs.evaluate()
  end

end

class Division
  def initialize(lhs, rhs)
    @lhs = lhs
    @rhs = rhs
    
  end
    
  def evalulate()
    return @lhs.evaluate() / @rhs.evaluate()
  end

end

class LiteralBool
  def initialize(value)
    if value == "true"
      @value = value
    else
      @value = value
    end
    
  end
  
  def evalulate()
    return @value
  end

end

class LiteralInteger
  def initialize(value)
    @value = value
    
  end
  
  def evalulate()
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
  def initialize(value)
    @value = value
  end

  def evaluate()
    return @value
  end
end
