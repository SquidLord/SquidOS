-- Startup file for ComputerCraft turtles to set paths and initialize
-- by Alexander "SquidLord" Williams (SaladinVrai)

-- Initialize any modules or other cruft you want accessible to all drones
--  Default API location for squidLib specific modules is under "squid/"
--  Other modules are assumed to be in root

-- Gist: https://gist.github.com/SquidLord/4746878

-- Load squidLib because, yes, you need it.
os.loadAPI("squidOS/lib/squidlib")

-- Pathfinding is too important not to manage; load "egps" every boot
os.loadAPI("squidOS/lib/egps")

-- Go ahead and initalize a modem, because why wouldn't you?
squidlib.initModem()

-- Identify
term.clear()
print("SquidOS Drone Startup ...")
print("  Node:"..squidlib.labelString())

-- Broadcast online status

squidlib.redCast("Online")
