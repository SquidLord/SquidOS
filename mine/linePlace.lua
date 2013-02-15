-- linePlace: ComputerCraft turtle program to place items in inventory down or forward 
--    until you can proceed no further, then return to start.
--    Arguments are "f" for place forward, or "d" for place down

-- by Alexander "SquidLord" Williams (SaladinVrai)

-- Gist: https://gist.github.com/SquidLord/4758568

-- Requires squidlib and egps
os.loadAPI("squid/lib/squidlib")
os.loadAPI("squid/lib/egps")

ARGS = {...}

function usage()
   squidlib.printTable({
			  "SquidOS LinePlace Program ...",
			  "",
			  "  Place items in inventory down or forward until you can proceed no further,",
			  "  then return to start..",
			  "",
			  "  Arguments:",
			  "    f - Place forward",
			  "    d - Place down"})
   return nil
end

-- placeItem(Slot, PlaceFunc) => Int/Bool
--    Takes the current inv slot and the function to place in the right direction
--    Returns false if out of inventory in all slots or an Int for the slot with materials in it
function placeItem(Slot, PlaceFunc)
   if (Slot == 17) then
      print("  Out of inventory")
      return false
   elseif (turtle.getItemCount(Slot) == 0) then -- There are slots left and we're out in this slot
      return placeItem(Slot+1, PlaceFunc) -- Call yourself with the next slot selected
   elseif not PlaceFunc() then -- there are items left in inv to place so if you STILL can't place the item
      print("  Cannot place item")
      return false -- Cannot continue; fail out 
   else
      return Slot -- Return the slot number
   end
end

-- scanPlaceMoveR(Func, Func, Func) => Bool
--    Take the Scan, Place, and Move functions and recourse until something throws false
--    Technically, this should always return false ... eventually
function scanMovePlaceR(ScanFunc, MoveFunc, PlaceFunc)
   if ScanFunc() then -- If there's something in the way
      print("  Way obstructed")
      return false
   elseif not MoveFunc() then -- If you can't move
      print("  Cannot move onwards")
      return false
   elseif not PlaceFunc() then -- If you can't place the item it's already emitted an error
      return false  
   else
      scanMovePlaceR(ScanFunc, MoveFunc, PlaceFunc)
   end
end

---
-- MAIN
---

function main()
   if not ARGS[1] then 
      return usage()
   elseif not ((ARGS[1] == "f") or (ARGS[1] == "d")) then
      return usage()
   else -- Everything is groovy
      Slot = 1 -- The current inv slot to start from
      
      Loc = {} -- Put starting location in scope
      MoveFunc = false -- Put direction of motion in scope
      PlaceFunc = false -- Put direction to drill in scope
      ScanFunc = false -- Put direction to look in scope
      Loc.x, Loc.y, Loc.z, Loc.f = egps.setLocationFromGPS() -- Save the current location to return to
      
      -- Identify
      squidlib.printTable({
			     "SquidOS linePlace Program ...",
			     ""})
      
      if (ARGS[1] == "f") then -- Placing forward?
	 egps.forward()
	 MoveFunc = function()
	    return egps.forward()
	 end
	 
	 PlaceFunc = 
	    function() -- Must turn around to place things behind us
	        egps.turnLeft()
		egps.turnLeft()
		Slot = turtlelib.placeItem(Slot, turtle.place)
		if not Slot then -- If you can't put it down, something is wrong
		   return false
		end
		egps.turnLeft() -- And turn back to the front
		egps.turnLeft()
		return true
	    end
	    
	    ScanFunc = turtle.detect
	    print("  Placing forward")
      else -- Place down
	 egps.down()
	 MoveFunc = egps.down
	 
	 PlaceFunc = 
	    function()
	        Slot = turtlelib.placeItem(Slot, turtle.placeUp)
		if not Slot then -- If you can't put it down, something is wrong
		   return false
		else
		   return true
		end
	    end
	    
	    ScanFunc = turtle.detectDown
	    print("  Placing down")
      end
      
      scanMovePlaceR(ScanFunc, MoveFunc, PlaceFunc)
      
      print("  Nothing more to place; RTB")
      
      egps.moveTo(Loc.x, Loc.y, Loc.z, Loc.f) -- Returning to start
      
      print("Done")
   end
end


---
--- Main
--- 

main()
