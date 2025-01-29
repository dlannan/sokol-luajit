package.path    = package.path..";../../?.lua"
local dirtools  = require("tools.vfs.dirtools").init("sokol%-luajit")

--_G.SOKOL_DLL    = "sokol_debug_dll"
local sapp      = require("sokol_app")
sg              = require("sokol_gfx")
sg              = require("sokol_nuklear")
local nk        = sg
local slib      = require("sokol_libs") -- Warn - always after gfx!!

local hmm       = require("hmm")
local hutils    = require("hmm_utils")

local stb       = require("stb")

local ffi       = require("ffi")

local utils     = require("utils")

-- --------------------------------------------------------------------------------------

local fonts     = nil
local atlas     = ffi.new("struct nk_font_atlas[1]")

-- --------------------------------------------------------------------------------------

local function init(void)
    -- // setup sokol-gfx, sokol-time and sokol-imgui
    local sg_desc = ffi.new("sg_desc[1]")
    sg_desc[0].environment = slib.sglue_environment()
    sg_desc[0].logger.func = slib.slog_func
    sg.sg_setup( sg_desc )

    -- // use sokol-nuklear with all default-options (we're not doing
    -- // multi-sampled rendering or using non-default pixel formats)
    local snk = ffi.new("snk_desc_t[1]")
    snk[0].dpi_scale = sapp.sapp_dpi_scale()
    snk[0].logger.func = slib.slog_func
    snk[0].no_default_font = true
    nk.snk_setup(snk)

    -- Hide sokol mouse, use the nuklear one
    sapp.sapp_show_mouse(false)
end

-- --------------------------------------------------------------------------------------

local master_img_width = ffi.new("int[1]", 0)
local master_img_height = ffi.new("int[1]", 0)   

local function font_loader( atlas, font_file, font_size, cfg)

    local newfont = nk.nk_font_atlas_add_from_file(atlas, font_file, font_size, cfg)
    local image = nk.nk_font_atlas_bake(atlas, master_img_width, master_img_height, nk.NK_FONT_ATLAS_RGBA32)
    return image, newfont
end

-- --------------------------------------------------------------------------------------

local function font_atlas_img( image )
    local sg_img_desc = ffi.new("sg_image_desc[1]")
    sg_img_desc[0].width = master_img_width[0]
    sg_img_desc[0].height = master_img_height[0]
    sg_img_desc[0].pixel_format = sg.SG_PIXELFORMAT_RGBA8
    sg_img_desc[0].sample_count = 1
    
    sg_img_desc[0].data.subimage[0][0].ptr = image
    sg_img_desc[0].data.subimage[0][0].size = master_img_width[0] * master_img_height[0] * 4
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
local function setup_font(ctx)

    fonts = {} 
    local font_path = "projects/examples/samples/font/"

    local image = nil

    nk.nk_font_atlas_init_default(atlas)
    nk.nk_font_atlas_begin(atlas)
    
    image = nk.nk_font_atlas_bake(atlas, master_img_width, master_img_height, nk.NK_FONT_ATLAS_RGBA32)

    image, fonts[1] = font_loader(atlas, font_path.."acknowtt.ttf", 16.0, nil)

    atlas[0].config.range = nk.nk_font_awesome_glyph_ranges()
    image, fonts[2] = font_loader(atlas, font_path.."fontawesome-webfont.ttf", 40.0, atlas[0].config)

    image, fonts[3] = font_loader(atlas, font_path.."ProggyClean.ttf", 18.0, nil)

    -- Dump the atlas to check it.
    stb.stbi_write_png( "samples/font/atlas_font.png", master_img_width[0], master_img_height[0], 4, image, master_img_width[0] * 4)

    -- print(master_img_width[0], master_img_height[0], 4)
    local nk_img = font_atlas_img(image)
    nk.nk_font_atlas_end(atlas, nk_img, nil)
    nk.nk_font_atlas_cleanup(atlas)
   
    nk.nk_style_load_all_cursors(ctx, atlas[0].cursors)
    nk.nk_style_set_font(ctx, fonts[1].handle)
end

-- --------------------------------------------------------------------------------------

local function cleanup()

    sg.sg_shutdown()
end

-- --------------------------------------------------------------------------------------

local function input(event) 
    nk.snk_handle_event(event)
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

    if(fonts == nil) then 
        setup_font(ctx)
    end

    nk.nk_style_show_cursor(ctx)

    -- /* window flags */
    ctx[0].style.window.header.align = header_align
    if (border[0] ==  true) then window_flags = bit.bor(window_flags, nk.NK_WINDOW_BORDER) end
    if (resize[0] == true) then window_flags = bit.bor(window_flags, nk.NK_WINDOW_SCALABLE) end
    if (movable[0] == true) then window_flags = bit.bor(window_flags, nk.NK_WINDOW_MOVABLE) end
    if (no_scrollbar[0] == true) then window_flags = bit.bor(window_flags, nk.NK_WINDOW_NO_SCROLLBAR) end
    if (scale_left[0] == true) then window_flags = bit.bor(window_flags, nk.NK_WINDOW_SCALE_LEFT) end
    if (minimizable[0] == true) then window_flags = bit.bor(window_flags, nk.NK_WINDOW_MINIMIZABLE) end

    if (nk.nk_begin(ctx, "Multi Font Sample", winrect[0], window_flags) == true) then

        if (show_menu[0] == true) then

            -- /* menubar */
            local menu_states = { MENU_DEFAULT = 0, MENU_WINDOWS = 1}
            nk.nk_menubar_begin(ctx)

            -- /* menu #1 */
            nk.nk_layout_row_begin(ctx, nk.NK_STATIC, 80, 5)
            nk.nk_layout_row_push(ctx, 250)

            nk.nk_style_set_font(ctx, fonts[1].handle)
            nk.nk_button_label(ctx, "Hello In acknowtt Font")

            local utf = ffi.new("char[2]", {0x83, 0xf1})
            nk.nk_style_set_font(ctx, fonts[2].handle)
            nk.nk_button_label(ctx, "")

            nk.nk_style_set_font(ctx, fonts[3].handle)
            nk.nk_button_label(ctx, "Hello in ProggyClean")

            nk.nk_layout_row_end(ctx)
        end 
    end
    nk.nk_end(ctx)
    return not nk.nk_window_is_closed(ctx, "Overview")
end

-- --------------------------------------------------------------------------------------

local function frame(void) 

    local ctx = nk.snk_new_frame()

    -- // see big function at end of file
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
end

-- --------------------------------------------------------------------------------------

local app_desc = ffi.new("sapp_desc[1]")
app_desc[0].init_cb = init
app_desc[0].frame_cb = frame
app_desc[0].cleanup_cb = cleanup
app_desc[0].event_cb = input
app_desc[0].width = 1920
app_desc[0].height = 1080
app_desc[0].window_title = "nuklear (sokol-app)"
app_desc[0].icon.sokol_default = true 
app_desc[0].logger.func = slib.slog_func 
app_desc[0].enable_clipboard = true
app_desc[0].ios_keyboard_resizes_canvas = false

sapp.sapp_run( app_desc )

-- --------------------------------------------------------------------------------------
