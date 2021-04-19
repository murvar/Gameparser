require './gameparser'

gp = GameLanguage.new()

code1 = 'number = read("Please enter a number:")
         msg = "Your entered " + number
         write(msg)'

code2 = 'name = read("Please enter your name:")
         greeting = "Hello " + name + "!"
         write(greeting)'

code3 = 'bool = read("Please enter a boolean value (true/false)")
         msg = "Your Entered: " + bool
         write(msg)'

gp.parse_string(code1)
gp.parse_string("write()") # empty line to look like better
gp.parse_string(code2)
gp.parse_string("write()") # empty line to look like better
gp.parse_string(code3)
