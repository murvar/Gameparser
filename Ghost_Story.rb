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

def prompt(msg, msg_len, iterations)
{
  condition = true
  while iterations > 0
    {
      if condition
        {
          cls()
          write("=" * 90)
          write(" " * ((90 - msg_len) / 2) + msg)
          write("=" * 90)
          condition = false
          wait(1)
        }
      else
        {
          cls()
          write("=" * 90)
          write()
          write("=" * 90)
          condition = true
          wait(1)
        }

        iterations = iterations - 1
    }
}

def initiate_player(name)
{
  p = Character.new(name, 5, 2, 25)
  write("Hello \"" + p.name + "\". Try to survive in this world!")
  write()
  p
}

def print_stats(attack, defence, health)
{
  write("Your stats:")
  write("* Attack  : " + str(attack))
  write("* Defence : " + str(defence))
  write("* health  : " + str(health))
  write()
}    
  
def header(heading)
{
  write("*"*90)
  write(" "*40 + heading)
  write("*"*90)
}

event room
  {

    init {
     
    }

  run
  {
    print_stats($player.attack, $player.defence, $player.health)
    header("Dark room")
    write("You are in a dark room.\n\n")
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
    print_stats($player.attack, $player.defence, $player.health)
    header("Yard")
    write("You are in a dark yard. Behind a dead tree you can see a ghost peeking out.\n\n")
    write("1. Go back to the house")
    write("2. Wave to the ghost")

    choice = read()
    
    switch(choice)
    case (1)
    {
      cls()
      load(room)
    }
    case (2)
    {
      write("The ghost waves for you to come closer.\n\n")
      write("1. Go towards it")
      write("2. Run back into the house")

      choice = read()
      
      switch(choice)
      case (1)
      {
        battle(ghost)
      }
      case (2)
      {
        cls()
        load(room)
      }
    }

  }

}

def battle (enemy)
{
  cls()
  header("Battle with the ghost!!!")
  write("You enter a battle with a " + enemy.name + ".\n\n")
      
  while true
  {
    write("1. Attack the " + enemy.name)
    write("2. Run away")

    choice = read()
    cls()
    header("Battle with the ghost!!!")
    
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
        if $player.health < 0
          {
            prompt("You have been slain", 19, 7)
            break
          }
        write("You have " + str($player.health) + " hp left.")
        write()
      }
      else
      {
        cls()
        prompt("Excellent! You defeated the ghost and won the game...", 53, 7)
        break
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
prompt("Welcome to the \"Ghost Story\"", 26, 5)    
name = read("Please enter your name:")
cls()
$player = initiate_player(name)
load(room)
