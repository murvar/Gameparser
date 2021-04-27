<<<<<<< HEAD
def battle (player, enemy) {
  # write("You enter a battle with a " + enemy.name)
  # wait(2)
  # while player.health and enemy.health > 0 {
  #   write("1. Attack " + enemy.name)
  #   choice = read("2. Run away")
  #   switch(choice)
  #   case (1) {
  #     write("You deal " + (player.attack - enemy.defence) + "damage to " + enemy.name)
  #     enemy.health = enemy.health - (player.attack - enemy.defence)
  #     if enemy.health > 0 {
  #       write(enemy.name + " attacks back dealing " + (enemy.attack - player.defence) + " damage to you")
  #       player.health = player.health - (enemy.attack - player.defence)
  #     }
  #   }
  #   case (2)  {
  #     load(yard)
  #   }
  # }
=======
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

# bossman = Character.new("Bossman",3, 2, 13)
# ghost = Character.new("Ghost",3, 2, 13)
# minion = Character.new("Minion",1, 1, 4)
$player = Character.new("Vincent", 2, 2, 4)

def battle (player, enemy) {
  write("You enter a battle with a " + enemy.name)
  #wait(2)
  while player.health and enemy.health > 0 {
    write("1. Attack " + enemy.name)
    choice = read("2. Run away")
    switch(choice)
    case (1) {
      write("You deal " + (player.attack - enemy.defence) + "damage to " + enemy.name)
      enemy.health = enemy.health - (player.attack*2 - enemy.defence)
      if enemy.health > 0 {
        write(enemy.name + " attacks back dealing " + (enemy.attack - player.defence) + " damage to you")
        player.health = player.health - (enemy.attack - player.defence)
      }
    }
    case (2)  {
      load(yard)
    }
  }
>>>>>>> 998fe64a5674f2e88e180684f77b47580cfc1468
}

event room {
  init {}
  run{
    write("you are in an empty room")
    choice = read("1. Go to the yard")
    switch(choice)
    case (1) {
      load(yard)
    }

  }

}


event yard {
  init {ghost = Character.new("Ghost",3, 2, 13)}
  run {
    write("you are in a dark yard. Behind a dead tree you can see a ghost peeking out.")
    write("1. Go back to the house")
    choice = read("2. Wave to the ghost")
    switch(choice)
    case (1) {
      load(room)
    }
    case (2) {
<<<<<<< HEAD
      write("The ghost waves for you to come closer")
=======
      #wait(3)
      write("The ghost waves for you to come closer")
      #wait(2)
>>>>>>> 998fe64a5674f2e88e180684f77b47580cfc1468
      write("1. Go towards it")
      choice = read("2. Run back into the house")
      switch(choice)
      case (1)  {
<<<<<<< HEAD
        battle(player, ghost)
=======
        battle($player, ghost)
>>>>>>> 998fe64a5674f2e88e180684f77b47580cfc1468
      }
      case (2) {
        load(room)
      }
    }

  }

}
load(room)
