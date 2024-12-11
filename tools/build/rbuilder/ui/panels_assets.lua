
-- --------------------------------------------------------------------------------------

local ffi       = require("ffi")

local dirtools  = require("tools.vfs.dirtools")
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
local logging   = require("utils.logging")

-- --------------------------------------------------------------------------------------

local assets = {

    curr_tab          = 1,
    font              = nil,
}

local tabs = { 
    { 
        name = "Lua Source",
        func = function(ctx) 
            
            local bounds = nk.nk_window_get_content_region(ctx)
            nk.nk_layout_row_dynamic(ctx, bounds.h, 1)
            local files = assets.config.assets.lua 
            wdgts.widget_list_removeable(ctx, "lua_source_files", nk.NK_WINDOW_BORDER, files, bounds.w -40 )
        end,
        asset_name = "lua",
    }, 
    { 
        name = "Shaders",
        func = function(ctx) 
            
            local bounds = nk.nk_window_get_content_region(ctx)
            nk.nk_layout_row_dynamic(ctx, bounds.h, 1)
            if(assets.config.assets.shaders == nil) then assets.config.assets.shaders = settings.default_settings.assets.shaders end
            local files = assets.config.assets.shaders 
            wdgts.widget_list_removeable(ctx, "shader_source_files", nk.NK_WINDOW_BORDER, files, bounds.w -40 )
        end,
        asset_name = "shaders",
    }, 
    { 
        name = "Images",
        func = function(ctx) 
            
            local bounds = nk.nk_window_get_content_region(ctx)
            nk.nk_layout_row_dynamic(ctx, bounds.h, 1)
            local files = assets.config.assets.images 
            wdgts.widget_list_removeable(ctx, "image_source_files", nk.NK_WINDOW_BORDER, files, bounds.w -40 )
        end,
        asset_name = "images",
    }, 
    { 
        name = "Data",
        func = function(ctx) 
            
            local bounds = nk.nk_window_get_content_region(ctx)
            nk.nk_layout_row_dynamic(ctx, bounds.h, 1)
            local files = assets.config.assets.data
            wdgts.widget_list_removeable(ctx, "data_source_files", nk.NK_WINDOW_BORDER, files, bounds.w -40 )
        end,
        asset_name = "data",
    } 
}


-- --------------------------------------------------------------------------------------

assets.panel = function(ctx)

    nk.nk_style_set_font(ctx, assets.font[3].handle)

    local r = nk.nk_window_get_content_region(ctx)
    local flags = nk.NK_WINDOW_BORDER
    assets.curr_tab, named_tab = wdgts.widget_notebook(ctx, "assets", flags, tabs, assets.curr_tab, r.h-60, 120)

    nk.nk_layout_row_dynamic(ctx, 25, 2)
    if (nk.nk_button_label(ctx, "Add Folder") == true) then
        fsel.open(assets.folder_select, ".", nil, function(udata, res)
            print(udata.folder_path, named_tab, res)
            if(res == true) then
                local tabinfo = tabs[assets.curr_tab]
                local newfolder = {
                    name=ffi.string(udata.folder_path),
                    select = ffi.new("bool[1]", {0})
                }
                table.insert(assets.config.assets[tabinfo.asset_name], newfolder)
            end 
        end)
    end

    if (nk.nk_button_label(ctx, "Add File") == true) then
        fsel.open(assets.file_select, ".", nil, function(udata, res)
            if(res == true) then
                local tabinfo = tabs[assets.curr_tab]
                local newfile = {
                    name=ffi.string(udata.file_selected),
                    select = ffi.new("bool[1]", {0})
                }
                table.insert(assets.config.assets[tabinfo.asset_name], newfile)
            end 
        end)
    end    

end

-- --------------------------------------------------------------------------------------

return assets

-- --------------------------------------------------------------------------------------
