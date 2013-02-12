-- Core library for SquidOS shared functions. Put in turtle startup file with:
--   os.loadAPI("squid/squidLib")
-- by Alexander "SquidLord" Williams (SaladinVrai)

-- Gist: https://gist.github.com/SquidLord/4746742

-- labelString() checks the machine's label and returns a sensible string
function labelString()
   local SYSNAME = os.getComputerLabel()
   if not SYSNAME then SYSNAME = "!UNKNOWN NODE!" end -- unset labels get a name
   return SYSNAME
end

-- initModem looks on all sides of a Computer for a modem and opens it for rednet communications
function initModem()
   local netOpen, modemSide = false, nil
   
   for _, side in pairs(rs.getSides()) do  -- for all sides
      if peripheral.getType(side) == "modem" then  -- find the modem
	 modemSide = side
	 if rednet.isOpen(side) then  -- check its status
	    netOpen = true
	    break
	 end
      end
   end
   
   if not netOpen then  -- if the rednet network is not open
      if modemSide then  -- and we found a modem, open the rednet network
	 rednet.open(modemSide)
      else
	 return false
      end
   end

   return true
end

-- broadcastMessage(String) sends String out to all rednet nodes in range
--    ASSUMES an opened rednet modem; call squidLib.initModem() before
--      using
--    String will be prefixed with the label of the current platform
--      to squidLib convention
function redCast(Mess)
   return rednet.broadcast(":"..labelString()..": "..Mess)
end

-- outputTextTable(Table) => Bool
--    Takes a table of text lines and prints them to the screen in order
function printTable(TextTable)
   for _,L in ipairs(TextTable) do
      print(L)
   end
end
