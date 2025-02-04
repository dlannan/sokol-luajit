package.path    = package.path..";../../?.lua"
local dirtools  = require("tools.vfs.dirtools").init("sokol%-luajit")

--_G.SOKOL_DLL    = "sokol_debug_dll"
local sapp      = require("sokol_app")
sg              = require("sokol_gfx")
local slib      = require("sokol_libs") -- Warn - always after gfx!!

local clay      = require("clay")
local cutils    = require("clay_utils")

local hmm       = require("hmm")
local hutils    = require("hmm_utils")

local utils     = require("utils")

local ffi       = require("ffi")

-- --------------------------------------------------------------------------------------

ffi.cdef[[
/* application state */
typedef struct state {
    float rx, ry;
    sg_pipeline pip;
    sg_bindings* bind;
} state;
]]

local layoutElement = ffi.new("Clay_LayoutConfig[1]", { padding = 5 })

-- --------------------------------------------------------------------------------------
-- The nice way to take a glsl shader and load, compile and return a shader description
local shc       = require("tools.shader_compiler.shc_compile").init( "sokol%-luajit", true )
local shader    = shc.compile("./projects/examples/samples/cube-sapp.glsl")

local clay_dim  = ffi.new("Clay_Dimensions[1]", { {1024,768} })
local clay_errors = ffi.new("Clay_ErrorHandler[1]", { { errorHanderFunction = HandleClayErrors } })

-- --------------------------------------------------------------------------------------

local function logout(tag, log_level, log_item, message, line_nr, filename, user_data)
    print("-------->>> ")
    print(tag.." "..log_level.." "..log_item.." "..message.." "..line_nr.." "..filename)
end

-- --------------------------------------------------------------------------------------

local function HandleClayErrors(errorData) 
    print(string.format("%s", errorData.errorText.chars))
end

-- --------------------------------------------------------------------------------------

local state = ffi.new("state[1]")
local sg_range = ffi.new("sg_range[1]")
local binding = ffi.new("sg_bindings[1]", {})

local function init()

    local desc = ffi.new("sg_desc[1]")
    desc[0].environment = slib.sglue_environment()
    desc[0].logger.func = slib.slog_func
    desc[0].disable_validation = false
    sg.sg_setup( desc )
    print("Sokol Is Valid: "..tostring(sg.sg_isvalid()))

    local vertices = ffi.new("float[168]", {
        -1.0, -1.0, -1.0,   1.0, 0.0, 0.0, 1.0,
         1.0, -1.0, -1.0,   1.0, 0.0, 0.0, 1.0,
         1.0,  1.0, -1.0,   1.0, 0.0, 0.0, 1.0,
        -1.0,  1.0, -1.0,   1.0, 0.0, 0.0, 1.0,

        -1.0, -1.0,  1.0,   0.0, 1.0, 0.0, 1.0,
         1.0, -1.0,  1.0,   0.0, 1.0, 0.0, 1.0,
         1.0,  1.0,  1.0,   0.0, 1.0, 0.0, 1.0,
        -1.0,  1.0,  1.0,   0.0, 1.0, 0.0, 1.0,

        -1.0, -1.0, -1.0,   0.0, 0.0, 1.0, 1.0,
        -1.0,  1.0, -1.0,   0.0, 0.0, 1.0, 1.0,
        -1.0,  1.0,  1.0,   0.0, 0.0, 1.0, 1.0,
        -1.0, -1.0,  1.0,   0.0, 0.0, 1.0, 1.0,

        1.0, -1.0, -1.0,    1.0, 0.5, 0.0, 1.0,
        1.0,  1.0, -1.0,    1.0, 0.5, 0.0, 1.0,
        1.0,  1.0,  1.0,    1.0, 0.5, 0.0, 1.0,
        1.0, -1.0,  1.0,    1.0, 0.5, 0.0, 1.0,

        -1.0, -1.0, -1.0,   0.0, 0.5, 1.0, 1.0,
        -1.0, -1.0,  1.0,   0.0, 0.5, 1.0, 1.0,
         1.0, -1.0,  1.0,   0.0, 0.5, 1.0, 1.0,
         1.0, -1.0, -1.0,   0.0, 0.5, 1.0, 1.0,

        -1.0,  1.0, -1.0,   1.0, 0.0, 0.5, 1.0,
        -1.0,  1.0,  1.0,   1.0, 0.0, 0.5, 1.0,
         1.0,  1.0,  1.0,   1.0, 0.0, 0.5, 1.0,
         1.0,  1.0, -1.0,   1.0, 0.0, 0.5, 1.0
    }) 
    
    local buffer_desc           = ffi.new("sg_buffer_desc[1]")
    buffer_desc[0].data.ptr     = vertices
    buffer_desc[0].data.size    = ffi.sizeof(vertices)
    buffer_desc[0].label        = "cube-vertices"
    local vbuf = sg.sg_make_buffer(buffer_desc)

    local indices = ffi.new("uint16_t[36]", {
        0, 1, 2,  0, 2, 3,
        6, 5, 4,  7, 6, 4,
        8, 9, 10,  8, 10, 11,
        14, 13, 12,  15, 14, 12,
        16, 17, 18,  16, 18, 19,
        22, 21, 20,  23, 22, 20
    })

    local ibuffer_desc          = ffi.new("sg_buffer_desc[1]", {})
    ibuffer_desc[0].type        = sg.SG_BUFFERTYPE_INDEXBUFFER
    ibuffer_desc[0].data.ptr    = indices
    ibuffer_desc[0].data.size   = ffi.sizeof(indices) 
    ibuffer_desc[0].label       = "cube-indices"
    local ibuf = sg.sg_make_buffer(ibuffer_desc)

    local shd = sg.sg_make_shader(shader)

    local pipe_desc = ffi.new("sg_pipeline_desc[1]", {})
    pipe_desc[0].layout.buffers[0].stride = 28
    pipe_desc[0].layout.attrs[0].format = sg.SG_VERTEXFORMAT_FLOAT3
    pipe_desc[0].layout.attrs[1].format = sg.SG_VERTEXFORMAT_FLOAT4
    pipe_desc[0].shader         = shd    
    pipe_desc[0].index_type     = sg.SG_INDEXTYPE_UINT16
    pipe_desc[0].cull_mode      = sg.SG_CULLMODE_BACK
    pipe_desc[0].depth.write_enabled = true
    pipe_desc[0].depth.compare  = sg.SG_COMPAREFUNC_LESS_EQUAL
    pipe_desc[0].label          = "cube-pipeline"
    state[0].pip = sg.sg_make_pipeline(pipe_desc)

    binding[0].vertex_buffers[0] = vbuf
    binding[0].index_buffer     = ibuf
    state[0].bind               = binding

    local totalMemorySize = clay.Clay_MinMemorySize()
    local clay_mem = ffi.new("char[?]", totalMemorySize)
    clayMemory = clay.Clay_CreateArenaWithCapacityAndMemory(totalMemorySize, clay_mem);    
    clay.Clay_Initialize(clayMemory, clay_dim[0], clay_errors[0]);
end

-- --------------------------------------------------------------------------------------
local rect1 = clay.CLAY_RECTANGLE({ color = {255,255,255,0} })
local layout1 = clay.CLAY_LAYOUT(layoutElement)

local function frame()

    -- /* NOTE: the vs_params_t struct has been code-generated by the shader-code-gen */
    local w         = sapp.sapp_widthf()
    local h         = sapp.sapp_heightf()
    local t         = (sapp.sapp_frame_duration() * 60.0)

    clay.Clay_BeginLayout()
    -- clay.CLAY(rect1, layout1) {
    --     clay.CLAY_TEXT(CLAY_STRING(""), clay.CLAY_TEXT_CONFIG({ .fontId = 0 }))
    -- }
    clay.Clay_EndLayout()

    local proj      = hmm.HMM_Perspective(60.0, w/h, 0.01, 10.0)
    local view      = hmm.HMM_LookAt(hmm.HMM_Vec3(0.0, 1.5, 6.0), hmm.HMM_Vec3(0.0, 0.0, 0.0), hmm.HMM_Vec3(0.0, 1.0, 0.0))
    local view_proj = hmm.HMM_MultiplyMat4(proj, view)
    state[0].rx     = state[0].rx + 1.0 * t
    state[0].ry     = state[0].ry + 2.0 * t

    local rxm       = hmm.HMM_Rotate(state[0].rx, hmm.HMM_Vec3(1.0, 0.0, 0.0))
    local rym       = hmm.HMM_Rotate(state[0].ry, hmm.HMM_Vec3(0.0, 1.0, 0.0))
    local model     = hmm.HMM_MultiplyMat4(rxm, rym)

    local mvp       = hmm.HMM_MultiplyMat4(view_proj, model)

    local pass      = ffi.new("sg_pass[1]")
    pass[0].action.colors[0].load_action = sg.SG_LOADACTION_CLEAR
    pass[0].action.colors[0].clear_value = { 0.25, 0.5, 0.75, 1.0 }
    pass[0].swapchain = slib.sglue_swapchain()
    sg.sg_begin_pass(pass)

    sg.sg_apply_pipeline(state[0].pip)
    sg.sg_apply_bindings(state[0].bind)

    local vs_params = ffi.new("vs_params_t[1]")
    vs_params[0].mvp    = mvp
    sg_range[0].ptr     = vs_params
    sg_range[0].size    = ffi.sizeof(vs_params[0])
    sg.sg_apply_uniforms(0, sg_range)
    
    sg.sg_draw(0, 36, 1)
    sg.sg_end_pass()
    sg.sg_commit()

    -- Display frame stats in console.
    -- hutils.show_stats()
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
app_desc[0].window_title = "Cube (sokol-app)"
app_desc[0].fullscreen  = true
app_desc[0].icon.sokol_default = true 
app_desc[0].logger.func = slib.slog_func 

sapp.sapp_run( app_desc )

-- --------------------------------------------------------------------------------------
