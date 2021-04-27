# coding: utf-8
require './gameparser'
require 'test/unit'

class EventTest < Test::Unit::TestCase
  def test1()
    gp = GameLanguage.new()

    code = 'write("Expecting 2")
            event Test { init { i = 2 } run { write(i) } }
            load(Test)'

    assert_equal(true, gp.parse_string(code))
  end

  def test2()
    gp = GameLanguage.new()

    code1 = 'write("Expecting 2")
            event Test
            {
              init
               {
                  i = 2
               }
             run
              {
                 write(i)
                 i = 5

              }
             }
            load(Test)'
    assert_equal(true, gp.parse_string(code1))


    code2 = 'write("Expecting 5")
             load(Test)'

    assert_equal(true, gp.parse_string(code2))
  end

  def test3()
    gp = GameLanguage.new()

    code1 = 'write("Expecting 5")
            event Test
            {
              init
               {
                  i = 0
                  for k in (1..5)
                    {
                      i = i + 1
                    }
               }
             run
              {
                 write(i)
                 i = 33

              }
             }
            load(Test)'
    assert_equal(true, gp.parse_string(code1))


    code2 = 'write("Expecting 33")
             load(Test)'

    assert_equal(true, gp.parse_string(code2))
  end
end

class EventTraverse < Test::Unit::TestCase
  def test1()
    gp = GameLanguage.new()
    
    code = 'event room
           {
            init
            {            
   	   
            }
            run
            {
   	      write("You are in an empty room")
   	      write("1. Go to the yard")
   	
              choice = read()
   	      switch (choice)
   	        case(1)
   	        {
   	          load(yard)
   	        }
   	
            }
           }

           event yard
           {        
             init
             {
   	      
             }
             run     
             {
               write("You are in a dark yard")
   	       write("1. Go back to the house")
   	
               choice = read()
   	       switch (choice)
   	         case(1)
   	         {
   	           load(room)
   	         }
   	
             }
           }'

    assert_equal(nil, gp.parse_string(code))    
  end
end


class PropTest < Test::Unit::TestCase
  def test1()
    gp = GameLanguage.new

    code = 'prop character
            {
              init(hp, n)
              {
                health = hp
                name = n
              }
            }'
    assert_equal(nil, gp.parse_string(code))
    assert_equal(true, gp.parse_string('player = character.new(100, "Hadi") true'))
    assert_equal(true, gp.parse_string('enemy = character.new(30, "Minion") true'))

    assert_equal(100, gp.parse_string('player.health'))
    assert_equal("Hadi", gp.parse_string('player.name'))

    assert_equal(30, gp.parse_string('enemy.health'))
    assert_equal("Minion", gp.parse_string('enemy.name'))

    assert_equal(250, gp.parse_string('player.health = 250'))
    assert_equal(250, gp.parse_string('player.health'))
    assert_equal("Vincent", gp.parse_string('player.name = "Vincent"'))
    assert_equal("Vincent", gp.parse_string('player.name'))

    assert_equal(50, gp.parse_string('enemy.health = 50'))
    assert_equal(50, gp.parse_string('enemy.health'))
    assert_equal("Big Boss", gp.parse_string('enemy.name = "Big Boss"'))
    assert_equal("Big Boss", gp.parse_string('enemy.name'))

    assert_equal(250, gp.parse_string('player.health'))
    assert_equal("Vincent", gp.parse_string('player.name'))
  end
end
