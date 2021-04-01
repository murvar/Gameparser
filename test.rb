require './gameparser'
require 'test/unit'


class StrTest < Test::Unit::TestCase
  def test1
    gp = GameLanguage.new

    assert_equal("Hi" , gp.parse_string('"Hi"'))
    assert_equal("Hi123" , gp.parse_string('"Hi123"'))
    assert_equal("123Hi" , gp.parse_string('"123Hi"'))
    assert_equal("Hello World" , gp.parse_string('"Hello World"'))
    assert_equal("Hey!" , gp.parse_string('"Hey!"'))
    assert_equal("###Bye" , gp.parse_string('"###Bye"'))

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
  def test3
    gp = GameLanguage.new

    assert_equal(22, gp.parse_string("2 + 2 * 10"))
    assert_equal(40, gp.parse_string("(2 + 2) * 10"))
    assert_equal(16, gp.parse_string("(2 + 2) * (2 + 2)"))
    assert_equal(1, gp.parse_string("(22/2) + (2 * 5) - (+20)"))
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
  def test3
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



class Variable_assignment < Test::Unit::TestCase

  def test_int
    gp = GameLanguage.new

    assert_equal(1, gp.parse_string(" i = 1"))
    assert_equal(1,gp.parse_string("i")) # doubble check if "i" keeps its value
    
    assert_equal(250, gp.parse_string(" i = 250"))
    assert_equal(250, gp.parse_string("i"))

    assert_equal(-34, gp.parse_string(" temp = -34"))
    assert_equal(-34, gp.parse_string("temp"))

    assert_equal(43, gp.parse_string(" age = +43"))
    assert_equal(43, gp.parse_string("age"))

    assert_equal(5, gp.parse_string(" student1 = 5"))
    assert_equal(5, gp.parse_string("student1"))

    assert_equal(-225, gp.parse_string(" my_dog = -225"))
    assert_equal(-225, gp.parse_string("my_dog "))
  end
  
  def test_string
    gp = GameLanguage.new

    assert_equal("Hej", gp.parse_string(' i = "Hej"'))
    assert_equal("Hej", gp.parse_string("i"))
    
    assert_equal("nO", gp.parse_string(' i = "nO"'))
    assert_equal("nO", gp.parse_string("i"))

    #asser_equal("Hello Worlds!", gp.parse_string('"Hello" + "World!"'))
    
  end
  
  def test_bool
    gp = GameLanguage.new

    assert_equal(true, gp.parse_string(" i = true"))
    assert_equal(true, gp.parse_string(" i"))
    
    assert_equal(false, gp.parse_string(" i = false"))
    assert_equal(false, gp.parse_string("i"))

    assert_equal(true, gp.parse_string(" value = (2 + 2) < (34 - (+2))"))
    assert_equal(true, gp.parse_string("value"))

    assert_equal(false, gp.parse_string(" value = false or (not(true or false))"))
    assert_equal(false, gp.parse_string(" value"))
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
