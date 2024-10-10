package.cpath   = package.cpath..";../bin/win64/?.dll"
package.path    = package.path..";../ffi/sokol/?.lua"
package.path    = package.path..";../?.lua"

--_G.SOKOL_DLL    = "sokol_debug_dll"
local sapp      = require("sokol_app")
sg              = require("sokol_nuklear")
local nk        = sg
local slib      = require("sokol_libs") -- Warn - always after gfx!!

local hmm       = require("hmm")
local hutils    = require("hmm_utils")

local ffi = require("ffi")

-- --------------------------------------------------------------------------------------

local function init(void)
    -- // setup sokol-gfx, sokol-time and sokol-imgui
    local sg_desc = ffi.new("sg_desc[1]")
    sg_desc[0].environment = slib.sglue_environment()
    sg_desc[0].logger.func = slib.slog_func
    sg.sg_setup( sg_desc )

    -- // use sokol-nuklear with all default-options (we're not doing
    -- // multi-sampled rendering or using non-default pixel formats)
    local snk = ffi.new("snk_desc_t[1]")
    snk[0].dpi_scale = sapp.sapp_dpi_scale()
    snk[0].logger.func = slib.slog_func
    nk.snk_setup(snk)
end

-- --------------------------------------------------------------------------------------

local function cleanup()

    sg.sg_shutdown()
end

-- --------------------------------------------------------------------------------------

local function input(event) 
    nk.snk_handle_event(event)
end

-- --------------------------------------------------------------------------------------

local show_menu = ffi.new("int[1]", { nk.nk_true })
local titlebar = ffi.new("int[1]", {nk.nk_true})
local border  = ffi.new("int[1]", {nk.nk_true})
local resize  = ffi.new("int[1]", {nk.nk_true})
local movable  = ffi.new("int[1]", {nk.nk_true})
local no_scrollbar  = ffi.new("int[1]", {nk.nk_false})
local scale_left  = ffi.new("int[1]", {nk.nk_false})

local function draw_demo_ui(ctx)

    -- /* window flags */

    window_flags = 0
    minimizable = nk.nk_true

    -- /* popups */
    header_align = nk.NK_HEADER_RIGHT
    show_app_about = nk.nk_false

    -- /* window flags */
    window_flags = 0
    ctx[0].style.window.header.align = header_align
    if (border) then window_flags = bit.bor(window_flags, nk.NK_WINDOW_BORDER) end
    if (resize) then window_flags = bit.bor(window_flags, nk.NK_WINDOW_SCALABLE) end
    if (movable) then window_flags = bit.bor(window_flags, nk.NK_WINDOW_MOVABLE) end
    if (no_scrollbar) then window_flags = bit.bor(window_flags, nk.NK_WINDOW_NO_SCROLLBAR) end
    if (scale_left) then window_flags = bit.bor(window_flags, nk.NK_WINDOW_SCALE_LEFT) end
    if (minimizable) then window_flags = bit.bor(window_flags, nk.NK_WINDOW_MINIMIZABLE) end

    winrect = ffi.new("struct nk_rect[1]", {{10, 25, 400, 600}})
    if (nk.nk_begin(ctx, "Overview", winrect[0], window_flags)) then

        if (show_menu) then

            -- /* menubar */
            menu_states = { MENU_DEFAULT = 0, MENU_WINDOWS = 1}
            mprog = ffi.new("size_t[1]", {60})
            mslider = ffi.new("int[1]", { 10 })
            mcheck = ffi.new("bool[1]", {nk.nk_true})
            nk.nk_menubar_begin(ctx)

            -- /* menu #1 */
            nk.nk_layout_row_begin(ctx, nk.NK_STATIC, 25, 5)
            nk.nk_layout_row_push(ctx, 45)
            if (nk.nk_menu_begin_label(ctx, "MENU", nk.NK_TEXT_LEFT, nk.nk_vec2(120, 200))) then 
            
                prog = ffi.new("size_t[1]", { 40 } )
                slider = ffi.new("int[1]", { 10 } )
                check =  ffi.new("bool[1]", {nk.nk_true})
                nk.nk_layout_row_dynamic(ctx, 25, 1)
                if (nk.nk_menu_item_label(ctx, "Hide", nk.NK_TEXT_LEFT)) then 
                    show_menu = nk.nk_false
                end
                if (nk.nk_menu_item_label(ctx, "About", nk.NK_TEXT_LEFT)) then 
                    show_app_about = nk.nk_true
                end
                nk.nk_progress(ctx, prog, 100, nk.NK_MODIFIABLE)
                nk.nk_slider_int(ctx, 0, slider, 16, 1)
                nk.nk_checkbox_label(ctx, "check", check)
                nk.nk_menu_end(ctx)
            end
            -- /* menu #2 */
            nk.nk_layout_row_push(ctx, 60)
            if (nk.nk_menu_begin_label(ctx, "ADVANCED", nk.NK_TEXT_LEFT, nk.nk_vec2(200, 600))) then 

                menu_states = { MENU_NONE = 0,MENU_FILE = 1, MENU_EDIT  = 2,MENU_VIEW = 3,MENU_CHART = 4}
                menu_state = menu_states.MENU_NONE
                state = ffi.new("nk_collapse_states[1]")
 
                state[0] = nk.NK_MINIMIZED
                if(menu_state == menu_states.MENU_FILE) then state[0] = nk.NK_MAXIMIZED end
                if (nk_tree_state_push(ctx, nk.NK_TREE_TAB, "FILE", state)) then
                    menu_state = menu_states.MENU_FILE
                    nk.nk_menu_item_label(ctx, "New", nk.NK_TEXT_LEFT)
                    nk.nk_menu_item_label(ctx, "Open", nk.NK_TEXT_LEFT)
                    nk.nk_menu_item_label(ctx, "Save", nk.NK_TEXT_LEFT)
                    nk.nk_menu_item_label(ctx, "Close", nk.NK_TEXT_LEFT)
                    nk.nk_menu_item_label(ctx, "Exit", nk.NK_TEXT_LEFT)
                    nk.nk_tree_pop(ctx)
                else 
                    if(menu_state == menu_states.MENU_FILE) then 
                        menu_state = menu_states.MENU_NONE
                    end
                end

                state[0] = nk.NK_MINIMIZED
                if(menu_state == menu_states.MENU_EDIT) then state[0] = nk.NK_MAXIMIZED end

                if (nk_tree_state_push(ctx, nk.NK_TREE_TAB, "EDIT", state)) then
                    menu_state = menu_states.MENU_EDIT
                    nk.nk_menu_item_label(ctx, "Copy", nk.NK_TEXT_LEFT)
                    nk.nk_menu_item_label(ctx, "Delete", nk.NK_TEXT_LEFT)
                    nk.nk_menu_item_label(ctx, "Cut", nk.NK_TEXT_LEFT)
                    nk.nk_menu_item_label(ctx, "Paste", nk.NK_TEXT_LEFT)
                    nk.nk_tree_pop(ctx)
                else 
                    if(menu_state == menu_states.MENU_EDIT) then 
                        menu_state = menu_states.MENU_NONE
                    end
                end

                state[0] = nk.NK_MINIMIZED
                if(menu_state == menu_states.MENU_VIEW) then state[0] = nk.NK_MAXIMIZED end
                if (nk_tree_state_push(ctx, nk.NK_TREE_TAB, "VIEW", state)) then
                    menu_state = menu_states.MENU_VIEW
                    nk.nk_menu_item_label(ctx, "About", nk.NK_TEXT_LEFT)
                    nk.nk_menu_item_label(ctx, "Options", nk.NK_TEXT_LEFT)
                    nk.nk_menu_item_label(ctx, "Customize", nk.NK_TEXT_LEFT)
                    nk.nk_tree_pop(ctx)
                else 
                    if(menu_state == menu_states.MENU_VIEW) then 
                        menu_state = menu_states.MENU_NONE
                    end
                end

                state[0] = nk.NK_MINIMIZED
                if(menu_state == menu_states.MENU_CHART) then state[0] = nk.NK_MAXIMIZED end
                if (nk_tree_state_push(ctx, nk.NK_TREE_TAB, "CHART", state)) then
                    local i = 0
                    local values= ffi.new("float[12]", {26.0,13.0,30.0,15.0,25.0,10.0,20.0,40.0,12.0,8.0,22.0,28.0} )
                    menu_state = menu_states.MENU_CHART
                    nk.nk_layout_row_dynamic(ctx, 150, 1)
                    nk.nk_chart_begin(ctx, nk.NK_CHART_COLUMN, nk.NK_LEN(values), 0, 50)
                    for i = 0, nk.NK_LEN(values)-1 do
                        nk.nk_chart_push(ctx, values[i])
                    end
                    nk.nk_chart_end(ctx)
                    nk.nk_tree_pop(ctx)
                else 
                    if(menu_state == menu_states.MENU_CHART) then 
                        menu_state = menu_states.MENU_NONE
                    end
                end
                nk.nk_menu_end(ctx)
            end
            -- /* menu widgets */
            nk.nk_layout_row_push(ctx, 70)
            nk.nk_progress(ctx, mprog, 100, nk.NK_MODIFIABLE)
            nk.nk_slider_int(ctx, 0, mslider, 16, 1)
            nk.nk_checkbox_label(ctx, "check", mcheck)
            nk.nk_menubar_end(ctx)
        end

        if (show_app_about == nk.nk_true) then

            -- /* about popup */
            local s = ffi.new("struct nk_rect[1]", { {20, 100, 300, 190} })
            if (nk.nk_popup_begin(ctx, nk.NK_POPUP_STATIC, "About", nk.NK_WINDOW_CLOSABLE, s[0])) then

                nk.nk_layout_row_dynamic(ctx, 20, 1)
                nk.nk_label(ctx, "Nuklear", nk.NK_TEXT_LEFT)
                nk.nk_label(ctx, "By Micha Mettke", nk.NK_TEXT_LEFT)
                nk.nk_label(ctx, "nuklear is licensed under the public domain License.",  nk.NK_TEXT_LEFT)
                nk.nk_popup_end(ctx)
            else 
                show_app_about = nk.nk_false
            end
        end

        -- /* window flags */
        if (nk.nk_tree_push(ctx, nk.NK_TREE_TAB, "Window", nk.NK_MINIMIZED)) then
            nk.nk_layout_row_dynamic(ctx, 30, 2)
            nk.nk_checkbox_label(ctx, "Titlebar", titlebar)
            nk.nk_checkbox_label(ctx, "Menu", show_menu)
            nk.nk_checkbox_label(ctx, "Border", border)
            nk.nk_checkbox_label(ctx, "Resizable", resize)
            nk.nk_checkbox_label(ctx, "Movable", movable)
            nk.nk_checkbox_label(ctx, "No Scrollbar", no_scrollbar)
            nk.nk_checkbox_label(ctx, "Minimizable", minimizable)
            nk.nk_checkbox_label(ctx, "Scale Left", scale_left)
            nk.nk_tree_pop(ctx)
        end

        if (nk.nk_tree_push(ctx, nk.NK_TREE_TAB, "Widgets", nk.NK_MINIMIZED)) then 
            options = {A=0,B=1,C=2}
            checkbox = ffi.new("int[1]")
            option = ffi.new("int[1]")
            if (nk.nk_tree_push(ctx, nk.NK_TREE_NODE, "Text", nk.NK_MINIMIZED)) then

                -- /* Text Widgets */
                nk.nk_layout_row_dynamic(ctx, 20, 1)
                nk.nk_label(ctx, "Label aligned left", nk.NK_TEXT_LEFT)
                nk.nk_label(ctx, "Label aligned centered", nk.NK_TEXT_CENTERED)
                nk.nk_label(ctx, "Label aligned right", nk.NK_TEXT_RIGHT)
                nk.nk_label_colored(ctx, "Blue text", nk.NK_TEXT_LEFT, nk.nk_rgb(0,0,255))
                nk.nk_label_colored(ctx, "Yellow text", nk.NK_TEXT_LEFT, nk.nk_rgb(255,255,0))
                nk.nk_text(ctx, "Text without /0", 15, nk.NK_TEXT_RIGHT)

                nk.nk_layout_row_static(ctx, 100, 200, 1)
                nk.nk_label_wrap(ctx, "This is a very long line to hopefully get this text to be wrapped into multiple lines to show line wrapping")
                nk.nk_layout_row_dynamic(ctx, 100, 1)
                nk.nk_label_wrap(ctx, "This is another long text to show dynamic window changes on multiline text")
                nk.nk_tree_pop(ctx)
            end

            if (nk.nk_tree_push(ctx, nk.NK_TREE_NODE, "Button", nk.NK_MINIMIZED)) then 
            
                -- /* Buttons Widgets */
                nk.nk_layout_row_static(ctx, 30, 100, 3)
                if (nk_button_label(ctx, "Button")) then 
                    print(stdout, "Button pressed!\n")
                end
                nk.nk_button_set_behavior(ctx, nk.NK_BUTTON_REPEATER)
                if (nk_button_label(ctx, "Repeater")) then 
                    print(stdout, "Repeater is being pressed!\n")
                end
                nk.nk_button_set_behavior(ctx, nk.NK_BUTTON_DEFAULT)
                nk.nk_button_color(ctx, nk.nk_rgb(0,0,255))

                nk.nk_layout_row_static(ctx, 25, 25, 8)
                nk.nk_button_symbol(ctx, nk.NK_SYMBOL_CIRCLE_SOLID)
                nk.nk_button_symbol(ctx, nk.NK_SYMBOL_CIRCLE_OUTLINE)
                nk.nk_button_symbol(ctx, nk.NK_SYMBOL_RECT_SOLID)
                nk.nk_button_symbol(ctx, nk.NK_SYMBOL_RECT_OUTLINE)
                nk.nk_button_symbol(ctx, nk.NK_SYMBOL_TRIANGLE_UP)
                nk.nk_button_symbol(ctx, nk.NK_SYMBOL_TRIANGLE_DOWN)
                nk.nk_button_symbol(ctx, nk.NK_SYMBOL_TRIANGLE_LEFT)
                nk.nk_button_symbol(ctx, nk.NK_SYMBOL_TRIANGLE_RIGHT)

                nk.nk_layout_row_static(ctx, 30, 100, 2)
                nk.nk_button_symbol_label(ctx, nk.NK_SYMBOL_TRIANGLE_LEFT, "prev", nk.NK_TEXT_RIGHT)
                nk.nk_button_symbol_label(ctx, nk.NK_SYMBOL_TRIANGLE_RIGHT, "next", nk.NK_TEXT_LEFT)
                nk.nk_tree_pop(ctx)
            end

            if (nk.nk_tree_push(ctx, nk.NK_TREE_NODE, "Basic", nk.NK_MINIMIZED)) then 
            
                -- /* Basic widgets */
                int_slider =  ffi.new("int[1]", {5})
                float_slider =  ffi.new("float[1]", {2.5})
                prog_value =  ffi.new("size_t[1]", {40})
                property_float =  ffi.new("float[1]", {2.0})
                property_int =  ffi.new("int[1]", {10})
                property_neg =  ffi.new("int[1]", {10})

                range_float_min =  ffi.new("float[1]", {0})
                range_float_max =  ffi.new("float[1]", {100})
                range_float_value =  ffi.new("float[1]",{50})
                range_int_min =  ffi.new("int[1]",{0})
                range_int_value =  ffi.new("int[1]",{2048})
                range_int_max =  ffi.new("int[1]",{4096})
                ratio =  ffi.new("float[2]", {120, 150})

                nk.nk_layout_row_static(ctx, 30, 100, 1)
                nk.nk_checkbox_label(ctx, "Checkbox", checkbox)

                nk.nk_layout_row_static(ctx, 30, 80, 3)
                if nk.nk_option_label(ctx, "optionA", option == A) then option = options.A end
                if nk.nk_option_label(ctx, "optionB", option == B) then option = options.B end
                if nk.nk_option_label(ctx, "optionC", option == C) then option = options.C end

                nk.nk_layout_row(ctx, nk.NK_STATIC, 30, 2, ratio)
                nk.nk_labelf(ctx, nk.NK_TEXT_LEFT, "Slider int")
                nk.nk_slider_int(ctx, 0, int_slider, 10, 1)

                nk.nk_label(ctx, "Slider float", nk.NK_TEXT_LEFT)
                nk.nk_slider_float(ctx, 0, float_slider, 5.0, 0.5)
                nk.nk_labelf(ctx, nk.NK_TEXT_LEFT, "Progressbar: %zu" , prog_value)
                nk.nk_progress(ctx, prog_value, 100, nk.NK_MODIFIABLE)

                nk.nk_layout_row(ctx, nk.NK_STATIC, 25, 2, ratio)
                nk.nk_label(ctx, "Property float:", nk.NK_TEXT_LEFT)
                nk.nk_property_float(ctx, "Float:", 0, property_float, 64.0, 0.1, 0.2)
                nk.nk_label(ctx, "Property int:", nk.NK_TEXT_LEFT)
                nk.nk_property_int(ctx, "Int:", 0, property_int, 100, 1, 1)
                nk.nk_label(ctx, "Property neg:", nk.NK_TEXT_LEFT)
                nk.nk_property_int(ctx, "Neg:", -10, property_neg, 10, 1, 1)

                nk.nk_layout_row_dynamic(ctx, 25, 1)
                nk.nk_label(ctx, "Range:", nk.NK_TEXT_LEFT)
                nk.nk_layout_row_dynamic(ctx, 25, 3)
                nk.nk_property_float(ctx, "#min:", 0, range_float_min, range_float_max, 1.0, 0.2)
                nk.nk_property_float(ctx, "#float:", range_float_min, range_float_value, range_float_max, 1.0, 0.2)
                nk.nk_property_float(ctx, "#max:", range_float_min, range_float_max, 100, 1.0, 0.2)

                nk.nk_property_int(ctx, "#min:", INT_MIN, range_int_min, range_int_max, 1, 10)
                nk.nk_property_int(ctx, "#neg:", range_int_min, range_int_value, range_int_max, 1, 10)
                nk.nk_property_int(ctx, "#max:", range_int_min, range_int_max, INT_MAX, 1, 10)

                nk.nk_tree_pop(ctx)
            end

            if (nk.nk_tree_push(ctx, nk.NK_TREE_NODE, "Inactive", nk.NK_MINIMIZED)) then
            
                inactive = 1
                nk.nk_layout_row_dynamic(ctx, 30, 1)
                nk.nk_checkbox_label(ctx, "Inactive", inactive)

                nk.nk_layout_row_static(ctx, 30, 80, 1)
                if (inactive) then
                    button = ffi.new("nk_style_button[1]")
                    button[0] = ctx[0].style.button
                    ctx[0].style.button.normal = nk.nk_style_item_color(nk_rgb(40,40,40))
                    ctx[0].style.button.hover = nk.nk_style_item_color(nk_rgb(40,40,40))
                    ctx[0].style.button.active = nk.nk_style_item_color(nk_rgb(40,40,40))
                    ctx[0].style.button.border_color = nk.nk_rgb(60,60,60)
                    ctx[0].style.button.text_background = nk.nk_rgb(60,60,60)
                    ctx[0].style.button.text_normal = nk.nk_rgb(60,60,60)
                    ctx[0].style.button.text_hover = nk.nk_rgb(60,60,60)
                    ctx[0].style.button.text_active = nk.nk_rgb(60,60,60)
                    nk.nk_button_label(ctx, "button")
                    ctx[0].style.button = button
                else 
                    if (nk.nk_button_label(ctx, "button")) then
                        print(stdout, "button pressed\n")
                    end
                end
                nk.nk_tree_pop(ctx)
            end


            if (nk.nk_tree_push(ctx, nk.NK_TREE_NODE, "Selectable", nk.NK_MINIMIZED)) then 
            
                if (nk.nk_tree_push(ctx, nk.NK_TREE_NODE, "List", nk.NK_MINIMIZED)) then 
                
                    selected[4] = {nk_false, nk.nk_false, nk.nk_true, nk.nk_false}
                    nk.nk_layout_row_static(ctx, 18, 100, 1)
                    nk.nk_selectable_label(ctx, "Selectable", nk.NK_TEXT_LEFT, selected[0])
                    nk.nk_selectable_label(ctx, "Selectable", nk.NK_TEXT_LEFT, selected[1])
                    nk.nk_label(ctx, "Not Selectable", nk.NK_TEXT_LEFT)
                    nk.nk_selectable_label(ctx, "Selectable", nk.NK_TEXT_LEFT, selected[2])
                    nk.nk_selectable_label(ctx, "Selectable", nk.NK_TEXT_LEFT, selected[3])
                    nk.nk_tree_pop(ctx)
                end
                if (nk.nk_tree_push(ctx, nk.NK_TREE_NODE, "Grid", nk.NK_MINIMIZED)) then
                
                    selected[16] = {1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1}
                    nk.nk_layout_row_static(ctx, 50, 50, 4)
                    for i = 0, 16-1 do
                        if (nk_selectable_label(ctx, "Z", nk.NK_TEXT_CENTERED, selected[i])) then
                            local x = (i % 4)
                            local y = i / 4
                            if (x > 0) then selected[i - 1] = bit.bxor(selected[i - 1], 1) end
                            if (x < 3) then selected[i + 1] = bit.bxor(selected[i + 1], 1) end
                            if (y > 0) then selected[i - 4] = bit.bxor(selected[i - 4], 1) end
                            if (y < 3) then selected[i + 4] = bit.bxor(selected[i + 4], 1) end
                        end
                    end
                    nk.nk_tree_pop(ctx)
                end
                nk.nk_tree_pop(ctx)
            end

            if (nk.nk_tree_push(ctx, nk.NK_TREE_NODE, "Combo", nk.NK_MINIMIZED)) then
            
                -- /* Combobox Widgets
                --  * In this library comboboxes are not limited to being a popup
                --  * list of selectable text. Instead it is a abstract concept of
                --  * having something that is *selected* or displayed, a popup window
                --  * which opens if something needs to be modified and the content
                --  * of the popup which causes the *selected* or displayed value to
                --  * change or if wanted close the combobox.
                --  *
                --  * While strange at first handling comboboxes in a abstract way
                --  * solves the problem of overloaded window content. For example
                --  * changing a color value requires 4 value modifier (slider, property,...)
                --  * for RGBA then you need a label and ways to display the current color.
                --  * If you want to go fancy you even add rgb and hsv ratio boxes.
                --  * While fine for one color if you have a lot of them it because
                --  * tedious to look at and quite wasteful in space. You could add
                --  * a popup which modifies the color but this does not solve the
                --  * fact that it still requires a lot of cluttered space to do.
                --  *
                --  * In these kind of instance abstract comboboxes are quite handy. All
                --  * value modifiers are hidden inside the combobox popup and only
                --  * the color is shown if not open. This combines the clarity of the
                --  * popup with the ease of use of just using the space for modifiers.
                --  *
                --  * Other instances are for example time and especially date picker,
                --  * which only show the currently activated time/data and hide the
                --  * selection logic inside the combobox popup.
                --  */
                chart_selection = ffi.new("float[1]", {8.0})
                current_weapon = ffi.new("int[1]", {0})
                check_values = ffi.new("int[5]", {0})
                position = ffi.new("float[3]", {0})
                combo_color = ffi.new("struct nk_color[1]", {{130, 50, 50, 255}})
                combo_color2 = ffi.new("struct nk_colorf[1]", {{0.509, 0.705, 0.2, 1.0}})
                prog_a = ffi.new("size_t[1]",{20})
                prog_b = ffi.new("size_t[1]",{40})
                prog_c = ffi.new("size_t[1]",{10})
                prog_d = ffi.new("size_t[1]",{90})
                weapons = ffi.new("char *[5]", {"Fist","Pistol","Shotgun","Plasma","BFG"})

                local buffer = ffi.new("char[64]")
                local sum = 0

                -- /* default combobox */
                nk.nk_layout_row_static(ctx, 25, 200, 1)
                current_weapon = nk.nk_combo(ctx, weapons, nk.NK_LEN(weapons), current_weapon, 25, nk.nk_vec2(200,200))

                -- /* slider color combobox */
                if (nk.nk_combo_begin_color(ctx, combo_color, nk.nk_vec2(200,200))) then
                    ratios = ffi.new("float[2]", {0.15, 0.85})
                    nk.nk_layout_row(ctx, nk.NK_DYNAMIC, 30, 2, ratios)
                    nk.nk_label(ctx, "R:", nk.NK_TEXT_LEFT)
                    combo_color.r = (nk_byte)nk_slide_int(ctx, 0, combo_color.r, 255, 5)
                    nk.nk_label(ctx, "G:", nk.NK_TEXT_LEFT)
                    combo_color.g = (nk_byte)nk_slide_int(ctx, 0, combo_color.g, 255, 5)
                    nk.nk_label(ctx, "B:", nk.NK_TEXT_LEFT)
                    combo_color.b = (nk_byte)nk_slide_int(ctx, 0, combo_color.b, 255, 5)
                    nk.nk_label(ctx, "A:", nk.NK_TEXT_LEFT)
                    combo_color.a = (nk_byte)nk_slide_int(ctx, 0, combo_color.a , 255, 5)
                    nk.nk_combo_end(ctx)
                end
                -- /* complex color combobox */
                if (nk.nk_combo_begin_color(ctx, nk.nk_rgb_cf(combo_color2), nk.nk_vec2(200,400)))  then
                    color_mode = {COL_RGB = 0, COL_HSV = 1}
                    col_mode = color_mode.COL_RGB

                    nk.nk_layout_row_dynamic(ctx, 120, 1)
                    combo_color2 = nk.nk_color_picker(ctx, combo_color2, nk.NK_RGBA)

                    nk.nk_layout_row_dynamic(ctx, 25, 2)
                    if(nk.nk_option_label(ctx, "RGB", col_mode == COL_RGB)) then col_mode = nk.COL_RGB end
                    if(nk.nk_option_label(ctx, "HSV", col_mode == COL_HSV)) then col_mode = nk.COL_HSV end

                    nk.nk_layout_row_dynamic(ctx, 25, 1)
                    if (col_mode == COL_RGB) then
                        combo_color2.r = nk.nk_propertyf(ctx, "#R:", 0, combo_color2.r, 1.0, 0.01,0.005)
                        combo_color2.g = nk.nk_propertyf(ctx, "#G:", 0, combo_color2.g, 1.0, 0.01,0.005)
                        combo_color2.b = nk.nk_propertyf(ctx, "#B:", 0, combo_color2.b, 1.0, 0.01,0.005)
                        combo_color2.a = nk.nk_propertyf(ctx, "#A:", 0, combo_color2.a, 1.0, 0.01,0.005)
                    else 
                        local hsva = ffi.new("float[4]")
                        nk.nk_colorf_hsva_fv(hsva, combo_color2)
                        hsva[0] = nk.nk_propertyf(ctx, "#H:", 0, hsva[0], 1.0, 0.01,0.05)
                        hsva[1] = nk.nk_propertyf(ctx, "#S:", 0, hsva[1], 1.0, 0.01,0.05)
                        hsva[2] = nk.nk_propertyf(ctx, "#V:", 0, hsva[2], 1.0, 0.01,0.05)
                        hsva[3] = nk.nk_propertyf(ctx, "#A:", 0, hsva[3], 1.0, 0.01,0.05)
                        combo_color2 = nk.nk_hsva_colorfv(hsva)
                    end
                    nk.nk_combo_end(ctx)
                end
                -- /* progressbar combobox */
                sum = prog_a[0] + prog_b[0] + prog_c[0] + prog_d[0]
                local buffer = ffi.string(sum)
                if (nk.nk_combo_begin_label(ctx, buffer, nk.nk_vec2(200,200))) then
                    nk.nk_layout_row_dynamic(ctx, 30, 1)
                    nk.nk_progress(ctx, prog_a, 100, nk.NK_MODIFIABLE)
                    nk.nk_progress(ctx, prog_b, 100, nk.NK_MODIFIABLE)
                    nk.nk_progress(ctx, prog_c, 100, nk.NK_MODIFIABLE)
                    nk.nk_progress(ctx, prog_d, 100, nk.NK_MODIFIABLE)
                    nk.nk_combo_end(ctx)
                end

                -- /* checkbox combobox */
                local sum = (check_values[0] + check_values[1] + check_values[2] + check_values[3] + check_values[4])
                buffer = ffi.string(sum)
                if (nk.nk_combo_begin_label(ctx, buffer, nk.nk_vec2(200,200))) then
                    nk.nk_layout_row_dynamic(ctx, 30, 1)
                    nk.nk_checkbox_label(ctx, weapons[0], check_values[0])
                    nk.nk_checkbox_label(ctx, weapons[1], check_values[1])
                    nk.nk_checkbox_label(ctx, weapons[2], check_values[2])
                    nk.nk_checkbox_label(ctx, weapons[3], check_values[3])
                    nk.nk_combo_end(ctx)
                end

                -- /* complex text combobox */
                buffer = ffi.string(position[0]..","..position[1]..","..position[2])
                if (nk.nk_combo_begin_label(ctx, buffer, nk.nk_vec2(200,200))) then
                    nk.nk_layout_row_dynamic(ctx, 25, 1)
                    nk.nk_property_float(ctx, "#X:", -1024.0, position[0], 1024.0, 1,0.5)
                    nk.nk_property_float(ctx, "#Y:", -1024.0, position[1], 1024.0, 1,0.5)
                    nk.nk_property_float(ctx, "#Z:", -1024.0, position[2], 1024.0, 1,0.5)
                    nk.nk_combo_end(ctx)
                end

                -- /* chart combobox */
                buffer = ffi.string(chart_selection)
                if (nk.nk_combo_begin_label(ctx, buffer, nk.nk_vec2(200,250))) then
                    local values = ffi.new(" float[13]", {26.0,13.0,30.0,15.0,25.0,10.0,20.0,40.0, 12.0, 8.0, 22.0, 28.0, 5.0})
                    nk.nk_layout_row_dynamic(ctx, 150, 1)
                    nk.nk_chart_begin(ctx, nk.NK_CHART_COLUMN, nk.NK_LEN(values), 0, 50)
                    for i = 0, nk.NK_LEN(values)-1 do
                        local res = nk.nk_chart_push(ctx, values[i])
                        if bit.band(res, nk.NK_CHART_CLICKED) then
                            chart_selection = values[i]
                            nk.nk_combo_close(ctx)
                        end
                    end
                    nk.nk_chart_end(ctx)
                    nk.nk_combo_end(ctx)
                end

                do
                    time_selected = 0
                    date_selected = 0

                    sel_time = os.date ("*t")
                    if (not time_selected or not date_selected) then
                        -- /* keep time and date updated if nothing is selected */
                        local cur_time = os.time()
                        if (not time_selected) then 
                            -- memcpy(&sel_time, n, sizeof(struct tm))
                        end
                        if (not date_selected) then
                            -- memcpy(&sel_date, n, sizeof(struct tm))
                        end
                    end

                    -- /* time combobox */
                    buffer = sel_time.hour..":"..sel_time.min..":"..sel_time.sec
                    if (nk.nk_combo_begin_label(ctx, buffer, nk.nk_vec2(200,250))) then
                        time_selected = 1
                        nk.nk_layout_row_dynamic(ctx, 25, 1)
                        sel_time.tm_sec = nk.nk_propertyi(ctx, "#S:", 0, sel_time.sec, 60, 1, 1)
                        sel_time.tm_min = nk.nk_propertyi(ctx, "#M:", 0, sel_time.min, 60, 1, 1)
                        sel_time.tm_hour = nk.nk_propertyi(ctx, "#H:", 0, sel_time.hour, 23, 1, 1)
                        nk.nk_combo_end(ctx)
                    end

                    -- /* date combobox */
                    buffer = ffi.string(sel_date.tm_mday.."%-"..(sel_date.tm_mon+1).."%-"..(sel_date.tm_year+1900))
                    if (nk_combo_begin_label(ctx, buffer, nk.nk_vec2(350,400))) then
                    
                        local month = ffi.new("char *[12]", {"January", "February", "March",
                            "April", "May", "June", "July", "August", "September",
                            "October", "November", "December"})
                        local week_days = ffi.new("char *[7]", {"SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"})
                        local month_days = ffi.new("int[12]",{31,28,31,30,31,30,31,31,30,31,30,31})
                        local year = sel_date.tm_year+1900
                        local leap_year = (not(year % 4) and ((year % 100))) or not(year % 400)
                        local days = month_days[sel_date.mon]
                        if(sel_date.mon == 1) then days = month_days[sel_date.mon] + leap_year end
                            

                        -- /* header with month and year */
                        date_selected = 1
                        nk.nk_layout_row_begin(ctx, nk.NK_DYNAMIC, 20, 3)
                        nk.nk_layout_row_push(ctx, 0.05)
                        if (nk.nk_button_symbol(ctx, nk.NK_SYMBOL_TRIANGLE_LEFT)) then
                            if (sel_date.tm_mon == 0) then
                                sel_date.tm_mon = 11
                                sel_date.tm_year = nk.NK_MAX(0, sel_date.tm_year-1)
                            else 
                                sel_date.tm_mon = sel_date.tm_mon - 1
                            end
                        end
                        nk.nk_layout_row_push(ctx, 0.9)
                        buffer = ffi.string(month[sel_date.tm_mon].." "..year)
                        nk.nk_label(ctx, buffer, nk.NK_TEXT_CENTERED)
                        nk.nk_layout_row_push(ctx, 0.05)
                        if (nk.nk_button_symbol(ctx, nk.NK_SYMBOL_TRIANGLE_RIGHT)) then
                            if (sel_date.mon == 11) then
                                sel_date.mon = 0
                                sel_date.year = sel_date.year + 1
                            else 
                                sel_date.mon = sel_date.mon + 1
                            end
                        end
                        nk.nk_layout_row_end(ctx)

                        -- /* good old week day formula (double because precision) */
                        do
                            local year_n = year
                            if(sel_date.mon < 2) then year_n = year-1 end
                            local y = year_n % 100
                            local c = year_n / 100
                            local y4 = (int)(y / 4)
                            local c4 = (int)(c / 4)
                            local m = (int)(2.6 * (double)(((sel_date.tm_mon + 10) % 12) + 1) - 0.2)
                            local week_day = (((1 + m + y + y4 + c4 - 2 * c) % 7) + 7) % 7

                            -- /* weekdays  */
                            nk.nk_layout_row_dynamic(ctx, 35, 7)
                            for i = 0, nk.NK_LEN(week_days)-1 do
                                nk.nk_label(ctx, week_days[i], nk.NK_TEXT_CENTERED)
                            end

                            -- /* days  */
                            if (week_day > 0) then 
                                nk.nk_spacing(ctx, week_day)
                            end

                            for i = 1, days do
                                buffer = ffi.string(i)
                                if (nk_button_label(ctx, buffer)) then
                                    sel_date.tm_mday = i
                                    nk.nk_combo_close(ctx)
                                end
                            end
                        end
                        nk.nk_combo_end(ctx)
                    end
                end

                nk.nk_tree_pop(ctx)
            end

            if (nk.nk_tree_push(ctx, nk.NK_TREE_NODE, "Input", nk.NK_MINIMIZED)) then
            
                ratio = ffi.new("float[2]", {120, 150})
                field_buffer = ffi.new("char[64]")
                text = ffi.new("char[9][64]")
                text_len = ffi.new("int[9]")
                box_buffer = ffi.new("char[512]")
                field_len = ffi.new("int[1]")
                box_len = ffi.new("int[1]")
                active = ffi.new("nk_flags[1]")

                nk.nk_layout_row(ctx, nk.NK_STATIC, 25, 2, ratio)
                nk.nk_label(ctx, "Default:", nk.NK_TEXT_LEFT)

                nk.nk_edit_string(ctx, nk.NK_EDIT_SIMPLE, text[0], text_len[0], 64, nk.nk_filter_default)
                nk.nk_label(ctx, "Int:", nk.NK_TEXT_LEFT)
                nk.nk_edit_string(ctx, nk.NK_EDIT_SIMPLE, text[1], text_len[1], 64, nk.nk_filter_decimal)
                nk.nk_label(ctx, "Float:", nk.NK_TEXT_LEFT)
                nk.nk_edit_string(ctx, nk.NK_EDIT_SIMPLE, text[2], text_len[2], 64, nk.nk_filter_float)
                nk.nk_label(ctx, "Hex:", nk.NK_TEXT_LEFT)
                nk.nk_edit_string(ctx, nk.NK_EDIT_SIMPLE, text[4], text_len[4], 64, nk.nk_filter_hex)
                nk.nk_label(ctx, "Octal:", nk.NK_TEXT_LEFT)
                nk.nk_edit_string(ctx, nk.NK_EDIT_SIMPLE, text[5], text_len[5], 64, nk.nk_filter_oct)
                nk.nk_label(ctx, "Binary:", nk.NK_TEXT_LEFT)
                nk.nk_edit_string(ctx, nk.NK_EDIT_SIMPLE, text[6], text_len[6], 64, nk.nk_filter_binary)

                nk.nk_label(ctx, "Password:", nk.NK_TEXT_LEFT)
                do
                    local i = 0
                    old_len = text_len[8]
                    buffer = ffi.new("char[64]")
                    for i = 0, text_len[8]-1 do buffer[i] = '*' end
                    nk.nk_edit_string(ctx, nk.NK_EDIT_FIELD, buffer, text_len[8], 64, nk.nk_filter_default)
                    if (old_len < text_len[8]) then
                        -- memcpy(&text[8][old_len], &buffer[old_len], (nk_size)(text_len[8] - old_len))
                    end
                end

                nk.nk_label(ctx, "Field:", nk.NK_TEXT_LEFT)
                nk.nk_edit_string(ctx, nk.NK_EDIT_FIELD, field_buffer, field_len, 64, nk.nk_filter_default)

                nk.nk_label(ctx, "Box:", nk.NK_TEXT_LEFT)
                nk.nk_layout_row_static(ctx, 180, 278, 1)
                nk.nk_edit_string(ctx, nk.NK_EDIT_BOX, box_buffer, box_len, 512, nk.nk_filter_default)

                nk.nk_layout_row(ctx, nk.NK_STATIC, 25, 2, ratio)
                active = nk.nk_edit_string(ctx, bit.bor(nk.NK_EDIT_FIELD,nk.NK_EDIT_SIG_ENTER), text[7], text_len[7], 64,  nk.nk_filter_ascii)
                if (nk.nk_button_label(ctx, "Submit") or bit.band(active, nk.NK_EDIT_COMMITED)) then
                
                    text[7][text_len[7]] = '\n'
                    text_len[7] = text_len[7] + 1
                    -- // memcpy(box_buffer[box_len], text[7], text_len[7])
                    box_len = box_len + text_len[7]
                    text_len[7] = 0
                end
                nk.nk_tree_pop(ctx)
            end
            nk.nk_tree_pop(ctx)
        end

        if (nk.nk_tree_push(ctx, nk.NK_TREE_TAB, "Chart", nk.NK_MINIMIZED)) then
        
            -- /* Chart Widgets
            --  * This library has two different rather simple charts. The line and the
            --  * column chart. Both provide a simple way of visualizing values and
            --  * have a retained mode and immediate mode API version. For the retain
            --  * mode version `nk_plot` and `nk_plot_function` you either provide
            --  * an array or a callback to call to handle drawing the graph.
            --  * For the immediate mode version you start by calling `nk_chart_begin`
            --  * and need to provide min and max values for scaling on the Y-axis.
            --  * and then call `nk_chart_push` to push values into the chart.
            --  * Finally `nk_chart_end` needs to be called to end the process. */
            local id = 0
            local col_index = -1
            local line_index = -1
            local step = (2*3.141592654) / 32

            local index = -1

            -- /* line chart */
            local id = 0
            index = -1
            nk.nk_layout_row_dynamic(ctx, 100, 1)
            if (nk.nk_chart_begin(ctx, nk.NK_CHART_LINES, 32, -1.0, 1.0)) then
                for i = 0, 32 do
                    local res = nk.nk_chart_push(ctx, math.cos(id))
                    if bit.band(res, nk.NK_CHART_HOVERING) then
                        index = i
                    end
                    if bit.band(res, nk.NK_CHART_CLICKED) then
                        line_index = i
                    end
                    id = id + step
                end
                nk.nk_chart_end(ctx)
            end

            if (index ~= -1) then
                nk.nk_tooltipf(ctx, "Value: %.2f", (math.cos(index*step)) )
            end
            if (line_index ~= -1) then
                nk.nk_layout_row_dynamic(ctx, 20, 1)
                nk.nk_labelf(ctx, nk.NK_TEXT_LEFT, "Selected value: %.2f", math.cos(index*step))
            end

            -- /* column chart */
            nk.nk_layout_row_dynamic(ctx, 100, 1)
            if (nk.nk_chart_begin(ctx, nk.NK_CHART_COLUMN, 32, 0.0, 1.0)) then
                for i = 0,32-1 do
                    local res = nk.nk_chart_push(ctx, math.abs(math.sin(id)))
                    if bit.band(res, nk.NK_CHART_HOVERING) then
                        index = i
                    end
                    if bit.band(res, nk.NK_CHART_CLICKED) then
                        col_index = i
                    end
                    id = id + step
                end
                nk.nk_chart_end(ctx)
            end
            if (index ~= -1) then
                nk.nk_tooltipf(ctx, "Value: %.2f", math.abs(math.sin(step * index)))
            end
            if (col_index ~= -1) then
                nk.nk_layout_row_dynamic(ctx, 20, 1)
                nk.nk_labelf(ctx, nk.NK_TEXT_LEFT, "Selected value: %.2f", math.abs(math.sin(step * col_index)))
            end

            -- /* mixed chart */
            nk.nk_layout_row_dynamic(ctx, 100, 1)
            if (nk.nk_chart_begin(ctx, nk.NK_CHART_COLUMN, 32, 0.0, 1.0)) then
                nk.nk_chart_add_slot(ctx, nk.NK_CHART_LINES, 32, -1.0, 1.0)
                nk.nk_chart_add_slot(ctx, nk.NK_CHART_LINES, 32, -1.0, 1.0)
                local id = 0
                for i = 0, 32 - 1 do
                    nk.nk_chart_push_slot(ctx, math.abs(math.sin(id)), 0)
                    nk.nk_chart_push_slot(ctx, math.cos(id), 1)
                    nk.nk_chart_push_slot(ctx, math.sin(id), 2)
                    id = id + step
                end
            end
            nk.nk_chart_end(ctx)

            -- /* mixed colored chart */
            nk.nk_layout_row_dynamic(ctx, 100, 1)
            if (nk.nk_chart_begin_colored(ctx, nk.NK_CHART_LINES, nk.nk_rgb(255,0,0), nk.nk_rgb(150,0,0), 32, 0.0, 1.0)) then
                nk.nk_chart_add_slot_colored(ctx, nk.NK_CHART_LINES, nk.nk_rgb(0,0,255), nk.nk_rgb(0,0,150),32, -1.0, 1.0)
                nk.nk_chart_add_slot_colored(ctx, nk.NK_CHART_LINES, nk.nk_rgb(0,255,0), nk.nk_rgb(0,150,0), 32, -1.0, 1.0)
                local id = 0
                for i = 0, 32-1 do
                    nk.nk_chart_push_slot(ctx, math.abs(math.sin(id)), 0)
                    nk.nk_chart_push_slot(ctx, math.cos(id), 1)
                    nk.nk_chart_push_slot(ctx, math.sin(id), 2)
                    id = id + step
                end
            end
            nk.nk_chart_end(ctx)
            nk.nk_tree_pop(ctx)
        end

        if (nk.nk_tree_push(ctx, nk.NK_TREE_TAB, "Popup", nk.NK_MINIMIZED)) then
        
            color = ffi.new("struct nk_color[1]", {{255,0,0, 255}})
            select = ffi.new("int[4]")
            popup_active = ffi.new("int[1]")
            inp = ctx[0].input
            bounds = ffi.new("struct nk_rect[1]")

            -- /* menu contextual */
            nk.nk_layout_row_static(ctx, 30, 160, 1)
            bounds = nk.nk_widget_bounds(ctx)
            nk.nk_label(ctx, "Right click me for menu", nk.NK_TEXT_LEFT)

            if (nk.nk_contextual_begin(ctx, 0, nk.nk_vec2(100, 300), bounds)) then
                local size_t prog = 40
                local int slider = 10

                nk.nk_layout_row_dynamic(ctx, 25, 1)
                nk.nk_checkbox_label(ctx, "Menu", show_menu)
                nk.nk_progress(ctx, prog, 100, nk.NK_MODIFIABLE)
                nk.nk_slider_int(ctx, 0, slider, 16, 1)
                if (nk_contextual_item_label(ctx, "About", nk.NK_TEXT_CENTERED)) then
                    show_app_about = nk.nk_true
                end
                local select0 = "Select"
                if(select[0]) then select0 = "Unselect" end
                nk.nk_selectable_label(ctx, select0, nk.NK_TEXT_LEFT, select[0])
                local select1 = "Select"
                if(select[1]) then select1 = "Unselect" end
                nk.nk_selectable_label(ctx, select1, nk.NK_TEXT_LEFT, select[1])
                local select2 = "Select"
                if(select[2]) then select2 = "Unselect" end
                nk.nk_selectable_label(ctx, select2, nk.NK_TEXT_LEFT, select[2])
                local select3 = "Select"
                if(select[3]) then select3 = "Unselect" end
                nk.nk_selectable_label(ctx, select3, nk.NK_TEXT_LEFT, select[3])
                nk.nk_contextual_end(ctx)
            end

            -- /* color contextual */
            nk.nk_layout_row_begin(ctx, nk.NK_STATIC, 30, 2)
            nk.nk_layout_row_push(ctx, 120)
            nk.nk_label(ctx, "Right Click here:", nk.NK_TEXT_LEFT)
            nk.nk_layout_row_push(ctx, 50)
            bounds = nk.nk_widget_bounds(ctx)
            nk.nk_button_color(ctx, color[0])
            nk.nk_layout_row_end(ctx)

            if (nk.nk_contextual_begin(ctx, 0, nk.nk_vec2(350, 60), bounds)) then
                nk.nk_layout_row_dynamic(ctx, 30, 4)
                color.r = nk.nk_propertyi(ctx, "#r", 0, color.r, 255, 1, 1)
                color.g = nk.nk_propertyi(ctx, "#g", 0, color.g, 255, 1, 1)
                color.b = nk.nk_propertyi(ctx, "#b", 0, color.b, 255, 1, 1)
                color.a = nk.nk_propertyi(ctx, "#a", 0, color.a, 255, 1, 1)
                nk.nk_contextual_end(ctx)
            end

            -- /* popup */
            nk.nk_layout_row_begin(ctx, nk.NK_STATIC, 30, 2)
            nk.nk_layout_row_push(ctx, 120)
            nk.nk_label(ctx, "Popup:", nk.NK_TEXT_LEFT)
            nk.nk_layout_row_push(ctx, 50)
            if (nk.nk_button_label(ctx, "Popup")) then
                popup_active = 1
            end
            nk.nk_layout_row_end(ctx)

            if (popup_active == 1) then
            
                local s = ffi.new("struct nk_rect[1]",{{20, 100, 220, 90}})
                if (nk.nk_popup_begin(ctx, nk.NK_POPUP_STATIC, "Error", 0, s)) then
                
                    nk.nk_layout_row_dynamic(ctx, 25, 1)
                    nk.nk_label(ctx, "A terrible error as occured", nk.NK_TEXT_LEFT)
                    nk.nk_layout_row_dynamic(ctx, 25, 2)
                    if (nk.nk_button_label(ctx, "OK")) then
                        popup_active = 0
                        nk.nk_popup_close(ctx)
                    end
                    if (nk.nk_button_label(ctx, "Cancel")) then
                        popup_active = 0
                        nk.nk_popup_close(ctx)
                    end
                    nk.nk_popup_end(ctx)
                else 
                    popup_active = nk.nk_false
                end
            end

            -- /* tooltip */
            nk.nk_layout_row_static(ctx, 30, 150, 1)
            bounds = nk.nk_widget_bounds(ctx)
            nk.nk_label(ctx, "Hover me for tooltip", nk.NK_TEXT_LEFT)
            if (nk.nk_input_is_mouse_hovering_rect(inp, bounds)) then
                nk.nk_tooltip(ctx, "This is a tooltip")
            end

            nk.nk_tree_pop(ctx)
        end

        if (nk.nk_tree_push(ctx, nk.NK_TREE_TAB, "Layout", nk.NK_MINIMIZED)) then
        
            if (nk.nk_tree_push(ctx, nk.NK_TREE_NODE, "Widget", nk.NK_MINIMIZED)) then
            
                ratio_two = ffi.new("float[3]", {0.2, 0.6, 0.2})
                width_two = ffi.new("float[3]", {100, 200, 50})

                nk.nk_layout_row_dynamic(ctx, 30, 1)
                nk.nk_label(ctx, "Dynamic fixed column layout with generated position and size:", nk.NK_TEXT_LEFT)
                nk.nk_layout_row_dynamic(ctx, 30, 3)
                nk.nk_button_label(ctx, "button")
                nk.nk_button_label(ctx, "button")
                nk.nk_button_label(ctx, "button")

                nk.nk_layout_row_dynamic(ctx, 30, 1)
                nk.nk_label(ctx, "static fixed column layout with generated position and size:", nk.NK_TEXT_LEFT)
                nk.nk_layout_row_static(ctx, 30, 100, 3)
                nk.nk_button_label(ctx, "button")
                nk.nk_button_label(ctx, "button")
                nk.nk_button_label(ctx, "button")

                nk.nk_layout_row_dynamic(ctx, 30, 1)
                nk.nk_label(ctx, "Dynamic array-based custom column layout with generated position and custom size:",nk.NK_TEXT_LEFT)
                nk.nk_layout_row(ctx, nk.NK_DYNAMIC, 30, 3, ratio_two)
                nk.nk_button_label(ctx, "button")
                nk.nk_button_label(ctx, "button")
                nk.nk_button_label(ctx, "button")

                nk.nk_layout_row_dynamic(ctx, 30, 1)
                nk.nk_label(ctx, "Static array-based custom column layout with generated position and custom size:",nk.NK_TEXT_LEFT )
                nk.nk_layout_row(ctx, nk.NK_STATIC, 30, 3, width_two)
                nk.nk_button_label(ctx, "button")
                nk.nk_button_label(ctx, "button")
                nk.nk_button_label(ctx, "button")

                nk.nk_layout_row_dynamic(ctx, 30, 1)
                nk.nk_label(ctx, "Dynamic immediate mode custom column layout with generated position and custom size:",nk.NK_TEXT_LEFT)
                nk.nk_layout_row_begin(ctx, nk.NK_DYNAMIC, 30, 3)
                nk.nk_layout_row_push(ctx, 0.2)
                nk.nk_button_label(ctx, "button")
                nk.nk_layout_row_push(ctx, 0.6)
                nk.nk_button_label(ctx, "button")
                nk.nk_layout_row_push(ctx, 0.2)
                nk.nk_button_label(ctx, "button")
                nk.nk_layout_row_end(ctx)

                nk.nk_layout_row_dynamic(ctx, 30, 1)
                nk.nk_label(ctx, "Static immediate mode custom column layout with generated position and custom size:", nk.NK_TEXT_LEFT)
                nk.nk_layout_row_begin(ctx, nk.NK_STATIC, 30, 3)
                nk.nk_layout_row_push(ctx, 100)
                nk.nk_button_label(ctx, "button")
                nk.nk_layout_row_push(ctx, 200)
                nk.nk_button_label(ctx, "button")
                nk.nk_layout_row_push(ctx, 50)
                nk.nk_button_label(ctx, "button")
                nk.nk_layout_row_end(ctx)

                nk.nk_layout_row_dynamic(ctx, 30, 1)
                nk.nk_label(ctx, "Static free space with custom position and custom size:", nk.NK_TEXT_LEFT)
                nk.nk_layout_space_begin(ctx, nk.NK_STATIC, 60, 4)
                nk.nk_layout_space_push(ctx, nk.nk_rect(100, 0, 100, 30))
                nk.nk_button_label(ctx, "button")
                nk.nk_layout_space_push(ctx, nk.nk_rect(0, 15, 100, 30))
                nk.nk_button_label(ctx, "button")
                nk.nk_layout_space_push(ctx, nk.nk_rect(200, 15, 100, 30))
                nk.nk_button_label(ctx, "button")
                nk.nk_layout_space_push(ctx, nk.nk_rect(100, 30, 100, 30))
                nk.nk_button_label(ctx, "button")
                nk.nk_layout_space_end(ctx)

                nk.nk_layout_row_dynamic(ctx, 30, 1)
                nk.nk_label(ctx, "Row template:", nk.NK_TEXT_LEFT)
                nk.nk_layout_row_template_begin(ctx, 30)
                nk.nk_layout_row_template_push_dynamic(ctx)
                nk.nk_layout_row_template_push_variable(ctx, 80)
                nk.nk_layout_row_template_push_static(ctx, 80)
                nk.nk_layout_row_template_end(ctx)
                nk.nk_button_label(ctx, "button")
                nk.nk_button_label(ctx, "button")
                nk.nk_button_label(ctx, "button")

                nk.nk_tree_pop(ctx)
            end

            if (nk.nk_tree_push(ctx, nk.NK_TREE_NODE, "Group", nk.NK_MINIMIZED)) then
            
                local group_titlebar = ffi.new("bool[1]", {nk.nk_false})
                local group_border = ffi.new("bool[1]", {nk.nk_true})
                local group_no_scrollbar = ffi.new("bool[1]", {nk.nk_false})
                local group_width = ffi.new("int[1]", {320})
                local group_height = ffi.new("int[1]", {200})

                group_flags = ffi.new("nk_flags[1]", {0})
                if (group_border) then group_flags[0] = bit.bor(group_flags[0], nk.NK_WINDOW_BORDER) end
                if (group_no_scrollbar) then group_flags[0] = bit.bor(group_flags[0], nk.NK_WINDOW_NO_SCROLLBAR) end
                if (group_titlebar) then group_flags[0] = bit.bor(group_flags[0], nk.NK_WINDOW_TITLE) end

                nk.nk_layout_row_dynamic(ctx, 30, 3)
                nk.nk_checkbox_label(ctx, "Titlebar", group_titlebar)
                nk.nk_checkbox_label(ctx, "Border", group_border)
                nk.nk_checkbox_label(ctx, "No Scrollbar", group_no_scrollbar)

                nk.nk_layout_row_begin(ctx, nk.NK_STATIC, 22, 3)
                nk.nk_layout_row_push(ctx, 50)
                nk.nk_label(ctx, "size:", nk.NK_TEXT_LEFT)
                nk.nk_layout_row_push(ctx, 130)
                nk.nk_property_int(ctx, "#Width:", 100, group_width, 500, 10, 1)
                nk.nk_layout_row_push(ctx, 130)
                nk.nk_property_int(ctx, "#Height:", 100, group_height, 500, 10, 1)
                nk.nk_layout_row_end(ctx)

                nk.nk_layout_row_static(ctx, group_height[0], group_width[0], 2)
                if (nk.nk_group_begin(ctx, "Group", group_flags[0])) then
                    local i = 0
                    local selected = ffi.new("int[16]")
                    nk.nk_layout_row_static(ctx, 18, 100, 1)
                    for i = 0, 16-1 do
                        local selected1 = ffi.string("Unselected")
                        if(selected[i]) then selected1 = ffi.string("Selected") end
                        nk.nk_selectable_label(ctx, selected1, nk.NK_TEXT_CENTERED, selected[i])
                    end
                    nk.nk_group_end(ctx)
                end
                nk.nk_tree_pop(ctx)
            end
            if (nk.nk_tree_push(ctx, nk.NK_TREE_NODE, "Tree", nk.NK_MINIMIZED)) then
            
                local root_selected = 0
                local sel = ffi.new("bool[1]", {root_selected})
                if (nk.nk_tree_element_push(ctx, nk.NK_TREE_NODE, "Root", nk.NK_MINIMIZED, sel)) then
                    local selected = ffi.new("int[8]")
                    local i = 0
                    local node_select = selected[0]
                    if (sel ~= root_selected) then
                        root_selected = sel
                        for i = 0, 8-1 do
                            selected[i] = sel
                        end
                    end
                    if (nk.nk_tree_element_push(ctx, nk.NK_TREE_NODE, "Node", nk.NK_MINIMIZED, node_select)) then
                        local j = 0
                        local sel_nodes = ffi.new("int[4]")
                        if (node_select ~= selected[0]) then
                            selected[0] = node_select
                            for i = 0, 4-1 do
                                sel_nodes[i] = node_select
                            end
                        end
                        nk.nk_layout_row_static(ctx, 18, 100, 1)
                        for j = 0, 4-1 do
                            local selectedj = ffi.string("Unselected")
                            if(sel_nodes[j]) then selectedj = ffi.string("Selected") end
                            nk.nk_selectable_symbol_label(ctx, nk.NK_SYMBOL_CIRCLE_SOLID, selectedj, nk.NK_TEXT_RIGHT, sel_nodes[j])
                        end
                        nk.nk_tree_element_pop(ctx)
                    end
                    nk.nk_layout_row_static(ctx, 18, 100, 1)
                    for i = 1, 8-1 do
                        local selectedi = ffi.string("Unselected")
                        if(selected[i]) then selectedi = ffi.string("Selected") end
                        nk.nk_selectable_symbol_label(ctx, nk.NK_SYMBOL_CIRCLE_SOLID, selectedi, nk.NK_TEXT_RIGHT, selected[i])
                    end
                    nk.nk_tree_element_pop(ctx)
                end
                nk.nk_tree_pop(ctx)
            end
            if (nk.nk_tree_push(ctx, nk.NK_TREE_NODE, "Notebook", nk.NK_MINIMIZED)) then
            
                local current_tab = 0
                local step = (2*3.141592654) / 32
                local chart_type = {CHART_LINE=0, CHART_HISTO=1, CHART_MIXED=2}
                local names = ffi.new("char [3][20]", {"Lines", "Columns", "Mixed"})
                local id = 0

                -- /* Header */
                nk.nk_style_push_vec2(ctx, ctx[0].style.window.spacing, nk.nk_vec2(0,0))
                local rnding = ffi.new("float[1]", {ctx[0].style.button.rounding})
                nk.nk_style_push_float(ctx, rnding, 0)
                nk.nk_layout_row_begin(ctx, nk.NK_STATIC, 20, 3)
                for i = 0, 3-1 do
                    -- /* make sure button perfectly fits text */
                    local f = ctx[0].style.font
                    local text_width = f.width(f.userdata, f.height, names[i], nk.nk_strlen(names[i]))
                    local widget_width = text_width + 3 * ctx[0].style.button.padding.x
                    nk.nk_layout_row_push(ctx, widget_width)
                    if (current_tab == i) then
                        -- /* active tab gets highlighted */
                        local button_color = ctx[0].style.button.normal
                        ctx[0].style.button.normal = ctx[0].style.button.active
                        if (nk.nk_button_label(ctx, names[i]) ) then current_tab = i end
                        ctx[0].style.button.normal = button_color
                    else 
                        if(nk.nk_button_label(ctx, names[i])) then current_tab = i end
                    end
                end
                nk.nk_style_pop_float(ctx)

                -- /* Body */
                nk.nk_layout_row_dynamic(ctx, 140, 1)
                if (nk.nk_group_begin(ctx, "Notebook", nk.NK_WINDOW_BORDER)) then
                
                    nk.nk_style_pop_vec2(ctx)
                    if(current_tab == nk.CHART_LINE) then
                        nk.nk_layout_row_dynamic(ctx, 100, 1)
                        if (nk.nk_chart_begin_colored(ctx, nk.NK_CHART_LINES, nk.nk_rgb(255,0,0), nk.nk_rgb(150,0,0), 32, 0.0, 1.0)) then
                            nk.nk_chart_add_slot_colored(ctx, nk.NK_CHART_LINES, nk.nk_rgb(0,0,255), nk.nk_rgb(0,0,150),32, -1.0, 1.0)
                            local id = 0
                            for i = 0, 32 -1 do
                                nk.nk_chart_push_slot(ctx, math.abs(sin(id)), 0)
                                nk.nk_chart_push_slot(ctx, math.cos(id), 1)
                                id = id + step
                            end
                        end
                        nk.nk_chart_end(ctx)
                    elseif(current_tab == nk.CHART_HISTO) then

                        nk.nk_layout_row_dynamic(ctx, 100, 1)
                        if (nk.nk_chart_begin_colored(ctx, nk.NK_CHART_COLUMN, nk.nk_rgb(255,0,0), nk.nk_rgb(150,0,0), 32, 0.0, 1.0)) then
                            local id = 0
                            for i = 0, 32-1 do
                                nk.nk_chart_push_slot(ctx, math.abs(math.sin(id)), 0)
                                id = id + step
                            end
                        end
                        nk.nk_chart_end(ctx)
                    elseif(current_tab == nk.CHART_MIXED) then
                        nk.nk_layout_row_dynamic(ctx, 100, 1)
                        if (nk.nk_chart_begin_colored(ctx, nk.NK_CHART_LINES, nk.nk_rgb(255,0,0), nk.nk_rgb(150,0,0), 32, 0.0, 1.0)) then
                            nk.nk_chart_add_slot_colored(ctx, nk.NK_CHART_LINES, nk.nk_rgb(0,0,255), nk.nk_rgb(0,0,150),32, -1.0, 1.0)
                            nk.nk_chart_add_slot_colored(ctx, nk.NK_CHART_COLUMN, nk.nk_rgb(0,255,0), nk.nk_rgb(0,150,0), 32, 0.0, 1.0)
                            local id = 0
                            for i = 0, 32-1 do
                                nk.nk_chart_push_slot(ctx, math.abs(math.sin(id)), 0)
                                nk.nk_chart_push_slot(ctx, math.abs(math.cos(id)), 1)
                                nk.nk_chart_push_slot(ctx, math.abs(math.sin(id)), 2)
                                id = id + step
                            end
                        end
                        nk.nk_chart_end(ctx)
                    end
                    nk.nk_group_end(ctx)
                else 
                    nk.nk_style_pop_vec2(ctx)
                end
                nk.nk_tree_pop(ctx)
            end

            if (nk.nk_tree_push(ctx, nk.NK_TREE_NODE, "Simple", nk.NK_MINIMIZED)) then
            
                nk.nk_layout_row_dynamic(ctx, 300, 2)
                if (nk.nk_group_begin(ctx, "Group_Without_Border", 0)) then
                    local i = 0
                    nk.nk_layout_row_static(ctx, 18, 150, 1)
                    for i = 0, 64-1 do
                        local buffer = ffi.string( "0x"..i ) 
                        nk.nk_labelf(ctx, nk.NK_TEXT_LEFT, "%s: scrollable region", buffer)
                    end
                    nk.nk_group_end(ctx)
                end
                if (nk.nk_group_begin(ctx, "Group_With_Border", nk.NK_WINDOW_BORDER)) then
                    local i = 0
                    nk.nk_layout_row_dynamic(ctx, 25, 2)
                    for i = 0, 64-1 do
                        local buffer = ffi.string(""..((((i%7)*10)^32))+(64+(i%2)*2)) 
                        nk.nk_button_label(ctx, buffer)
                    end
                    nk.nk_group_end(ctx)
                end
                nk.nk_tree_pop(ctx)
            end

            if (nk.nk_tree_push(ctx, nk.NK_TREE_NODE, "Complex", nk.NK_MINIMIZED)) then
            
                nk.nk_layout_space_begin(ctx, nk.NK_STATIC, 500, 64)
                nk.nk_layout_space_push(ctx, nk.nk_rect(0,0,150,500))
                if (nk.nk_group_begin(ctx, "Group_left", nk.NK_WINDOW_BORDER)) then
                    local selected = ffi.new("int[32]")
                    nk.nk_layout_row_static(ctx, 18, 100, 1)
                    for i = 0, 32-1 do
                        local selectedi = ffi.string("Unselected")
                        if(selected[i]) then selectedi = "Selected" end
                        nk.nk_selectable_label(ctx, selectedi, nk.NK_TEXT_CENTERED, selected[i])
                    end
                    nk.nk_group_end(ctx)
                end

                nk.nk_layout_space_push(ctx, nk.nk_rect(160,0,150,240))
                if (nk.nk_group_begin(ctx, "Group_top", nk.NK_WINDOW_BORDER)) then
                    nk.nk_layout_row_dynamic(ctx, 25, 1)
                    nk.nk_button_label(ctx, "#FFAA")
                    nk.nk_button_label(ctx, "#FFBB")
                    nk.nk_button_label(ctx, "#FFCC")
                    nk.nk_button_label(ctx, "#FFDD")
                    nk.nk_button_label(ctx, "#FFEE")
                    nk.nk_button_label(ctx, "#FFFF")
                    nk.nk_group_end(ctx)
                end

                nk.nk_layout_space_push(ctx, nk.nk_rect(160,250,150,250))
                if (nk.nk_group_begin(ctx, "Group_buttom", nk.NK_WINDOW_BORDER)) then
                    nk.nk_layout_row_dynamic(ctx, 25, 1)
                    nk.nk_button_label(ctx, "#FFAA")
                    nk.nk_button_label(ctx, "#FFBB")
                    nk.nk_button_label(ctx, "#FFCC")
                    nk.nk_button_label(ctx, "#FFDD")
                    nk.nk_button_label(ctx, "#FFEE")
                    nk.nk_button_label(ctx, "#FFFF")
                    nk.nk_group_end(ctx)
                end

                nk.nk_layout_space_push(ctx, nk.nk_rect(320,0,150,150))
                if (nk.nk_group_begin(ctx, "Group_right_top", nk.NK_WINDOW_BORDER)) then
                    local selected = ffi.new("int[4]")
                    nk.nk_layout_row_static(ctx, 18, 100, 1)
                    for i = 0, 4-1 do
                        local selectedi = ffi.string("Unselected")
                        if(selected[i]) then selectedi = ffi.string("Selected") end
                        nk.nk_selectable_label(ctx, selectedi, nk.NK_TEXT_CENTERED, selected[i])
                    end
                    nk.nk_group_end(ctx)
                end

                nk.nk_layout_space_push(ctx, nk.nk_rect(320,160,150,150))
                if (nk.nk_group_begin(ctx, "Group_right_center", nk.NK_WINDOW_BORDER)) then
                    local selected = ffi.new("int[4]")
                    nk.nk_layout_row_static(ctx, 18, 100, 1)
                    for i = 0, 4-1 do
                        local selectedi = ffi.string("Unselected")
                        if(selected[i]) then selectedi = ffi.string("Selected") end
                        nk.nk_selectable_label(ctx, selectedi, nk.NK_TEXT_CENTERED, selected[i])
                    end
                    nk.nk_group_end(ctx)
                end

                nk.nk_layout_space_push(ctx, nk.nk_rect(320,320,150,150))
                if (nk.nk_group_begin(ctx, "Group_right_bottom", nk.NK_WINDOW_BORDER)) then
                    local selected = ffi.new("int[4]")
                    nk.nk_layout_row_static(ctx, 18, 100, 1)
                    for i = 0, 4-1 do
                        local selectedi = ffi.string("Unselected")
                        nk.nk_selectable_label(ctx, selectedi, nk.NK_TEXT_CENTERED, selected[i])
                    end
                    nk.nk_group_end(ctx)
                end
                nk.nk_layout_space_end(ctx)
                nk.nk_tree_pop(ctx)
            end

            if (nk.nk_tree_push(ctx, nk.NK_TREE_NODE, "Splitter", nk.NK_MINIMIZED)) then
            
                inp = ctx[0].input
                nk.nk_layout_row_static(ctx, 20, 320, 1)
                nk.nk_label(ctx, "Use slider and spinner to change tile size", nk.NK_TEXT_LEFT)
                nk.nk_label(ctx, "Drag the space between tiles to change tile ratio", nk.NK_TEXT_LEFT)

                if (nk.nk_tree_push(ctx, nk.NK_TREE_NODE, "Vertical", nk.NK_MINIMIZED)) then
                
                    local a = ffi.new("float[1]", {100})
                    local b = ffi.new("float[1]", {100})
                    local c = ffi.new("float[1]", {100})
                    bounds = ffi.new("struct nk_rect[1]")

                    row_layout = ffi.new("float[5]")
                    row_layout[0] = a[0]
                    row_layout[1] = 8
                    row_layout[2] = b[0]
                    row_layout[3] = 8
                    row_layout[4] = c[0]

                    -- /* header */
                    nk.nk_layout_row_static(ctx, 30, 100, 2)
                    nk.nk_label(ctx, "left:", nk.NK_TEXT_LEFT)
                    nk.nk_slider_float(ctx, 10.0, a, 200.0, 10.0)

                    nk.nk_label(ctx, "middle:", nk.NK_TEXT_LEFT)
                    nk.nk_slider_float(ctx, 10.0, b, 200.0, 10.0)

                    nk.nk_label(ctx, "right:", nk.NK_TEXT_LEFT)
                    nk.nk_slider_float(ctx, 10.0, c, 200.0, 10.0)

                    -- /* tiles */
                    nk.nk_layout_row(ctx, nk.NK_STATIC, 200, 5, row_layout)

                    -- /* left space */
                    local winbit = bit.band(nk.NK_WINDOW_NO_SCROLLBAR, nk.NK_WINDOW_BORDER)
                    winbit = bit.band(winbit, nk.NK_WINDOW_NO_SCROLLBAR)
                    if (nk.nk_group_begin(ctx, "left", winbit)) then
                        nk.nk_layout_row_dynamic(ctx, 25, 1)
                        nk.nk_button_label(ctx, "#FFAA")
                        nk.nk_button_label(ctx, "#FFBB")
                        nk.nk_button_label(ctx, "#FFCC")
                        nk.nk_button_label(ctx, "#FFDD")
                        nk.nk_button_label(ctx, "#FFEE")
                        nk.nk_button_label(ctx, "#FFFF")
                        nk.nk_group_end(ctx)
                    end

                    -- /* scaler */
                    bounds = nk.nk_widget_bounds(ctx)
                    nk.nk_spacing(ctx, 1)
                    if ((nk.nk_input_is_mouse_hovering_rect(inp, bounds) or
                        nk.nk_input_is_mouse_prev_hovering_rect(inp, bounds)) and
                        nk.nk_input_is_mouse_down(inp, nk.NK_BUTTON_LEFT)) then
                    
                        a[0] = row_layout[0] + inp.mouse.delta.x
                        b[0] = row_layout[2] - inp.mouse.delta.x
                    end

                    -- /* middle space */
                    if (nk.nk_group_begin(ctx, "center", bit.bor(nk.NK_WINDOW_BORDER, nk.NK_WINDOW_NO_SCROLLBAR))) then
                        nk.nk_layout_row_dynamic(ctx, 25, 1)
                        nk.nk_button_label(ctx, "#FFAA")
                        nk.nk_button_label(ctx, "#FFBB")
                        nk.nk_button_label(ctx, "#FFCC")
                        nk.nk_button_label(ctx, "#FFDD")
                        nk.nk_button_label(ctx, "#FFEE")
                        nk.nk_button_label(ctx, "#FFFF")
                        nk.nk_group_end(ctx)
                    end

                    -- /* scaler */
                    bounds = nk.nk_widget_bounds(ctx)
                    nk.nk_spacing(ctx, 1)
                    if ((nk.nk_input_is_mouse_hovering_rect(inp, bounds) or
                        nk.nk_input_is_mouse_prev_hovering_rect(inp, bounds)) and
                        nk.nk_input_is_mouse_down(inp, nk.NK_BUTTON_LEFT)) then
                    
                        b[0] = (row_layout[2] + inp.mouse.delta.x)
                        c[0] = (row_layout[4] - inp.mouse.delta.x)
                    end

                    -- /* right space */
                    if (nk.nk_group_begin(ctx, "right", bit.bor(nk.NK_WINDOW_BORDER,nk.NK_WINDOW_NO_SCROLLBAR))) then
                        nk.nk_layout_row_dynamic(ctx, 25, 1)
                        nk.nk_button_label(ctx, "#FFAA")
                        nk.nk_button_label(ctx, "#FFBB")
                        nk.nk_button_label(ctx, "#FFCC")
                        nk.nk_button_label(ctx, "#FFDD")
                        nk.nk_button_label(ctx, "#FFEE")
                        nk.nk_button_label(ctx, "#FFFF")
                        nk.nk_group_end(ctx)
                    end

                    nk.nk_tree_pop(ctx)
                end

                if (nk.nk_tree_push(ctx, nk.NK_TREE_NODE, "Horizontal", nk.NK_MINIMIZED)) then
                
                    local a = ffi.new("float[1]", {100})
                    local b = ffi.new("float[1]", {100})
                    local c = ffi.new("float[1]", {100})
                    bounds = ffi.new("struct nk_rect[1]")

                    -- /* header */
                    nk.nk_layout_row_static(ctx, 30, 100, 2)
                    nk.nk_label(ctx, "top:", nk.NK_TEXT_LEFT)
                    nk.nk_slider_float(ctx, 10.0, a, 200.0, 10.0)

                    nk.nk_label(ctx, "middle:", nk.NK_TEXT_LEFT)
                    nk.nk_slider_float(ctx, 10.0, b, 200.0, 10.0)

                    nk.nk_label(ctx, "bottom:", nk.NK_TEXT_LEFT)
                    nk.nk_slider_float(ctx, 10.0, c, 200.0, 10.0)

                    -- /* top space */
                    nk.nk_layout_row_dynamic(ctx, a[0], 1)
                    if (nk.nk_group_begin(ctx, "top", bit.bor(nk.NK_WINDOW_NO_SCROLLBAR,nk.NK_WINDOW_BORDER))) then
                        nk.nk_layout_row_dynamic(ctx, 25, 3)
                        nk.nk_button_label(ctx, "#FFAA")
                        nk.nk_button_label(ctx, "#FFBB")
                        nk.nk_button_label(ctx, "#FFCC")
                        nk.nk_button_label(ctx, "#FFDD")
                        nk.nk_button_label(ctx, "#FFEE")
                        nk.nk_button_label(ctx, "#FFFF")
                        nk.nk_group_end(ctx)
                    end

                    -- /* scaler */
                    nk.nk_layout_row_dynamic(ctx, 8, 1)
                    bounds = nk.nk_widget_bounds(ctx)
                    nk.nk_spacing(ctx, 1)
                    if ((nk.nk_input_is_mouse_hovering_rect(inp, bounds) or
                        nk.nk_input_is_mouse_prev_hovering_rect(inp, bounds)) and
                        nk.nk_input_is_mouse_down(inp, nk.NK_BUTTON_LEFT)) then
                    
                        a = a + inp.mouse.delta.y
                        b = b - inp.mouse.delta.y
                    end

                    -- /* middle space */
                    nk.nk_layout_row_dynamic(ctx, b[0], 1)
                    if (nk.nk_group_begin(ctx, "middle", bit.bor(nk.NK_WINDOW_NO_SCROLLBAR,nk.NK_WINDOW_BORDER))) then
                        nk.nk_layout_row_dynamic(ctx, 25, 3)
                        nk.nk_button_label(ctx, "#FFAA")
                        nk.nk_button_label(ctx, "#FFBB")
                        nk.nk_button_label(ctx, "#FFCC")
                        nk.nk_button_label(ctx, "#FFDD")
                        nk.nk_button_label(ctx, "#FFEE")
                        nk.nk_button_label(ctx, "#FFFF")
                        nk.nk_group_end(ctx)
                    end

                    do
                        -- /* scaler */
                        nk.nk_layout_row_dynamic(ctx, 8, 1)
                        bounds = nk.nk_widget_bounds(ctx)
                        if ((nk.nk_input_is_mouse_hovering_rect(inp, bounds) or
                            nk.nk_input_is_mouse_prev_hovering_rect(inp, bounds)) and
                            nk.nk_input_is_mouse_down(inp, nk.NK_BUTTON_LEFT)) then
                        
                            b = b + inp.mouse.delta.y
                            c = c - inp.mouse.delta.y
                        end
                    end

                    -- /* bottom space */
                    nk.nk_layout_row_dynamic(ctx, c[0], 1)
                    if (nk.nk_group_begin(ctx, "bottom", bit.bor(nk.NK_WINDOW_NO_SCROLLBAR,nk.NK_WINDOW_BORDER))) then
                        nk.nk_layout_row_dynamic(ctx, 25, 3)
                        nk.nk_button_label(ctx, "#FFAA")
                        nk.nk_button_label(ctx, "#FFBB")
                        nk.nk_button_label(ctx, "#FFCC")
                        nk.nk_button_label(ctx, "#FFDD")
                        nk.nk_button_label(ctx, "#FFEE")
                        nk.nk_button_label(ctx, "#FFFF")
                        nk.nk_group_end(ctx)
                    end
                    nk.nk_tree_pop(ctx)
                end
                nk.nk_tree_pop(ctx)
            end
            nk.nk_tree_pop(ctx)
        end
    end
    nk.nk_end(ctx)
    return not nk.nk_window_is_closed(ctx, "Overview")
end

-- --------------------------------------------------------------------------------------

local function frame(void) 

    local ctx = nk.snk_new_frame()
    -- // see big function at end of file
    draw_demo_ui(ctx)

    -- // the sokol_gfx draw pass
    local pass = ffi.new("sg_pass[1]")
    pass[0].action.colors[0].load_action = sg.SG_LOADACTION_CLEAR
    pass[0].action.colors[0].clear_value = { 0.25, 0.5, 0.7, 1.0 }
    pass[0].swapchain = slib.sglue_swapchain()
    sg.sg_begin_pass(pass)

    nk.snk_render(sapp.sapp_width(), sapp.sapp_height())
    sg.sg_end_pass()
    sg.sg_commit()

    nk.nk_clear(ctx)
end

-- --------------------------------------------------------------------------------------

local app_desc = ffi.new("sapp_desc[1]")
app_desc[0].init_cb = init
app_desc[0].frame_cb = frame
app_desc[0].cleanup_cb = cleanup
app_desc[0].event_cb = input
app_desc[0].width = 1920
app_desc[0].height = 1080
app_desc[0].window_title = "nuklear (sokol-app)"
app_desc[0].icon.sokol_default = true 
app_desc[0].logger.func = slib.slog_func 
app_desc[0].enable_clipboard = true
app_desc[0].ios_keyboard_resizes_canvas = false

sapp.sapp_run( app_desc )

-- --------------------------------------------------------------------------------------
