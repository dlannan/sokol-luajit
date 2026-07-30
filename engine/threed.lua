
local sapp          = require("sokol_app")
local nk            = sg
local stb           = require("stb")

local hmm           = require("hmm")
local hutils        = require("hmm_utils")

local ffi           = require("ffi")

local utils         = require("lua.utils")

local cameramgr     = require("lua.engine.camera_manager")
local geomutils     = require("lua.loaders.geometry-utils")

local tinsert       = table.insert
local tremove       = table.remove

-- --------------------------------------------------------------------------------------
-- TODO: Make better handler for this.
local MAX_STATES            = 1024
local CAM_DISTANCE          = 6.0 

-- --------------------------------------------------------------------------------------
-- This is a global - prob not a great idea, but there should only ever be one per process!
threed_renderer     = {
    render_queue        = {},
    model_load_queue    = {},

    -- A mapped list of model files by the file name
    --  These indicate whether a model is loaded, if it has an id and if it 
    --  has had its data initialised
    model_files         = {},

    default_cam         = cameramgr.add("default", 60.0, 1, 0.01, CAM_DISTANCE * 2),
} 

-- --------------------------------------------------------------------------------------

local shc       = require("tools.shader_compiler.shc_compile").init( "worldbuilder", false )
local shader    = nil

-- --------------------------------------------------------------------------------------

threed_renderer.make_cube = function()

    shader    = shader or shc.compile("lua/engine/shaders/cube_simple.glsl")
    -- Make a fake model to use for testing
    local state = ffi.new("internal_state[1]")
    local binding = ffi.new("sg_bindings[1]", {})   

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

    return { state = state, binding = binding }
end

-- --------------------------------------------------------------------------------------

local function render_model( dt, model_rect )

    local aabb = model_rect.model.data.mesh.aabb
    local maxx = aabb.max.x - aabb.min.x
    local maxy = aabb.max.y - aabb.min.y
    local maxz = aabb.max.z - aabb.min.z
    local maxsize = math.sqrt( maxx * maxx + maxy * maxy + maxz * maxz)
    local sc = CAM_DISTANCE * 0.85 / maxsize * model_rect.model.scale

    local offset = hmm.HMM_V3(aabb.min.x + maxx * 0.5, aabb.min.y + maxy * 0.5, aabb.min.z + maxz * 0.5)
    offset.x, offset.y, offset.z = offset.x * sc, offset.y * sc, offset.x * sc

    local w, h      = model_rect.w, model_rect.h
    -- Dont render if there is no width or height?
    if(w <= 0 or h <= 0) then return end 

    cameramgr.set_nearfar( model_rect.cam, 0.01, CAM_DISTANCE * 2 * model_rect.model.scale )
    cameramgr.set_aspect( model_rect.cam, w/h )
    cameramgr.lookat( model_rect.cam, hmm.HMM_V3(0.0, (offset.y + 1.5), -CAM_DISTANCE), hmm.HMM_V3(0.0, offset.y, 0.0), hmm.HMM_V3(0.0, -1.0, 0.0))
    local view_proj = cameramgr.get_view_proj(model_rect.cam)
    local view = cameramgr.get_view(model_rect.cam)

    local model_all_geom = model_rect.model.data.mesh.all_geom
    model_rect.model.data.mesh.camera = model_rect.cam

    cameramgr.update_viewport( model_rect.cam, hmm.HMM_V4(0, 0, 1024, 1024))
    cameramgr.update_scissor( model_rect.cam, hmm.HMM_V4(0, 0, 1024, 1024))
    local thiscam = cameramgr.get_id( model_rect.cam )

    for i, geom_id in ipairs(model_all_geom) do 

        local geom      = geomutils.all_objs[geom_id]
        geom.rx        = 0.0
        geom.ry        = geom.ry + dt * 3.0
        -- geom.fs_params[0].alpha_cutoff = 0.9
        -- geom.fs_params[0].alpha_mode = 2
        geom.dstate[0].state = 0x01

        local pos = hmm.HMM_V3(0, 0, 0)
        local angles = hmm.HMM_V3(geom.rx, geom.ry, 0.0)
        local model = geomutils.model_matrix( geom.transform, pos, angles, sc)
        geom.vs_params[0].mvp    = hmm.HMM_MulM4(view_proj, model)
    end
end

-- --------------------------------------------------------------------------------------
-- Hides all the vertex buffers associated with this model
threed_renderer.hide_model = function(model)
    if (model.loaded == true) then 
        local model_all_geom = model.data.mesh.all_geom
        for i, geom_id in ipairs(model_all_geom) do 
            local geom      = geomutils.all_objs[geom_id]
            geom.dstate[0].state = 0x0
        end
    end
end

-- --------------------------------------------------------------------------------------
-- This doesnt directly load a model in case it happens during an incorrent phase of rendering
threed_renderer.load_model = function(filename, params)

    -- Check first if it hasnt been loaded already! 
    local is_loaded = threed_renderer.model_load_queue[filename]
    if(is_loaded) then 
        return is_loaded
    end

    local new_model = { loaded = nil, filename = filename, params = params }
    threed_renderer.model_load_queue[filename] = new_model
    return new_model
end

-- --------------------------------------------------------------------------------------
-- Draw the model based on an xy rect position (not 3d space).
--  This queues model rects for drawing in the correct phase of the frame. 
threed_renderer.draw_model = function(model, x, y, w, h)

    if (model.loaded == true) then 
        tinsert(threed_renderer.render_queue, { cam=model.data.camera, model=model, x=x, y=y, w=w, h=h })
    end
end

-- --------------------------------------------------------------------------------------
-- Iterate the queued rects and render models into them
-- Rects should _not_ be here if they are hidden (ie in a hidden tab)
threed_renderer.load_models = function()

    if(utils.tcount(threed_renderer.model_load_queue) == 0) then return end

    -- print("queued models", count)
    for k,model_load in pairs(threed_renderer.model_load_queue) do
        if(model_load.loaded == nil and model_load.params.do_load) then
            model_load.data = model_load.params.do_load( model_load )
            if(model_load.data) then 
                -- model_load.data = threed_renderer.make_cube()
                model_load.loaded = true
            else 
                -- Remove model that cant be loaded.
                threed_renderer.model_load_queue[k] = nil 
            end
        end
    end
end

-- --------------------------------------------------------------------------------------
-- Iterate the queued rects and render models into them
-- Rects should _not_ be here if they are hidden (ie in a hidden tab)
threed_renderer.render_rects = function( dt )

    local count = #threed_renderer.render_queue 
    -- print("queued models", count)
    for i=1, count do
        local model_rect = threed_renderer.render_queue[i]
        render_model(dt, model_rect)
    end
end

-- --------------------------------------------------------------------------------------
