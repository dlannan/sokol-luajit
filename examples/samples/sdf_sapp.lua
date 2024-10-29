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

ffi.cdef[[
/* application state */
typedef struct state {
    sg_pass_action pass_action;
    vs_params_t vs_params;
    sg_pipeline pip;
    sg_bindings* bind;
}
]]

-- --------------------------------------------------------------------------------------

local state = ffi.new("state[1]")
local sg_range = ffi.new("sg_range[1]")
local binding = ffi.new("sg_bindings[1]", {})

local function init()

    local desc = ffi.new("sg_desc[1]")
    desc[0].environment = slib.sglue_environment()
    desc[0].logger.func = slib.slog_func
    sg.sg_setup( desc )
    print("Sokol Is Valid: "..tostring(sg.sg_isvalid()))

    local fsq_verts = ffi.new("float[6]", { -1.0, -3.0, 3.0, 1.0, -1.0, 1.0 })

    local buffer_inf = ffi.new("sg_buffer_desc[1]")
    buffer_inf[0].data.ptr = fsq_verts
    buffer_inf[0].data.size = 6 * ffi.sizeof("float")
    buffer_inf[0].label = "fsq vertices"

    --// a vertex buffer to render a 'fullscreen triangle'
    state.bind.vertex_buffers[0] = sg_make_buffer(buffer_inf)

    local pipe_desc = ffi.new("sg_pipeline_desc[1]")
    pipe_desc[0].shader = shd 
    pipe_desc[0].layout.attrs[0].format = 2     -- vs_position float2
    pipe_desc[0].label = "fsq-pipeline"

    state[0].pip = sg.sg_make_pipeline(pipe_desc)

    local pass_action = ffi.new("sg_pass_action[1]")
    pass_action[0].colors[0].load_action = sg.SG_LOADACTION_DONTCARE
    state[0].pass_action = pass_action[0]
end

local function frame()

    local pass = ffi.new("sg_pass[1]")
    pass[0].action = state[0].pass_action
    pass[0].swapchain = sg.sglue_swapchain()
    
    sg.sg_begin_pass(pass)
    sg.sg_apply_pipeline(state[0].pip)
    sg.sg_apply_bindings(state[0].bind)
    sg.sg_draw(0, 3, 1)
    sg.sg_end_pass()
    sg.sg_commit()
end

local function cleanup()
    sg.sg_shutdown()
end