write("Hello")

prop Player
{
  init(a, d, h)
  {
    attack = a
    defence = d
    health = h
    slots = {"sword" = nil, "helmet" = nil, "chest" = nil}
  }

}


prop Character
{
  init(att, d, hp)
  {
    attack = att
    defence = d
    health = hp
  }
}

bossman = Character.new(3, 2, 13)
minion = Character.new(1, 1, 4)

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
    if (not boss_defeated) write("3. Initiate battle with Bossman.")
    if (not chest_opended) write("4. Open the chest.")

    counter = 0
    for option in option_list
      {
        write(counter + " " + option)
        counter += 1
      }

      choice = read()

      switch choice
      case 1
        {
          load(Desert)
        }
      case 2
        {
          write("You won!")
        }
      case 3
        {
          load(Battle1)
        }
      case 4
        {
          write("You got a rusty sword which gives you +5 attack!")
          player.slots[sword] += 5
          chest_opened = True
          continue
        }
  }
}
