-- Build a column of the material in inv 1 , starting where the bot is sitting,
--    until out of material, a ceiling is reached, or a specified height
-- by Alexander "SquidLord" Williams (SaladinVrai)

-- Gist: https://gist.github.com/SquidLord/4741925

-- Set up environ
local ARGS = {...}
local SLOT = 1
local COLHEIGHT = tonumber(ARGS[1])
local MAXBLOX = turtle.getItemCount(SLOT)

-- Get the system label for identification
local SYSNAME = os.getComputerLabel()
if not SYSNAME then SYSNAME = "UNNAMED NODE" end

-- Open rednet for status spurts
--   Iterate over all sides for rednet.open
for N,M in ipairs(rs.getSides()) do
   rednet.open(M)
end

--
-- Function Definition
--

-- PlaceCol(Int)
--   Recursively try placing a block, then moving up. Failures return a (discarded) 1.

local function PlaceCol(ColHeight)
   if ColHeight == 0 then
      print("  Reached max height.")
      rednet.broadcast(":"..SYSNAME..": reached given column height; returning to start")
      return false
   elseif not turtle.place() then
      print("  Could not place block; ending column.")
      rednet.broadcast(":"..SYSNAME..": could not place block; returning to start")
      return false
   elseif not turtle.up() then
      print("  Hit ceiling or block; returning down.")
      rednet.broadcast(":"..SYSNAME..": hit ceiling or block; returning to start")
      return false
   else PlaceCol(ColHeight - 1)
      turtle.down()
      return true
   end
end

--
-- Main Loop Identify
--

print("SquidOS Column Builder ...")
print("  Running on: "..SYSNAME)

-- If there are no blocks in SLOT, complain loudly
if MAXBLOX == 0 then
   print("  No blocks to build column with.")
   rednet.broadcast(":"..SYSNAME..": No blocks to build with.")
   return false
end

-- If there aren't enough blocks in the inventory to build that column, 
--   only plan to build as much as you have.
if not COLHEIGHT then COLHEIGHT = 64 end

if MAXBLOX < COLHEIGHT then COLHEIGHT = MAXBLOX end

print("  Building to "..COLHEIGHT)
rednet.broadcast(":"..SYSNAME..": building column to "..COLHEIGHT)

if not turtle.back() then
   print("  Cannot back up. Clear the position and try again.")
   rednet.broadcast(":"..SYSNAME..": failed to back up.")
   return false
end

-- Target the colmn material block for placement
turtle.select(SLOT)

-- Recursively place blocks
if not PlaceCol(COLHEIGHT) then
   turtle.forward()
end

print("  Build complete.")
rednet.broadcast(":"..SYSNAME..": Finished building "..COLHEIGHT.." pillar.")
return true