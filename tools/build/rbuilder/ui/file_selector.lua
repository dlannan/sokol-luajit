
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

-- --------------------------------------------------------------------------------------

local file_selector = {}

-- --------------------------------------------------------------------------------------

file_selector.create_file_selector = function( name, rect, start_folder, folders_only )

    local file_select = {
        popup_active = 0,
        prop = nil,
        drives = {},
        popup_dim = rect,
        fs_type = folders_only,
        folder_path = start_folder,
        file_selected = "",
        hit = {0, "", 0},

        ui_func = function(ctx, dim, udata)

            nk.nk_layout_row_dynamic(ctx, dim.h-20, 1)
            local flags = bit.bor(nk.NK_WINDOW_BORDER, nk.NK_WINDOW_TITLE)
            flags = bit.bor(flags, nk.NK_WINDOW_NO_SCROLLBAR)
            if (nk.nk_group_begin(ctx, name, flags) == true) then
            
                nk.nk_layout_row_begin(ctx, nk.NK_DYNAMIC, 25, 2)
                nk.nk_layout_row_push(ctx, 0.2)
                nk.nk_label(ctx, "Drives: ", 1)
                
                for k,v in ipairs(udata.drives) do
                    nk.nk_layout_row_push(ctx, 0.1)
                    if(nk.nk_button_label(ctx, v) == true) then 
                        udata.folder_path = v
                    end
                end
                nk.nk_layout_row_end(ctx)

                if(udata.fs_type) then
                    nk.nk_layout_row_dynamic(ctx, dim.h-110, 1)
                    local files = dirtools.get_folderslist(udata.folder_path)
                    local bhit = wdgts.widget_list_buttons(ctx, "folder_files", nil, files, dim.w -40 )
                    
                    if(bhit) then
                        udata.hit = bhit 
                        if(bhit[2] == "..") then 
                            udata.folder_path = dirtools.get_parent(udata.folder_path)
                        else
                            udata.folder_path = dirtools.change_folder(udata.folder_path, udata.hit[2])
                        end
                    end
                else
                    nk.nk_layout_row_dynamic(ctx, dim.h-110, 1)
                    local files = dirtools.get_dirlist(udata.folder_path)
                    local bhit = wdgts.widget_list_buttons(ctx, "select_file", nil, files, dim.w -40 )
                    
                    if(bhit) then
                        udata.hit = bhit 
                        if(bhit[2] == "..") then 
                            udata.folder_path = dirtools.get_parent(udata.folder_path)
                        else
                            local isfolder = files[udata.hit[1]].folder ~= nil
                            if(isfolder == true) then 
                                udata.folder_path = dirtools.change_folder(udata.folder_path, udata.hit[2])
                            else 
                                udata.file_selected  = dirtools.change_folder(udata.folder_path, udata.hit[2])
                            end
                        end
                    end
                end
                nk.nk_layout_row_dynamic(ctx, 25, 2)
                if (nk.nk_button_label(ctx, "Cancel") == true) then
                    udata.popup_active = 0
                    if(udata.callback) then 
                        udata.callback(udata, false)
                    end
                end
                if (nk.nk_button_label(ctx, "OK") == true) then
                    udata.popup_active = 0
                    if(udata.prop) then 
                        udata.prop.value = udata.file_selected
                        udata.prop.ffi = ffi.new("char[?]", udata.prop.slen )
                        ffi.fill(udata.prop.ffi, udata.prop.slen, 0)
                        ffi.copy(udata.prop.ffi, ffi.string(udata.prop.value))
                        udata.prop.len_ffi = ffi.new("int[1]", {string.len(udata.prop.value)})
                    end
                    if(udata.callback) then 
                        udata.callback(udata, true)
                    end
                end
                nk.nk_group_end(ctx)
            end
            if(udata.popup_active == 0) then nk.nk_popup_close(ctx) end
            return udata.popup_active
        end,
    }

    return file_select
end

-- --------------------------------------------------------------------------------------



-- --------------------------------------------------------------------------------------

return file_selector

-- --------------------------------------------------------------------------------------
