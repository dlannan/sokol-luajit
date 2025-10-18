------------------------------------------------------------------------------------------------------------
-- State - Run the scene
--
-- Decription: 
--    Runs most of the scene.

local sapp      	= require("sokol_app")
local smgr 			= require("engine.utils.statemanager")
local nk        	= sg
local hmm      		= require("hmm")

local ffi 			= require("ffi")

------------------------------------------------------------------------------------------------------------

-- These are child states that allow easier management of a simple controller
-- local SmenuMain   	= require("app.states.menus.sceneMenuMain")
-- local SenvHandler  	= require("app.states.world.envHandler")
-- local SAssetMenu 	= require("app.states.menus.sceneMenuAssets")

local tinsert 		= table.insert

local nkgui			= require("engine.nuklear.gui")
local pngloader 	= require("engine.nuklear.png-loader")
local themes 		= require("engine.nuklear.themes")
local colors 		= themes.colors
local utils			= require("lua.utils")

local tf 			= require("engine.utils.transforms")

local player 		= require("engine.libs.camera.player")
local orbit 		= require("engine.libs.camera.orbitGO")
local follow 		= require("engine.libs.camera.follow")

local socket    	= require("socket.core")
local copas 		= require("copas")

local panels        = require("data.gui.panels.panels")
local panelactions  = require("data.gui.actions.panels")

-- This needs to be a database of loaded element templates
local elements_lookup 	= {

	project_config 		= require("data.gui.elements.project_config"),
	assets_config 		= require("data.gui.elements.assets_config"),

}

local button_colors 	= nil 

------------------------------------------------------------------------------------------------------------

local SmainGui	= smgr:NewState()

local enums = {
	VIEW_ORBIT 		= 1,
	VIEW_FLY 		= 2,
}

------------------------------------------------------------------------------------------------------------

function SmainGui:Init(wwidth, wheight)

	-- SmenuMain:Init(wwidth, wheight)
	-- SenvHandler:Init(wwidth, wheight)
	print("Display: "..wwidth.." x "..wheight)
	panels.windows.panel_master.parent = { size = { wwidth, wheight } }

	button_colors = {
		normal = nk.nk_style_item_color(mainState.ctx[0].style.button.normal.data.color),
		hover = nk.nk_style_item_color(mainState.ctx[0].style.button.hover.data.color),
		active = nk.nk_style_item_color(mainState.ctx[0].style.button.active.data.color),
	}

end

------------------------------------------------------------------------------------------------------------

function SmainGui:Begin()
	
	-- self.Sassets = smgr:GetState("SetupAssets")

	-- SmenuMain:Begin(self.Sassets)
	-- SenvHandler:Begin(self.Sassets)

	-- gltf:load("/assets/models/demo_grass01/demo_grass01.gltf", "/temp/temp006", "temp")
	-- go.set_rotation(vmath.quat_rotation_y(3.141 * 0.5), "/temp/temp006")
	-- 
	-- updatelights(Gmain)
end

------------------------------------------------------------------------------------------------------------

function SmainGui:Screenshot()
	self.do_screenshot = true
end 

------------------------------------------------------------------------------------------------------------

function SmainGui:TakeScreenshot()

	nkgui:update()
	nkgui:render()

	screenshot.png(function(png, image, w, h)
		local ss_id = os.date('%d_%m_%y %H_%M.png')
		local fh = io.open("data/screenshots/"..ss_id, "wb")
		if(fh) then 
			fh:write(image)
			fh:close()
		end
		self.do_screenshot = nil
	end)
	return 
end

------------------------------------------------------------------------------------------------------------

local function get_parent_size( ele )

	local size = { 1920, 1440 }
	-- Calc size first since this may be used in positioning (like center etc)
	if(ele.size) then 
		local pwidth = ele.parent.size[1] or 1920
		if(ele.size[1]) then 
			if(type(ele.size[1]) == "string") then 
				if(ele.size[1] == "auto") then 
					size[1] = pwidth
				end
			else 
				size[1] = tonumber(ele.size[1]) or 100
			end
		end
		local pheight = ele.parent.size[2] or 1440
		if(ele.size[2]) then 
			if(type(ele.size[2]) == "string") then 
				if(ele.size[2] == "auto") then 
					size[2] = pheight
				end
			else 
				size[2] = tonumber(ele.size[2]) or 100
			end
		end
	end
	return size
end
------------------------------------------------------------------------------------------------------------

local function calc_row_geometry( ele )
	local esizes = {}
	local autosize = 0
	local pwidth = get_parent_size(ele)[1]
	local remainwidth = pwidth
	for i,v in ipairs(ele.layout) do
		if(v.width and type(v.width) == "number") then 
			if(v.width > 0.99) then 
				esizes[i] = v.width / pwidth
				remainwidth = remainwidth - v.width
			else 
				esizes[i] = v.width
				remainwidth = remainwidth - v.width * pwidth
			end
		else 
			esizes[i] = 0
			autosize = autosize + 1
		end
	end			
	local autosize = (remainwidth / pwidth) / autosize
	for i,v in ipairs(ele.layout) do
		if(esizes[i] == 0) then esizes[i] = autosize end
	end
	return esizes
end

------------------------------------------------------------------------------------------------------------

local function get_geometry( ele, winrect )

	local size = get_parent_size( ele )
	ele.size = size
	winrect[0].w, winrect[0].h = size[1], size[2]
	if(ele.pos) then 
		if(ele.pos[1]) then
			if(type(ele.pos[1]) == "string") then 
				if(ele.pos[1] == "center") then 
					local pwidth = ele.parent.size[1] or 1920
					winrect[0].x = pwidth * 0.5 - winrect[0].w * 0.5
				elseif(ele.pos[1] == "left") then 
					winrect[0].x = 0.0
				elseif(ele.pos[1] == "right") then 
					local pwidth = ele.parent.size[1] or 1920
					winrect[0].x = pwidth - winrect[0].w
				end

			else 
				winrect[0].x = tonumber(ele.pos[1]) or 0
			end 
		end
		if(ele.pos[2]) then
			if(type(ele.pos[2]) == "string") then 
				if(ele.pos[2] == "center") then 
					local pheight = ele.parent.size[2] or 1440
					winrect[0].y = pheight * 0.5 - winrect[0].h * 0.5
				elseif(ele.pos[2] == "top") then 
					winrect[0].y = 0.0
				elseif(ele.pos[2] == "bottom") then 
					local pheight = ele.parent.size[2] or 1440
					winrect[0].y = pheight - winrect[0].h
				end
			else 
				winrect[0].y = tonumber(ele.pos[2]) or 0
			end 
		end
	end 
end

------------------------------------------------------------------------------------------------------------

local function render_element( ctx, element )

	-- Custom is for custom provided gui rendering (ie doesnt work well with provided templates)
	if(element.type == "custom") then  

		if(element.init) then element.init(ctx, element) end
		if(element.update) then element.update(ctx, element) end
		-- if(element.finish) then element.finish(ctx, element) end

		
	elseif(element.type == "group") then  

		element.winrect = element.winrect or ffi.new("struct nk_rect[1]", {{0, 0, 400, 600}})
		get_geometry(element, element.winrect)
		if(element.layout) then 
			for i,v in ipairs(element.layout) do
				v.parent = element
				render_element(ctx, v)
			end
		end 

	elseif(element.type == "panel") then  

		element.winrect = element.winrect or ffi.new("struct nk_rect[1]", {{0, 0, 400, 600}})
		get_geometry(element, element.winrect)
		if (nk.nk_begin(ctx, element.title or "", element.winrect[0], element.window_flags or 0) == true) then
			if(element.layout) then 
				for i,v in ipairs(element.layout) do
					v.parent = element
					render_element(ctx, v)
				end
			end 
		end
		nk.nk_end(ctx)

	elseif(element.type == "notebook") then  

		element.winrect = element.winrect or ffi.new("struct nk_rect[1]", {{0, 0, 400, 600}})
		element.current_tab = element.current_tab or 1
		
		local tabs = #element.tab_titles or 0
		local row_height = element.height or 30
		local widget_width = (element.parent.size[1] / tabs) / element.parent.size[1]

		-- Remove button rounding
		local rounding_ptr = utils.get_field_ptr( ctx[0].style.button, "struct nk_style_button", "rounding", "float *")
		nk.nk_style_push_float(ctx, rounding_ptr, 0)
		nk.nk_layout_row_begin(ctx, nk.NK_DYNAMIC, row_height, tabs)

		for i = 1, tabs do
			-- /* make sure button perfectly fits text */
			nk.nk_layout_row_push(ctx, widget_width)
			if (element.current_tab == i) then
				-- /* active tab gets highlighted */
				ctx[0].style.button.normal = button_colors.active
				ctx[0].style.button.hover = button_colors.active
				if (nk.nk_button_label(ctx, element.tab_titles[i]) ) then element.current_tab = i end
			else 
				if(nk.nk_button_label(ctx, element.tab_titles[i])) then element.current_tab = i end
			end
			ctx[0].style.button.normal = button_colors.normal
			ctx[0].style.button.hover = button_colors.hover
		end
		nk.nk_layout_row_end(ctx)
		nk.nk_style_pop_float(ctx)		

		get_geometry(element, element.winrect)
		if(element.tab_panels) then 
			for i,v in ipairs(element.tab_panels) do
				if(i == element.current_tab) then  
					child_element = elements_lookup[v]
					if(child_element) then 
						child_element.parent = element
						render_element(ctx, child_element) 
					end
				end
			end
		end 

	elseif(element.type == "row") then 
		local row_height = 30
		local children = 1
		if(element.height) then row_height = tonumber(element.height) end  
		if(element.layout) then children = #element.layout end
		nk.nk_layout_row_begin(ctx, nk.NK_DYNAMIC, row_height, children)
		if(element.layout) then 
			local esizes = calc_row_geometry(element)
			for i,v in ipairs(element.layout) do 
				v.parent = element
				v.row_height = row_height
				nk.nk_layout_row_push(ctx, esizes[i])
				render_element(ctx, v)
			end
		end
		nk.nk_layout_row_end(ctx)

	elseif(element.type == "label") then 
		local alignment = nk.NK_TEXT_LEFT 
		if(element.align) then alignment = ALIGNMENT[element.align] or alignment end
		nk.nk_label(ctx, element.text or "", alignment)

	elseif(element.type == "button") then  
		local styled_button = ffi.new("struct nk_style_button[1]", { ctx[0].style.button })
		-- Override rounded corners (can do other things here too - can also make your own button style)
		styled_button[0].rounding = 0.0
		if( nk.nk_button_label_styled(ctx, styled_button, element.text or "Missing Text")) then
		-- if (nk.nk_button_label(ctx, element.text or "Missing Text")) then
			if(element.action) then 
				local action = panelactions[element.action]
				if(action) then action("button", element) end
			end
		end
	end
end

------------------------------------------------------------------------------------------------------------

function SmainGui:Update(mxi, myi, buttons)

	--nkgui:update()
	
	if(self.do_screenshot) then 
		self:TakeScreenshot()
	end

	-- SmenuMain:Update(mxi, myi, buttons)
	-- SenvHandler:Update(mxi, myi, buttons)
	render_element(mainState.ctx, panels.windows.panel_master)

	--nkgui:render()
	
	self.prevmxi = mxi
	self.prevmyi = myi
end

------------------------------------------------------------------------------------------------------------

function SmainGui:Input(action_id, action)

	-- if(action_id == hash("screenshot") and action.released) then 
	-- 	self:Screenshot()
	-- 	return true
	-- end
	
	-- SmenuMain:Input(action_id, action)
	-- SenvHandler:Input(action_id, action)
end

------------------------------------------------------------------------------------------------------------
-- On message send to the current state
function SmainGui:Message( owner, message_id, message, sender )

	local ctx = mainState.ctx
	if(message_id == "mouse_enter") then
		nk.nk_style_show_cursor(ctx)
	elseif(message_id == "mouse_leave") then
		nk.nk_style_hide_cursor(ctx)
	end

	-- SmenuMain:Message( owner, message_id, message, sender )
	-- SenvHandler:Message( owner, message_id, message, sender )
end
	
------------------------------------------------------------------------------------------------------------

function SmainGui:Finish()

	-- SmenuMain:Finish()
	-- SenvHandler:Finish()
end
	
------------------------------------------------------------------------------------------------------------

return SmainGui

------------------------------------------------------------------------------------------------------------
