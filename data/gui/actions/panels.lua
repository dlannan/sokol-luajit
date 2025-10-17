-- Add your panel actions here.
local sapp      	= require("sokol_app")
local nk        	= sg

local panel_actions = {}

panel_actions["quit_app"] = function(event, element)

    sapp.sapp_quit()
end
  

return panel_actions