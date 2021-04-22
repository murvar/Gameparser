# coding: utf-8
type Character
{
  init(att, agi, hp)
  {
    attack = att
    agility = agi
    health = hp


    #slots = {"sword" = RustySword, "helmet" = nil, "chest" = nil}
  }
}

kratos = Character.new(8, 5, 20)
bossman = Character.new(3, 2, 13)
minion = Character.new(1, 1, 4)


# ============================================================
# Aggregering problem!
# Hur ska en karaktär i spelet äga ett svärd?
# ============================================================
# type Sword
# {
#   init(attack, agility)
#   {
#     @attack = attack
#     @agility = agility
#   }
# }

# rusty_sword = Sword.new(8, 1)

event Forest
{
  init
  {
    chest_opened = False
    boss_defeated = False
  }
  run
  {
    write("You enter a dark forest. The wind is howling.")
    write("1. Walk to the right.")
    write("2. Walk forward.")
    write_if(not boss_defeated)("3. Initiate battle with Bossman.")
    write_if(not chest_opended)("4. Open the chest.")

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
          run(Desert)
        }
      when 2
        {
          write("You won!")
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
          continue
        }
  }
}

# new version
event Battle
{
  init
  {
    bossman = Character.new(3, 2, 13)
    minions = []
    for i in (0, 5) # create 5 minions
      {
        minions.append(Character.new(1, 1, 4))
      }
  }
 run
 {
   write("The Bossman shouts at you: DIE!")
   write ("1. Attack.")

   choice = read()

   case choice
   when 1
     {
       while True
         {
           bossman.health -= kratos.attack
           for i in minions

         }
     }
 }

# old version
event Battle
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

         else if boss_hp < 0
           Forest1
         else
           stay
         }
      }
   }
}

#----- Huvudprogram -----

$kratos = Character.new(8, 5, 20)

run(Forest1)
