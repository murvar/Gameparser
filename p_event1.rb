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
  init {}
  run {
    write("you are in a dark yard. Behind a dead tree you can see a ghost peeking out.")
    write("1. Go back to the house")
    choice = read("2. Wave to the ghost")
    switch(choice)
    case (1) {
      load(room)
    }

  }

}

# def battle (player, enemy) {
#   write("You enter a battle with a " + enemy.name)
#   wait(2)
#   while player.health and enemy.health > 0 {
#     write("1. Attack " + enemy.name)
#     choice = read("2. Run away")
#     switch(choice)
#     case (1) {
#       write("You deal " + (player.attack - enemy.defence) + "damage to " + enemy.name)
#       enemy.health = enemy.health - (player.attack - enemy.defence)
#       if enemy.health > 0 {
#         write(enemy.name + " attacks back dealing " + (enemy.attack - player.defence) + " damage to you")
#         player.health = player.health - (enemy.attack - player.defence)
#       }
#     }
#     case (2)  {
#       load(yard)
#     }
#   }
# }


load(room)
