require './gameparser'
require 'test/unit'

class Variable_assignment < Test::Unit::TestCase

  def test_int
    gp = GameLanguage.new
    
    assert_equal(1, gp.parse_string(" i = 1"))
    assert_equal(1,gp.parse_string("i")) # doubble check if "i" keeps its value
    
    assert_equal(250, gp.parse_string(" i = 250"))
    assert_equal(250, gp.parse_string("i"))

    assert_equal(-34, gp.parse_string(" i = -34"))
    assert_equal(-34, gp.parse_string("i")) # doubble check if "i" keeps its value
    
  end
  
  def test_string
    gp = GameLanguage.new
    
    assert_equal("Hej", gp.parse_string(' i = "Hej"'))
    assert_equal("Hej", gp.parse_string("i"))
    
    assert_equal("nO", gp.parse_string(' i = "nO"'))
    assert_equal("nO", gp.parse_string("i"))
  end
  
  def test_bool
    gp = GameLanguage.new
    
    assert_equal(true, gp.parse_string(" i = true"))
    assert_equal(true, gp.parse_string(" i"))
    
    assert_equal(false, gp.parse_string(" i = false"))
    assert_equal(false, gp.parse_string("i"))
  end
  
end

class SimpleArithmetic < Test::Unit::TestCase
  def test_addition
    gp = GameLanguage.new

    assert_equal(4, gp.parse_string("2 + 2"))
    assert_equal(6, gp.parse_string("2 + 2 + 2"))
    assert_equal(62, gp.parse_string("2 + 10 + 20 + 30"))
    assert_equal(20, gp.parse_string("10 +    10"))
    assert_equal(101, gp.parse_string("100 + 1"))
    assert_equal(-18, gp.parse_string("-19 + 1"))
    assert_equal(10, gp.parse_string("-220 + 230"))
    assert_equal(0, gp.parse_string("-440 + 440"))
    assert_equal(105, gp.parse_string("100+5"))
    assert_equal(400, gp.parse_string("100+100+ 100 +100"))
  end
  
  def test_subtraction
    gp = GameLanguage.new
    
    assert_equal(0, gp.parse_string("2 - 2"))
    assert_equal(-2, gp.parse_string("2 - 2 - 2"))
    assert_equal(15, gp.parse_string("20 - 2 - 3"))
    assert_equal(8, gp.parse_string("10 -   2"))
    assert_equal(-10, gp.parse_string("10 - 20"))
    assert_equal(-30, gp.parse_string("-10 - 20"))
    assert_equal(0, gp.parse_string("-1 - (-1)"))
    assert_equal(-42, gp.parse_string("(-22) - 20"))
    assert_equal(-1, gp.parse_string("1 -2"))
    assert_equal(-4, gp.parse_string("1 -2-2 - 1"))
    
  end
end

class ArithmeticPriority < Test::Unit::TestCase
  def test
    gp = GameLanguage.new
    
    assert_equal(22, gp.parse_string("2 + 2 * 10"))
    assert_equal(40, gp.parse_string("(2 + 2) * 10"))
    assert_equal(16, gp.parse_string("(2 + 2) * (2 + 2)"))
  end
end

class SimpleLogicalExpression < Test::Unit::TestCase
  def test_and
    gp = GameLanguage.new
    
    assert_equal(true, gp.parse_string("true and true"))
    assert_equal(false, gp.parse_string("true and false"))
    assert_equal(false, gp.parse_string("false and true"))
    assert_equal(false, gp.parse_string("false and false"))
  end
   def test_or
     gp = GameLanguage.new
     
     assert_equal(true, gp.parse_string("true or true"))
     assert_equal(true, gp.parse_string("true or false"))
     assert_equal(true, gp.parse_string("false or true"))
     assert_equal(false, gp.parse_string("false or false"))
   end
   def test_not
     gp = GameLanguage.new
     
     assert_equal(false, gp.parse_string("not true"))
     assert_equal(true, gp.parse_string("not false"))
   end
end

class LogicalExpressionPriority < Test::Unit::TestCase
  def test
    gp = GameLanguage.new

    assert_equal(true, gp.parse_string("(true and true) and true"))
    assert_equal(false, gp.parse_string("(true and false) and true"))
    assert_equal(false, gp.parse_string("(true and false) and false"))
    assert_equal(true, gp.parse_string("(true and false) or true"))
    assert_equal(false, gp.parse_string("(true and false) and ( false and true)"))
    assert_equal(true, gp.parse_string("(true and false) or ( (false or true) and true)"))
  end
end

class BooleanExpression < Test::Unit::TestCase
  def test_less
    gp = GameLanguage.new

    assert_equal(true, gp.parse_string("1 < 2"))
    assert_equal(true, gp.parse_string("-10 < 6"))
    assert_equal(false, gp.parse_string("-10 < -12"))
    assert_equal(false, gp.parse_string("390 < 2"))
    assert_equal(false, gp.parse_string("0 < -1"))
  end
  
  def test_greater
    gp = GameLanguage.new

    assert_equal(true, gp.parse_string("146 > 44"))
    assert_equal(true, gp.parse_string("-100 > -101 "))
    assert_equal(true, gp.parse_string("0 > -12"))
    assert_equal(false, gp.parse_string("20 > 120"))
    assert_equal(false, gp.parse_string("-12 > -1"))
  end

  def test_less_equal
    gp = GameLanguage.new

    assert_equal(false, gp.parse_string("146 <= 44"))
    assert_equal(true, gp.parse_string("-100 <= -100 "))
    assert_equal(false, gp.parse_string("0 <= -12"))
    assert_equal(true, gp.parse_string("222 <= 980"))
    assert_equal(true, gp.parse_string("-12 <= 1"))
  end
  
  def test_greater_equal
    gp = GameLanguage.new

    assert_equal(true, gp.parse_string("146 >= 44"))
    assert_equal(true, gp.parse_string("-100 >= -100 "))
    assert_equal(true, gp.parse_string("0 >= -12"))
    assert_equal(false, gp.parse_string("222 >= 980"))
    assert_equal(false, gp.parse_string("-12 >= 1"))
  end

  def test_equal
    gp = GameLanguage.new

    assert_equal(false, gp.parse_string("146 == 44"))
    assert_equal(true, gp.parse_string("-100 == -100 "))
    assert_equal(false, gp.parse_string("0 == -12"))
    assert_equal(true, gp.parse_string("210 == 210"))
  end
  
  def test_not_equal
    gp = GameLanguage.new
    
    assert_equal(true, gp.parse_string("146 != 44"))
    assert_equal(false, gp.parse_string("-100 != -100 "))
    assert_equal(true, gp.parse_string("0 != -12"))
    assert_equal(false, gp.parse_string("300 != 300"))
  end
  
end

class BoolLogic < Test::Unit::TestCase
  def test_bool_logic
    gp = GameLanguage.new

    assert_equal(false, gp.parse_string("(12 > 100) and (100 < 2)" ))
    assert_equal(false, gp.parse_string("not ((12 > 10) or (100 < 2))"))
    assert_equal(true , gp.parse_string("(2 == 2) and (100 >= 2)"))
  end
end

class Lista < Test::Unit::TestCase
  def test_lista
    gp = GameLanguage.new

    assert_equal([], gp.parse_string("[]"))
    assert_equal([1,2,3], gp.parse_string("[1,2,3]"))
    assert_equal(["a", "b", "c"], gp.parse_string('["a","b","c"]'))
    assert_equal(["a", "b", "c"], gp.parse_string("['a','b','c']"))
    assert_equal([true, true, false], gp.parse_string("[true,true,false]"))
    assert_equal([1,"a",1<5], gp.parse_string("[1,'a',true]"))
  end
end

# ============================================================
# Template
# ============================================================
# class "..." < Test::Unit::TestCase
#   def "..."
#     gp = GameLanguage.new
#
#     assert_equal( , gp.parse_string())
#     assert_equal( , gp.parse_string())
#     assert_equal( , gp.parse_string())
#   end
# end
