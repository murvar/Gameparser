# coding: utf-8

require './rdparse'
require './classes'

$current_scope = 0
$variables = [Hash.new()]
$g_variables = Hash.new()
$functions = Hash.new()
$props = Hash.new()
$events = Hash.new()

class GameLanguage

  def initialize
    @line = 1
    @gameParser = Parser.new("game language") do

      token(/#.*/) # removes comment
      token(/\s+/) # removes whitespaces
      token(/^\d+/) {|m| m.to_i} # returns integers

      token(/(?<!\w)false(?!\w)/) {|m|m}
      token(/(?<!\w)true(?!\w)/) {|m| m }
      token(/(?<!\w)or(?!\w)/) {|m| m }
      token(/(?<!\w)and(?!\w)/) {|m| m }
      token(/(?<!\w)not(?!\w)/) {|m| m }
      token(/(?<!\w)def(?!\w)/) {|m| m }
      token(/(?<!\w)write(?!\w)/) {|m| m }
      token(/(?<!\w)read(?!\w)/) {|m| m }
      token(/(?<!\w)wait(?!\w)/) {|m| m }
      token(/(?<!\w)if(?!\w)/) {|m| m }
      token(/(?<!\w)else(?!\w)/) {|m| m }
      token(/(?<!\w)switch(?!\w)/) {|m| m }
      token(/(?<!\w)case(?!\w)/) {|m| m }
      token(/(?<!\w)while(?!\w)/) {|m| m }
      token(/(?<!\w)for(?!\w)/) {|m| m }
      token(/(?<!\w)init(?!\w)/) {|m| m }
      token(/(?<!\w)run(?!\w)/) {|m| m }
      token(/(?<!\w)in(?!\w)/) {|m| m }
      token(/(?<!\w)prop(?!\w)/) {|m| m }
      token(/(?<!\w)event(?!\w)/) {|m| m }
      token(/(?<!\w)load(?!\w)/) {|m| m }
      token(/(?<!\w)new(?!\w)/) {|m| m }
      token(/(?<!\w)str(?!\w)/) {|m| m }
      token(/(?<!\w)cls(?!\w)/) {|m| m }
      token(/(?<!\w)len(?!\w)/) {|m| m }      
      token(/(?<!\w)remove(?!\w)/) {|m| m }
      token(/(?<!\w)append(?!\w)/) {|m| m }
      token(/(?<!\w)insert(?!\w)/) {|m| m }
      token(/break/) { Break.new() }
      token(/\((-?\d+)(\.{2,3})(-?\d+)\)/) do |m|
        mymatch = m.match(/\((-?\d+)(\.{2,3})(-?\d+)\)/)
        Range.new(mymatch[1].to_i, mymatch[2], mymatch[3].to_i)
      end
      
      token(/<</) {|m| m }
      token(/<=/){|m| CompOp.new(m) }
      token(/==/){|m| CompOp.new(m) }
      token(/!=/){|m| CompOp.new(m) }
      token(/</){|m| CompOp.new(m)  }
      token(/>=/){|m| CompOp.new(m) }
      token(/>/){|m| CompOp.new(m)  }

      token(/^\$[a-zA-Z_0-9]*/) {|m| GIdentifier.new(m) }
      # returns variable/function names as an Identifier object
      token(/^[a-zA-Z][a-zA-Z_0-9]*/) {|m| Identifier.new(m) }

      token(/((?<![\\])['"])((?:.(?!(?<![\\])\1))*.?)\1/) do |m|
        m = m[1...-1]
        LiteralString.new(m)
      end # returns a LiteralString object

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
        match(:prop)
        match(:event)
        match(:function_def)
      end

      rule :prop do
        match("prop", Identifier, "{", :init, "}") {|_, idn, _, i, _|
          if i.class != Array
            raise "Missed parentheses for init while defining prop '#{idn.name}'"
          end
          $props[idn.name] = Prop.new(idn, i[0], i[1])
        }
      end

      rule :event do
        match("event", Identifier, "{", :init, "run", :block, "}") do |_, idn, _, i, _, b, _|
          if i.class == Array
            raise "Event '#{idn.name}' should not have parameters"
          end
          $events[idn.name] = Event.new(i, b)
        end
      end

      rule :init do #Kan vi avgöra vilken init som skall tillåtas på det här djupet?
        match("init", "(", :params, ")", :block) {|_, _, p, _, b, _| [p,b] }
        match("init", :block) {|_, b| b }
      end

      rule :function_def do
        match("def", Identifier, "(", :params, ")", :block) do
          |_, func, _, params, _, block|
          $functions[func.name] = Function.new(params, block)
        end
      end

      rule :params do
        match(:params, ",", :param) {|m, _, n| m + Array(n) }
        match(:param) {|m| Array(m)}
        match(:empty)  {|m| [] }
      end

      rule :param do
        match(:identifier) {|m| m}
      end

      rule :block do
        match("{", :statements, "}") {|_, m, _| Block.new(m)}
        match("{", :empty, "}") { Block.new()}
      end

      rule :function_call do
        match(Identifier, "(", :values, ")") do |idn, _, args, _|
          FunctionCall.new(idn, args)
        end
        match("write", "(", Identifier, ")") do |_, _, idn, _|
          Write.new(IdentifierNode.new(idn))
        end
        match("write", "(", GIdentifier, ")") do |_, _, idn, _|
          Write.new(GIdentifierNode.new(idn))
        end
        match("write", "(", :exp, ")") {|_, _, s, _| Write.new(s)}
        match("write", "(", ")") { Write.new("")}
        match("read", "(", :exp, ")") {|_, _, m, _| Read.new(m)}
        match("read", "(", ")") {|_, _, _| Read.new()}
        match("wait", "(", Integer, ")") {|_, _, s, _| Wait.new(s)}
        match("wait") {raise "Wait takes a positive integer as argument"}
        match("load", "(", Identifier, ")") { |_, _, idn, _| Load.new(idn.name) }
        match("str", "(", :exp, ")") {|_, _, exp, _| ToString.new(exp)}
        match("cls", "(", ")") { Clear.new()}
      end

      rule :statements do
        match(:statements, :statement) {|m, n| m + Array(n) }
        match(:statement) {|m| Array(m)}
      end

      rule :statement do
        match(:condition)
        match(:loop)
        match(:assignment)
        match(:array_op)
        match(:exp)
        match(Break)
      end

      # rule :assignments do
      #   match(:assignments, :assignment) {|m, n| m + Array(n) }
      #   match(:assignment) {|m| Array(m)}
      # end

      rule :assignment do
        match(:identifier, "=", :array_op) do |idn, _, a|
          Assignment.new(idn, a)
        end
        match(:identifier, "=", :exp) do |idn, _, exp|
          Assignment.new(idn, exp)
        end
        match(:identifier, "[", Integer, "]", "=", :exp) do |idn, _, index, _, _, exp|
          ElementWriter.new(idn, index, exp)
        end
        match(:identifier, ".", Identifier, "=", :exp) do |idn, _, attr, _, exp|
          AttributeWriter.new(idn, attr, exp)
        end
      end

      rule :exp do
        match(:exp, "and", :bool_exp) {|lhs, _, rhs| And.new(lhs, rhs) }
        match(:exp, "or", :bool_exp) {|lhs, _, rhs| Or.new(lhs, rhs) }
        match("not", :exp) {|_, m, _| Not.new(m) }
        match(:bool_exp) {|m| m}
      end

      rule :bool_exp do
        match(:math_exp, CompOp, :math_exp) do |lhs, c, rhs| #finns det bättre lösning?
          case c.op
          when "<=" then
            LessEqual.new(lhs, rhs)
          when "==" then
            Equal.new(lhs, rhs)
          when "!=" then
            NotEqual.new(lhs, rhs)
          when "<" then
            Less.new(lhs, rhs)
          when ">=" then
            GreaterEqual.new(lhs, rhs)
          when ">" then
            Greater.new(lhs, rhs)
          end
        end

        match(:bool_val, CompOp, :bool_val) do |lhs, c, rhs|
          case c.op
          when "==" then
            Equal.new(lhs, rhs)
          when "!=" then
            NotEqual.new(lhs, rhs)
          end
        end

        match(:bool_val) {|m| m }

      end

      rule :bool_val do
        match("true") {|b| LiteralBool.new(b) }
        match("false") {|b| LiteralBool.new(b) }
        match(:math_exp)
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
        match(:signs, Integer) {|s, m|  Multiplication.new(s, m) }
        match(:signs, "(", :math_exp , ")") {|s, _, m, _| Multiplication.new(s, m) }
        match("(", :exp , ")") {|_, m, _| m }
        match(:function_call) 
        match(:array)
        match(:instancering)
        match(:instance_reader)
        match(:identifiernode)
        match(LiteralString)
        match(Range)
      end
      
      rule :signs do
        match(:signs, :sign) {|a, b| Multiplication.new(a, b) }
        match(:sign)
      end

      rule :sign do
        match("+") { LiteralInteger.new(1)  }
        match("-") { LiteralInteger.new(-1) }
      end

      rule :array do
        match("[", :values, "]") {|_, v, _| List.new(v)}
        match("[", "]") { List.new([]) }
      end

      rule :array_op do
        match(:identifier, "[", Integer, "]") do |idn, _, index, _| 
          ElementReader.new(idn, index)
        end
        match(:identifier, ".", "remove", "(", :exp, ")") do |idn, _, _, _, index, _| 
          ElementRemover.new(idn, index)
        end
        match(:identifier, ".", "remove", "(", ")") do |idn, _, _, _, _| 
          ElementRemover.new(idn)
        end
        match(:identifier, ".", "append", "(", :exp, ")") do |idn, _, _, _, exp, _| 
          ListAppend.new(idn, exp)
        end
        match(:identifier, "<<", :exp) do |idn, _, exp| 
          ListAppend.new(idn, exp)
        end
        match(:identifier, ".", "insert", "(", Integer, ",", :exp, ")") do |idn, _, _, _, index, _, exp, _| 
          ListInsert.new(idn, index, exp)
        end
        match(:identifier, ".", "len") {|idn, _, _| ListLength.new(idn) }
      end

      rule :values do
        match(:values, ",", :exp) {|m, _, n| m + Array(n)}
        match(:exp) {|m| Array(m)}
        match(:empty)  {|m| [] }
      end

      rule :instancering do
        match(:identifier, ".", "new", "(", :values, ")") do |idn, _, _, _, args, _ |
          Instancering.new(idn, args)
        end
      end
      rule :instance_reader do
        match(:identifier, ".", :identifier) { |idn, _, attr, _ |
          AttributeReader.new(idn, attr)
        }
      end

      rule :condition do
        match(:if)
        match(:switch)
      end

      rule :if do
        match("if", :exp, :block, "else", :block) {|_, e, b, _, eb| If.new(e, b, eb)}
        match("if", :exp, :block) {|_, e, b| If.new(e, b)}
      end

      rule :switch do
        match("switch", "(", :exp, ")", :cases) {|_, _, val, _, cases| Switch.new(val, cases)}
        match("switch", "(", :exp, ")") {raise "Switch needs at least one case"}
      end

      rule :cases do
        match(:cases, :case) {|m, n| m + Array(n) }
        match(:case) {|m| Array(m)}
      end

      rule :case do
        match("case", "(", :exp, ")", :block) {|_, _, val, _, block|  Case.new(val, block) }
      end

      rule :loop do
        match("while", :exp, :block) {|_, e, b| While.new(e, b)}
        match("for", Identifier, "in", Range, :block) { |_, i, _, r, b| For.new(i, r, b)}
        match("for", Identifier, "in", :array, :block) {|_, i, _, a, b| For.new(i, a, b)}
        match("for", Identifier, "in", Identifier, :block) do |_, i1, _, i2, b|
          For.new(i1, IdentifierNode.new(i2), b)
        end
        match("for", Identifier, "in", GIdentifier, :block) do |_, i1, _, i2, b|
          For.new(i1, GIdentifierNode.new(i2), b)
        end
      end

      rule :identifier do
        match(Identifier)
        match(GIdentifier)
      end
      rule :identifiernode do
        match(Identifier) {|m| IdentifierNode.new(m)}
        match(GIdentifier) {|m| GIdentifierNode.new(m)}
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
      log(false)
     # print "[gameParser] #{format('%03d', @line)}: "
      print "[gameParser]: "
      #str = File.read(file)
      str = gets
      if done(str) then
        puts "Bye."
      else
        puts "=> #{@gameParser.parse str}"
        @line +=1
        parse()
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
  if ARGV[0] == nil
    GameLanguage.new.parse()
  else
    file = File.read(ARGV[0])
    gp = GameLanguage.new()
    gp.parse_string(file)
  end
end
