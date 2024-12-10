-- A util for makin themes. Create a theme, and then add it to the theme pool

local sapp      = require("sokol_app")
local nk        = sg
local ffi       = require("ffi")

local indexes = {
    NK_COLOR_TEXT                = 0,
    NK_COLOR_WINDOW              = 1,
    NK_COLOR_HEADER              = 2,
    NK_COLOR_BORDER              = 3,
    NK_COLOR_BUTTON              = 4,
    NK_COLOR_BUTTON_HOVER        = 5,
    NK_COLOR_BUTTON_ACTIVE       = 6,
    NK_COLOR_TOGGLE              = 7,
    NK_COLOR_TOGGLE_HOVER        = 8,
    NK_COLOR_TOGGLE_CURSOR       = 9,
    NK_COLOR_SELECT              = 10,
    NK_COLOR_SELECT_ACTIVE       = 11,
    NK_COLOR_SLIDER              = 12,
    NK_COLOR_SLIDER_CURSOR       = 13, 
    NK_COLOR_SLIDER_CURSOR_HOVER = 14,
    NK_COLOR_SLIDER_CURSOR_ACTIVE = 15,
    NK_COLOR_PROPERTY            = 16, 
    NK_COLOR_EDIT                = 17,
    NK_COLOR_EDIT_CURSOR         = 18,
    NK_COLOR_COMBO               = 19,
    NK_COLOR_CHART               = 20,
    NK_COLOR_CHART_COLOR         = 21,
    NK_COLOR_CHART_COLOR_HIGHLIGHT = 22,
    NK_COLOR_SCROLLBAR           = 23,
    NK_COLOR_SCROLLBAR_CURSOR    = 24,
    NK_COLOR_SCROLLBAR_CURSOR_HOVER = 25,
    NK_COLOR_SCROLLBAR_CURSOR_ACTIVE = 26,
    NK_COLOR_TAB_HEADER          = 27,
}

local theme_index_keys = {}
for k,v in pairs(indexes) do
    theme_index_keys[v+1] = tostring(k)
end

local function make_nk_color( hexnum )
    local col = ffi.new("struct nk_color")
    col.r = bit.band( hexnum, 0xff )
    col.g = bit.band( bit.rshift(hexnum, 8), 0xff )
    col.b = bit.band( bit.rshift(hexnum, 16), 0xff )
    col.a = bit.band( bit.rshift(hexnum, 24), 0xff )
    return col
end

local colors = {
    cyan        = make_nk_color(0xff119da4),
    cerulean    = make_nk_color(0xff0c7489),
    midnight_green = make_nk_color(0xff13505b),
    black       = make_nk_color(0xff040404),
    timberwolf  = make_nk_color(0xffd7d9ce),

    oxford_blue = make_nk_color(0xff0b132b),
    space_cadet = make_nk_color(0xff1c2541),
    yinmin_blue = make_nk_color(0xff3a506b),
    vedigris    = nk.nk_rgba_hex("5bc0be"),
    white       = make_nk_color(0xffffffff),

    gunmetal    = make_nk_color(0xff253237),
    paynes_dark = make_nk_color(0xff2c3b43),
    paynes_gray = make_nk_color(0xff5c6b73),
    cadet_gray  = make_nk_color(0xff6d94a0),
    light_blue  = nk.nk_rgba_hex("ADD8E6"),
    light_cyan  = make_nk_color(0xffc0dbdc),

    techalpha   = make_nk_color(0x00177772),
    techbg1     = make_nk_color(0xff177772),
    techbg2     = nk.nk_rgba_hex("29f9e5"),
    techfg1     = make_nk_color(0x800c3d46),
    tech_black  = make_nk_color(0xff000000),

    tech_primary  = {
         nk.nk_rgba_hex("170e47"),
         nk.nk_rgba_hex("31245a"),
         nk.nk_rgba_hex("493c6d"),
         nk.nk_rgba_hex("625581"),
         nk.nk_rgba_hex("7b6f95"),
         nk.nk_rgba_hex("948aaa"),
    },
    tech_surface  = {
        nk.nk_rgba_hex("121212"),
        nk.nk_rgba_hex("282828"),
        nk.nk_rgba_hex("3f3f3f"),
        nk.nk_rgba_hex("575757"),
        nk.nk_rgba_hex("717171"),
        nk.nk_rgba_hex("8b8b8b"),
    },
    tech_mixed    = {
        nk.nk_rgba_hex("171127"),
        nk.nk_rgba_hex("2c273c"),
        nk.nk_rgba_hex("433e51"),
        nk.nk_rgba_hex("5b5668"),
        nk.nk_rgba_hex("75707f"),
        nk.nk_rgba_hex("8f8b97"),
    },
}

-----------------------------------------------------------------------------------

local default_colors = ffi.new("struct nk_color[28]",{
    {175,175,175,255},
    {45, 45, 45, 255},
    {40, 40, 40, 255},
    {65, 65, 65, 255},
    {50, 50, 50, 255},
    {40, 40, 40, 255},
    {35, 35, 35, 255},
    {100,100,100,255},
    {120,120,120,255},
    {45, 45, 45, 255},
    {45, 45, 45, 255},
    {35, 35, 35,255},
    {38, 38, 38, 255},
    {100,100,100,255},
    {120,120,120,255},
    {150,150,150,255},
    {38, 38, 38, 255},
    {38, 38, 38, 255},
    {175,175,175,255},
    {45, 45, 45, 255},
    {120,120,120,255},
    {45, 45, 45, 255},
    {255, 0,  0, 255},
    {40, 40, 40, 255},
    {100,100,100,255},
    {120,120,120,255},
    {150,150,150,255},
    {40, 40, 40,255}
})

-----------------------------------------------------------------------------------
-- Some custom color slots to match the old method
local custom_colors = 
{
    ffi.new("struct nk_color[28]",default_colors),
    ffi.new("struct nk_color[28]",default_colors),
    ffi.new("struct nk_color[28]",default_colors),
}

-----------------------------------------------------------------------------------

local themes = {

    indexes = indexes,
    editor_theme = {},

    colors = colors,

    theme_names = { "default", "custom", "tech", "gray_blue" },
    
    default = function(ctx)

        nk.nk_style_from_table(ctx, default_colors)
    end,

    custom = function(ctx, customid)

        local customid = customid or 1
        nk.nk_style_from_table(ctx, custom_colors[customid])
    end,
}
    
 themes.tech = function(ctx)

    local color_tbl = custom_colors[2]

    color_tbl[indexes.NK_COLOR_TEXT] = colors.white           -- text color 
    color_tbl[indexes.NK_COLOR_WINDOW] = colors.tech_mixed[1] -- colors.techalpha        -- bg color 

    color_tbl[indexes.NK_COLOR_HEADER] = colors.tech_mixed[2]                 -- header color 
    color_tbl[indexes.NK_COLOR_BORDER] = colors.tech_surface[3]           -- border color 

    color_tbl[indexes.NK_COLOR_BUTTON] = colors.tech_primary[2]        -- button color
    color_tbl[indexes.NK_COLOR_BUTTON_HOVER] = colors.tech_primary[3]      -- button hover color
    color_tbl[indexes.NK_COLOR_BUTTON_ACTIVE] = colors.tech_primary[4]      -- button active color

    color_tbl[indexes.NK_COLOR_TOGGLE] = colors.tech_primary[6]      -- toggle color
    color_tbl[indexes.NK_COLOR_TOGGLE_HOVER] =  colors.tech_mixed[4]    -- toggle hover color
    color_tbl[indexes.NK_COLOR_TOGGLE_CURSOR] = colors.white       -- toggle active color

    color_tbl[indexes.NK_COLOR_SELECT] = colors.tech_primary[2]                -- select color
    color_tbl[indexes.NK_COLOR_SELECT_ACTIVE] = colors.tech_mixed[1]        -- select active color
    
    color_tbl[indexes.NK_COLOR_SLIDER] = colors.paynes_gray     -- slider color
    color_tbl[indexes.NK_COLOR_SLIDER_CURSOR] = colors.cadet_gray      -- slider cursor
    color_tbl[indexes.NK_COLOR_SLIDER_CURSOR_HOVER] = colors.paynes_gray     -- slider hover
    color_tbl[indexes.NK_COLOR_SLIDER_CURSOR_ACTIVE] = colors.paynes_gray     -- slider active

    color_tbl[indexes.NK_COLOR_PROPERTY] = colors.paynes_gray     -- property color

    color_tbl[indexes.NK_COLOR_EDIT] = colors.tech_mixed[3]            -- edit color 
    color_tbl[indexes.NK_COLOR_EDIT_CURSOR] = colors.tech_mixed[6]      -- edit cursor color

    color_tbl[indexes.NK_COLOR_COMBO] = colors.tech_mixed[3]     -- combo color
    
    color_tbl[indexes.NK_COLOR_CHART] = colors.tech_black         -- chart bg color
    color_tbl[indexes.NK_COLOR_CHART_COLOR] = colors.tech_black      -- chart color
    color_tbl[indexes.NK_COLOR_CHART_COLOR_HIGHLIGHT] = colors.tech_black      -- chart color highlight

    color_tbl[indexes.NK_COLOR_SCROLLBAR] = colors.tech_black      -- scrollbar color
    color_tbl[indexes.NK_COLOR_SCROLLBAR_CURSOR] = colors.tech_black      -- scrollbar cursor color
    color_tbl[indexes.NK_COLOR_SCROLLBAR_CURSOR_HOVER] = colors.tech_black      -- scrollbar cursor hover color
    color_tbl[indexes.NK_COLOR_SCROLLBAR_CURSOR_ACTIVE] = colors.tech_black      -- scrollbar cursor active color

    color_tbl[indexes.NK_COLOR_TAB_HEADER] = colors.techfg1         -- tab header color 
    nk.nk_style_from_table(ctx, custom_colors[2])
end

themes.gray_blue = function(ctx)

    local color_tbl = custom_colors[3]
    
    color_tbl[indexes.NK_COLOR_TEXT] = colors.white
    color_tbl[indexes.NK_COLOR_WINDOW] = make_nk_color(0xe0253237) -- bg color 

    color_tbl[indexes.NK_COLOR_HEADER] = colors.paynes_gray      -- header color 
    color_tbl[indexes.NK_COLOR_BORDER] = colors.light_blue       -- border color 

    color_tbl[indexes.NK_COLOR_BUTTON] = colors.gunmetal         -- button color
    color_tbl[indexes.NK_COLOR_BUTTON_HOVER] = colors.cadet_gray       -- button hover color
    color_tbl[indexes.NK_COLOR_BUTTON_ACTIVE] = colors.light_blue       -- button active color

    color_tbl[indexes.NK_COLOR_TOGGLE] = colors.paynes_gray      -- toggle color
    color_tbl[indexes.NK_COLOR_TOGGLE_HOVER] = colors.cadet_gray       -- toggle hover color
    color_tbl[indexes.NK_COLOR_TOGGLE_CURSOR] = colors.light_blue       -- toggle active color

    color_tbl[indexes.NK_COLOR_SELECT] = colors.paynes_dark     -- select color
    color_tbl[indexes.NK_COLOR_SELECT_ACTIVE] = colors.light_blue      -- select active color
    
    color_tbl[indexes.NK_COLOR_SLIDER] = colors.paynes_gray     -- slider color
    color_tbl[indexes.NK_COLOR_SLIDER_CURSOR] = colors.cadet_gray      -- slider cursor
    color_tbl[indexes.NK_COLOR_SLIDER_CURSOR_HOVER] = colors.paynes_gray     -- slider hover
    color_tbl[indexes.NK_COLOR_SLIDER_CURSOR_ACTIVE] = colors.paynes_gray     -- slider active

    color_tbl[indexes.NK_COLOR_PROPERTY] = colors.paynes_gray     -- property color

    color_tbl[indexes.NK_COLOR_EDIT] = colors.paynes_gray     -- edit color 
    color_tbl[indexes.NK_COLOR_EDIT_CURSOR] = colors.light_blue      -- edit cursor color

    color_tbl[indexes.NK_COLOR_COMBO] = colors.paynes_gray     -- combo color

    -- color_tbl[indexes.NK_COLOR_COMBO] = colors.paynes_gray)     -- combo color

    -- color_tbl[indexes.NK_COLOR_CHART] = colors.tech_black)      -- chart bg color
    
    -- color_tbl[indexes.NK_COLOR_CHART_COLOR] = colors.tech_black)      -- chart color
    -- color_tbl[indexes.NK_COLOR_CHART_COLOR_HIGHLIGHT] = colors.tech_black)      -- chart color highlight

    -- color_tbl[indexes.NK_COLOR_SCROLLBAR] = colors.tech_black)      -- scrollbar color
    -- color_tbl[indexes.NK_COLOR_SCROLLBAR_CURSOR] = colors.tech_black)      -- scrollbar cursor color
    -- color_tbl[indexes.NK_COLOR_SCROLLBAR_CURSOR_HOVER] = colors.tech_black)      -- scrollbar cursor hover color
    -- color_tbl[indexes.NK_COLOR_SCROLLBARCURSOR_ACTIVE] = colors.tech_black)      -- scrollbar cursor active color
    
    color_tbl[indexes.NK_COLOR_TAB_HEADER] = colors.paynes_gray     -- tab header color 

    nk.nk_style_from_table(ctx, custom_colors[3])
end

-----------------------------------------------------------------------------------
-- Save a theme in the above format as lua. 
--    This allows themes to eb used without the editor and this file. 

local function save_theme( filename )

    local fh = io.open(filename, "w")
    if(fh == nil) then 
        print("[Error Save Theme] Cannot save to file: "..filename)
        return nil
    end 

    -- Always save out a theme into the custom style. Dont overwrite builtin styles
    fh:write("-- -----------------------------------------------------------------------\n")
    fh:write("-- Auto generated theme file. Do not edit!\n")
    fh:write("-- -----------------------------------------------------------------------\n")
    fh:write("nk.nk_set_style(2, 255, 0xffffffff)  -- set custom style\n")

    for k,v in ipairs(theme_index_keys) do        
        fh:write("nk.nk_set_style_prop(ctx,indexes."..v..", "..string.format("0x%0x", nk.nk_get_style_prop(ctx,indexes[v]))..")\n" )
    end
    fh:write("nk.nk_set_style_table(ctx)\n")
    fh:close()

end

-----------------------------------------------------------------------------------
-- Loading a theme is really simple. 
--    Loadstring and run it. We cannot use require, because it only loads once.

local function load_theme( filename )

    local fh = io.open(filename, "r")
    if(fh == nil) then 
        print("[Error Save Theme] Cannot save to file: "..filename)
        return nil
    end 
    local themestr = fh:read("*a")
    fh:close()

    local func = assert(load(themestr, themestr, "t" , {indexes=indexes, nuklear=nuklear}))
    func()
end

-----------------------------------------------------------------------------------
-- Theme editor panel. Load, Save and Modify your theme. 
--    Themes are in the same format as above, and can be used in place of this file.

themes.theme_panel = function ( self, font, left, top, width, height, readonly )

	local y = top
	local x = left

    local flags = bit.bor(self.flags.NK_WINDOW_TITLE, self.flags.NK_WINDOW_BORDER)
	flags = bit.bor(flags, self.flags.NK_WINDOW_MOVABLE)
	flags = bit.bor(flags, self.flags.NK_WINDOW_MINIMIZABLE)
    flags = bit.bor(flags, self.flags.NK_WINDOW_NO_SCROLLBAR)

    local bg_current = nk.nk_get_style_prop( indexes.NK_COLOR_WINDOW )
    local txt_current = nk.nk_get_style_prop( indexes.NK_COLOR_TEXT )
    nk.nk_set_style_prop(ctx,indexes.NK_COLOR_WINDOW, 0xff000000)
    nk.nk_set_style_prop(ctx,indexes.NK_COLOR_TEXT, 0xffffffff)
    nk.nk_set_style_table(ctx)
        
	local winshow = nk.nk_begin_window( "Theme Editor", x, y, width, height, flags)

    -- Using index 2 for this panel. Which means editing it wont change anything.
    local newx, newy, wide, high = nk.nk_get_bounds_window(ctx)
    -- Ensure alpga is enabled on bg for this panel
    
    nk.nk_style_set_font(ctx, self.fonts.fontid )
    --nk.nk_fill_rect(left, top, width + 30, height + 30, 0, 0x000001ff)

    nk.nk_layout_row_dynamic(ctx,30, 1)
    local select_theme = tonumber(nk.nk_combo( ctx,themes.theme_names, self.theme_select or 2, 25, 280, 200 ))

    nk.nk_layout_row_dynamic(ctx,30, 1)
    local select_index = nk.nk_combo( ctx,theme_index_keys, self.theme_index_select or 0, 25, 280, 200 )
    if(select_index ~= self.theme_index_select) then 
    
        local indexcol = nk.nk_get_style_prop(ctx,select_index)
        self.theme_index_color = indexcol 
        self.theme_index_select = select_index
    end 
            
    local index_color = nk.nk_picker_color_complex(ctx, self.theme_index_color or 0xffffffff )
    
    nk.nk_layout_row_dynamic(ctx,30, 1)
    local set_style = nk.nk_button_label_active(ctx, "Apply Style" )

    nk.nk_layout_row_dynamic(ctx,30, 1)
    self.style_path = nk.nk_edit_string(ctx,10,  self.style_path or "./config/custom_theme.lua", 128, 1)
    
    nk.nk_layout_row_dynamic(ctx,30, 2)
    local load_style = nk.nk_button_label_active(ctx, "Load Style" )
    local save_style = nk.nk_button_label_active(ctx, "Save Style" )
    
    if(save_style == 1) then 
        save_theme( self.style_path )
    end

    if(load_style == 1) then 
        load_theme( self.style_path )
    end

    if(select_theme ~= self.theme_select) then 
        self.theme_select = select_theme
        themes[themes.theme_names[self.theme_select+1]]()
    end

    nk.nk_set_style_prop(ctx,indexes.NK_COLOR_WINDOW, bg_current)
    nk.nk_set_style_prop(ctx,indexes.NK_COLOR_TEXT, txt_current)
    nk.nk_set_style_table(ctx)

    if (index_color ~= self.theme_index_color) then 
        self.theme_index_color = index_color
        nk.nk_set_style_prop(ctx,self.theme_index_select,  self.theme_index_color)
    end
    
    if(set_style == 1) then 
        nk.nk_set_style_table(ctx)
    end
    
    nk.nk_end(ctx)
end

-----------------------------------------------------------------------------------

return themes

-----------------------------------------------------------------------------------