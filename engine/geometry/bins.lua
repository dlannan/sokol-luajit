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
local slib      = require("sokol_libs") -- Warn - always after gfx!!
local hmm       = require("hmm")
local hutils    = require("hmm_utils")

local utils     = require("lua.utils")

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

    bin_mgr.bins    = utils.deepcopy(default_bins)
    bin_mgr.passes  = { }

    for k,v in pairs(bintype) do 
        bin_mgr[k] = v
    end
end

-- ---------------------------------------------------------------------------------------------------
-- TODO: Need to deal with this. Will become a fast lookup for numerous items
local cache = {}

bin_mgr.bin_add = function(geom) 

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

    dstate[0].offset    = geom.offset or 0
    -- Assert will prob be temporary. Will capture this upstream. 
    assert(geom.count ~= nil or geom.count ~= 0, "[render bin_add] Invalid geometry count for mesh.")
    dstate[0].count     = geom.count
    dstate[0].instances = geom.instances or 1

    local bin_slot      = bintype.BTYPE_OPAQUE 
    if(geom.bintype) then bin_slot = geom.bintype end
    
    -- Insert into known bin slot
    local thebin = bin_mgr.bins[bin_slot]
    if(thebin) then 
        tinsert(bin_mgr.bins[bin_slot], dstate)

    -- Insert into newly created bin slot
    else 
        bin_mgr.bins[bin_slot] = { dstate }
    end

    return bin_slot
end

-- ---------------------------------------------------------------------------------------------------
-- Need a way to order passes on submission
bin_mgr.pass_add = function(pdata, index, front)

    local thispass      = ffi.new("sg_pass[1]")
    thispass[0].action.colors[0].load_action = pdata.action
    thispass[0].action.colors[0].clear_value = pdata.clear   
    thispass[0].swapchain   = pdata.swapchain

    local binpass = { 
        pass = thispass,
        binlist = { 
            bintype.BTYPE_OPAQUE  
        },
    }

    if(index) then 
        binpass.binlist = { index }
    end
        
    local passid = 1
    if(not front) then 
        passid = tcount(bin_mgr.passes)
    end
    tinsert(bin_mgr.passes, passid, binpass)
    return passid
end

-- ---------------------------------------------------------------------------------------------------
-- Need a way to order passes on submission
bin_mgr.bin_add_func = function(bid, func, index)

    if(index) then 
        tinsert(bin_mgr.bins[bid], index, func)    
    else
        tinsert(bin_mgr.bins[bid], func)
    end
end

-- ---------------------------------------------------------------------------------------------------

bin_mgr.bin_remove = function(bid) 

end

-- ---------------------------------------------------------------------------------------------------

bin_mgr.bin_clear = function(bid) 

end

-- ---------------------------------------------------------------------------------------------------

bin_mgr.update = function(dt) 

end

-- ---------------------------------------------------------------------------------------------------

bin_mgr.render = function() 

    -- Not initialized?
    if(bin_mgr.bins == nil) then return end 

    -- iterate passes and render bins with pass setup
    for pi, pass in ipairs(bin_mgr.passes) do

        pass.pass[0].swapchain = slib.sglue_swapchain() 

        if(pass.binlist) then          

            sg.sg_begin_pass(pass.pass)
            -- Go through the bins for this pass! 
            for bi, binid in ipairs(pass.binlist) do

                -- Fetch the bin from the pool
                local binlist = bin_mgr.bins[binid]

                for bli, bin in ipairs(binlist) do
                
                    if(type(bin) == "function") then

                        bin(sapp.sapp_width(), sapp.sapp_height())
                    else
    
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
            sg.sg_end_pass()

        end
    end

    sg.sg_commit()
end

-- ---------------------------------------------------------------------------------------------------

return bin_mgr

-- ---------------------------------------------------------------------------------------------------