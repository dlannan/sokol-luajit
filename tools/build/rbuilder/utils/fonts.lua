
local sapp      = require("sokol_app")
sg              = require("sokol_nuklear")
local nk        = sg
local slib      = require("sokol_libs") -- Warn - always after gfx!!

local hmm       = require("hmm")
local hutils    = require("hmm_utils")

local stb       = require("stb")

local ffi       = require("ffi")

-- --------------------------------------------------------------------------------------

local fonts = {
    master_img_width    = ffi.new("int[1]", 0),
    master_img_height   = ffi.new("int[1]", 0),   

    atlas               = ffi.new("struct nk_font_atlas[1]"),
}

-- --------------------------------------------------------------------------------------

local function font_loader( atlas, font_file, font_size, cfg)

    local newfont = nk.nk_font_atlas_add_from_file(atlas, font_file, font_size, cfg)
    local image = nk.nk_font_atlas_bake(atlas, fonts.master_img_width, fonts.master_img_height, nk.NK_FONT_ATLAS_RGBA32)
    return image, newfont
end

-- --------------------------------------------------------------------------------------

local function font_atlas_img( image )
    local sg_img_desc = ffi.new("sg_image_desc[1]")
    sg_img_desc[0].width = fonts.master_img_width[0]
    sg_img_desc[0].height = fonts.master_img_height[0]
    sg_img_desc[0].pixel_format = sg.SG_PIXELFORMAT_RGBA8
    sg_img_desc[0].sample_count = 1
    
    sg_img_desc[0].data.subimage[0][0].ptr = image
    sg_img_desc[0].data.subimage[0][0].size = fonts.master_img_width[0] * fonts.master_img_height[0] * 4
    local new_img = sg.sg_make_image(sg_img_desc)

    -- // create a sokol-nuklear image object which associates an sg_image with an sg_sampler
    local img_desc = ffi.new("snk_image_desc_t[1]")
    img_desc[0].image = new_img

    local snk_img = nk.snk_make_image(img_desc)
    local nk_hnd = nk.snk_nkhandle(snk_img)
    return nk_hnd
end

-- --------------------------------------------------------------------------------------
-- Setup fonts
fonts.setup_font = function(ctx, font_list)
    
    local atlas = fonts.atlas 
    local font_path = fonts.path or "fonts/"
    local image = nil

    nk.nk_font_atlas_init_default(atlas)
    nk.nk_font_atlas_begin(atlas)
    
    image = nk.nk_font_atlas_bake(atlas, fonts.master_img_width, fonts.master_img_height, nk.NK_FONT_ATLAS_RGBA32)
    local font_handles = {}

    for i,v in ipairs(font_list) do
        if(v.range) then 
            atlas[0].config.range = v.range
            image, v.font = font_loader(atlas, font_path..v.font_file, v.font_size, atlas[0].config)
        else 
            image, v.font = font_loader(atlas, font_path..v.font_file, v.font_size, nil)
        end
        table.insert(font_handles, v.font)
    end
    
    -- Dump the atlas to check it.
    stb.stbi_write_png( font_path.."atlas_font.png", fonts.master_img_width[0], fonts.master_img_height[0], 4, image, fonts.master_img_width[0] * 4)

    -- print(master_img_width[0], master_img_height[0], 4)
    local nk_img = font_atlas_img(image)
    nk.nk_font_atlas_end(atlas, nk_img, nil)
    nk.nk_font_atlas_cleanup(atlas)
   
    nk.nk_style_load_all_cursors(ctx, atlas[0].cursors)
    return font_handles
end

-- --------------------------------------------------------------------------------------

return fonts

-- --------------------------------------------------------------------------------------