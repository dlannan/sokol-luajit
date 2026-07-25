
local nk            = sg
local stb           = require("stb")

local ffi           = require("ffi")

-- --------------------------------------------------------------------------------------

local function checkstring(val)
    local t = type(val)
    if t == "string" then
        return val
    elseif t == "number" then
        return tostring(val)
    elseif t == "cdata" then 
        return ffi.string(val)
    else
        error("bad argument: string or number expected, got " .. t, 2)
    end
end

-- --------------------------------------------------------------------------------------

nuklear_renderer = {}

-- --------------------------------------------------------------------------------------

nuklear_renderer.get_size       = function() 
    local r = renderer.rect
    -- print("get_size", r.w, r.h)
    return r.w, r.h 
end

-- --------------------------------------------------------------------------------------

nuklear_renderer.set_clip_rect  = function(x, y, w, h) 
    local canvas = renderer.canvas
    local r = renderer.rect
    local rect = nk.nk_rect(x + r.x, y + r.y, w, h)
    -- print("set_clip_rect", rect.x, rect.y, rect.w, rect.h)
    nk.nk_push_scissor(canvas, rect)
end

-- --------------------------------------------------------------------------------------

nuklear_renderer.draw_rect      = function(x, y, w, h, color) 
    local canvas = renderer.canvas
    local r = renderer.rect
    -- local ncol = nk.nk_rgba(color.r, color.g, color.b, color.a)
    local ncol = nk.nk_rgba(color[1], color[2], color[3], color[4])
    -- print("draw_rect", x, y, w, h)
    -- nk.nk_layout_space_begin(renderer.ctx, nk.NK_STATIC, r.w, 1)
    -- nk.nk_layout_space_push(renderer.ctx, r)
    nk.nk_fill_rect(canvas, nk.nk_rect( x+r.x, y+r.y, w, h), 0, ncol)
    -- nk.nk_layout_space_end(renderer.ctx)
end

-- --------------------------------------------------------------------------------------

nuklear_renderer.draw_text      = function(font, text, x, y, color) 
    local canvas = renderer.canvas
    -- local hcolor = nk.nk_rgba(color.r, color.g, color.b, color.a)
    local hcolor = nk.nk_rgba(color[1], color[2], color[3], color[4])
    local r = renderer.rect
    local w = font:get_width(text)
    local h = font:get_height()
    local rect = nk.nk_rect(x+r.x, y+r.y, w, h)
    local font_handle = font.font.handle
    local text = checkstring(text)
    local text_len = #text
    -- print("draw_text", x, y, text)
    if(text == "CRLF" or #text == 0) then return x end
    if(string.byte(text, -1, -1) == 10) then text_len = text_len - 1 end
    -- nk.nk_layout_space_begin(renderer.ctx, nk.NK_STATIC, r.w, 1)
    -- nk.nk_layout_space_push(renderer.ctx, r)
    -- font:set_tab_width( font.tab_width )
    nk.nk_draw_text(canvas, rect, text, text_len, font_handle, hcolor, hcolor)
    -- nk.nk_layout_space_end(renderer.ctx)
    return w + x, h
end
  
-- --------------------------------------------------------------------------------------

nuklear_renderer.load_image = function(filename, no_ui)

    local x = ffi.new("int[1]", {0})
    local y = ffi.new("int[1]", {0})
    local n = ffi.new("int[1]", {4})
    local data = stb.stbi_load(filename, x, y, n, 4)
    if (data == nil) then error("[STB]: failed to load image: "..filename); return nil end
    -- print("Original channels in file:", n[0])
    print("Image Loaded: "..filename.."      Width: "..x[0].."  Height: "..y[0].."  Channels: "..n[0])

    -- Auto free when data handles are released
    ffi.gc(data, stb.stbi_image_free)
    local pixformat =  sg.SG_PIXELFORMAT_RGBA8

    local sg_img_desc = ffi.new("sg_image_desc[1]", {})
    sg_img_desc[0].width = x[0]
    sg_img_desc[0].height = y[0]
    sg_img_desc[0].pixel_format = pixformat
    sg_img_desc[0].sample_count = 1
    
    sg_img_desc[0].data.subimage[0][0].ptr = data
    sg_img_desc[0].data.subimage[0][0].size = x[0] * y[0] * 4

    if(sg.sg_isvalid() == false) then return nil, sg_img_desc, data end
    local new_img = sg.sg_make_image(sg_img_desc)
    if(no_ui) then return new_img, sg_img_desc, data end

    -- // create a sokol-nuklear image object which associates an sg_image with an sg_sampler
    local img_desc = ffi.new("snk_image_desc_t[1]")
    img_desc[0].image = new_img
    local snk_img = nk.snk_make_image(img_desc)
    local nk_hnd = nk.snk_nkhandle(snk_img)
    local nk_img = nk.nk_image_handle(nk_hnd);

    return nk_img, sg_img_desc
end

-- --------------------------------------------------------------------------------------

nuklear_renderer.load_image_buffer = function( name, buf, bufsize, no_ui )

    name = name or "image"
    local x = ffi.new("int[1]", {0})
    local y = ffi.new("int[1]", {0})
    local n = ffi.new("int[1]", {4})
    local data = stb.stbi_load_from_memory(buf, bufsize, x, y, n, 4)
    if (data == nil) then 
        print("[STB]: failed to load image: ", name)
        return nil, nil 
    end
    print("Original channels in file:", n[0])
    print("Image Buffer Loaded: "..name.."      Width: "..x[0].."  Height: "..y[0].."  Channels: "..n[0])

    local pixformat =  sg.SG_PIXELFORMAT_RGBA8

    local sg_img_desc = ffi.new("sg_image_desc[1]")
    sg_img_desc[0].width = x[0]
    sg_img_desc[0].height = y[0]
    sg_img_desc[0].pixel_format = pixformat
    sg_img_desc[0].sample_count = 1
    
    sg_img_desc[0].data.subimage[0][0].ptr = data
    sg_img_desc[0].data.subimage[0][0].size = x[0] * y[0] * 4

    if(sg.sg_isvalid() == false) then return nil, sg_img_desc, data end
    local new_img = sg.sg_make_image(sg_img_desc)
    if(no_ui) then return new_img, sg_img_desc, data end

    -- // create a sokol-nuklear image object which associates an sg_image with an sg_sampler
    local img_desc = ffi.new("snk_image_desc_t[1]")
    img_desc[0].image = new_img
    local snk_img = nk.snk_make_image(img_desc)
    local nk_hnd = nk.snk_nkhandle(snk_img)
    local nk_img = nk.nk_image_handle(nk_hnd);

    stb.stbi_image_free(data)
    return nk_img, sg_img_desc
end

-- --------------------------------------------------------------------------------------

nuklear_renderer.draw_image = function(img, x, y, w, h, color)
    color = color or {0xff, 0xff, 0xff, 0xff}
    local canvas = renderer.canvas
    local r = renderer.rect
    local rect = nk.nk_rect(x+r.x, y+r.y, w, h)
    local icolor = nk.nk_rgba(color[1], color[2], color[3], color[4])
    nk.nk_draw_image(canvas, rect, img, icolor )
end

-- --------------------------------------------------------------------------------------

nuklear_renderer.set_cursor = function()

    if(renderer.ctx == nil) then return end
    local cursor_name, rect = renderer.cursor.name, renderer.cursor.rect 
    local r = nk.nk_rect(rect.position.x, rect.position.y, rect.size.x, rect.size.y)
    
    nk.nk_layout_space_begin(renderer.ctx, nk.NK_STATIC, 27, 1)
    nk.nk_layout_space_push(renderer.ctx, r)
    if (nk.nk_widget_is_hovered(renderer.ctx) == true) then

        if(cursor_name == "arrow") then 
            nk.nk_style_set_cursor(renderer.ctx, nk.NK_CURSOR_ARROW)
        elseif(cursor_name == "ibeam") then 
            nk.nk_style_set_cursor(renderer.ctx, nk.NK_CURSOR_TEXT)
        elseif(cursor_name == "hsplit") then 
            nk.nk_style_set_cursor(renderer.ctx, nk.NK_CURSOR_RESIZE_HORIZONTAL)
        elseif(cursor_name == "sizeh") then 
            nk.nk_style_set_cursor(renderer.ctx, nk.NK_CURSOR_RESIZE_HORIZONTAL)
        elseif(cursor_name == "sizev") then 
            nk.nk_style_set_cursor(renderer.ctx, nk.NK_CURSOR_RESIZE_VERTICAL)
        end
    else 
        nk.nk_style_set_cursor(renderer.ctx, nk.NK_CURSOR_ARROW);
    end
    nk.nk_layout_space_end(renderer.ctx)
end 

-- --------------------------------------------------------------------------------------