
-- A mesh is a specific mesh resource. 
--   It contains _only_
--   - vertices         * required
--   - indices          * required
--   - texcoords 
--   - normals
--   - colors
--   - tangents 
--   - custom stream data. 

-- These are created as buffers and can be used as needed. 

local ffi           = require("ffi")

local utils         = require("lua.utils")
local imageutils 	= require("lua.gltfloader.image-utils")
local cgltf      	= require("ffi.sokol.cgltf")

local tinsert       = table.insert

-- --------------------------------------------------------------------------------------

local shc           = require("tools.shader_compiler.shc_compile").init( "dim", false )

-- ----------------------------------------------------------------------------------------

local all_meshes = {
    materials   = {},           -- A material shader cache.
}

-- ----------------------------------------------------------------------------------------

local MESH_TYPE    = {
    MTYPE_TRIANGLES   = 1, 
    MTYPE_TRI_STRIP   = 2,
    MTYPE_POINTS      = 3,        -- These use special shaders
    MTYPE_LINES       = 4,        -- These use special shaders
}

-- ----------------------------------------------------------------------------------------

local mesh = {
    id          = 0,        -- internal id for the engine
    priority    = 0,        -- rendering information
    binid       = 0,        -- current render bin assignment (transparent/opaque/custom)
    type        = MESH_TYPE.MTYPE_TRIANGLES,
    vertices    = nil,      -- vert buf 
    indices     = nil,      -- This can be nil. If so, triangles are rendered in order.
    streams     = {},       -- The above attached streams of data (uvs, norms, etc)
}

--- Load the types into the main library (so external systems can use it)
for k,v in pairs(MESH_TYPE) do 
    mesh[k]=v
end

-- ----------------------------------------------------------------------------------------
-- Buffer creation tool
mesh.create_buffer     = function(name, buffers)

    -- Make a mesh table with the info we need to build the pipeline and bindings.
    -- Buffers need to be interleaved with data sets, so we do this here. 
    local vertcount     = 0 

    local stride      = 0
    local attribs     = {}
    local float_size  = ffi.sizeof("float")
    local offset      = 0

    if(buffers.vertices) then 
        
        vertcount = ffi.sizeof(buffers.vertices) / (3 * float_size)
        stride = 3
        tinsert(attribs, { offset = offset, format = sg.SG_VERTEXFORMAT_FLOAT3 })

        if(buffers.uvs) then 
            stride = stride + 2
            offset = offset + 3 * float_size
            tinsert(attribs, { offset = offset, format = sg.SG_VERTEXFORMAT_FLOAT2 })
        end
        if(buffers.normals) then 
            stride = stride + 3
            offset = offset + 5 * float_size
            tinsert(attribs, { offset = offset, format = sg.SG_VERTEXFORMAT_FLOAT3 })
        end
        if(buffers.colors) then 
            stride = stride + 4
            offset = offset + 8 * float_size
            tinsert(attribs, { offset = offset, format = sg.SG_VERTEXFORMAT_FLOAT4 })
        end
    end

    local buffs = {
        vbuf   = nil,
        vcount  = vertcount,
        ibuf   = nil,
        icount  = 0,
        sbuf   = nil,
        scount  = 0,
        stride  = stride,
        attrs   = attribs,
        depth   = {},
    }

    if(buffers.indices) then 
        buffs.icount = buffers.icount
        buffs.index_type = buffers.itype
    end

    local uvptr = nil
    local nptr = nil
    local cptr = nil
    if(buffers.vertices) then 
        local buffer = ffi.new("float[?]", vertcount * stride)
        local vptr = ffi.cast("float *", buffers.vertices)

        if(buffers.uvs) then uvptr = ffi.cast("float *", buffers.uvs) end
        if(buffers.normals) then nptr = ffi.cast("float *", buffers.normals) end
        if(buffers.colors) then cptr = ffi.cast("float *", buffers.colors) end

        -- Copy in interlaced! 
        local ptr = ffi.cast("float *", buffer) 
        for i=1, vertcount do 
            ffi.copy(ptr, vptr,  3 * float_size)
            vptr = vptr + 3
            ptr = ptr + 3

            if(buffers.uvs) then 
                ffi.copy(ptr, uvptr, 2* float_size)
                uvptr = uvptr + 2
                ptr = ptr + 2
            end
            if(buffers.normals) then 
                ffi.copy(ptr, nptr,  3* float_size)
                nptr = nptr + 3
                ptr = ptr + 3
            end
            if(buffers.colors) then 
                ffi.copy(ptr, cptr,  4* float_size)
                cptr = cptr + 4
                ptr = ptr + 4
            end
        end
        -- buffer should now have interlaced data
        if(ffi.sizeof(buffer) > 0) then 
            local buffer_desc           = ffi.new("sg_buffer_desc[1]")
            buffer_desc[0].type         = sg.SG_BUFFERTYPE_VERTEXBUFFER 
            buffer_desc[0].data.ptr     = buffer
            buffer_desc[0].data.size    = ffi.sizeof(buffer)
            buffer_desc[0].label        = name.."-vertices"
            buffs.vbuf = sg.sg_make_buffer(buffer_desc)
        else 
            return nil         
        end
    end

    if(buffers.indices) then
        if(ffi.sizeof(buffers.indices) > 0) then 
            local buffer_desc           = ffi.new("sg_buffer_desc[1]")
            buffer_desc[0].type         = sg.SG_BUFFERTYPE_INDEXBUFFER 
            buffer_desc[0].data.ptr     = buffers.indices
            buffer_desc[0].data.size    = ffi.sizeof(buffers.indices)
            buffer_desc[0].label        = name.."-indices"
            buffs.ibuf = sg.sg_make_buffer(buffer_desc)    
        else 
            return nil         
        end
    end

    if(buffers.storage) then 
        if(ffi.sizeof(buffers.storage) > 0) then 
            local buffer_desc           = ffi.new("sg_buffer_desc[1]")
            buffer_desc[0].type         = sg.SG_BUFFERTYPE_STORAGEBUFFER
            buffer_desc[0].data.ptr     = buffers.storage
            buffer_desc[0].data.size    = ffi.sizeof(buffers.storage)
            buffer_desc[0].label        = name.."-storage"
            buffs.sbuf = sg.sg_make_buffer(buffer_desc)     
        else 
            return nil         
        end        
    end

    return buffs
end

-- ----------------------------------------------------------------------------------------
-- Create an image to be used to texture geom or render textures

mesh.image = function(name, rt, width, height, format, samples )
    local img_desc = ffi.new("sg_image_desc[1]")
    img_desc[0].render_target   = rt or false
    img_desc[0].width           = width or 512
    img_desc[0].height          = height or 512
    img_desc[0].pixel_format    = format or sg.SG_PIXELFORMAT_RGBA8
    img_desc[0].sample_count    = samples or 1
    img_desc[0].label           = name
    return sg.sg_make_image(img_desc)
end

-- ----------------------------------------------------------------------------------------
-- Create a material from shader and params
mesh.material  = function(name, shaderfile, params)

    local cached = all_meshes.materials[shaderfile]
    if(cached) then return cached end

    local shader    = shc.compile(shaderfile)
    local shd       = sg.sg_make_shader(shader)

    local sampler_desc      = ffi.new("sg_sampler_desc")
    sampler_desc.min_filter = sg.SG_FILTER_LINEAR
    sampler_desc.mag_filter = sg.SG_FILTER_LINEAR
    sampler_desc.wrap_u     = sg.SG_WRAP_REPEAT
    sampler_desc.wrap_v     = sg.SG_WRAP_REPEAT
    sampler_desc.wrap_w     = sg.SG_WRAP_REPEAT  -- only needed for 3D textures
    
    local default_sampler = sg.sg_make_sampler(sampler_desc)

    if(shd) then 
        local material = {
            shader          = shd, 
            params          = params,
            name            = name, 
            base_color_smp  = default_sampler,
        }
        all_meshes.materials[shaderfile] = material
        return material
    else 
        print("[Error mesh.material] Could not create material: "..tostring(name))
        return nil 
    end
end

-- ----------------------------------------------------------------------------------------
-- Model makes a pipeline 
mesh.make_mesh = function(name, buffers)

    local mesh = { layout = {}, depth = {}, aabb = buffers.aabb }

    local buffercount = utils.tcount(buffers)
    if(buffercount == 0) then 
        print("[Error mesh.make_mesh] No buffers to process!")
        return nil 
    end
    mesh.layout.buffers = ffi.new("sg_vertex_buffer_layout_state[8]")
    mesh.layout.attrs   = ffi.new("sg_vertex_attr_state[16]")
    -- One attr for each buffer
    for bi, buffer in ipairs(buffers) do
        
        if(buffer) then 
            mesh.layout.buffers[bi-1].stride = buffer.stride * ffi.sizeof("float")
        end

        if(buffer.index_type) then 
            mesh.index_type = buffer.index_type
        end

        if(buffer.cull_mode) then 
            mesh.cullmode = buffer.cullmode
        end

        if(buffer.attrs) then 
            for i, attr in ipairs(buffer.attrs) do
                mesh.layout.attrs[i-1].format = attr.format
                mesh.layout.attrs[i-1].offset = attr.offset
            end
        end

        if(mesh.depth) then 
            mesh.depth = ffi.new("sg_depth_state")
            if(buffer.depth.write_enabled) then 
                mesh.depth.write_enabled = buffer.depth.write_enabled
            end
            if(buffer.depth.compare) then 
                mesh.depth.compare = buffer.depth.compare
            end
        end

        mesh.vbuf = buffer.vbuf
        mesh.ibuf = buffer.ibuf
        mesh.sbuf = buffer.sbuf    
    end

    return mesh
end

-- ----------------------------------------------------------------------------------------
-- Model makes a pipeline 
mesh.model     = function(name, prim, mesh, material)

    -- Stores material with mesh - this should be an index
    -- mesh.material = material

    local pipe_desc = ffi.new("sg_pipeline_desc[1]", {})
    pipe_desc[0].layout.buffers         = mesh.layout.buffers
    pipe_desc[0].layout.attrs           = mesh.layout.attrs
    pipe_desc[0].shader                 = material.shader 

    if(mesh.index_type) then pipe_desc[0].index_type = mesh.index_type end
    if(mesh.cull_mode) then pipe_desc[0].cull_mode = mesh.cull_mode end
    if(mesh.depth) then 
        if(mesh.depth.write_enabled) then pipe_desc[0].depth.write_enabled = mesh.depth.write_enabled end
        if(mesh.depth.compare) then pipe_desc[0].depth.compare = mesh.depth.compare end
    end
    if(prim.material.alpha_mode == cgltf.cgltf_alpha_mode_blend) then 
        pipe_desc[0].colors[0].blend.enabled = true
        pipe_desc[0].colors[0].blend.src_factor_rgb = sg.SG_BLENDFACTOR_SRC_ALPHA
        pipe_desc[0].colors[0].blend.dst_factor_rgb = sg.SG_BLENDFACTOR_ONE_MINUS_SRC_ALPHA
        pipe_desc[0].colors[0].blend.src_factor_alpha = sg.SG_BLENDFACTOR_ONE
        pipe_desc[0].colors[0].blend.dst_factor_alpha = sg.SG_BLENDFACTOR_ONE_MINUS_SRC_ALPHA
    elseif(prim.material.alpha_mode == cgltf.cgltf_alpha_mode_mask) then 

    end

    pipe_desc[0].label                  = name.."-pipeline"

    local pipeline = sg.sg_make_pipeline(pipe_desc)
    
    local binding = ffi.new("sg_bindings[1]", {})
    binding[0].vertex_buffers[0]       = mesh.vbuf
    if(mesh.ibuf) then binding[0].index_buffer = mesh.ibuf end

    local mesh_mat = prim.material
    local tex = nil
    if(mesh_mat and mesh_mat.images) then 
        if(mesh_mat.images.base_color ~= nil) then
            local img = mesh_mat.images.base_color.img or sg.sg_make_image(mesh_mat.images.base_color.info)
            binding[0].images[0]   = img
            tex = true 
        end
    end
    if(tex == nil) then 
        binding[0].images[0]   =  imageutils.default_white_image
    end
    if(material.base_color_smp ~= nil) then
        binding[0].samplers[0] = material.base_color_smp  -- the sampler        
    end
    return {
        pip     = pipeline,
        bind    = binding,
        alpha   = { mode = prim.material.alpha_mode, cutoff = prim.material.alpha_cutoff }
    }
end 

-- ----------------------------------------------------------------------------------------

return mesh 

-- ----------------------------------------------------------------------------------------