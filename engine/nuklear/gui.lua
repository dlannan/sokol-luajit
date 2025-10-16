local ffi 		= require("ffi")

local tf = require("engine.nuklear.transforms")
local themes = require("engine.nuklear.themes")

local sapp      = require("sokol_app")
local nk        = sg
local hmm       = require("hmm")
local png 		= require("engine.nuklear.png-loader")
local stb 		= require("stb")
local utils 	= require("lua.utils")

local socket    = require("socket.core")
local copas 	= require("copas")

--------------------------------------------------------------------------------

local tinsert = table.insert 
local ctx 		= nil

--------------------------------------------------------------------------------
local nuklear_gui = {

	themes = themes,
    colors = themes.colors,
	fonts = {},

	gui_data = nil,

    res  = {
        width = 960,
        height = 960, 
        channels = 4,
		resolution = 960,
    }, 
    camera = {
        url = "/camera#camera",
	},
	window = {
		width = nil,
		height = 640,
		offx = 0, 
		offy = 0,
	},

    win_ctr = 0,

    mouse = { 
        x = 0, 
        y = 0 
    },
	
    evt_queue = {},
	prev_button = 0,

	updates = {},
	inits = {},

	winrect = {},

	nk_null_rect = nk.nk_rect(-8192.0, -8192.0, 16384, 16384),

	font_atlas_img_width = ffi.new("int[1]", 2048),
	font_atlas_img_height = ffi.new("int[1]", 2048),
	font_atlas = ffi.new("struct nk_font_atlas[1]"),
}

--------------------------------------------------------------------------------
-- Helpers

local function getTopDisplayEdge(vertFOV, panel_distance, gui_resolution)
	local visible_vertical = math.tan(vertFOV /2) * panel_distance * gui_resolution * 2.0
	return ( gui_resolution - visible_vertical ) * 0.5
end

local function getCamDistToSeeSize(FOV, size)
	return (size/2) / math.tan(FOV/2)
end

local function getHorizFOV(vertFOV, aspect)
	return 2 * math.atan(math.tan(vertFOV/2) * aspect)
end

--------------------------------------------------------------------------------

nuklear_gui.flags = {
-- /// #### nk_panel_flags
-- /// Flag                            --| Description
-- /// ----------------------------------|----------------------------------------
    NK_WINDOW_BORDER = 1,              --| Draws a border around the window to visually separate window from the background
    NK_WINDOW_MOVABLE = 2,             --| The movable flag indicates that a window can be moved by user input or by dragging the window header
    NK_WINDOW_SCALABLE = 4,            --| The scalable flag indicates that a window can be scaled by user input by dragging a scaler icon at the button of the window
    NK_WINDOW_CLOSABLE = 8,            --| Adds a closable icon into the header
    NK_WINDOW_MINIMIZABLE = 16,        --| Adds a minimize icon into the header
    NK_WINDOW_NO_SCROLLBAR = 32,       --| Removes the scrollbar from the window
    NK_WINDOW_TITLE = 64,              --| Forces a header at the top at the window showing the title
    NK_WINDOW_SCROLL_AUTO_HIDE = 128,  --| Automatically hides the window scrollbar if no user interaction: also requires delta time in `nk_context` to be set each frame
    NK_WINDOW_BACKGROUND = 256,        --| Always keep window in the background
    NK_WINDOW_SCALE_LEFT = 512,        --| Puts window scaler in the left-bottom corner instead right-bottom
    NK_WINDOW_NO_INPUT = 1024,         --| Prevents window of scaling, moving or getting focus
}

nuklear_gui.keys = {
	NK_KEY_NONE			= 0,
	NK_KEY_SHIFT		= 1,
	NK_KEY_CTRL			= 2,
	NK_KEY_DEL			= 3,
	NK_KEY_ENTER		= 4,
	NK_KEY_TAB			= 5,
	NK_KEY_BACKSPACE	= 6,
	NK_KEY_COPY			= 7,
	NK_KEY_CUT			= 8,
	NK_KEY_PASTE		= 9,
	NK_KEY_UP			= 10,
	NK_KEY_DOWN			= 11,
	NK_KEY_LEFT			= 12,
	NK_KEY_RIGHT		= 13,
}

--------------------------------------------------------------------------------

nuklear_gui.world_to_screen = function (self, pos, width, height, x, y)
	local proj = go.get(self.camera.url, "projection")
	local view = go.get(self.camera.url, "view")
	local m = proj * view
	local pv = hmm.HMM_Vec4( pos.x, pos.y, pos.z, 1 )

	pv = m * pv
	pv = pv * (1/pv.w)
	pv.x = (pv.x / 2 + 0.5) * width + x
	pv.y = (pv.y / 2 + 0.5) * height + y

	return hmm.HMM_Vec3(pv.x, pv.y, 0) 
end

--------------------------------------------------------------------------------

nuklear_gui.get_screen_pos = function( self, x, y, z, rot )
	local issrot = rot or hmm.HMM_Quaternion(0,0,0,0)
	local lp = hmm.HMM_Rotate(issrot, hmm.HMM_Vec3(x, y, z))
	local p = self:world_to_screen( lp, self.window.width, self.window.height, self.window.offx, self.window.offy )

	p.x = p.x * self.window.scalex
	p.y = p.y * self.window.scaley - self.edge_top
	return hmm.HMM_Vec3(p.x, p.y, 0)
end

--------------------------------------------------------------------------------

nuklear_gui.window_resized = function(self, data)

	self.mouse = { x = 0, y = 0 }
	self.evt_queue = {}
	self.updates = {}

	self:init()
	sg.sg_apply_scissor_rect(0, 0, data.width, data.height, true)

	self:reload_fonts()
	nk.nk_style_set_font(ctx, self.fonts.first_font.fontid )
end

--------------------------------------------------------------------------------

nuklear_gui.setup_gui = function( self, gui_quad, camera_url, scale_texture )

	self.camera.url = camera_url or self.camera.url

	local newwidth = sapp.sapp_widthf() 
	local newheight = sapp.sapp_heightf()

	-- Trying to fit width of gui quad into exact position 
	self.window.width = newwidth
	self.window.height = newheight

	local res = self.window.width * scale_texture
	if( self.window.height * scale_texture > res) then 
		res = self.window.height * scale_texture
	end

	self.res.resolution = { w = self.window.width * scale_texture, h = self.window.height * scale_texture }
	local gui_resolution = self.res.resolution

	local aspect = newwidth/newheight
	local vertFOV = 45.0 -- go.get(self.camera.url, "fov")
	local horizFOV = getHorizFOV(vertFOV, aspect)
	local aspectFOV = horizFOV / vertFOV
	--if( aspect < 1.0) then aspectScale = 0.95 end

	local panel_distance = getCamDistToSeeSize(horizFOV, 1.0)
	-- go.set_position(hmm.HMM_Vec3(0,0,-panel_distance), gui_quad)
	-- go.set_scale(hmm.HMM_Vec3(1.0, 1.0/aspect, 1.0), gui_quad)

	self.edge_top = 0 --getTopDisplayEdge(vertFOV, panel_distance, gui_resolution.h)
	if(aspect < 1.0) then self.edge_top = 0 end

	self.window.scalex = 1.0 -- gui_resolution.w / newwidth
	self.window.scaley = 1.0 -- aspectYScale
	self.window.offx = 0
end

--------------------------------------------------------------------------------

nuklear_gui.shutdown = function(self)

end

--------------------------------------------------------------------------------

nuklear_gui.init = function(self, camera, texture_scale)

	texture_scale = texture_scale or 1.0
	-- Prep editor theme with index 0 theme 
	-- nk.nk_set_style(ctx, 0, 0, self.themes.colors.white )
	-- for k,v in pairs(self.themes.indexes) do
	-- 	self.themes.editor_theme[v] = nk.nk_get_style_prop(ctx,v) 
	-- end
	ctx = mainState.ctx
	nuklear_gui:setup_gui(nil, "some_camera_url", texture_scale)
end

-- --------------------------------------------------------------------------------------

local function font_loader( atlas, font_file, font_size, glyph_func)

	local datasize = 0	
	local fontdata = nil
	local data = utils.loaddata(font_file)
	if(data) then 
		datasize = string.len(data)
		fontdata = ffi.new("char[?]", datasize)
		ffi.copy(fontdata, data, datasize)		
	else 
		print("[ Error: nuklear_gui.add_fonts] Cannot load font: "..tostring(font_file))
		return nil, nil
	end

	local image 	= nil 
	local newfont 	= nil 
	if(fontdata) then 
--     local newfont = nk.nk_font_atlas_add_from_file(atlas, font_file, font_size, cfg)
		local config = nil
		if(glyph_func) then 
			config = nk.nk_font_config(font_size)
			config.range = glyph_func()
		end 
		newfont = nk.nk_font_atlas_add_from_memory(atlas, fontdata, datasize, font_size, config)
    	image = nk.nk_font_atlas_bake(atlas, nuklear_gui.font_atlas_img_width, nuklear_gui.font_atlas_img_height, nk.NK_FONT_ATLAS_RGBA32)
	end
    return image, newfont
end

-- --------------------------------------------------------------------------------------

local function font_atlas_img( image, debug )
    local sg_img_desc = ffi.new("sg_image_desc[1]")
    sg_img_desc[0].width = nuklear_gui.font_atlas_img_width[0]
    sg_img_desc[0].height = nuklear_gui.font_atlas_img_height[0]
    sg_img_desc[0].pixel_format = sg.SG_PIXELFORMAT_RGBA8
    sg_img_desc[0].sample_count = 1
    
    sg_img_desc[0].data.subimage[0][0].ptr = image
    sg_img_desc[0].data.subimage[0][0].size = nuklear_gui.font_atlas_img_width[0] * nuklear_gui.font_atlas_img_height[0] * 4
    local new_img = sg.sg_make_image(sg_img_desc)

    -- // create a sokol-nuklear image object which associates an sg_image with an sg_sampler
    local img_desc = ffi.new("snk_image_desc_t[1]")
    img_desc[0].image = new_img

    local snk_img = nk.snk_make_image(img_desc)
    local nk_hnd = nk.snk_nkhandle(snk_img)

	if(debug) then 
		stb.stbi_write_png( "assets/fonts/atlas_font.png", nuklear_gui.font_atlas_img_width[0], nuklear_gui.font_atlas_img_height[0], 4, image, nuklear_gui.font_atlas_img_width[0] * 4)
	end

    return nk_hnd
end

--------------------------------------------------------------------------------

nuklear_gui.add_fonts = function( self, fonts )
	self.first_font = nil

	nk.nk_font_atlas_init_default(nuklear_gui.font_atlas)
	nk.nk_font_atlas_begin(nuklear_gui.font_atlas)

	local image = nil 
	local newfont = nil
	for k,font in pairs(fonts) do
	
		-- local newfont = nk.nk_font_atlas_add_from_file(atlas, font.path, font.size, nil)
		--local newfont = nk.nk_font_atlas_add_from_memory(atlas, fontdata, datasize, font.size, nil)
		image, newfont = font_loader( nuklear_gui.font_atlas, font.path, font.size, font.glyph_func)
		font.fontid = newfont.handle
		font.nk_font = newfont
		self.fonts[k] = font	

		--print(font.fontid.texture.ptr)
		if(self.first_font == nil) then self.first_font = font.fontid end

	end

    local nk_img = font_atlas_img(image)
    nk.nk_font_atlas_end(nuklear_gui.font_atlas, nk_img, nil)
    nk.nk_font_atlas_cleanup(nuklear_gui.font_atlas)

	-- nk.nk_init_default(ctx, fonts.text1.fontid)
	nk.nk_style_load_all_cursors(ctx, nuklear_gui.font_atlas[0].cursors)
end 

--------------------------------------------------------------------------------

nuklear_gui.reload_fonts = function( self )
	-- nk.nk_begin_fonts(ctx)
	-- for k,font in pairs(self.fonts) do
	-- 	local fontdata, error = sys.load_resource(font.path)
	-- 	font.fontid = nk.nk_add_font(ctx, fontdata, #fontdata, font.size, font.resolution )
	-- end
	-- nk.nk_end_fonts(ctx)
end 

--------------------------------------------------------------------------------
nuklear_gui.widget_panel = function (self, title, left, top, width, height, panel_function, data)

	local ctx = mainState.ctx
	local y =  self.edge_top + top
	local x = left

    local flags = bit.bor(self.flags.NK_WINDOW_TITLE, self.flags.NK_WINDOW_BORDER)
	flags = bit.bor(flags, self.flags.NK_WINDOW_MOVABLE)
	flags = bit.bor(flags, self.flags.NK_WINDOW_MINIMIZABLE)
    -- flags = bit.bor(flags, self.flags.NK_WINDOW_CLOSABLE)
    flags = bit.bor(flags, self.flags.NK_WINDOW_SCALABLE)

	nuklear_gui.winrect[title] = nuklear_gui.winrect[title] or ffi.new("struct nk_rect[1]", {{x, y, width, height}})
	local winrect = nuklear_gui.winrect[title]
	local winshow = nk.nk_begin(ctx, title , winrect, flags)
	if( winshow == true) then 
	    if(panel_function) then panel_function(data, left, top, width, height) end
		nk.nk_end(ctx)
	end
	
	return { show=winshow, x=winrect[0].x, y=winrect[0].h - self.edge_top, w=winrect[0].w, h=winrect[0].h }
end	

--------------------------------------------------------------------------------

nuklear_gui.widget_panel_fixed = function (self, title, left, top, width, height, flags, panel_function, data)

	local ctx 	= mainState.ctx
	local x 	= left
	local y 	= self.edge_top + top

	flags = flags or 0
	-- flags = bit.bor(flags, self.flags.NK_WINDOW_BORDER)
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

nuklear_gui.widget_button = function (self, text, left, top, width, height)

	local ctx = mainState.ctx
	local y = self.edge_top + top
	local x = left

	nuklear_gui.winrect[text] = nuklear_gui.winrect[text] or ffi.new("struct nk_rect[1]", {{x, y, width+10, height+8}})
	local winrect = nuklear_gui.winrect[text]
	local winshow = nk.nk_begin(ctx, text , winrect, nk.NK_WINDOW_NO_SCROLLBAR)

	nk.nk_layout_space_begin(ctx, 50, 2)
	nk.nk_layout_space_push(ctx, 0, 0, width, height)
	local res = nk.nk_button_label(ctx, text, 1)
	nk.nk_layout_space_end(ctx)

	nk.nk_end(ctx)
	return res
end	

--------------------------------------------------------------------------------

nuklear_gui.widget_text = function (self, left, top, text, value, lvl1, lvl2)

	local ctx = mainState.ctx
	local y = self.edge_top + top
	local x = left

	lvl1 = lvl1 or 1.0
	lvl2 = lvl2 or 1.0

	local title = "win_"..self.winctr
	nuklear_gui.winrect[title] = nuklear_gui.winrect[title] or ffi.new("struct nk_rect[1]", {{x, y,400,60}})
	local winrect = nuklear_gui.winrect[title]
	local winshow = nk.nk_begin(ctx, title , winrect, nk.NK_WINDOW_NO_SCROLLBAR)
	
	nk.nk_stroke_rect(ctx, x + 4, y, 190, 34, 0, 2, self.colors.bg1)
	nk.nk_fill_rect(ctx, x + 4, y, 190, 3, 0, self.colors.bg1)

	nk.nk_fill_rect(ctx, x + 7, y + 5 + (28 * (1.0-lvl1)), 5, 28 * lvl1, 0, self.colors.bg2)
	nk.nk_fill_rect(ctx, x + 14, y + 5 + (28 * (1.0-lvl2)), 5, 28 * lvl2, 0, self.colors.bg1)

	nk.nk_fill_rect(ctx, x + 21, y + 5, 173, 28, 0, self.colors.fg1)

	-- nk.nk_layout_row_static(ctx,10, 400, 1)
	nk.nk_layout_space_begin(ctx, 50, 2)
	nk.nk_layout_space_push(ctx, 22, 0, 300, 20)
	nk.nk_label(ctx, text, 1)
		
	-- nk.nk_layout_row_static(ctx,10, 400, 1)
	nk.nk_layout_space_push(ctx, 55, 12, 300, 20)
	nk.nk_label(ctx, value, 1)
	nk.nk_layout_space_end(ctx)

	nk.nk_end(ctx)
	self.winctr = self.winctr + 1
end	

--------------------------------------------------------------------------------
nuklear_gui.faicon_tooltip_button = function( self, ctx, obj, align) 

    local hovered = nk.nk_widget_is_hovered(ctx)
    if(hovered == true) then obj.hoverctr = (obj.hoverctr or 0) + 1 else obj.hoverctr = 0 end 		
    if(obj.hoverctr > 100) then 
        nk.nk_style_set_font(ctx, self.fonts.text1.fontid )
        nk.nk_tooltip(ctx, obj.name)
        nk.nk_style_set_font(ctx, self.fonts.fa.fontid )
    end 

    local res = nk.nk_button_label(ctx, obj.faicon)
    return res
end


--------------------------------------------------------------------------------

nuklear_gui.widget_chart = function (self, left, top, text, lvl1, lvl2, charttbl)

	local ctx = mainState.ctx
	local y = self.edge_top + top
	local x = left

	lvl1 = lvl1 or 1.0
	lvl2 = lvl2 or 1.0

	local title = "win_"..self.winctr
	nuklear_gui.winrect[title] = nuklear_gui.winrect[title] or ffi.new("struct nk_rect[1]", {{x, y,400,60}})
	local winrect = nuklear_gui.winrect[title]
	local winshow = nk.nk_begin(ctx, title , winrect, nk.NK_WINDOW_NO_SCROLLBAR)
	
	nk.nk_stroke_rect(ctx, x + 4, y, 190, 34, 0, 2, self.colors.bg1)
	nk.nk_fill_rect(ctx, x + 4, y, 190, 3, 0, self.colors.bg1)

	nk.nk_fill_rect(ctx, x + 7, y + 5 + (28 * (1.0-lvl1)), 5, 28 * lvl1, 0, self.colors.bg2)
	nk.nk_fill_rect(ctx, x + 14, y + 5 + (28 * (1.0-lvl2)), 5, 28 * lvl2, 0, self.colors.bg1)

	nk.nk_fill_rect(ctx, x + 21, y + 5, 173, 28, 0, self.colors.fg1)

	-- nk.nk_layout_row_static(ctx,10, 400, 1)
	nk.nk_layout_space_begin(ctx, 50, 2)
	nk.nk_layout_space_push(ctx, 22, 0, 300, 20)
	nk.nk_label(ctx, text, 1)
		
	-- nk.nk_layout_row_static(ctx,10, 400, 1)
	nk.nk_layout_space_push(ctx, 18, 12, 170, 18)
	nk.nk_line_chart(ctx, 0x1, charttbl);
	nk.nk_layout_space_end(ctx)

	nk.nk_end(ctx)
	self.winctr = self.winctr + 1
end	

--------------------------------------------------------------------------------

nuklear_gui.widget_text_movable = function(self, left, top, spacer, text, value, lvl1, lvl2)

	local ctx = mainState.ctx
	local y = self.edge_top + top
	local x = left

	lvl1 = lvl1 or 1.0
	lvl2 = lvl2 or 1.0
	
	local title = "win_"..self.winctr
	nuklear_gui.winrect[title] = nuklear_gui.winrect[title] or ffi.new("struct nk_rect[1]", {{x, y,400 + spacer,60}})
	local winrect = nuklear_gui.winrect[title]
	local winshow = nk.nk_begin(ctx, title , winrect, nk.NK_WINDOW_NO_SCROLLBAR)	
	
	nk.nk_stroke_rect(ctx, x + 100 + spacer, y, 190, 34, 0, 2, self.colors.bg1)
	nk.nk_fill_rect(ctx, x + 100 + spacer, y, 190, 3, 0, self.colors.bg1)
	
	nk.nk_fill_rect(ctx, x + 102 + spacer, y + 5 + (28 * (1.0-lvl1)), 5, 28 * lvl1, 0, self.colors.bg1)
	nk.nk_fill_rect(ctx, x + 109 + spacer, y + 5 + (28 * (1.0-lvl2)), 5, 28 * lvl2, 0, self.colors.bg1)

	nk.nk_fill_rect(ctx, x + 116 + spacer, y + 5, 173, 28, 0, self.colors.fg1)

	nk.nk_stroke_line(ctx,  x + 20, y + 15 + 20, x + 100, y + 2, 1, self.colors.bg2 )
	nk.nk_stroke_line(ctx,  x + 100, y + 2, x + 100 + spacer, y + 2, 1, self.colors.bg2 )
	nk.nk_stroke_circle(ctx,  x + 10, y + 5 + 20, 20, 20, 1, self.colors.bg1 )
	nk.nk_stroke_circle(ctx,  x + 9, y + 4 + 20, 22, 22, 1, self.colors.bg1 )
	nk.nk_stroke_circle(ctx,  x + 17, y + 12 + 20, 6, 6, 1, self.colors.bg1 )

	nk.nk_layout_space_begin(ctx, 50, 2)
	nk.nk_layout_space_push(ctx, 100 + 22 + spacer, 0, 300, 20)
	nk.nk_label(ctx, text, 1)

	nk.nk_layout_space_push(ctx, 100 + 55 + spacer, 12, 300, 20)
	nk.nk_label(ctx, value, 1)

	nk.nk_layout_space_end(ctx)
	nk.nk_end(ctx)
	self.winctr = self.winctr + 1
end	


--------------------------------------------------------------------------------

nuklear_gui.widget_chart_movable = function(self, left, top, spacer, text, lvl1, lvl2, charttbl)

	local ctx = mainState.ctx
	local y = self.edge_top + top
	local x = left

	lvl1 = lvl1 or 1.0
	lvl2 = lvl2 or 1.0
	
	local title = "win_"..self.winctr
	nuklear_gui.winrect[title] = nuklear_gui.winrect[title] or ffi.new("struct nk_rect[1]", {{x, y,400 + spacer,60}})
	local winrect = nuklear_gui.winrect[title]
	local winshow = nk.nk_begin(ctx, title , winrect, nk.NK_WINDOW_NO_SCROLLBAR)		
	
	nk.nk_stroke_rect(ctx, x + 100 + spacer, y, 190, 34, 0, 2, self.colors.bg1)
	nk.nk_fill_rect(ctx, x + 100 + spacer, y, 190, 3, 0, self.colors.bg1)
	
	nk.nk_fill_rect(ctx, x + 102 + spacer, y + 5 + (28 * (1.0-lvl1)), 5, 28 * lvl1, 0, self.colors.bg1)
	nk.nk_fill_rect(ctx, x + 109 + spacer, y + 5 + (28 * (1.0-lvl2)), 5, 28 * lvl2, 0, self.colors.bg1)

	nk.nk_fill_rect(ctx, x + 116 + spacer, y + 5, 173, 28, 0, self.colors.fg1)

	nk.nk_stroke_line(ctx,  x + 20, y + 15 + 20, x + 100, y + 2, 1, self.colors.bg2 )
	nk.nk_stroke_line(ctx,  x + 100, y + 2, x + 100 + spacer, y + 2, 1, self.colors.bg2 )
	nk.nk_stroke_circle(ctx,  x + 10, y + 5 + 20, 20, 20, 1, self.colors.bg1 )
	nk.nk_stroke_circle(ctx,  x + 9, y + 4 + 20, 22, 22, 1, self.colors.bg1 )
	nk.nk_stroke_circle(ctx,  x + 17, y + 12 + 20, 6, 6, 1, self.colors.bg1 )

	nk.nk_layout_space_begin(ctx, 50, 2)
	nk.nk_layout_space_push(ctx, 100 + 22 + spacer, 0, 300, 20)
	nk.nk_label(ctx, text, 1)

	--nk.nk_layout_space_push(100 + 55 + spacer, 12, 300, 20)
	nk.nk_layout_space_push(ctx, 112 + spacer, 12, 170, 18)
	nk.nk_line_chart(ctx,  0x1, charttbl);
	nk.nk_layout_space_end(ctx)

	nk.nk_end(ctx)
	self.winctr = self.winctr + 1
end	


--------------------------------------------------------------------------------

nuklear_gui.render = function(self)
	-- if(self.init_done == false) then return end
    -- nk.nk_render(0,0,0,0 , self.buffer_info.buffer)
	-- resource.set_texture(self.resource_path, self.header, self.buffer_info.buffer)
	self.winctr = 0
end

--------------------------------------------------------------------------------
-- Notes: This handler relies on the input bindings from the example.
--        It is easy enough to modify this behavior if needed.

nuklear_gui.handle_input = function(self, caller, action_id, action)

    local evt_insert = false
    local evt_type = "button"
    local evt_button = 0

	local mousex = action.x + self.window.offx
	local mousey = self.window.height - action.y + self.edge_top

    -- Leftclick handler
	if action_id == hash("touch") or action_id == hash("button_left") then
        evt_insert = true 
        evt_type = "button"
        evt_button = 0
	end

    if action_id == hash("button_middle") then
        evt_insert = true 
        evt_type = "button"
        evt_button = 1
	end

	if action_id == hash("button_right") then
        evt_insert = true 
        evt_type = "button"
        evt_button = 2
	end

    if action_id == hash("wheel_up") then
        evt_type = "wheel"
        evt_dir = 1
    end
    
    if action_id == hash("wheel_down") then
        evt_type = "wheel"
        evt_dir = -1
	end    

    if(evt_type == "wheel") then 
        if(action.value == 1) then 
            tinsert(self.evt_queue, { 
                evt = "wheel", 
                button = 1, 
                x = mousex, 
                y = mousey, 
                value = action.value * evt_dir,
            } )
        end
	end

	if( action_id == hash("backspace") or action_id == hash("delete") )  then 

		local id = nuklear_gui.keys.NK_KEY_BACKSPACE
		if(action_id == hash("delete")) then 
			id = nuklear_gui.keys.NK_KEY_DEL
		end 
		local pressed = 1
		if(action.pressed == false) then 
			pressed = 0
		end

		tinsert(self.evt_queue, { 
			evt = "key", 
			button = 1, 
			x = mousex, 
			y = mousey, 
			value = id,
			down = pressed,
		} )
	end

	local cursor = nil
	if( action_id == hash("cursor_left") )  then 
		cursor = nuklear_gui.keys.NK_KEY_LEFT
	end
	if( action_id == hash("cursor_right") )  then 
		cursor = nuklear_gui.keys.NK_KEY_RIGHT
	end
	if( action_id == hash("cursor_up") )  then 
		cursor = nuklear_gui.keys.NK_KEY_UP
	end
	if( action_id == hash("cursor_down") )  then 
		cursor = nuklear_gui.keys.NK_KEY_DOWN
	end
	if(cursor) then 

		local pressed = 1
		if(action.pressed == false) then 
			pressed = 0
		end

		tinsert(self.evt_queue, { 
			evt = "key", 
			button = 1, 
			x = mousex, 
			y = mousey, 
			value = cursor,
			down = pressed,
		} )
	end

	if( action_id == hash("text") )  then 
		tinsert(self.evt_queue, { 
			evt = "text", 
			button = 1, 
			x = mousex, 
			y = mousey, 
			value = action.text,
		} )
	end
    
    if(evt_insert == true) then 
        if action.pressed == true then 
            tinsert(self.evt_queue, { 
                evt = evt_type, 
                button = evt_button, 
                x = mousex, 
                y = mousey, 
                down = 1,
            } )	
        end
		if action.released == true then 
            tinsert(self.evt_queue, { 
                evt = evt_type, 
                button = evt_button, 
                x = mousex, 
                y = mousey, 
                down = 0,
            } )	
        end
    end
	
    -- Mouse movement update events
	local xdiff = mousex - self.mouse.x 
	local ydiff = mousey - self.mouse.y 
	if( xdiff ~= 0 or ydiff ~= 0 ) then 
		tinsert(self.evt_queue, { evt = "motion", x = mousex, y = mousey } )
	end

    -- store for previous movememt
	self.mouse.x = mousex
	self.mouse.y = mousey
	return true
end

--------------------------------------------------------------------------------

nuklear_gui.update = function(self)

	local ctx = mainState.ctx
	if(self.init_done == false) then return end
	local events = #self.evt_queue
	nk.nk_input_begin(ctx)
	for k,v in pairs(self.evt_queue) do 
		local mx = v.x * self.window.scalex
		local my = v.y * self.window.scaley

		if(v.evt == "button") then 
			nk.nk_input_button(ctx, v.button, mx, my, v.down )
        elseif (v.evt == "motion") then 
			if(v.evt.down == 1) then nk.nk_input_button(ctx, 0, mx, my, 1 ) end
			nk.nk_input_motion(ctx, mx, my )
        elseif (v.evt == "wheel") then 
			nk.nk_input_scroll(ctx, 0, v.value )
		elseif (v.evt == "text") then 
			nk.nk_input_char(ctx, string.byte(v.value ) )
		elseif (v.evt == "key") then 
			nk.nk_input_key(ctx, v.value, v.down )
		end
	end
	nk.nk_input_end(ctx)
	self.evt_queue = {}
end

--------------------------------------------------------------------------------

nuklear_gui.timer = function(timerlen, delay, complete, params)
	local tmr = copas.timer.new({
		delay 			= timerlen,      
		initial_delay 	= delay,
		params 			= params,
		callback 		= function(timer_obj, params)
			complete(params)
			timer_obj:cancel()			 
		end
	})
	return tmr
end 

--------------------------------------------------------------------------------

return nuklear_gui

--------------------------------------------------------------------------------