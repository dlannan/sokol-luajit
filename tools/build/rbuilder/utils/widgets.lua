local sapp      = require("sokol_app")
local nk        = sg
local hmm       = require("hmm")
local stb       = require("stb")

local ffi       = require("ffi")

--------------------------------------------------------------------------------

local widgets   = {
    id_name     = 1,
}

--------------------------------------------------------------------------------

widgets.widget_panel_fixed = function (ctx, title, left, top, width, height, flags, panel_function, data)

	local x 	= left
	local y 	= top

	flags = flags or 0
	flags = bit.bor(flags, nk.NK_WINDOW_NO_SCROLLBAR)

	local winrect = nk.nk_rect(tonumber(x), tonumber(y), tonumber(width), tonumber(height))

	local shown = false
	if( nk.nk_begin(ctx, title, winrect, flags) == true) then 
        if(panel_function) then panel_function(data, left, top, width, height) end
		shown = true
		nk.nk_end(ctx)
	end

	return { show=shown, x=winrect.x, y=winrect.y, w=winrect.w, h=winrect.h }
end	

--------------------------------------------------------------------------------

widgets.widget_pie_menu = function(ctx, left, top, radius, icons, item_count)

    local scale = radius / 140
    local ret = -1
    local total_space = ffi.new("struct nk_rect")
    local bounds = ffi.new("struct nk_rect")
    local active_item = 0
 
    --  /* pie menu popup */
    local border = ctx.style.window.popup_border_color
    local bgtype = ctx.style.window.fixed_background.type
    local alpha = ctx.style.window.fixed_background.data.color.a

    ctx.style.window.fixed_background.data.color.a = 0
    ctx.style.window.popup_border_color = nk.nk_rgba(0,0,0,0)
    total_space = nk.nk_window_get_content_region(ctx)

    local spacing = nk.nk_vec2(ctx.style.window.spacing.x, ctx.style.window.spacing.y)
    local padding = nk.nk_vec2(ctx.style.window.padding.x, ctx.style.window.padding.y)

    ctx.style.window.spacing = nk.nk_vec2(0,0)
    ctx.style.window.padding = nk.nk_vec2(0,0)
 
    local flags = nk.NK_WINDOW_NO_SCROLLBAR
    if (nk.nk_popup_begin(ctx, nk.NK_POPUP_STATIC, "piemenu", flags,
        nk.nk_rect(left - total_space.x - radius, top - radius - total_space.y,
        2*radius,2*radius)) == true) then 

        local i = 0
        local out = nk.nk_window_get_canvas(ctx)
        local nk_in = ctx.input
 
        total_space = nk.nk_window_get_content_region(ctx)
        ctx.style.window.spacing = nk.nk_vec2(4,4)
        ctx.style.window.padding = nk.nk_vec2(8,8)
        nk.nk_layout_row_dynamic(ctx, total_space.h, 1)
        nk.nk_widget(bounds, ctx)
 
        --  /* outer circle */
        nk.nk_fill_circle(out, bounds, nk.nk_rgb(50,50,50))
        do
            --  /* circle buttons */
            local step = (2 * 3.141592654) / (math.max(1,item_count))
            local a_min = 0; local a_max = step
 
            local center = nk.nk_vec2(bounds.x + bounds.w / 2.0, bounds.y + bounds.h / 2.0)
            local drag = nk.nk_vec2(nk_in.mouse.pos.x - center.x, nk_in.mouse.pos.y - center.y)
            local angle = math.atan2(drag.y, drag.x)
            if (angle < -0.0) then angle = angle + 2.0 * 3.141592654 end
            active_item = math.floor(angle/step)
 
            for i = 0, item_count-1 do
                
                local content = ffi.new("struct nk_rect")
                local rgb = nk.nk_rgb(60,60,60)
                if(active_item == i) then rgb = nk.nk_rgb(45,100,255) end
                nk.nk_fill_arc(out, center.x, center.y, (bounds.w/2.0), a_min, a_max, rgb)
 
                --  /* separator line */
                local rx = bounds.w/2.0
                local ry = 0
                local dx = rx * math.cos(a_min) - ry * math.sin(a_min)
                local dy = rx * math.sin(a_min) + ry * math.cos(a_min)
                nk.nk_stroke_line(out, center.x, center.y, center.x + dx, center.y + dy, 1.0, nk.nk_rgb(50,50,50))
 
                --  /* button content */
                local a = a_min + (a_max - a_min)/2.0
                local rx = bounds.w * 0.5 - bounds.w * 0.125; ry = 0
                content.w = 30 * scale; content.h = 30 * scale;
                content.x = center.x + ((rx * math.cos(a) - ry * math.sin(a)) - content.w/2.0)
                content.y = center.y + (rx * math.sin(a) + ry * math.cos(a) - content.h/2.0)
                nk.nk_draw_image(out, content, icons[i], nk.nk_rgb(255,255,255))
                a_min = a_max; a_max = a_max + step
            end
        end
        do
            --  /* inner circle */
            local inner = ffi.new("struct nk_rect")
            inner.x = bounds.x + bounds.w/2 - bounds.w/4
            inner.y = bounds.y + bounds.h/2 - bounds.h/4
            inner.w = bounds.w/2; inner.h = bounds.h/2
            nk.nk_fill_circle(out, inner, nk.nk_rgb(45,45,45))
 
            --  /* active icon content */
            bounds.w = inner.w / 2.0
            bounds.h = inner.h / 2.0
            bounds.x = inner.x + inner.w/2 - bounds.w/2
            bounds.y = inner.y + inner.h/2 - bounds.h/2
            nk.nk_draw_image(out, bounds, icons[active_item], nk.nk_rgb(255,255,255))
        end
        nk.nk_layout_space_end(ctx);
        if (nk.nk_input_is_mouse_released(ctx.input, nk.NK_BUTTON_RIGHT) == true) then
            nk.nk_popup_close(ctx)
            ret = active_item
        end
    else 
        ret = -2
    end
    nk.nk_popup_end(ctx)

    ctx.style.window.spacing = spacing
    ctx.style.window.padding = padding

    ctx.style.window.fixed_background.type = bgtype
    ctx.style.window.fixed_background.data.color.a = alpha
    ctx.style.window.popup_border_color = border
    return ret
end

--------------------------------------------------------------------------------

local piemenu_pos = nk.nk_vec2(0,0)
local piemenu_active = 0

widgets.make_pie_popup = function(ctx, icons, pie_size, pie_count)

    pie_size = pie_size or 140
    pie_count = pie_count or 6

    if ((nk.nk_input_is_mouse_click_down_in_rect(ctx.input, nk.NK_BUTTON_RIGHT, nk.nk_window_get_bounds(ctx),nk.nk_true) == true) and 
        piemenu_active == 0) then 
        piemenu_pos = nk.nk_vec2(ctx.input.mouse.pos.x, ctx.input.mouse.pos.y)
        piemenu_active = 1
    end
    local ret = -1
    if (piemenu_active == 1) then
        ret = widgets.widget_pie_menu(ctx, piemenu_pos.x, piemenu_pos.y, pie_size, icons, pie_count)
        if (ret == -2) then piemenu_active = 0 end
        if (ret ~= -1) then 
            piemenu_active = 0
        end
    end
    return ret
end 

--------------------------------------------------------------------------------

widgets.widget_notebook = function(ctx, tab_name, tabs, current_tab, height, tab_fixed_width)

    local step = (2*3.141592654) / 32
    local chart_type = {CHART_LINE=1, CHART_HISTO=2, CHART_MIXED=3}

    -- /* Header */
    nk.nk_style_push_vec2(ctx, ctx[0].style.window.spacing, nk.nk_vec2(0,0))
    local rnding = ffi.new("float[1]", {ctx[0].style.button.rounding})
    nk.nk_style_push_float(ctx, rnding, 0)
    nk.nk_layout_row_begin(ctx, nk.NK_STATIC, 20, 3)
    for i = 1, table.getn(tabs) do
        -- /* make sure button perfectly fits text */
        local f = ctx[0].style.font
        local text_width = tab_fixed_width or f.width(f.userdata, f.height, tabs[i], string.len(tabs[i]))
        local widget_width = text_width + 4 * ctx[0].style.button.padding.x
        nk.nk_layout_row_push(ctx, widget_width)
        if (current_tab == i) then
            -- /* active tab gets highlighted */
            local button_color = ctx[0].style.button.normal
            ctx[0].style.button.normal = ctx[0].style.button.active
            if (nk.nk_button_label(ctx, tabs[i]) == true ) then current_tab = i end
            ctx[0].style.button.normal = button_color
        else 
            if(nk.nk_button_label(ctx, tabs[i]) == true) then current_tab = i end
        end
    end
    nk.nk_style_pop_float(ctx)

    -- /* Body */
    nk.nk_layout_row_dynamic(ctx, height, 1)
    if (nk.nk_group_begin(ctx, tab_name, nk.NK_WINDOW_BORDER) == true) then
    
        nk.nk_style_pop_vec2(ctx)
        if(current_tab == chart_type.CHART_LINE) then
            nk.nk_layout_row_dynamic(ctx, height-20, 1)
            if (nk.nk_chart_begin_colored(ctx, nk.NK_CHART_LINES, nk.nk_rgb(255,0,0), nk.nk_rgb(150,0,0), 32, 0.0, 1.0)) then
                nk.nk_chart_add_slot_colored(ctx, nk.NK_CHART_LINES, nk.nk_rgb(0,0,255), nk.nk_rgb(0,0,150),32, -1.0, 1.0)
                local id = 0
                for i = 0, 32 -1 do
                    nk.nk_chart_push_slot(ctx, math.abs(math.sin(id)), 0)
                    nk.nk_chart_push_slot(ctx, math.cos(id), 1)
                    id = id + step
                end
            end
            nk.nk_chart_end(ctx)
        elseif(current_tab == chart_type.CHART_HISTO) then

            nk.nk_layout_row_dynamic(ctx, height-20, 1)
            if (nk.nk_chart_begin_colored(ctx, nk.NK_CHART_COLUMN, nk.nk_rgb(255,0,0), nk.nk_rgb(150,0,0), 32, 0.0, 1.0)) then
                local id = 0
                for i = 0, 32-1 do
                    nk.nk_chart_push_slot(ctx, math.abs(math.sin(id)), 0)
                    id = id + step
                end
            end
            nk.nk_chart_end(ctx)
        elseif(current_tab == chart_type.CHART_MIXED) then
            nk.nk_layout_row_dynamic(ctx, height-20, 1)
            if (nk.nk_chart_begin_colored(ctx, nk.NK_CHART_LINES, nk.nk_rgb(255,0,0), nk.nk_rgb(150,0,0), 32, 0.0, 1.0)) then
                nk.nk_chart_add_slot_colored(ctx, nk.NK_CHART_LINES, nk.nk_rgb(0,0,255), nk.nk_rgb(0,0,150),32, -1.0, 1.0)
                nk.nk_chart_add_slot_colored(ctx, nk.NK_CHART_COLUMN, nk.nk_rgb(0,255,0), nk.nk_rgb(0,150,0), 32, 0.0, 1.0)
                local id = 0
                for i = 0, 32-1 do
                    nk.nk_chart_push_slot(ctx, math.abs(math.sin(id)), 0)
                    nk.nk_chart_push_slot(ctx, math.abs(math.cos(id)), 1)
                    nk.nk_chart_push_slot(ctx, math.abs(math.sin(id)), 2)
                    id = id + step
                end
            end
            nk.nk_chart_end(ctx)
        end
        nk.nk_group_end(ctx)
    else 
        nk.nk_style_pop_vec2(ctx)
    end

    return current_tab
end

--------------------------------------------------------------------------------

widgets.widget_combo_box = function(ctx, items, selected_item, height)
    
    local buffer = ffi.string(items[selected_item])
    if (nk.nk_combo_begin_label(ctx, buffer, nk.nk_vec2(nk.nk_widget_width(ctx), height)) == true) then
        nk.nk_layout_row_dynamic(ctx, 35, 1);
        local count = table.getn(items)
        for i = 1, count do
            if (nk.nk_combo_item_label(ctx, ffi.string(items[i]), nk.NK_TEXT_LEFT) == true) then
                selected_item = i
            end
        end
        nk.nk_combo_end(ctx)
    end
    return selected_item
end 

--------------------------------------------------------------------------------
-- returns struct nk_image

widgets.icon_load = function(filename)

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

--------------------------------------------------------------------------------

return widgets

--------------------------------------------------------------------------------