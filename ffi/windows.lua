local ffi   = require( "ffi" )
 
ffi.cdef[[

    typedef char* PCIDLIST_ABSOLUTE;
    typedef char* LPCTSTR;
	typedef char* LPCSTR;
    typedef char* LPTSTR;
	typedef char* LPSTR;
	typedef void* LPVOID;
	typedef uint64_t HANDLE;
	typedef uint64_t HHOOK;
	typedef uint32_t HRESULT;
	
	typedef unsigned __int64 UINT_PTR, *PUINT_PTR;
	typedef __int64 LONG_PTR, *PLONG_PTR;
	typedef UINT_PTR            WPARAM;
	typedef LONG_PTR            LPARAM;

	typedef uint64_t LRESULT;
    typedef uint32_t UINT;
    typedef uint64_t HWND;
    typedef uint32_t DWORD;
	typedef DWORD * LPDWORD;
    typedef uint32_t LONG;
    typedef uint32_t HINSTANCE;
    typedef uint16_t WORD;
	typedef uint32_t COLORREF;
	typedef unsigned char BYTE;

	enum {
		// Use crKey as the transparency color.
		LWA_COLORKEY 	= 0x00000001,
		//Use bAlpha to determine the opacity of the layered window.
		LWA_ALPHA 		= 0x00000002, 
	};

	typedef struct tagRECT
	{
		LONG    left;
		LONG    top;
		LONG    right;
		LONG    bottom;
	} RECT;
	typedef RECT *PRECT;
	typedef RECT *NPRECT;
	typedef RECT *LPRECT;

    typedef struct tagBITMAP {
      LONG   	bmType;
      LONG   	bmWidth;
      LONG   	bmHeight;
      LONG   	bmWidthBytes;
      WORD   	bmPlanes;
      WORD   	bmBitsPixel;
      void * 	bmBits;
    } BITMAP;
    typedef BITMAP *PBITMAP;

    typedef struct tagBITMAPFILEHEADER {
      WORD  	bfType;
      DWORD 	bfSize;
      WORD  	bfReserved1;
      WORD  	bfReserved2;
      DWORD 	bfOffBits;
    } BITMAPFILEHEADER;
    typedef BITMAPFILEHEADER *PBITMAPFILEHEADER;

    typedef struct tagOFN {
      DWORD         lStructSize;
      HWND          hwndOwner;
      HINSTANCE     hInstance;
      LPCTSTR       lpstrFilter;
      LPTSTR        lpstrCustomFilter;
      DWORD         nMaxCustFilter;
      DWORD         nFilterIndex;
      LPTSTR        lpstrFile;
      DWORD         nMaxFile;
      LPTSTR        lpstrFileTitle;
      DWORD         nMaxFileTitle;
      LPCTSTR       lpstrInitialDir;
      LPCTSTR       lpstrTitle;
      DWORD         Flags;
      WORD          nFileOffset;
      WORD          nFileExtension;
      LPCTSTR       lpstrDefExt;
      LPARAM        lCustData;
      HANDLE        lpfnHook;
      LPCTSTR       lpTemplateName;
      void *        pvReserved;
      DWORD         dwReserved;
      DWORD         FlagsEx;
    } OPENFILENAME;
    typedef OPENFILENAME *LPOPENFILENAME;

	typedef int32_t bool32;
	typedef intptr_t (__stdcall *WNDPROC)(HWND hwnd, unsigned int message, uintptr_t wparam, intptr_t lparam);

	enum {
		PROCESS_P_WAIT     				= 0,
		PROCESS_P_NOWAIT    			= 1,
		PROCESS_P_OVERLAY				= 2,
		PROCESS_OLD_P_OVERLAY			= 2,
		PROCESS_P_NOWAITO				= 3,
		PROCESS_P_DETACH				= 4,
		STATUS_PENDING  				= 0x00000103,
		STARTF_USESTDHANDLES 			= 0x00000100,
				
		CS_VREDRAW 						= 0x0001,
		CS_HREDRAW 						= 0x0002,

		WM_DESTROY 						= 0x0002,
		WM_SIZE 						= 0x0005,
		WM_CLOSE 						= 0x0010,
		WM_GETMINMAXINFO				= 0x0024,
		WM_NCHITTEST					= 0x0084,
		
		WM_QUIT                        	= 0x0012,
		WM_ERASEBKGND                  	= 0x0014,
		WM_SYSCOLORCHANGE              	= 0x0015,
		WM_SHOWWINDOW                  	= 0x0018,
		WM_WININICHANGE                	= 0x001A,

		WM_MOUSEFIRST    				= 0x0200,
		WM_MOUSEMOVE     				= 0x0200,
		WM_LBUTTONDOWN   				= 0x0201,
		WM_LBUTTONUP     				= 0x0202,
		WM_LBUTTONDBLCLK 				= 0x0203,
		WM_RBUTTONDOWN   				= 0x0204,
		WM_RBUTTONUP     				= 0x0205,
		WM_RBUTTONDBLCLK 				= 0x0206,
		WM_MBUTTONDOWN   				= 0x0207,
		WM_MBUTTONUP     				= 0x0208,
		WM_MBUTTONDBLCLK 				= 0x0209,
		WM_MOUSEWHEEL    				= 0x020A,

		WM_NCMOUSEMOVE                  = 0x00A0,
		WM_NCLBUTTONDOWN                = 0x00A1,
		WM_NCLBUTTONUP                  = 0x00A2,
		WM_NCLBUTTONDBLCLK              = 0x00A3,
		WM_NCRBUTTONDOWN                = 0x00A4,
		WM_NCRBUTTONUP                  = 0x00A5,
		WM_NCRBUTTONDBLCLK              = 0x00A6,
		WM_NCMBUTTONDOWN                = 0x00A7,
		WM_NCMBUTTONUP                  = 0x00A8,
		WM_NCMBUTTONDBLCLK              = 0x00A9,

		WS_BORDER 		= 0x00800000,
		WS_CAPTION 		= 0x00C00000,
		WS_CHILD 		= 0x40000000,
		WS_CHILDWINDOW 	= 0x40000000,
		WS_CLIPCHILDREN = 0x02000000,
		WS_CLIPSIBLINGS = 0x04000000,
		WS_DISABLED 	= 0x08000000,
		WS_DLGFRAME 	= 0x00400000,
		WS_GROUP 		= 0x00020000,
		WS_HSCROLL 		= 0x00100000,
		WS_ICONIC 		= 0x20000000,
		WS_MAXIMIZE 	= 0x01000000,
		WS_MAXIMIZEBOX 	= 0x00010000,
		WS_MINIMIZE 	= 0x20000000,
		WS_MINIMIZEBOX 	= 0x00020000,
		WS_OVERLAPPED 	= 0x00000000,
		WS_SIZEBOX 		= 0x00040000,
		WS_SYSMENU 		= 0x00080000,
		WS_TABSTOP 		= 0x00010000,
		WS_THICKFRAME 	= 0x00040000,
		WS_TILED 		= 0x00000000,
		WS_VISIBLE 		= 0x10000000,
		WS_VSCROLL 		= 0x00200000,

		WS_EX_DLGMODALFRAME = 0x00000001,
		WS_EX_TOPMOST = 0x00000008,
		WS_EX_TRANSPARENT = 0x00000020,
		WS_EX_TOOLWINDOW = 0x00000080,
		WS_EX_WINDOWEDGE= 0x00000100,
		WS_EX_CLIENTEDGE= 0x00000200,
		WS_EX_APPWINDOW = 0x00040000,
		WS_EX_LAYERED	= 0x00080000,
		WS_EX_STATICEDGE= 0x00200000,

		WS_POPUP = ((int)0x80000000),
		WS_OVERLAPPEDWINDOW = WS_OVERLAPPED | WS_CAPTION | WS_SYSMENU | WS_THICKFRAME | WS_MINIMIZEBOX | WS_MAXIMIZEBOX,
		WS_POPUPWINDOW 	= WS_POPUP | WS_BORDER,
		WS_TILEDWINDOW 	= WS_OVERLAPPED | WS_CAPTION | WS_SYSMENU | WS_THICKFRAME | WS_MINIMIZEBOX | WS_MAXIMIZEBOX,
		WS_SIMPLEWINDOW = WS_POPUP | WS_BORDER| WS_THICKFRAME,

		WS_NOBORDERS	= WS_CAPTION | WS_THICKFRAME | WS_MINIMIZEBOX | WS_MAXIMIZEBOX | WS_SYSMENU,
      		
		WAIT_OBJECT_0 	= 0x00000000,
		PM_NOREMOVE 	= 0x0000,
		PM_REMOVE 		= 0x0001,
		SW_SHOW 		= 5,
		SW_MAXIMIZE		= 3,
		INFINITE 		= 0xFFFFFFFF,
		QS_ALLEVENTS 	= 0x04BF,

		WH_KEYBOARD		= 2,
		WH_GETMESSAGE	= 3,
		WH_CALLWNDPROC  = 4,
		WH_SYSMSGFILTER = 6,
		WH_MOUSE		= 7,
		WH_CALLWNDPROCRET = 12,

		/*
 		* WM_NCHITTEST and MOUSEHOOKSTRUCT Mouse Position Codes
 		*/
		HTERROR         = (-2),
		HTTRANSPARENT   = (-1),
		HTNOWHERE       = 0,
		HTCLIENT        = 1,
		HTCAPTION 		= 2,

		/*
		* Window field offsets for GetWindowLong()
		*/
		GWL_WNDPROC     = (-4),
		GWL_HINSTANCE   = (-6),
		GWL_HWNDPARENT  = (-8),
		GWL_STYLE       = (-16),
		GWL_EXSTYLE     = (-20),
		GWL_USERDATA    = (-21),
		GWL_ID          = (-12),		

		GWLP_WNDPROC	= (-4),

		SWP_NOSIZE 		= 0x0001,
		SWP_NOZORDER	= 0x0004,
		SWP_FRAMECHANGED = 0x0020,

		SEE_MASK_NOCLOSEPROCESS	= 0x00000040,
		SEE_MASK_FLAG_NO_UI		= 0x00000400
	};

	typedef struct _SHELLEXECUTEINFOA {
		DWORD     cbSize;
		uint64_t  fMask;
		HWND      hwnd;
		LPCSTR    lpVerb;
		LPCSTR    lpFile;
		LPCSTR    lpParameters;
		LPCSTR    lpDirectory;
		int       nShow;
		HINSTANCE hInstApp;
		void      *lpIDList;
		LPCSTR    lpClass;
		HANDLE    hkeyClass;
		DWORD     dwHotKey;
		union {
		  HANDLE hIcon;
		  HANDLE hMonitor;
		} DUMMYUNIONNAME;
		HANDLE    hProcess;
	} SHELLEXECUTEINFOA, *LPSHELLEXECUTEINFOA;

    typedef struct _STARTUPINFOA {
        uint32_t    cb;
        void *      lpReserved;
        void *      lpDesktop;
        void *      lpTitle;
        uint32_t    dwX;
        uint32_t    dwY;
        uint32_t    dwXSize;
        uint32_t    dwYSize;
        uint32_t    dwXCountChars;
        uint32_t    dwYCountChars;
        uint32_t    dwFillAttribute;
        uint32_t    dwFlags;
        uint16_t    wShowWindow;
        uint16_t    cbReserved2;
        void *      lpReserved2;
        void *      hStdInput;
        void *      hStdOutput;
        void *      hStdError;
    } STARTUPINFOA, *LPSTARTUPINFOA;

    typedef struct _PROCESS_INFORMATION {
        uint64_t      hProcess;
        uint64_t      hThread;
        uint32_t    dwProcessId;
        uint32_t    dwThreadId;
    } PROCESS_INFORMATION, *LPPROCESS_INFORMATION;

	typedef struct POINT { int32_t x, y; } POINT;

	typedef struct WNDCLASSEXA {
		uint32_t cbSize, style;
		WNDPROC lpfnWndProc;
		int32_t cbClsExtra, cbWndExtra;
		HANDLE hInstance;
		HANDLE hIcon;
		HANDLE hCursor;
		HANDLE hbrBackground;
		const char* lpszMenuName;
		const char* lpszClassName;
		HANDLE hIconSm;
	} WNDCLASSEXA;

	typedef struct MSG {
		HWND hwnd;
		uint32_t message;
		uintptr_t wParam, lParam;
		uint32_t time;
		POINT pt;
	} MSG;

	typedef struct SECURITY_ATTRIBUTES {
		uint32_t nLength;
		void* lpSecurityDescriptor;
		bool32 bInheritHandle;
	} SECURITY_ATTRIBUTES;

    enum {
        CF_TEXT     = 1,
        CF_BITMAP   = 2,
        CF_DIB      = 8
    };

	typedef enum tagCOINIT {
		COINIT_APARTMENTTHREADED = 0x2,
		COINIT_MULTITHREADED = 0x0,
		COINIT_DISABLE_OLE1DDE = 0x4,
		COINIT_SPEED_OVER_MEMORY = 0x8
	} COINIT;	

	typedef enum  {
		ASSOCF_NONE                  = 0x00000000,  
		ASSOCF_INIT_NOREMAPCLSID     = 0x00000001,  
		ASSOCF_INIT_BYEXENAME        = 0x00000002,  
		ASSOCF_OPEN_BYEXENAME        = 0x00000002,  
		ASSOCF_INIT_DEFAULTTOSTAR    = 0x00000004,  
		ASSOCF_INIT_DEFAULTTOFOLDER  = 0x00000008,  
		ASSOCF_NOUSERSETTINGS        = 0x00000010,  
		ASSOCF_NOTRUNCATE            = 0x00000020,  
		ASSOCF_VERIFY                = 0x00000040,  
		ASSOCF_REMAPRUNDLL           = 0x00000080,  
		ASSOCF_NOFIXUPS              = 0x00000100,  
		ASSOCF_IGNOREBASECLASS       = 0x00000200,  
		ASSOCF_INIT_IGNOREUNKNOWN    = 0x00000400,  
		ASSOCF_INIT_FIXED_PROGID     = 0x00000800,  
		ASSOCF_IS_PROTOCOL           = 0x00001000,  
		ASSOCF_INIT_FOR_FILE         = 0x00002000,
		ASSOCF_IS_FULL_URI           = 0x00004000,
		ASSOCF_PER_MACHINE_ONLY      = 0x00008000,
		ASSOCF_APP_TO_APP            = 0x00010000,
	} ASSOCF;

	typedef enum {
		ASSOCSTR_COMMAND = 1,
		ASSOCSTR_EXECUTABLE,
		ASSOCSTR_FRIENDLYDOCNAME,
		ASSOCSTR_FRIENDLYAPPNAME,
		ASSOCSTR_NOOPEN,
		ASSOCSTR_SHELLNEWVALUE,
		ASSOCSTR_DDECOMMAND,
		ASSOCSTR_DDEIFEXEC,
		ASSOCSTR_DDEAPPLICATION,
		ASSOCSTR_DDETOPIC,
		ASSOCSTR_INFOTIP,
		ASSOCSTR_QUICKTIP,
		ASSOCSTR_TILEINFO,
		ASSOCSTR_CONTENTTYPE,
		ASSOCSTR_DEFAULTICON,
		ASSOCSTR_SHELLEXTENSION,
		ASSOCSTR_DROPTARGET,
		ASSOCSTR_DELEGATEEXECUTE,
		ASSOCSTR_SUPPORTED_URI_PROTOCOLS,
		ASSOCSTR_PROGID,
		ASSOCSTR_APPID,
		ASSOCSTR_APPPUBLISHER,
		ASSOCSTR_APPICONREFERENCE,
		ASSOCSTR_MAX
	} ASSOCSTR;

		

	typedef bool32 (*WinEnumWindowsProc)( HWND hwnd, LPARAM lParam );
	typedef LRESULT (* HOOKPROC)(int code, WPARAM wParam, LPARAM lParam);
	typedef LRESULT (* WNDPROC)(HWND hwnd, int code, WPARAM wParam, LPARAM lParam);
	typedef int64_t (* FARPROC)();

    uint32_t _spawnvp(int mode, const char *cmdname, const char *const *argv);
    bool GetExitCodeProcess( uint64_t hProcess, uint32_t * lpExitCode);
    uint32_t WaitForInputIdle(uint64_t hProcess, uint32_t  dwMilliseconds);

    uint32_t CreateProcessA(
        void *,
        const char * commandLine,
        void *,
        void *,
        bool,
        uint32_t,
        void *,
        const char * currentDirectory,
        LPSTARTUPINFOA,
      LPPROCESS_INFORMATION
	);	

	bool32 ShellExecuteExA(SHELLEXECUTEINFOA *pExecInfo);

	bool32 TerminateProcess(HANDLE hProcess, uint32_t   uExitCode);
	bool32 CloseHandle(HANDLE hObject);

	HRESULT CoInitializeEx(LPVOID pvReserved, DWORD  dwCoInit);
	HRESULT AssocQueryStringA(ASSOCF flags, ASSOCSTR str, LPCSTR pszAssoc, LPCSTR pszExtra, LPSTR pszOut, DWORD *pcchOut);

    int         OpenClipboard(HANDLE);
    HANDLE      GetClipboardData(unsigned);
    int         CloseClipboard();
    HANDLE      GlobalLock(HANDLE);
    int         GlobalUnlock(HANDLE);
    size_t      GlobalSize(HANDLE);
    bool32      EmptyClipboard(void);
    bool32      IsClipboardFormatAvailable(uint32_t format);

	HANDLE		GetModuleHandleA(const char* name);
	uint16_t 	RegisterClassExA(const WNDCLASSEXA*);
	intptr_t 	DefWindowProcA(HWND hwnd, uint32_t msg, uintptr_t wparam, uintptr_t lparam);
	void 		PostQuitMessage(int exitCode);
	HANDLE 		LoadIconA(HANDLE hInstance, const char* iconName);
	HANDLE 		LoadCursorA(HANDLE hInstance, const char* cursorName);
	uint32_t 	GetLastError();
	DWORD 		GetWindowThreadProcessId( HWND hWnd, LPDWORD lpdwProcessId );
	bool32 		SetDllDirectoryA( LPCSTR lpPathName );
	DWORD 		GetDllDirectoryA( DWORD nBufferLength, LPSTR lpBuffer);

	HANDLE 		CreateWindowExA(uint32_t exstyle,	const char* classname,	const char* windowname,	int32_t style,	int32_t x, int32_t y, int32_t width, int32_t height, HWND parent_hwnd, HWND hmenu, HANDLE hinstance, void* param);
	bool32 		SetWindowPos(HWND hWnd,int hWndInsertAfter, int X, int Y, int cx, int cy, uint32_t uFlags);
	bool32 		ShowWindow(HWND hwnd, int32_t command);
	bool32 		CloseWindow(HWND hWnd);
	bool32 		UpdateWindow(HWND hwnd);
	HWND 		FindWindowA(const char * lpClassName, const char * lpWindowName );
	bool32 		SetLayeredWindowAttributes(HWND hwnd, COLORREF crKey, BYTE bAlpha,uint32_t dwFlags);
	bool32		UpdateLayeredWindow(HWND hWnd, HANDLE hdcDst, void *pptDst,void *psize, HANDLE hdcSrc, POINT *pptSrc, COLORREF crKey, void *pblend, uint32_t dwFlags);	
	HWND		SetParent( HWND hWndChild, HWND hWndNewParent);
	bool32 		MoveWindow( HWND hWnd, int  X, int  Y, int  nWidth, int  nHeight, bool32 bRepaint);
	LONG 		GetWindowLongA( HWND hWnd,int  nIndex);
	LONG 		SetWindowLongA( HWND hWnd, int  nIndex, LONG dwNewLong);
	bool32 		GetClientRect(HWND hWnd, LPRECT lpRect);
	bool32		EnumWindows( WinEnumWindowsProc lpEnumFunc,LPARAM lParam );
	int 		GetWindowTextA(HWND hWnd, LPSTR lpString, int nMaxCount);
	HWND 		SetFocus(HWND hWnd);
	HHOOK 		SetWindowsHookExA(int idHook, HOOKPROC lpfn, HINSTANCE hmod, DWORD dwThreadId);	
	bool32 		SetProcessDPIAware();
	
	bool32 		PeekMessageA(MSG* out_msg, HWND hwnd, uint32_t filter_min, uint32_t filter_max, uint32_t removalMode);
	bool32 		TranslateMessage(const MSG* msg);
	intptr_t 	DispatchMessageA(const MSG* msg);
	uint32_t	SendMessageA(HWND hWnd, uint32_t Msg, uintptr_t wParam, uintptr_t lParam );	
	uint32_t	PostMessageA(HWND hWnd, uint32_t Msg, uintptr_t wParam, uintptr_t lParam );	
	bool32 		InvalidateRect(HWND hwnd, const RECT*, bool32 erase);
	HANDLE 		CreateEventA(SECURITY_ATTRIBUTES*, bool32 manualReset, bool32 initialState, const char* name);
	uint32_t 	MsgWaitForMultipleObjects(uint32_t count, HANDLE* handles, bool32 waitAll, uint32_t ms, uint32_t wakeMask);
	DWORD 		WaitForSingleObject(HANDLE hHandle, DWORD  dwMilliseconds);
	bool32 		SetEnvironmentVariableA(const char * lpName, const char * lpValue);
	uint32_t	SetWindowLongA(HWND hWnd, int nIndex, uint32_t dwNewLong );
	LONG_PTR 	SetWindowLongPtrA( HWND hWnd, int nIndex, LONG_PTR dwNewLong );
	LRESULT 	CallWindowProcA( WNDPROC lpPrevWndFunc, HWND hWnd, UINT Msg,WPARAM wParam,LPARAM  lParam);
	bool32 		IsWindow(HWND hWnd);
	HWND 		GetDesktopWindow();
	bool32 		GetWindowRect(HWND   hWnd, LPRECT lpRect);

    bool32      GetOpenFileNameA( LPOPENFILENAME lpofn);
    void        keybd_event(uint8_t bVk, uint8_t bScan, uint32_t dwFlags, void * dwExtraInfo);
    void        Sleep(DWORD dwMilliseconds);

    int         GetObjectA(void * hgdiobj, uint32_t cbBuffer, void * lpvObject);
    uint32_t    GetBitmapBits( void * hbmp, uint32_t cbBuffer,void * lpvBits);
]]
