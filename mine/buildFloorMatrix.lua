-- buildFloorMatrix build a floor over open spaces
-- by Alexander "SquidLord" Williams (Saladin Vrai)

-- "buildFloorMatrix [r|r]"
--    Place drone over near edge of opening. [R|L] defines which way 
--      the drone shouldturn at the end of the opening.

-- Gist: https://gist.github.com/SquidLord/4748385

-- Requires squidlib (https://gist.github.com/SquidLord/4746742)
os.loadAPI("squid/lib/squidlib")

-- Requires EGPS (A* pathfinding): https://gist.github.com/SquidLord/4741746
os.loadAPI("squid/lib/egps")

-- usage()
--    Print usage text
function usage()
   print("buildFloorMatrix [r|l]")
   print("  r|l says which way to turn at the end of the first row.")
end

-- process Step(Turn, JustTurned)
--    Do for every block passed over; Turn is the direction to turn on
--      not finding a hole; JustTurned is whether you've just not found a block
--    Not finding a block twice is the trigger to return to start
function step(Turn, JustTurned, Slt)
   if turtle.getFuelLevel() < 300 then  -- Are we out of fuel?
      print("  Insufficient fuel; RTB; please fuel")
      return false
   end
   if turtle.detectDown() then -- Is there a block below?
      if JustTurned then -- Have we just turned at the end of row?
	 print("  End of area; RTB")
	 squidlib.redCast("Completed flooring area.")
	 return true
      else
	 print("  End of row; turning "..Turn)
	 if Turn == "r" then
	    egps.back()
	    egps.turnRight()
	    egps.forward()
	    return step("r", true, Slt)
	 else
	    egps.back()
	    egps.turnLeft()
	    egps.forward()
	    return step("l", true, Slt)
	 end -- Turn check
      end -- JustTurned
   else -- There is not a block below
      if (turtle.getItemCount(Slt) == 0) then -- Are we out of flooring in the current inv slot?
	 print("  Out of flooring in slot "..Slt)
	 if (Slt == 16) then -- Is this the last slot?
	    print("  Empty of flooring; RTB")
	    return false
	 else
	    turtle.select(Slt+1)
	    return step(Turn, false, Slt+1) -- Re-enter with new slot
	 end
      else
	 turtle.placeDown()
	 egps.forward()
	 return step(Turn, false, Slt) -- Continue ahead with the same Turn
      end
   end
end

-- Load vars/args
local ARGS = {...}

-- Identify
term.clear()
print("SquidOS buildFloorMatrix Startup ...")
print("  Node:"..squidlib.labelString())

-- If no arguments, print usage and fail out
if (#ARGS == 0) then
   usage()
   return false
end

-- Find out the start position
STARTPOSX, STARTPOSY, STARTPOSZ, STARTPOSFACE = egps.setLocationFromGPS()

if not ((ARGS[1] == "r") or (ARGS[1] == "l")) then
   usage()
   return false
end

turtle.select(1)
egps.forward()
local RETVAL = step(ARGS[1], false, 1)
egps.moveTo(STARTPOSX, STARTPOSY, STARTPOSZ, STARTPOSFACE)
print("  Done")
squidlib.redCast("Done with floor laying")
return RETVAL