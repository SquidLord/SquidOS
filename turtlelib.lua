-- turtleLib: A core set of tool libraries for ComputerCraft turtles
-- by Alexander "SquidLord" Williams (SaladinVrai)

-- Gist: https://gist.github.com/SquidLord/4755840

-- Put in turtle startup file with: 
--    os.loadAPI("squid/turtleLib")


-- goodStr
--    String containing list of all good characters for directions
goodStr = "fblrudLR"


-- makeMoveTable(Lib) => Table
--    takes a Lib (egps, turtle) and builds a map of String->move function associations
function makeMoveTable(Lib)
   MT = {}
   
   MT.f = Lib.forward
   MT.b = Lib.back
   MT.l = Lib.turnLeft
   MT.r = Lib.turnRight
   MT.u = Lib.up
   MT.d = Lib.down
   MT.L = function() 
      Lib.turnLeft()
      Lib.forward()
      Lib.turnRight()
   end
   MT.R = function()
      Lib.turnRight()
      Lib.forward()
      Lib.turnLeft()  
   end
   return MT
end


-- StrToDirection(Cha, MoveTable) => Func
--    Takes a single-character string and returns the turtle
--    movement function associated with that direction
function chaToDirection(Cha, MoveTable)
   if not (string.find(goodStr, Cha)) then
      return false
   else
      return MoveTable[Cha]
   end
end


-- stringToMoves(String, Table, [Table]): => Table
--    Takes a string, a generated MoveTable, and an optional table in progress
--    Returns an ordered list of function calls
function stringToMoves(Str, MoveTable, OutTable)
   if (OutTable == nil) then -- If this is the first call of the func, init OutTable
      OutTable = {}
   end
   
   if (Str == "") then -- If there are no more cha's to process, return
      return OutTable
   else
      table.insert(OutTable, MoveTable[string.sub(Str, 1, 1)])
      return stringToMoves(string.sub(Str, 2),
			   MoveTable,
			   OutTable)
   end                                  
end

-- executeMoveTable(Table) => Bool
--    Executes a series of turtle moves as given in an ordered Table
function executeMoves(MoveTable)
   for _,Move in ipairs(MoveTable) do
      Move()
   end
end