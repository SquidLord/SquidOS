-- gist: A program for fetching and putting files to/from the GitHub-linked
--    gist repository

-- by p3lim (original)

local cmd, arg = ...

local function printUsage()
   print('Usages:')
   print('gist put <filename>')
   print('gist get <id>')
end

if(not arg) then
   return printUsage()
end

if(not http) then
   print('Gist requires http API')
   print('Set B:enableAPI_http to true in ComputerCraft.cfg')
   return
end

local jsonPath = shell.resolve('json')

if(not fs.exists(jsonPath)) then
   print('Missing JSON library, downloading now.')
   os.sleep(0.2)
   write('Connecting to pastebin.com...')

   local response = http.get('http://pastebin.com/raw.php?i=0g211jCp')
   if(response) then
      print('Success!')

      local result = response.readAll()
      response.close()

      local file = fs.open(jsonPath, 'w')
      file.write(result)
      file.close()

      print('Downloaded JSON library to "json"')
   else
      return print('Failed.')
   end
end

if(not json) then
   os.loadAPI(jsonPath)
end

local post = '{"public":true,"files":{"%s.lua":{"content":"%s"}}}'

if(cmd == 'put') then
   return print('Put is not yet implemented')
   --[[
      local path = shell.resolve(arg)
      if(not fs.exists(path) or fs.isDir(path)) then
      return print('No such file')
      end

      local file = fs.open(path, 'r')
      local content = file.readAll()
      file.close()

      write('Connecting to gist.github.com...')
      http.post('https://api.github.com/gists', string.format(post, fs.getName(path), content))
      print(response)
      print(type(response))
      response.close()


      if(response) then
      print('Success!')

      local result = response.readAll()
      response.close()

      local _, id = string.match(result, '[^/]+$')
      print('Uploaded as ', response)
      print('Run "gist get ', id, '" to download anywhere')
      else
      print('Failed.')
      end
      --]]
elseif(cmd == 'get') then
   write('Connecting to gist.github.com...')
   local response = http.get('https://api.github.com/gists/' .. arg)

   if(response) then
      print('Success!')

      local result = response.readAll()
      response.close()

      local jsonTable = json.decode(result)

      for file, data in pairs(jsonTable.files) do
         print('Found "', file, '"')
         print('Please select a name for it:')

         local name = read()
         local path = shell.resolve(name)

         if(fs.exists(path)) then
            print('File "', name, '" already exists, skipping...')
         else
            local file = fs.open(path, 'w')
            file.write(data.content)
            file.close()

            print('Downloaded as ', name)
         end
      end
   else
      print('Failed.')
   end
else
   return printUsage()
end