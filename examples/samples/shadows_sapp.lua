package.path    = package.path..";../?.lua"
local dirtools  = require("tools.dirtools").init("sokol%-luajit")

--_G.SOKOL_DLL    = "sokol_debug_dll"
local sapp      = require("ffi.sokol.sokol_app")
local sg        = require("ffi.sokol.sokol_gfx")
local slib      = require("ffi.sokol.sokol_libs") -- Warn - always after gfx!!

local hmm       = require("ffi.sokol.hmm")
local hutils    = require("ffi.sokol.hmm_utils")

local utils     = require("lua.utils")

local ffi       = require("ffi")

-- --------------------------------------------------------------------------------------
-- Shader debug enabled
local shc       = require("tools.shc_compile").init( "sokol%-luajit", false )

-- Need to use default because this is whats used for first unnamed program
local shadow_shader   = shc.compile("./samples/shadows-sapp.glsl", "shadow")
local display_shader  = shc.compile("./samples/shadows-sapp.glsl", "display")
local dbg_shader      = shc.compile("./samples/shadows-sapp.glsl", "dbg")

-- --------------------------------------------------------------------------------------

ffi.cdef[[ 
    typedef struct state {
        sg_image shadow_map;
        sg_sampler shadow_sampler;
        sg_buffer vbuf;
        sg_buffer ibuf;
        float ry;
        struct {
            sg_pass_action pass_action;
            sg_attachments atts;
            sg_pipeline pip;
            sg_bindings * bind;
        } shadow;
        struct {
            sg_pass_action pass_action;
            sg_pipeline pip;
            sg_bindings * bind;
        } display;
        struct {
            sg_pipeline pip;
            sg_bindings * bind;
        } dbg;
    } state;
]]

local state = ffi.new("state[1]")

local display_bind = ffi.new("sg_bindings[1]", {})

-- --------------------------------------------------------------------------------------

local function init()

    local sg_desc = ffi.new("sg_desc[1]")
    sg_desc[0].environment = slib.sglue_environment()
    sg_desc[0].logger.func = slib.slog_func
    sg.sg_setup( sg_desc )
    print("Sokol Is Valid: "..tostring(sg.sg_isvalid()))

    local vertices = ffi.new("float[196]", {
        
        -1.0, -1.0, -1.0,    0.0, 0.0, -1.0, 
         1.0, -1.0, -1.0,    0.0, 0.0, -1.0,
         1.0,  1.0, -1.0,    0.0, 0.0, -1.0,
        -1.0,  1.0, -1.0,    0.0, 0.0, -1.0,

        -1.0, -1.0,  1.0,    0.0, 0.0, 1.0,  
         1.0, -1.0,  1.0,    0.0, 0.0, 1.0,
         1.0,  1.0,  1.0,    0.0, 0.0, 1.0,
        -1.0,  1.0,  1.0,    0.0, 0.0, 1.0,

        -1.0, -1.0, -1.0,    -1.0, 0.0, 0.0, 
        -1.0,  1.0, -1.0,    -1.0, 0.0, 0.0,
        -1.0,  1.0,  1.0,    -1.0, 0.0, 0.0,
        -1.0, -1.0,  1.0,    -1.0, 0.0, 0.0,

         1.0, -1.0, -1.0,    1.0, 0.0, 0.0,  
         1.0,  1.0, -1.0,    1.0, 0.0, 0.0,
         1.0,  1.0,  1.0,    1.0, 0.0, 0.0,
         1.0, -1.0,  1.0,    1.0, 0.0, 0.0,

        -1.0, -1.0, -1.0,    0.0, -1.0, 0.0, 
        -1.0, -1.0,  1.0,    0.0, -1.0, 0.0,
         1.0, -1.0,  1.0,    0.0, -1.0, 0.0,
         1.0, -1.0, -1.0,    0.0, -1.0, 0.0,

        -1.0,  1.0, -1.0,    0.0, 1.0, 0.0,  
        -1.0,  1.0,  1.0,    0.0, 1.0, 0.0,
         1.0,  1.0,  1.0,    0.0, 1.0, 0.0,
         1.0,  1.0, -1.0,    0.0, 1.0, 0.0,

        -5.0,  0.0, -5.0,    0.0, 1.0, 0.0,  
        -5.0,  0.0,  5.0,    0.0, 1.0, 0.0,
         5.0,  0.0,  5.0,    0.0, 1.0, 0.0,
         5.0,  0.0, -5.0,    0.0, 1.0, 0.0,
         1.0,  1.0, -1.0,   1.0, 0.0, 0.5, 1.0
    }) 
    
    local buffer_desc           = ffi.new("sg_buffer_desc[1]")
    buffer_desc[0].data.ptr     = vertices
    buffer_desc[0].data.size    = ffi.sizeof(vertices)
    buffer_desc[0].label        = "cube-vertices"
    local vbuf = sg.sg_make_buffer(buffer_desc)

    local indices = ffi.new("uint16_t[42]", {
        0, 1, 2,  0, 2, 3,
        6, 5, 4,  7, 6, 4,
        8, 9, 10,  8, 10, 11,
        14, 13, 12,  15, 14, 12,
        16, 17, 18,  16, 18, 19,
        22, 21, 20,  23, 22, 20,
        26, 25, 24,  27, 26, 24
    })

    local ibuffer_desc          = ffi.new("sg_buffer_desc[1]", {})
    ibuffer_desc[0].type        = sg.SG_BUFFERTYPE_INDEXBUFFER
    ibuffer_desc[0].data.ptr    = indices
    ibuffer_desc[0].data.size   = ffi.sizeof(indices) 
    ibuffer_desc[0].label       = "cube-indices"
    local ibuf = sg.sg_make_buffer(ibuffer_desc)

    local pass_action = ffi.new("sg_pass_action[1]")
    pass_action[0].colors[0].load_action = sg.SG_LOADACTION_CLEAR
    pass_action[0].colors[0].clear_value = { 1.0, 1.0, 1.0, 1.0 }
    state[0].shadow.pass_action = pass_action[0]

    local disp_pass_action = ffi.new("sg_pass_action[1]")
    disp_pass_action[0].colors[0].load_action = sg.SG_LOADACTION_CLEAR
    disp_pass_action[0].colors[0].clear_value = { 0.25, 0.5, 0.25, 1.0 }
    state[0].display.pass_action = disp_pass_action[0]

    local img_desc = ffi.new("sg_image_desc[1]")
    img_desc[0].render_target = true
    img_desc[0].width = 2048
    img_desc[0].height = 2048
    img_desc[0].pixel_format = sg.SG_PIXELFORMAT_RGBA8
    img_desc[0].sample_count = 1
    img_desc[0].label = "shadow-map"
    state[0].shadow_map = sg.sg_make_image(img_desc)

    img_desc = ffi.new("sg_image_desc[1]")
    img_desc[0].render_target = true
    img_desc[0].width = 2048
    img_desc[0].height = 2048
    img_desc[0].pixel_format = sg.SG_PIXELFORMAT_DEPTH
    img_desc[0].sample_count = 1
    img_desc[0].label = "shadow-depth-buffer"
    local shadow_depth_img = sg.sg_make_image(img_desc)

    local sampler = ffi.new("sg_sampler_desc[1]")
    sampler[0].min_filter = sg.SG_FILTER_NEAREST
    sampler[0].mag_filter = sg.SG_FILTER_NEAREST
    sampler[0].wrap_u = sg.SG_WRAP_CLAMP_TO_EDGE
    sampler[0].wrap_v = sg.SG_WRAP_CLAMP_TO_EDGE
    sampler[0].label = "shadow-sampler"
    state[0].shadow_sampler = sg.sg_make_sampler(sampler)    

    local att_desc = ffi.new("sg_attachments_desc[1]")
    att_desc[0].colors[0].image = state[0].shadow_map
    att_desc[0].depth_stencil.image = shadow_depth_img
    att_desc[0].label = "shado-pass"
    state[0].shadow.atts = sg.sg_make_attachments(att_desc)

    local pipeline = ffi.new("sg_pipeline_desc[1]")
    pipeline[0].layout.buffers[0].stride = 6 * ffi.sizeof("float")
    pipeline[0].layout.attrs[0].format = sg.SG_VERTEXFORMAT_FLOAT3
    pipeline[0].shader = sg.sg_make_shader(shadow_shader)
    pipeline[0].index_type = sg.SG_INDEXTYPE_UINT16
    pipeline[0].cull_mode = sg.SG_CULLMODE_FRONT
    pipeline[0].sample_count = 1
    pipeline[0].colors[0].pixel_format = sg.SG_PIXELFORMAT_RGBA8
    pipeline[0].depth.pixel_format = sg.SG_PIXELFORMAT_DEPTH
    pipeline[0].depth.compare = sg.SG_COMPAREFUNC_LESS_EQUAL
    pipeline[0].depth.write_enabled = true 
    pipeline[0].label = "shadow-pipeline"
    state[0].shadow.pip = sg.sg_make_pipeline(pipeline)

    shadow_bind = ffi.new("sg_bindings[1]")
    shadow_bind[0].vertex_buffers[0] = vbuf
    shadow_bind[0].index_buffer = ibuf
    state[0].shadow.bind = shadow_bind

    local pipe_desc = ffi.new("sg_pipeline_desc[1]")
    pipe_desc[0].layout.attrs[0].format = sg.SG_VERTEXFORMAT_FLOAT3
    pipe_desc[0].layout.attrs[1].format = sg.SG_VERTEXFORMAT_FLOAT3
    pipe_desc[0].shader = sg.sg_make_shader(display_shader)
    pipe_desc[0].index_type = sg.SG_INDEXTYPE_UINT16
    pipe_desc[0].cull_mode = sg.SG_CULLMODE_BACK
    pipe_desc[0].depth.compare = sg.SG_COMPAREFUNC_LESS_EQUAL
    pipe_desc[0].depth.write_enabled = true
    pipe_desc[0].label = "display-pipeline"
    state[0].display.pip = sg.sg_make_pipeline(pipe_desc)

    display_bind = ffi.new("sg_bindings[1]")
    display_bind[0].vertex_buffers[0] = vbuf
    display_bind[0].index_buffer = ibuf
    display_bind[0].fs.images[0] = state[0].shadow_map
    display_bind[0].fs.samplers[0] = state[0].shadow_sampler
    state[0].display.bind = display_bind

    local dbg_vertices = ffi.new("float[8]", { 0.0, 0.0,  1.0, 0.0,  0.0, 1.0,  1.0, 1.0 })
    local dbg_buffer_desc           = ffi.new("sg_buffer_desc[1]")
    dbg_buffer_desc[0].data.ptr     = dbg_vertices
    dbg_buffer_desc[0].data.size    = ffi.sizeof(dbg_vertices)
    dbg_buffer_desc[0].label        = "debug-vertices"
    local dbg_vbuf = sg.sg_make_buffer(dbg_buffer_desc)    

    local dbg_pipe_desc = ffi.new("sg_pipeline_desc[1]")
    dbg_pipe_desc[0].layout.attrs[0].format = sg.SG_VERTEXFORMAT_FLOAT2
    dbg_pipe_desc[0].shader = sg.sg_make_shader(dbg_shader)
    dbg_pipe_desc[0].primitive_type = sg.SG_PRIMITIVETYPE_TRIANGLE_STRIP
    dbg_pipe_desc[0].label = "debug-pipeline"
    state[0].dbg.pip = sg.sg_make_pipeline(dbg_pipe_desc)

    local dbg_sampler = ffi.new("sg_sampler_desc[1]")
    dbg_sampler[0].min_filter = sg.SG_FILTER_NEAREST
    dbg_sampler[0].mag_filter = sg.SG_FILTER_NEAREST
    dbg_sampler[0].wrap_u = sg.SG_WRAP_CLAMP_TO_EDGE
    dbg_sampler[0].wrap_v = sg.SG_WRAP_CLAMP_TO_EDGE
    dbg_sampler[0].label = "debug-sampler"
    local dbg_sampler = sg.sg_make_sampler(dbg_sampler)

    dbg_bind = ffi.new("sg_bindings[1]")
    dbg_bind[0].vertex_buffers[0] = dbg_vbuf
    dbg_bind[0].fs.images[0] = state[0].shadow_map
    dbg_bind[0].fs.samplers[0] = dbg_sampler
    state[0].dbg.bind = dbg_bind
end

-- --------------------------------------------------------------------------------------
-- // helper function to compute model-view-projection matrix
local function compute_mvp( rx,  ry,  aspect, eye_dist) 
    local proj = hmm.HMM_Perspective(45.0, aspect, 0.01, 10.0)
    local view = hmm.HMM_LookAt(hmm.HMM_Vec3(0.0, 0.0, eye_dist), hmm.HMM_Vec3(0.0, 0.0, 0.0), hmm.HMM_Vec3(0.0, 1.0, 0.0))
    local view_proj = hmm.HMM_MultiplyMat4(proj, view)
    local rxm = hmm.HMM_Rotate(rx, hmm.HMM_Vec3(1.0, 0.0, 0.0))
    local rym = hmm.HMM_Rotate(ry, hmm.HMM_Vec3(0.0, 1.0, 0.0))
    local model = hmm.HMM_MultiplyMat4(rym, rxm)
    local mvp = hmm.HMM_MultiplyMat4(view_proj, model)
    return mvp
end

-- --------------------------------------------------------------------------------------

local def_vs_range = ffi.new("sg_range[1]")
local plane_vs_range = ffi.new("sg_range[1]")
local cube_vs_range = ffi.new("sg_range[1]")
local disp_fs_range = ffi.new("sg_range[1]")

local function frame()

    local t = (sapp.sapp_frame_duration() * 60.0)
    state[0].ry = state[0].ry + 0.2 * t


    local eye_pos = hmm.HMM_Vec3(5.0, 5.0, 5.0)
    local plane_model = hmm.HMM_Mat4d(1.0)
    local cube_model = hmm.HMM_Translate(hmm.HMM_Vec3(0.0, 1.5, 0.0))
    local plane_color = hmm.HMM_Vec3(1.0, 0.5, 0.0)
    local cube_color = hmm.HMM_Vec3(0.5, 0.5, 1.0)

    -- // calculate matrices for shadow pass
    local rym = hmm.HMM_Rotate(state[0].ry, hmm.HMM_Vec3(0.0, 1.0, 0.0))
    local light_pos = hmm.HMM_MultiplyMat4ByVec4(rym, hmm.HMM_Vec4(50.0, 50.0, -50.0, 1.0))
    local light_view = hmm.HMM_LookAt(light_pos.XYZ, hmm.HMM_Vec3(0.0, 1.5, 0.0), hmm.HMM_Vec3(0.0, 1.0, 0.0))
    local light_proj = hmm.HMM_Orthographic(-5.0, 5.0, -5.0, 5.0, 0, 100.0)
    local light_view_proj = hmm.HMM_MultiplyMat4(light_proj, light_view)

    local cube_vs_shadow_params = ffi.new("vs_shadow_params_t[1]")
    cube_vs_shadow_params[0].mvp = hmm.HMM_MultiplyMat4(light_view_proj, cube_model)

    -- // calculate matrices for display pass
    local proj = hmm.HMM_Perspective(60.0, sapp.sapp_widthf()/sapp.sapp_heightf(), 0.01, 100.0)
    local view = hmm.HMM_LookAt(eye_pos, hmm.HMM_Vec3(0.0, 0.0, 0.0), hmm.HMM_Vec3(0.0, 1.0, 0.0))
    local view_proj = hmm.HMM_MultiplyMat4(proj, view)

    local fs_display_params = ffi.new("fs_display_params_t[1]")
    fs_display_params[0].light_dir = hmm.HMM_NormalizeVec3(light_pos.XYZ)
    fs_display_params[0].eye_pos = eye_pos

    local plane_vs_display_params = ffi.new("vs_display_params_t[1]")
    plane_vs_display_params[0].mvp = hmm.HMM_MultiplyMat4(view_proj, plane_model)
    plane_vs_display_params[0].model = plane_model
    plane_vs_display_params[0].light_mvp = hmm.HMM_MultiplyMat4(light_view_proj, plane_model)
    plane_vs_display_params[0].diff_color = plane_color

    local cube_vs_display_params = ffi.new("vs_display_params_t[1]")
    cube_vs_display_params[0].mvp = hmm.HMM_MultiplyMat4(view_proj, cube_model)
    cube_vs_display_params[0].model = cube_model
    cube_vs_display_params[0].light_mvp = hmm.HMM_MultiplyMat4(light_view_proj, cube_model)
    cube_vs_display_params[0].diff_color = cube_color
    

    local pass = ffi.new("sg_pass[1]")
    pass[0].action = state[0].shadow.pass_action
    pass[0].attachments = state[0].shadow.atts
    sg.sg_begin_pass(pass)

    def_vs_range[0].ptr = cube_vs_shadow_params
    def_vs_range[0].size = ffi.sizeof(cube_vs_shadow_params)

    sg.sg_apply_pipeline(state[0].shadow.pip)
    sg.sg_apply_bindings(state[0].shadow.bind)
    sg.sg_apply_uniforms(sg.SG_SHADERSTAGE_VS, 0, def_vs_range)
    sg.sg_draw(0, 36, 1)
    sg.sg_end_pass()

    local disp_pass = ffi.new("sg_pass[1]")
    disp_pass[0].action = state[0].display.pass_action
    disp_pass[0].swapchain = slib.sglue_swapchain()
    sg.sg_begin_pass(disp_pass)

    disp_fs_range[0].ptr = fs_display_params
    disp_fs_range[0].size = ffi.sizeof(fs_display_params)

    plane_vs_range[0].ptr = plane_vs_display_params
    plane_vs_range[0].size = ffi.sizeof(plane_vs_display_params)

    cube_vs_range[0].ptr = cube_vs_display_params
    cube_vs_range[0].size = ffi.sizeof(cube_vs_display_params)

    sg.sg_apply_pipeline(state[0].display.pip)
    sg.sg_apply_bindings(state[0].display.bind)
    sg.sg_apply_uniforms(sg.SG_SHADERSTAGE_FS, 0, disp_fs_range)
    sg.sg_apply_uniforms(sg.SG_SHADERSTAGE_VS, 0, plane_vs_range)
    sg.sg_draw(36, 6, 1)

    sg.sg_apply_uniforms(sg.SG_SHADERSTAGE_VS, 0, cube_vs_range)
    sg.sg_draw(0, 36, 1)

    sg.sg_apply_pipeline(state[0].dbg.pip)
    sg.sg_apply_bindings(state[0].dbg.bind)
    sg.sg_apply_viewport(sapp.sapp_widthf() - 150, 0, 150, 150, false)
    sg.sg_draw(0, 4, 1)

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
app_desc[0].init_cb = init
app_desc[0].frame_cb = frame
app_desc[0].cleanup_cb = cleanup
app_desc[0].width = 800
app_desc[0].height = 600
app_desc[0].sample_count = 4
app_desc[0].window_title = "Shadows (sokol-app)"
app_desc[0].icon.sokol_default = true 
app_desc[0].logger.func = slib.slog_func 

sapp.sapp_run( app_desc )

-- --------------------------------------------------------------------------------------