-- --------------------------------------------------------------------------------------

local ffi       = require("ffi")

local dirtools  = require("tools.dirtools")
local sapp      = require("sokol_app")
sg              = require("sokol_nuklear")
local nk        = sg
local slib      = require("sokol_libs") -- Warn - always after gfx!!

-- --------------------------------------------------------------------------------------

local settings  = require("config.settings")
local wdgts     = require("utils.widgets")
local fonts     = require("utils.fonts")
local fsel      = require("ui.file_selector")

local icons     = ffi.new("struct nk_image [?]", 10)

local themes    = require("lua.themes")

local panel     = {
    config = nil
}

-- --------------------------------------------------------------------------------------
-- Static vars 
-- 
--  Note: Many vars are locally set or globals. This was from a direct C conversion. 
--        To make static vars workaround then place them below.

local winrect       = ffi.new("struct nk_rect[1]", {{10, 25, 1000, 600}})

-- --------------------------------------------------------------------------------------

local myfonts   = nil
local font_list = {
    { font_file = "fontawesome-webfont.ttf", font_size = 16.0, range = nk.nk_font_awesome_glyph_ranges() },
    { font_file = "Rubik-Light.ttf", font_size = 16.0 },
    { font_file = "Rubik-Regular.ttf", font_size = 20.0 },
    { font_file = "Rubik-Bold.ttf", font_size = 21.0 },
}

local folder_select = nil
local file_select = nil

-- --------------------------------------------------------------------------------------
local curr_tab          = 1

local tabs = { 
    { 
        name = "Lua Source",
        func = function(ctx) 
            
            local bounds = nk.nk_window_get_content_region(ctx)
            nk.nk_layout_row_dynamic(ctx, bounds.h, 1)
            local files = panel.config.assets.lua 
            wdgts.widget_list_removeable(ctx, "source_files", nk.NK_WINDOW_BORDER, files, bounds.w -40 )
        end,
        asset_name = "lua",
    }, 
    { 
        name = "Images",
        func = function(ctx) 
            
            local bounds = nk.nk_window_get_content_region(ctx)
            nk.nk_layout_row_dynamic(ctx, bounds.h, 1)
            local files = panel.config.assets.images 
            wdgts.widget_list_removeable(ctx, "source_files", nk.NK_WINDOW_BORDER, files, bounds.w -40 )
        end,
        asset_name = "images",
    }, 
    { 
        name = "Data",
        func = function(ctx) 
            
            local bounds = nk.nk_window_get_content_region(ctx)
            nk.nk_layout_row_dynamic(ctx, bounds.h, 1)
            local files = panel.config.assets.data
            wdgts.widget_list_removeable(ctx, "source_files", nk.NK_WINDOW_BORDER, files, bounds.w -40 )
        end,
        asset_name = "data",
    } 
}

-- --------------------------------------------------------------------------------------
-- Extract config and build ffi objects for them 
--   Each config property shall have a shadow ffi property labeled with _ffi

local function setup_config()
    
    for sectionname, section in pairs(panel.config) do

        for key, prop in pairs(section) do
            -- If ptype is nill or string its a string
            if(prop.ptype == "string") then
                prop.ffi = ffi.new("char[?]", prop.slen )
                ffi.fill(prop.ffi, prop.slen, 0)
                ffi.copy(prop.ffi, ffi.string(prop.value))
                prop.len_ffi = ffi.new("int[1]", {string.len(prop.value)})
            elseif(prop.ptype == "combo") then
                prop.ffi = ffi.new("int[1]", prop.value)
            elseif(prop.ptype == "int") then
                prop.ffi = ffi.new("int[1]", prop.value)
            elseif(prop.ptype == "float") then
                prop.ffi = ffi.new("float[1]", prop.value)
            elseif(prop.ptype == "path") then
                prop.ffi = ffi.new("char[?]", prop.slen )
                ffi.fill(prop.ffi, prop.slen, 0)
                ffi.copy(prop.ffi, ffi.string(prop.value))
                prop.len_ffi = ffi.new("int[1]", {string.len(prop.value)})
            elseif(prop.ptype == "file") then
                prop.ffi = ffi.new("char[?]", prop.slen )
                ffi.fill(prop.ffi, prop.slen, 0)
                ffi.copy(prop.ffi, ffi.string(prop.value))
                prop.len_ffi = ffi.new("int[1]", {string.len(prop.value)})
            end
        end
    end
end 

-- --------------------------------------------------------------------------------------
local pix = {}

panel.init = function()

    local base_path = "./"
    pix["baboon"] = wdgts.icon_load(base_path.."images/baboon.png")
    -- pix["copy"] = icon_load(base_path.."icon/copy.png")
    -- pix["del"] = icon_load(base_path.."icon/delete.png")
    -- pix["rocket"] = icon_load(base_path.."icon/rocket.png")
    -- pix["edit"] = icon_load(base_path.."icon/edit.png")

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

    local popup_wide = sapp.sapp_width()* 0.4
    local popup_high = sapp.sapp_height()* 0.7

    local dim = nk.nk_rect( sapp.sapp_width()/2-8 - popup_wide/2,
        sapp.sapp_height()/2-40 - popup_high/2, popup_wide, popup_high)
    folder_select = fsel.create_file_selector("Select Folder", dim, ".", true)

    local dim2 = nk.nk_rect( sapp.sapp_width()/2-8 - popup_wide/2,
        sapp.sapp_height()/2-40 - popup_high/2, popup_wide, popup_high)
    file_select = fsel.create_file_selector("Select File", dim2, ".")

    panel.config = settings.load()
    setup_config()
end

-- --------------------------------------------------------------------------------------

local function display_section(ctx, sectionname)

    local section = panel.config[sectionname]
    -- Collect the number of properties in the section
    local count = 0
    local sorted = {}
    for k,v in pairs(section) do
        count = count + 1
        v.key = k
        sorted[v.index] = v
    end

    nk.nk_layout_row_dynamic(ctx, 28 * count + 60, 1)
    local bounds = nk.nk_window_get_content_region(ctx)
    local prop_col = bounds.w * 0.23
    local value_col = bounds.w * 0.73

    local flags = bit.bor(nk.NK_WINDOW_BORDER, nk.NK_WINDOW_TITLE)
    flags = bit.bor(flags, nk.NK_WINDOW_NO_SCROLLBAR)
    if (nk.nk_group_begin(ctx, sectionname, flags) == true) then
    
        for k,v in ipairs(sorted) do
            nk.nk_layout_row_begin(ctx, nk.NK_STATIC, 28, 3)
            nk.nk_layout_row_push(ctx, prop_col)
            nk.nk_label(ctx, v.key..":", nk.NK_TEXT_LEFT)
            if(v.ptype == "string" or v.ptype == nil) then
                nk.nk_layout_row_push(ctx, value_col)
                nk.nk_edit_string(ctx, nk.NK_EDIT_SIMPLE, v.ffi, v.len_ffi, v.slen, nk.nk_filter_default)
            elseif(v.ptype == "path") then
                nk.nk_layout_row_push(ctx, value_col - 34)
                nk.nk_edit_string(ctx, nk.NK_EDIT_SIMPLE, v.ffi, v.len_ffi, v.slen, nk.nk_filter_default)
                nk.nk_style_set_font(ctx, myfonts[1].handle)
                nk.nk_layout_row_push(ctx, 30)               
                if(nk.nk_button_label(ctx, "") == true) then 
                    folder_select.popup_active = 1
                    folder_select.prop = v
                    folder_select.folder_path = v.value
                    folder_select.drives = dirtools.get_drives()
                end
                nk.nk_style_set_font(ctx, myfonts[3].handle)
            elseif(v.ptype == "file") then
                nk.nk_layout_row_push(ctx, value_col - 34)
                nk.nk_edit_string(ctx, nk.NK_EDIT_SIMPLE, v.ffi, v.len_ffi, v.slen, nk.nk_filter_default)
                nk.nk_style_set_font(ctx, myfonts[1].handle)
                nk.nk_layout_row_push(ctx, 30)
                if(nk.nk_button_label(ctx, "") == true) then 
                    file_select.popup_active = 1
                    file_select.prop = v
                    file_select.folder_path = dirtools.get_folder(v.value)
                    file_select.drives = dirtools.get_drives()
                end
                nk.nk_style_set_font(ctx, myfonts[3].handle)
            elseif(v.ptype == "combo") then 
                nk.nk_layout_row_push(ctx, value_col)
                v.value = wdgts.widget_combo_box(ctx, v.plist, v.value, 200)
            elseif(v.ptype == "int") then
                nk.nk_layout_row_push(ctx, value_col)
                nk.nk_property_int(ctx, "", v.vmin, v.ffi, v.vmax, v.vstep, v.vinc)
            elseif(v.ptype == "float") then
                nk.nk_layout_row_push(ctx, value_col)
                nk.nk_property_float(ctx, "", v.vmin, v.ffi, v.vmax, v.vstep, v.vinc)
            end
            nk.nk_layout_row_end(ctx)
        end

        nk.nk_group_end(ctx)
    end
end

-- --------------------------------------------------------------------------------------

local project_curr_tab = 1
local project_tabs = { 
    { 
        name = "Settings",
        func = function(ctx) 
            display_section(ctx, "project") 
            display_section(ctx, "sokol")
        end,
    }, 
    { 
        name = "Build",
        func = function(ctx) 
            display_section(ctx, "platform") 
        end,
    }, 
    { 
        name = "Logs",
    } 
}
-- --------------------------------------------------------------------------------------

local function project_panel(ctx)

    nk.nk_style_set_font(ctx, myfonts[3].handle)

    project_curr_tab = wdgts.widget_notebook(ctx, "assets", project_tabs, project_curr_tab, 500, 120)
    -- display_section(ctx, "graphics")
    -- display_section(ctx, "audio")

    nk.nk_layout_row_dynamic(ctx, 25, 2)
    local add_folder = false
    if (nk.nk_button_label(ctx, "Build Release") == true) then
        add_folder = true
    end
    local add_file = false
    if (nk.nk_button_label(ctx, "Clean All") == true) then
        add_file = true
    end    

    -- Awesome little radial popup.
    local res = wdgts.make_pie_popup(ctx, icons, 100, 6)
end


-- --------------------------------------------------------------------------------------

local function assets_panel(ctx)

    nk.nk_style_set_font(ctx, myfonts[3].handle)
    curr_tab, named_tab = wdgts.widget_notebook(ctx, "assets", tabs, curr_tab, 500, 120)

    nk.nk_layout_row_dynamic(ctx, 25, 2)
    if (nk.nk_button_label(ctx, "Add Folder") == true) then
        folder_select.popup_active = 1
        folder_select.prop = nil
        folder_select.folder_path = "."
        folder_select.drives = dirtools.get_drives()
        folder_select.callback = function(udata, res) 
            print(udata.folder_path, named_tab, res)
            if(res == true) then
                local tabinfo = tabs[curr_tab]
                local newfolder = {
                    name=ffi.string(udata.folder_path),
                    select = ffi.new("bool[1]", {0})
                }
                table.insert(panel.config.assets[tabinfo.asset_name], newfolder)
            end 
        end
    end

    if (nk.nk_button_label(ctx, "Add File") == true) then
        file_select.popup_active = 1
        file_select.prop = nil
        file_select.folder_path = dirtools.get_folder(".")
        file_select.drives = dirtools.get_drives()
        file_select.callback = function(udata, res) 
            if(res == true) then
                local tabinfo = tabs[curr_tab]
                local newfile = {
                    name=ffi.string(udata.file_selected),
                    select = ffi.new("bool[1]", {0})
                }
                table.insert(panel.config.assets[tabinfo.asset_name], newfile)
            end 
        end
    end    

end

-- --------------------------------------------------------------------------------------

panel.main_ui = function(ctx)

    if(myfonts == nil) then 
        myfonts = fonts.setup_font(ctx, font_list)
        wdgts.myfonts = myfonts
        themes.tech(ctx)
    end

    local config_reset = nil

    wdgts.widget_panel_fixed(ctx, "WinMain", 0, 0, sapp.sapp_width(), sapp.sapp_height(), 0, function(data)

        folder_select.popup_active = wdgts.widget_popup_panel(ctx, "popup", folder_select.popup_dim, folder_select.ui_func, folder_select, folder_select.popup_active)
        file_select.popup_active = wdgts.widget_popup_panel(ctx, "popup", file_select.popup_dim, file_select.ui_func, file_select, file_select.popup_active)

        -- /* menubar */
        local menu_states = { MENU_DEFAULT = 0, MENU_WINDOWS = 1}
        nk.nk_menubar_begin(ctx)

        -- /* menu #1 */
        nk.nk_layout_row_begin(ctx, nk.NK_STATIC, 25, 2)
        nk.nk_layout_row_push(ctx, 140)
        if (nk.nk_menu_begin_label(ctx, "File", nk.NK_TEXT_LEFT, nk.nk_vec2(120, 200))) then 
        
            nk.nk_layout_row_dynamic(ctx, 35, 1)
            if (nk.nk_menu_item_label(ctx, "New", nk.NK_TEXT_LEFT)) then
                config_reset = true
            end
            nk.nk_layout_row_dynamic(ctx, 35, 1)
            if (nk.nk_menu_item_label(ctx, "Open", nk.NK_TEXT_LEFT)) then 
            end
            nk.nk_layout_row_dynamic(ctx, 35, 1)
            if (nk.nk_menu_item_label(ctx, "Save", nk.NK_TEXT_LEFT)) then 
            end
            nk.nk_layout_row_dynamic(ctx, 35, 1)
            if (nk.nk_menu_item_label(ctx, "SaveAs", nk.NK_TEXT_LEFT)) then 
            end
            nk.nk_layout_row_dynamic(ctx, 35, 1)
            if (nk.nk_menu_item_label(ctx, "Quit", nk.NK_TEXT_LEFT)) then 
                os.exit()
            end
            nk.nk_menu_end(ctx)
        end

        -- /* menu #2 */
        nk.nk_layout_row_push(ctx, 60)
        if (nk.nk_menu_begin_label(ctx, "Tools", nk.NK_TEXT_LEFT, nk.nk_vec2(200, 200))) then 
        
            nk.nk_layout_row_dynamic(ctx, 35, 1)
            if (nk.nk_menu_item_label(ctx, "Build", nk.NK_TEXT_LEFT)) then 
            end
            nk.nk_layout_row_dynamic(ctx, 35, 1)
            if (nk.nk_menu_item_label(ctx, "Build All", nk.NK_TEXT_LEFT)) then 
            end
            nk.nk_layout_row_dynamic(ctx, 35, 1)
            if (nk.nk_menu_item_label(ctx, "Clean All", nk.NK_TEXT_LEFT)) then 
            end
            nk.nk_layout_row_dynamic(ctx, 35, 1)
            if (nk.nk_menu_item_label(ctx, "Test Build", nk.NK_TEXT_LEFT)) then 
            end
            nk.nk_layout_row_dynamic(ctx, 35, 1)
            if (nk.nk_menu_item_label(ctx, "Profile", nk.NK_TEXT_LEFT)) then 
            end
            nk.nk_menu_end(ctx)
        end
        nk.nk_menubar_end(ctx)        
    
        nk.nk_layout_row_begin(ctx, nk.NK_STATIC, 15, 1)
        nk.nk_layout_row_push(ctx, 140)

        nk.nk_style_set_font(ctx, myfonts[4].handle)

        local flags = nk.NK_WINDOW_BORDER
        local height = sapp.sapp_height()
        nk.nk_layout_row_dynamic(ctx, height-20, 2)

        -- wdgts.widget_panel_fixed(ctx, "Project", 10, 10, width, height, flags, function(data)
        if (nk.nk_group_begin(ctx, "Settings", flags) == true) then

            local padding = ctx[0].style.window.padding
            ctx[0].style.window.padding = nk.nk_vec2(10,10)
    
            project_panel(data.ctx)
        -- end, {ctx=ctx})
            nk.nk_group_end(ctx)
        end

        nk.nk_style_set_font(ctx, myfonts[4].handle)

        -- wdgts.widget_panel_fixed(ctx, "Assets", 10+width+10, 10, width, height, flags, function(data)
        if (nk.nk_group_begin(ctx, "Assets", flags) == true) then           
    
            assets_panel(data.ctx)
        -- end, {ctx=ctx})
        nk.nk_group_end(ctx)
        end

    end, {ctx=ctx})

    -- return not nk.nk_window_is_closed(ctx, "Overview")
    return config_reset
end

-- --------------------------------------------------------------------------------------

panel.input = function(event)

    if(event.type == sapp.SAPP_EVENTTYPE_RESIZED) then 

        local popup_wide = sapp.sapp_width()* 0.4
        local popup_high = sapp.sapp_height()* 0.7

        local dim = nk.nk_rect( sapp.sapp_width()/2-8 - popup_wide/2,
        sapp.sapp_height()/2-40 - popup_high/2, popup_wide, popup_high)
        folder_select.popup_dim = dim

        local dim2 = nk.nk_rect( sapp.sapp_width()/2-8 - popup_wide/2,
            sapp.sapp_height()/2-40 - popup_high/2, popup_wide, popup_high)
        file_select.popup_dim = dim2
    end
end

-- --------------------------------------------------------------------------------------

return panel

-- --------------------------------------------------------------------------------------
