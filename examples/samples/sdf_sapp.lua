package.cpath   = package.cpath..";../bin/win64/?.dll"
package.path    = package.path..";../ffi/sokol/?.lua"
package.path    = package.path..";../?.lua"

--_G.SOKOL_DLL    = "sokol_debug_dll"
local sapp      = require("sokol_app")
local sg        = require("sokol_gfx")
local slib      = require("sokol_libs") -- Warn - always after gfx!!
local hmm       = require("hmm")
local hutils    = require("hmm_utils")

local ffi = require("ffi")

-- --------------------------------------------------------------------------------------
-- The nice way to take a glsl shader and load, compile and return a shader description
local shc       = require("tools.shc_compile").init( "sokol%-luajit", true )
local shader    = shc.compile("./samples/sdf-sapp.glsl")

-- --------------------------------------------------------------------------------------

ffi.cdef[[
/* application state */
typedef struct state {
    sg_pass_action pass_action;
    vs_params_t *vs_params;
    sg_pipeline pip;
    sg_bindings* bind;
} state;
]]

-- --------------------------------------------------------------------------------------

local state = ffi.new("state[1]")
local binding = ffi.new("sg_bindings[1]", {})
local vs_params = ffi.new("vs_params_t[1]")
local vs_params_range = ffi.new("sg_range[1]")
local pass = ffi.new("sg_pass[1]")

-- --------------------------------------------------------------------------------------

local function init()

    local desc = ffi.new("sg_desc[1]")
    desc[0].environment = slib.sglue_environment()
    desc[0].logger.func = slib.slog_func
    sg.sg_setup( desc )
    print("Sokol Is Valid: "..tostring(sg.sg_isvalid()))

    local fsq_verts = ffi.new("float[6]", { -1.0, -3.0, 3.0, 1.0, -1.0, 1.0 })

    local buffer_inf = ffi.new("sg_buffer_desc[1]")
    buffer_inf[0].data.ptr = fsq_verts
    buffer_inf[0].data.size = ffi.sizeof(fsq_verts)
    buffer_inf[0].label = "fsq vertices"

    --// a vertex buffer to render a 'fullscreen triangle'
    state[0].bind = binding
    state[0].bind[0].vertex_buffers[0] = sg.sg_make_buffer(buffer_inf)

    local shd = sg.sg_make_shader(shader)

    local pipe_desc = ffi.new("sg_pipeline_desc[1]")
    pipe_desc[0].shader = shd 
    pipe_desc[0].layout.attrs[0].format = sg.SG_VERTEXFORMAT_FLOAT2     -- vs_position float2
    pipe_desc[0].label = "fsq-pipeline"

    state[0].pip = sg.sg_make_pipeline(pipe_desc)
    state[0].pass_action.colors[0].load_action = sg.SG_LOADACTION_DONTCARE

    state[0].vs_params = vs_params

    pass[0].action = state[0].pass_action
end

-- --------------------------------------------------------------------------------------

local function frame()

    local w = sapp.sapp_widthf()
    local h = sapp.sapp_heightf()

    state[0].vs_params[0].time = state[0].vs_params.time + sapp.sapp_frame_duration()
    state[0].vs_params[0].aspect = w / h

    pass[0].swapchain = sg.sglue_swapchain()
    
    sg.sg_begin_pass(pass)
    sg.sg_apply_pipeline(state[0].pip)
    sg.sg_apply_bindings(state[0].bind)

    vs_params_range[0].ptr = state[0].vs_params
    vs_params_range[0].size = ffi.sizeof(state[0].vs_params[0])
    sg.sg_apply_uniforms(sg.SG_SHADERSTAGE_VS, 0, vs_params_range);

    sg.sg_draw(0, 3, 1)
    sg.sg_end_pass()
    sg.sg_commit()
end

-- --------------------------------------------------------------------------------------

local function cleanup()
    sg.sg_shutdown()
end

-- --------------------------------------------------------------------------------------

local app_desc = ffi.new("sapp_desc[1]")
app_desc[0].init_cb     = init
app_desc[0].frame_cb    = frame
app_desc[0].cleanup_cb  = cleanup
app_desc[0].width       = 1920
app_desc[0].height      = 1080
app_desc[0].window_title = "SDF Example (sokol-app)"
app_desc[0].icon.sokol_default = true 
app_desc[0].logger.func = slib.slog_func 

sapp.sapp_run( app_desc )

-- --------------------------------------------------------------------------------------
