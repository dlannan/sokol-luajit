-- --------------------------------------------------------------------------------------

local sapp          = require("sokol_app")
sg                  = require("sokol_gfx")
sg                  = require("sokol_nuklear")
local nk            = sg

-- --------------------------------------------------------------------------------------

local THEME_BLACK   = 0 
local THEME_WHITE   = 1 
local THEME_RED     = 2 
local THEME_BLUE    = 3
local THEME_DARK    = 4

-- --------------------------------------------------------------------------------------



-- --------------------------------------------------------------------------------------

local g_table = ffi.new("struct nk_color *[5]")
for i=0, 4 do 
    g_table[i] = ffi.new("struct nk_color[?]", tonumber(nk.NK_COLOR_COUNT + 1))
end 

-- --------------------------------------------------------------------------------------

local g_lasttheme = 0

-- --------------------------------------------------------------------------------------

local function nk_set_style_prop(prop, color)
    local theme_tbl = g_table[g_lasttheme]
    if(theme_tbl) then theme_tbl[prop] = nk.nk_rgba_u32(color) end
end

-- --------------------------------------------------------------------------------------

local function nk_set_style_table() 
    local ctx = renderer.ctx
    nk.nk_style_from_table(ctx, g_table[g_lasttheme])
end

-- --------------------------------------------------------------------------------------

local function nk_get_style_prop(prop)
    return nk.nk_color_u32(g_table[g_lasttheme][prop])
end

-- --------------------------------------------------------------------------------------

local function nk_set_style(theme, bgalpha, txtcolor)
    local ctx = renderer.ctx
    g_lasttheme = tonumber(theme)
    local theme_table = g_table[theme]
    if (theme == THEME_WHITE) then
        theme_table[nk.NK_COLOR_TEXT] = nk.nk_rgba(70, 70, 70, 255)
        if(txtcolor ~= 0) then
            theme_table[nk.NK_COLOR_TEXT] = nk.nk_rgba_u32(txtcolor)
        elseif(bgalpha ~= 255) then
            theme_table[nk.NK_COLOR_WINDOW] = nk.nk_rgba(175, 175, 175, bgalpha)
        else 
            theme_table[nk.NK_COLOR_WINDOW] = nk.nk_rgba(175, 175, 175, 255)
        end
        theme_table[nk.NK_COLOR_HEADER] = nk.nk_rgba(175, 175, 175, 255)
        theme_table[nk.NK_COLOR_BORDER] = nk.nk_rgba(0, 0, 0, 255)
        theme_table[nk.NK_COLOR_BUTTON] = nk.nk_rgba(185, 185, 185, 255)
        theme_table[nk.NK_COLOR_BUTTON_HOVER] = nk.nk_rgba(170, 170, 170, 255)
        theme_table[nk.NK_COLOR_BUTTON_ACTIVE] = nk.nk_rgba(160, 160, 160, 255)
        theme_table[nk.NK_COLOR_TOGGLE] = nk.nk_rgba(150, 150, 150, 255)
        theme_table[nk.NK_COLOR_TOGGLE_HOVER] = nk.nk_rgba(120, 120, 120, 255)
        theme_table[nk.NK_COLOR_TOGGLE_CURSOR] = nk.nk_rgba(175, 175, 175, 255)
        theme_table[nk.NK_COLOR_SELECT] = nk.nk_rgba(190, 190, 190, 255)
        theme_table[nk.NK_COLOR_SELECT_ACTIVE] = nk.nk_rgba(175, 175, 175, 255)
        theme_table[nk.NK_COLOR_SLIDER] = nk.nk_rgba(190, 190, 190, 255)
        theme_table[nk.NK_COLOR_SLIDER_CURSOR] = nk.nk_rgba(80, 80, 80, 255)
        theme_table[nk.NK_COLOR_SLIDER_CURSOR_HOVER] = nk.nk_rgba(70, 70, 70, 255)
        theme_table[nk.NK_COLOR_SLIDER_CURSOR_ACTIVE] = nk.nk_rgba(60, 60, 60, 255)
        theme_table[nk.NK_COLOR_PROPERTY] = nk.nk_rgba(175, 175, 175, 255)
        theme_table[nk.NK_COLOR_EDIT] = nk.nk_rgba(150, 150, 150, 255)
        theme_table[nk.NK_COLOR_EDIT_CURSOR] = nk.nk_rgba(0, 0, 0, 255)
        theme_table[nk.NK_COLOR_COMBO] = nk.nk_rgba(175, 175, 175, 255)
        theme_table[nk.NK_COLOR_CHART] = nk.nk_rgba(160, 160, 160, 255)
        theme_table[nk.NK_COLOR_CHART_COLOR] = nk.nk_rgba(45, 45, 45, 255)
        theme_table[nk.NK_COLOR_CHART_COLOR_HIGHLIGHT] = nk.nk_rgba( 255, 0, 0, 255)
        theme_table[nk.NK_COLOR_SCROLLBAR] = nk.nk_rgba(180, 180, 180, 255)
        theme_table[nk.NK_COLOR_SCROLLBAR_CURSOR] = nk.nk_rgba(140, 140, 140, 255)
        theme_table[nk.NK_COLOR_SCROLLBAR_CURSOR_HOVER] = nk.nk_rgba(150, 150, 150, 255)
        theme_table[nk.NK_COLOR_SCROLLBAR_CURSOR_ACTIVE] = nk.nk_rgba(160, 160, 160, 255)
        theme_table[nk.NK_COLOR_TAB_HEADER] = nk.nk_rgba(180, 180, 180, 255)
        nk.nk_style_from_table(ctx, theme_table)
    elseif (theme == THEME_RED) then
        theme_table[nk.NK_COLOR_TEXT] = nk.nk_rgba(190, 190, 190, 255)
        if(txtcolor ~= 0) then
            theme_table[nk.NK_COLOR_TEXT] = nk.nk_rgba_u32(txtcolor)
        end
        if(bgalpha ~= 215) then
            theme_table[nk.NK_COLOR_WINDOW] = nk.nk_rgba(30, 33, 40, bgalpha)
        else 
            theme_table[nk.NK_COLOR_WINDOW] = nk.nk_rgba(30, 33, 40, 215)
        end
        theme_table[nk.NK_COLOR_HEADER] = nk.nk_rgba(181, 45, 69, 220)
        theme_table[nk.NK_COLOR_BORDER] = nk.nk_rgba(51, 55, 67, 255)
        theme_table[nk.NK_COLOR_BUTTON] = nk.nk_rgba(181, 45, 69, 255)
        theme_table[nk.NK_COLOR_BUTTON_HOVER] = nk.nk_rgba(190, 50, 70, 255)
        theme_table[nk.NK_COLOR_BUTTON_ACTIVE] = nk.nk_rgba(195, 55, 75, 255)
        theme_table[nk.NK_COLOR_TOGGLE] = nk.nk_rgba(51, 55, 67, 255)
        theme_table[nk.NK_COLOR_TOGGLE_HOVER] = nk.nk_rgba(45, 60, 60, 255)
        theme_table[nk.NK_COLOR_TOGGLE_CURSOR] = nk.nk_rgba(181, 45, 69, 255)
        theme_table[nk.NK_COLOR_SELECT] = nk.nk_rgba(51, 55, 67, 255)
        theme_table[nk.NK_COLOR_SELECT_ACTIVE] = nk.nk_rgba(181, 45, 69, 255)
        theme_table[nk.NK_COLOR_SLIDER] = nk.nk_rgba(51, 55, 67, 255)
        theme_table[nk.NK_COLOR_SLIDER_CURSOR] = nk.nk_rgba(181, 45, 69, 255)
        theme_table[nk.NK_COLOR_SLIDER_CURSOR_HOVER] = nk.nk_rgba(186, 50, 74, 255)
        theme_table[nk.NK_COLOR_SLIDER_CURSOR_ACTIVE] = nk.nk_rgba(191, 55, 79, 255)
        theme_table[nk.NK_COLOR_PROPERTY] = nk.nk_rgba(51, 55, 67, 255)
        theme_table[nk.NK_COLOR_EDIT] = nk.nk_rgba(51, 55, 67, 225)
        theme_table[nk.NK_COLOR_EDIT_CURSOR] = nk.nk_rgba(190, 190, 190, 255)
        theme_table[nk.NK_COLOR_COMBO] = nk.nk_rgba(51, 55, 67, 255)
        theme_table[nk.NK_COLOR_CHART] = nk.nk_rgba(51, 55, 67, 255)
        theme_table[nk.NK_COLOR_CHART_COLOR] = nk.nk_rgba(170, 40, 60, 255)
        theme_table[nk.NK_COLOR_CHART_COLOR_HIGHLIGHT] = nk.nk_rgba( 255, 0, 0, 255)
        theme_table[nk.NK_COLOR_SCROLLBAR] = nk.nk_rgba(30, 33, 40, 255)
        theme_table[nk.NK_COLOR_SCROLLBAR_CURSOR] = nk.nk_rgba(64, 84, 95, 255)
        theme_table[nk.NK_COLOR_SCROLLBAR_CURSOR_HOVER] = nk.nk_rgba(70, 90, 100, 255)
        theme_table[nk.NK_COLOR_SCROLLBAR_CURSOR_ACTIVE] = nk.nk_rgba(75, 95, 105, 255)
        theme_table[nk.NK_COLOR_TAB_HEADER] = nk.nk_rgba(181, 45, 69, 220)
        nk.nk_style_from_table(ctx, theme_table)
    elseif (theme == THEME_BLUE) then
        theme_table[nk.NK_COLOR_TEXT] = nk.nk_rgba(20, 20, 20, 255)
        if(txtcolor ~= 0) then
            theme_table[nk.NK_COLOR_TEXT] = nk.nk_rgba_u32(txtcolor)
        end
        if(bgalpha ~= 215) then
            theme_table[nk.NK_COLOR_WINDOW] = nk.nk_rgba(12, 61, 70, bgalpha)
        else 
            theme_table[nk.NK_COLOR_WINDOW] = nk.nk_rgba(12, 61, 70, 215)
        end
        theme_table[nk.NK_COLOR_HEADER] = nk.nk_rgba_u32(0x80043e49)
        theme_table[nk.NK_COLOR_BORDER] = nk.nk_rgba(140, 159, 173, 255)
        theme_table[nk.NK_COLOR_BUTTON] = nk.nk_rgba_u32(0x80043e49)
        theme_table[nk.NK_COLOR_BUTTON_HOVER] = nk.nk_rgba_u32(0x800c3d46)
        theme_table[nk.NK_COLOR_BUTTON_ACTIVE] = nk.nk_rgba(147, 192, 234, 255)
        theme_table[nk.NK_COLOR_TOGGLE] = nk.nk_rgba(177, 210, 210, 255)
        theme_table[nk.NK_COLOR_TOGGLE_HOVER] = nk.nk_rgba(182, 215, 215, 255)
        theme_table[nk.NK_COLOR_TOGGLE_CURSOR] = nk.nk_rgba(137, 182, 224, 255)
        theme_table[nk.NK_COLOR_SELECT] = nk.nk_rgba(177, 210, 210, 255)
        theme_table[nk.NK_COLOR_SELECT_ACTIVE] = nk.nk_rgba(137, 182, 224, 255)
        theme_table[nk.NK_COLOR_SLIDER] = nk.nk_rgba(177, 210, 210, 255)
        theme_table[nk.NK_COLOR_SLIDER_CURSOR] = nk.nk_rgba(137, 182, 224, 245)
        theme_table[nk.NK_COLOR_SLIDER_CURSOR_HOVER] = nk.nk_rgba(142, 188, 229, 255)
        theme_table[nk.NK_COLOR_SLIDER_CURSOR_ACTIVE] = nk.nk_rgba(147, 193, 234, 255)
        theme_table[nk.NK_COLOR_PROPERTY] = nk.nk_rgba(210, 210, 210, 255)
        theme_table[nk.NK_COLOR_EDIT] = nk.nk_rgba(210, 210, 210, 225)
        theme_table[nk.NK_COLOR_EDIT_CURSOR] = nk.nk_rgba(20, 20, 20, 255)
        theme_table[nk.NK_COLOR_COMBO] = nk.nk_rgba(210, 210, 210, 255)
        theme_table[nk.NK_COLOR_CHART] = nk.nk_rgba(210, 210, 210, 255)
        theme_table[nk.NK_COLOR_CHART_COLOR] = nk.nk_rgba(137, 182, 224, 255)
        theme_table[nk.NK_COLOR_CHART_COLOR_HIGHLIGHT] = nk.nk_rgba( 255, 0, 0, 255)
        theme_table[nk.NK_COLOR_SCROLLBAR] = nk.nk_rgba(190, 200, 200, 255)
        theme_table[nk.NK_COLOR_SCROLLBAR_CURSOR] = nk.nk_rgba(64, 84, 95, 255)
        theme_table[nk.NK_COLOR_SCROLLBAR_CURSOR_HOVER] = nk.nk_rgba(70, 90, 100, 255)
        theme_table[nk.NK_COLOR_SCROLLBAR_CURSOR_ACTIVE] = nk.nk_rgba(75, 95, 105, 255)
        theme_table[nk.NK_COLOR_TAB_HEADER] = nk.nk_rgba(156, 193, 220, 255)
        nk.nk_style_from_table(ctx, theme_table)
    elseif (theme == THEME_DARK) then
        theme_table[nk.NK_COLOR_TEXT] = nk.nk_rgba(57, 67, 71, 215)
        if(txtcolor ~= 0) then
            theme_table[nk.NK_COLOR_TEXT] = nk.nk_rgba_u32(txtcolor)
        end
        if(bgalpha ~= 255) then
            theme_table[nk.NK_COLOR_WINDOW] = nk.nk_rgba(57, 67, 71, bgalpha)
        else 
            theme_table[nk.NK_COLOR_WINDOW] = nk.nk_rgba(57, 67, 71, 215)
        end
        theme_table[nk.NK_COLOR_HEADER] = nk.nk_rgba(51, 51, 56, 220)
        theme_table[nk.NK_COLOR_BORDER] = nk.nk_rgba(46, 46, 46, 255)
        theme_table[nk.NK_COLOR_BUTTON] = nk.nk_rgba(48, 83, 111, 255)
        theme_table[nk.NK_COLOR_BUTTON_HOVER] = nk.nk_rgba(58, 93, 121, 255)
        theme_table[nk.NK_COLOR_BUTTON_ACTIVE] = nk.nk_rgba(63, 98, 126, 255)
        theme_table[nk.NK_COLOR_TOGGLE] = nk.nk_rgba(50, 58, 61, 255)
        theme_table[nk.NK_COLOR_TOGGLE_HOVER] = nk.nk_rgba(45, 53, 56, 255)
        theme_table[nk.NK_COLOR_TOGGLE_CURSOR] = nk.nk_rgba(48, 83, 111, 255)
        theme_table[nk.NK_COLOR_SELECT] = nk.nk_rgba(57, 67, 61, 255)
        theme_table[nk.NK_COLOR_SELECT_ACTIVE] = nk.nk_rgba(48, 83, 111, 255)
        theme_table[nk.NK_COLOR_SLIDER] = nk.nk_rgba(50, 58, 61, 255)
        theme_table[nk.NK_COLOR_SLIDER_CURSOR] = nk.nk_rgba(48, 83, 111, 245)
        theme_table[nk.NK_COLOR_SLIDER_CURSOR_HOVER] = nk.nk_rgba(53, 88, 116, 255)
        theme_table[nk.NK_COLOR_SLIDER_CURSOR_ACTIVE] = nk.nk_rgba(58, 93, 121, 255)
        theme_table[nk.NK_COLOR_PROPERTY] = nk.nk_rgba(50, 58, 61, 255)
        theme_table[nk.NK_COLOR_EDIT] = nk.nk_rgba(50, 58, 61, 225)
        theme_table[nk.NK_COLOR_EDIT_CURSOR] = nk.nk_rgba(210, 210, 210, 255)
        theme_table[nk.NK_COLOR_COMBO] = nk.nk_rgba(50, 58, 61, 255)
        theme_table[nk.NK_COLOR_CHART] = nk.nk_rgba(50, 58, 61, 255)
        theme_table[nk.NK_COLOR_CHART_COLOR] = nk.nk_rgba(48, 83, 111, 255)
        theme_table[nk.NK_COLOR_CHART_COLOR_HIGHLIGHT] = nk.nk_rgba(255, 0, 0, 255)
        theme_table[nk.NK_COLOR_SCROLLBAR] = nk.nk_rgba(50, 58, 61, 255)
        theme_table[nk.NK_COLOR_SCROLLBAR_CURSOR] = nk.nk_rgba(48, 83, 111, 255)
        theme_table[nk.NK_COLOR_SCROLLBAR_CURSOR_HOVER] = nk.nk_rgba(53, 88, 116, 255)
        theme_table[nk.NK_COLOR_SCROLLBAR_CURSOR_ACTIVE] = nk.nk_rgba(58, 93, 121, 255)
        theme_table[nk.NK_COLOR_TAB_HEADER] = nk.nk_rgba(48, 83, 111, 255)
        nk.nk_style_from_table(ctx, theme_table)
    else 
        nk.nk_style_default(ctx)
    end
end

-- --------------------------------------------------------------------------------------

local function input_begin()
    nk.nk_input_begin(renderer.ctx)
    if (renderer.ctx.input.mouse.grab) then
        renderer.ctx.input.mouse.grab = 0
    elseif (renderer.ctx.input.mouse.ungrab) then
        renderer.ctx.input.mouse.ungrab = 0
    end
end

-- --------------------------------------------------------------------------------------

local function input_end()
    nk.nk_input_end(renderer.ctx)
end

-- --------------------------------------------------------------------------------------

local function get_bounds_window()
    local bnd = nk.nk_window_get_bounds(renderer.ctx)
    return bnd.x, bnd.y, bnd.w, bnd.h
end

-- --------------------------------------------------------------------------------------

local function stroke_line( x1, y1, x2, y2, width, color )
    nk.nk_stroke_line(renderer.canvas, x1, y1, x2, y2, width, nk.nk_rgba_u32(color))
end

-- --------------------------------------------------------------------------------------

local function draw_text( x, y, w, h, text, font, color, bcolor )

    w = w or font:get_width(text)
    h = h or font:get_height()
    local rect = nk.nk_rect(x, y, w, h)
    local font_handle = font.font.handle
    nk.nk_draw_text(renderer.canvas, rect, text, #text, font_handle, nk.nk_rgba_u32(color), nk.nk_rgba_u32(bcolor))
end

-- --------------------------------------------------------------------------------------

local function bgcolor_window(color)
    local style = renderer.ctx.style
    local win = style.window
    local old = win.fixed_background.data.color
    win.fixed_background.data.color = nk.nk_rgba_u32(color)
    return nk.nk_color_u32(old)
end

-- --------------------------------------------------------------------------------------

local function tooltip(text, align)
    local bounds = nk_widget_bounds(renderer.ctx)
    if (nk.nk_input_is_mouse_hovering_rect(renderer.ctx.input, bounds)) then
        nk.nk_tooltip(renderer.ctx, text, align)
    end
    return 0
end

-- --------------------------------------------------------------------------------------

local function begin_window(name, left, top, width, height, flags)  
    -- // Flags example: NK_WINDOW_BORDER|NK_WINDOW_MOVABLE|NK_WINDOW_CLOSABLE
    -- nk.nk_layout_space_begin(renderer.ctx, nk.NK_STATIC, 0, 1)
    nk.nk_layout_space_push(renderer.ctx, nk.nk_rect(left, top, width, height))
    -- return nk.nk_begin(renderer.ctx, name, nk.nk_rect(left, top, width, height), flags)
    return nk.nk_group_begin(renderer.ctx, name, flags)
end 

-- --------------------------------------------------------------------------------------

local function end_window()
    nk.nk_group_end(renderer.ctx) 
    -- nk.nk_layout_space_end(renderer.ctx)
end

-- --------------------------------------------------------------------------------------

return {
    set_style_prop       = nk_set_style_prop,
    set_style_table      = nk_set_style_table,
    get_style_prop       = nk_get_style_prop,
    set_style            = nk_set_style,

    input_begin          = input_begin,
    input_end            = input_end,

    get_bounds_window    = get_bounds_window,
    bgcolor_window       = bgcolor_window,
    tooltip              = tooltip,

    begin_window         = begin_window,
    end_window           = end_window, 

    stroke_line          = stroke_line, 
    draw_text            = draw_text,
}

-- --------------------------------------------------------------------------------------