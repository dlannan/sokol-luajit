-- --------------------------------------------------------------------------------------
-- This is crazy windows stuff. Will attempt with OSX and Linux later)

-- TODO - I think I need to make this a core main app, and the other processes are forked
--        from this app. That way it can get process handles and manage them closing properly.
--        Other benefits might be the ability to put their hwnd into a "master window" and thus
--        drive it all much more cleanly (this will suit linux and osx more too)

local ffi       = require("ffi")
local winu      = require("editor.deps.winutils")

-- Load in the user32 runtime library into the ffi.C interface
local kernel32  = winu.kernel 
local user32    = winu.user
local gdi32     = winu.gdi 
local comdlg32  = winu.comdlg 

local CreateWindow          = winu.CreateWindow 
local GetFile               = winu.GetFile 
local GetHwndFromProcess    = winu.GetHwndFromProcess
local RemoveWindowBorders   = winu.RemoveWindowBorders
local execute               = winu.execute
local shellexecute          = winu.shellexecute
local sleep                 = winu.Sleep

------------------------------------------------------------------------------------------------------------

local hproc_browser, hthread_browser, si_browser    = nil
local hproc_sokol, hthread_sokol, si_sokol          = nil

local browserhwnd   = nil
local sokolhwnd     = nil

------------------------------------------------------------------------------------------------------------

local function SetupBrowser(rect)
print("BROWSER SETUP")

    local browser, bsize = winu.getDefaultBrowser()
    local browser_path    = ffi.string(browser)..[[ -new-window "http://localhost:9190/index.html"]]
    hproc_browser, hthread_browser, si_browser = execute(browser_path)
    sleep(200)
    -- Need to make this more generic (ie browser agnostic)
    local browserhwnd = GetHwndFromProcess( hthread_browser, "Mozilla Firefox" )
    -- local browserhwnd = user32.FindWindowA( nil, "http://localhost:9190/index.html")
    print(hproc_browser, hthread_browser, si_browser)
    if(browserhwnd) then 
        sleep(100) -- Let things setup (window pos etc)
        local style = user32.GetWindowLongA(browserhwnd, -16)
        print(string.format("0x%x", style))
        user32.AdjustWindowRect(rect, 0x80040000, 0)
        -- user32.MoveWindow(browserhwnd, rect[0].left, rect[0].top, rect[0].right-rect[0].left, rect[0].bottom-rect[0].top, 1)
        winu.SetWindowPos(browserhwnd, rect[0].left, rect[0].top, rect[0].right-rect[0].left, rect[0].bottom-rect[0].top)
    end
    return browserhwnd
end

------------------------------------------------------------------------------------------------------------

local function SetupSokolLuajit(rect, diff)
print("SOKOL-LUAJIT SETUP")

    local width = rect[0].right - rect[0].left 
    local height = rect[0].bottom - rect[0].top
    local sokolluajit_path    = [["bin/win64/luajit.exe" "editor/editor.lua" ]]..string.format(" %d  %d", width, height)
    hproc_sokol, hthread_sokol, si_sokol = execute(sokolluajit_path)
    sleep(200)
    print(hproc_sokol, hthread_sokol, si_sokol)
    local sokolhwnd = GetHwndFromProcess( hthread_sokol, "editor - sokol" )
    -- local sokolhwnd = user32.FindWindowA( nil, "editor - sokol")
    if(sokolhwnd) then 
        sleep(100) -- Let things setup (window pos etc)
        local style = user32.GetWindowLongA(sokolhwnd, -16)
        print(string.format("0x%x", style))
        user32.AdjustWindowRect(rect, style, 0)
        -- user32.MoveWindow(sokolhwnd, rect[0].left, 0, rect[0].right-rect[0].left, rect[0].bottom-rect[0].top - diff, 0)
        winu.SetWindowPos(sokolhwnd, rect[0].left, 0, rect[0].right-rect[0].left, rect[0].bottom-rect[0].top - diff)
    end
    return sokolhwnd
end
    
------------------------------------------------------------------------------------------------------------

local function setupWindows()


    local workArea = ffi.new("RECT")
    user32.SystemParametersInfoW(0x0030, 0, workArea, 0)
    desktop_width = workArea.right - workArea.left
    desktop_height = workArea.bottom - workArea.top
    print("Screen size:", desktop_width, "x", desktop_height)

    local desktop = ffi.new("RECT[1]")
    -- Get a handle to the desktop window
    hDesktop = user32.GetDesktopWindow()
    -- Get the size of screen to the variable desktop
    user32.GetWindowRect(hDesktop, desktop)
    local diff = desktop[0].bottom - desktop_height - 2
    print(diff)

    local dwidth = desktop_width/2.0
    desktop[0].bottom  = desktop_height

    desktop[0].left = 0
    desktop[0].right = dwidth
    browserhwnd = SetupBrowser(desktop)

    desktop[0].left = dwidth
    desktop[0].right = desktop_width
    sokolhwnd = SetupSokolLuajit(desktop, diff)
end 

------------------------------------------------------------------------------------------------------------

setupWindows()
while true do 
    if(user32.IsWindow(browserhwnd) == 0) then break end 
    if(user32.IsWindow(sokolhwnd) == 0) then break end
    sleep(1)
end

if(browserhwnd) then
    user32.SendMessageA(browserhwnd, ffi.C.WM_CLOSE, 0, 0)
end
if(sokolhwnd) then 
    user32.SendMessageA(sokolhwnd, ffi.C.WM_CLOSE, 0, 0)
end
print("Editor Exited.")
------------------------------------------------------------------------------------------------------------
