-- --------------------------------------------------------------------------------------
-- This is crazy windows stuff. Will attempt with OSX and Linux later)
local ffi       = require("ffi")
local winu      = require("editor.deps.winutils")

-- Load in the user32 runtime library into the ffi.C interface
local kernel32  = winu.kernel 
local user32    = winu.user
local gdi32     = winu.gdi 
local comdlg32  = winu.comdlg 

local CreateWindow = winu.CreateWindow 
local GetFile   = winu.GetFile 
local GetHwndFromProcess = winu.GetHwndFromProcess
local RemoveWindowBorders = winu.RemoveWindowBorders
local execute   = winu.execute
local shellexecute   = winu.shellexecute
local sleep     = winu.Sleep

------------------------------------------------------------------------------------------------------------

local hproc_browser, hthread_browser, si_browser = nil
local hproc_sokol, hthread_sokol, si_sokol = nil

local browserhwnd   = nil
local sokolhwnd     = nil

------------------------------------------------------------------------------------------------------------

local function SetupBrowser(rect)
print("BROWSER SETUP")

    local browser, bsize = winu.getDefaultBrowser()
    local browser_path    = ffi.string(browser)..[[ -new-window "http://localhost:9190/index.html"]]
    hproc_browser, hthread_browser, si_browser = execute(browser_path)
    sleep(100)
    -- Need to make this more generic (ie browser agnostic)
    local browserhwnd = GetHwndFromProcess( hthread_browser, "Mozilla Firefox" )
    -- local browserhwnd = user32.FindWindowA( nil, "http://localhost:9190/index.html")
    print(hproc_browser, hthread_browser, si_browser)
    if(browserhwnd) then 
        user32.MoveWindow(browserhwnd, rect[0].left, rect[0].top, rect[0].right-rect[0].left, rect[0].bottom-rect[0].top, 1)
    end
    return browserhwnd
end

------------------------------------------------------------------------------------------------------------

local function SetupSokolLuajit(rect)
print("SOKOL-LUAJIT SETUP")

    local sokolluajit_path    = [["bin/win64/luajit.exe" "editor/editor.lua"]]
    hproc_sokol, hthread_sokol, si_sokol = execute(sokolluajit_path)
    sleep(100)
    print(hproc_sokol, hthread_sokol, si_sokol)
    local sokolhwnd = GetHwndFromProcess( hthread_sokol, "editor - sokol" )
    -- local sokolhwnd = user32.FindWindowA( nil, "editor - sokol")
    if(sokolhwnd) then 
        user32.MoveWindow(sokolhwnd, rect[0].left, rect[0].top, rect[0].right-rect[0].left, rect[0].bottom-rect[0].top, 1)
    end
    return sokolhwnd
end
    
------------------------------------------------------------------------------------------------------------

local function setupWindows()

    local desktop = ffi.new("RECT[1]")
    -- Get a handle to the desktop window
    hDesktop = user32.GetDesktopWindow()
    -- Get the size of screen to the variable desktop
    user32.GetWindowRect(hDesktop, desktop)

    local l = desktop[0].left
    local r = desktop[0].right
    desktop[0].bottom  = desktop[0].bottom - 50

    desktop[0].left = 0
    desktop[0].right = (r-l)/2
    browserhwnd = SetupBrowser(desktop)
    desktop[0].left = (r-l)/2
    desktop[0].right = r
    sokolhwnd = SetupSokolLuajit(desktop)
end 

------------------------------------------------------------------------------------------------------------

setupWindows()
while true do 
    if(user32.IsWindow(browserhwnd) == 0) then break end 
    if(user32.IsWindow(sokolhwnd) == 0) then break end
    sleep(1)
end

user32.CloseWindow(browserhwnd)
user32.CloseWindow(sokolhwnd)
print("Exited")
------------------------------------------------------------------------------------------------------------
