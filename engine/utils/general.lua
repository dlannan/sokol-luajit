-- --------------------------------------------------------------------------------------

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

 
 -- --------------------------------------------------------------------------------------

 local function ffi_string( data, str )

	data.value = str
	data.ffi = ffi.new("char[?]", #str, str)
	data.len_ffi = ffi.new("int[1]", { #str} )
	return data
 end

 -- --------------------------------------------------------------------------------------

 return {
    tdump       = tdump,

	ffi_string	= ffi_string,
 }

 -- --------------------------------------------------------------------------------------