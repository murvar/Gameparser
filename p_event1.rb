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
load(room)
