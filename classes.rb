#!/usr/bin/env ruby
# coding: utf-8

require './gameparser'

class Prog
  def initialize(comps)
    @comps = comps
  end

  def evaluate()
    @comps.evaluate()
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
    temp
  end
end

class Comp
  def initialize(comp)
    @comp = comp
  end

  def evaluate()
    @comp.evaluate()
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
    @object.evaluate()
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

class List
  def initialize(list)
    @list = list
  end

  def evaluate()
    result_list = []
    for element in @list
      result_list << element.evaluate()
    end
    result_list
  end
end

class ElementReader
  def initialize(name, index)
    @name = name
    @index = index
  end

  def evaluate()
    $variables[$current_scope][@name].value[@index]
  end
end

class ElementWriter
  def initialize(name, index, value)
    @name = name
    @index = index
    @value = value
  end

  def evaluate()
    $variables[$current_scope][@name].value[@index] = @value.evaluate()
  end
end

class And
  def initialize(lhs, rhs)
    @lhs = lhs
    @rhs = rhs
  end

  def evaluate()
    @lhs.evaluate() and @rhs.evaluate()
  end
end

class Or
  def initialize(lhs, rhs)
    @lhs = lhs
    @rhs = rhs
  end

  def evaluate()
    @lhs.evaluate() or @rhs.evaluate()
  end
end

class Not
  def initialize(object)
    @object = object
  end

  def evaluate()
    not @object.evaluate()
  end
end

class Less
  def initialize(lhs, rhs)
    @lhs = lhs
    @rhs = rhs
  end

  def evaluate()
    @lhs.evaluate() < @rhs.evaluate()
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
    @lhs.evaluate() > @rhs.evaluate()
  end
end

class GreaterEqual
  def initialize(lhs, rhs)
    @lhs = lhs
    @rhs = rhs
  end

  def evaluate()
    @lhs.evaluate() >= @rhs.evaluate()
  end
end

class Equal
  def initialize(lhs, rhs)
    @lhs = lhs
    @rhs = rhs
  end

  def evaluate()
    @lhs.evaluate() == @rhs.evaluate()
  end
end

class NotEqual
  def initialize(lhs, rhs)
    @lhs = lhs
    @rhs = rhs
  end

  def evaluate()
    @lhs.evaluate() != @rhs.evaluate()
  end
end

class Addition
  def initialize(lhs, rhs)
    @lhs = lhs
    @rhs = rhs
  end

  def evaluate()
    @lhs.evaluate() + @rhs.evaluate()
  end
end

class Subtraction
  def initialize(lhs, rhs)
    @lhs = lhs
    @rhs = rhs
  end

  def evaluate()
    @lhs.evaluate() - @rhs.evaluate()
  end
end

class Multiplication
  def initialize(lhs, rhs)
    @lhs = lhs
    @rhs = rhs

  end

  def evaluate()
    @lhs.evaluate() * @rhs.evaluate()
  end
end

class Division
  def initialize(lhs, rhs)
    @lhs = lhs
    @rhs = rhs

  end

  def evaluate()
    @lhs.evaluate() / @rhs.evaluate()
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
    @value
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
  def initialize(st)
    @str = st.gsub(/\\/, "")
  end

  def evaluate()
    @str
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

class IdentifierNode
  def initialize(idn)
    @idn = idn
  end

  def evaluate()
    $variables[$current_scope][@idn.name].evaluate()
  end
end

class CompOp
  attr_reader :op
  def initialize(op)
    @op = op
  end
end

class Range
  def initialize(start, dots, stop)
    @start = start
    @stop = stop
    @dots = dots.length()
  end

  def evaluate()
    list = []
    if @stop > @start
      if @dots == 2
        list = Array((@start..@stop))
      else
        list = Array((@start...@stop))
      end
    else
      if @dots == 2
        list= Array((@stop..@start))
        list.reverse!
      else
        list= Array((@stop+1...@start+1))
        list.reverse!
      end
    end
    list
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
  def initialize(string = nil)
    @string = string
  end

  def evaluate()
    if @string != nil
      puts @string.evaluate()
    end
    input = gets().chomp()
    input
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

class Switch
  def initialize(idn, cases)
    @idn = idn
    @cases = cases
  end

  def evaluate()
    for c in @cases
      if c.value.evaluate() == @idn.evaluate()
        return c.evaluate()
      end
    end
  end
end

class Case
  attr_reader :value
  def initialize(value, block)
    @value = value
    @block = block
  end

  def evaluate()
    @block.evaluate()
  end
end

class While
  def initialize(exp, block)
    @exp = exp
    @block = block
  end

  def evaluate()
    while @exp.evaluate
      temp = @block.evaluate
    end
    nil
  end
end

class For
  def initialize(identifier, iterable, block)
    @identifier = identifier
    @iterable = iterable
    @block = block
  end

  def evaluate()
    for var in @iterable.evaluate()
      $variables[$current_scope][@identifier.name] = Variable.new(var)
      @block.evaluate()
    end
    $variables[$current_scope].tap { |h| h.delete(@identifier.name) }
    nil
  end
end
