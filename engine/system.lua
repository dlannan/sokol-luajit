local dirtools  = require("tools.vfs.dirtools").init("worldbuilder")

-- --------------------------------------------------------------------------------------

local sapp        = require("sokol_app")
local stb         = require("stb")
local nk          = sg

local platform    = require("src.platform")

local ffi         = require("ffi")

local tinsert     = table.insert
local tremove 	  = table.remove

-- --------------------------------------------------------------------------------------

local function fuzzy_match(needle, haystack, file_mode)
  -- Convert to lowercase for case‑insensitive match
  local n = needle:lower()
  local h = haystack:lower()

  local nlen = #n
  local hlen = #h

  if nlen == 0 then
      return 1  -- empty needle matches with highest score
  end

  local score = 0
  local j = 1

  for i = 1, nlen do
      local c = n:sub(i,i)
      local found = h:find(c, j, true)
      if not found then
          return 0  -- no match
      end
      -- reward a match early in the haystack
      if found == j then
          score = score + 1
      end
      j = found + 1
  end

  -- normalize score: divide by the haystack length (or some heuristic)
  local norm = score / hlen
  return norm
end

-- --------------------------------------------------------------------------------------

system = {
	event_queue 		= {}, -- Back buffer events are always collected in.
	has_focus 			= true,
    iconified           = false,
    
    keychanges          = {},       -- A buffer of most recent key pressed
    mousechanges        = {},       -- A buffer of most recent mouse button presses
}

-- --------------------------------------------------------------------------------------

system.push_event = function( ev )

	-- print(ev.type, ev.a, ev.b, ev.c, ev.d)
	tinsert(system.event_queue, ev)
end

-- --------------------------------------------------------------------------------------

system.events_clear = function()
	for i = #system.event_queue, 1, -1 do
		if system.event_queue[i].processed == true then
			tremove(system.event_queue, i)
		end
	end
end

-- --------------------------------------------------------------------------------------
-- This is a double buffered event queue in case events come in while processing
system.events_buffer = function()
	local tmp = {}
	for i, ev in ipairs(system.event_queue) do
		tinsert(tmp, ev)
		ev.processed = true 
	end 
	system.events_clear()
	return tmp
end 

-- --------------------------------------------------------------------------------------
-- blocking: wait for event, simplified with coroutine or a condition var
system.wait_event         = function(timeout) 
	local ticker_end = os.clock() + timeout
	while #system.event_queue == 0 and os.clock() < ticker_end do
	end
end

-- --------------------------------------------------------------------------------------

system.set_cursor         = function(cursor_name, rect) 
    renderer.cursor = { name = cursor_name, rect = rect }
end

-- --------------------------------------------------------------------------------------

system.set_window_title   = function(title) 
    sapp.sapp_set_window_title(title)
end

-- --------------------------------------------------------------------------------------
-- Set fullscreen, minimized and maximized etc
system.set_window_mode    = function(mode, width, height) 
    -- sapp_is_fullscreen()
    -- sapp_toggle_fullscreen()
end

-- --------------------------------------------------------------------------------------

system.window_has_focus   = function() 
    return system.has_focus
end

-- --------------------------------------------------------------------------------------

system.show_confirm_dialog= function(title, message) 
    return false 
end

-- --------------------------------------------------------------------------------------

system.chdir              = function(path) 
    -- dirtools.change_dir(path)
end

-- --------------------------------------------------------------------------------------

system.list_dir           = function(path) 
	-- print("list_dir", path)
    return dirtools.get_dir_names(path)
end

-- --------------------------------------------------------------------------------------

system.absolute_path      = function(path) 
	-- print("absolute_path")
    local abspath = dirtools.get_absolute_path(path)
	return abspath
end

-- --------------------------------------------------------------------------------------

system.get_file_info      = function(path) 
	return dirtools.get_fileinfo(path)
    -- return { modified=0, size=0, type="file" } 
end

-- --------------------------------------------------------------------------------------
-- Opens native file selection dialog
system.file_select      = function(start_path)

    local filename = win.FileSelect()
    return filename
end

-- --------------------------------------------------------------------------------------
-- Opens native file selection dialog
system.folder_select      = function(start_path)

    return win.FolderSelect()
end

-- --------------------------------------------------------------------------------------

system.get_clipboard      = function() 
    return ffi.string(sapp.sapp_get_clipboard_string())
end

-- --------------------------------------------------------------------------------------

system.set_clipboard      = function(text) 
    sapp.sapp_set_clipboard_string(ffi.string(text))
end

-- --------------------------------------------------------------------------------------

system.get_time           = function() 
    return os.clock()
end

-- --------------------------------------------------------------------------------------

system.sleep              = function(seconds) 
    win.Sleep(seconds * 1000) 
end

-- --------------------------------------------------------------------------------------

system.exec               = function(cmd) 
	-- cmd = string.format("cmd /c \"%s 2>&1\"", cmd)
	-- print(cmd)
    local fh = io.popen(cmd, "r")
	local results = ""
	if(fh) then 
		results = fh:read("*a")
		fh:close()
	end 
	return results
end

-- --------------------------------------------------------------------------------------

system.fuzzy_match        = function(str, pattern) 
    return fuzzy_match( pattern, str, false)
end

-- --------------------------------------------------------------------------------------

-- /* gets the total number of dropped files (after an SAPP_EVENTTYPE_FILES_DROPPED event) */
-- SOKOL_APP_API_DECL int sapp_get_num_dropped_files(void);
-- /* gets the dropped file paths */
-- SOKOL_APP_API_DECL const char* sapp_get_dropped_file_path(int index);