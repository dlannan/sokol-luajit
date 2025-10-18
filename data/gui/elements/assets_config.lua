

local assets        = require("engine.gui.ui.panels_assets")


local element_assets     = {
    type        = "custom",
    init        = nil,
    update      = assets.panel,
    finish      = nil,
}


return element_assets
