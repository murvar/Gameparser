#!/usr/bin/env ruby

require "rdparse"

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


  rule :definition do
    match(:type)
    match(:event)
  end

  rule :statement do
    # match(:function_call)
    match(:condition)
    match(:loop)
    match(:assignment)
    match(:value)
    # match(:exp)
    # match(:array)
  end

  # rule :function_call do
  #   match(:run)
  #   match(:read?)
  #   match(:write?)
  # end

  # rule :read do
  # end

  # rule :write do
  # end

  # rule :type do
  #   match("type", String, "{", :assignsments, :run,"}")
  # end

  # rule :event do
  #   match("event", String, "{", :assignsments, :run,"}")
  # end

  rule :assignsments do
    match(:assignsments, :assignment)
    match(:assignment)
  end

  rule :assignment do
    match(:var, "=", :value) { |m,  _, n| @user_assignments[m] = n}
  end

  rule :exp do
    match(:log_exp) {|e| e}
    match(:math_exp) {|e| e} #1+1 fungerar ej, måste skriva 1 + 1
  end

  rule :values do
    match(:values, ",", :value) {|m, _, n| m + Array(n)}
    match(:value) {|m| Array(m)}
  end

  rule :value do
    # match('"', String, '"') {|_, s, _| s}
    # match("'", String, "'") {|_, s, _| s}
    match(LiteralString) {|s| s.str }
    match(:array) {|a| a}
    match(:exp) {|e| e}
  end

  rule :array do
    match("[", :values, "]") {|_, v, _| v}
    match("[", "]") {[]}
  end

  rule :run do
    match("run", "(""example.rb", :block_comps, ")")
  end

  rule :loop do
    match(:while)
    match(:for)
  end

  rule :condition do
    match(:if)
    match(:switch)
  end

  rule :while do
    match("while", :log_exp, "{", :block_comps, "}")
  end

  rule :if do
    match("if", :log_exp, "{", :block_comps, "}", "else", "{", :block_comps, "}")
    match("if", :log_exp, "{", :block_comps, "}")
  end

  rule :switch do
    match("case", :var, :cases)
  end

  rule :cases do
    match(:cases, :case)
    match(:case)
  end

  rule :case do
    match()
  end

  rule :for do
    match("for", :var, "in", :array, "{", :block_comps, "}")
  end

  rule :log_exp do
    match(:bool_exp, "and", :log_exp) {|m, _, n| m and n}
    match(:bool_exp, "or", :log_exp) {|m, _, n| m or n}
    match("not", :log_exp) {|_, m, _| !m}
    match(:bool_exp) {|m| m}
  end

  rule :bool_exp do
    match(:math_exp, "<", :math_exp) {|m, _, n| m < n}
    match(:math_exp, "<", "=", :math_exp) {|m, _, _, n| m <= n}
    match(:bool_val, "=", "=", :bool_val) {|m, _, _, n| m == n}
    match(:math_exp, "=", "=", :math_exp) {|m, _, _, n| m == n} #infinite stack
    match(:math_exp, ">", :math_exp) {|m, _, n| m > n}
    match(:math_exp, ">", "=", :math_exp) {|m, _, _, n| m >= n}
    match(:math_exp, "!", "=", :math_exp) {|m, _, _, n| m != n}
    match(:bool_val, "!", "=", :bool_val) {|m, _, _, n| m != n} #infinite stack
    match(:bool_val) {|m| m}
    match(:var) {|m| @user_assignments[m]}
    end

  rule :bool_val do
    match("true") {true}
    match("false") {false}
    match("(", :log_exp, ")") {|_, m, _| m }
  end

  rule :math_exp do
    match(:math_exp, "+", :term) {|m, _, n| m + n}
    match(:math_exp, "-", :term) {|m, _, n| m - n}
    match(:term) {|m| m}
  end

  rule :term do
    match(:term, "*", :factor) {|m, _, n| m * n}
    match(:term, "/", :factor) {|m, _, n| m / n}
    match(:factor) {|m| m}
  end

  rule :factor do
    match(Integer) {|m| m}
    match("-", Integer) {|_, m| -m}
    match("+", Integer) {|_, m| m}
    match("(", :math_exp , ")"){|_, m, _| m}
    match(:var) {|m| @user_assignments[m]}
  end

  rule :var do
    match(String) {|s| s}
  end
  end
