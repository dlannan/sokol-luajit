local tinsert 	= table.insert
local tremove 	= table.remove
local tcount 	= table.getn
local ffi 		= require("ffi")

-- ---------------------------------------------------------------------------

local struct    = require("lua.struct")
local tween 	= require("lua.tween")

-- ---------------------------------------------------------------------------

local function genname()
	m,c = math.random,("").char 
	name = ((" "):rep(9):gsub(".",function()return c(("aeiouy"):byte(m(1,6)))end):gsub(".-",function()return c(m(97,122))end))
	return(string.sub(name, 1, math.random(4) + 5))
end

-- ---------------------------------------------------------------------------

local function tcount(tbl)
	local cnt = 0
	if(tbl == nil) then return cnt end
	for k,v in pairs(tbl) do 
		cnt = cnt + 1
	end 
	return cnt
end 

-- ---------------------------------------------------------------------------

local function uinttocolor( ucolor )

	return {
		bit.band(ucolor, 0xff) / 255.0,
		bit.band(bit.rshift(ucolor, 8), 0xff) / 255.0,
		bit.band(bit.rshift(ucolor, 16), 0xff) / 255.0,
		bit.band(bit.rshift(ucolor, 24), 0xff) / 255.0,
	}
end

-- -----------------------------------------------------------------------

local function processPngHeader(header)
	local pnginfo = {}
	local filesig = header:sub(1, 8)
	if (filesig == string.format("%c%c%c%c%c%c%c%c", 0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a)) then
		local tmp = struct.unpack("<L", header, 9)-- we dont care about length and chunktype (iHDR is always first)
		pnginfo.width = struct.unpack(">I", header, 17)
		pnginfo.height = struct.unpack(">I", header, 21)
		pnginfo.depth = struct.unpack(">B", header, 25)
		pnginfo.type = struct.unpack(">B", header, 26)
		pnginfo.comp = struct.unpack(">B", header, 27)
		pnginfo.filter = struct.unpack(">B", header, 28)
		pnginfo.interlace = struct.unpack(">B", header, 29)
		return pnginfo
	end
	return nil
end

-- -----------------------------------------------------------------------
-- PNG header loader
local function getpngfile(filenamepath)
    -- Try to open first - return nil if unsuccessful
    local fh = io.open(filenamepath, 'rb')
    if (fh == nil) then
        print("[Error] png file not found: " .. filenamepath)
        return nil
    end
	local header = fh:read(8 + 8 + 4 + 4 + 1 + 1 + 1 + 1 + 1)
	fh:close()
	local pnginfo = processPngHeader(header)
	if (pnginfo) then return pnginfo end

    print("[Error] Png header unreadable: " .. filenamepath)
    return nil
end

-- ---------------------------------------------------------------------------

function tmerge(t1, t2)
	if(t1 == nil) then t1 = {} end 
	if(t2 == nil) then return t1 end 
	
	for k, v in pairs(t2) do
		if (type(v) == "table") and (type(t1[k] or false) == "table") then
			tmerge(t1[k], t2[k])
		else
			t1[k] = v
		end
	end
	return t1
end

-- ---------------------------------------------------------------------------
local visited = {}
local function tdump(o, level)
	local level = level or 1
	if(level == 0) then visited = {} end
	if type(o) == 'table' then
	   	local s = ' {\n'
	   	for k,v in pairs(o) do
		  	if type(k) ~= 'number' then k = '"'..tostring(k)..'"' end
			if(visited[v] == nil) then 
				visited[v] = true
		  		s = s .. string.rep("  ", level)..'['..k..'] = ' .. tdump(v, level+1)
			end
	   	end
	   	return s .. string.rep("  ", level-1)..'}\n'
	else
	   return tostring(o).."\n"
	end
 end

-- ---------------------------------------------------------------------------

local function tablejson( list )

	local p = "{"
	local i = 1
	for k,v in pairs(list) do 
		if(i ~= 1) then p = p.."," end

		if(type(v) == "table") then 
			p = p.."\""..tostring(k).."\":\""..tablejson(v)
		elseif(type(v) == "number") then 
			p = p.."\""..tostring(k).."\":"..tostring(v)
		elseif(type(v) ~= "function") then
			p = p.."\""..tostring(k).."\":\""..tostring(v).."\""
		end
		i = i + 1
	end
	p = p.." }"

	return p
end

-- ---------------------------------------------------------------------------
-- Deep Copy
-- This is good for instantiating tables/objects without too much effort :)

function deepcopy(t)
	if type(t) ~= 'table' then return t end
	local mt = getmetatable(t)
	local res = {}
	for k,v in pairs(t) do
		if type(v) == 'table' then
		v = deepcopy(v)
		end
		res[k] = v
	end
	setmetatable(res,mt)
	return res
end

-- ---------------------------------------------------------------------------

local function tickround(self, dt, callback)

	if(self.round == nil) then return end 
	
	self.round.timeout = self.round.timeout - dt
	-- Selection done
	if(self.round.timeout < 0.0) then 
		self.round.timeout = 0.0
		callback()
	end
end 

------------------------------------------------------------------------------------------------------------
-- Remove quotes from string start and end
local function cleanstring(str)
	if(str == nil) then return str end
	if(string.sub(str, 1, 1) == "'") then 
		str = string.sub(str, 2, -1)
	end 
	if(string.sub(str, -1) == "'") then 
		str = string.sub(str, 1, -2)
	end 
	str = string.gsub(str, "%%20", " " ) 
	
	-- str = string.gsub(str, "'", "")
	-- str = string.gsub(str, '"', "")
	return str
end

-- ---------------------------------------------------------------------------

local function loaddata(filepath)
	local data = nil
	local fh = io.open(filepath, "rb")
	if(fh) then 
		data = fh:read("*a")
		fh:close()
	else 
		print("[Error] utils.loaddata: Unable to load - "..filepath)
	end
	return data 
end

-- ---------------------------------------------------------------------------

local function savedata(filepath, content)
	local data = nil
	local fh = io.open(filepath, "wb")
	if(fh) then 
		data = fh:write(content)
		fh:close()
	else 
		print("[Error] utils.savedata: Unable to save - "..filepath)
	end
end

------------------------------------------------------------------------------------------------------------

local function csplit(str,sep)
	local ret={}
	local n=1
	for w in str:gmatch("([^"..sep.."]*)") do
		-- only set once (so the blank after a string is ignored)
		if w=="" then
			n = n + 1
		else 
			ret[n] = ret[n] or w
		end -- step forwards on a blank but not a string
	end
	return ret
end

-- ---------------------------------------------------------------------------

local function ByteCRC(sum, data)
    sum = bit.bxor(sum, data)
    for i = 0, 7 do     -- lua for loop includes upper bound, so 7, not 8
        if (bit.band(sum, 1) == 0) then
            sum = bit.rshift(sum , 1)
        else
            sum = bit.bxor(bit.rshift(sum , 1), 0xA001)  -- it is integer, no need for string func
        end
    end
    return sum
end

-- ---------------------------------------------------------------------------

local function CRC(data, length)
    local sum = 65535
    local d
    for i = 1, length do
        d = string.byte(data, i)    -- get i-th element, like data[i] in C
        sum = ByteCRC(sum, d)
    end
    return sum
end

-- ---------------------------------------------------------------------------

function table.val_to_str ( v )
	if "string" == type( v ) then
	  v = string.gsub( v, "\n", "\\n" )
	  if string.match( string.gsub(v,"[^'\"]",""), '^"+$' ) then
		return "'" .. v .. "'"
	  end
	  return '"' .. string.gsub(v,'"', '\\"' ) .. '"'
	else
	  return "table" == type( v ) and table.tostring( v ) or
		tostring( v )
	end
end

function table.key_to_str ( k )
	if "string" == type( k ) and string.match( k, "^[_%a][_%a%d]*$" ) then
		return k
	else
		return "[" .. table.val_to_str( k ) .. "]"
	end
end

function table.tostring( tbl )
local result, done = {}, {}
	for k, v in ipairs( tbl ) do
		table.insert( result, table.val_to_str( v ) )
		done[ k ] = true
	end
	for k, v in pairs( tbl ) do
		if not done[ k ] then
		table.insert( result,
			table.key_to_str( k ) .. "=" .. table.val_to_str( v ) )
		end
	end
	return "{" .. table.concat( result, "," ) .. "}"
end

-- ---------------------------------------------------------------------------

function urldecode(s)
	s = s:gsub('+', ' ')
		 :gsub('%%(%x%x)', function(h)
							 return string.char(tonumber(h, 16))
						   end)
	return s
end
  
function parseurl(s)
	if(s == nil) then return {} end
	local ans = {}
	for k,v in s:gmatch('([^&=?]-)=([^&=?]+)' ) do
		ans[ k ] = urldecode(v)
	end
	return ans
end

-- ---------------------------------------------------------------------------

local function get_field_ptr( object, structname, field, ptrtype)

	local base_ptr = ffi.cast("uint8_t *", object)
	local off = ffi.offsetof(structname, field)
	return ffi.cast(ptrtype, base_ptr + off)
end


-- ---------------------------------------------------------------------------
return {

	getdirs 		= getdirs,
	csplit			= csplit,
	cleanstring		= cleanstring,

	uinttocolor 	= uinttocolor,
	getpngfile		= getpngfile,
	getpngheader	= processPngHeader,

	crc 			= CRC,
	
	genname 		= genname,
	tcount 			= tcount,
	tmerge			= tmerge,
	tdump			= tdump,
	tablejson		= tablejson,

	deepcopy		= deepcopy,

	tickround		= tickround,

	loaddata		= loaddata,
	savedata		= savedata,

	urldecode		= urldecode,
	parseurl 		= parseurl,

	get_field_ptr	= get_field_ptr,
}
-- ---------------------------------------------------------------------------
