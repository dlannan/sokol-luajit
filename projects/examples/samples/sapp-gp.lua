
package.path    = package.path..";../../?.lua"
local dirtools  = require("tools.vfs.dirtools").init("sokol%-luajit")

--_G.SOKOL_DLL    = "sokol_debug_dll"
local sapp      = require("sokol_app")
sgp             = require("sokol_gp")
sg              = sgp
local slib      = require("sokol_libs") -- Warn - always after gfx!!

local hmm       = require("hmm")
local hutils    = require("hmm_utils")

local utils     = require("utils")

local ffi       = require("ffi")

-- --------------------------------------------------------------------------------------

local function init()

    local desc = ffi.new("sg_desc[1]")
    desc[0].environment = slib.sglue_environment()
    desc[0].logger.func = slib.slog_func
    desc[0].disable_validation = false
    sg.sg_setup( desc )
    print("Sokol Is Valid: "..tostring(sg.sg_isvalid()))

    -- Initialize Sokol GP, adjust the size of command buffers for your own use.
    local sgpdesc = ffi.new("sgp_desc[1]")
    ffi.fill(sgpdesc, ffi.sizeof("sgp_desc"))
    sgp.sgp_setup(sgpdesc)
    print("Sokol GP Is Valid: ".. tostring(sgp.sgp_is_valid()))
end

-- --------------------------------------------------------------------------------------

local function frame()

    -- Get current window size.
    local width         = sapp.sapp_widthf()
    local height        = sapp.sapp_heightf()
    local t             = (sapp.sapp_frame_duration() * 60.0)
    local ratio = width/height

    -- Begin recording draw commands for a frame buffer of size (width, height).
    sgp.sgp_begin(width, height)
    -- Set frame buffer drawing region to (0,0,width,height).
    sgp.sgp_viewport(0, 0, width, height)
    -- Set drawing coordinate space to (left=-ratio, right=ratio, top=1, bottom=-1).
    sgp.sgp_project(-ratio, ratio, 1.0, -1.0)

    -- Clear the frame buffer.
    sgp.sgp_set_color(0.1, 0.1, 0.1, 1.0)
    sgp.sgp_clear()

    -- Draw an animated rectangle that rotates and changes its colors.
    local time = tonumber(sapp.sapp_frame_count() * sapp.sapp_frame_duration())
    local r = math.sin(time)*0.5+0.5
    local g = math.cos(time)*0.5+0.5
    sgp.sgp_set_color(r, g, 0.3, 1.0)
    sgp.sgp_rotate_at(time, 0.0, 0.0)
    sgp.sgp_draw_filled_rect(-0.5, -0.5, 1.0, 1.0)

    -- Begin a render pass.
    local pass      = ffi.new("sg_pass[1]")
    pass[0].swapchain = slib.sglue_swapchain()
    sg.sg_begin_pass(pass)

    -- Dispatch all draw commands to Sokol GFX.
    sgp.sgp_flush()
    -- Finish a draw command queue, clearing it.
    sgp.sgp_end()
    -- End render pass.
    sgp.sg_end_pass()
    -- Commit Sokol render.
    sg.sg_commit()
end

-- --------------------------------------------------------------------------------------

local function cleanup()
    sgp.sgp_shutdown()
    sg.sg_shutdown()
end

-- --------------------------------------------------------------------------------------

local app_desc = ffi.new("sapp_desc[1]")
app_desc[0].init_cb     = init
app_desc[0].frame_cb    = frame
app_desc[0].cleanup_cb  = cleanup
app_desc[0].width       = 1920
app_desc[0].height      = 1080
app_desc[0].window_title = "Rectangle (Sokol GP)"
app_desc[0].fullscreen  = false
app_desc[0].icon.sokol_default = true 
app_desc[0].logger.func = slib.slog_func 

sapp.sapp_run( app_desc )

-- --------------------------------------------------------------------------------------
