# coding: utf-8
require './rdparse'
require './classes'

$variables = {}
$functions = {}
class GameLanguage

  def initialize

    @gameParser = Parser.new("game language") do

      token(/#.*/) # removes comment
      token(/\s+/) # removes whitespaces
      token(/^\d+/) {|m| m.to_i} # returns integers
      token(/\w+/) {|m| m } # returns variable names as string
      token(/".*?"/) do |m|
        m = m[1...-1]
        LiteralString.new(m)
      end # returns a LiteralString object
       token(/'.*?'/) do |m|
        m = m[1...-1]
        obj = LiteralString.new(m)
      end # returns string a LiteralString object
      token(/./) {|m| m } # returns rest like (, {, =, < etc as string

      start :prog do
        match(:comps) {|m| Comps.new(m).evaluate() unless m.class == nil }
      end

      rule :comps do
        match(:comps, :comp) {|m, n| m + Array(Comp.new(n)) }
        match(:comp) {|m| Array(Comp.new(m)) }
      end

      rule :comp do
        match(:definition) {|m| Definition.new(m) }
        match(:statement) {|m| Statement.new(m) }
      end

      rule :definition do
        match(:type)
        match(:event)
        match(:function_def)
      end

      rule :function_def do
        match("def", :function_name, "(", :params, ")", :block) do
          |_, name, _, params, _, block|
          $functions[name] = Function.new(params, block)
        end
      end
      
      rule :function_name do
        match(String) {|m| m }
      end

      rule :params do
        match(:params, :param) {|m, n| m + Array(n) }
        match(:param) {|m| Array(m)}
        match(:empty)  {|m| [] }
      end

      rule :param do
        match(/\w+/) do |m|
          $variables[m] = Variable.new(0) # fel?
          m
        end
      end

      rule :block do
        match("{", :statements, "}") {|_, m, _| m}
      end
      
      rule :function_call do
        match(:function_name, "(", :values, ")") do |m, _, arguments, _|
          $functions[m].evaluate(arguments)
        end
      end
      rule :statements do
        match(:statements, :statement) {|m, n| m + Array(n) }
        match(:statement) {|m| Array(m)}
      end

      rule :statement do
       # match(:condition)
       # match(:loop)
        match(:assignment)
        match(:value)
        match(:function_call)
      end

     
      rule :assignsments do
        match(:assignsments, :assignment)
        match(:assignment)
      end

      rule :assignment do
        match(:var, "=", :value) do |m,  _, n|
          Assignment.new(m, n)
        end
      end

      rule :values do
        match(:values, ",", :value) {|m, _, n| m + Array(n)}
        match(:value) {|m| Array(m)}
        match(:empty)  {|m| [] }
      end

      rule :value do
        match(LiteralString)
        match(:array)
        match(:exp)
        #match(:function_call)
       end

      rule :array do
        match("[", :values, "]") {|_, v, _| Arry.new(v)}
        match("[", "]") { Arry.new([]) }
      end

      rule :exp do
        match(:log_exp) {|e| e}
        match(:math_exp) {|e| e}
      end

      rule :log_exp do
        match(:bool_exp, "and", :log_exp) {|m, _, n| And.new(m, n) }
        match(:bool_exp, "or", :log_exp) {|m, _, n| Or.new(m, n) }
        match("not", :log_exp) {|_, m, _| Not.new(m) }
        match(:bool_exp) {|m| m}
      end

      rule :bool_exp do
        match(:math_exp, "<", :math_exp) {|m, _, n| Less.new(m, n) }
        match(:math_exp, "<", "=", :math_exp) {|m, _, _, n| LessEqual.new(m, n) }
        match(:bool_val, "=", "=", :bool_val) {|m, _, _, n| Equal.new(m, n) }
        match(:math_exp, "=", "=", :math_exp) {|m, _, _, n| Equal.new(m, n) }
        match(:math_exp, ">", :math_exp) {|m, _, n| Greater.new(m, n) }
        match(:math_exp, ">", "=", :math_exp) {|m, _, _, n| GreaterEqual.new(m, n) }
        match(:math_exp, "!", "=", :math_exp) {|m, _, _, n| NotEqual.new(m, n) }
        match(:bool_val, "!", "=", :bool_val) {|m, _, _, n| NotEqual.new(m, n) }
        match(:bool_val) {|m| m }
        match(:var) do |m|
          if $variables[m].class == LiteralBool
            $variables[m]
          end
        end
      end

      rule :bool_val do
        match("true") {|b| LiteralBool.new(b) }
        match("false") {|b| LiteralBool.new(b) }
        match("(", :log_exp, ")") {|_, m, _| m }
      end

      rule :math_exp do
        match(:math_exp, "+", :term) {|m, _, n| Addition.new(m, n) }
        match(:math_exp, "-", :term) {|m, _, n| Subtraction.new(m, n) }
        match(:term) {|m| m}
      end

      rule :term do
        match(:term, "*", :factor) {|m, _, n| Multiplication.new(m, n) }
        match(:term, "/", :factor) {|m, _, n| Division.new(m, n) }
        match(:factor) {|m| m}
      end

      rule :factor do
        match(Integer) {|m| LiteralInteger.new(m) }
        match("-", Integer) {|_, m| LiteralInteger.new(-m) }
        match("+", Integer) {|_, m| LiteralInteger.new(m) }
        match("(", :math_exp , ")"){|_, m, _| m }
        match(:var) { |m| $variables[m] }
      end

      rule :var do
        match(String) {|s| s }
      end
    end

# ============================================================
# Parser end
# ============================================================


    def done(str)
      ["quit","exit","bye",""].include?(str.chomp)
    end
    def parse_string(str)
      log(false)
      @gameParser.parse(str)
    end
    def parse()
      print "[gameParser] "
      #str = File.read(file)
      str = gets
      if done(str) then
        puts "Bye."
      else
        puts "=> #{@gameParser.parse str}"
        parse
      end
    end

    def log(state = true)
      if state
        @gameParser.logger.level = Logger::DEBUG
      else
        @gameParser.logger.level = Logger::WARN
      end
    end
  end
end

if __FILE__ == $0
  GameLanguage.new.parse()
end
