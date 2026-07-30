-- ---------------------------------------------------------------------------------------------------
-- bins
--    All geometry ends up in a binding, pipeline, uniforms and draw calls. 
--    So to make this more efficient, geometry buffers (vert, uv, index, normals and others) are 
--    organized in two main bin categories.
--    Main category: Priority - this is the main ordering of rendering. 
--                   The higher the priority id the further down the list of rendering. 
--                   Thus bins with priority 1 are highest, and are rendered first. 
--    Secondary category: Shader order id - this is the ordering within a bin.
--                   The higher the shader order id, also the further down the list of rendering within a bin 
--                   Thus geometry can be ordered within a priority bin 
--                   This is most often happening when the render engine does specifc types of sorting
-- 
--  Notes: Initially the shader order id, will not be managed or used. To be implemented later if
--         needed (which is expected)
-- 
--
--  bin default priority ranges. 
--    bins will have ranges for specific types of shaders and geometry. 
--    If a material is tagged with transparent, or opaque then the geometry will be 
--    added to the transparent or opaque bins respectively.
--  
--    The default bin priority ranges are fixed. And _shall_ _not_ change for the duration of the
--    development of the rendering engine. READ THIS: THEY ARE FIXED. DO NOT CHANGE!
-- 
--  pass
--    A pass is a collection of bin ids to render together. 
--    Thus while you might have an ordered set of geom in bins, they can be associated
--    with a specific pass if needed - even multiple passes eg:
--             when rendering to texture then rendering the same geometry to the display, or;
--             rendering one geometry as transparent, and one in the gui.
--
--  geometry 
--    The geometry object is specifically:
--      1. A set of buffers (vert, index, etc)
--      2. An associated material id 
--      3. Unifrom data - for vs, and fs uniforms when preparing the shaders before draw.
--      4. The offset and length of the draw call. This allows for the same buffers to be 
--         used with different materials or uniform data.
--    When the bin is created, it will do so for the buffers, and assign them an id. If the same
--      buffers are submitted again, it will lookup these and use them. Minimizing duplication. 
-- ---------------------------------------------------------------------------------------------------

local sapp      = require("sokol_app")
sg              = require("sokol_gfx")
sg              = require("sokol_nuklear")
local nk        = sg
local slib      = require("sokol_libs") -- Warn - always after gfx!!
local hmm       = require("hmm")
local hutils    = require("hmm_utils")

local utils     = require("lua.utils")

local cammgr    = require("lua.engine.camera_manager")

local ffi       = require("ffi")

-- ---------------------------------------------------------------------------------------------------

local tinsert   = table.insert
local tcount    = table.getn

-- ---------------------------------------------------------------------------------------------------

local bintype = {
    BTYPE_CUSTOM_BG       = 0x1000,
    BTYPE_BACKGROUND      = 0x2000,
    BTYPE_TRANSPARENT     = 0x4000,
    BTYPE_CUT_OUT         = 0x6000,
    BTYPE_OPAQUE          = 0x8000,
    BTYPE_GUI             = 0xA000,
    BTYPE_CUSTOM_GUI      = 0xC000,
    BTYPE_CUSTOM_OVERLAY  = 0xD000,
}

-- bins can be inserted (use the management methods to do so!!)
local default_bins = {
    [bintype.BTYPE_CUSTOM_BG]       = {},
    [bintype.BTYPE_BACKGROUND]      = {},
    [bintype.BTYPE_TRANSPARENT]     = {},
    [bintype.BTYPE_CUT_OUT]         = {},
    [bintype.BTYPE_OPAQUE]          = {},
    [bintype.BTYPE_GUI]             = {},
    [bintype.BTYPE_CUSTOM_GUI]      = {},
    [bintype.BTYPE_CUSTOM_OVERLAY]  = {},    
}

local default_bin_order = {
    BTYPE_CUSTOM_BG,
    BTYPE_BACKGROUND,
    BTYPE_TRANSPARENT,
    BTYPE_CUT_OUT,
    BTYPE_OPAQUE,
    BTYPE_GUI,
    BTYPE_CUSTOM_GUI,
    BTYPE_CUSTOM_OVERLAY,
}

-- --------------------------------------------------------------------------------------
-- A ultra base bin_state object - this is what is stored in the bins
--
--  Note: params may move from here. TBA.
ffi.cdef[[
typedef struct bin_state {
    sg_range        *vs_params;
    int             vs_block_index;
    sg_range        *fs_params;
    int             fs_block_index;

    sg_pipeline     pip;
    sg_bindings*    bind;

    uint8_t         state;          // Visibility, and other important flags
    int             offset; 
    int             count;
    int             instances;
} bin_state;

]]

-- ---------------------------------------------------------------------------------------------------
-- A table (like a class) to handle the main singleton of bins. 
--     Note: This could be extended to have multiple bins if needed.
local bin_mgr       = {}

-- ---------------------------------------------------------------------------------------------------

bin_mgr.init = function() 

    bin_mgr.bins        = utils.deepcopy(default_bins)
    bin_mgr.passes      = { }
    bin_mgr.cameras     = { }

    for k,v in pairs(bintype) do 
        bin_mgr[k] = v
    end
end

-- ---------------------------------------------------------------------------------------------------
-- TODO: Need to deal with this. Will become a fast lookup for numerous items
local cache = {}

bin_mgr.bin_add_geom = function(geom) 

    local vs_range      = nil
    if(geom.vs_params) then 
        vs_range = ffi.new("sg_range[1]")
        vs_range[0].ptr     = geom.vs_params
        vs_range[0].size    = ffi.sizeof(ffi.typeof(geom.vs_params[0]))
        tinsert(cache, vs_range)
    end

    local fs_range      = nil
    if(geom.fs_params) then 
        fs_range = ffi.new("sg_range[1]")
        fs_range[0].ptr     = geom.fs_params
        fs_range[0].size    = ffi.sizeof(geom.fs_params[0])
        tinsert(cache, fs_range)
    end

    local dstate = ffi.new("bin_state[1]",{})
    dstate[0].vs_params     = vs_range
    dstate[0].vs_block_index = 0    -- Need to fix
    dstate[0].fs_params     = fs_range 
    dstate[0].fs_block_index = 0    -- Need to fix

    dstate[0].pip       = geom.pip
    dstate[0].bind      = geom.bind
    dstate[0].state     = 0

    dstate[0].offset    = geom.offset or 0
    -- Assert will prob be temporary. Will capture this upstream. 
    assert(geom.count ~= nil or geom.count ~= 0, "[render bin_add] Invalid geometry count for mesh.")
    dstate[0].count     = geom.count or 0
    dstate[0].instances = geom.instances or 1

    local bin_slot      = bintype.BTYPE_OPAQUE 
    if(geom.bintype) then bin_slot = geom.bintype end
    
    -- Insert into known bin slot
    local thebin = bin_mgr.bins[bin_slot]
    if(thebin) then 
        tinsert(bin_mgr.bins[bin_slot], dstate )

    -- Insert into newly created bin slot
    else 
        bin_mgr.bins[bin_slot] = { dstate }
    end

    return bin_slot, dstate
end

-- ---------------------------------------------------------------------------------------------------

bin_mgr.camera_add = function( cameraid, front )

    if(cammgr.is_active(cameraid)) then 
        if(front) then 
            tinsert(bin_mgr.cameras, 1, cameraid)
        else
            tinsert(bin_mgr.cameras, cameraid)
        end
    end
end 

-- ---------------------------------------------------------------------------------------------------
-- Need a way to order passes on submission
bin_mgr.pass_add = function(pdata, index, front, attach)

    local thispass      = ffi.new("sg_pass[1]")
    thispass[0].action.colors[0].load_action = pdata.action
    if(pdata.clear) then thispass[0].action.colors[0].clear_value = pdata.clear end 

    if(attach) then 
        thispass[0].attachments = attach
    else 
        thispass[0].swapchain   = slib.sglue_swapchain()
    end

    local binpass = { 
        pass = thispass,
        binlist = {},
        offscreen = attach ~= nil,
    }

    if(index) then 
        binpass.binlist = { index }
    else 
        binpass.binlist = { bins.BTYPE_OPAQUE }
    end
        
    local passid = 1
    if(not front) then 
        passid = tcount(bin_mgr.passes) + 1
    end
    bin_mgr.passes[passid] = binpass
    return passid
end

-- ---------------------------------------------------------------------------------------------------

bin_mgr.add_offscreen_buffers = function(w, h)

    local img_desc = ffi.new("sg_image_desc[1]")
    img_desc[0].render_target = true
    img_desc[0].width = w
    img_desc[0].height = h
    img_desc[0].pixel_format = sg.SG_PIXELFORMAT_RGBA8
    img_desc[0].sample_count = 1
    img_desc[0].label = "color-image"
    local color_img = sg.sg_make_image(img_desc)

    img_desc[0].pixel_format = sg.SG_PIXELFORMAT_DEPTH
    img_desc[0].label = "depth-image";
    local depth_img = sg.sg_make_image(img_desc)

    local att_desc = ffi.new("sg_attachments_desc[1]")
    att_desc[0].colors[0].image = color_img
    att_desc[0].depth_stencil.image = depth_img
    att_desc[0].label = "offscreen-attachments"    
    local attach = sg.sg_make_attachments(att_desc)

    -- local p_action = ffi.new("sg_pass_action[1]")
    -- p_action[0].colors[0].load_action = sg.SG_LOADACTION_CLEAR,
    -- p_action[0].colors[0].clear_value = { 0.0f, 0.0f, 0.0f, 1.0f }

    -- // create a sokol-nuklear image object which associates an sg_image with an sg_sampler
    local img_desc = ffi.new("snk_image_desc_t[1]")
    img_desc[0].image = color_img
    local snk_img = nk.snk_make_image(img_desc)
    local nk_hnd = nk.snk_nkhandle(snk_img)
    local nk_img = nk.nk_image_handle(nk_hnd)

    return attach, nk_img, depth_img
end    


-- --------------------------------------------------------------------------------------

bin_mgr.add_offscreen = function(newcam, clear_color, bin_target, front, w, h)

    bin_target = bin_target or bintype.BTYPE_OPAQUE
    w = w or 1024
    h = h or 1024
    if(newcam) then 
        local main_pass = {
            action      = sg.SG_LOADACTION_CLEAR,
            clear       = clear_color,
        }
        newcam.offscreen = true
        local off_attachments, color_img, depth_img = bin_mgr.add_offscreen_buffers( w, h )
        local passid = bin_mgr.pass_add(main_pass, bin_target, nil, off_attachments)
        newcam.color_image = color_img 
        newcam.depth_image = depth_img      
        cammgr.add_pass(newcam.name, passid)
        bin_mgr.camera_add(newcam.id, front)    
        return off_attachments            
    end
end


-- ---------------------------------------------------------------------------------------------------

bin_mgr.add_pass = function( newcam, attachid, bin_target)

    if(newcam) then 
        local main_pass = {
            action      = sg.SG_LOADACTION_LOAD,
        }
        local passid = bin_mgr.pass_add(main_pass, bin_target, nil, attachid)
        cammgr.add_pass(newcam.name, passid)
    end
end

-- ---------------------------------------------------------------------------------------------------
-- Need a way to order passes on submission
bin_mgr.bin_set_func = function(bid, func, index)

    if(index) then 
        bin_mgr.bins[bid][index] = func
    else
        bin_mgr.bins[bid][1] = func
    end
end

-- ---------------------------------------------------------------------------------------------------

bin_mgr.bin_remove = function(bid, index) 
    local bin = bin_mgr.bins[bid]
    if(bin) then bin[index] = nil end
end

-- ---------------------------------------------------------------------------------------------------

bin_mgr.bin_clear = function(bid, index) 
    local bin = bin_mgr.bins[bid]
    if(bin) then bin[index][0].state = 0x00 end
end

-- ---------------------------------------------------------------------------------------------------
-- Call updates if a bin has an associate function
bin_mgr.update = function(dt) 

end

-- ---------------------------------------------------------------------------------------------------

bin_mgr.render = function(w, h) 

    -- Not initialized or no geometry?
    if(bin_mgr.bins == nil) then return end 

    -- NOTE: Each active camera renders its associated binlists. 
    --       Thus multiple cameras can target they same scene objects if needed 
    --       Also, it is the camera that determine offscreen rendering or "special" rendering conditions

    for ci, cameraid in ipairs(bin_mgr.cameras) do

        -- only active cameras should populate this list anyway, but check
        if(cammgr.is_active(cameraid)) then 

            local cam_name = cammgr.cameras_active[cameraid]
            local camera = cammgr.get(cam_name)

            -- iterate passes and render bins with pass setup
            for pi, passid in ipairs(camera.passes) do
                local pass = bin_mgr.passes[passid]
                if(pass.binlist) then          

                    -- Set offscreen rendering
                    if(camera.offscreen == true) then 
                        if(camera.offscreen_prerender) then camera.offscreen_prerender(pass.binlist) end
                    else
                        pass.pass[0].swapchain = slib.sglue_swapchain() 
                        -- pprint("normal: ", camera.name)
                    end

                    sg.sg_begin_pass(pass.pass)
                    cammgr.apply( cam_name )

                    -- Go through the bins for this pass! 
                    for bi, binid in ipairs(pass.binlist) do

                        -- Fetch the bin from the pool
                        local binlist = bin_mgr.bins[binid]

                        if(binlist) then 

                            for bli, bin in pairs(binlist) do
                            
                                if(type(bin) == "function") then
                                    bin(w, h)
                                else
                                    if(bit.band(bin[0].state, 0x01) == 1) then 

                                        sg.sg_apply_pipeline(bin[0].pip)
                                        sg.sg_apply_bindings(bin[0].bind)
                                    
                                        if(bin[0].vs_params ~= nil) then 
                                            sg.sg_apply_uniforms(sg.SG_SHADERSTAGE_VS, bin[0].vs_params)
                                        end
                                        if(bin[0].fs_params ~= nil) then 
                                            sg.sg_apply_uniforms(sg.SG_SHADERSTAGE_FS, bin[0].fs_params)
                                        end
                                        
                                        sg.sg_draw(bin[0].offset, bin[0].count, bin[0].instances)
                                    end
                                end
                            end
                        end
                    end
                    sg.sg_end_pass()
                end
            end
        end
    end
    sg.sg_commit()
end

-- ---------------------------------------------------------------------------------------------------

return bin_mgr

-- ---------------------------------------------------------------------------------------------------