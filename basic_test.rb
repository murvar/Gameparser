# coding: utf-8
require './gameparser'
require 'test/unit'

class SimpleTest < Test::Unit::TestCase

  def test1
    gp = GameLanguage.new

    assert_equal(1, gp.parse_string("1"))
    assert_equal(123, gp.parse_string("123"))
    assert_equal(888, gp.parse_string("888"))
    assert_equal(10000, gp.parse_string("10000"))
    assert_equal(100000000, gp.parse_string("100000000"))

    assert_equal(-1, gp.parse_string("-1"))
    assert_equal(123, gp.parse_string("--123"))
    assert_equal(-888, gp.parse_string("---888"))
    assert_equal(-101, gp.parse_string("-+-+-101"))
    assert_equal(100000000, gp.parse_string("+++++100000000"))

  end

  def test2
    gp = GameLanguage.new

    assert_equal("Hi", gp.parse_string('"Hi"'))
    assert_equal("Hi123", gp.parse_string('"Hi123"'))
    assert_equal("123Hi", gp.parse_string('"123Hi"'))
    assert_equal("Hello World", gp.parse_string('"Hello World"'))
    assert_equal("Hey!", gp.parse_string('"Hey!"'))
    assert_equal("###Bye", gp.parse_string('"###Bye"'))
    assert_equal("Hallå där!", gp.parse_string('"Hallå där!"'))
    assert_equal("ÄÖÅ äöå!", gp.parse_string('"ÄÖÅ äöå!"'))
    assert_equal("2 + 2 / 0", gp.parse_string('"2 + 2 / 0"'))
    assert_equal("false", gp.parse_string('"false"'))
    assert_equal("def t()", gp.parse_string('"def t()"'))
  end

  def test3
    gp = GameLanguage.new

    assert_equal(true, gp.parse_string("true"))
    assert_equal(false, gp.parse_string("false"))
  end

  def test4
    gp = GameLanguage.new

    assert_equal([], gp.parse_string("[]"))
    assert_equal([1,2,3], gp.parse_string("[1,2,3]"))
    assert_equal(["a", "b", "c"], gp.parse_string('["a","b","c"]'))
    assert_equal(["a", "b", "c"], gp.parse_string("['a','b','c']"))
    assert_equal([true, true, false], gp.parse_string("[true,true,false]"))
    assert_equal([1, "a", true], gp.parse_string("[1,'a',true]"))
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

  def test_multiplication
    gp = GameLanguage.new

    assert_equal(0, gp.parse_string("2 *0"))
    assert_equal(0, gp.parse_string("0 *0"))
    assert_equal(40, gp.parse_string("20 *2"))
    assert_equal(-10, gp.parse_string("10 *-1"))
    assert_equal(3300, gp.parse_string("33* 100"))
  end

  def test_division
    gp = GameLanguage.new

    assert_equal(0, gp.parse_string("0/2"))
    assert_equal(0, gp.parse_string("0 /110"))
    assert_equal(10, gp.parse_string("20 /2"))
    assert_equal(-10, gp.parse_string("10 /-1"))
    assert_equal(0, gp.parse_string("33/ 100")) # Integer division
  end
end

class ArithmeticPriority < Test::Unit::TestCase
  def test1
    gp = GameLanguage.new
    
    assert_equal(22, gp.parse_string("2 + 2 * 10"))
    assert_equal(40, gp.parse_string("(2 + 2) * 10"))
    assert_equal(14, gp.parse_string("2 * 2 + 10"))
    assert_equal(11, gp.parse_string("2 / 2 + 10"))
    assert_equal(21, gp.parse_string("2 / 2 + 10 * 2"))
    assert_equal(22, gp.parse_string("2 / 2 + 10 * 2 + 1"))
    assert_equal(16, gp.parse_string("(2 + 2) * (2 + 2)"))
    assert_equal(1, gp.parse_string("(22/2) + (2 * 5) - (+20)"))

    assert_equal(3, gp.parse_string("--(++3)"))
    assert_equal(1, gp.parse_string("2 +-1"))
    assert_equal(0, gp.parse_string("2 +-1 * 2"))
    assert_equal(100, gp.parse_string("2 +-1 * 2 ++100"))
    assert_equal(-4, gp.parse_string("--(+-2) +-1 * 2"))
    assert_equal(-4, gp.parse_string("--(+-2) +-1 * (-++-2)"))
    assert_equal(-2, gp.parse_string("--(+-2) +-1 / (-++2)"))
    
  end
end

class LogicalExp < Test::Unit::TestCase
  def test_and
    gp = GameLanguage.new

    assert_equal(true, gp.parse_string("true and true"))
    assert_equal(false, gp.parse_string("true and false"))
    assert_equal(false, gp.parse_string("false and true"))
    assert_equal(false, gp.parse_string("false and false"))
    
    assert_equal(2, gp.parse_string("2 and 2"))
    assert_equal(2, gp.parse_string("10 and 2"))
    assert_equal(-12, gp.parse_string("10 and -12"))
  end
  def test_or
    gp = GameLanguage.new

    assert_equal(true, gp.parse_string("true or true"))
    assert_equal(true, gp.parse_string("true or false"))
    assert_equal(true, gp.parse_string("false or true"))
    assert_equal(false, gp.parse_string("false or false"))
    
    assert_equal(2, gp.parse_string("2 or 2"))
    assert_equal(10, gp.parse_string("10 or 2"))
    assert_equal(10, gp.parse_string("10 or -12"))
    
  end
  def test_not
    gp = GameLanguage.new

    assert_equal(false, gp.parse_string("not true"))
    assert_equal(true, gp.parse_string("not false"))

    assert_equal(false, gp.parse_string("not 2"))
    assert_equal(false, gp.parse_string("not -12"))
    assert_equal(false, gp.parse_string("not 0"))
  end
end

class LogicalExpPriority < Test::Unit::TestCase
  def test3
    gp = GameLanguage.new

    assert_equal(true, gp.parse_string("(true and true) and true"))
    assert_equal(false, gp.parse_string("(true and false) and true"))
    assert_equal(false, gp.parse_string("(true and false) and false"))
    assert_equal(true, gp.parse_string("(true and false) or true"))
    assert_equal(false, gp.parse_string("(true and false) and ( false and true)"))
    assert_equal(true, gp.parse_string("(true and false) or ( (false or true) and true)"))
    assert_equal(true, gp.parse_string("false and true or true"))
    assert_equal(false, gp.parse_string("false and true or true and false"))
  end
end

class BooleanExp < Test::Unit::TestCase
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
    assert_equal(true, gp.parse_string("(2 == 2) and (100 >= 2)"))
    assert_equal(true, gp.parse_string("2 == 2 and 100 >= 2"))
    assert_equal(false, gp.parse_string("2 == 3 or 100 >= 200"))
  end
end

class VariableAssignment < Test::Unit::TestCase

  def test_int
    gp = GameLanguage.new

    assert_equal(1, gp.parse_string(" i = 1"))
    assert_equal(1,gp.parse_string("i")) # doubble check if "i" keeps its value

    assert_equal(250, gp.parse_string(" i = 250"))
    assert_equal(250, gp.parse_string("i"))
    assert_equal(300, gp.parse_string(" k = i + 50"))
    assert_equal(300, gp.parse_string("k"))
    assert_equal(250, gp.parse_string("i"))

    assert_equal(250, gp.parse_string("i = 250"))
    assert_equal(300, gp.parse_string(" k = 50 + i"))
    assert_equal(300, gp.parse_string("k"))
    assert_equal(250, gp.parse_string("i"))

    assert_equal(250, gp.parse_string("i = 250"))
    assert_equal(-200, gp.parse_string(" k = 50 - i"))
    assert_equal(-200, gp.parse_string("k"))
    assert_equal(250, gp.parse_string("i"))

    assert_equal(250, gp.parse_string("i = 250"))
    assert_equal(200, gp.parse_string(" k = i - 50"))
    assert_equal(200, gp.parse_string("k"))
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

    assert_equal("Hello World!", gp.parse_string('greeting = "Hello " + "World!"'))

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

  def test_list
    gp = GameLanguage.new

    assert_equal([23, 11, 578], gp.parse_string("l = [23, 11, 578]"))
    assert_equal([23, 11, 578], gp.parse_string("l"))
    assert_equal(23, gp.parse_string("l[0]"))
    assert_equal(11, gp.parse_string("l[1]"))
    assert_equal(578, gp.parse_string("l[2]"))

    assert_equal(1, gp.parse_string("l[0] = 1"))
    assert_equal([1, 11, 578], gp.parse_string("l"))
    assert_equal(2, gp.parse_string("l[1] = 2"))
    assert_equal([1, 2, 578], gp.parse_string("l"))
    assert_equal(3, gp.parse_string("l[2] = 3"))
    assert_equal([1, 2, 3], gp.parse_string("l"))


    assert_equal([true, false, true], gp.parse_string("l2 = [true, false, true]"))
    assert_equal([true, false, true], gp.parse_string("l2"))
    assert_equal(true, gp.parse_string("l2[0]"))
    assert_equal(false, gp.parse_string("l2[1]"))
    assert_equal(true, gp.parse_string("l2[2]"))

    assert_equal(true, gp.parse_string("l2[0] = true"))
    assert_equal([true, false, true], gp.parse_string("l2"))
    assert_equal(true, gp.parse_string("l2[1] = true"))
    assert_equal([true, true, true], gp.parse_string("l2"))
    assert_equal(true, gp.parse_string("l2[2] = true"))
    assert_equal([true, true, true], gp.parse_string("l2"))


    assert_equal(["a", "b", "c"], gp.parse_string('l3 = ["a","b","c"]'))
    assert_equal(["a", "b", "c"], gp.parse_string("l3"))
    assert_equal("a", gp.parse_string("l3[0]"))
    assert_equal("b", gp.parse_string("l3[1]"))
    assert_equal("c", gp.parse_string("l3[2]"))

    assert_equal("x", gp.parse_string('l3[0] = "x"'))
    assert_equal(["x", "b", "c"], gp.parse_string("l3"))
    assert_equal("y", gp.parse_string('l3[1] = "y"'))
    assert_equal(["x", "y", "c"], gp.parse_string("l3"))
    assert_equal("z", gp.parse_string('l3[2] = "z"'))
    assert_equal(["x", "y", "z"], gp.parse_string("l3"))

  end
end

class ListOperation < Test::Unit::TestCase
  
  def test1_remove() # removes by index. Whitout index pop the list.
    gp = GameLanguage.new

    assert_equal([1, 2, 3], gp.parse_string("l = [1, 2, 3]"))
    assert_equal(1, gp.parse_string("l.remove(0)"))
    assert_equal([2, 3], gp.parse_string("l"))

    assert_equal([1, -2, 3], gp.parse_string("l = [1, -2, 3]"))
    assert_equal(-2, gp.parse_string("l.remove(1)"))
    assert_equal([1, 3], gp.parse_string("l"))
    
    assert_equal([true, true, false], gp.parse_string("l = [true, true, false]"))
    assert_equal(false, gp.parse_string("l.remove(2)"))
    assert_equal([true, true], gp.parse_string("l"))

    assert_equal(["a", "b", "c"], gp.parse_string('l = ["a", "b", "c"]'))
    assert_equal("b", gp.parse_string("l.remove(1)"))
    assert_equal(["a", "c"], gp.parse_string("l"))

    assert_equal([[1, 2], [3, 4], [5, 6]], gp.parse_string("l = [[1, 2], [3, 4], [5, 6]]"))
    assert_equal([1, 2], gp.parse_string("l.remove(0)"))
    assert_equal([[3, 4], [5, 6]], gp.parse_string("l"))

    assert_equal(1, gp.parse_string("index = 1"))
    assert_equal([1, 2, 3], gp.parse_string("l = [1, 2, 3]"))
    assert_equal(2, gp.parse_string("l.remove(index)"))
    assert_equal([1, 3], gp.parse_string("l"))

    assert_equal([1, 2, 3], gp.parse_string("l = [1, 2, 3]"))
    assert_equal(3, gp.parse_string("l.remove()"))
    assert_equal([1, 2], gp.parse_string("l"))


    code1 = '
           l = [100, 200, 300]
           l.remove(0)
           '

    assert_equal(100, gp.parse_string(code1))

    code2 = '
           l = [100, 200, 300]
           l.remove()
           '
    assert_equal(300, gp.parse_string(code2))
    
  end

  def test2_append()
    gp = GameLanguage.new

    assert_equal([1, 2, 3], gp.parse_string("l = [1, 2, 3]"))
    assert_equal([1, 2, 3, 4], gp.parse_string("l.append(4)"))
    assert_equal([1, 2, 3, 4], gp.parse_string("l"))

    assert_equal([1, 2, 3], gp.parse_string("l = [1, 2, 3]"))
    assert_equal([1, 2, 3, -5], gp.parse_string("l.append(-5)"))
    assert_equal([1, 2, 3, -5], gp.parse_string("l"))

    assert_equal([1, 2, 3], gp.parse_string("l = [1, 2, 3]"))
    assert_equal([1, 2, 3, 4], gp.parse_string("l << 4"))
    assert_equal([1, 2, 3, 4], gp.parse_string("l"))
    
    
    assert_equal([true, true, false], gp.parse_string("l = [true, true, false]"))
    assert_equal([true, true, false, false], gp.parse_string("l.append(false)"))
    assert_equal([true, true, false, false], gp.parse_string("l"))

    assert_equal(["a", "b", "c"], gp.parse_string('l = ["a", "b", "c"]'))
    assert_equal(["a", "b", "c", "d"], gp.parse_string('l.append("d")'))
    assert_equal(["a", "b", "c", "d"], gp.parse_string("l"))

    assert_equal([[1, 2], [3, 4], [5, 6]], gp.parse_string("l = [[1, 2], [3, 4], [5, 6]]"))
    assert_equal([[1, 2], [3, 4], [5, 6], [7, 8]], gp.parse_string("l.append([7, 8])"))
    assert_equal([[1, 2], [3, 4], [5, 6], [7, 8]], gp.parse_string("l"))

    assert_equal(4, gp.parse_string("value = 4"))
    assert_equal([1, 2, 3], gp.parse_string("l = [1, 2, 3]"))
    assert_equal([1, 2, 3, 4], gp.parse_string("l.append(value)"))
    assert_equal([1, 2, 3, 4], gp.parse_string("l"))

    assert_equal(-100, gp.parse_string("value = -100"))
    assert_equal([1, 2, 3], gp.parse_string("l = [1, 2, 3]"))
    assert_equal([1, 2, 3, -100], gp.parse_string("l << value"))
    assert_equal([1, 2, 3, -100], gp.parse_string("l"))
    
    code1 = '
           l = [100, 200, 300]
           l.append(400)
           '

    assert_equal([100, 200, 300, 400], gp.parse_string(code1))

    code2 = '
           l = [100, 200, 300]
           l.append(400)
           l
           '
    assert_equal([100, 200, 300, 400], gp.parse_string(code2))
  end
  def test3_insert() # insert(index, value)
    gp = GameLanguage.new

    assert_equal([1, 2, 3], gp.parse_string("l = [1, 2, 3]"))
    assert_equal([0, 1, 2, 3], gp.parse_string("l.insert(0, 0)"))
    assert_equal([0, 1, 2, 3], gp.parse_string("l"))

    assert_equal([1, 2, 3], gp.parse_string("l = [1, 2, 3]"))
    assert_equal([-1, 1, 2, 3], gp.parse_string("l.insert(0, -1)"))
    assert_equal([-1, 1, 2, 3], gp.parse_string("l"))
    
    assert_equal([true, true, true], gp.parse_string("l = [true, true, true]"))
    assert_equal([true, false, true, true], gp.parse_string("l.insert(1, false)"))
    assert_equal([true, false, true, true], gp.parse_string("l"))

    assert_equal(["a", "b", "c"], gp.parse_string('l = ["a", "b", "c"]'))
    assert_equal(["a", "b", "c", "d"], gp.parse_string('l.insert(3, "d")'))
    assert_equal(["a", "b", "c", "d"], gp.parse_string("l"))
    assert_equal(["a", "b", "c", "x", "d"], gp.parse_string('l.insert(3, "x")'))
    assert_equal(["a", "b", "c", "x", "d"], gp.parse_string("l"))

    assert_equal([[1, 2], [3, 4], [5, 6]], gp.parse_string("l = [[1, 2], [3, 4], [5, 6]]"))
    assert_equal([[1, 2], [3, 4], [7, 8], [5, 6]], gp.parse_string("l.insert(2, [7, 8])"))
    assert_equal([[1, 2], [3, 4], [7, 8], [5, 6]], gp.parse_string("l"))

    assert_equal(4, gp.parse_string("value = 4"))
    assert_equal([1, 2, 3], gp.parse_string("l = [1, 2, 3]"))
    assert_equal([1, 4, 2, 3], gp.parse_string("l.insert(1, value)"))
    assert_equal([1, 4, 2, 3], gp.parse_string("l"))
    
    code1 = '
           l = [100, 200, 300]
           l.insert(3, 400)
           '

    assert_equal([100, 200, 300, 400], gp.parse_string(code1))

    code2 = '
           l = [100, 200, 300]
           l.insert(3, 400)
           l
           '
    assert_equal([100, 200, 300, 400], gp.parse_string(code2))

  end
end

class GlobalVars < Test::Unit::TestCase
  def test1_assignment()
    gp = GameLanguage.new

    assert_equal(1, gp.parse_string("$my_int = 1"))
    assert_equal(1, gp.parse_string("$my_int"))

    assert_equal(true, gp.parse_string("$my_bool = true"))
    assert_equal(true, gp.parse_string("$my_bool"))

    assert_equal("Hello", gp.parse_string('$my_str = "Hello"'))
    assert_equal("Hello", gp.parse_string('$my_str'))

    assert_equal([1, 2, 3], gp.parse_string("$my_list = [1, 2, 3]"))
    assert_equal([1, 2, 3], gp.parse_string("$my_list"))
    assert_equal([1, 2, 3, 4], gp.parse_string("$my_list.append(4)"))
    assert_equal([1, 2, 3, 4, 4], gp.parse_string("$my_list.append(4)"))
    assert_equal([1, 2, 3, 4, 4], gp.parse_string("$my_list"))
    assert_equal(4, gp.parse_string("$my_list.remove()"))
    assert_equal([1, 2, 3, 4], gp.parse_string("$my_list"))
    assert_equal([1, -40, 2, 3, 4], gp.parse_string("$my_list.insert(1, -40)"))
    assert_equal([1, -40, 2, 3, 4], gp.parse_string("$my_list"))
    
  end

  def test2_access()
    gp = GameLanguage.new
      
    code = '$i = 22
           def function1(p)
           {
                p = $i + p
                p
           }'

    assert_equal(nil, gp.parse_string(code))
    assert_equal(24, gp.parse_string("function1(2)"))
    assert_equal(145, gp.parse_string("function1(123)"))


    code = '$i = 22
           def function2()
           {
                $i = $i + 1 
           }'
    assert_equal(nil, gp.parse_string(code))
    assert_equal(23, gp.parse_string("function2()"))
    assert_equal(24, gp.parse_string("function2()"))
    assert_equal(25, gp.parse_string("function2()"))
    assert_equal(26, gp.parse_string("function2()"))
  end
  def test3_access()
    gp = GameLanguage.new
    
    code = '$t = 40
           event Desert
           {
             init{}
             run
             {
                $t = $t + 10
                
             }
           }'

    assert_equal(nil, gp.parse_string(code))
    assert_equal(true, gp.parse_string("load(Desert)"))
    assert_equal(50, gp.parse_string("$t"))
    
  end
  def test4_access()
    gp = GameLanguage.new
    puts "Global variable access test 3:"
    
    code = '$global_hp = 150
           prop character
           {
             init(n, hp)
             {
                name = n
                health = $global_hp
                
             }
           }'

    assert_equal(nil, gp.parse_string(code))
    assert_equal(true, gp.parse_string('p1 = character.new("Hadi", 100) true'))
    assert_equal(150, gp.parse_string("p1.health"))
  end
end

class MultipleLine < Test::Unit::TestCase
  def test_mini()
    gp = GameLanguage.new


    code = "bool = true and false
            bool"
    assert_equal(false, gp.parse_string(code))


    code = "bool = true and false or true
            bool"
    assert_equal(true, gp.parse_string(code))

    code = "bool = true and false or true
            bool = 32 + 21
            bool"
    assert_equal(53, gp.parse_string(code))

    code = "bool1 = true and false or true
            bool1 = 32 + 21
            bool2 = bool1 * 10
            bool2"

    assert_equal(530, gp.parse_string(code))

    assert_equal(530, gp.parse_string("bool2"))

    code = "bool1 = true and false or true
            bool1 = 32 + 21
            bool2 = bool1 * 10
            2"

    assert_equal(2, gp.parse_string(code))

    code = "m = 20
            m = m + 20
            "
    assert_equal(40, gp.parse_string(code))

  end
end

class WriteTest < Test::Unit::TestCase
  def test1()
    gp = GameLanguage.new

    assert_equal(nil, gp.parse_string('write()'))
    assert_equal(nil, gp.parse_string('write("Testing \"write\":")'))
    assert_equal(nil, gp.parse_string('write("Hello World!")'))
    assert_equal(nil, gp.parse_string('write("write()")'))
    assert_equal(nil, gp.parse_string('write("My name is Hadi")'))
  end

  def test2()
    gp = GameLanguage.new

    assert_equal(nil, gp.parse_string("write()"))

    # Works in interactive mode
    # assert_equal(nil, gp.parse_string("write('Testing \'write\':')"))

    assert_equal(nil, gp.parse_string("write('Hello World!')"))
    assert_equal(nil, gp.parse_string("write('write()')"))
    assert_equal(nil, gp.parse_string("write('My name is Hadi')"))
  end
   def test3()
    gp = GameLanguage.new

    code = 'a = 12
            b = false
            c = "hi"'

    assert_equal("hi", gp.parse_string(code))
    assert_equal(nil, gp.parse_string("write(a)"))
    assert_equal(nil, gp.parse_string("write(b)"))
    assert_equal(nil, gp.parse_string("write(c)"))
   end
end

class SwitchTest < Test::Unit::TestCase
  def test1()
    gp = GameLanguage.new

    code = 'i = 2
            switch(i)
            case(1)
              {
                write("i is one.")
              }
            case(2)
              {
                write("i is 2.")
              }
            write("Hello")'

    assert_equal(nil, gp.parse_string(code))
  end

  def test2()
    gp = GameLanguage.new

    code = 'i = 2
            k = 0
            switch(i)
            case(1)
              {
                write("i is one.")
                k = 1
                str2 = "Test string"
              }
            case(2)
              {
                write("i is 2.")
                k = 2
                m = 100
              }'

     assert_equal(100, gp.parse_string(code))
     assert_equal(2, gp.parse_string("k"))
     assert_equal(100, gp.parse_string("m"))
  end
end


class IfTest < Test::Unit::TestCase
  def test1()
    gp = GameLanguage.new

    code = "x = 1
           if x <10
           {
                'low'
           }
           else
           {
                'high'
           }"

    assert_equal("low", gp.parse_string(code))

    code = "x = 10
           if x <10
           {
                'low'
           }
           else
           {
                'high'
           }"
    assert_equal("high", gp.parse_string(code))
  end
end

class WhileTest < Test::Unit::TestCase
  def test1()
    gp = GameLanguage.new

    code = "i = 0
            while (i < 5)
            {
              i = i + 1
            }"

    assert_equal(nil, gp.parse_string(code))
    assert_equal(5, gp.parse_string("i"))
  end

  def test2()
    gp = GameLanguage.new

    code = "i = 0
            while (2*i < 20)
            {
              i = i + 1
            }"

    assert_equal(nil, gp.parse_string(code))
    assert_equal(10, gp.parse_string("i"))

  end

  def test3()
    gp = GameLanguage.new

    code = "i = 0
            bool = true
            while (bool)
            {
              i = i + 1
              if i > 5
              {
                bool = false
              }
            }"

    assert_equal(nil, gp.parse_string(code))
    assert_equal(false, gp.parse_string("bool"))
    assert_equal(6, gp.parse_string("i"))

  end

  def test3_break()
    gp = GameLanguage.new

    code = "i = 0
            while true
            {
              i = i + 1
              if i > 10
              {
                break
              }
            }"

    assert_equal(nil, gp.parse_string(code))
    assert_equal(11, gp.parse_string("i"))

  end
end

class ForTest < Test::Unit::TestCase
  def test1_literal_list()
    gp = GameLanguage.new()

    code1 = "sum = 0
            for i in [1, 2, 3]
            {
                sum = sum + i
            }
            "

    assert_equal(nil, gp.parse_string(code1))
    assert_equal(6, gp.parse_string("sum"))

    code2 = "for i in [1, 2, 3]
            {
                sum = sum + i
            }
            "
    assert_equal(nil, gp.parse_string(code2))
    assert_equal(12, gp.parse_string("sum"))
  end

  def test2_list()
    gp = GameLanguage.new()

    code1 = "l = [1, 2, 3]
            sum = 0
            for i in l
            {
                sum = sum + i
            }
            "

    assert_equal(nil, gp.parse_string(code1))
    assert_equal(6, gp.parse_string("sum"))

    code2 = "for i in l
            {
                sum = sum + i
            }
            "
    assert_equal(nil, gp.parse_string(code2))
    assert_equal(12, gp.parse_string("sum"))
  end

  def test3_literal_range()
    gp = GameLanguage.new()

    code1 = "sum = 0
            for i in (1..5)
            {
                sum = sum + i
            }
            "

    assert_equal(nil, gp.parse_string(code1))
    assert_equal(15, gp.parse_string("sum"))

    code2 = "for i in (1..5)
            {
                sum = sum + i
            }
            "
    assert_equal(nil, gp.parse_string(code2))
    assert_equal(30, gp.parse_string("sum"))

    code3 = "sum = 0
            for i in (1...5)
            {
                sum = sum + i
            }
            "
    assert_equal(nil, gp.parse_string(code3))
    assert_equal(10, gp.parse_string("sum"))
  end
  def test4_range()
    gp = GameLanguage.new()

    code1 = "r = (1..5)
            sum = 0
            for i in r
            {
                sum = sum + i
            }
            "

    assert_equal(nil, gp.parse_string(code1))
    assert_equal(15, gp.parse_string("sum"))

    code2 = "for i in r
            {
                sum = sum + i
            }
            "
    assert_equal(nil, gp.parse_string(code2))
    assert_equal(30, gp.parse_string("sum"))
  end

  def test5_range_descending()
    gp = GameLanguage.new()

    code1 = 'write("Printing numbers in range(5..0)")
            r = (5..0)
            for i in r
            {
                write(i)
            }
            '

    assert_equal(nil, gp.parse_string(code1))

    code1 = 'write("Printing numbers in range(-2..2)")
            r = (-2..2)
            for i in r
            {
                write(i)
            }
            '

    assert_equal(nil, gp.parse_string(code1))

    code1 = 'write("Printing numbers in range(-4..-1)")
            r = (-4..-1)
            for i in r
            {
                write(i)
            }
            '

    assert_equal(nil, gp.parse_string(code1))

    code1 = 'write("Printing numbers in range(4...0)")
            r = (4...0)
            for i in r
            {
                write(i)
            }
            '

    assert_equal(nil, gp.parse_string(code1))
  end

  def test6_nested()
    gp = GameLanguage.new()

    code1 = "result = 0
            for x in [1, 2, 3]
            {
                 for y in [1, 2, 3]
                 {
                      result = result + (x * y)
                 }
            }
            "
    assert_equal(nil, gp.parse_string(code1))
    assert_equal(36, gp.parse_string("result"))
  end

  def test7_break()
    gp = GameLanguage.new()

    code1 = "result = 0
            for x in [1, 2, 3]
            {
                 if x == 2
                 {
                        result = x
                        break
                 }
            }
            "
    assert_equal(nil, gp.parse_string(code1))
    assert_equal(2, gp.parse_string("result"))
  end


end

# ============================================================
# Template
# ============================================================
# class "..." < Test::Unit::TestCase
#   def "..."
#     gp = GameLanguage.new
#
#     assert_equal(, gp.parse_string())
#     assert_equal(, gp.parse_string())
#     assert_equal(, gp.parse_string())
#   end
# end
