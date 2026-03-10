package.path    = package.path..";../../?.lua"
local dirtools  = require("tools.vfs.dirtools").init("sokol%-luajit")

--_G.SOKOL_DLL    = "sokol_debug_dll"
local sapp      = require("sokol_app")
sg              = require("sokol_gfx")
sg              = require("sokol_nuklear")
local nk        = sg
local slib      = require("sokol_libs") -- Warn - always after gfx!!

local sshape    = require("sokol_shape")
local hmm       = require("hmm")
local hutils    = require("hmm_utils")

local stb       = require("stb")

local ffi       = require("ffi")

-- --------------------------------------------------------------------------------------
-- The nice way to take a glsl shader and load, compile and return a shader description
local shc       = require("tools.shader_compiler.shc_compile").init( "sokol%-luajit", false )

-- Need to use default because this is whats used for first unnamed program
local default   = shc.compile("./projects/examples/samples/offscreen-sapp.glsl", "default")
local offscreen = shc.compile("./projects/examples/samples/offscreen-sapp.glsl", "offscreen")

-- --------------------------------------------------------------------------------------

local OFFSCREEN_PIXEL_FORMAT = (sg.SG_PIXELFORMAT_RGBA8)
local OFFSCREEN_SAMPLE_COUNT = 1
local DISPLAY_SAMPLE_COUNT = 4

-- --------------------------------------------------------------------------------------

ffi.cdef[[ 
    typedef struct state {
        struct {
            sg_pass * pass;
            sg_pipeline pip;
            sg_bindings * bind;
        } offscreen;
        struct {
            sg_pass_action pass_action;
            sg_pipeline pip;
            sg_bindings * bind;
        } display;
        struct nk_image color_image;
        sshape_element_range_t donut;
        sshape_element_range_t sphere;
        float rx, ry;
    } state; 
]]

local state = ffi.new("state[1]")

local display_bind = ffi.new("sg_bindings[1]", {})
local offscreen_bind = ffi.new("sg_bindings[1]", {})
local off_pass = ffi.new("sg_pass[1]")

-- --------------------------------------------------------------------------------------
-- returns struct nk_image
local function icon_load(filename)

    local x = ffi.new("int[1]", {0})
    local y = ffi.new("int[1]", {0})
    local n = ffi.new("int[1]", {4})
    local data = stb.stbi_load(filename, x, y, nil, 4)
    if (data == nil) then error("[STB]: failed to load image: "..filename); end

    print("Image Loaded: "..filename.."      Width: "..x[0].."  Height: "..y[0].."  Channels: "..n[0])

    local pixformat =  sg.SG_PIXELFORMAT_RGBA8

    local sg_img_desc = ffi.new("sg_image_desc[1]")
    sg_img_desc[0].width = x[0]
    sg_img_desc[0].height = y[0]
    sg_img_desc[0].pixel_format = pixformat
    sg_img_desc[0].sample_count = 1
    
    sg_img_desc[0].data.subimage[0][0].ptr = data
    sg_img_desc[0].data.subimage[0][0].size = x[0] * y[0] * n[0]

    local new_img = sg.sg_make_image(sg_img_desc)

    -- // create a sokol-nuklear image object which associates an sg_image with an sg_sampler
    local img_desc = ffi.new("snk_image_desc_t[1]")
    img_desc[0].image = new_img
    local snk_img = nk.snk_make_image(img_desc)
    local nk_hnd = nk.snk_nkhandle(snk_img)
    local nk_img = nk.nk_image_handle(nk_hnd);

    stb.stbi_image_free(data)
    return nk_img
end

-- --------------------------------------------------------------------------------------

local pix = {}

local function init()

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

    local base_path = "projects/examples/samples/"
    pix["baboon"] = icon_load(base_path.."images/baboon.png")

    local offscreen_shader = sg.sg_make_shader(offscreen)
    local default_shader = sg.sg_make_shader(default)  

    local pass_action = ffi.new("sg_pass_action[1]")
    pass_action[0].colors[0].load_action = sg.SG_LOADACTION_CLEAR
    pass_action[0].colors[0].clear_value = { 0.25, 0.45, 0.65, 1.0 }
    state[0].display.pass_action = pass_action[0]

    -- // setup a render pass struct with one color and one depth render attachment image
    -- // NOTE: we need to explicitly set the sample count in the attachment image objects,
    -- // because the offscreen pass uses a different sample count than the display render pass
    -- // (the display render pass is multi-sampled, the offscreen pass is not)
    local img_desc = ffi.new("sg_image_desc[1]")
    img_desc[0].render_target = true
    img_desc[0].width = 256
    img_desc[0].height = 256
    img_desc[0].pixel_format = OFFSCREEN_PIXEL_FORMAT
    img_desc[0].sample_count = OFFSCREEN_SAMPLE_COUNT
    img_desc[0].label = "color-image"
    local color_img = sg.sg_make_image(img_desc)

    local nk_img_desc = ffi.new("snk_image_desc_t[1]")
    nk_img_desc[0].image = color_img
    local snk_img = nk.snk_make_image(nk_img_desc)
    local nk_hnd = nk.snk_nkhandle(snk_img)
    local nk_img = nk.nk_image_handle(nk_hnd);
    state[0].color_image = nk_img

    img_desc[0].pixel_format = sg.SG_PIXELFORMAT_DEPTH
    img_desc[0].label = "depth-image";
    local depth_img = sg.sg_make_image(img_desc)

    local att_desc = ffi.new("sg_attachments_desc[1]")
    att_desc[0].colors[0].image = color_img
    att_desc[0].depth_stencil.image = depth_img
    att_desc[0].label = "offscree-attachments"

    off_pass[0].attachments = sg.sg_make_attachments(att_desc)
    off_pass[0].action.colors[0].load_action = sg.SG_LOADACTION_CLEAR
    off_pass[0].action.colors[0].clear_value = { 0.25, 0.25, 0.25, 1.0 }
    off_pass[0].label = "offscreen-pass"
    state[0].offscreen.pass = off_pass

    -- // a donut shape which is rendered into the offscreen render target, and
    -- // a sphere shape which is rendered into the default framebuffer
    local vertices = ffi.new("sshape_vertex_t[4000]", {})
    local indices = ffi.new("uint16_t[24000]", { 0 })
    local buf = ffi.new("sshape_buffer_t[1]")
    buf[0].vertices.buffer.ptr = vertices
    buf[0].vertices.buffer.size = ffi.sizeof(vertices)
    buf[0].indices.buffer.ptr = indices 
    buf[0].indices.buffer.size = ffi.sizeof(indices)
    
    local shape_torus = ffi.new("sshape_torus_t[1]", {})
    shape_torus[0].radius = 0.5 
    shape_torus[0].ring_radius = 0.3 
    shape_torus[0].sides = 20 
    shape_torus[0].rings = 36
    buf[0] = sshape.sshape_build_torus(buf, shape_torus)

    state[0].donut = sshape.sshape_element_range(buf)

    local shape_sphere = ffi.new("sshape_sphere_t[1]", {})
    shape_sphere[0].radius = 0.5 
    shape_sphere[0].slices = 72
    shape_sphere[0].stacks = 40 

    buf[0] = sshape.sshape_build_sphere(buf, shape_sphere)
    state[0].sphere = sshape.sshape_element_range(buf)

    local vbuf_desc = ffi.new("sg_buffer_desc[1]")
    vbuf_desc[0] = sshape.sshape_vertex_buffer_desc(buf)
    local ibuf_desc = ffi.new("sg_buffer_desc[1]")
    ibuf_desc[0] = sshape.sshape_index_buffer_desc(buf)
    vbuf_desc[0].label = "shape-vbuf"
    ibuf_desc[0].label = "shape-ibuf"
    local vbuf = sg.sg_make_buffer(vbuf_desc)
    local ibuf = sg.sg_make_buffer(ibuf_desc)

    -- // pipeline-state-object for offscreen-rendered donut
    -- // NOTE: we need to explicitly set the sample_count here because
    -- // the offscreen pass uses a different sample count than the default
    -- // pass (the display pass is multi-sampled, but the offscreen pass isn't)

    local pipeline = ffi.new("sg_pipeline_desc[1]")
    pipeline[0].layout.buffers[0] = sshape.sshape_vertex_buffer_layout_state()
    pipeline[0].layout.attrs[0] = sshape.sshape_position_vertex_attr_state()
    pipeline[0].layout.attrs[1] = sshape.sshape_normal_vertex_attr_state()
    pipeline[0].shader = offscreen_shader
    pipeline[0].index_type = sg.SG_INDEXTYPE_UINT16
    pipeline[0].cull_mode = sg.SG_CULLMODE_BACK
    pipeline[0].sample_count = OFFSCREEN_SAMPLE_COUNT
    pipeline[0].depth.pixel_format = sg.SG_PIXELFORMAT_DEPTH
    pipeline[0].depth.compare = sg.SG_COMPAREFUNC_LESS_EQUAL
    pipeline[0].depth.write_enabled = true 
    pipeline[0].colors[0].pixel_format = OFFSCREEN_PIXEL_FORMAT
    pipeline[0].label = "offscreen-pipeline"
    state[0].offscreen.pip = sg.sg_make_pipeline(pipeline)

    -- // and another pipeline-state-object for the default pass
    local pipe_desc = ffi.new("sg_pipeline_desc[1]")
    pipe_desc[0].layout.buffers[0] = sshape.sshape_vertex_buffer_layout_state()
    pipe_desc[0].layout.attrs[0] = sshape.sshape_position_vertex_attr_state()
    pipe_desc[0].layout.attrs[1] = sshape.sshape_normal_vertex_attr_state()
    pipe_desc[0].layout.attrs[2] = sshape.sshape_texcoord_vertex_attr_state()
    pipe_desc[0].shader = default_shader
    pipe_desc[0].index_type = sg.SG_INDEXTYPE_UINT16
    pipe_desc[0].cull_mode = sg.SG_CULLMODE_BACK
    pipe_desc[0].depth.compare = sg.SG_COMPAREFUNC_LESS_EQUAL
    pipe_desc[0].depth.write_enabled = true
    pipe_desc[0].label = "default-pipeline"
    state[0].display.pip = sg.sg_make_pipeline(pipe_desc)

    -- // a sampler object for sampling the render target texture
    local sampler = ffi.new("sg_sampler_desc[1]")
    sampler[0].min_filter = sg.SG_FILTER_LINEAR
    sampler[0].mag_filter = sg.SG_FILTER_LINEAR
    sampler[0].wrap_u = sg.SG_WRAP_REPEAT
    sampler[0].wrap_v = sg.SG_WRAP_REPEAT
    local smp = sg.sg_make_sampler(sampler)

    -- // the resource bindings for rendering a non-textured shape into offscreen render target
    offscreen_bind[0].vertex_buffers[0] = vbuf
    offscreen_bind[0].index_buffer = ibuf
    state[0].offscreen.bind = offscreen_bind

    -- // resource bindings to render a textured shape, using the offscreen render target as texture
    display_bind[0].vertex_buffers[0] = vbuf
    display_bind[0].index_buffer = ibuf
    display_bind[0].images[0] = color_img
    display_bind[0].samplers[0] = smp
    state[0].display.bind = display_bind
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
-- Static vars 
-- 
--  Note: Many vars are locally set or globals. This was from a direct C conversion. 
--        To make static vars workaround then place them below.

local show_menu     = ffi.new("bool[1]", {nk.nk_true})
local border        = ffi.new("bool[1]", {nk.nk_true})
local resize        = ffi.new("bool[1]", {nk.nk_true})
local movable       = ffi.new("bool[1]", {nk.nk_true})
local no_scrollbar  = ffi.new("bool[1]", {nk.nk_false})
local scale_left    = ffi.new("bool[1]", {nk.nk_false})
local winrect       = ffi.new("struct nk_rect[1]", {{10, 25, 1000, 600}})

-- /* window flags */
local window_flags = 0
local minimizable = ffi.new("bool[1]", {nk.nk_true})

-- /* popups */
local header_align = nk.NK_HEADER_RIGHT

-- --------------------------------------------------------------------------------------

local function draw_demo_ui(ctx)

    -- /* window flags */
    ctx[0].style.window.header.align = header_align
    if (border[0] ==  true) then window_flags = bit.bor(window_flags, nk.NK_WINDOW_BORDER) end
    if (resize[0] == true) then window_flags = bit.bor(window_flags, nk.NK_WINDOW_SCALABLE) end
    if (movable[0] == true) then window_flags = bit.bor(window_flags, nk.NK_WINDOW_MOVABLE) end
    if (no_scrollbar[0] == true) then window_flags = bit.bor(window_flags, nk.NK_WINDOW_NO_SCROLLBAR) end
    if (scale_left[0] == true) then window_flags = bit.bor(window_flags, nk.NK_WINDOW_SCALE_LEFT) end
    if (minimizable[0] == true) then window_flags = bit.bor(window_flags, nk.NK_WINDOW_MINIMIZABLE) end

    if (nk.nk_begin(ctx, "PNG View", winrect[0], window_flags) == true) then
        nk.nk_layout_row_begin(ctx, nk.NK_STATIC, 500, 5)
        nk.nk_layout_row_push(ctx, 600)

        -- nk.nk_image(ctx, pix["baboon"])
        nk.nk_image(ctx, state[0].color_image)
    end
    nk.nk_end(ctx)
    return not nk.nk_window_is_closed(ctx, "Overview")        
end 

-- --------------------------------------------------------------------------------------

local vs_params = ffi.new("vs_params_t[1]")
local def_vs_params = ffi.new("vs_params_t[1]")
local vs_range = ffi.new("sg_range[1]")
local def_vs_range = ffi.new("sg_range[1]")

local function frame()

    local ctx = nk.snk_new_frame(false)

    local t = (sapp.sapp_frame_duration() * 60.0)
    state[0].rx = state[0].rx + 1.0 * t
    state[0].ry = state[0].ry + 2.0 * t

    -- // the offscreen pass, rendering an rotating, untextured donut into a render target image
    vs_params[0].mvp = compute_mvp(state[0].rx, state[0].ry, 1.0, 2.5)

    vs_range[0].ptr = vs_params
    vs_range[0].size = ffi.sizeof(vs_params)

    sg.sg_begin_pass(state[0].offscreen.pass)
    sg.sg_apply_pipeline(state[0].offscreen.pip)
    sg.sg_apply_bindings(state[0].offscreen.bind)
    sg.sg_apply_uniforms(sg.SG_SHADERSTAGE_VS, vs_range)
    sg.sg_draw(state[0].donut.base_element, state[0].donut.num_elements, 1)
    sg.sg_end_pass()

    -- // and the display-pass, rendering a rotating textured sphere which uses the
    -- // previously rendered offscreen render-target as texture
    local w = sapp.sapp_width()
    local h = sapp.sapp_height()
    def_vs_params[0].mvp = compute_mvp(-state[0].rx * 0.25, state[0].ry * 0.25, w/h, 3.0)
    
    -- local pass = ffi.new("sg_pass[1]")
    -- pass[0].action = state[0].display.pass_action
    -- pass[0].swapchain = slib.sglue_swapchain()
    -- pass[0].label = "swapchain-pass"
    -- sg.sg_begin_pass(pass)

    -- def_vs_range[0].ptr = def_vs_params
    -- def_vs_range[0].size = ffi.sizeof(def_vs_params)

    -- sg.sg_apply_pipeline(state[0].display.pip)
    -- sg.sg_apply_bindings(state[0].display.bind)
    -- sg.sg_apply_uniforms(sg.SG_SHADERSTAGE_VS, def_vs_range)
    -- sg.sg_draw(state[0].sphere.base_element, state[0].sphere.num_elements, 1)
    -- sg.sg_end_pass()

    draw_demo_ui(ctx)

    -- // the sokol_gfx draw pass
    local pass = ffi.new("sg_pass[1]")
    pass[0].action.colors[0].load_action = sg.SG_LOADACTION_CLEAR
    pass[0].action.colors[0].clear_value = { 0.25, 0.5, 0.7, 1.0 }
    pass[0].swapchain = slib.sglue_swapchain()
    sg.sg_begin_pass(pass)

    nk.snk_render(sapp.sapp_width(), sapp.sapp_height())
    sg.sg_end_pass()

    sg.sg_commit()

    -- Display frame stats in console.
    -- hutils.show_stats()
end

-- --------------------------------------------------------------------------------------

local function input(event) 
    nk.snk_handle_event(event)
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
app_desc[0].width = 1920
app_desc[0].height = 1080
app_desc[0].sample_count = DISPLAY_SAMPLE_COUNT
app_desc[0].window_title = "Offscreen (sokol-app)"
app_desc[0].icon.sokol_default = true 
app_desc[0].logger.func = slib.slog_func 

sapp.sapp_run( app_desc )

-- --------------------------------------------------------------------------------------