package.cpath   = package.cpath..";../bin/win64/?.dll"
package.path    = package.path..";../ffi/sokol/?.lua"
package.path    = package.path..";../?.lua"

--_G.SOKOL_DLL    = "sokol_debug_dll"
local sapp      = require("sokol_app")
local sg        = require("sokol_imgui") -- Includes gfx!!
local im = sg -- Will NOT be using imgui in applications. Sample only. Dont recommend.
local slib      = require("sokol_libs") -- Warn - always after gfx!!

local hmm       = require("hmm")
local hutils    = require("hmm_utils")

local ffi       = require("ffi")

-- --------------------------------------------------------------------------------------

ffi.cdef[[
    typedef struct {
        uint64_t last_time;
        bool show_test_window;
        bool show_another_window;
        sg_pass_action pass_action;
    } state_t;
]]

local state = ffi.new("state_t[1]") 

-- --------------------------------------------------------------------------------------

local function init(void) 
    -- // setup sokol-gfx, sokol-time and sokol-imgui
    local sg_desc = ffi.new("sg_desc[1]")
    sg_desc[0].environment = slib.sglue_environment()
    sg_desc[0].logger.func = slib.slog_func
    sg.sg_setup( sg_desc )

    -- // use sokol-imgui with all default-options (we're not doing
    -- // multi-sampled rendering or using non-default pixel formats)
    local simg = ffi.new("simgui_desc_t[1]")
    simg[0].logger.func = slib.slog_func
    sg.simgui_setup(simg)

    -- /* initialize application state */
    state[0].show_test_window = true
    state[0].pass_action.colors[0].load_action = sg.SG_LOADACTION_CLEAR
    state[0].pass_action.colors[0].clear_value = { 0.7, 0.5, 0.0, 1.0 }
end

-- --------------------------------------------------------------------------------------

local emptyVec2 = ffi.new("ImVec2[1]",{ x=0.0, y=0.0} )
local f = ffi.new("float[1]", {0.0});
local color = ffi.new("float[3]", { state[0].pass_action.colors[0].clear_value.r, state[0].pass_action.colors[0].clear_value.g, state[0].pass_action.colors[0].clear_value.b })

local function frame(void)
    local width = sapp.sapp_width()
    local height = sapp.sapp_height()

    local imframe = ffi.new("simgui_frame_desc_t[1]")
    imframe[0].width = width
    imframe[0].height = height
    imframe[0].delta_time = sapp.sapp_frame_duration()
    imframe[0].dpi_scale = sapp.sapp_dpi_scale()
    im.simgui_new_frame(imframe)

    -- // 1. Show a simple window
    -- // Tip: if we don't call ImGui::Begin()/ImGui::End() the widgets appears in a window automatically called "Debug"
    im.igText("Hello, world!")
    local sliderset = im.igSliderFloat("float", f, 0.0, 1.0, "%.3f", im.ImGuiSliderFlags_None)
    im.igColorEdit3("clear color", color, 0)
    if (im.igButton("Test Window", emptyVec2[0])) then state[0].show_test_window = not state[0].show_test_window end
    if (im.igButton("Another Window", emptyVec2[0])) then state[0].show_another_window = not state[0].show_another_window end
     im.igText("Application average %.3f ms/frame (%.1f FPS)", 1000.0 / im.igGetIO().Framerate, im.igGetIO().Framerate)

    -- -- // 2. Show another simple window, this time using an explicit Begin/End pair
    if (state[0].show_another_window) then
        local saw = ffi.new("bool[1]", {state[0].show_another_window})
        local winpos = ffi.new("ImVec2[1]", { {200, 100} })
        im.igSetNextWindowSize(winpos[0], im.ImGuiCond_FirstUseEver)
        im.igBegin("Another Window", saw, 0)
        im.igText("Hello");
        im.igEnd();
    end

    -- -- // 3. Show the ImGui test window. Most of the sample code is in ImGui::ShowDemoWindow()
    if (state[0].show_test_window) then
        local stw = ffi.new("bool[1]", {state[0].show_test_window})
        local winpos = ffi.new("ImVec2[1]", { { 460, 20} })
        im.igSetNextWindowPos(winpos[0], im.ImGuiCond_FirstUseEver, emptyVec2[0]);
        im.igShowDemoWindow(stw);
    end

    -- // the sokol_gfx draw pass
    local pass = ffi.new("sg_pass[1]")
    pass[0].action = state[0].pass_action
    pass[0].swapchain = slib.sglue_swapchain()
    sg.sg_begin_pass(pass)

    im.simgui_render()
    sg.sg_end_pass()
    sg.sg_commit()
end

-- --------------------------------------------------------------------------------------

local function cleanup()

    sg.sg_shutdown()
end

-- --------------------------------------------------------------------------------------

local function input(event) 
    im.simgui_handle_event(event)
end

-- --------------------------------------------------------------------------------------

local app_desc = ffi.new("sapp_desc[1]")
app_desc[0].init_cb = init
app_desc[0].frame_cb = frame
app_desc[0].cleanup_cb = cleanup
app_desc[0].event_cb = input
app_desc[0].width = 1920
app_desc[0].height = 1080
app_desc[0].window_title = "cimgui (sokol-app)"
app_desc[0].icon.sokol_default = true 
app_desc[0].logger.func = slib.slog_func 
app_desc[0].enable_clipboard = true
app_desc[0].ios_keyboard_resizes_canvas = false

sapp.sapp_run( app_desc )

-- --------------------------------------------------------------------------------------