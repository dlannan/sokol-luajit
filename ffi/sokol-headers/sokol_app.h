/*
    sokol_app.h -- cross-platform application wrapper

    Project URL: https://github.com/floooh/sokol

    Do this:
        #define SOKOL_IMPL or
        #define SOKOL_APP_IMPL
    before you include this file in *one* C or C++ file to create the
    implementation.

    In the same place define one of the following to select the 3D-API
    which should be initialized by sokol_app.h (this must also match
    the backend selected for sokol_gfx.h if both are used in the same
    project):

        #define SOKOL_GLCORE
        #define SOKOL_GLES3
        #define SOKOL_D3D11
        #define SOKOL_METAL
        #define SOKOL_WGPU
        #define SOKOL_NOAPI

    Optionally provide the following defines with your own implementations:

        SOKOL_ASSERT(c)             - your own assert macro (default: assert(c))
        SOKOL_UNREACHABLE()         - a guard macro for unreachable code (default: assert(false))
        SOKOL_WIN32_FORCE_MAIN      - define this on Win32 to add a main() entry point
        SOKOL_WIN32_FORCE_WINMAIN   - define this on Win32 to add a WinMain() entry point (enabled by default unless SOKOL_WIN32_FORCE_MAIN or SOKOL_NO_ENTRY is defined)
        SOKOL_NO_ENTRY              - define this if sokol_app.h shouldn't "hijack" the main() function
        SOKOL_APP_API_DECL          - public function declaration prefix (default: extern)
        SOKOL_API_DECL              - same as SOKOL_APP_API_DECL
        SOKOL_API_IMPL              - public function implementation prefix (default: -)

    Optionally define the following to force debug checks and validations
    even in release mode:

        SOKOL_DEBUG         - by default this is defined if _DEBUG is defined

    If sokol_app.h is compiled as a DLL, define the following before
    including the declaration or implementation:

        SOKOL_DLL

    On Windows, SOKOL_DLL will define SOKOL_APP_API_DECL as __declspec(dllexport)
    or __declspec(dllimport) as needed.

    if SOKOL_WIN32_FORCE_MAIN and SOKOL_WIN32_FORCE_WINMAIN are both defined,
    it is up to the developer to define the desired subsystem.

    On Linux, SOKOL_GLCORE can use either GLX or EGL.
    GLX is default, set SOKOL_FORCE_EGL to override.

    For example code, see https://github.com/floooh/sokol-samples/tree/master/sapp

    Portions of the Windows and Linux GL initialization, event-, icon- etc... code
    have been taken from GLFW (http://www.glfw.org/).

    iOS onscreen keyboard support 'inspired' by libgdx.

    Link with the following system libraries:

    - on macOS with Metal: Cocoa, QuartzCore, Metal, MetalKit
    - on macOS with GL: Cocoa, QuartzCore, OpenGL
    - on iOS with Metal: Foundation, UIKit, Metal, MetalKit
    - on iOS with GL: Foundation, UIKit, OpenGLES, GLKit
    - on Linux with EGL: X11, Xi, Xcursor, EGL, GL (or GLESv2), dl, pthread, m(?)
    - on Linux with GLX: X11, Xi, Xcursor, GL, dl, pthread, m(?)
    - on Android: GLESv3, EGL, log, android
    - on Windows with the MSVC or Clang toolchains: no action needed, libs are defined in-source via pragma-comment-lib
    - on Windows with MINGW/MSYS2 gcc: compile with '-mwin32' so that _WIN32 is defined
        - link with the following libs: -lkernel32 -luser32 -lshell32
        - additionally with the GL backend: -lgdi32
        - additionally with the D3D11 backend: -ld3d11 -ldxgi

    On Linux, you also need to use the -pthread compiler and linker option, otherwise weird
    things will happen, see here for details: https://github.com/floooh/sokol/issues/376

    On macOS and iOS, the implementation must be compiled as Objective-C.

    FEATURE OVERVIEW
    ================
    sokol_app.h provides a minimalistic cross-platform API which
    implements the 'application-wrapper' parts of a 3D application:

    - a common application entry function
    - creates a window and 3D-API context/device with a 'default framebuffer'
    - makes the rendered frame visible
    - provides keyboard-, mouse- and low-level touch-events
    - platforms: MacOS, iOS, HTML5, Win32, Linux/RaspberryPi, Android
    - 3D-APIs: Metal, D3D11, GL4.1, GL4.3, GLES3, WebGL, WebGL2, NOAPI

    FEATURE/PLATFORM MATRIX
    =======================
                        | Windows | macOS | Linux |  iOS  | Android |  HTML5
    --------------------+---------+-------+-------+-------+---------+--------
    gl 4.x              | YES     | YES   | YES   | ---   | ---     |  ---
    gles3/webgl2        | ---     | ---   | YES(2)| YES   | YES     |  YES
    metal               | ---     | YES   | ---   | YES   | ---     |  ---
    d3d11               | YES     | ---   | ---   | ---   | ---     |  ---
    noapi               | YES     | TODO  | TODO  | ---   | TODO    |  ---
    KEY_DOWN            | YES     | YES   | YES   | SOME  | TODO    |  YES
    KEY_UP              | YES     | YES   | YES   | SOME  | TODO    |  YES
    CHAR                | YES     | YES   | YES   | YES   | TODO    |  YES
    MOUSE_DOWN          | YES     | YES   | YES   | ---   | ---     |  YES
    MOUSE_UP            | YES     | YES   | YES   | ---   | ---     |  YES
    MOUSE_SCROLL        | YES     | YES   | YES   | ---   | ---     |  YES
    MOUSE_MOVE          | YES     | YES   | YES   | ---   | ---     |  YES
    MOUSE_ENTER         | YES     | YES   | YES   | ---   | ---     |  YES
    MOUSE_LEAVE         | YES     | YES   | YES   | ---   | ---     |  YES
    TOUCHES_BEGAN       | ---     | ---   | ---   | YES   | YES     |  YES
    TOUCHES_MOVED       | ---     | ---   | ---   | YES   | YES     |  YES
    TOUCHES_ENDED       | ---     | ---   | ---   | YES   | YES     |  YES
    TOUCHES_CANCELLED   | ---     | ---   | ---   | YES   | YES     |  YES
    RESIZED             | YES     | YES   | YES   | YES   | YES     |  YES
    ICONIFIED           | YES     | YES   | YES   | ---   | ---     |  ---
    RESTORED            | YES     | YES   | YES   | ---   | ---     |  ---
    FOCUSED             | YES     | YES   | YES   | ---   | ---     |  YES
    UNFOCUSED           | YES     | YES   | YES   | ---   | ---     |  YES
    SUSPENDED           | ---     | ---   | ---   | YES   | YES     |  TODO
    RESUMED             | ---     | ---   | ---   | YES   | YES     |  TODO
    QUIT_REQUESTED      | YES     | YES   | YES   | ---   | ---     |  YES
    IME                 | TODO    | TODO? | TODO  | ???   | TODO    |  ???
    key repeat flag     | YES     | YES   | YES   | ---   | ---     |  YES
    windowed            | YES     | YES   | YES   | ---   | ---     |  YES
    fullscreen          | YES     | YES   | YES   | YES   | YES     |  ---
    mouse hide          | YES     | YES   | YES   | ---   | ---     |  YES
    mouse lock          | YES     | YES   | YES   | ---   | ---     |  YES
    set cursor type     | YES     | YES   | YES   | ---   | ---     |  YES
    screen keyboard     | ---     | ---   | ---   | YES   | TODO    |  YES
    swap interval       | YES     | YES   | YES   | YES   | TODO    |  YES
    high-dpi            | YES     | YES   | TODO  | YES   | YES     |  YES
    clipboard           | YES     | YES   | YES   | ---   | ---     |  YES
    MSAA                | YES     | YES   | YES   | YES   | YES     |  YES
    drag'n'drop         | YES     | YES   | YES   | ---   | ---     |  YES
    window icon         | YES     | YES(1)| YES   | ---   | ---     |  YES

    (1) macOS has no regular window icons, instead the dock icon is changed
    (2) supported with EGL only (not GLX)

    STEP BY STEP
    ============
    --- Add a sokol_main() function to your code which returns a sapp_desc structure
        with initialization parameters and callback function pointers. This
        function is called very early, usually at the start of the
        platform's entry function (e.g. main or WinMain). You should do as
        little as possible here, since the rest of your code might be called
        from another thread (this depends on the platform):

            sapp_desc sokol_main(int argc, char* argv[]) {
                return (sapp_desc) {
                    .width = 640,
                    .height = 480,
                    .init_cb = my_init_func,
                    .frame_cb = my_frame_func,
                    .cleanup_cb = my_cleanup_func,
                    .event_cb = my_event_func,
                    ...
                };
            }

        To get any logging output in case of errors you need to provide a log
        callback. The easiest way is via sokol_log.h:

            #include "sokol_log.h"

            sapp_desc sokol_main(int argc, char* argv[]) {
                return (sapp_desc) {
                    ...
                    .logger.func = slog_func,
                };
            }

        There are many more setup parameters, but these are the most important.
        For a complete list search for the sapp_desc structure declaration
        below.

        DO NOT call any sokol-app function from inside sokol_main(), since
        sokol-app will not be initialized at this point.

        The .width and .height parameters are the preferred size of the 3D
        rendering canvas. The actual size may differ from this depending on
        platform and other circumstances. Also the canvas size may change at
        any time (for instance when the user resizes the application window,
        or rotates the mobile device). You can just keep .width and .height
        zero-initialized to open a default-sized window (what "default-size"
        exactly means is platform-specific, but usually it's a size that covers
        most of, but not all, of the display).

        All provided function callbacks will be called from the same thread,
        but this may be different from the thread where sokol_main() was called.

        .init_cb (void (*)(void))
            This function is called once after the application window,
            3D rendering context and swap chain have been created. The
            function takes no arguments and has no return value.
        .frame_cb (void (*)(void))
            This is the per-frame callback, which is usually called 60
            times per second. This is where your application would update
            most of its state and perform all rendering.
        .cleanup_cb (void (*)(void))
            The cleanup callback is called once right before the application
            quits.
        .event_cb (void (*)(const sapp_event* event))
            The event callback is mainly for input handling, but is also
            used to communicate other types of events to the application. Keep the
            event_cb struct member zero-initialized if your application doesn't require
            event handling.

        As you can see, those 'standard callbacks' don't have a user_data
        argument, so any data that needs to be preserved between callbacks
        must live in global variables. If keeping state in global variables
        is not an option, there's an alternative set of callbacks with
        an additional user_data pointer argument:

        .user_data (void*)
            The user-data argument for the callbacks below
        .init_userdata_cb (void (*)(void* user_data))
        .frame_userdata_cb (void (*)(void* user_data))
        .cleanup_userdata_cb (void (*)(void* user_data))
        .event_userdata_cb (void(*)(const sapp_event* event, void* user_data))

        The function sapp_userdata() can be used to query the user_data
        pointer provided in the sapp_desc struct.

        You can also call sapp_query_desc() to get a copy of the
        original sapp_desc structure.

        NOTE that there's also an alternative compile mode where sokol_app.h
        doesn't "hijack" the main() function. Search below for SOKOL_NO_ENTRY.

    --- Implement the initialization callback function (init_cb), this is called
        once after the rendering surface, 3D API and swap chain have been
        initialized by sokol_app. All sokol-app functions can be called
        from inside the initialization callback, the most useful functions
        at this point are:

        int sapp_width(void)
        int sapp_height(void)
            Returns the current width and height of the default framebuffer in pixels,
            this may change from one frame to the next, and it may be different
            from the initial size provided in the sapp_desc struct.

        float sapp_widthf(void)
        float sapp_heightf(void)
            These are alternatives to sapp_width() and sapp_height() which return
            the default framebuffer size as float values instead of integer. This
            may help to prevent casting back and forth between int and float
            in more strongly typed languages than C and C++.

        double sapp_frame_duration(void)
            Returns the frame duration in seconds averaged over a number of
            frames to smooth out any jittering spikes.

        int sapp_color_format(void)
        int sapp_depth_format(void)
            The color and depth-stencil pixelformats of the default framebuffer,
            as integer values which are compatible with sokol-gfx's
            sg_pixel_format enum (so that they can be plugged directly in places
            where sg_pixel_format is expected). Possible values are:

                23 == SG_PIXELFORMAT_RGBA8
                28 == SG_PIXELFORMAT_BGRA8
                42 == SG_PIXELFORMAT_DEPTH
                43 == SG_PIXELFORMAT_DEPTH_STENCIL

        int sapp_sample_count(void)
            Return the MSAA sample count of the default framebuffer.

        const void* sapp_metal_get_device(void)
        const void* sapp_metal_get_current_drawable(void)
        const void* sapp_metal_get_depth_stencil_texture(void)
        const void* sapp_metal_get_msaa_color_texture(void)
            If the Metal backend has been selected, these functions return pointers
            to various Metal API objects required for rendering, otherwise
            they return a null pointer. These void pointers are actually
            Objective-C ids converted with a (ARC) __bridge cast so that
            the ids can be tunneled through C code. Also note that the returned
            pointers may change from one frame to the next, only the Metal device
            object is guaranteed to stay the same.

        const void* sapp_macos_get_window(void)
            On macOS, get the NSWindow object pointer, otherwise a null pointer.
            Before being used as Objective-C object, the void* must be converted
            back with a (ARC) __bridge cast.

        const void* sapp_ios_get_window(void)
            On iOS, get the UIWindow object pointer, otherwise a null pointer.
            Before being used as Objective-C object, the void* must be converted
            back with a (ARC) __bridge cast.

        const void* sapp_d3d11_get_device(void)
        const void* sapp_d3d11_get_device_context(void)
        const void* sapp_d3d11_get_render_view(void)
        const void* sapp_d3d11_get_resolve_view(void);
        const void* sapp_d3d11_get_depth_stencil_view(void)
            Similar to the sapp_metal_* functions, the sapp_d3d11_* functions
            return pointers to D3D11 API objects required for rendering,
            only if the D3D11 backend has been selected. Otherwise they
            return a null pointer. Note that the returned pointers to the
            render-target-view and depth-stencil-view may change from one
            frame to the next!

        const void* sapp_win32_get_hwnd(void)
            On Windows, get the window's HWND, otherwise a null pointer. The
            HWND has been cast to a void pointer in order to be tunneled
            through code which doesn't include Windows.h.

        const void* sapp_wgpu_get_device(void)
        const void* sapp_wgpu_get_render_view(void)
        const void* sapp_wgpu_get_resolve_view(void)
        const void* sapp_wgpu_get_depth_stencil_view(void)
            These are the WebGPU-specific functions to get the WebGPU
            objects and values required for rendering. If sokol_app.h
            is not compiled with SOKOL_WGPU, these functions return null.

        uint32_t sapp_gl_get_framebuffer(void)
            This returns the 'default framebuffer' of the GL context.
            Typically this will be zero.

        int sapp_gl_get_major_version(void)
        int sapp_gl_get_minor_version(void)
            Returns the major and minor version of the GL context
            (only for SOKOL_GLCORE, all other backends return zero here, including SOKOL_GLES3)

        const void* sapp_android_get_native_activity(void);
            On Android, get the native activity ANativeActivity pointer, otherwise
            a null pointer.

    --- Implement the frame-callback function, this function will be called
        on the same thread as the init callback, but might be on a different
        thread than the sokol_main() function. Note that the size of
        the rendering framebuffer might have changed since the frame callback
        was called last. Call the functions sapp_width() and sapp_height()
        each frame to get the current size.

    --- Optionally implement the event-callback to handle input events.
        sokol-app provides the following type of input events:
            - a 'virtual key' was pressed down or released
            - a single text character was entered (provided as UTF-32 encoded
              UNICODE code point)
            - a mouse button was pressed down or released (left, right, middle)
            - mouse-wheel or 2D scrolling events
            - the mouse was moved
            - the mouse has entered or left the application window boundaries
            - low-level, portable multi-touch events (began, moved, ended, cancelled)
            - the application window was resized, iconified or restored
            - the application was suspended or restored (on mobile platforms)
            - the user or application code has asked to quit the application
            - a string was pasted to the system clipboard
            - one or more files have been dropped onto the application window

        To explicitly 'consume' an event and prevent that the event is
        forwarded for further handling to the operating system, call
        sapp_consume_event() from inside the event handler (NOTE that
        this behaviour is currently only implemented for some HTML5
        events, support for other platforms and event types will
        be added as needed, please open a GitHub ticket and/or provide
        a PR if needed).

        NOTE: Do *not* call any 3D API rendering functions in the event
        callback function, since the 3D API context may not be active when the
        event callback is called (it may work on some platforms and 3D APIs,
        but not others, and the exact behaviour may change between
        sokol-app versions).

    --- Implement the cleanup-callback function, this is called once
        after the user quits the application (see the section
        "APPLICATION QUIT" for detailed information on quitting
        behaviour, and how to intercept a pending quit - for instance to show a
        "Really Quit?" dialog box). Note that the cleanup-callback isn't
        guaranteed to be called on the web and mobile platforms.

    MOUSE CURSOR TYPE AND VISIBILITY
    ================================
    You can show and hide the mouse cursor with

        void sapp_show_mouse(bool show)

    And to get the current shown status:

        bool sapp_mouse_shown(void)

    NOTE that hiding the mouse cursor is different and independent from
    the MOUSE/POINTER LOCK feature which will also hide the mouse pointer when
    active (MOUSE LOCK is described below).

    To change the mouse cursor to one of several predefined types, call
    the function:

        void sapp_set_mouse_cursor(sapp_mouse_cursor cursor)

    Setting the default mouse cursor SAPP_MOUSECURSOR_DEFAULT will restore
    the standard look.

    To get the currently active mouse cursor type, call:

        sapp_mouse_cursor sapp_get_mouse_cursor(void)

    MOUSE LOCK (AKA POINTER LOCK, AKA MOUSE CAPTURE)
    ================================================
    In normal mouse mode, no mouse movement events are reported when the
    mouse leaves the windows client area or hits the screen border (whether
    it's one or the other depends on the platform), and the mouse move events
    (SAPP_EVENTTYPE_MOUSE_MOVE) contain absolute mouse positions in
    framebuffer pixels in the sapp_event items mouse_x and mouse_y, and
    relative movement in framebuffer pixels in the sapp_event items mouse_dx
    and mouse_dy.

    To get continuous mouse movement (also when the mouse leaves the window
    client area or hits the screen border), activate mouse-lock mode
    by calling:

        sapp_lock_mouse(true)

    When mouse lock is activated, the mouse pointer is hidden, the
    reported absolute mouse position (sapp_event.mouse_x/y) appears
    frozen, and the relative mouse movement in sapp_event.mouse_dx/dy
    no longer has a direct relation to framebuffer pixels but instead
    uses "raw mouse input" (what "raw mouse input" exactly means also
    differs by platform).

    To deactivate mouse lock and return to normal mouse mode, call

        sapp_lock_mouse(false)

    And finally, to check if mouse lock is currently active, call

        if (sapp_mouse_locked()) { ... }

    On native platforms, the sapp_lock_mouse() and sapp_mouse_locked()
    functions work as expected (mouse lock is activated or deactivated
    immediately when sapp_lock_mouse() is called, and sapp_mouse_locked()
    also immediately returns the new state after sapp_lock_mouse()
    is called.

    On the web platform, sapp_lock_mouse() and sapp_mouse_locked() behave
    differently, as dictated by the limitations of the HTML5 Pointer Lock API:

        - sapp_lock_mouse(true) can be called at any time, but it will
          only take effect in a 'short-lived input event handler of a specific
          type', meaning when one of the following events happens:
            - SAPP_EVENTTYPE_MOUSE_DOWN
            - SAPP_EVENTTYPE_MOUSE_UP
            - SAPP_EVENTTYPE_MOUSE_SCROLL
            - SAPP_EVENTTYPE_KEY_UP
            - SAPP_EVENTTYPE_KEY_DOWN
        - The mouse lock/unlock action on the web platform is asynchronous,
          this means that sapp_mouse_locked() won't immediately return
          the new status after calling sapp_lock_mouse(), instead the
          reported status will only change when the pointer lock has actually
          been activated or deactivated in the browser.
        - On the web, mouse lock can be deactivated by the user at any time
          by pressing the Esc key. When this happens, sokol_app.h behaves
          the same as if sapp_lock_mouse(false) is called.

    For things like camera manipulation it's most straightforward to lock
    and unlock the mouse right from the sokol_app.h event handler, for
    instance the following code enters and leaves mouse lock when the
    left mouse button is pressed and released, and then uses the relative
    movement information to manipulate a camera (taken from the
    cgltf-sapp.c sample in the sokol-samples repository
    at https://github.com/floooh/sokol-samples):

        static void input(const sapp_event* ev) {
            switch (ev->type) {
                case SAPP_EVENTTYPE_MOUSE_DOWN:
                    if (ev->mouse_button == SAPP_MOUSEBUTTON_LEFT) {
                        sapp_lock_mouse(true);
                    }
                    break;

                case SAPP_EVENTTYPE_MOUSE_UP:
                    if (ev->mouse_button == SAPP_MOUSEBUTTON_LEFT) {
                        sapp_lock_mouse(false);
                    }
                    break;

                case SAPP_EVENTTYPE_MOUSE_MOVE:
                    if (sapp_mouse_locked()) {
                        cam_orbit(&state.camera, ev->mouse_dx * 0.25f, ev->mouse_dy * 0.25f);
                    }
                    break;

                default:
                    break;
            }
        }

    CLIPBOARD SUPPORT
    =================
    Applications can send and receive UTF-8 encoded text data from and to the
    system clipboard. By default, clipboard support is disabled and
    must be enabled at startup via the following sapp_desc struct
    members:

        sapp_desc.enable_clipboard  - set to true to enable clipboard support
        sapp_desc.clipboard_size    - size of the internal clipboard buffer in bytes

    Enabling the clipboard will dynamically allocate a clipboard buffer
    for UTF-8 encoded text data of the requested size in bytes, the default
    size is 8 KBytes. Strings that don't fit into the clipboard buffer
    (including the terminating zero) will be silently clipped, so it's
    important that you provide a big enough clipboard size for your
    use case.

    To send data to the clipboard, call sapp_set_clipboard_string() with
    a pointer to an UTF-8 encoded, null-terminated C-string.

    NOTE that on the HTML5 platform, sapp_set_clipboard_string() must be
    called from inside a 'short-lived event handler', and there are a few
    other HTML5-specific caveats to workaround. You'll basically have to
    tinker until it works in all browsers :/ (maybe the situation will
    improve when all browsers agree on and implement the new
    HTML5 navigator.clipboard API).

    To get data from the clipboard, check for the SAPP_EVENTTYPE_CLIPBOARD_PASTED
    event in your event handler function, and then call sapp_get_clipboard_string()
    to obtain the pasted UTF-8 encoded text.

    NOTE that behaviour of sapp_get_clipboard_string() is slightly different
    depending on platform:

        - on the HTML5 platform, the internal clipboard buffer will only be updated
          right before the SAPP_EVENTTYPE_CLIPBOARD_PASTED event is sent,
          and sapp_get_clipboard_string() will simply return the current content
          of the clipboard buffer
        - on 'native' platforms, the call to sapp_get_clipboard_string() will
          update the internal clipboard buffer with the most recent data
          from the system clipboard

    Portable code should check for the SAPP_EVENTTYPE_CLIPBOARD_PASTED event,
    and then call sapp_get_clipboard_string() right in the event handler.

    The SAPP_EVENTTYPE_CLIPBOARD_PASTED event will be generated by sokol-app
    as follows:

        - on macOS: when the Cmd+V key is pressed down
        - on HTML5: when the browser sends a 'paste' event to the global 'window' object
        - on all other platforms: when the Ctrl+V key is pressed down

    DRAG AND DROP SUPPORT
    =====================
    PLEASE NOTE: the drag'n'drop feature works differently on WASM/HTML5
    and on the native desktop platforms (Win32, Linux and macOS) because
    of security-related restrictions in the HTML5 drag'n'drop API. The
    WASM/HTML5 specifics are described at the end of this documentation
    section:

    Like clipboard support, drag'n'drop support must be explicitly enabled
    at startup in the sapp_desc struct.

        sapp_desc sokol_main(void) {
            return (sapp_desc) {
                .enable_dragndrop = true,   // default is false
                ...
            };
        }

    You can also adjust the maximum number of files that are accepted
    in a drop operation, and the maximum path length in bytes if needed:

        sapp_desc sokol_main(void) {
            return (sapp_desc) {
                .enable_dragndrop = true,               // default is false
                .max_dropped_files = 8,                 // default is 1
                .max_dropped_file_path_length = 8192,   // in bytes, default is 2048
                ...
            };
        }

    When drag'n'drop is enabled, the event callback will be invoked with an
    event of type SAPP_EVENTTYPE_FILES_DROPPED whenever the user drops files on
    the application window.

    After the SAPP_EVENTTYPE_FILES_DROPPED is received, you can query the
    number of dropped files, and their absolute paths by calling separate
    functions:

        void on_event(const sapp_event* ev) {
            if (ev->type == SAPP_EVENTTYPE_FILES_DROPPED) {

                // the mouse position where the drop happened
                float x = ev->mouse_x;
                float y = ev->mouse_y;

                // get the number of files and their paths like this:
                const int num_dropped_files = sapp_get_num_dropped_files();
                for (int i = 0; i < num_dropped_files; i++) {
                    const char* path = sapp_get_dropped_file_path(i);
                    ...
                }
            }
        }

    The returned file paths are UTF-8 encoded strings.

    You can call sapp_get_num_dropped_files() and sapp_get_dropped_file_path()
    anywhere, also outside the event handler callback, but be aware that the
    file path strings will be overwritten with the next drop operation.

    In any case, sapp_get_dropped_file_path() will never return a null pointer,
    instead an empty string "" will be returned if the drag'n'drop feature
    hasn't been enabled, the last drop-operation failed, or the file path index
    is out of range.

    Drag'n'drop caveats:

        - if more files are dropped in a single drop-action
          than sapp_desc.max_dropped_files, the additional
          files will be silently ignored
        - if any of the file paths is longer than
          sapp_desc.max_dropped_file_path_length (in number of bytes, after UTF-8
          encoding) the entire drop operation will be silently ignored (this
          needs some sort of error feedback in the future)
        - no mouse positions are reported while the drag is in
          process, this may change in the future

    Drag'n'drop on HTML5/WASM:

    The HTML5 drag'n'drop API doesn't return file paths, but instead
    black-box 'file objects' which must be used to load the content
    of dropped files. This is the reason why sokol_app.h adds two
    HTML5-specific functions to the drag'n'drop API:

        uint32_t sapp_html5_get_dropped_file_size(int index)
            Returns the size in bytes of a dropped file.

        void sapp_html5_fetch_dropped_file(const sapp_html5_fetch_request* request)
            Asynchronously loads the content of a dropped file into a
            provided memory buffer (which must be big enough to hold
            the file content)

    To start loading the first dropped file after an SAPP_EVENTTYPE_FILES_DROPPED
    event is received:

        sapp_html5_fetch_dropped_file(&(sapp_html5_fetch_request){
            .dropped_file_index = 0,
            .callback = fetch_cb
            .buffer = {
                .ptr = buf,
                .size = sizeof(buf)
            },
            .user_data = ...
        });

    Make sure that the memory pointed to by 'buf' stays valid until the
    callback function is called!

    As result of the asynchronous loading operation (no matter if succeeded or
    failed) the 'fetch_cb' function will be called:

        void fetch_cb(const sapp_html5_fetch_response* response) {
            // IMPORTANT: check if the loading operation actually succeeded:
            if (response->succeeded) {
                // the size of the loaded file:
                const size_t num_bytes = response->data.size;
                // and the pointer to the data (same as 'buf' in the fetch-call):
                const void* ptr = response->data.ptr;
            }
            else {
                // on error check the error code:
                switch (response->error_code) {
                    case SAPP_HTML5_FETCH_ERROR_BUFFER_TOO_SMALL:
                        ...
                        break;
                    case SAPP_HTML5_FETCH_ERROR_OTHER:
                        ...
                        break;
                }
            }
        }

    Check the droptest-sapp example for a real-world example which works
    both on native platforms and the web:

    https://github.com/floooh/sokol-samples/blob/master/sapp/droptest-sapp.c

    HIGH-DPI RENDERING
    ==================
    You can set the sapp_desc.high_dpi flag during initialization to request
    a full-resolution framebuffer on HighDPI displays. The default behaviour
    is sapp_desc.high_dpi=false, this means that the application will
    render to a lower-resolution framebuffer on HighDPI displays and the
    rendered content will be upscaled by the window system composer.

    In a HighDPI scenario, you still request the same window size during
    sokol_main(), but the framebuffer sizes returned by sapp_width()
    and sapp_height() will be scaled up according to the DPI scaling
    ratio.

    Note that on some platforms the DPI scaling factor may change at any
    time (for instance when a window is moved from a high-dpi display
    to a low-dpi display).

    To query the current DPI scaling factor, call the function:

    float sapp_dpi_scale(void);

    For instance on a Retina Mac, returning the following sapp_desc
    struct from sokol_main():

    sapp_desc sokol_main(void) {
        return (sapp_desc) {
            .width = 640,
            .height = 480,
            .high_dpi = true,
            ...
        };
    }

    ...the functions the functions sapp_width(), sapp_height()
    and sapp_dpi_scale() will return the following values:

    sapp_width:     1280
    sapp_height:    960
    sapp_dpi_scale: 2.0

    If the high_dpi flag is false, or you're not running on a Retina display,
    the values would be:

    sapp_width:     640
    sapp_height:    480
    sapp_dpi_scale: 1.0

    If the window is moved from the Retina display to a low-dpi external display,
    the values would change as follows:

    sapp_width:     1280 => 640
    sapp_height:    960  => 480
    sapp_dpi_scale: 2.0  => 1.0

    Currently there is no event associated with a DPI change, but an
    SAPP_EVENTTYPE_RESIZED will be sent as a side effect of the
    framebuffer size changing.

    Per-monitor DPI is currently supported on macOS and Windows.

    APPLICATION QUIT
    ================
    Without special quit handling, a sokol_app.h application will quit
    'gracefully' when the user clicks the window close-button unless a
    platform's application model prevents this (e.g. on web or mobile).
    'Graceful exit' means that the application-provided cleanup callback will
    be called before the application quits.

    On native desktop platforms sokol_app.h provides more control over the
    application-quit-process. It's possible to initiate a 'programmatic quit'
    from the application code, and a quit initiated by the application user can
    be intercepted (for instance to show a custom dialog box).

    This 'programmatic quit protocol' is implemented through 3 functions
    and 1 event:

        - sapp_quit(): This function simply quits the application without
          giving the user a chance to intervene. Usually this might
          be called when the user clicks the 'Ok' button in a 'Really Quit?'
          dialog box
        - sapp_request_quit(): Calling sapp_request_quit() will send the
          event SAPP_EVENTTYPE_QUIT_REQUESTED to the applications event handler
          callback, giving the user code a chance to intervene and cancel the
          pending quit process (for instance to show a 'Really Quit?' dialog
          box). If the event handler callback does nothing, the application
          will be quit as usual. To prevent this, call the function
          sapp_cancel_quit() from inside the event handler.
        - sapp_cancel_quit(): Cancels a pending quit request, either initiated
          by the user clicking the window close button, or programmatically
          by calling sapp_request_quit(). The only place where calling this
          function makes sense is from inside the event handler callback when
          the SAPP_EVENTTYPE_QUIT_REQUESTED event has been received.
        - SAPP_EVENTTYPE_QUIT_REQUESTED: this event is sent when the user
          clicks the window's close button or application code calls the
          sapp_request_quit() function. The event handler callback code can handle
          this event by calling sapp_cancel_quit() to cancel the quit.
          If the event is ignored, the application will quit as usual.

    On the web platform, the quit behaviour differs from native platforms,
    because of web-specific restrictions:

    A `programmatic quit` initiated by calling sapp_quit() or
    sapp_request_quit() will work as described above: the cleanup callback is
    called, platform-specific cleanup is performed (on the web
    this means that JS event handlers are unregistered), and then
    the request-animation-loop will be exited. However that's all. The
    web page itself will continue to exist (e.g. it's not possible to
    programmatically close the browser tab).

    On the web it's also not possible to run custom code when the user
    closes a browser tab, so it's not possible to prevent this with a
    fancy custom dialog box.

    Instead the standard "Leave Site?" dialog box can be activated (or
    deactivated) with the following function:

        sapp_html5_ask_leave_site(bool ask);

    The initial state of the associated internal flag can be provided
    at startup via sapp_desc.html5_ask_leave_site.

    This feature should only be used sparingly in critical situations - for
    instance when the user would loose data - since popping up modal dialog
    boxes is considered quite rude in the web world. Note that there's no way
    to customize the content of this dialog box or run any code as a result
    of the user's decision. Also note that the user must have interacted with
    the site before the dialog box will appear. These are all security measures
    to prevent fishing.

    The Dear ImGui HighDPI sample contains example code of how to
    implement a 'Really Quit?' dialog box with Dear ImGui (native desktop
    platforms only), and for showing the hardwired "Leave Site?" dialog box
    when running on the web platform:

        https://floooh.github.io/sokol-html5/wasm/imgui-highdpi-sapp.html

    FULLSCREEN
    ==========
    If the sapp_desc.fullscreen flag is true, sokol-app will try to create
    a fullscreen window on platforms with a 'proper' window system
    (mobile devices will always use fullscreen). The implementation details
    depend on the target platform, in general sokol-app will use a
    'soft approach' which doesn't interfere too much with the platform's
    window system (for instance borderless fullscreen window instead of
    a 'real' fullscreen mode). Such details might change over time
    as sokol-app is adapted for different needs.

    The most important effect of fullscreen mode to keep in mind is that
    the requested canvas width and height will be ignored for the initial
    window size, calling sapp_width() and sapp_height() will instead return
    the resolution of the fullscreen canvas (however the provided size
    might still be used for the non-fullscreen window, in case the user can
    switch back from fullscreen- to windowed-mode).

    To toggle fullscreen mode programmatically, call sapp_toggle_fullscreen().

    To check if the application window is currently in fullscreen mode,
    call sapp_is_fullscreen().

    WINDOW ICON SUPPORT
    ===================
    Some sokol_app.h backends allow to change the window icon programmatically:

        - on Win32: the small icon in the window's title bar, and the
          bigger icon in the task bar
        - on Linux: highly dependent on the used window manager, but usually
          the window's title bar icon and/or the task bar icon
        - on HTML5: the favicon shown in the page's browser tab
        - on macOS: the application icon shown in the dock, but only
          for currently running applications

    NOTE that it is not possible to set the actual application icon which is
    displayed by the operating system on the desktop or 'home screen'. Those
    icons must be provided 'traditionally' through operating-system-specific
    resources which are associated with the application (sokol_app.h might
    later support setting the window icon from platform specific resource data
    though).

    There are two ways to set the window icon:

        - at application start in the sokol_main() function by initializing
          the sapp_desc.icon nested struct
        - or later by calling the function sapp_set_icon()

    As a convenient shortcut, sokol_app.h comes with a builtin default-icon
    (a rainbow-colored 'S', which at least looks a bit better than the Windows
    default icon for applications), which can be activated like this:

    At startup in sokol_main():

        sapp_desc sokol_main(...) {
            return (sapp_desc){
                ...
                icon.sokol_default = true
            };
        }

    Or later by calling:

        sapp_set_icon(&(sapp_icon_desc){ .sokol_default = true });

    NOTE that a completely zero-initialized sapp_icon_desc struct will not
    update the window icon in any way. This is an 'escape hatch' so that you
    can handle the window icon update yourself (or if you do this already,
    sokol_app.h won't get in your way, in this case just leave the
    sapp_desc.icon struct zero-initialized).

    Providing your own icon images works exactly like in GLFW (down to the
    data format):

    You provide one or more 'candidate images' in different sizes, and the
    sokol_app.h platform backends pick the best match for the specific backend
    and icon type.

    For each candidate image, you need to provide:

        - the width in pixels
        - the height in pixels
        - and the actual pixel data in RGBA8 pixel format (e.g. 0xFFCC8844
          on a little-endian CPU means: alpha=0xFF, blue=0xCC, green=0x88, red=0x44)

    For instance, if you have 3 candidate images (small, medium, big) of
    sizes 16x16, 32x32 and 64x64 the corresponding sapp_icon_desc struct is setup
    like this:

        // the actual pixel data (RGBA8, origin top-left)
        const uint32_t small[16][16]  = { ... };
        const uint32_t medium[32][32] = { ... };
        const uint32_t big[64][64]    = { ... };

        const sapp_icon_desc icon_desc = {
            .images = {
                { .width = 16, .height = 16, .pixels = SAPP_RANGE(small) },
                { .width = 32, .height = 32, .pixels = SAPP_RANGE(medium) },
                // ...or without the SAPP_RANGE helper macro:
                { .width = 64, .height = 64, .pixels = { .ptr=big, .size=sizeof(big) } }
            }
        };

    An sapp_icon_desc struct initialized like this can then either be applied
    at application start in sokol_main:

        sapp_desc sokol_main(...) {
            return (sapp_desc){
                ...
                icon = icon_desc
            };
        }

    ...or later by calling sapp_set_icon():

        sapp_set_icon(&icon_desc);

    Some window icon caveats:

        - once the window icon has been updated, there's no way to go back to
          the platform's default icon, this is because some platforms (Linux
          and HTML5) don't switch the icon visual back to the default even if
          the custom icon is deleted or removed
        - on HTML5, if the sokol_app.h icon doesn't show up in the browser
          tab, check that there's no traditional favicon 'link' element
          is defined in the page's index.html, sokol_app.h will only
          append a new favicon link element, but not delete any manually
          defined favicon in the page

    For an example and test of the window icon feature, check out the
    'icon-sapp' sample on the sokol-samples git repository.

    ONSCREEN KEYBOARD
    =================
    On some platforms which don't provide a physical keyboard, sokol-app
    can display the platform's integrated onscreen keyboard for text
    input. To request that the onscreen keyboard is shown, call

        sapp_show_keyboard(true);

    Likewise, to hide the keyboard call:

        sapp_show_keyboard(false);

    Note that onscreen keyboard functionality is no longer supported
    on the browser platform (the previous hacks and workarounds to make browser
    keyboards work for on web applications that don't use HTML UIs
    never really worked across browsers).

    INPUT EVENT BUBBLING ON THE WEB PLATFORM
    ========================================
    By default, input event bubbling on the web platform is configured in
    a way that makes the most sense for 'full-canvas' apps that cover the
    entire browser client window area:

    - mouse, touch and wheel events do not bubble up, this prevents various
      ugly side events, like:
        - HTML text overlays being selected on double- or triple-click into
          the canvas
        - 'scroll bumping' even when the canvas covers the entire client area
    - key_up/down events for 'character keys' *do* bubble up (otherwise
      the browser will not generate UNICODE character events)
    - all other key events *do not* bubble up by default (this prevents side effects
      like F1 opening help, or F7 starting 'caret browsing')
    - character events do not bubble up (although I haven't noticed any side effects
      otherwise)

    Event bubbling can be enabled for input event categories during initialization
    in the sapp_desc struct:

        sapp_desc sokol_main(int argc, char* argv[]) {
            return (sapp_desc){
                //...
                .html5_bubble_mouse_events = true,
                .html5_bubble_touch_events = true,
                .html5_bubble_wheel_events = true,
                .html5_bubble_key_events = true,
                .html5_bubble_char_events = true,
            };
        }

    This basically opens the floodgates and lets *all* input events bubble up to the browser.

    To prevent individual events from bubbling, call sapp_consume_event() from within
    the sokol_app.h event callback when that specific event is reported.


    SETTING THE CANVAS OBJECT ON THE WEB PLATFORM
    =============================================
    On the web, sokol_app.h and the Emscripten SDK functions need to find
    the WebGL/WebGPU canvas intended for rendering and attaching event
    handlers. This can happen in four ways:

    1. do nothing and just set the id of the canvas object to 'canvas' (preferred)
    2. via a CSS Selector string (preferred)
    3. by setting the `Module.canvas` property to the canvas object
    4. by adding the canvas object to the global variable `specialHTMLTargets[]`
       (this is a special variable used by the Emscripten runtime to lookup
       event target objects for which document.querySelector() cannot be used)

    The easiest way is to just name your canvas object 'canvas':

        <canvas id="canvas" ...></canvas>

    This works because the default css selector string used by sokol_app.h
    is '#canvas'.

    If you name your canvas differently, you need to communicate that name to
    sokol_app.h via `sapp_desc.html5_canvas_selector` as a regular css selector
    string that's compatible with `document.querySelector()`. E.g. if your canvas
    object looks like this:

        <canvas id="bla" ...></canvas>

    The `sapp_desc.html5_canvas_selector` string must be set to '#bla':

        .html5_canvas_selector = "#bla"

    If the canvas object cannot be looked up via `document.querySelector()` you
    need to use one of the alternative methods, both involve the special
    Emscripten runtime `Module` object which is usually setup in the index.html
    like this before the WASM blob is loaded and instantiated:

        <script type='text/javascript'>
            var Module = {
                // ...
            };
        </script>

    The first option is to set the `Module.canvas` property to your canvas object:

        <script type='text/javascript'>
            var Module = {
                canvas: my_canvas_object,
            };
        </script>

    When sokol_app.h initializes, it will check the global Module object whether
    a `Module.canvas` property exists and is an object. This method will add
    a new entry to the `specialHTMLTargets[]` object

    The other option is to add the canvas under a name chosen by you to the
    special `specialHTMLTargets[]` map, which is used by the Emscripten runtime
    to lookup 'event target objects' which are not visible to `document.querySelector()`.
    Note that `specialHTMLTargets[]` must be updated after the Emscripten runtime
    has started but before the WASM code is running. A good place for this is
    the special `Module.preRun` array in index.html:

        <script type='text/javascript'>
            var Module = {
                preRun: [
                    () => {
                        specialHTMLTargets['my_canvas'] = my_canvas_object;
                    }
                ],
            };
        </script>

    In that case, pass the same string to sokol_app.h which is used as key
    in the specialHTMLTargets[] map:

        .html5_canvas_selector = "my_canvas"

    If sokol_app.h can't find your canvas for some reason check for warning
    messages on the browser console.


    OPTIONAL: DON'T HIJACK main() (#define SOKOL_NO_ENTRY)
    ======================================================
    NOTE: SOKOL_NO_ENTRY and sapp_run() is currently not supported on Android.

    In its default configuration, sokol_app.h "hijacks" the platform's
    standard main() function. This was done because different platforms
    have different entry point conventions which are not compatible with
    C's main() (for instance WinMain on Windows has completely different
    arguments). However, this "main hijacking" posed a problem for
    usage scenarios like integrating sokol_app.h with other languages than
    C or C++, so an alternative SOKOL_NO_ENTRY mode has been added
    in which the user code provides the platform's main function:

    - define SOKOL_NO_ENTRY before including the sokol_app.h implementation
    - do *not* provide a sokol_main() function
    - instead provide the standard main() function of the platform
    - from the main function, call the function ```sapp_run()``` which
      takes a pointer to an ```sapp_desc``` structure.
    - from here on```sapp_run()``` takes over control and calls the provided
      init-, frame-, event- and cleanup-callbacks just like in the default model.

    sapp_run() behaves differently across platforms:

        - on some platforms, sapp_run() will return when the application quits
        - on other platforms, sapp_run() will never return, even when the
          application quits (the operating system is free to simply terminate
          the application at any time)
        - on Emscripten specifically, sapp_run() will return immediately while
          the frame callback keeps being called

    This different behaviour of sapp_run() essentially means that there shouldn't
    be any code *after* sapp_run(), because that may either never be called, or in
    case of Emscripten will be called at an unexpected time (at application start).

    An application also should not depend on the cleanup-callback being called
    when cross-platform compatibility is required.

    Since sapp_run() returns immediately on Emscripten you shouldn't activate
    the 'EXIT_RUNTIME' linker option (this is disabled by default when compiling
    for the browser target), since the C/C++ exit runtime would be called immediately at
    application start, causing any global objects to be destroyed and global
    variables to be zeroed.

    WINDOWS CONSOLE OUTPUT
    ======================
    On Windows, regular windowed applications don't show any stdout/stderr text
    output, which can be a bit of a hassle for printf() debugging or generally
    logging text to the console. Also, console output by default uses a local
    codepage setting and thus international UTF-8 encoded text is printed
    as garbage.

    To help with these issues, sokol_app.h can be configured at startup
    via the following Windows-specific sapp_desc flags:

        sapp_desc.win32_console_utf8 (default: false)
            When set to true, the output console codepage will be switched
            to UTF-8 (and restored to the original codepage on exit)

        sapp_desc.win32_console_attach (default: false)
            When set to true, stdout and stderr will be attached to the
            console of the parent process (if the parent process actually
            has a console). This means that if the application was started
            in a command line window, stdout and stderr output will be printed
            to the terminal, just like a regular command line program. But if
            the application is started via double-click, it will behave like
            a regular UI application, and stdout/stderr will not be visible.

        sapp_desc.win32_console_create (default: false)
            When set to true, a new console window will be created and
            stdout/stderr will be redirected to that console window. It
            doesn't matter if the application is started from the command
            line or via double-click.

    MEMORY ALLOCATION OVERRIDE
    ==========================
    You can override the memory allocation functions at initialization time
    like this:

        void* my_alloc(size_t size, void* user_data) {
            return malloc(size);
        }

        void my_free(void* ptr, void* user_data) {
            free(ptr);
        }

        sapp_desc sokol_main(int argc, char* argv[]) {
            return (sapp_desc){
                // ...
                .allocator = {
                    .alloc_fn = my_alloc,
                    .free_fn = my_free,
                    .user_data = ...,
                }
            };
        }

    If no overrides are provided, malloc and free will be used.

    This only affects memory allocation calls done by sokol_app.h
    itself though, not any allocations in OS libraries.


    ERROR REPORTING AND LOGGING
    ===========================
    To get any logging information at all you need to provide a logging callback in the setup call
    the easiest way is to use sokol_log.h:

        #include "sokol_log.h"

        sapp_desc sokol_main(int argc, char* argv[]) {
            return (sapp_desc) {
                ...
                .logger.func = slog_func,
            };
        }

    To override logging with your own callback, first write a logging function like this:

        void my_log(const char* tag,                // e.g. 'sapp'
                    uint32_t log_level,             // 0=panic, 1=error, 2=warn, 3=info
                    uint32_t log_item_id,           // SAPP_LOGITEM_*
                    const char* message_or_null,    // a message string, may be nullptr in release mode
                    uint32_t line_nr,               // line number in sokol_app.h
                    const char* filename_or_null,   // source filename, may be nullptr in release mode
                    void* user_data)
        {
            ...
        }

    ...and then setup sokol-app like this:

        sapp_desc sokol_main(int argc, char* argv[]) {
            return (sapp_desc) {
                ...
                .logger = {
                    .func = my_log,
                    .user_data = my_user_data,
                }
            };
        }

    The provided logging function must be reentrant (e.g. be callable from
    different threads).

    If you don't want to provide your own custom logger it is highly recommended to use
    the standard logger in sokol_log.h instead, otherwise you won't see any warnings or
    errors.

    TEMP NOTE DUMP
    ==============
    - sapp_desc needs a bool whether to initialize depth-stencil surface
    - the Android implementation calls cleanup_cb() and destroys the egl context in onDestroy
      at the latest but should do it earlier, in onStop, as an app is "killable" after onStop
      on Android Honeycomb and later (it can't be done at the moment as the app may be started
      again after onStop and the sokol lifecycle does not yet handle context teardown/bringup)


    LICENSE
    =======
    zlib/libpng license

    Copyright (c) 2018 Andre Weissflog

    This software is provided 'as-is', without any express or implied warranty.
    In no event will the authors be held liable for any damages arising from the
    use of this software.

    Permission is granted to anyone to use this software for any purpose,
    including commercial applications, and to alter it and redistribute it
    freely, subject to the following restrictions:

        1. The origin of this software must not be misrepresented; you must not
        claim that you wrote the original software. If you use this software in a
        product, an acknowledgment in the product documentation would be
        appreciated but is not required.

        2. Altered source versions must be plainly marked as such, and must not
        be misrepresented as being the original software.

        3. This notice may not be removed or altered from any source
        distribution.
*/
#define SOKOL_APP_INCLUDED (1)
#define SOKOL_API_DECL
#define SOKOL_APP_API_DECL SOKOL_API_DECL

/* misc constants */
enum {
    SAPP_MAX_TOUCHPOINTS = 8,
    SAPP_MAX_MOUSEBUTTONS = 3,
    SAPP_MAX_KEYCODES = 512,
    SAPP_MAX_ICONIMAGES = 8,
};

/*
    sapp_event_type

    The type of event that's passed to the event handler callback
    in the sapp_event.type field. These are not just "traditional"
    input events, but also notify the application about state changes
    or other user-invoked actions.
*/
typedef enum sapp_event_type {
    SAPP_EVENTTYPE_INVALID,
    SAPP_EVENTTYPE_KEY_DOWN,
    SAPP_EVENTTYPE_KEY_UP,
    SAPP_EVENTTYPE_CHAR,
    SAPP_EVENTTYPE_MOUSE_DOWN,
    SAPP_EVENTTYPE_MOUSE_UP,
    SAPP_EVENTTYPE_MOUSE_SCROLL,
    SAPP_EVENTTYPE_MOUSE_MOVE,
    SAPP_EVENTTYPE_MOUSE_ENTER,
    SAPP_EVENTTYPE_MOUSE_LEAVE,
    SAPP_EVENTTYPE_TOUCHES_BEGAN,
    SAPP_EVENTTYPE_TOUCHES_MOVED,
    SAPP_EVENTTYPE_TOUCHES_ENDED,
    SAPP_EVENTTYPE_TOUCHES_CANCELLED,
    SAPP_EVENTTYPE_RESIZED,
    SAPP_EVENTTYPE_ICONIFIED,
    SAPP_EVENTTYPE_RESTORED,
    SAPP_EVENTTYPE_FOCUSED,
    SAPP_EVENTTYPE_UNFOCUSED,
    SAPP_EVENTTYPE_SUSPENDED,
    SAPP_EVENTTYPE_RESUMED,
    SAPP_EVENTTYPE_QUIT_REQUESTED,
    SAPP_EVENTTYPE_CLIPBOARD_PASTED,
    SAPP_EVENTTYPE_FILES_DROPPED,
    _SAPP_EVENTTYPE_NUM,
    _SAPP_EVENTTYPE_FORCE_U32 = 0x7FFFFFFF
} sapp_event_type;

/*
    sapp_keycode

    The 'virtual keycode' of a KEY_DOWN or KEY_UP event in the
    struct field sapp_event.key_code.

    Note that the keycode values are identical with GLFW.
*/
typedef enum sapp_keycode {
    SAPP_KEYCODE_INVALID          = 0,
    SAPP_KEYCODE_SPACE            = 32,
    SAPP_KEYCODE_APOSTROPHE       = 39,  /* ' */
    SAPP_KEYCODE_COMMA            = 44,  /* , */
    SAPP_KEYCODE_MINUS            = 45,  /* - */
    SAPP_KEYCODE_PERIOD           = 46,  /* . */
    SAPP_KEYCODE_SLASH            = 47,  /* / */
    SAPP_KEYCODE_0                = 48,
    SAPP_KEYCODE_1                = 49,
    SAPP_KEYCODE_2                = 50,
    SAPP_KEYCODE_3                = 51,
    SAPP_KEYCODE_4                = 52,
    SAPP_KEYCODE_5                = 53,
    SAPP_KEYCODE_6                = 54,
    SAPP_KEYCODE_7                = 55,
    SAPP_KEYCODE_8                = 56,
    SAPP_KEYCODE_9                = 57,
    SAPP_KEYCODE_SEMICOLON        = 59,  /* ; */
    SAPP_KEYCODE_EQUAL            = 61,  /* = */
    SAPP_KEYCODE_A                = 65,
    SAPP_KEYCODE_B                = 66,
    SAPP_KEYCODE_C                = 67,
    SAPP_KEYCODE_D                = 68,
    SAPP_KEYCODE_E                = 69,
    SAPP_KEYCODE_F                = 70,
    SAPP_KEYCODE_G                = 71,
    SAPP_KEYCODE_H                = 72,
    SAPP_KEYCODE_I                = 73,
    SAPP_KEYCODE_J                = 74,
    SAPP_KEYCODE_K                = 75,
    SAPP_KEYCODE_L                = 76,
    SAPP_KEYCODE_M                = 77,
    SAPP_KEYCODE_N                = 78,
    SAPP_KEYCODE_O                = 79,
    SAPP_KEYCODE_P                = 80,
    SAPP_KEYCODE_Q                = 81,
    SAPP_KEYCODE_R                = 82,
    SAPP_KEYCODE_S                = 83,
    SAPP_KEYCODE_T                = 84,
    SAPP_KEYCODE_U                = 85,
    SAPP_KEYCODE_V                = 86,
    SAPP_KEYCODE_W                = 87,
    SAPP_KEYCODE_X                = 88,
    SAPP_KEYCODE_Y                = 89,
    SAPP_KEYCODE_Z                = 90,
    SAPP_KEYCODE_LEFT_BRACKET     = 91,  /* [ */
    SAPP_KEYCODE_BACKSLASH        = 92,  /* \ */
    SAPP_KEYCODE_RIGHT_BRACKET    = 93,  /* ] */
    SAPP_KEYCODE_GRAVE_ACCENT     = 96,  /* ` */
    SAPP_KEYCODE_WORLD_1          = 161, /* non-US #1 */
    SAPP_KEYCODE_WORLD_2          = 162, /* non-US #2 */
    SAPP_KEYCODE_ESCAPE           = 256,
    SAPP_KEYCODE_ENTER            = 257,
    SAPP_KEYCODE_TAB              = 258,
    SAPP_KEYCODE_BACKSPACE        = 259,
    SAPP_KEYCODE_INSERT           = 260,
    SAPP_KEYCODE_DELETE           = 261,
    SAPP_KEYCODE_RIGHT            = 262,
    SAPP_KEYCODE_LEFT             = 263,
    SAPP_KEYCODE_DOWN             = 264,
    SAPP_KEYCODE_UP               = 265,
    SAPP_KEYCODE_PAGE_UP          = 266,
    SAPP_KEYCODE_PAGE_DOWN        = 267,
    SAPP_KEYCODE_HOME             = 268,
    SAPP_KEYCODE_END              = 269,
    SAPP_KEYCODE_CAPS_LOCK        = 280,
    SAPP_KEYCODE_SCROLL_LOCK      = 281,
    SAPP_KEYCODE_NUM_LOCK         = 282,
    SAPP_KEYCODE_PRINT_SCREEN     = 283,
    SAPP_KEYCODE_PAUSE            = 284,
    SAPP_KEYCODE_F1               = 290,
    SAPP_KEYCODE_F2               = 291,
    SAPP_KEYCODE_F3               = 292,
    SAPP_KEYCODE_F4               = 293,
    SAPP_KEYCODE_F5               = 294,
    SAPP_KEYCODE_F6               = 295,
    SAPP_KEYCODE_F7               = 296,
    SAPP_KEYCODE_F8               = 297,
    SAPP_KEYCODE_F9               = 298,
    SAPP_KEYCODE_F10              = 299,
    SAPP_KEYCODE_F11              = 300,
    SAPP_KEYCODE_F12              = 301,
    SAPP_KEYCODE_F13              = 302,
    SAPP_KEYCODE_F14              = 303,
    SAPP_KEYCODE_F15              = 304,
    SAPP_KEYCODE_F16              = 305,
    SAPP_KEYCODE_F17              = 306,
    SAPP_KEYCODE_F18              = 307,
    SAPP_KEYCODE_F19              = 308,
    SAPP_KEYCODE_F20              = 309,
    SAPP_KEYCODE_F21              = 310,
    SAPP_KEYCODE_F22              = 311,
    SAPP_KEYCODE_F23              = 312,
    SAPP_KEYCODE_F24              = 313,
    SAPP_KEYCODE_F25              = 314,
    SAPP_KEYCODE_KP_0             = 320,
    SAPP_KEYCODE_KP_1             = 321,
    SAPP_KEYCODE_KP_2             = 322,
    SAPP_KEYCODE_KP_3             = 323,
    SAPP_KEYCODE_KP_4             = 324,
    SAPP_KEYCODE_KP_5             = 325,
    SAPP_KEYCODE_KP_6             = 326,
    SAPP_KEYCODE_KP_7             = 327,
    SAPP_KEYCODE_KP_8             = 328,
    SAPP_KEYCODE_KP_9             = 329,
    SAPP_KEYCODE_KP_DECIMAL       = 330,
    SAPP_KEYCODE_KP_DIVIDE        = 331,
    SAPP_KEYCODE_KP_MULTIPLY      = 332,
    SAPP_KEYCODE_KP_SUBTRACT      = 333,
    SAPP_KEYCODE_KP_ADD           = 334,
    SAPP_KEYCODE_KP_ENTER         = 335,
    SAPP_KEYCODE_KP_EQUAL         = 336,
    SAPP_KEYCODE_LEFT_SHIFT       = 340,
    SAPP_KEYCODE_LEFT_CONTROL     = 341,
    SAPP_KEYCODE_LEFT_ALT         = 342,
    SAPP_KEYCODE_LEFT_SUPER       = 343,
    SAPP_KEYCODE_RIGHT_SHIFT      = 344,
    SAPP_KEYCODE_RIGHT_CONTROL    = 345,
    SAPP_KEYCODE_RIGHT_ALT        = 346,
    SAPP_KEYCODE_RIGHT_SUPER      = 347,
    SAPP_KEYCODE_MENU             = 348,
} sapp_keycode;

/*
    Android specific 'tool type' enum for touch events. This lets the
    application check what type of input device was used for
    touch events.

    NOTE: the values must remain in sync with the corresponding
    Android SDK type, so don't change those.

    See https://developer.android.com/reference/android/view/MotionEvent#TOOL_TYPE_UNKNOWN
*/
typedef enum sapp_android_tooltype {
    SAPP_ANDROIDTOOLTYPE_UNKNOWN = 0,   // TOOL_TYPE_UNKNOWN
    SAPP_ANDROIDTOOLTYPE_FINGER = 1,    // TOOL_TYPE_FINGER
    SAPP_ANDROIDTOOLTYPE_STYLUS = 2,    // TOOL_TYPE_STYLUS
    SAPP_ANDROIDTOOLTYPE_MOUSE = 3,     // TOOL_TYPE_MOUSE
} sapp_android_tooltype;

/*
    sapp_touchpoint

    Describes a single touchpoint in a multitouch event (TOUCHES_BEGAN,
    TOUCHES_MOVED, TOUCHES_ENDED).

    Touch points are stored in the nested array sapp_event.touches[],
    and the number of touches is stored in sapp_event.num_touches.
*/
typedef struct sapp_touchpoint {
    uintptr_t identifier;
    float pos_x;
    float pos_y;
    sapp_android_tooltype android_tooltype; // only valid on Android
    bool changed;
} sapp_touchpoint;

/*
    sapp_mousebutton

    The currently pressed mouse button in the events MOUSE_DOWN
    and MOUSE_UP, stored in the struct field sapp_event.mouse_button.
*/
typedef enum sapp_mousebutton {
    SAPP_MOUSEBUTTON_LEFT = 0x0,
    SAPP_MOUSEBUTTON_RIGHT = 0x1,
    SAPP_MOUSEBUTTON_MIDDLE = 0x2,
    SAPP_MOUSEBUTTON_INVALID = 0x100,
} sapp_mousebutton;

/*
    These are currently pressed modifier keys (and mouse buttons) which are
    passed in the event struct field sapp_event.modifiers.
*/
enum {
    SAPP_MODIFIER_SHIFT = 0x1,      // left or right shift key
    SAPP_MODIFIER_CTRL  = 0x2,      // left or right control key
    SAPP_MODIFIER_ALT   = 0x4,      // left or right alt key
    SAPP_MODIFIER_SUPER = 0x8,      // left or right 'super' key
    SAPP_MODIFIER_LMB   = 0x100,    // left mouse button
    SAPP_MODIFIER_RMB   = 0x200,    // right mouse button
    SAPP_MODIFIER_MMB   = 0x400,    // middle mouse button
};

/*
    sapp_event

    This is an all-in-one event struct passed to the event handler
    user callback function. Note that it depends on the event
    type what struct fields actually contain useful values, so you
    should first check the event type before reading other struct
    fields.
*/
typedef struct sapp_event {
    uint64_t frame_count;               // current frame counter, always valid, useful for checking if two events were issued in the same frame
    sapp_event_type type;               // the event type, always valid
    sapp_keycode key_code;              // the virtual key code, only valid in KEY_UP, KEY_DOWN
    uint32_t char_code;                 // the UTF-32 character code, only valid in CHAR events
    bool key_repeat;                    // true if this is a key-repeat event, valid in KEY_UP, KEY_DOWN and CHAR
    uint32_t modifiers;                 // current modifier keys, valid in all key-, char- and mouse-events
    sapp_mousebutton mouse_button;      // mouse button that was pressed or released, valid in MOUSE_DOWN, MOUSE_UP
    float mouse_x;                      // current horizontal mouse position in pixels, always valid except during mouse lock
    float mouse_y;                      // current vertical mouse position in pixels, always valid except during mouse lock
    float mouse_dx;                     // relative horizontal mouse movement since last frame, always valid
    float mouse_dy;                     // relative vertical mouse movement since last frame, always valid
    float scroll_x;                     // horizontal mouse wheel scroll distance, valid in MOUSE_SCROLL events
    float scroll_y;                     // vertical mouse wheel scroll distance, valid in MOUSE_SCROLL events
    int num_touches;                    // number of valid items in the touches[] array
    sapp_touchpoint touches[SAPP_MAX_TOUCHPOINTS];  // current touch points, valid in TOUCHES_BEGIN, TOUCHES_MOVED, TOUCHES_ENDED
    int window_width;                   // current window- and framebuffer sizes in pixels, always valid
    int window_height;
    int framebuffer_width;              // = window_width * dpi_scale
    int framebuffer_height;             // = window_height * dpi_scale
} sapp_event;

/*
    sg_range

    A general pointer/size-pair struct and constructor macros for passing binary blobs
    into sokol_app.h.
*/
typedef struct sapp_range {
    const void* ptr;
    size_t size;
} sapp_range;
// disabling this for every includer isn't great, but the warnings are also quite pointless
#if defined(_MSC_VER)
#pragma warning(disable:4221)   /* /W4 only: nonstandard extension used: 'x': cannot be initialized using address of automatic variable 'y' */
#pragma warning(disable:4204)   /* VS2015: nonstandard extension used: non-constant aggregate initializer */
#endif
#if defined(__cplusplus)
#define SAPP_RANGE(x) sapp_range{ &x, sizeof(x) }
#else
#define SAPP_RANGE(x) (sapp_range){ &x, sizeof(x) }
#endif

/*
    sapp_image_desc

    This is used to describe image data to sokol_app.h (at first, window
    icons, later maybe cursor images).

    Note that the actual image pixel format depends on the use case:

    - window icon pixels are RGBA8
*/
typedef struct sapp_image_desc {
    int width;
    int height;
    sapp_range pixels;
} sapp_image_desc;

/*
    sapp_icon_desc

    An icon description structure for use in sapp_desc.icon and
    sapp_set_icon().

    When setting a custom image, the application can provide a number of
    candidates differing in size, and sokol_app.h will pick the image(s)
    closest to the size expected by the platform's window system.

    To set sokol-app's default icon, set .sokol_default to true.

    Otherwise provide candidate images of different sizes in the
    images[] array.

    If both the sokol_default flag is set to true, any image candidates
    will be ignored and the sokol_app.h default icon will be set.
*/
typedef struct sapp_icon_desc {
    bool sokol_default;
    sapp_image_desc images[SAPP_MAX_ICONIMAGES];
} sapp_icon_desc;

/*
    sapp_allocator

    Used in sapp_desc to provide custom memory-alloc and -free functions
    to sokol_app.h. If memory management should be overridden, both the
    alloc_fn and free_fn function must be provided (e.g. it's not valid to
    override one function but not the other).
*/
typedef struct sapp_allocator {
    void* (*alloc_fn)(size_t size, void* user_data);
    void (*free_fn)(void* ptr, void* user_data);
    void* user_data;
} sapp_allocator;

/*
    sapp_log_item

    Log items are defined via X-Macros and expanded to an enum
    'sapp_log_item', and in debug mode to corresponding
    human readable error messages.
*/
#define _SAPP_LOG_ITEMS \
    _SAPP_LOGITEM_XMACRO(OK, "Ok") \
    _SAPP_LOGITEM_XMACRO(MALLOC_FAILED, "memory allocation failed") \
    _SAPP_LOGITEM_XMACRO(MACOS_INVALID_NSOPENGL_PROFILE, "macos: invalid NSOpenGLProfile (valid choices are 1.0 and 4.1)") \
    _SAPP_LOGITEM_XMACRO(WIN32_LOAD_OPENGL32_DLL_FAILED, "failed loading opengl32.dll") \
    _SAPP_LOGITEM_XMACRO(WIN32_CREATE_HELPER_WINDOW_FAILED, "failed to create helper window") \
    _SAPP_LOGITEM_XMACRO(WIN32_HELPER_WINDOW_GETDC_FAILED, "failed to get helper window DC") \
    _SAPP_LOGITEM_XMACRO(WIN32_DUMMY_CONTEXT_SET_PIXELFORMAT_FAILED, "failed to set pixel format for dummy GL context") \
    _SAPP_LOGITEM_XMACRO(WIN32_CREATE_DUMMY_CONTEXT_FAILED, "failed to create dummy GL context") \
    _SAPP_LOGITEM_XMACRO(WIN32_DUMMY_CONTEXT_MAKE_CURRENT_FAILED, "failed to make dummy GL context current") \
    _SAPP_LOGITEM_XMACRO(WIN32_GET_PIXELFORMAT_ATTRIB_FAILED, "failed to get WGL pixel format attribute") \
    _SAPP_LOGITEM_XMACRO(WIN32_WGL_FIND_PIXELFORMAT_FAILED, "failed to find matching WGL pixel format") \
    _SAPP_LOGITEM_XMACRO(WIN32_WGL_DESCRIBE_PIXELFORMAT_FAILED, "failed to get pixel format descriptor") \
    _SAPP_LOGITEM_XMACRO(WIN32_WGL_SET_PIXELFORMAT_FAILED, "failed to set selected pixel format") \
    _SAPP_LOGITEM_XMACRO(WIN32_WGL_ARB_CREATE_CONTEXT_REQUIRED, "ARB_create_context required") \
    _SAPP_LOGITEM_XMACRO(WIN32_WGL_ARB_CREATE_CONTEXT_PROFILE_REQUIRED, "ARB_create_context_profile required") \
    _SAPP_LOGITEM_XMACRO(WIN32_WGL_OPENGL_VERSION_NOT_SUPPORTED, "requested OpenGL version not supported by GL driver (ERROR_INVALID_VERSION_ARB)") \
    _SAPP_LOGITEM_XMACRO(WIN32_WGL_OPENGL_PROFILE_NOT_SUPPORTED, "requested OpenGL profile not support by GL driver (ERROR_INVALID_PROFILE_ARB)") \
    _SAPP_LOGITEM_XMACRO(WIN32_WGL_INCOMPATIBLE_DEVICE_CONTEXT, "CreateContextAttribsARB failed with ERROR_INCOMPATIBLE_DEVICE_CONTEXTS_ARB") \
    _SAPP_LOGITEM_XMACRO(WIN32_WGL_CREATE_CONTEXT_ATTRIBS_FAILED_OTHER, "CreateContextAttribsARB failed for other reason") \
    _SAPP_LOGITEM_XMACRO(WIN32_D3D11_CREATE_DEVICE_AND_SWAPCHAIN_WITH_DEBUG_FAILED, "D3D11CreateDeviceAndSwapChain() with D3D11_CREATE_DEVICE_DEBUG failed, retrying without debug flag.") \
    _SAPP_LOGITEM_XMACRO(WIN32_D3D11_GET_IDXGIFACTORY_FAILED, "could not obtain IDXGIFactory object") \
    _SAPP_LOGITEM_XMACRO(WIN32_D3D11_GET_IDXGIADAPTER_FAILED, "could not obtain IDXGIAdapter object") \
    _SAPP_LOGITEM_XMACRO(WIN32_D3D11_QUERY_INTERFACE_IDXGIDEVICE1_FAILED, "could not obtain IDXGIDevice1 interface") \
    _SAPP_LOGITEM_XMACRO(WIN32_REGISTER_RAW_INPUT_DEVICES_FAILED_MOUSE_LOCK, "RegisterRawInputDevices() failed (on mouse lock)") \
    _SAPP_LOGITEM_XMACRO(WIN32_REGISTER_RAW_INPUT_DEVICES_FAILED_MOUSE_UNLOCK, "RegisterRawInputDevices() failed (on mouse unlock)") \
    _SAPP_LOGITEM_XMACRO(WIN32_GET_RAW_INPUT_DATA_FAILED, "GetRawInputData() failed") \
    _SAPP_LOGITEM_XMACRO(LINUX_GLX_LOAD_LIBGL_FAILED, "failed to load libGL") \
    _SAPP_LOGITEM_XMACRO(LINUX_GLX_LOAD_ENTRY_POINTS_FAILED, "failed to load GLX entry points") \
    _SAPP_LOGITEM_XMACRO(LINUX_GLX_EXTENSION_NOT_FOUND, "GLX extension not found") \
    _SAPP_LOGITEM_XMACRO(LINUX_GLX_QUERY_VERSION_FAILED, "failed to query GLX version") \
    _SAPP_LOGITEM_XMACRO(LINUX_GLX_VERSION_TOO_LOW, "GLX version too low (need at least 1.3)") \
    _SAPP_LOGITEM_XMACRO(LINUX_GLX_NO_GLXFBCONFIGS, "glXGetFBConfigs() returned no configs") \
    _SAPP_LOGITEM_XMACRO(LINUX_GLX_NO_SUITABLE_GLXFBCONFIG, "failed to find a suitable GLXFBConfig") \
    _SAPP_LOGITEM_XMACRO(LINUX_GLX_GET_VISUAL_FROM_FBCONFIG_FAILED, "glXGetVisualFromFBConfig failed") \
    _SAPP_LOGITEM_XMACRO(LINUX_GLX_REQUIRED_EXTENSIONS_MISSING, "GLX extensions ARB_create_context and ARB_create_context_profile missing") \
    _SAPP_LOGITEM_XMACRO(LINUX_GLX_CREATE_CONTEXT_FAILED, "Failed to create GL context via glXCreateContextAttribsARB") \
    _SAPP_LOGITEM_XMACRO(LINUX_GLX_CREATE_WINDOW_FAILED, "glXCreateWindow() failed") \
    _SAPP_LOGITEM_XMACRO(LINUX_X11_CREATE_WINDOW_FAILED, "XCreateWindow() failed") \
    _SAPP_LOGITEM_XMACRO(LINUX_EGL_BIND_OPENGL_API_FAILED, "eglBindAPI(EGL_OPENGL_API) failed") \
    _SAPP_LOGITEM_XMACRO(LINUX_EGL_BIND_OPENGL_ES_API_FAILED, "eglBindAPI(EGL_OPENGL_ES_API) failed") \
    _SAPP_LOGITEM_XMACRO(LINUX_EGL_GET_DISPLAY_FAILED, "eglGetDisplay() failed") \
    _SAPP_LOGITEM_XMACRO(LINUX_EGL_INITIALIZE_FAILED, "eglInitialize() failed") \
    _SAPP_LOGITEM_XMACRO(LINUX_EGL_NO_CONFIGS, "eglChooseConfig() returned no configs") \
    _SAPP_LOGITEM_XMACRO(LINUX_EGL_NO_NATIVE_VISUAL, "eglGetConfigAttrib() for EGL_NATIVE_VISUAL_ID failed") \
    _SAPP_LOGITEM_XMACRO(LINUX_EGL_GET_VISUAL_INFO_FAILED, "XGetVisualInfo() failed") \
    _SAPP_LOGITEM_XMACRO(LINUX_EGL_CREATE_WINDOW_SURFACE_FAILED, "eglCreateWindowSurface() failed") \
    _SAPP_LOGITEM_XMACRO(LINUX_EGL_CREATE_CONTEXT_FAILED, "eglCreateContext() failed") \
    _SAPP_LOGITEM_XMACRO(LINUX_EGL_MAKE_CURRENT_FAILED, "eglMakeCurrent() failed") \
    _SAPP_LOGITEM_XMACRO(LINUX_X11_OPEN_DISPLAY_FAILED, "XOpenDisplay() failed") \
    _SAPP_LOGITEM_XMACRO(LINUX_X11_QUERY_SYSTEM_DPI_FAILED, "failed to query system dpi value, assuming default 96.0") \
    _SAPP_LOGITEM_XMACRO(LINUX_X11_DROPPED_FILE_URI_WRONG_SCHEME, "dropped file URL doesn't start with 'file://'") \
    _SAPP_LOGITEM_XMACRO(LINUX_X11_FAILED_TO_BECOME_OWNER_OF_CLIPBOARD, "X11: Failed to become owner of clipboard selection") \
    _SAPP_LOGITEM_XMACRO(ANDROID_UNSUPPORTED_INPUT_EVENT_INPUT_CB, "unsupported input event encountered in _sapp_android_input_cb()") \
    _SAPP_LOGITEM_XMACRO(ANDROID_UNSUPPORTED_INPUT_EVENT_MAIN_CB, "unsupported input event encountered in _sapp_android_main_cb()") \
    _SAPP_LOGITEM_XMACRO(ANDROID_READ_MSG_FAILED, "failed to read message in _sapp_android_main_cb()") \
    _SAPP_LOGITEM_XMACRO(ANDROID_WRITE_MSG_FAILED, "failed to write message in _sapp_android_msg") \
    _SAPP_LOGITEM_XMACRO(ANDROID_MSG_CREATE, "MSG_CREATE") \
    _SAPP_LOGITEM_XMACRO(ANDROID_MSG_RESUME, "MSG_RESUME") \
    _SAPP_LOGITEM_XMACRO(ANDROID_MSG_PAUSE, "MSG_PAUSE") \
    _SAPP_LOGITEM_XMACRO(ANDROID_MSG_FOCUS, "MSG_FOCUS") \
    _SAPP_LOGITEM_XMACRO(ANDROID_MSG_NO_FOCUS, "MSG_NO_FOCUS") \
    _SAPP_LOGITEM_XMACRO(ANDROID_MSG_SET_NATIVE_WINDOW, "MSG_SET_NATIVE_WINDOW") \
    _SAPP_LOGITEM_XMACRO(ANDROID_MSG_SET_INPUT_QUEUE, "MSG_SET_INPUT_QUEUE") \
    _SAPP_LOGITEM_XMACRO(ANDROID_MSG_DESTROY, "MSG_DESTROY") \
    _SAPP_LOGITEM_XMACRO(ANDROID_UNKNOWN_MSG, "unknown msg type received") \
    _SAPP_LOGITEM_XMACRO(ANDROID_LOOP_THREAD_STARTED, "loop thread started") \
    _SAPP_LOGITEM_XMACRO(ANDROID_LOOP_THREAD_DONE, "loop thread done") \
    _SAPP_LOGITEM_XMACRO(ANDROID_NATIVE_ACTIVITY_ONSTART, "NativeActivity onStart()") \
    _SAPP_LOGITEM_XMACRO(ANDROID_NATIVE_ACTIVITY_ONRESUME, "NativeActivity onResume") \
    _SAPP_LOGITEM_XMACRO(ANDROID_NATIVE_ACTIVITY_ONSAVEINSTANCESTATE, "NativeActivity onSaveInstanceState") \
    _SAPP_LOGITEM_XMACRO(ANDROID_NATIVE_ACTIVITY_ONWINDOWFOCUSCHANGED, "NativeActivity onWindowFocusChanged") \
    _SAPP_LOGITEM_XMACRO(ANDROID_NATIVE_ACTIVITY_ONPAUSE, "NativeActivity onPause") \
    _SAPP_LOGITEM_XMACRO(ANDROID_NATIVE_ACTIVITY_ONSTOP, "NativeActivity onStop()") \
    _SAPP_LOGITEM_XMACRO(ANDROID_NATIVE_ACTIVITY_ONNATIVEWINDOWCREATED, "NativeActivity onNativeWindowCreated") \
    _SAPP_LOGITEM_XMACRO(ANDROID_NATIVE_ACTIVITY_ONNATIVEWINDOWDESTROYED, "NativeActivity onNativeWindowDestroyed") \
    _SAPP_LOGITEM_XMACRO(ANDROID_NATIVE_ACTIVITY_ONINPUTQUEUECREATED, "NativeActivity onInputQueueCreated") \
    _SAPP_LOGITEM_XMACRO(ANDROID_NATIVE_ACTIVITY_ONINPUTQUEUEDESTROYED, "NativeActivity onInputQueueDestroyed") \
    _SAPP_LOGITEM_XMACRO(ANDROID_NATIVE_ACTIVITY_ONCONFIGURATIONCHANGED, "NativeActivity onConfigurationChanged") \
    _SAPP_LOGITEM_XMACRO(ANDROID_NATIVE_ACTIVITY_ONLOWMEMORY, "NativeActivity onLowMemory") \
    _SAPP_LOGITEM_XMACRO(ANDROID_NATIVE_ACTIVITY_ONDESTROY, "NativeActivity onDestroy") \
    _SAPP_LOGITEM_XMACRO(ANDROID_NATIVE_ACTIVITY_DONE, "NativeActivity done") \
    _SAPP_LOGITEM_XMACRO(ANDROID_NATIVE_ACTIVITY_ONCREATE, "NativeActivity onCreate") \
    _SAPP_LOGITEM_XMACRO(ANDROID_CREATE_THREAD_PIPE_FAILED, "failed to create thread pipe") \
    _SAPP_LOGITEM_XMACRO(ANDROID_NATIVE_ACTIVITY_CREATE_SUCCESS, "NativeActivity successfully created") \
    _SAPP_LOGITEM_XMACRO(WGPU_SWAPCHAIN_CREATE_SURFACE_FAILED, "wgpu: failed to create surface for swapchain") \
    _SAPP_LOGITEM_XMACRO(WGPU_SWAPCHAIN_CREATE_SWAPCHAIN_FAILED, "wgpu: failed to create swapchain object") \
    _SAPP_LOGITEM_XMACRO(WGPU_SWAPCHAIN_CREATE_DEPTH_STENCIL_TEXTURE_FAILED, "wgpu: failed to create depth-stencil texture for swapchain") \
    _SAPP_LOGITEM_XMACRO(WGPU_SWAPCHAIN_CREATE_DEPTH_STENCIL_VIEW_FAILED, "wgpu: failed to create view object for swapchain depth-stencil texture") \
    _SAPP_LOGITEM_XMACRO(WGPU_SWAPCHAIN_CREATE_MSAA_TEXTURE_FAILED, "wgpu: failed to create msaa texture for swapchain") \
    _SAPP_LOGITEM_XMACRO(WGPU_SWAPCHAIN_CREATE_MSAA_VIEW_FAILED, "wgpu: failed to create view object for swapchain msaa texture") \
    _SAPP_LOGITEM_XMACRO(WGPU_REQUEST_DEVICE_STATUS_ERROR, "wgpu: requesting device failed with status 'error'") \
    _SAPP_LOGITEM_XMACRO(WGPU_REQUEST_DEVICE_STATUS_UNKNOWN, "wgpu: requesting device failed with status 'unknown'") \
    _SAPP_LOGITEM_XMACRO(WGPU_REQUEST_ADAPTER_STATUS_UNAVAILABLE, "wgpu: requesting adapter failed with 'unavailable'") \
    _SAPP_LOGITEM_XMACRO(WGPU_REQUEST_ADAPTER_STATUS_ERROR, "wgpu: requesting adapter failed with status 'error'") \
    _SAPP_LOGITEM_XMACRO(WGPU_REQUEST_ADAPTER_STATUS_UNKNOWN, "wgpu: requesting adapter failed with status 'unknown'") \
    _SAPP_LOGITEM_XMACRO(WGPU_CREATE_INSTANCE_FAILED, "wgpu: failed to create instance") \
    _SAPP_LOGITEM_XMACRO(IMAGE_DATA_SIZE_MISMATCH, "image data size mismatch (must be width*height*4 bytes)") \
    _SAPP_LOGITEM_XMACRO(DROPPED_FILE_PATH_TOO_LONG, "dropped file path too long (sapp_desc.max_dropped_filed_path_length)") \
    _SAPP_LOGITEM_XMACRO(CLIPBOARD_STRING_TOO_BIG, "clipboard string didn't fit into clipboard buffer") \

#define _SAPP_LOGITEM_XMACRO(item,msg) SAPP_LOGITEM_##item,
typedef enum sapp_log_item {
    _SAPP_LOG_ITEMS
} sapp_log_item;
#undef _SAPP_LOGITEM_XMACRO

/*
    sapp_logger

    Used in sapp_desc to provide a logging function. Please be aware that
    without logging function, sokol-app will be completely silent, e.g. it will
    not report errors or warnings. For maximum error verbosity, compile in
    debug mode (e.g. NDEBUG *not* defined) and install a logger (for instance
    the standard logging function from sokol_log.h).
*/
typedef struct sapp_logger {
    void (*func)(
        const char* tag,                // always "sapp"
        uint32_t log_level,             // 0=panic, 1=error, 2=warning, 3=info
        uint32_t log_item_id,           // SAPP_LOGITEM_*
        const char* message_or_null,    // a message string, may be nullptr in release mode
        uint32_t line_nr,               // line number in sokol_app.h
        const char* filename_or_null,   // source filename, may be nullptr in release mode
        void* user_data);
    void* user_data;
} sapp_logger;

typedef struct sapp_desc {
    void (*init_cb)(void);                  // these are the user-provided callbacks without user data
    void (*frame_cb)(void);
    void (*cleanup_cb)(void);
    void (*event_cb)(const sapp_event*);

    void* user_data;                        // these are the user-provided callbacks with user data
    void (*init_userdata_cb)(void*);
    void (*frame_userdata_cb)(void*);
    void (*cleanup_userdata_cb)(void*);
    void (*event_userdata_cb)(const sapp_event*, void*);

    int width;                          // the preferred width of the window / canvas
    int height;                         // the preferred height of the window / canvas
    int sample_count;                   // MSAA sample count
    int swap_interval;                  // the preferred swap interval (ignored on some platforms)
    bool high_dpi;                      // whether the rendering canvas is full-resolution on HighDPI displays
    bool fullscreen;                    // whether the window should be created in fullscreen mode
    bool alpha;                         // whether the framebuffer should have an alpha channel (ignored on some platforms)
    const char* window_title;           // the window title as UTF-8 encoded string
    bool enable_clipboard;              // enable clipboard access, default is false
    int clipboard_size;                 // max size of clipboard content in bytes
    bool enable_dragndrop;              // enable file dropping (drag'n'drop), default is false
    int max_dropped_files;              // max number of dropped files to process (default: 1)
    int max_dropped_file_path_length;   // max length in bytes of a dropped UTF-8 file path (default: 2048)
    sapp_icon_desc icon;                // the initial window icon to set
    sapp_allocator allocator;           // optional memory allocation overrides (default: malloc/free)
    sapp_logger logger;                 // logging callback override (default: NO LOGGING!)

    // backend-specific options
    int gl_major_version;               // override GL major and minor version (the default GL version is 4.1 on macOS, 4.3 elsewhere)
    int gl_minor_version;
    bool win32_console_utf8;            // if true, set the output console codepage to UTF-8
    bool win32_console_create;          // if true, attach stdout/stderr to a new console window
    bool win32_console_attach;          // if true, attach stdout/stderr to parent process
    const char* html5_canvas_selector;  // css selector of the HTML5 canvas element, default is "#canvas"
    bool html5_canvas_resize;           // if true, the HTML5 canvas size is set to sapp_desc.width/height, otherwise canvas size is tracked
    bool html5_preserve_drawing_buffer; // HTML5 only: whether to preserve default framebuffer content between frames
    bool html5_premultiplied_alpha;     // HTML5 only: whether the rendered pixels use premultiplied alpha convention
    bool html5_ask_leave_site;          // initial state of the internal html5_ask_leave_site flag (see sapp_html5_ask_leave_site())
    bool html5_bubble_mouse_events;     // if true, mouse events will bubble up to the web page
    bool html5_bubble_touch_events;     // same for touch events
    bool html5_bubble_wheel_events;     // same for wheel events
    bool html5_bubble_key_events;       // if true, bubble up *all* key events to browser, not just key events that represent characters
    bool html5_bubble_char_events;      // if true, bubble up character events to browser
    bool html5_use_emsc_set_main_loop;  // if true, use emscripten_set_main_loop() instead of emscripten_request_animation_frame_loop()
    bool html5_emsc_set_main_loop_simulate_infinite_loop;   // this will be passed as the simulate_infinite_loop arg to emscripten_set_main_loop()
    bool ios_keyboard_resizes_canvas;   // if true, showing the iOS keyboard shrinks the canvas
} sapp_desc;

/* HTML5 specific: request and response structs for
   asynchronously loading dropped-file content.
*/
typedef enum sapp_html5_fetch_error {
    SAPP_HTML5_FETCH_ERROR_NO_ERROR,
    SAPP_HTML5_FETCH_ERROR_BUFFER_TOO_SMALL,
    SAPP_HTML5_FETCH_ERROR_OTHER,
} sapp_html5_fetch_error;

typedef struct sapp_html5_fetch_response {
    bool succeeded;         // true if the loading operation has succeeded
    sapp_html5_fetch_error error_code;
    int file_index;         // index of the dropped file (0..sapp_get_num_dropped_filed()-1)
    sapp_range data;        // pointer and size of the fetched data (data.ptr == buffer.ptr, data.size <= buffer.size)
    sapp_range buffer;      // the user-provided buffer ptr/size pair (buffer.ptr == data.ptr, buffer.size >= data.size)
    void* user_data;        // user-provided user data pointer
} sapp_html5_fetch_response;

typedef struct sapp_html5_fetch_request {
    int dropped_file_index; // 0..sapp_get_num_dropped_files()-1
    void (*callback)(const sapp_html5_fetch_response*);     // response callback function pointer (required)
    sapp_range buffer;      // ptr/size of a memory buffer to load the data into
    void* user_data;        // optional userdata pointer
} sapp_html5_fetch_request;

/*
    sapp_mouse_cursor

    Predefined cursor image definitions, set with sapp_set_mouse_cursor(sapp_mouse_cursor cursor)
*/
typedef enum sapp_mouse_cursor {
    SAPP_MOUSECURSOR_DEFAULT = 0,   // equivalent with system default cursor
    SAPP_MOUSECURSOR_ARROW,
    SAPP_MOUSECURSOR_IBEAM,
    SAPP_MOUSECURSOR_CROSSHAIR,
    SAPP_MOUSECURSOR_POINTING_HAND,
    SAPP_MOUSECURSOR_RESIZE_EW,
    SAPP_MOUSECURSOR_RESIZE_NS,
    SAPP_MOUSECURSOR_RESIZE_NWSE,
    SAPP_MOUSECURSOR_RESIZE_NESW,
    SAPP_MOUSECURSOR_RESIZE_ALL,
    SAPP_MOUSECURSOR_NOT_ALLOWED,
    _SAPP_MOUSECURSOR_NUM,
} sapp_mouse_cursor;

/* user-provided functions */
extern sapp_desc sokol_main(int argc, char* argv[]);

/* returns true after sokol-app has been initialized */
SOKOL_APP_API_DECL bool sapp_isvalid(void);
/* returns the current framebuffer width in pixels */
SOKOL_APP_API_DECL int sapp_width(void);
/* same as sapp_width(), but returns float */
SOKOL_APP_API_DECL float sapp_widthf(void);
/* returns the current framebuffer height in pixels */
SOKOL_APP_API_DECL int sapp_height(void);
/* same as sapp_height(), but returns float */
SOKOL_APP_API_DECL float sapp_heightf(void);
/* get default framebuffer color pixel format */
SOKOL_APP_API_DECL int sapp_color_format(void);
/* get default framebuffer depth pixel format */
SOKOL_APP_API_DECL int sapp_depth_format(void);
/* get default framebuffer sample count */
SOKOL_APP_API_DECL int sapp_sample_count(void);
/* returns true when high_dpi was requested and actually running in a high-dpi scenario */
SOKOL_APP_API_DECL bool sapp_high_dpi(void);
/* returns the dpi scaling factor (window pixels to framebuffer pixels) */
SOKOL_APP_API_DECL float sapp_dpi_scale(void);
/* show or hide the mobile device onscreen keyboard */
SOKOL_APP_API_DECL void sapp_show_keyboard(bool show);
/* return true if the mobile device onscreen keyboard is currently shown */
SOKOL_APP_API_DECL bool sapp_keyboard_shown(void);
/* query fullscreen mode */
SOKOL_APP_API_DECL bool sapp_is_fullscreen(void);
/* toggle fullscreen mode */
SOKOL_APP_API_DECL void sapp_toggle_fullscreen(void);
/* show or hide the mouse cursor */
SOKOL_APP_API_DECL void sapp_show_mouse(bool show);
/* show or hide the mouse cursor */
SOKOL_APP_API_DECL bool sapp_mouse_shown(void);
/* enable/disable mouse-pointer-lock mode */
SOKOL_APP_API_DECL void sapp_lock_mouse(bool lock);
/* return true if in mouse-pointer-lock mode (this may toggle a few frames later) */
SOKOL_APP_API_DECL bool sapp_mouse_locked(void);
/* set mouse cursor type */
SOKOL_APP_API_DECL void sapp_set_mouse_cursor(sapp_mouse_cursor cursor);
/* get current mouse cursor type */
SOKOL_APP_API_DECL sapp_mouse_cursor sapp_get_mouse_cursor(void);
/* return the userdata pointer optionally provided in sapp_desc */
SOKOL_APP_API_DECL void* sapp_userdata(void);
/* return a copy of the sapp_desc structure */
SOKOL_APP_API_DECL sapp_desc sapp_query_desc(void);
/* initiate a "soft quit" (sends SAPP_EVENTTYPE_QUIT_REQUESTED) */
SOKOL_APP_API_DECL void sapp_request_quit(void);
/* cancel a pending quit (when SAPP_EVENTTYPE_QUIT_REQUESTED has been received) */
SOKOL_APP_API_DECL void sapp_cancel_quit(void);
/* initiate a "hard quit" (quit application without sending SAPP_EVENTTYPE_QUIT_REQUESTED) */
SOKOL_APP_API_DECL void sapp_quit(void);
/* call from inside event callback to consume the current event (don't forward to platform) */
SOKOL_APP_API_DECL void sapp_consume_event(void);
/* get the current frame counter (for comparison with sapp_event.frame_count) */
SOKOL_APP_API_DECL uint64_t sapp_frame_count(void);
/* get an averaged/smoothed frame duration in seconds */
SOKOL_APP_API_DECL double sapp_frame_duration(void);
/* write string into clipboard */
SOKOL_APP_API_DECL void sapp_set_clipboard_string(const char* str);
/* read string from clipboard (usually during SAPP_EVENTTYPE_CLIPBOARD_PASTED) */
SOKOL_APP_API_DECL const char* sapp_get_clipboard_string(void);
/* set the window title (only on desktop platforms) */
SOKOL_APP_API_DECL void sapp_set_window_title(const char* str);
/* set the window icon (only on Windows and Linux) */
SOKOL_APP_API_DECL void sapp_set_icon(const sapp_icon_desc* icon_desc);
/* gets the total number of dropped files (after an SAPP_EVENTTYPE_FILES_DROPPED event) */
SOKOL_APP_API_DECL int sapp_get_num_dropped_files(void);
/* gets the dropped file paths */
SOKOL_APP_API_DECL const char* sapp_get_dropped_file_path(int index);

/* special run-function for SOKOL_NO_ENTRY (in standard mode this is an empty stub) */
SOKOL_APP_API_DECL void sapp_run(const sapp_desc* desc);

/* EGL: get EGLDisplay object */
SOKOL_APP_API_DECL const void* sapp_egl_get_display(void);
/* EGL: get EGLContext object */
SOKOL_APP_API_DECL const void* sapp_egl_get_context(void);

/* HTML5: enable or disable the hardwired "Leave Site?" dialog box */
SOKOL_APP_API_DECL void sapp_html5_ask_leave_site(bool ask);
/* HTML5: get byte size of a dropped file */
SOKOL_APP_API_DECL uint32_t sapp_html5_get_dropped_file_size(int index);
/* HTML5: asynchronously load the content of a dropped file */
SOKOL_APP_API_DECL void sapp_html5_fetch_dropped_file(const sapp_html5_fetch_request* request);

/* Metal: get bridged pointer to Metal device object */
SOKOL_APP_API_DECL const void* sapp_metal_get_device(void);
/* Metal: get bridged pointer to MTKView's current drawable of type CAMetalDrawable */
SOKOL_APP_API_DECL const void* sapp_metal_get_current_drawable(void);
/* Metal: get bridged pointer to MTKView's depth-stencil texture of type MTLTexture */
SOKOL_APP_API_DECL const void* sapp_metal_get_depth_stencil_texture(void);
/* Metal: get bridged pointer to MTKView's msaa-color-texture of type MTLTexture (may be null) */
SOKOL_APP_API_DECL const void* sapp_metal_get_msaa_color_texture(void);
/* macOS: get bridged pointer to macOS NSWindow */
SOKOL_APP_API_DECL const void* sapp_macos_get_window(void);
/* iOS: get bridged pointer to iOS UIWindow */
SOKOL_APP_API_DECL const void* sapp_ios_get_window(void);

/* D3D11: get pointer to ID3D11Device object */
SOKOL_APP_API_DECL const void* sapp_d3d11_get_device(void);
/* D3D11: get pointer to ID3D11DeviceContext object */
SOKOL_APP_API_DECL const void* sapp_d3d11_get_device_context(void);
/* D3D11: get pointer to IDXGISwapChain object */
SOKOL_APP_API_DECL const void* sapp_d3d11_get_swap_chain(void);
/* D3D11: get pointer to ID3D11RenderTargetView object for rendering */
SOKOL_APP_API_DECL const void* sapp_d3d11_get_render_view(void);
/* D3D11: get pointer ID3D11RenderTargetView object for msaa-resolve (may return null) */
SOKOL_APP_API_DECL const void* sapp_d3d11_get_resolve_view(void);
/* D3D11: get pointer ID3D11DepthStencilView */
SOKOL_APP_API_DECL const void* sapp_d3d11_get_depth_stencil_view(void);
/* Win32: get the HWND window handle */
SOKOL_APP_API_DECL const void* sapp_win32_get_hwnd(void);

/* WebGPU: get WGPUDevice handle */
SOKOL_APP_API_DECL const void* sapp_wgpu_get_device(void);
/* WebGPU: get swapchain's WGPUTextureView handle for rendering */
SOKOL_APP_API_DECL const void* sapp_wgpu_get_render_view(void);
/* WebGPU: get swapchain's MSAA-resolve WGPUTextureView (may return null) */
SOKOL_APP_API_DECL const void* sapp_wgpu_get_resolve_view(void);
/* WebGPU: get swapchain's WGPUTextureView for the depth-stencil surface */
SOKOL_APP_API_DECL const void* sapp_wgpu_get_depth_stencil_view(void);

/* GL: get framebuffer object */
SOKOL_APP_API_DECL uint32_t sapp_gl_get_framebuffer(void);
/* GL: get major version (only valid for desktop GL) */
SOKOL_APP_API_DECL int sapp_gl_get_major_version(void);
/* GL: get minor version (only valid for desktop GL) */
SOKOL_APP_API_DECL int sapp_gl_get_minor_version(void);

/* Android: get native activity handle */
SOKOL_APP_API_DECL const void* sapp_android_get_native_activity(void);

