-- All gui ui elements will follow a std format (under development)
---    Primary goal: A formal gui protocol like svg or html that allows for clear gui creation and control.
local nk        = sg 
local panels    = {}

panels.windows  = {}

panels.windows.popup = {
    type    = "panel",
    title   = "Main",
    size    = {600, "auto"},
    pos     = {"left", "top"},    -- Can be pixels or strings
    color   = { background = 0x000000ff, text = 0xffffffff, border = 0x888888ff },
    window_flags =  bit.bor(nk.NK_WINDOW_TITLE, nk.NK_WINDOW_MOVABLE),

    layout = {
        { 
            type = "row", height = 24, layout = {
                { type = "label", text = "Some text", width = 0.1 },
                { type = "button", text = "Build Project", action = "build_project", width = "auto" },
                { type = "button", text = "Export", action = "export_assets", width = 200 },
                { type = "button", text = "Quit", action = "quit_app", width = "auto" },
            }
        },
    }
}


return panels