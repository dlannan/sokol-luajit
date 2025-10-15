------------------------------------------------------------------------------------------------------------
local ffi = require( "ffi" )

local tinsert       = table.insert

local kernel32 	    = ffi.load( "kernel32.dll" )
local user32 	    = ffi.load( "user32.dll" )
local comdlg32      = ffi.load( "Comdlg32.dll" )
local gdi32         = ffi.load( "gdi32.dll" )
local shell32       = ffi.load( "shell32.dll" )
local ole32         = ffi.load( "ole32.dll" )
local shlwapi       = ffi.load( "shlwapi.dll" )

local Colors = {
	-- Color constants.
	rgbRed   =  0x000000FF,
	rgbGreen =  0x0000FF00,
	rgbBlue  =  0x00FF0000,
	rgbBlack =  0x00000000,
	rgbWhite =  0x00FFFFFF,
}

ffi.cdef[[

    typedef unsigned long DWORD;
    typedef int BOOL;
    typedef const char* LPCSTR;
    typedef unsigned int HANDLE;
    typedef unsigned int HWND;
    typedef unsigned long *ULONG_PTR;
    typedef long LPARAM;
    typedef int (*WNDENUMPROC)(HWND hwnd, LPARAM lParam);

    typedef struct enumData {
        uint64_t        lparam[1];
        const char *    title;
   } enumData;

   typedef struct tagPROCESSENTRY32 {
        DWORD dwSize;
        DWORD cntUsage;
        DWORD th32ProcessID;
        ULONG_PTR  th32DefaultHeapID;
        DWORD th32ModuleID;
        DWORD cntThreads;
        DWORD th32ParentProcessID;
        long pcPriClassBase;
        DWORD dwFlags;
        char szExeFile[260];
    } PROCESSENTRY32;   

    typedef struct { long left; long top; long right; long bottom; } RECT;

    HANDLE CreateToolhelp32Snapshot(DWORD dwFlags, DWORD th32ProcessID);
    BOOL Process32First(HANDLE hSnapshot, PROCESSENTRY32 *lppe);
    BOOL Process32Next(HANDLE hSnapshot, PROCESSENTRY32 *lppe);
    BOOL CloseHandle(HANDLE hObject);

    BOOL EnumWindows(WNDENUMPROC lpEnumFunc, LPARAM lParam);
    DWORD GetWindowThreadProcessId(HWND hWnd, DWORD *lpdwProcessId);
    BOOL IsWindowVisible(HWND hWnd);

    DWORD WaitForInputIdle(HANDLE hProcess, DWORD dwMilliseconds);
    HWND GetForegroundWindow(void);

    int GetSystemMetrics(int nIndex);
    int AdjustWindowRect(RECT* lpRect, unsigned long dwStyle, int bMenu);
    long GetWindowLongA(unsigned int hWnd, int nIndex);
    BOOL SystemParametersInfoW(unsigned int uiAction, unsigned int uiParam, RECT* pvParam, unsigned int fWinIni);

    BOOL SetWindowPos(unsigned int hWnd, void* hWndInsertAfter, int X, int Y, int cx, int cy, unsigned int uFlags);    

    void Sleep(uint32_t ms);
]]

require("ffi.windows")

-- -----------------------------------------------------------------------------------
local TH32CS_SNAPPROCESS = 0x00000002
local process_parents = {}
local process_childs = {}

local function GetAllProcesses( )
    -- Setup Toolhelp snapshot
    local snapshot = kernel32.CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0)
    if snapshot == -1 then return end

    local entry = ffi.new("PROCESSENTRY32[1]")
    entry[0].dwSize = ffi.sizeof("PROCESSENTRY32")

    local found = false
    local first_entry = kernel32.Process32First(snapshot, entry)
    if first_entry ~= 0 then
        repeat
            process_parents[entry[0].th32ParentProcessID] = process_parents[entry[0].th32ParentProcessID] or {}
            tinsert(process_parents[entry[0].th32ParentProcessID], entry[0].th32ProcessID)
            process_childs[entry[0].th32ProcessID] = entry[0].th32ParentProcessID
            print(entry[0].th32ProcessID, entry[0].th32ParentProcessID)
        until kernel32.Process32Next(snapshot, entry) == 0
    end

    kernel32.CloseHandle(snapshot)
end

-- -----------------------------------------------------------------------------------

function CheckChildren( win_pid, target_pid )

    if( process_parents[target_pid] ) then 
        for i, v in ipairs(process_parents[target_pid]) do 
            print(v, win_pid, target_pid)
            if v == win_pid then return true end 
        end 
    end 
    return false
end

-- -----------------------------------------------------------------------------------

local function FindWindowByProcId( proc_handle, proc_id, timeout_ms )

    timeout_ms = timeout_ms or 5000

    -- Wait until process is idle (i.e., its message queue is waiting)
    local wait_result = ffi.C.Sleep(timeout_ms)

    -- Get the currently active (foreground) window
    local hwnd = user32.GetForegroundWindow()
    if hwnd == nil then
        print("No foreground window found.")
        return nil
    end

    -- Check if it belongs to our target process
    local pid_ptr = ffi.new("DWORD[1]")
    user32.GetWindowThreadProcessId(hwnd, pid_ptr)
    return hwnd
end    

-- -----------------------------------------------------------------------------------

local function AssocQ( outstr, bsize )
    local ftype = ffi.cast("char *", ffi.string("http"))
    local verb = ffi.cast("char *", ffi.string("open"))
    local hr = shlwapi.AssocQueryStringA(user32.ASSOCF_NONE, user32.ASSOCSTR_EXECUTABLE, ftype, verb, outstr, bsize)
    return outstr, bsize
end

-- -----------------------------------------------------------------------------------

local function getDefaultBrowser()
    local bsize = ffi.new("uint32_t[1]")
    AssocQ( nil, bsize)
    local outstr = ffi.new("char[?]", bsize[0])
    local hr = AssocQ( outstr, bsize)
    return outstr, bsize
end

-- -----------------------------------------------------------------------------------
-- To be added to UTILS
local function execute(commandLine, currentDirectory)
    local si = ffi.new("STARTUPINFOA[1]")
    si[0].cb = ffi.sizeof(si[0])
    -- si[0].dwFlags = ffi.C.STARTF_USESTDHANDLES
    local pi = ffi.new("PROCESS_INFORMATION[1]")
    local hproc = ffi.C.CreateProcessA(nil, commandLine, nil, nil, 1, 0, nil, currentDirectory, si, pi) ~= 0
    -- Short delay to make sure the process has at least begun.
    ffi.C.Sleep(200)
    return pi[0].dwProcessId, pi[0].dwThreadId, pi
end   

-- -----------------------------------------------------------------------------------
-- To be added to UTILS
local function shellexecute(hwnd, commandline, directory)

    local cmdstr = ffi.new("char[?]", #commandline + 1)
    ffi.copy(cmdstr, ffi.string(commandline))
    
    local si = ffi.new("SHELLEXECUTEINFOA[1]")
    si[0].cbSize = ffi.sizeof(si[0])
    si[0].fMask = user32.SEE_MASK_NOCLOSEPROCESS
    si[0].hwnd = 0
    si[0].lpVerb = nil
    si[0].lpFile = ffi.cast("char *", cmdstr)
    si[0].lpParameters = nil
    si[0].lpDirectory = nil
    -- si[0].hInstApp = kernel32.GetModuleHandleA(nil)
    si[0].nShow = user32.SW_SHOW
    local res = shell32.ShellExecuteExA(si)
    print(string.format("Error: 0x%02x", kernel32.GetLastError()))
    print("result:", res)
    -- Short delay to make sure the process has at least begun.
    ffi.C.Sleep(200)
    return si[0].hProcess, si[0].hwnd, si
end  

------------------------------------------------------------------------------------------------------------
local reg = nil 

function CreateWindow(name, px, py, wide, high, createtype, wndproc, exstyle, parent, menu)

    local hparent = parent or 0 
    local hmenu = menu or 0

	local hInstance = kernel32.GetModuleHandleA(nil)
	local CLASS_NAME = 'TestWindowClass'
	
	if (reg == nil ) then
	
		local classstruct = {}
		classstruct.cbSize 		= ffi.sizeof( "WNDCLASSEXA" )
		classstruct.style 		= bit.bor(user32.CS_HREDRAW, user32.CS_VREDRAW)
	
		classstruct.lpfnWndProc = wndproc

		
		classstruct.cbClsExtra 		= 0
		classstruct.cbWndExtra 		= 0
		classstruct.hInstance 		= hInstance	
		classstruct.hIcon 			= user32.LoadIconA(0, idi.APPLICATION)
		classstruct.hCursor 		= user32.LoadCursorA(0, idc.ARROW)
		classstruct.hbrBackground 	= nil
		classstruct.lpszMenuName 	= nil
		classstruct.lpszClassName 	= CLASS_NAME
		classstruct.hIconSm = 0
		
		local wndclass = ffi.new( "WNDCLASSEXA", classstruct )	
		if(reg == nil) then 
            reg = user32.RegisterClassExA( wndclass )
		
		    if (reg == 0) then
			    error('error #' .. kernel32.GetLastError())
		    end
        end
	end 

    exstyle = exstyle or 0

	local hwnd = user32.CreateWindowExA( exstyle, CLASS_NAME, name, createtype, px, py, wide, high, hparent, hmenu, hInstance, nil)	
	if (hwnd == 0) then
		error 'unable to create window'
	end
	
	user32.ShowWindow(hwnd, user32.SW_SHOW)	
    print("[HWND] ", hwnd)
	return hwnd
end

local function SetTransparentBlend( hwnd, colorref, byte, style )
    user32.SetLayeredWindowAttributes(hwnd, colorref, byte, style )
end

------------------------------------------------------------------------------------------------------------
-- To be added to UTILS
local function RemoveWindowBorders(hwnd)

    local style = user32.GetWindowLongA(hwnd, user32.GWL_STYLE)

    local minimalStyle = bit.bnot(user32.WS_NOBORDERS)
    style = bit.band( style, minimalStyle )
    -- lExStyle = bit.bor(lExStyle, minimalStyle)
    user32.SetWindowLongA(hwnd, user32.GWL_STYLE, style)    
end 

------------------------------------------------------------------------------------------------------------
-- To be added to UTILS
local pid = ffi.new("DWORD[1]")
local buffer = ffi.new("char[256]")

local function EnumWindowsProc( hwnd, lparam )

    local processData = ffi.cast("enumData *", lparam)

    -- local style = user32.GetWindowLongA(hwnd, user32.GWL_STYLE)

    if(processData[0].title == nil) then 
        pid[0] = user32.GetWindowThreadProcessId(hwnd, nil)
        if(pid[0] == processData[0].lparam[0]) then        

            ffi.fill(buffer, 0, 256)
            user32.GetWindowTextA(hwnd, buffer, 255)
            local titlestr = ffi.string(buffer)
            print(string.format("PROC MATCH: %s %d", titlestr, pid[0]))
            -- Window title?
            processData[0].lparam[0] = ffi.cast("uint64_t", hwnd)
            return false
        end
    else
        ffi.fill(buffer, 0, 256)
        user32.GetWindowTextA(hwnd, buffer, 255)
        local titlestr = ffi.string(buffer)
        if(string.len(titlestr) > 5) then
            local wintitlestr = ffi.string(processData[0].title)
            titlestr = string.gsub(titlestr, "%-", "_")
            wintitlestr = string.gsub(wintitlestr, "%-", "_")
            print(string.format("HWND MATCH: %s   %s", titlestr, wintitlestr))
            if(string.match(titlestr, wintitlestr)) then 
                processData[0].lparam[0] = ffi.cast("uint64_t", hwnd)
                return false
            end
        end
    end

	return true
end 

------------------------------------------------------------------------------------------------------------

local function GetHwndFromProcess( pid, title )
    local processdata = ffi.new("enumData[1]")
    processdata[0].lparam[0] = pid
    if(title) then 
        processdata[0].title = ffi.cast("const char *", ffi.string(title)) 
    else 
        processdata[0].title = nil
    end
    user32.EnumWindows( EnumWindowsProc, ffi.cast("LPARAM", processdata))
    return ffi.cast("HWND", processdata[0].lparam[0])
end

------------------------------------------------------------------------------------------------------------

local function GetFile( filepath )
    local data = nil
    local dfile = io.open(filepath, "r")
    if(dfile) then 
        data = dfile:read("*a")
        dfile:close()
    end
    return data
end

------------------------------------------------------------------------------------------------------------

function WindowsFileSelect()

end

------------------------------------------------------------------------------------------------------------

function WindowsFolderSelect()
    local ofn = ffi.new("OPENFILENAME")
    ofn.lStructSize = ffi.sizeof(ofn)
    ofn.lpstrFile = ffi.new( "char[512]" )
    ofn.lpstrFilter = ffi.new( "char[19]", "All\0*.*\0Text\0*.TXT\0")
    ofn.lpstrInitialDir = ffi.new( "char[3]", "C:/")
    comdlg32.GetOpenFileNameA( ofn )

    print("Selected folder: ", ffi.string(ofn.lpstrFile ), ffi.string(ofn.lpstrFilter ))
end

------------------------------------------------------------------------------------------------------------
-- Windows Hook tests - not really working well Only seems to work on Mainhwnd, I think
--   this is because the main windows belongs to this process.
local msgtbl = {}

local function MsgFilter(code, wParam, lParam)
    print(code,wParam,lParam)
    if(code < 0) then 
        return 0
    end 

    local msg = ffi.cast("MSG *", lParam)
    --print( unityhwnd, msg[0].message, msg[0].wparam, msg[0].lparam)

    if(msg[0].message == user32.WM_MOUSEMOVE or msg[0].message == user32.WM_NCMOUSEMOVE) then
        user32.PostMessageA( unityhwnd, msg[0].message, msg[0].wparam, msg[0].lparam)
    end
    table.insert( msgtbl, {hwnd=unityhwnd, msg=code, wparam=wParam, lparam=lParam})
end 

local pid = user32.GetWindowThreadProcessId( wvhwnd or 0, nil )
local hhookSysMsg = user32.SetWindowsHookExA( user32.WH_CALLWNDPROC, MsgFilter, 0, pid)


local SWP_NOZORDER = 0x0004
local SWP_NOACTIVATE = 0x0010
local SWP_ASYNCWINDOWPOS = 0x4000
local SWP_SHOWWINDOW = 0x0040

local function SetWindowPos( hwnd, x, y, width, height )

    user32.SetWindowPos(hwnd, nil, x, y, width, height, bit.bor(SWP_NOZORDER, SWP_ASYNCWINDOWPOS, SWP_NOACTIVATE))
end

------------------------------------------------------------------------------------------------------------

return {
    CreateWindow            = CreateWindow,
    SetWindowPos            = SetWindowPos,

    SetTransparentBlend     = SetTransparentBlend,
    GetHwndFromProcess      = GetHwndFromProcess,
    RemoveWindowBorders     = RemoveWindowBorders,
    WindowsFileSelect       = WindowsFileSelect,
    WindowsFolderSelect     = WindowsFolderSelect,

    execute                 = execute,
    shellexecute =           shellexecute,
    Sleep                   = ffi.C.Sleep,
    GetFile                 = GetFile,

    FindWindowByProcId      = FindWindowByProcId,
    GetAllProcesses         = GetAllProcesses,
    getDefaultBrowser       = getDefaultBrowser,

    kernel  = kernel32,
    user    = user32,
    gdi     = gdi32,
    comdlg  = comdlg32,
}