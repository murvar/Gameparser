type Kratos()
{
    attack = -8
    agility = 5
    health = 20
    inventory = []
    weapon = {"name": Sword}
    slots = {"sword" = RustySword, "helmet" = nil, "chest" = nil}
}

type Sword
  {
    attack = 8
    agi = 1


  }

object.new(2,3,4)

class object
  blablab


object.new("boss", stats{:name = 2, :agi = 15, :hp = 100})

for i in range(1, 10)
object Boss(n)
{
    name = n
    agility = 2
    attack = 15
    health = 100
}

event Battle1(num_of_bosses) {
  enemies = []
  run
  {
    for i in range(num_of_bosses)
    {
      enemies.add Boss.new("Boss " + i)
    }

    while len(enemies) > 0 {
      for enemy in enemies {
        Kratos.health -= enemy.attack
      }
    }

  }
}


class object
  {

  }

object RustySword
{
  agility = 5
  geartype = "sword"
}

RustySword.new()
RustySword = object.new()

event Forest1()
{
  chest_opened = False
  chest_locked = True
  option_list = ["Walk to the right.", "Walk forward.", "Initiate battle with Bossman.", " Open the chest."]
 run
 {
   write("You enter a dark forest. The wind is howling.")


     # write("1. Walk to the right.")
     # write("2. Walk forward.")
     # write("3. Initiate battle with Bossman.")
     # write("4. Open the chest.")
     counter = 0
     for option in option_list
       {
         write(counter + " " + option)
         counter += 1
       }

     choice = read()

     case choice
     when 1
      {
       run(Forest2)
      }
     when 2
     {
       write("You won!")
       return False
      }
     when 3
      {
        run(Battle1)
      }
     when 4
       {
       write("You got rusty sword which gives you +5 agility!")
       Kratos.agility += 5
       chest_opened = True
       stay
       }
}

event Battle1
{
   #Boss.new("Bossman")
   $minion_damage = 10
   boss_hp = 10
   boss_damage = 5
 run
 {
   write("The Bossman shouts at you: DIE!")
   while boss_hp > 0
     {
       write ("1. Attack.")

       choice = read()

       case choice
       when 1
        {
         boss_hp -= Kratos.damage
         Kratos.hp -= boss_damage
         if Kratos.hp < 0
           write("You have been slain...")
           False
         else if boss_hp < 0
           Forest1
         else
           stay
         }
      }
   }
}
#----- Huvudprogram -----

#current_event = Forest1

run(Forest1)

# while True do
#  {
#    current_event = current_event.run()
#    if not current_event
#      exit
#  }
