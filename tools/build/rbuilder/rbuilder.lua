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
-- For win - sleep so as to not consume all proc cycles for ui
ffi.cdef[[
    void Sleep(uint32_t ms);
]]

 
-- --------------------------------------------------------------------------------------

local config    = require("config.settings")
local wdgts     = require("utils.widgets")
local fonts     = require("utils.fonts")

local icons     = ffi.new("struct nk_image [?]", 10)

-- --------------------------------------------------------------------------------------

local myfonts   = nil
local font_list = {
    { font_file = "fontawesome-webfont.ttf", font_size = 30.0, range = nk.nk_font_awesome_glyph_ranges() },
    { font_file = "Rubik-Light.ttf", font_size = 16.0 },
    { font_file = "Rubik-Regular.ttf", font_size = 20.0 },
    { font_file = "Rubik-Bold.ttf", font_size = 21.0 },
}

-- --------------------------------------------------------------------------------------

-- --------------------------------------------------------------------------------------
-- Static vars 
-- 
--  Note: Many vars are locally set or globals. This was from a direct C conversion. 
--        To make static vars workaround then place them below.

local winrect       = ffi.new("struct nk_rect[1]", {{10, 25, 1000, 600}})

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
    pix["baboon"] = wdgts.icon_load(base_path.."images/baboon.png")
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
-- TODO: These to all go into config
local group_width = ffi.new("int[1]", {320})
local group_height = ffi.new("int[1]", {200})

local project_path = ffi.new("char[256]")
local project_path_len = ffi.new("int[1]")

local project_startup_file = ffi.new("char[256]")
local project_startup_file_len = ffi.new("int[1]")

local project_name = ffi.new("char[256]")
local project_name_len = ffi.new("int[1]")

local platform_selected = 1
local platforms = { "Win64", "MacOS", "Linux", "IOS64" }

local res_selected = 1
local resolutions = { "1920x1080", "1680x1050", "1600x900", "1440x900", "1376x768" }

-- --------------------------------------------------------------------------------------

local function project_panel(ctx)

    nk.nk_style_set_font(ctx, myfonts[3].handle)

    local bounds = nk.nk_window_get_content_region(ctx)
    local prop_col = bounds.w * 0.25
    local value_col = bounds.w * 0.75

    nk.nk_layout_row_begin(ctx, nk.NK_STATIC, 22, 3)
    nk.nk_layout_row_push(ctx, prop_col)
    nk.nk_label(ctx, "Project Name:", nk.NK_TEXT_LEFT)
    nk.nk_layout_row_push(ctx, value_col)
    nk.nk_edit_string(ctx, nk.NK_EDIT_SIMPLE, project_name, project_name_len, 256, nk.nk_filter_default)
    nk.nk_layout_row_end(ctx)    

    nk.nk_layout_row_begin(ctx, nk.NK_STATIC, 22, 3)
    nk.nk_layout_row_push(ctx, prop_col)
    nk.nk_label(ctx, "Project Path:", nk.NK_TEXT_LEFT)
    nk.nk_layout_row_push(ctx, value_col * 0.9)
    nk.nk_edit_string(ctx, nk.NK_EDIT_SIMPLE, project_path, project_path_len, 256, nk.nk_filter_default)
    nk.nk_layout_row_push(ctx, value_col * 0.1)
    if(nk.nk_button_label(ctx, ffi.string("...")) == true) then
        print("pressed")    
    end
    nk.nk_layout_row_end(ctx)    

    nk.nk_layout_row_begin(ctx, nk.NK_STATIC, 22, 3)
    nk.nk_layout_row_push(ctx, prop_col)
    nk.nk_label(ctx, "sokol-luajit Path:", nk.NK_TEXT_LEFT)
    nk.nk_layout_row_push(ctx, value_col * 0.9)
    nk.nk_edit_string(ctx, nk.NK_EDIT_SIMPLE, project_name, project_name_len, 256, nk.nk_filter_default)
    nk.nk_layout_row_push(ctx, value_col * 0.1)
    if(nk.nk_button_label(ctx, ffi.string("...")) == true) then
        print("pressed")    
    end
    nk.nk_layout_row_end(ctx)    

    nk.nk_layout_row_begin(ctx, nk.NK_STATIC, 22, 3)
    nk.nk_layout_row_push(ctx, prop_col)
    nk.nk_label(ctx, "Startup Lua File:", nk.NK_TEXT_LEFT)
    nk.nk_layout_row_push(ctx, value_col * 0.9)
    nk.nk_edit_string(ctx, nk.NK_EDIT_SIMPLE, project_startup_file, project_startup_file_len, 256, nk.nk_filter_default)
    nk.nk_layout_row_push(ctx, value_col * 0.1)
    if(nk.nk_button_label(ctx, ffi.string("...")) == true) then
        print("pressed")    
    end
    nk.nk_layout_row_end(ctx)    

    nk.nk_layout_row_begin(ctx, nk.NK_STATIC, 22, 3)
    nk.nk_layout_row_push(ctx, prop_col)
    nk.nk_label(ctx, "Platform Target:", nk.NK_TEXT_LEFT)
    nk.nk_layout_row_push(ctx, value_col)
    platform_selected = wdgts.widget_combo_box(ctx, platforms, platform_selected, 200)
    nk.nk_layout_row_end(ctx)


    nk.nk_layout_row_begin(ctx, nk.NK_STATIC, 22, 3)
    nk.nk_layout_row_push(ctx, prop_col)
    nk.nk_label(ctx, "Resolution:", nk.NK_TEXT_LEFT)
    nk.nk_layout_row_push(ctx, value_col)
    res_selected = wdgts.widget_combo_box(ctx, resolutions, res_selected, 200)
    nk.nk_layout_row_end(ctx)

    -- Awesome little radial popup.
    local res = wdgts.make_pie_popup(ctx, icons, 100, 6)
end

-- --------------------------------------------------------------------------------------
local curr_tab = 1
local tabs = { "Lua Source", "Images", "Data" }

local function assets_panel(ctx)

    nk.nk_style_set_font(ctx, myfonts[3].handle)

    curr_tab = wdgts.widget_notebook(ctx, tabs, curr_tab, 120)

    nk.nk_layout_row_begin(ctx, nk.NK_STATIC, 22, 3)
    nk.nk_layout_row_push(ctx, 50)
    nk.nk_label(ctx, "size:", nk.NK_TEXT_LEFT)
    nk.nk_layout_row_push(ctx, 130)
    nk.nk_property_int(ctx, "#Width:", 100, group_width, 500, 10, 1)
    nk.nk_layout_row_push(ctx, 130)
    nk.nk_property_int(ctx, "#Height:", 100, group_height, 500, 10, 1)
    nk.nk_layout_row_end(ctx)

end

-- --------------------------------------------------------------------------------------

local function panel_project_function(data, left, top, width, height)
    project_panel(data.ctx)
end

-- --------------------------------------------------------------------------------------

local function panel_assets_function(data, left, top, width, height)
    assets_panel(data.ctx)
end

-- --------------------------------------------------------------------------------------

local function main_ui(ctx)

    if(myfonts == nil) then 
        myfonts = fonts.setup_font(ctx, font_list)
    end

    nk.nk_style_set_font(ctx, myfonts[4].handle)

    local flags = bit.bor(nk.NK_WINDOW_TITLE, nk.NK_WINDOW_BORDER)
    local height = sapp.sapp_height() - 20 
    local width = sapp.sapp_width() / 2 - 15
    wdgts.widget_panel_fixed(ctx, "Project", 10, 10, width, height, flags, panel_project_function, {ctx=ctx})

    nk.nk_style_set_font(ctx, myfonts[4].handle)

    local height = sapp.sapp_height() - 20 
    local width = sapp.sapp_width() / 2 - 15
    wdgts.widget_panel_fixed(ctx, "Assets", 10+width+10, 10, width, height, flags, panel_assets_function, {ctx=ctx})
    return not nk.nk_window_is_closed(ctx, "Overview")
end

-- --------------------------------------------------------------------------------------

local function frame(void) 

    local ctx = nk.snk_new_frame()
    current_ctx = ctx

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

    ffi.C.Sleep(3)
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
