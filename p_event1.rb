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
      write("You deal " + str(player.attack - enemy.defence) + "damage to " + enemy.name)
      enemy.health = enemy.health - (player.attack*2 - enemy.defence)
      if enemy.health > 0 {
        write(enemy.name + " attacks back dealing " + str(enemy.attack - player.defence) + " damage to you")
        player.health = player.health - (enemy.attack - player.defence)
      }
    }
    case (2)  {
      load(yard)
    }
  }
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
      #wait(3)
      write("The ghost waves for you to come closer")
      #wait(2)
      write("1. Go towards it")
      choice = read("2. Run back into the house")
      switch(choice)
      case (1)  {
        battle($player, ghost)
      }
      case (2) {
        load(room)
      }
    }

  }

}
load(room)
