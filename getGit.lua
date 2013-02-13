-- gitGit: Pull files from Git repository
--  by Alexander "SquidLord" Williams (SaladinVrai)

-- Place in the root directory of your preferred ComputerCraft turtles
--    or computers

-- Args:
--    Filename
--        The filename to save it as
--    URL
--        The URL of the file to pull; the Master branch is typically the most
--        recent.

---
-- Dependencies
---

os.loadAPI("squid/squidlib")


---
-- VARS
---

ARGS = {...}

---
-- FUNCTIONS

local function printUsage()
   squidlib.printTable({
                          "SquidOS getGit: pull files from git repositories",
                          "",
                          "getGit URL",
                          "  URL is the URI of the file in question without the leading",
                          "    https://raw.github.com/"
                          "",
                          "By default, the name of the file will match that of the source",
                          "  without any extension."
                       })
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
   -- Need a simple way to get the first char
   local function first(S)
      local F = ""
      F = string.sub(S, 1, 1)
      if (F == "") then
         return false
      else
         return F
      end
   end

   -- Need everything BUT the first char
   local function rest(S)
      local F = ""
      F = string.sub(S, 2)
      if (F == "") then
         return false
      else
         return F
      end
   end

   -- Create a continuation-passing-style func to handle things
   local function exffu(Work, FN)
      F = first(Work)
      if not F then
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

   FileName = exffu(string.reverse(URL), "") -- Call with string reversed to make it easier to parse
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
   
   if (not ARGS) then printUsage() end -- If called as library or with no command line, Usage

   if (not http) then
      squidlib.print("  Requires the http API")
      return false
   end

   local URL = expandURL(ARGS[1])
   local FileName = extractFileFromURL(ARGS[1])

   if not FileName then
      return printUsage()
   else
      print("  Writing: "..FileName)
   end

   
   
end


main()
