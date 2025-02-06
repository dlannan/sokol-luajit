
package.path    = package.path..";../../?.lua"
local dirtools  = require("tools.vfs.dirtools").init("sokol%-luajit")

--_G.SOKOL_DLL    = "sokol_debug_dll"
local sapp      = require("sokol_app")
sgp             = require("sokol_gp")
sg              = sgp
local slib      = require("sokol_libs") -- Warn - always after gfx!!

local hmm       = require("hmm")
local hutils    = require("hmm_utils")

local clay      = require("clay")
local cutils    = require("clay_utils")

local utils     = require("utils")

-- --------------------------------------------------------------------------------------

local ffi       = require("ffi")

ffi.cdef[[
    void Sleep(uint32_t ms);
]]

-- --------------------------------------------------------------------------------------

local function HandleClayErrors(errorData) 
    print(errorData)
    print(string.format("[Clay] %s", ffi.string(errorData.errorText.chars)))
end

-- --------------------------------------------------------------------------------------
-- Clay setup params
local clay_dim  = ffi.new("Clay_Dimensions", { 1024, 768 })
local clay_errors = ffi.new("Clay_ErrorHandler", { errorHanderFunction = HandleClayErrors })

-- --------------------------------------------------------------------------------------

local totalMemorySize = clay.Clay_MinMemorySize()
local clay_mem = ffi.new("char[?]", totalMemorySize)

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

    clayMemory = clay.Clay_CreateArenaWithCapacityAndMemory(totalMemorySize, clay_mem)
    clay.Clay_Initialize(clayMemory, clay_dim, clay_errors)
end

-- --------------------------------------------------------------------------------------

local renderCmdMap = {
    [clay.CLAY_RENDER_COMMAND_TYPE_RECTANGLE] = function(cmd)
        local color = cmd.config.rectangleElementConfig.color
        sgp.sgp_set_color(color.r, color.g, color.b, color.a)
        local bb = cmd.boundingBox
        sgp.sgp_draw_filled_rect(bb.x, bb.y, bb.width, bb.height)
    end, 
    [clay.CLAY_RENDER_COMMAND_TYPE_TEXT] = function(cmd)

    end, 
}

-- --------------------------------------------------------------------------------------

local function renderClay( renderCommands )
    -- // More comprehensive rendering examples can be found in the renderers/ directory
    for i = 0, renderCommands.length do
        local theCmd = renderCommands.internalArray[i]
        local cmdType = tonumber(theCmd.commandType)
        local docommand = renderCmdMap[cmdType]
        if(docommand) then 
            docommand(theCmd)
        end
    end
end    

-- --------------------------------------------------------------------------------------
-- TODO: make these helpers in cutils I think.
local ctype_sizingaxis = ffi.typeof("Clay_SizingAxis")
local ctype_sizing = ffi.typeof("Clay_Sizing")

local sizingGrow = ctype_sizing( { 
    width = ctype_sizingaxis( { size = {percent = 100}, type = clay.CLAY__SIZING_TYPE_GROW } ), 
    height = ctype_sizingaxis( { size = {percent = 100}, type = clay.CLAY__SIZING_TYPE_GROW } )
} )

local ctype_layoutconfig = ffi.typeof("Clay_LayoutConfig")
local ctype_rectangleelementconfig = ffi.typeof("Clay_RectangleElementConfig")

-- --------------------------------------------------------------------------------------
local rotator = 0.0
local function frame()

    -- Get current window size.
    local width         = sapp.sapp_widthf()
    local height        = sapp.sapp_heightf()
    local t             = (sapp.sapp_frame_duration() * 60.0)
    rotator = math.fmod(rotator + sapp.sapp_frame_duration(), math.pi * 2.0)
    local ratio = width/height

    -- Clay commands to make ui - this is a little messy because Clay uses a mess of macros (very 90s)
    clay.Clay_BeginLayout()

    -- The cascading child declaration methodology is messy. I think I might make it stack based, 
    --    much cleaner and certainly better to dev with. 
    cutils.CLAY_START()
        -- elements config
        cutils.CLAY_LAYOUT( ctype_layoutconfig({ padding = { top = 25 }, sizing = sizingGrow }) )
        cutils.CLAY_RECTANGLE( ctype_rectangleelementconfig( { color = {255,255,0,255} }) )
    cutils.CLAY_POSTCONFIG()

        -- Children here
        cutils.CLAY_TEXT( cutils.CLAY_STRING(""), cutils.CLAY_TEXT_CONFIG({ fontId = 0 }) )
    cutils.CLAY_END()

    -- This builds a list of render commands we can process below
    local renderCommands = clay.Clay_EndLayout()

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
    local r = math.sin(rotator)*0.5+0.5
    local g = math.cos(rotator)*0.5+0.5
    sgp.sgp_push_transform()
    sgp.sgp_set_color(r, g, 0.3, 1.0)
    sgp.sgp_rotate_at(rotator, 0.0, 0.0)
    sgp.sgp_draw_filled_rect(-0.5, -0.5, 1.0, 1.0)
    sgp.sgp_pop_transform()

    -- Render clay last (over the top)
    sgp.sgp_reset_project()
    renderClay(renderCommands)

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

    ffi.C.Sleep(1)
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
