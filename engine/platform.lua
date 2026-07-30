
local ffi = require("ffi")

win = {}

-- --------------------------------------------------------------------------------------
-- Windows stuff
if ffi.os == "Windows" then
local shell32   = ffi.load("shell32")

-- TODO: Need equivalents for OSX and Linux - probably should go in a systems utils.
ffi.cdef[[
    typedef char CHAR;
    typedef uint8_t BYTE;
    typedef uint32_t UINT;
    typedef unsigned short WORD;
    typedef unsigned long DWORD;
    typedef void* HINSTANCE;
    typedef void* LPARAM;
    typedef const char* LPCSTR;
    typedef char* LPSTR;
    typedef const void * HWND;
    typedef void* LPVOID;
    typedef int BOOL;

    typedef struct RECT {
        int x, y, w, h;
    } RECT;

    typedef struct _ITEMIDLIST {
        BYTE mkid[1];
    } ITEMIDLIST, *LPITEMIDLIST;
    
    typedef int (__stdcall *BFFCALLBACK)(HWND, UINT, LPARAM, LPARAM);
    
    typedef struct {
        HWND        hwndOwner;
        LPCSTR      pidlRoot;
        LPSTR       pszDisplayName;
        LPCSTR      lpszTitle;
        UINT        ulFlags;
        BFFCALLBACK lpfn;
        LPARAM      lParam;
        int         iImage;
    } BROWSEINFOA;   

    typedef struct tagOPENFILENAMEA {
    DWORD        lStructSize;
    HWND         hwndOwner;
    HINSTANCE    hInstance;
    LPCSTR       lpstrFilter;
    LPSTR        lpstrCustomFilter;
    DWORD        nMaxCustFilter;
    DWORD        nFilterIndex;
    LPSTR        lpstrFile;
    DWORD        nMaxFile;
    LPSTR        lpstrFileTitle;
    DWORD        nMaxFileTitle;
    LPCSTR       lpstrInitialDir;
    LPCSTR       lpstrTitle;
    DWORD        Flags;
    WORD         nFileOffset;
    WORD         nFileExtension;
    LPCSTR       lpstrDefExt;
    LPARAM       lCustData;
    void*        lpfnHook;
    LPCSTR       lpTemplateName;
    void*        pvReserved;
    DWORD        dwReserved;
    DWORD        FlagsEx;
    } OPENFILENAMEA;

    bool GetOpenFileNameA(OPENFILENAMEA *ofn);
    
    LPITEMIDLIST SHBrowseForFolderA(BROWSEINFOA *bi);
    BOOL SHGetPathFromIDListA(LPITEMIDLIST pidl, LPSTR pszPath);

    void Sleep(uint32_t ms);

    // Get the size of screen to the variable desktop
    HWND GetDesktopWindow();
    int GetWindowRect(HWND hwnd, RECT *hrect);    
    int ShowWindow(HWND hWnd, int nCmdShow);
    int SetWindowPos( HWND hWnd, int hWndInsertAfter, int X, int Y, int cx, int cy, uint32_t uFlags);
]]

local HWND_TOP          = 0x00 

local SWP_NOSIZE        = 0x01
local SW_SHOWMINIMIZED  = 0x02
local SW_MAXIMIZE       = 0x03

local comdlg32 = ffi.load("comdlg32")
local shell32 = ffi.load("shell32")

win.ShowWindow  = function(hwnd, cmd)
    if(cmd == 0) then
        ffi.C.ShowWindow(hwnd, SW_SHOWMINIMIZED)
    else 
        ffi.C.ShowWindow(hwnd, SW_MAXIMIZE)
    end
end
win.Sleep       = ffi.C.Sleep

win.SetWindowPos = function(hwnd, x, y, w, h) 
    ffi.C.SetWindowPos(hwnd, HWND_TOP, x, y, w, h, 0)
end

win.DetectDisplay = function()
    local desktop = ffi.new("RECT[1]")
    -- Get a handle to the desktop window
    local hDesktop = ffi.C.GetDesktopWindow()
    ffi.C.GetWindowRect(hDesktop, desktop)
    return desktop[0].w, desktop[0].h
end 

win.FileSelect  = function()
    -- buffer for returned file path
    local pathBuf = ffi.new("char[260]")  -- MAX_PATH

    local ofn = ffi.new("OPENFILENAMEA")
    ofn.lStructSize = ffi.sizeof(ofn)
    ofn.hwndOwner = nil
    ofn.lpstrFilter = "All Files\0*.*\0\0"   -- Double null terminated
    ofn.lpstrFile = pathBuf
    ofn.nMaxFile = 260
    ofn.Flags = 0x00080000 + 0x00001000     -- OFN_EXPLORER + OFN_FILEMUSTEXIST

    local result = comdlg32.GetOpenFileNameA(ofn)

    if result then
        pprint("Selected file:", ffi.string(pathBuf))
        return ffi.string(pathBuf)
    else
        pprint("No file selected (or dialog canceled).")
        return nil
    end
end

win.FolderSelect  = function()

    local pathBuf = ffi.new("char[260]")  -- MAX_PATH
    local displayBuf = ffi.new("char[260]")
    
    local bi = ffi.new("BROWSEINFOA")
    bi.hwndOwner = nil
    bi.pidlRoot = nil                     -- start at Desktop
    bi.pszDisplayName = displayBuf
    bi.lpszTitle = "Select a folder:"
    bi.ulFlags = 0x0001 + 0x00000040 + 0x00000100
    
    local pidl = shell32.SHBrowseForFolderA(bi)
    
    if pidl ~= nil then
        if shell32.SHGetPathFromIDListA(pidl, pathBuf) ~= 0 then
            pprint("Selected folder:", ffi.string(pathBuf))
            return ffi.string(pathBuf)
        else
            pprint("Folder picked, but path could not be retrieved.")
            return nil
        end
    else
        pprint("User canceled.")
        return nil
    end
end    

end


-- --------------------------------------------------------------------------------------
-- Linux stuff
if ffi.os == "Linux" then

ffi.cdef[[
typedef unsigned long Colormap;

typedef struct _Screen {
    int width;           /* width of the screen in pixels */
    int height;          /* height of the screen in pixels */
    int mwidth;          /* width of the screen in millimeters */
    int mheight;         /* height of the screen in millimeters */
    int root;            /* the root window of the screen */
    int root_depth;      /* the depth of the root window */
    void *root_visual;   /* the root window visual */
    Colormap default_colormap;  /* the default colormap */
    int white_pixel;     /* white pixel value */
    int black_pixel;     /* black pixel value */
    int my_num;          /* screen number */
    bool is_installed;   /* indicates whether the screen is installed */
    void *saver;         /* screen saver properties (if any) */
} Screen;

typedef unsigned long Atom;
typedef unsigned long Window;
typedef struct _XDisplay Display;
typedef struct _XEvent {
    union {
        struct {
            unsigned long window;
            int type;
            int format;
            Atom message_type;
            long data[5];
        } xclient;
    };
} XEvent;

void usleep(unsigned int usec);

Display* XOpenDisplay(const char* display_name);
Window XRootWindow(Display* display, int screen_number);
int XGetWindowProperty(Display* display, Window w, Atom property, long long_offset,
    long long_length, int delete, Atom req_type, Atom* actual_type,
    int* actual_format, unsigned long* nitems,
    unsigned long* bytes_after, unsigned char** prop);
int XSendEvent(Display* display, Window w, int propagate, long event_mask, XEvent* event);
Atom XInternAtom(Display* display, const char* name, int only_if_exists);
int XCloseDisplay(Display* display);
Screen *DefaultScreenOfDisplay(Display *display);

// Constants
#define AnyPropertyType 0
]]

-- Load the X11 library
local X11 = ffi.load("X11")

win.Sleep       = function(ms) ffi.C.usleep(ms * 1000) end


-- Function to maximize a window
local function maximizeWindow(win)
    -- Open the display
    local display = X11.XOpenDisplay(nil)
    if display == nil then
        error("Unable to open X display")
    end

    -- Create the event structure
    local ev = ffi.new("XEvent[1]")

    -- Set up the event for the window maximize
    ev[0].xclient.window = win
    ev[0].xclient.type = 33  -- ClientMessage event type
    ev[0].xclient.format = 32
    ev[0].xclient.message_type = X11.XInternAtom(display, "_NET_WM_STATE", 0)
    ev[0].xclient.data[0] = 1  -- Set to 1 to indicate we want to add the state
    ev[0].xclient.data[1] = X11.XInternAtom(display, "_NET_WM_STATE_MAXIMIZED_HORIZ", 0)
    ev[0].xclient.data[2] = X11.XInternAtom(display, "_NET_WM_STATE_MAXIMIZED_VERT", 0)
    ev[0].xclient.data[3] = 1  -- 1 means "active" or "add" to the state

    -- Send the event to the root window
    X11.XSendEvent(display, 0, false, 0x00000008, ev)  -- SubstructureNotifyMask
    X11.XCloseDisplay(display)
end

-- --------------------------------------------------------------------------------------
-- TODO: ShowWindow not working properly on Linux yet
win.ShowWindow  = function(hwnd, state)
    -- Open the display
    local display = X11.XOpenDisplay(hwnd)
    if display == nil then
        error("Unable to open X display")
    end

    -- auto display = XOpenDisplay(NULL);
    -- Get the root window (or get the window ID through other methods if needed)
    local root_window = X11.XRootWindow(display, 0)

    -- Example usage: Get the active window and maximize it
    local NET_ACTIVE_WINDOW = X11.XInternAtom(display, "_NET_ACTIVE_WINDOW", 0)
    local prop = ffi.new("unsigned char*[1]")
    local actual_type = ffi.new("Atom[1]")
    local actual_format = ffi.new("int[1]")
    local nitems = ffi.new("unsigned long[1]")
    local bytes_after = ffi.new("unsigned long[1]")

    -- Fetch the active window ID
    local result = X11.XGetWindowProperty(display, root_window, NET_ACTIVE_WINDOW, 0, 1024, 0, 0,
                                        actual_type, actual_format, nitems, bytes_after, prop)

    if result == 0 then  -- Success
        -- Dereference the window ID
        local window_id = ffi.cast("Window", ffi.cast("intptr_t", ffi.cast("void*", prop[0])))

        -- Call the maximizeWindow function
        maximizeWindow(window_id)
        pprint("Window maximized successfully!")

    else
        pprint("Failed to fetch active window.")
    end
    pprint("Window resized successfully.")
end

win.DetectDisplay = function()
    local display = X11.XOpenDisplay(hwnd)
    if display == nil then
        error("Unable to open X display")
    end
    local s = X11.DefaultScreenOfDisplay(display)
    return s.width, s.height
end 

end
