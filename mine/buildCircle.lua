-- v. 1.0 : Not the most efficient way of doing a circle--I just do a square 
-- grid, and if the turtle is outside the radius, it just skips laying a block.
-- I hope in later versions, I'll manage to make a spiral pattern so we don't have to go over empty blocks.
-- v. 1.1 : It will start now know the correct center of the circle...it's moving too far back

local tArgs = {...}
local radius = tonumber(tArgs[1])
local slot = 1
local turnflag = true

turtle.select(slot)

for i = 1,radius do
   turtle.back()
end

turtle.turnRight()
for i = 1,radius do
   turtle.back()
end
turtle.turnLeft()

for i = -radius, radius do
   for j = -radius, radius do
      
      if turtle.getItemCount(slot) == 0 then
	 slot = slot + 1
	 if slot == 17 then 
	    slot = 1 -- Let's hope something will be there.
	    if turtle.getItemCount(slot) == 0 then
	       return
	    end
	 end
	 turtle.select(slot)
      end

      if math.sqrt(i*i + j*j) <= radius then
	 turtle.placeDown()
      end
      
      turtle.forward()
      
   end
   
   if turnflag == true then
      turtle.turnRight()
      turtle.forward()
      turtle.turnRight()
      turtle.forward()
      turnflag = false
   else
      turtle.turnLeft()
      turtle.forward()
      turtle.turnLeft()
      turtle.forward()

      turnflag = true
   end
   
end

-- now to return to the center of the platform
for i=1,radius do
   turtle.forward()
end

turtle.turnLeft()

for i=0,radius do
   turtle.back()
end
