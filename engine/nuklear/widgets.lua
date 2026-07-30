

local sapp      	= require("sokol_app")
sg              	= require("sokol_gfx")
sg              	= require("sokol_nuklear")
local nk        	= sg
local slib      	= require("sokol_libs") -- Warn - always after gfx!!

local hmm       	= require("hmm")
local hutils    	= require("hmm_utils")

-- local style   		= require "core.style"
if renderer == nil then require("engine.renderer") end

local ffi 			= require("ffi")

-- nuklear based widgets
--
--  Widgets use c based objects to store the results for input and other states
--    They are stored in lists here
local widgets = {
	ctx 	= renderer.ctx, 
	canvas 	= renderer.canvas,
	id 		= 1, 		-- Auto increment as widgets are created
	values 	= {}, 		-- ffi allocated values for widgets
	lens 	= {}, 		-- Sepcifically for buffer lengths
}

-- -------------------------------------------------------------------------------------------

function widgets:set_font( font )
	nk.nk_style_set_font(self.ctx, font.font.handle)
end

-- -------------------------------------------------------------------------------------------

function widgets:begin( h, items )
	items = items or -1
	nk.nk_layout_space_begin(self.ctx, nk.NK_STATIC, h, items )
end

-- -------------------------------------------------------------------------------------------

function widgets:finish( )
	nk.nk_layout_space_end(self.ctx)
end

-- -------------------------------------------------------------------------------------------

function widgets:line( x, y, w, h )
	nk.nk_layout_space_push(self.ctx, nk.nk_rect(x, y, w, h))
end

-- -------------------------------------------------------------------------------------------

function widgets:row( h, cols )
	nk.nk_layout_row_dynamic(self.ctx, h, cols)
end

-- -------------------------------------------------------------------------------------------

function widgets:label( label, align)
	nk.nk_label(self.ctx, label, align)
end

-- -------------------------------------------------------------------------------------------

function widgets:button_fa( icon_utf8 )
	local rounding = self.ctx.style.button.rounding
	self.ctx.style.button.rounding = 0
	nk.nk_style_push_font(self.ctx, style.fa_font_small.font.handle )
	local res = nil
	if(nk.nk_button_label(self.ctx, icon_utf8 )) then res = true end
	nk.nk_style_pop_font(self.ctx)
	self.ctx.style.button.rounding = rounding
	return res
end

-- -------------------------------------------------------------------------------------------
-- Can be user provided ( this removed any nasty characters )
local nk_plugin_filter = function(nk_text_edit, unicode)
	if(unicode > 255) then return false end 
	if(unicode <= 13) then return false end 
	return true
end

-- -------------------------------------------------------------------------------------------

function widgets:text_input( text_value, max_len )
	local text_len = self.lens[text_value] or ffi.new("int[1]", #ffi.string(text_value))
	max_len = max_len or 1024
	local res = nk.nk_edit_string(self.ctx, nk.NK_EDIT_SIMPLE, text_value, text_len, max_len, nk.nk_filter_default)
	if(bit.band(res, nk.NK_EDIT_ACTIVE) > 0 or bit.band(res, nk.NK_EDIT_ACTIVATED) > 0) then 
		system.nuklear_edit = true
	elseif(bit.band(res, nk.NK_EDIT_DEACTIVATED) > 0) then
		system.nuklear_edit = nil
	elseif(bit.band(res, nk.NK_EDIT_COMMITED) > 0) then 
		system.nuklear_edit = nil
	end
	self.lens[text_value] = text_len
end

-- -------------------------------------------------------------------------------------------

function widgets:menu( name, items, w, h)

	nk.nk_layout_row_push(ctx, 45)
	if (nk.nk_menu_begin_label(ctx, name, nk.NK_TEXT_LEFT, nk.nk_vec2(w, h))) then 
	
		prog = ffi.new("size_t[1]", { 40 } )
		slider = ffi.new("int[1]", { 10 } )
		check =  ffi.new("bool[1]", {nk.nk_true})
		nk.nk_layout_row_dynamic(self.ctx, 25, 1)
		if (nk.nk_menu_item_label(self.ctx, "Hide", nk.NK_TEXT_LEFT)) then 
			show_menu[0] = nk.nk_false
		end
		if (nk.nk_menu_item_label(ctx, "About", nk.NK_TEXT_LEFT)) then 
			show_app_about = nk.nk_true
		end
		nk.nk_progress(self.ctx, prog, 100, nk.NK_MODIFIABLE)
		nk.nk_slider_int(self.ctx, 0, slider, 16, 1)
		nk.nk_checkbox_label(self.ctx, "check", check)
		nk.nk_menu_end(self.ctx)
	end
end

-- -------------------------------------------------------------------------------------------

function widgets:progress( val, max_val )

	nk.nk_progress(self.ctx, prog, 100, nk.NK_MODIFIABLE)

end

-- -------------------------------------------------------------------------------------------

function widgets:slider( min_val, val, max_val, step, type )

	local res = false
	if(type == nil or type == "int") then 
		res = nk.nk_slider_int(self.ctx, min_val, val, max_val, step)
	elseif(type == "float") then 
		res = nk.nk_slider_float(self.ctx, min_val, val, max_val, step)
	end
	return res
end

-- -------------------------------------------------------------------------------------------


function widgets:color_picker( color_val )
	nk.nk_color_pick(self.ctx, color_val, nk.NK_RGBA)
end 

-- -------------------------------------------------------------------------------------------

return widgets 

-- -------------------------------------------------------------------------------------------
