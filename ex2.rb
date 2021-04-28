read("hello")
prop Character
{
  init(n, att, d, hp)
  {
    name = n
    attack = att
    defence = d
    health = hp
  }
}

event room
  {

    init {
      write("Hello " + $player.name + ". Try to survive in this world!")
      write("Your stats")
      write("=" * 30)
      write("Attack : " + str($player.attack))
      write("Defence : " + str($player.defence))
      write("health : " + str($player.health))
      write()
    }

  run
  {
    write("You are in an empty room.")
    choice = read("1. Go to the yard")
    cls()

    switch(choice)
    case (1)
    {
      load(yard)
    }

  }

}

event yard
{
  init
  {
    ghost = Character.new("Ghost", 3, 1, 15)
  }

  run
  {
    write("You are in a dark yard. Behind a dead tree you can see a ghost peeking out.")
    write("1. Go back to the house")
    write("2. Wave to the ghost")

    choice = read()
    cls()

    switch(choice)
    case (1)
    {
      load(room)
    }
    case (2)
    {
      #wait(3)
      write("The ghost waves for you to come closer")
      #wait(2)
      write("1. Go towards it")
      write("2. Run back into the house")

      choice = read()
      cls()

      switch(choice)
      case (1)
      {
        battle(ghost)
      }
      case (2)
      {
        load(room)
      }
    }

  }

}

def battle (enemy) {
  write("You enter a battle with a " + enemy.name)
  #wait(2)
  while $player.health and enemy.health > 0
  {
    write("1. Attack the " + enemy.name)
    write("2. Run away")
    choice = read()
    cls()

    switch(choice)
    case (1)
    {
      write("You deal " + str($player.attack - enemy.defence) + " damage to the " + enemy.name + ".")
      enemy.health = enemy.health - ($player.attack - enemy.defence)
      if enemy.health > 0
      {
        write(enemy.name + " has " + str(enemy.health) + " hp left.")
        write(enemy.name + " attacks back dealing " + str(enemy.attack - $player.defence) + " damage to you.")
        $player.health = $player.health - (enemy.attack - $player.defence)
        write("You have " + str($player.health) + " hp left.")
      }
      else
      {
        cls()
        write("Excellent! You defeated the ghost and won the game...")
      }

    }
    case (2)
    {
     load(yard)
    }
  }
}

# ==================================================
# Huvudprogram
# ==================================================

$player = Character.new("Vincent", 5, 2, 25)
load(room)
