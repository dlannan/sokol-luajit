package.path    = package.path..";../?.lua"
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

    local base_path = "samples/"
    pix["baboon"] = icon_load(base_path.."images/baboon.png")
    pix["copy"] = icon_load(base_path.."icon/copy.png")
    pix["del"] = icon_load(base_path.."icon/delete.png")
    pix["rocket"] = icon_load(base_path.."icon/rocket.png")
    pix["edit"] = icon_load(base_path.."icon/edit.png")
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

    -- /* window flags */
    ctx[0].style.window.header.align = header_align
    if (border[0] ==  true) then window_flags = bit.bor(window_flags, nk.NK_WINDOW_BORDER) end
    if (resize[0] == true) then window_flags = bit.bor(window_flags, nk.NK_WINDOW_SCALABLE) end
    if (movable[0] == true) then window_flags = bit.bor(window_flags, nk.NK_WINDOW_MOVABLE) end
    if (no_scrollbar[0] == true) then window_flags = bit.bor(window_flags, nk.NK_WINDOW_NO_SCROLLBAR) end
    if (scale_left[0] == true) then window_flags = bit.bor(window_flags, nk.NK_WINDOW_SCALE_LEFT) end
    if (minimizable[0] == true) then window_flags = bit.bor(window_flags, nk.NK_WINDOW_MINIMIZABLE) end

    if (nk.nk_begin(ctx, "PNG View", winrect[0], window_flags) == true) then

        if (show_menu[0] == true) then

            -- /* menubar */
            local menu_states = { MENU_DEFAULT = 0, MENU_WINDOWS = 1}
            nk.nk_menubar_begin(ctx)

            -- /* menu #1 */
            nk.nk_layout_row_begin(ctx, nk.NK_STATIC, 500, 5)
            nk.nk_layout_row_push(ctx, 600)

            nk.nk_image(ctx, pix["baboon"])

            -- /*------------------------------------------------
            -- *                  CONTEXTUAL
            -- *------------------------------------------------*/
            if (nk.nk_contextual_begin(ctx, nk.NK_WINDOW_NO_SCROLLBAR, nk.nk_vec2(150, 300), nk.nk_window_get_bounds(ctx)) == true) then 
                nk.nk_layout_row_dynamic(ctx, 30, 1);
                if (nk.nk_contextual_item_image_label(ctx, pix.copy, "Clone", nk.NK_TEXT_RIGHT) == true) then 
                    print("pressed clone!\n")
                end
                if (nk.nk_contextual_item_image_label(ctx, pix.del, "Delete", nk.NK_TEXT_RIGHT) == true) then
                    print("pressed delete!\n")
                end
                if (nk.nk_contextual_item_image_label(ctx, pix.rocket, "Rocket", nk.NK_TEXT_RIGHT) == true) then
                    print("pressed rocket!\n")
                end
                if (nk.nk_contextual_item_image_label(ctx, pix.edit, "Edit", nk.NK_TEXT_RIGHT) == true) then 
                    print("pressed edit!\n")
                end
                nk.nk_contextual_end(ctx)
            end

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
