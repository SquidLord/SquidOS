-- t: ComputerCraft turtle command line nav tool. Takes a single string and parses it as directions
-- by Alexander "SquidLord" Williams (SaladinVrai)

-- Gist: https://gist.github.com/SquidLord/4757117

-- Load libraries
os.loadAPI("squid/squidlib")
os.loadAPI("squid/turtlelib")

ARGS = {...}

function main()
   if not ARGS[1] then
      usage()
      return nil
   else
      MT = turtlelib.makeMoveTable(turtle) -- Initialize the parser from the base turtle motions
      Moves = turtlelib.stringToMoves(ARGS[1], MT) -- Build the move list
      print("Moving turtle: "..ARGS[1])
      turtlelib.executeMoves(Moves) -- Make stuff happen
   end
end

function usage()
   UsageText = { "SquidOS Turtle Movement Program ...",
		 "  Takes a string of letters as directives on how to move the drone.",
		 "",
		 "  Acceptable letters are:",
		 "    f - Forward",
		 "    b - Back",
		 "    u - Up",
		 "    d - Down",
		 "    l - Turn left",
		 "    r - Turn right",
		 "    L - Move Left 1m but keep facing",
		 "    R - Move Right 1m but keep facing"}
   squidlib.printTable(UsageText)
end

---
--- Main
---

main()
