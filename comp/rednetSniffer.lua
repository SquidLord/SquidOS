-- ComputerCraft Broadcast Rednet Monitor
--   Monitor all traffic on local broadcast RedNet
-- by Alexander "SquidLord" Williams (SaladinVrai)

-- Import dependencies

os.loadAPI("squidOS/lib/squidlib")

-- Get the system label for identification

local SysName = os.getComputerLabel()

-- Open modem for comms

squidlib.initModem()

-- Identify

print("SquidOS RedNet Sniffer ...")
write("  Running on "..squidlib.labelString())

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
