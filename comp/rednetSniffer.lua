-- ComputerCraft Broadcast Rednet Monitor
--   Monitor all traffic on local broadcast RedNet
-- by Alexander "SquidLord" Williams (SaladinVrai)

-- Get the system label for identification

local SysName = os.getComputerLabel()

-- Iterate over all sides for rednet.open

for n,m in ipairs(rs.getSides()) do
   rednet.open(m)
end

-- Identify

print("SquidOS RedNet Sniffer ...")
if SysName then
   print("  Running on node: " .. os.getComputerLabel())
else
   write("  Running on ")
   textutils.slowPrint("UNIDENTIFIED NODE")
end

print()
print("Press and hold Ctrl-T to end.")
print()

-- Loop forever (or until forced termination with Ctrl-T)

while true do
   Event, Id, Content = os.pullEvent()
   if Event == "rednet_message" then
      print(Id .. " (" .. textutils.formatTime(os.time(), false) ..")>")
      print("  " .. Content)
   end
end
