package.path    = package.path..";../../../?.lua"
local dirtools = require("tools.dirtools")
local base_path = dirtools.get_app_path("sokol%-luajit")

package.cpath   = package.cpath..";"..base_path.."bin/win64/?.dll"
package.path    = package.path..";"..base_path.."ffi/sokol/?.lua"
package.path    = package.path..";"..base_path.."?.lua"

--_G.SOKOL_DLL    = "sokol_debug_dll"
local sapp      = require("sokol_app")
sg              = require("sokol_nuklear")
local nk        = sg
local slib      = require("sokol_libs") -- Warn - always after gfx!!

local hmm       = require("hmm")
local hutils    = require("hmm_utils")

local stb       = require("stb")

local ffi       = require("ffi")

-- --------------------------------------------------------------------------------------

local config    = require("config.settings")
local wdgts     = require("utils.widgets")

-- --------------------------------------------------------------------------------------

local fonts     = nil
local atlas     = ffi.new("struct nk_font_atlas[1]")

local icons     = ffi.new("struct nk_image [?]", 10)

-- --------------------------------------------------------------------------------------

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

local master_img_width = ffi.new("int[1]", 0)
local master_img_height = ffi.new("int[1]", 0)   

-- --------------------------------------------------------------------------------------

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
    local font_path = "font/"

    local image = nil

    nk.nk_font_atlas_init_default(atlas)
    nk.nk_font_atlas_begin(atlas)
    
    image = nk.nk_font_atlas_bake(atlas, master_img_width, master_img_height, nk.NK_FONT_ATLAS_RGBA32)

    atlas[0].config.range = nk.nk_font_awesome_glyph_ranges()
    image, fonts[1] = font_loader(atlas, font_path.."fontawesome-webfont.ttf", 40.0, atlas[0].config)

    image, fonts[2] = font_loader(atlas, font_path.."Rubik-Light.ttf", 16.0, nil)
    image, fonts[3] = font_loader(atlas, font_path.."Rubik-Regular.ttf", 20.0, nil)
    image, fonts[4] = font_loader(atlas, font_path.."Rubik-Bold.ttf", 24.0, nil)
    
    -- Dump the atlas to check it.
    stb.stbi_write_png( "font/atlas_font.png", master_img_width[0], master_img_height[0], 4, image, master_img_width[0] * 4)

    -- print(master_img_width[0], master_img_height[0], 4)
    local nk_img = font_atlas_img(image)
    nk.nk_font_atlas_end(atlas, nk_img, nil)
    nk.nk_font_atlas_cleanup(atlas)
   
    nk.nk_style_load_all_cursors(ctx, atlas[0].cursors)
    nk.nk_style_set_font(ctx, fonts[1].handle)
end

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
    nk.snk_setup(snk)

    local base_path = "./"
    pix["baboon"] = icon_load(base_path.."images/baboon.png")
    -- pix["copy"] = icon_load(base_path.."icon/copy.png")
    -- pix["del"] = icon_load(base_path.."icon/delete.png")
    -- pix["rocket"] = icon_load(base_path.."icon/rocket.png")
    -- pix["edit"] = icon_load(base_path.."icon/edit.png")

    sapp.sapp_show_mouse(false)

    winrect[0].x = 0 
    winrect[0].y = 0
    winrect[0].w = sapp.sapp_width()
    winrect[0].h = sapp.sapp_height()

    icons[0] = wdgts.icon_load("./icon/home.png")
    icons[1] = wdgts.icon_load("./icon/phone.png")
    icons[2] = wdgts.icon_load("./icon/plane.png")
    icons[3] = wdgts.icon_load("./icon/wifi.png")
    icons[4] = wdgts.icon_load("./icon/settings.png")
    icons[5] = wdgts.icon_load("./icon/volume.png")   
end

-- --------------------------------------------------------------------------------------

local function cleanup()

    sg.sg_shutdown()
end

-- --------------------------------------------------------------------------------------
local current_ctx = nil
local function input(event) 
    if(event.type == sapp.SAPP_EVENTTYPE_RESIZED) then 
        nk.snk_handle_event(event)
    elseif(event.type == sapp.SAPP_EVENTTYPE_MOUSE_ENTER) then 
        nk.nk_style_show_cursor(current_ctx)
        sapp.sapp_show_mouse(false)
    elseif(event.type == sapp.SAPP_EVENTTYPE_MOUSE_LEAVE) then 
        nk.nk_style_hide_cursor(current_ctx)
        sapp.sapp_show_mouse(true)
    else 
        nk.snk_handle_event(event)
    end    
end


-- --------------------------------------------------------------------------------------
local group_width = ffi.new("int[1]", {320})
local group_height = ffi.new("int[1]", {200})

local group_name = ffi.new("char[64]")
local group_name_len = ffi.new("int[1]")

local function project_panel(ctx)

    nk.nk_style_set_font(ctx, fonts[3].handle)

    nk.nk_layout_row_begin(ctx, nk.NK_STATIC, 22, 3)
    nk.nk_layout_row_push(ctx, 50)
    nk.nk_label(ctx, "size:", nk.NK_TEXT_LEFT)
    nk.nk_layout_row_push(ctx, 130)
    nk.nk_property_int(ctx, "#Width:", 100, group_width, 500, 10, 1)
    nk.nk_layout_row_push(ctx, 130)
    nk.nk_property_int(ctx, "#Height:", 100, group_height, 500, 10, 1)
    nk.nk_layout_row_end(ctx)

    nk.nk_layout_row_begin(ctx, nk.NK_STATIC, 22, 3)
    nk.nk_layout_row_push(ctx, 50)
    nk.nk_label(ctx, "name:", nk.NK_TEXT_LEFT)
    nk.nk_layout_row_push(ctx, 130)
    nk.nk_edit_string(ctx, nk.NK_EDIT_SIMPLE, group_name, group_name_len, 64, nk.nk_filter_default)
    nk.nk_layout_row_end(ctx)    

    -- Awesome little radial popup.
    local res = wdgts.make_pie_popup(ctx, icons, 140, 6)
end

-- --------------------------------------------------------------------------------------

local function properties_panel(ctx)

    nk.nk_style_set_font(ctx, fonts[3].handle)

    nk.nk_layout_row_begin(ctx, nk.NK_STATIC, 22, 3)
    nk.nk_layout_row_push(ctx, 50)
    nk.nk_label(ctx, "size:", nk.NK_TEXT_LEFT)
    nk.nk_layout_row_push(ctx, 130)
    nk.nk_property_int(ctx, "#Width:", 100, group_width, 500, 10, 1)
    nk.nk_layout_row_push(ctx, 130)
    nk.nk_property_int(ctx, "#Height:", 100, group_height, 500, 10, 1)
    nk.nk_layout_row_end(ctx)

    nk.nk_layout_row_begin(ctx, nk.NK_STATIC, 22, 3)
    nk.nk_layout_row_push(ctx, 50)
    nk.nk_label(ctx, "name:", nk.NK_TEXT_LEFT)
    nk.nk_layout_row_push(ctx, 130)
    nk.nk_edit_string(ctx, nk.NK_EDIT_SIMPLE, group_name, group_name_len, 64, nk.nk_filter_default)
    nk.nk_layout_row_end(ctx)    
end

-- --------------------------------------------------------------------------------------

local function panel_project_function(data, left, top, width, height)
    project_panel(data.ctx)
end

-- --------------------------------------------------------------------------------------

local function panel_properties_function(data, left, top, width, height)
    properties_panel(data.ctx)
end

-- --------------------------------------------------------------------------------------

local function main_ui(ctx)

    if(fonts == nil) then 
        setup_font(ctx)
    end

    nk.nk_style_set_font(ctx, fonts[4].handle)

    local flags = bit.bor(nk.NK_WINDOW_TITLE, nk.NK_WINDOW_BORDER)
    local height = sapp.sapp_height() - 20 
    local width = sapp.sapp_width() / 2 - 15
    wdgts.widget_panel_fixed(ctx, "Project", 10, 10, width, height, flags, panel_project_function, {ctx=ctx})

    nk.nk_style_set_font(ctx, fonts[4].handle)

    local height = sapp.sapp_height() - 20 
    local width = sapp.sapp_width() / 2 - 15
    wdgts.widget_panel_fixed(ctx, "Properties", 10+width+10, 10, width, height, flags, panel_properties_function, {ctx=ctx})


    -- if (nk.nk_begin(ctx, "rbuild", winrect[0], window_flags) == true) then

        
        -- if (show_menu[0] == true) then


            -- /* menubar */
            -- local menu_states = { MENU_DEFAULT = 0, MENU_WINDOWS = 1}
            -- nk.nk_menubar_begin(ctx)

            -- -- /* menu #1 */
            -- nk.nk_layout_row_begin(ctx, nk.NK_STATIC, 40, 5)
            -- nk.nk_layout_row_push(ctx, 40)

            -- nk.nk_image(ctx, pix["baboon"])

            -- /*------------------------------------------------
            -- *                  CONTEXTUAL
            -- *------------------------------------------------*/
            -- if (nk.nk_contextual_begin(ctx, nk.NK_WINDOW_NO_SCROLLBAR, nk.nk_vec2(150, 300), nk.nk_window_get_bounds(ctx)) == true) then 
            --     nk.nk_layout_row_dynamic(ctx, 30, 1);
            --     if (nk.nk_contextual_item_image_label(ctx, pix.copy, "Clone", nk.NK_TEXT_RIGHT) == true) then 
            --         print("pressed clone!\n")
            --     end
            --     if (nk.nk_contextual_item_image_label(ctx, pix.del, "Delete", nk.NK_TEXT_RIGHT) == true) then
            --         print("pressed delete!\n")
            --     end
            --     if (nk.nk_contextual_item_image_label(ctx, pix.rocket, "Rocket", nk.NK_TEXT_RIGHT) == true) then
            --         print("pressed rocket!\n")
            --     end
            --     if (nk.nk_contextual_item_image_label(ctx, pix.edit, "Edit", nk.NK_TEXT_RIGHT) == true) then 
            --         print("pressed edit!\n")
            --     end
            --     nk.nk_contextual_end(ctx)
            -- end

            -- nk.nk_layout_row_end(ctx)
    --     end 
    --     nk.nk_end(ctx)
    -- end
    return not nk.nk_window_is_closed(ctx, "Overview")
end

-- --------------------------------------------------------------------------------------

local function frame(void) 

    local ctx = nk.snk_new_frame()
    current_ctx = ctx

    -- // see big function at end of file
    main_ui(ctx)

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
app_desc[0].width = 1280
app_desc[0].height = 800
app_desc[0].window_title = config.title
app_desc[0].icon.sokol_default = true 
app_desc[0].logger.func = slib.slog_func 
app_desc[0].enable_clipboard = true
app_desc[0].ios_keyboard_resizes_canvas = false

sapp.sapp_run( app_desc )

-- --------------------------------------------------------------------------------------
