-- usage: lua luac.lua [file.lua]* [-L [module.lua]*]
--
-- creates a precompiled chunk that preloads all modules listed after
-- -L and then runs all programs listed before -L.
--
-- assumptions:
--	file xxx.lua contains module xxx
--	'/' is the directory separator (could have used package.config)
--	int and size_t take 4 bytes (could have read sizes from header)
--	does not honor package.path
--
-- Luiz Henrique de Figueiredo <lhf@tecgraf.puc-rio.br>
-- Tue Aug  5 22:57:33 BRT 2008
-- This code is hereby placed in the public domain.
--
-- This has been hevily midified to utilize a different method to concatenate the 
-- chunks without losing the package module mapping.
-- ref: https://www.lua-users.org/wiki/LuaCompilerInLua

-- ---------------------------------------------------------------------------------------------------

local combine = {}

-- ---------------------------------------------------------------------------------------------------
-- Load a chunk manually so we can name it
local function loader(filepath)
  local data = ""
  local fh = io.open(filepath, "r")
  if(fh) then 
    data = fh:read("*a")
    fh:close() 
  end 
  return data 
end

-- ---------------------------------------------------------------------------------------------------

combine.run =  function(tempfile, startup_files, lib_files)

  local outfile=tempfile

  -- Iterate libs to prepend them to the chunk list
  local ts = {}
  table.insert(ts, 1, "local t=package.preload;")

  for k,v in ipairs(lib_files) do
    local modulename = string.gsub(v.name, "^%.[/\\]", "")
    modulename = string.gsub(modulename, "[/\\]", "%.")
    modulename = string.gsub(modulename, "%.lua", "")
    print(">>>> Module: "..modulename.."   "..v.fullpath)

    local loaded_chunk = assert(load( loader(v.fullpath),modulename ))
    table.insert(ts, ("t['%s']=load(%q);"):format(modulename, string.dump(loaded_chunk)) )
  end

  -- Add core scripts that will be executed
  for k,v in ipairs(startup_files) do
    table.insert(ts, ("load(%q)(...);"):format(string.dump(assert(loadfile(v)))) )
  end

  -- Assemble chunks into one file to dump. 
  local chunks = assert(load(table.concat(ts)))
  local f=assert(io.open(outfile,"wb"))
  local data = string.dump(chunks)
  f:write(data)
  assert(f:close())
end

-- ---------------------------------------------------------------------------------------------------

return combine 

-- ---------------------------------------------------------------------------------------------------
