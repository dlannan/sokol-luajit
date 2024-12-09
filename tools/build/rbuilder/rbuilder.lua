package.path    = package.path..";../../../?.lua"
local dirtools = require("tools.dirtools")
local base_path = dirtools.get_app_path("sokol%-luajit")

package.cpath   = package.cpath..";"..base_path.."bin/win64/?.dll"
package.path    = package.path..";"..base_path.."ffi/sokol/?.lua"
package.path    = package.path..";"..base_path.."?.lua"

--_G.SOKOL_DLL    = "sokol_debug_dll"
local sapp      = require("sokol_app")
sg              = require("sokol_nuklear")
local nk        = sg
local slib      = require("sokol_libs") -- Warn - always after gfx!!

local hmm       = require("hmm")
local hutils    = require("hmm_utils")

local stb       = require("stb")

local ffi       = require("ffi")

local panel     = require("ui.panels")
local builder   = require("utils.build")

-- --------------------------------------------------------------------------------------
-- For win - sleep so as to not consume all proc cycles for ui
ffi.cdef[[
    void Sleep(uint32_t ms);
]]

-- --------------------------------------------------------------------------------------
local ticker = nil

function default_handler(ctx, build)

    builder.configure(panel.config)
    builder.run(panel.config)

    -- ticker = (ticker or 0) + 0.016
    -- if(ticker > 0.01) then 
    --     build.progress[0] = build.progress[0] + 1
    --     ticker = ticker - 0.01 
    -- end
    -- if(panel.build.progress[0] >= 999) then 
        -- ticker = nil
        build.progress[0] = 0.0 
        build.active = 0 
        build.mode = nil
    -- end 
end

-- --------------------------------------------------------------------------------------

local function init(void)
    -- // setup sokol-gfx, sokol-time and sokol-imgui
    local sg_desc = ffi.new("sg_desc[1]")
    sg_desc[0].environment = slib.sglue_environment()
    sg_desc[0].logger.func = slib.slog_func
    sg.sg_setup( sg_desc )

    -- // use sokol-nuklear with all default-options (we're not doing
    -- // multi-sampled rendering or using non-default pixel formats)
    local snk = ffi.new("snk_desc_t[1]")
    snk[0].dpi_scale = sapp.sapp_dpi_scale()
    snk[0].logger.func = slib.slog_func
    nk.snk_setup(snk)

    sapp.sapp_show_mouse(false)

    panel.init()
    panel.build.handler = default_handler
    sapp.sapp_set_window_title(panel.config.rbuilder.title.value)
end

-- --------------------------------------------------------------------------------------

local function cleanup()

    sg.sg_shutdown()
end

-- --------------------------------------------------------------------------------------

local current_ctx = nil
local function input(event) 
    panel.input(event)
    if(event.type == sapp.SAPP_EVENTTYPE_RESIZED) then 
        nk.snk_handle_event(event)
        -- folder_select.popup_dim.x = sapp.sapp_width()/2 - folder_select.popup_dim.w/2
        -- folder_select.popup_dim.y = sapp.sapp_height()/2 - folder_select.popup_dim.h    
    elseif(event.type == sapp.SAPP_EVENTTYPE_MOUSE_ENTER) then 
        nk.nk_style_show_cursor(current_ctx)
        sapp.sapp_show_mouse(false)
    elseif(event.type == sapp.SAPP_EVENTTYPE_MOUSE_LEAVE) then 
        nk.nk_style_hide_cursor(current_ctx)
        sapp.sapp_show_mouse(true)
    else 
        nk.snk_handle_event(event)
    end   
end

-- --------------------------------------------------------------------------------------

local function frame(void) 

    local ctx = nk.snk_new_frame()
    current_ctx = ctx
    panel.main_ui(ctx)

    -- // the sokol_gfx draw pass
    local pass = ffi.new("sg_pass[1]")
    pass[0].action.colors[0].load_action = sg.SG_LOADACTION_CLEAR
    pass[0].action.colors[0].clear_value = { 0.09, 0.067, 0.153, 1.0 }
    pass[0].swapchain = slib.sglue_swapchain()
    sg.sg_begin_pass(pass)

    nk.snk_render(sapp.sapp_width(), sapp.sapp_height())
    sg.sg_end_pass()
    sg.sg_commit()

    ffi.C.Sleep(3)
end

-- --------------------------------------------------------------------------------------

local app_desc = ffi.new("sapp_desc[1]")
app_desc[0].init_cb = init
app_desc[0].frame_cb = frame
app_desc[0].cleanup_cb = cleanup
app_desc[0].event_cb = input
app_desc[0].width = 1280
app_desc[0].height = 800
app_desc[0].window_title = ""
app_desc[0].icon.sokol_default = true 
app_desc[0].logger.func = slib.slog_func 
app_desc[0].enable_clipboard = true
app_desc[0].ios_keyboard_resizes_canvas = false

sapp.sapp_run( app_desc )

-- --------------------------------------------------------------------------------------

-- local default_libs = {
--     ["os"] = true,
--     ["_G"] = true,
--     ["jit"] = true,
--     ["table"] = true, 
--     ["jit.opt"] = true,
--     ["ffi"] = true, 
--     ["string"] = true,
--     ["io"] = true, 
--     ["coroutine"] = true,
--     ["package"] = true,
--     ["math"] = true,
--     ["debug"] = true,
--     ["bit"] = true, 
-- }
-- for k,v in pairs(package.loaded) do 

--     if(type(v) ~= "userdata" and default_libs[tostring(k)] == nil) then
--         print( "["..tostring(k).."] = "..tostring(v)) 
--     end
-- end

-- --------------------------------------------------------------------------------------

panel.cleanup()

-- --------------------------------------------------------------------------------------
