# coding: utf-8
require './gameparser'
require 'test/unit'

class FunctionTest < Test::Unit::TestCase
   def test222222()
     gp1 = GameLanguage.new

     code = "def test(i)
            {
             k = i + 12
             k
            }
            test(2)
            "
#     assert_equal(nil, gp1.parse_string(code))
     assert_equal(14, gp1.parse_string(code))
     #assert_equal(14, gp1.parse_string("test(2)"))
     # assert_equal(32, gp1.parse_string("test(20)"))
     # assert_equal(13, gp1.parse_string("test(2 / 2)"))

   end
   #   gp2 = GameLanguage.new
   #   code = "def test1(i)
   #          {
   #           k = i + 12
   #           k
   #          }
   #          def test2(j)
   #          {
   #           p = ( j * 2 ) - 2
   #           p
   #          }
   #          def test3(x)
   #          {
   #           y = ( x * 2 ) - 2
   #           y
   #           x
   #          }
   #          "
   #   assert_equal(nil, gp2.parse_string(code))
   #   assert_equal(14, gp2.parse_string("test1(2)"))
   #   assert_equal(2, gp2.parse_string("test2(2)"))
   #   assert_equal(-4, gp2.parse_string("test2(-1)"))
   #   assert_equal(30, gp2.parse_string("test3(30)"))
   # end
end
