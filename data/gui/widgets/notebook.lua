
local nk            = sg 
local widgets       = {}


widgets.notebook    = {}

widgets.notebook.side_panel = {

    type = "notebook",
    height  = 24, 

    tab_titles = { "Project", "Paths", "World", "Assets" },
    tab_panels = { "project_config", "paths_config", "world_config", "assets_config" },

    layout = {
        { 
        },
    }
}

return widgets.notebook