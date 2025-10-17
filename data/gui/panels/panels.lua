-- All gui ui elements will follow a std format (under development)
---    Primary goal: A formal gui protocol like svg or html that allows for clear gui creation and control.
local nk        = sg 
local panels    = {}

panels.windows  = {}

-- Note: In Niklear panels/windows are top level and cannot be nested. 

panels.windows.panel_simple = {
    type    = "panel",
    title   = "simple",
    size    = {600, "auto"},
    pos     = {0, 0},    -- Can be pixels or strings
    color   = { background = 0x000000ff, text = 0xffffffff, border = 0x888888ff },
    window_flags =  bit.bor(0, nk.NK_WINDOW_NO_SCROLLBAR),

    layout = {
        { 
            type = "row", height = 24, layout = {
                { type = "button", text = "Project", action = "project_config", width = "auto" },
                { type = "button", text = "Paths", action = "paths_config", width = "auto" },
                { type = "button", text = "World", action = "world_view", width = "auto" },
                { type = "button", text = "Assets", action = "assets_view", width = "auto" },
            }
        },
    }
}

panels.windows.panel_icon_bar = {
    type    = "panel",
    title   = "icon_bar",
    size    = {"auto", 30},
    pos     = {600, "top"},    -- Can be pixels or strings
    color   = { background = 0x000000ff, text = 0xffffffff, border = 0x888888ff },
    window_flags =  bit.bor(0, nk.NK_WINDOW_NO_SCROLLBAR),

    layout = {
        { 
            type = "row", height = 24, layout = {
                { type = "button", text = "Scene", action = "scene_view", width = 80 },
                { type = "button", text = "Models", action = "model_view", width = 80 },
                { type = "button", text = "Scripts", action = "scripts_view",width = 80 },
            }
        },
    }
}

panels.windows.panel_master = {
    type    = "group",
    size    = {"auto", "auto"},
    pos     = {"left", "top"},    -- Can be pixels or strings

    layout = {
        panels.windows.panel_simple,
        panels.windows.panel_icon_bar,
    }
}


return panels