
local stb   = require("stb")
local ffi   = require("ffi")

local nk    = sg

--  A magic cache pool of loaded pngs. Storing filename to data
local images_loaded = {}

-- returns struct nk_image
local function image_load(filename)

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

    return nk_img
end

----------------------------

local function image_create( buffer, width, height, channels )

    channels = channels or 4
    local x = ffi.new("int[1]", {width})
    local y = ffi.new("int[1]", {height})
    local n = ffi.new("int[1]", {channels})
    local data = ffi.new("unsigned char[?]", width * height * channels) 
    ffi.copy(data, ffi.cast("unsigned char *",buffer), width * height * channels)
    
    local pixformat =  sg.SG_PIXELFORMAT_RGBA8
    if(channels == 1) then 
        pixformat = sg.SG_PIXELFORMAT_R8
    elseif(channels == 2) then 
        pixformat = sg.SG_PIXELFORMAT_RG8
    end
    
    local sg_img_desc = ffi.new("sg_image_desc[1]")
    sg_img_desc[0].width = x[0]
    sg_img_desc[0].height = y[0]
    sg_img_desc[0].pixel_format = pixformat
    sg_img_desc[0].sample_count = 1
    
    sg_img_desc[0].data.subimage[0][0].ptr = data
    sg_img_desc[0].data.subimage[0][0].size = x[0] * y[0] * channels

    local new_img = sg.sg_make_image(sg_img_desc)

    -- // create a sokol-nuklear image object which associates an sg_image with an sg_sampler
    local img_desc = ffi.new("snk_image_desc_t[1]")
    img_desc[0].image = new_img

    local snk_img = nk.snk_make_image(img_desc)
    local nk_hnd = nk.snk_nkhandle(snk_img)
    local nk_img = nk.nk_image_handle(nk_hnd);
    
    return snk_img, nk_hnd, data
end

----------------------------

local function load(filename)
    local imgid = image_load(filename)
    images_loaded[filename] =imgid
    return imgid
end


----------------------------

local function loadbuffer(filename)
    local imgid = image_load(filename)
    images_loaded[filename] =imgid
    return imgid
end

----------------------------

local function getimage(filename)
    return images_loaded[filename]
end


----------------------------

return {
    load = load,
    loadbuffer = loadbuffer,
    getimage = getimage,
    image_load = image_load,
    image_create = image_create,
}

----------------------------