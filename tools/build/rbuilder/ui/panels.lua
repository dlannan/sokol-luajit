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

local icons     = ffi.new("struct nk_image [?]", 10)

local config    = settings.load()

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

-- --------------------------------------------------------------------------------------
local curr_tab          = 1

local tabs = { 
    { 
        name = "Lua Source",
        func = function(ctx) 
            
            local bounds = nk.nk_window_get_content_region(ctx)
            nk.nk_layout_row_dynamic(ctx, bounds.h, 1)
            local files = config.assets.lua 
            wdgts.widget_list_selectable(ctx, "source_files", nk.NK_WINDOW_BORDER, files, bounds.w -40 )
        end,
    }, 
    { 
        name = "Images",
        func = function(ctx) 
            
            local bounds = nk.nk_window_get_content_region(ctx)
            nk.nk_layout_row_dynamic(ctx, bounds.h, 1)
            local files = config.assets.images 
            wdgts.widget_list_selectable(ctx, "source_files", nk.NK_WINDOW_BORDER, files, bounds.w -40 )
        end,
    }, 
    { 
        name = "Data",
        func = function(ctx) 
            
            local bounds = nk.nk_window_get_content_region(ctx)
            nk.nk_layout_row_dynamic(ctx, bounds.h, 1)
            local files = config.assets.data
            wdgts.widget_list_selectable(ctx, "source_files", nk.NK_WINDOW_BORDER, files, bounds.w -40 )
        end,
    } 
}

-- --------------------------------------------------------------------------------------

local folder_select = {
    popup_active = 0,
    popup_dim = ffi.new("struct nk_rect",{20, 100, 220, 90}),
    folder_path = ".",
    hit = {0, "", 0},

    ui_func = function(ctx, dim, udata)

        nk.nk_layout_row_dynamic(ctx, dim.h-20, 1)
        local flags = bit.bor(nk.NK_WINDOW_BORDER, nk.NK_WINDOW_TITLE)
        flags = bit.bor(flags, nk.NK_WINDOW_NO_SCROLLBAR)
        if (nk.nk_group_begin(ctx, "Select Folder", flags) == true) then
        
            nk.nk_layout_row_dynamic(ctx, dim.h-90, 1)
            local files = dirtools.get_folderslist(udata.folder_path)
            if(#files == 0 or files[1].name ~= "..") then table.insert(files, 1, { name = ".." }) end
            local bhit = wdgts.widget_list_buttons(ctx, "folder_files", nil, files, dim.w -40 )
            
            if(bhit) then
                udata.hit = bhit 
                if(bhit[2] == "..") then 
                    udata.folder_path = dirtools.get_folder(udata.folder_path)
                    if(udata.folder_path == nil or udata.folder_path == "") then udata.folder_path = "." end
                else
                    udata.folder_path = udata.folder_path.."\\"..udata.hit[2]
                end
                print(udata.folder_path)
            end

            nk.nk_layout_row_dynamic(ctx, 25, 2)
            if (nk.nk_button_label(ctx, "Cancel") == true) then
                udata.popup_active = 0
            end
            if (nk.nk_button_label(ctx, "OK") == true) then
                udata.popup_active = 0
            end
            nk.nk_group_end(ctx)
        end
        if(udata.popup_active == 0) then nk.nk_popup_close(ctx) end
        return udata.popup_active
    end,
}

-- --------------------------------------------------------------------------------------
-- Extract config and build ffi objects for them 
--   Each config property shall have a shadow ffi property labeled with _ffi
for sectionname, section in pairs(config) do

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
            print(prop.value)
            prop.ffi = ffi.new("char[?]", prop.slen )
            ffi.fill(prop.ffi, prop.slen, 0)
            ffi.copy(prop.ffi, ffi.string(prop.value))
            prop.len_ffi = ffi.new("int[1]", {string.len(prop.value)})
        elseif(prop.ptype == "file") then
            print(prop.value)
            prop.ffi = ffi.new("char[?]", prop.slen )
            ffi.fill(prop.ffi, prop.slen, 0)
            ffi.copy(prop.ffi, ffi.string(prop.value))
            prop.len_ffi = ffi.new("int[1]", {string.len(prop.value)})
        end
    end
end


local group_width = ffi.new("int[1]", {320})
local group_height = ffi.new("int[1]", {200})

-- --------------------------------------------------------------------------------------
local range_float_value = ffi.new("float[1]")

local function display_section(ctx, sectionname)

    local section = config[sectionname]
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
                    folder_select.folder_path = v.value
                end
                nk.nk_style_set_font(ctx, myfonts[3].handle)
            elseif(v.ptype == "file") then
                nk.nk_layout_row_push(ctx, value_col - 34)
                nk.nk_edit_string(ctx, nk.NK_EDIT_SIMPLE, v.ffi, v.len_ffi, v.slen, nk.nk_filter_default)
                nk.nk_style_set_font(ctx, myfonts[1].handle)
                nk.nk_layout_row_push(ctx, 30)
                nk.nk_button_label(ctx, "")
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
        name = "Project",
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
        name = "Logs" 
    } 
}
-- --------------------------------------------------------------------------------------

local function project_panel(ctx)

    nk.nk_style_set_font(ctx, myfonts[3].handle)

    project_curr_tab = wdgts.widget_notebook(ctx, "assets", project_tabs, project_curr_tab, 500, 120)
    -- display_section(ctx, "graphics")
    -- display_section(ctx, "audio")

    -- Awesome little radial popup.
    local res = wdgts.make_pie_popup(ctx, icons, 100, 6)
end


-- --------------------------------------------------------------------------------------

local function assets_panel(ctx)

    nk.nk_style_set_font(ctx, myfonts[3].handle)
    curr_tab = wdgts.widget_notebook(ctx, "assets", tabs, curr_tab, 500, 120)

    nk.nk_layout_row_begin(ctx, nk.NK_STATIC, 22, 3)
    nk.nk_layout_row_end(ctx)

end

-- --------------------------------------------------------------------------------------

local function main_ui(ctx)

    if(myfonts == nil) then 
        myfonts = fonts.setup_font(ctx, font_list)
    end

    wdgts.widget_panel_fixed(ctx, "WinMain", 0, 0, sapp.sapp_width(), sapp.sapp_height(), 0, function(data)

        folder_select.popup_active = wdgts.widget_popup_panel(ctx, "popup", folder_select.popup_dim, folder_select.ui_func, folder_select, folder_select.popup_active)

        nk.nk_style_set_font(ctx, myfonts[4].handle)

        local flags = nk.NK_WINDOW_BORDER
        local height = sapp.sapp_height()
        nk.nk_layout_row_dynamic(ctx, height-20, 2)

        -- wdgts.widget_panel_fixed(ctx, "Project", 10, 10, width, height, flags, function(data)
        if (nk.nk_group_begin(ctx, "Project", flags) == true) then

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

    return not nk.nk_window_is_closed(ctx, "Overview")
end

-- --------------------------------------------------------------------------------------
local pix = {}

local function init()

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

    folder_select.popup_dim.w = sapp.sapp_width()* 0.4
    folder_select.popup_dim.h = sapp.sapp_height()* 0.7
    folder_select.popup_dim.x = sapp.sapp_width()/2-8 - folder_select.popup_dim.w/2
    folder_select.popup_dim.y = sapp.sapp_height()/2-40 - folder_select.popup_dim.h/2
end

-- --------------------------------------------------------------------------------------

return {
    config      = config,

    init        = init, 
    main_ui     = main_ui,
}


-- --------------------------------------------------------------------------------------

