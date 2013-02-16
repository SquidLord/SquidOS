-- gitGit: Pull files from Git repository
--  by Alexander "SquidLord" Williams (SaladinVrai)

-- Place in the root directory of your preferred ComputerCraft turtles
--    or computers

-- Pastebin: http://pastebin.com/s21FC76b

-- Args:
--    URL
--       The URL of the file to pull; the Master branch is typically the most
--       recent.

---
-- Dependencies
---

-- NONE DAMNIT! Odds are low anything's even installed yet!

---
-- VARS
---

ARGS = {...}

---
-- FUNCTIONS

local function printUsage()
   usageText = {
      "SquidOS getGit: pull files from git repositories",
      "",
      "getGit URL",
      "  URL is the URI of the file in question without the leading",
      "    https://raw.github.com/",
      "",
      "By default, the name of the file will match that of the source",
      "  without any extension."
   }

   for _,L in ipairs(usageText) do
      print(L)
   end

   return false
end

-- expandURL(String) => String
--    Takes the end part of a git URL and returns the full URL to fetch the file
--    Checks for https at the beginning in case it's already a full URL
local function expandURL(URL)
   if (not URL) then return false end

   if (string.sub(URL, 1, 6) == "https:") then
      return URL
   else
      return "https://raw.hithub.com/"..URL
   end
end

-- extractFileFromURL(String) => String
--    Take a full or partial URL and return the filename between any final . and the last /
local function extractFileFromURL(URL)
   -- first:  Need a simple way to get the first char
   local function first(S)
      if (not S) then -- What, you're passing me a nil?
         return false
      end
      local F = ""
      F = string.sub(S, 1, 1)
      if (F == "") then
         return false
      else
         return F
      end
   end

   -- rest: Need everything BUT the first char
   local function rest(S)
      if (not S) then -- What, you're passing me a nil?
         return false
      end
      local F = ""
      F = string.sub(S, 2)
      if (F == "") then
         return false
      else
         return F
      end
   end

   -- exffu: Create a continuation-passing-style func to handle things
   local function exffu(Work, FN)
      F = first(Work)
      if ((not F) or (F == "")) then
         return FN -- If no more charas to process, return the FN
      elseif (F == ".") then -- If we've found the last "."
         return exffu(rest(Work), "") -- Call exffu with the rest of the URL and reset the FN
      elseif (F == "/") then -- If we found the last "/"
         return FN -- Return the FileName
      else
         -- If it's just a character, recourse on rest of URL and append character to FN
         return exffu(rest(Work), FN..F)
      end
   end

   -- Call with string reversed to make it easier to parse
   FileName = exffu(string.reverse(URL), "")

   if FileName then
      return FileName
   else
      return false
   end
end


----
-- MAIN
----

local function main()
   print("SquidOS getGit ...")
   print("")

   if (not ARGS[1]) then -- If called as library or with no command line, Usage
      printUsage()
      return false
   end 

   if (not http) then -- If the http API isn't built in, fail
      print("  Requires the http API")
      return false
   end

   -- local safedURL = textutils.urlEncode(URL)
   local SafedURL = URL
   local URL = expandURL(SafedURL)
   local FileName = extractFileFromURL(SafedURL)

   if not FileName then -- If there was no filename at the end of the URL, fail
      return printUsage()
   else
      print("  Getting: "..URL)
      print("  Writing: "..FileName)
      print()
   end

   print("  Getting file from gitHub ...")

   local FNcontent = http.get(URL)

   if (not FNcontent) then
      print("  !!! Failed to pull file !!!")
      return false
   end

   if (not (FNcontent.getResponseCode() == 200)) then
      print("  !!! Response code "..FNcontent.getResponseCode().." !!!")
      return false
   end

   local FNdata = FNcontent.readAll()

   if fs.exists(FileName) then
      print("  Wiping old version")
      fs.delete(FileName)
   end

   local Dump = fs.open(FileName, "w")
   Dump.write(FNdata)
   Dump.close()

   print("  Done!")
end

---
-- MAIN Entry
---

main()
