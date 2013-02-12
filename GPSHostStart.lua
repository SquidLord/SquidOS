-- GPS Host Startup v0.0.1
-- Written by Alexander "SquidLord" Williams (SamaelVrai)

-- Coords is a Table containing the X, Y, Z coordinates of the host computer
-- EDIT this for new host instances!

local Coords = {}

Coords.x = 0
Coords.y = 0
Coords.z = 0

-- Get local computer label for ID; if it's nil, then we don't have one

SysLabel = os.getComputerLabel()

-- All systems must self-identify on boot

term.clear()
textutils.slowPrint("SquidOS GPS Host Server Igniting...")

if SysLabel then
   print("    Server site: " .. os.getComputerLabel())
else
   textutils.slowPrint("    Server site: UNIDENTIFIED")
end

term.scroll(2)

-- Fork GPS host process with appropriate arguments

shell.run("gps", "host "..
	  Coords["x"].." "..
	  Coords["y"].." "..
	  Coords["z"] )