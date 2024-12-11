package.cpath   = package.cpath..";../bin/win64/?.dll"
package.path    = package.path..";../ffi/sokol/?.lua"
package.path    = package.path..";../?.lua"

local sapp      = require("sokol_app")
local sg        = require("sokol_gfx")
local slib      = require("sokol_libs") -- Warn - always after gfx!!

local sshape    = require("sokol_shape")
local hmm       = require("hmm")

local ffi       = require("ffi")

-- --------------------------------------------------------------------------------------

local shc       = require("tools.shader_compiler.shc_compile").init( "sokol%-luajit", false )
local shader    = shc.compile("./samples/shapes-sapp.glsl")

-- --------------------------------------------------------------------------------------

ffi.cdef[[ 
    typedef struct shape_t {
        hmm_vec3 pos;
        sshape_element_range_t draw;
    } shape_t;
    
    enum {
        BOX = 0,
        PLANE,
        SPHERE,
        CYLINDER,
        TORUS,
        NUM_SHAPES
    };
    
    typedef struct state {
        sg_pass_action pass_action;
        sg_pipeline pip;
        sg_bindings* bind;
        sg_buffer vbuf;
        sg_buffer ibuf;
        shape_t shapes[NUM_SHAPES];
        float rx, ry;
    } state;
]]

-- --------------------------------------------------------------------------------------

local state = ffi.new("state[1]")
local vs_params = ffi.new("vs_params_t[1]")
local sg_range = ffi.new("sg_range[1]")

local vbuf_desc = ffi.new("sg_buffer_desc[1]")
local ibuf_desc = ffi.new("sg_buffer_desc[1]")

-- --------------------------------------------------------------------------------------

local function init()

    local sg_desc = ffi.new("sg_desc[1]")
    sg_desc[0].environment = slib.sglue_environment()
    sg_desc[0].logger.func = slib.slog_func
    sg_desc[0].disable_validation = false
    sg.sg_setup( sg_desc )

    local pass_action = ffi.new("sg_pass_action[1]", {})
    pass_action[0].colors[0].load_action = sg.SG_LOADACTION_CLEAR
    pass_action[0].colors[0].clear_value.r = 0.0
    pass_action[0].colors[0].clear_value.g = 0.0
    pass_action[0].colors[0].clear_value.b = 0.0
    pass_action[0].colors[0].clear_value.a = 1.0
    state[0].pass_action = pass_action[0]

    local shd = sg.sg_make_shader(shader)

    local pipe_desc = ffi.new("sg_pipeline_desc[1]", {})
    pipe_desc[0].shader = shd 
    pipe_desc[0].layout.buffers[0] = sshape.sshape_vertex_buffer_layout_state()

    pipe_desc[0].layout.attrs[0] = sshape.sshape_position_vertex_attr_state()
    pipe_desc[0].layout.attrs[1] = sshape.sshape_normal_vertex_attr_state()
    pipe_desc[0].layout.attrs[2] = sshape.sshape_texcoord_vertex_attr_state()
    pipe_desc[0].layout.attrs[3] = sshape.sshape_color_vertex_attr_state()
    
    pipe_desc[0].index_type = sg.SG_INDEXTYPE_UINT16
    pipe_desc[0].cull_mode = sg.SG_CULLMODE_NONE
    pipe_desc[0].depth.compare = sg.SG_COMPAREFUNC_LESS_EQUAL
    pipe_desc[0].depth.write_enabled = true
 
    state[0].pip = sg.sg_make_pipeline(pipe_desc)

    -- // shape positions
    state[0].shapes[ffi.C.BOX].pos = hmm.HMM_Vec3(-1.0, 1.0, 0.0)
    state[0].shapes[ffi.C.PLANE].pos = hmm.HMM_Vec3(1.0, 1.0, 0.0)
    state[0].shapes[ffi.C.SPHERE].pos = hmm.HMM_Vec3(-2.0, -1.0, 0.0)
    state[0].shapes[ffi.C.CYLINDER].pos = hmm.HMM_Vec3(2.0, -1.0, 0.0)
    state[0].shapes[ffi.C.TORUS].pos = hmm.HMM_Vec3(0.0, -1.0, 0.0)

    -- // generate shape geometries
    local vertices = ffi.new("sshape_vertex_t[6 * 1024]")
    local indices = ffi.new("uint16_t[16 * 1024]")
    local buf = ffi.new("sshape_buffer_t[1]")
    buf[0].vertices.buffer.ptr = vertices
    buf[0].vertices.buffer.size = ffi.sizeof(vertices) 
    buf[0].indices.buffer.ptr = indices
    buf[0].indices.buffer.size = ffi.sizeof(indices)

    -- box 
    local sshape_box = ffi.new("sshape_box_t[1]")
    sshape_box[0].width = 1.0 
    sshape_box[0].height = 1.0 
    sshape_box[0].depth = 1.0 
    sshape_box[0].tiles = 10 
    sshape_box[0].random_colors = true
    buf[0] = sshape.sshape_build_box(buf, sshape_box)
    state[0].shapes[ffi.C.BOX].draw = sshape.sshape_element_range(buf)

    local sshape_plane = ffi.new("sshape_plane_t[1]")
    sshape_plane[0].width = 1.0
    sshape_plane[0].depth = 1.0
    sshape_plane[0].tiles = 10
    sshape_plane[0].random_colors = true
    buf[0] = sshape.sshape_build_plane(buf, sshape_plane)
    state[0].shapes[ffi.C.PLANE].draw = sshape.sshape_element_range(buf)

    local sshape_sphere = ffi.new("sshape_sphere_t[1]")
    sshape_sphere[0].radius = 0.75
    sshape_sphere[0].slices = 36
    sshape_sphere[0].stacks = 20
    sshape_sphere[0].random_colors = true 
    buf[0] = sshape.sshape_build_sphere(buf, sshape_sphere)
    state[0].shapes[ffi.C.SPHERE].draw = sshape.sshape_element_range(buf)

    local sshape_cylinder = ffi.new("sshape_cylinder_t[1]")
    sshape_cylinder[0].radius = 0.5 
    sshape_cylinder[0].height = 1.5
    sshape_cylinder[0].slices = 36
    sshape_cylinder[0].stacks = 10
    sshape_cylinder[0].random_colors = true
    buf[0] = sshape.sshape_build_cylinder(buf, sshape_cylinder)
    state[0].shapes[ffi.C.CYLINDER].draw = sshape.sshape_element_range(buf)

    local sshape_torus = ffi.new("sshape_torus_t[1]")
    sshape_torus[0].radius = 0.5 
    sshape_torus[0].ring_radius =  0.3
    sshape_torus[0].rings = 36
    sshape_torus[0].sides = 18
    sshape_torus[0].random_colors = true 
    buf[0] = sshape.sshape_build_torus(buf, sshape_torus)
    state[0].shapes[ffi.C.TORUS].draw = sshape.sshape_element_range(buf)
    
    assert(buf[0].valid)

    --// one vertex/index-buffer-pair for all shapes
    vbuf_desc[0] = sshape.sshape_vertex_buffer_desc(buf)
    ibuf_desc[0] = sshape.sshape_index_buffer_desc(buf)

    state[0].vbuf = sg.sg_make_buffer(vbuf_desc)
    state[0].ibuf = sg.sg_make_buffer(ibuf_desc)

    bindings = ffi.new("sg_bindings[1]", {})
    bindings[0].vertex_buffers[0] = state[0].vbuf
    bindings[0].index_buffer = state[0].ibuf
    state[0].bind = bindings
end

-- --------------------------------------------------------------------------------------


local function frame()

    -- // view-projection matrix...
    local proj = hmm.HMM_Perspective(60.0, sapp.sapp_widthf()/sapp.sapp_heightf(), 0.01, 10.0)
    local view = hmm.HMM_LookAt(hmm.HMM_Vec3(0.0, 1.5, 6.0), hmm.HMM_Vec3(0.0, 0.0, 0.0), hmm.HMM_Vec3(0.0, 1.0, 0.0))
    local view_proj = hmm.HMM_MultiplyMat4(proj, view)

    -- // model-rotation matrix
    local t = (sapp.sapp_frame_duration() * 60.0)

    state[0].rx = state[0].rx + 1.0 * t
    state[0].ry = state[0].ry + 2.0 * t
    local rxm = hmm.HMM_Rotate(state[0].rx, hmm.HMM_Vec3(1.0, 0.0, 0.0))
    local rym = hmm.HMM_Rotate(state[0].ry, hmm.HMM_Vec3(0.0, 1.0, 0.0))
    local rm = hmm.HMM_MultiplyMat4(rxm, rym)

    -- // render shapes...
    local pass = ffi.new("sg_pass[1]")
    pass[0].action = state[0].pass_action
    pass[0].swapchain = sg.sglue_swapchain()
    sg.sg_begin_pass(pass)

    sg.sg_apply_pipeline(state[0].pip)
    
    sg.sg_apply_bindings(bindings)

    for i = 0, ffi.C.NUM_SHAPES-1 do
        -- // per shape model-view-projection matrix
        local model = hmm.HMM_MultiplyMat4(hmm.HMM_Translate(state[0].shapes[i].pos), rm)
        vs_params[0].mvp = hmm.HMM_MultiplyMat4(view_proj, model)

        sg_range[0].ptr = vs_params
        sg_range[0].size = ffi.sizeof(vs_params)
        
        sg.sg_apply_uniforms(sg.SG_SHADERSTAGE_VS, 0, sg_range)
        sg.sg_draw(state[0].shapes[i].draw.base_element, state[0].shapes[i].draw.num_elements, 1)
    end
    sg.sg_end_pass();
    sg.sg_commit();
end

-- --------------------------------------------------------------------------------------

local function input( ev )

    if( ev.type == sapp.SAPP_EVENTTYPE_KEY_DOWN) then 

        if(ev.key_code == sapp.SAPP_KEYCODE_1) then vs_params[0].draw_mode = 0
        elseif(ev.key_code == sapp.SAPP_KEYCODE_2) then vs_params[0].draw_mode = 1
        elseif(ev.key_code == sapp.SAPP_KEYCODE_3) then vs_params[0].draw_mode = 2
        end
    end
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
app_desc[0].event_cb = input
app_desc[0].width = 800 
app_desc[0].height = 600
app_desc[0].sample_count = 4
app_desc[0].window_title = "Shapes (sokol-app)"
app_desc[0].icon.sokol_default = true 
app_desc[0].logger.func = slib.slog_func 

sapp.sapp_run( app_desc )

-- --------------------------------------------------------------------------------------