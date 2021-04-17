# coding: utf-8
require './gameparser'
require 'test/unit'

class FunctionBasic < Test::Unit::TestCase
  def test1()
    gp = GameLanguage.new

    code = "def test(i)
            {
             k = i + p
             k
            }
            "

    assert_equal(nil, gp.parse_string(code))
  end

  def test2()
    gp = GameLanguage.new
    
    code = "def test(i)
            {
             k = i + 12
             k
            }
            "

    assert_equal(nil, gp.parse_string(code))
    assert_equal(14, gp.parse_string("test(2)"))
    assert_equal(32, gp.parse_string("test(20)"))
    assert_equal(13, gp.parse_string("test(2 / 2)"))
  end

  def test3()
    gp = GameLanguage.new

    code = "def test1(i)
            {
             k = i + 12
             k
            }
            def test2(j)
            {
             p = ( j * 2 ) - 2
             p
            }
            def test3(x)
            {
             y = ( x * 2 ) - 2
             y
             x
            }
            "
    assert_equal(nil, gp.parse_string(code))
    assert_equal(14, gp.parse_string("test1(2)"))
    assert_equal(2, gp.parse_string("test2(2)"))
    assert_equal(-4, gp.parse_string("test2(-1)"))
    assert_equal(30, gp.parse_string("test3(30)"))
  end

  def test4()
    gp = GameLanguage.new
    
    code = "def test1(i)
            {
             k = i + 12
             k
            }
            def test2(j)
            {
             t = test1(j)
             t = t + 5
             t
            }"
    assert_equal(nil, gp.parse_string(code))
    assert_equal(20, gp.parse_string("test1(8)"))
    assert_equal(25, gp.parse_string("test2(8)"))
    assert_equal(17, gp.parse_string("test2(0)"))

  end

  def test5()
    gp = GameLanguage.new
    
    code = "def test1(i)
            {
             k = i + 12
             k
            }
            def test2(j)
            {
             t = 6 * test1(j)
             t
            }"
    assert_equal(nil, gp.parse_string(code))
    assert_equal(72, gp.parse_string("test2(0)"))
    assert_equal(60, gp.parse_string("test2(-2)"))
    assert_equal(0, gp.parse_string("test2(-12)"))

  end
end

class FunctionRecursion < Test::Unit::TestCase


  def test1()
    gp = GameLanguage.new

    code = "def rec(x)
           {
            counter = 0
            if x == 5
            {
                counter
            }
            else
            {
                counter = counter + 1
                counter + rec (x+1)
            }
           }
           rec(0)"
    assert_equal(5, gp.parse_string(code))
    assert_equal(0, gp.parse_string("rec(5)"))
  end
  
  def test2()
    gp = GameLanguage.new

    code = "def fibonacci(n)
           {      
            if (n == 1) or (n == 2)
            {
                1
            }
            else
            {
                fibonacci(n-1) + fibonacci(n-2)
            }
           }
           "
    assert_equal(nil, gp.parse_string(code))
    assert_equal(1, gp.parse_string("fibonacci(1)"))
    assert_equal(1, gp.parse_string("fibonacci(2)"))
    assert_equal(2, gp.parse_string("fibonacci(3)"))
    assert_equal(3, gp.parse_string("fibonacci(4)"))
    assert_equal(5, gp.parse_string("fibonacci(5)"))
    assert_equal(55, gp.parse_string("fibonacci(10)"))
  end

  def test3()
    gp = GameLanguage.new
    
    code = "def rec(x)
           {
            if x > 10
           {
                x
           }
           else 
           {
               rec (x+3)
           }
           }
           rec(0)"
    assert_equal(12, gp.parse_string(code))
    assert_equal(12, gp.parse_string("rec(0)"))
    assert_equal(13, gp.parse_string("rec(10)"))
  end
end

class FunctionMultiArg < Test::Unit::TestCase
  
  def test1()
    gp = GameLanguage.new
    
    code = "def add(x, y)
           {      
            sum = x + y
            sum
           }
           add(10, 30)"
    assert_equal(40, gp.parse_string(code))
    assert_equal(0, gp.parse_string("add(-10, 10)"))
  end

  def test2()
    gp = GameLanguage.new

    code = "def min(x, y, z)
           {      
            min = x
            if min > y
            {
                min = y
            }
            if min > z
            {
                min = z
            }
            min
           }"
    assert_equal(nil, gp.parse_string(code))
    assert_equal(1, gp.parse_string("min(1, 2, 3)"))
    assert_equal(1, gp.parse_string("min(3, 2, 1)"))
    assert_equal(1, gp.parse_string("min(2, 1, 3)"))
    assert_equal(1, gp.parse_string("min(2, 3, 1)"))

    assert_equal(-3, gp.parse_string("min(-1, -2, -3)"))
    assert_equal(-3, gp.parse_string("min(-1, -3, -3)"))
    assert_equal(-100, gp.parse_string("min(-1, -2, -100)"))
  end


end
