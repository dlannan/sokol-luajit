module(..., package.seeall)

local crypto = require 'crypto'

local dtypes = {"md5", "md4", "md2", "sha1", "sha", "sha256", "sha512"}

local function load(modulename)
  -- Find source
  local filename
  local file,hashfile,hashtype
  local errmsg = ""
  for path in string.gmatch(package.path..";", "([^;]*);") do
    filename = string.gsub(path, "%?", (string.gsub(modulename, "%.", "\\")))
    file = io.open(filename, "rb")
    -- If we found a module check if it has a hash file
    if file then
      for _,dtype in ipairs(dtypes) do
        hashfile = io.open(filename.."."..dtype, "rb")
        if hashfile then
          hashtype = dtype
          break
        end
      end
    end
    if hashfile then
      break
    end
    errmsg = errmsg.."\n\tno file '"..filename.."' (signed)"
  end
  if not file then
    return errmsg
  end
  -- Read source file
  local source = file:read("*a")
  -- Read saved hash
  local hash = hashfile:read("*a"):gsub("[^%x]", "")
  -- Check that the saved hash match the file hash
  assert(crypto.evp.digest(hashtype, source)==hash,
    "module "..modulename.." (from file '"..filename.."')"
    .." does not match its "..hashtype.." hash")
  -- Compile and return the module
  return assert(loadstring(source, filename))
end

-- Install the loader so that it's called just before the normal Lua loader
table.insert(package.loaders, 2, load)