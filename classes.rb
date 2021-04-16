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
    @str = st.gsub(/\\/, "")
  end

  def evaluate()
    return @str
  end
end

class Variable
  attr_accessor :value
  def initialize(value = 0)
    @value = value
  end

  def evaluate()
    @value
  end
end

class Function
  def initialize(params, block)
    @params = params
    @block = block
  end

  def evaluate(arguments)
    $current_scope += 1
    $variables[$current_scope] = Hash.new()
    counter = 0
    @params.each do |p|
      $variables[$current_scope][p.name] = Variable.new(arguments[counter].evaluate())
      counter += 1
    end
    result = @block.evaluate()
    # riva ner frame
    $current_scope -= 1
    $variables.pop()
    result
  end
end

class FunctionCall
  def initialize(idn, args)
    @idn = idn
    @args = args
  end

  def evaluate()
    params = []
    for arg in @args
      params << arg.evaluate()
    end
    $functions[@idn.name].evaluate(params)
  end
end

class Block
  attr_reader :statements
  def initialize(statements)
    @statements = statements
  end

  def evaluate()
    for statement in @statements do
      result = statement.evaluate()
    end
    result
  end
end

class Assignment
  def initialize(lhs, rhs)
    @lhs = lhs
    @rhs = rhs
    # $variables[@lhs] = Variable.new()
  end

  def evaluate()
    $variables[$current_scope][@lhs] = Variable.new(@rhs.evaluate())
    $variables[$current_scope][@lhs].value
  end
end

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

class Identifier
  attr_accessor :name
  def initialize(name)
    @name = name
  end
end

class CompOp
  attr_reader :op
  def initialize(op)
    @op = op
  end
end

class Write
  def initialize(string)
    @string = string
  end

  def evaluate()
    puts @string.evaluate()
  end
end

class Read
  def initialize(string)
    @string = string
  end

  def evaluate()
    puts @string.evaluate()
    input = gets().chomp()
    return input
  end
end

class IdentifierNode
  def initialize(idn)
    @idn = idn
  end

  def evaluate()
    $variables[$current_scope][@idn.name].evaluate()
  end
end

class If
  def initialize(exp, block, elseblock = nil)
    @exp = exp
    @block = block
    @elseblock = elseblock
  end

  def evaluate()
    if @exp.evaluate()
      @block.evaluate
    else
      if @elseblock != nil
        @elseblock.evaluate
      end
    end
  end
end

class Case
  def initialize(identifier)
    @identifier = identifier
  end

  def evaluate()

  end
end

class While
  def initialize(exp, block)
    @exp = exp
    @block = block
  end

  def evaluate()
    $current_scope += 1
    $variables[$current_scope] = Hash.new()
    while @exp.evaluate
      @block.evaluate
    end
    $current_scope -= 1
  end
end

class For
  def initialize(identifier, array, block)
    @identifier = identifier
    @array = array
    @block = block
  end

  def evaluate()
    $current_scope += 1
    $variables[$current_scope] = Hash.new()
    for @identifier in @array.evaluate()
      @block.evaluate()
    end
    $current_scope -= 1
  end
end
