-- v. 1.0 : Based off of v. 1.1 of Circle Platform.  Again, a bit messy, dealing
-- with going over the entire area of r^3 cube (and plus the distance for it to 
-- get back to the center), but this should do the trick.

local tArgs = {...}
local radius = tonumber(tArgs[1])
local slot = 1
local turnflag = true

turtle.select(slot)

for k = -radius,radius do
    
    turnflag = true
    
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
    
        if math.sqrt(i*i + j*j + k*k) <= radius then
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

    turtle.up()
end