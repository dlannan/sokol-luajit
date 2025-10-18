


local panel     = require("engine.gui.ui.panels")
local builder   = require("engine.utils.build")
local build     = require("engine.gui.ui.panels_build")

local element_project     = {}

function default_handler(ctx, build)

    builder.configure(panel.config)
    builder.run(panel.config)

    -- ticker = (ticker or 0) + 0.016
    -- if(ticker > 0.01) then 
    --     build.progress[0] = build.progress[0] + 1
    --     ticker = ticker - 0.01 
    -- end
    -- if(panel.build.progress[0] >= 999) then 
        -- ticker = nil
        build.progress[0] = 0.0 
        build.active = 0 
        build.mode = nil
    -- end 
end

function project_init(ctx, element)
    print("project init handler")
    panel.init()
    panel.setup_fonts(ctx)
    panel.build.handler = default_handler

    -- Remove init on the element (no longer needed)
    element.init = nil
end

function project_update(ctx, element)

    build.panel(ctx)
end

element_project.type        = "custom"
element_project.init        = project_init
element_project.update      = project_update
element_project.finish      = panel.cleanup

return element_project
