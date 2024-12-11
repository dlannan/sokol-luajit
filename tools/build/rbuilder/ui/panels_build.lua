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

local build           = {

    curr_tab = 1,
    font = nil,
    run_config  = nil,

    mode    = nil,
    active  = 0,
    progress = ffi.new("size_t[1]", { 0 } ),
    status  = "",
    handler = nil, 
    ui_func = function(ctx, dim, build) 

        nk.nk_layout_row_dynamic(ctx, dim.h-20, 1)

        local flags = bit.bor(nk.NK_WINDOW_BORDER, nk.NK_WINDOW_TITLE)
        flags = bit.bor(flags, nk.NK_WINDOW_NO_SCROLLBAR)
        if (nk.nk_group_begin(ctx, "Building...", flags) == true) then
        
            nk.nk_layout_row_dynamic(ctx, dim.h-dim.h/2 - 50, 1)
            nk.nk_layout_row_dynamic(ctx, 25, 1)
            nk.nk_label(ctx, "Please wait. Build mode: "..build.mode, nk.NK_TEXT_CENTERED)
            nk.nk_layout_row_dynamic(ctx, 25, 1)
            nk.nk_progress(ctx, build.progress, 1000, nk.NK_FIXED)
            nk.nk_group_end(ctx)  
        end

        if(build.handler) then build.handler(ctx, build) end

        if(build.active == 0) then nk.nk_popup_close(ctx) end
        return build.active
    end,
}

-- --------------------------------------------------------------------------------------
-- Attempts to find sokol in nearby folders (up max 4 directories from builder)
--    Sets all the sokol properties if it does find it
local function search_sokol(ctx)

    local r = nk.nk_window_get_content_region(ctx)
    build.run_config = nil

    nk.nk_layout_space_begin(ctx, nk.NK_STATIC, 27, 1)
    nk.nk_layout_space_push(ctx, nk.nk_rect(r.w-40, -195, 27, 27))

    nk.nk_style_set_font(ctx, build.font[1].handle)
    if(nk.nk_button_label(ctx, "") == true) then
        -- do search stuff
        local found = dirtools.find_folder(".", 5, "sokol-luajit")
        if(found) then 
            found = dirtools.combine_path(found, "sokol-luajit")
            logging.info(string.format("Found Sokol-luajit: %s",found))
            logging.info("Auto filling sokol paths...")
            build.config["sokol"].sokol_path.value = found 
            build.config["sokol"].sokol_bin.value = dirtools.combine_path(found, "bin")
            build.config["sokol"].sokol_ffi.value = dirtools.combine_path(found, "ffi")
            build.config["sokol"].sokol_lua.value = dirtools.combine_path(found, "lua")
            build.config["sokol"].sokol_examples.value = dirtools.combine_path(found, "examples")
            build.run_config = true
        end
    end
    nk.nk_style_set_font(ctx, build.font[3].handle)
    nk.nk_layout_space_end(ctx)
end

-- --------------------------------------------------------------------------------------

local function display_section(ctx, sectionname)

    local section = build.config[sectionname]
    if(section == nil) then 
        build.config[sectionname] = settings.default_settings[sectionname]
        section = settings.default_settings[sectionname] 
    end
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
                local flags = nk.nk_edit_string(ctx, nk.NK_EDIT_SIMPLE, v.ffi, v.len_ffi, v.slen, nk.nk_filter_default)
                if(flags ~= nk.NK_EDIT_ACTIVE and flags ~= nk.NK_EDIT_ACTIVATED) then 
                    v.value = ffi.string(v.ffi)
                end 
            elseif(v.ptype == "path") then
                nk.nk_layout_row_push(ctx, value_col - 34)
                nk.nk_edit_string(ctx, nk.NK_EDIT_SIMPLE, v.ffi, v.len_ffi, v.slen, nk.nk_filter_default)
                nk.nk_style_set_font(ctx, build.font[1].handle)
                nk.nk_layout_row_push(ctx, 30)               
                if(nk.nk_button_label(ctx, "") == true) then 
                    fsel.open(build.folder_select, v.value, v)
                end
                nk.nk_style_set_font(ctx, build.font[3].handle)
            elseif(v.ptype == "file") then
                nk.nk_layout_row_push(ctx, value_col - 34)
                nk.nk_edit_string(ctx, nk.NK_EDIT_SIMPLE, v.ffi, v.len_ffi, v.slen, nk.nk_filter_default)
                nk.nk_style_set_font(ctx, build.font[1].handle)
                nk.nk_layout_row_push(ctx, 30)
                if(nk.nk_button_label(ctx, "") == true) then 
                    fsel.open(build.file_select, v.value, v)
                end
                nk.nk_style_set_font(ctx, build.font[3].handle)
            elseif(v.ptype == "combo") then 
                nk.nk_layout_row_push(ctx, value_col)
                v.value = wdgts.widget_combo_box(ctx, v.plist, v.value, 200)
            elseif(v.ptype == "check") then
                nk.nk_layout_row_push(ctx, value_col)
                -- Hide the text for the key (nasty hack make text alpha)
                local tmpn = ctx.style.checkbox.text_normal
                local tmph = ctx.style.checkbox.text_hover
                local tmpa = ctx.style.checkbox.text_active
                ctx.style.checkbox.text_normal = nk.nk_rgba(255,0,0,0)
                ctx.style.checkbox.text_hover = nk.nk_rgba(255,0,0,0)
                ctx.style.checkbox.text_active = nk.nk_rgba(255,0,0,0)
                nk.nk_checkbox_label(ctx, v.key, v.ffi)
                ctx.style.checkbox.text_normal = nk.nk_rgba(tmpn.r, tmpn.g, tmpn.b, tmpn.a)
                ctx.style.checkbox.text_hover = nk.nk_rgba(tmph.r, tmph.g, tmph.b, tmph.a)
                ctx.style.checkbox.text_active = nk.nk_rgba(tmpa.r, tmpa.g, tmpa.b, tmpa.a)
            elseif(v.ptype == "int") then
                nk.nk_layout_row_push(ctx, value_col)
                nk.nk_property_int(ctx, v.key, v.vmin, v.ffi, v.vmax, v.vstep, v.vinc)
            elseif(v.ptype == "float") then
                nk.nk_layout_row_push(ctx, value_col)
                nk.nk_property_float(ctx, v.key, v.vmin, v.ffi, v.vmax, v.vstep, v.vinc)
            end
            nk.nk_layout_row_end(ctx)
        end
        nk.nk_group_end(ctx)
    end
end

-- --------------------------------------------------------------------------------------

local project_tabs = { 
    { 
        name = "Settings",
        func = function(ctx) 
            display_section(ctx, "project") 
            display_section(ctx, "sokol")
            search_sokol(ctx)
            display_section(ctx, "graphics")
        end,
    }, 
    { 
        name = "Build",
        func = function(ctx) 
            display_section(ctx, "platform") 
            display_section(ctx, "options") 
        end,
    }, 
    { 
        name = "Logs",
        func = function(ctx)
            local bounds = nk.nk_window_get_content_region(ctx)
            nk.nk_layout_row_dynamic(ctx, bounds.h, 1)
            wdgts.widget_list(ctx, "Logs", nk.NK_WINDOW_BORDER, logging.loglines)
        end,
    } 
}

-- --------------------------------------------------------------------------------------

build.panel = function(ctx)

    nk.nk_style_set_font(ctx, build.font[3].handle)

    local r = nk.nk_window_get_content_region(ctx)
    local flags = nk.NK_WINDOW_BORDER
    build.curr_tab = wdgts.widget_notebook(ctx, "assets", flags, project_tabs, build.curr_tab, r.h-60, 120)
    -- display_section(ctx, "graphics")
    -- display_section(ctx, "audio")

    nk.nk_layout_row_dynamic(ctx, 25, 2)
    if (nk.nk_button_label(ctx, "Build Release") == true) then
        build.mode = "release"
        build.active = 1
    end
    if (nk.nk_button_label(ctx, "Clean All") == true) then
        build.mode = "clean"
        build.active = 1
    end    

    -- Awesome little radial popup.
    local res = wdgts.make_pie_popup(ctx, icons, 100, 6)
end

-- --------------------------------------------------------------------------------------

return build

-- --------------------------------------------------------------------------------------
