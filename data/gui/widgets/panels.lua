-- All gui ui elements will follow a std format (under development)
---    Primary goal: A formal gui protocol like svg or html that allows for clear gui creation and control.

local panels = {}

panels.windows = {}

panels.windows.popup = {
    title   = "",
    size    = {500, 300},
    pos     = { "center", "center"},    -- Can be pixels or strings
    color   = { background = 0x000000ff, text = 0xffffffff, border = 0x888888ff },

    layout = {
        { 
            type = "row", height = 100, children = {
                { type = "label", text = "Some text in the row", width = "auto" },
                { type = "button", label = "Build Project", action = "build_project", width = "auto" },
                { type = "button", label = "Export", action = "export_assets", width = 200 },
                { type = "button", label = "Quit", action = "quit_app", width = "auto" },
            }
        },
    }
}


return panels