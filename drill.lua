--drill: ComputerCraft turtle program to drill down or forward 
--    through materials until you hit open area, then return to start.
--    Arguments are "f" for drill forward, or "d" for drill down.

-- by Alexander "SquidLord" Williams (SaladinVrai)

-- Gist: https://gist.github.com/SquidLord/4757383

-- Requires squidlib and egps
os.loadAPI("squid/squidlib")
os.loadAPI("squid/egps")

ARGS = {...}

function usage()
   squidlib.printTable({
			  "SquidOS Drill Program ...",
			  "",
			  "  Drill down or forward through materials until you hit open area, then return to Start.",
			  "",
			  "  Arguments:",
			  "    f - Drill forward",
			  "    d - Drill down"})
   return nil
end

function main()
   if not ARGS[1] then 
      return usage()
   elseif not ((ARGS[1] == "f") or (ARGS[1] == "d")) then
      return usage()
   else -- Everything is groovy
      Loc = {} -- Put starting location in scope
      MoveFunc = false -- Put direction of motion in scope
      DrillFunc = false -- Put direction to drill in scope
      ScanFunc = false -- Put direction to look in scope
      Loc.x, Loc.y, Loc.z, Loc.f = egps.setLocationFromGPS() -- Save the current location to return to
      
      -- Identify
      squidlib.printTable({
			     "SquidOS Drill Program ...",
			     ""})
      
      if (ARGS[1] == "f") then
	 MoveFunc = egps.forward
	 DrillFunc = turtle.dig
	 ScanFunc = turtle.detect
	 print("  Drilling forward")
      else
	 MoveFunc = egps.down
	 DrillFunc = turtle.digDown
	 ScanFunc = turtle.detectDown
	 print("  Drilling down")
      end
      
      while ScanFunc() do
	 if not DrillFunc() then -- If you're at the bottom of the world or otherwise can't drill
	    print("  Cannot drill further")
	    break
	 elseif not MoveFunc() then -- If you can't move even after drilling
	    print("  Cannot move into drilled space")
	    break
	 end
      end
      
      print("  Nothing more to drill; RTB")
      
      egps.moveTo(Loc.x, Loc.y, Loc.z, Loc.f) -- Returning to start
      
      print("Done")
   end
end


---
--- Main
--- 

main()
