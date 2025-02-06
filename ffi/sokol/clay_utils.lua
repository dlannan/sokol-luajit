
local clay      = require("clay")

-- --------------------------------------------------------------------------------------

local math_max  = math.max 
local math_min  = math.min

local clay_utils = {}

-- --------------------------------------------------------------------------------------

local CLAY__INIT = function(ctype) return ffi.new( ctype ) end
local CLAY__WRAPPER_TYPE = function(ctype) return "Clay__"..ctype.."Wrapper" end
local CLAY__WRAPPER_STRUCT = function(ctype) return [[typedef struct { ]]..ctype..[[ wrapped; } ]]..CLAY__WRAPPER_TYPE(ctype)..";" end
local CLAY__CONFIG_WRAPPER = function(ctype, ...) return CLAY__INIT(CLAY__WRAPPER_TYPE(ctype)).wrapped end

-- --------------------------------------------------------------------------------------

local CLAY__MAX = function(x, y) return math_max(x, y) end
local CLAY__MIN = function(x, y) return math_min(x, y) end

clay_utils.CLAY_LAYOUT = function(layoutElement)
    clay.Clay__AttachLayoutConfig(clay.Clay__StoreLayoutConfig(layoutElement) )
end

clay_utils.CLAY_RECTANGLE = function(rectconfig) 
    local rectElement = ffi.new("Clay_ElementConfigUnion", {
        rectangleElementConfig = clay.Clay__StoreRectangleElementConfig(rectconfig) 
    })    
    clay.Clay__AttachElementConfig( rectElement, clay.CLAY__ELEMENT_CONFIG_TYPE_RECTANGLE )
end 

clay_utils.CLAY_TEXT_CONFIG = function(...) 
    return clay.Clay__StoreTextElementConfig( ffi.new("Clay_TextElementConfig", ...))
end

-- CLAY_IMAGE(...) Clay__AttachElementConfig(CLAY__INIT(Clay_ElementConfigUnion) { .imageElementConfig = Clay__StoreImageElementConfig(CLAY__CONFIG_WRAPPER(Clay_ImageElementConfig, __VA_ARGS__)) }, CLAY__ELEMENT_CONFIG_TYPE_IMAGE)

-- CLAY_FLOATING(...) Clay__AttachElementConfig(CLAY__INIT(Clay_ElementConfigUnion) { .floatingElementConfig = Clay__StoreFloatingElementConfig(CLAY__CONFIG_WRAPPER(Clay_FloatingElementConfig, __VA_ARGS__)) }, CLAY__ELEMENT_CONFIG_TYPE_FLOATING_CONTAINER)

-- CLAY_CUSTOM_ELEMENT(...) Clay__AttachElementConfig(CLAY__INIT(Clay_ElementConfigUnion) { .customElementConfig = Clay__StoreCustomElementConfig(CLAY__CONFIG_WRAPPER(Clay_CustomElementConfig, __VA_ARGS__)) }, CLAY__ELEMENT_CONFIG_TYPE_CUSTOM)

-- CLAY_SCROLL(...) Clay__AttachElementConfig(CLAY__INIT(Clay_ElementConfigUnion) { .scrollElementConfig = Clay__StoreScrollElementConfig(CLAY__CONFIG_WRAPPER(Clay_ScrollElementConfig, __VA_ARGS__)) }, CLAY__ELEMENT_CONFIG_TYPE_SCROLL_CONTAINER)

-- CLAY_BORDER(...) Clay__AttachElementConfig(CLAY__INIT(Clay_ElementConfigUnion) { .borderElementConfig = Clay__StoreBorderElementConfig(CLAY__CONFIG_WRAPPER(Clay_BorderElementConfig, __VA_ARGS__)) }, CLAY__ELEMENT_CONFIG_TYPE_BORDER_CONTAINER)

-- CLAY_BORDER_OUTSIDE(...) Clay__AttachElementConfig(CLAY__INIT(Clay_ElementConfigUnion) { .borderElementConfig = Clay__StoreBorderElementConfig(CLAY__INIT(Clay_BorderElementConfig) { .left = __VA_ARGS__, .right = __VA_ARGS__, .top = __VA_ARGS__, .bottom = __VA_ARGS__ }) }, CLAY__ELEMENT_CONFIG_TYPE_BORDER_CONTAINER)

-- CLAY_BORDER_OUTSIDE_RADIUS(width, color, radius) Clay__AttachElementConfig(CLAY__INIT(Clay_ElementConfigUnion) { .borderElementConfig = Clay__StoreBorderElementConfig(CLAY__INIT(Clay_BorderElementConfig) { .left = { width, color }, .right = { width, color }, .top = { width, color }, .bottom = { width, color }, .cornerRadius = CLAY_CORNER_RADIUS(radius) })}, CLAY__ELEMENT_CONFIG_TYPE_BORDER_CONTAINER)

-- CLAY_BORDER_ALL(...) Clay__AttachElementConfig(CLAY__INIT(Clay_ElementConfigUnion) { .borderElementConfig = Clay__StoreBorderElementConfig(CLAY__INIT(Clay_BorderElementConfig) { .left = __VA_ARGS__, .right = __VA_ARGS__, .top = __VA_ARGS__, .bottom = __VA_ARGS__, .betweenChildren = __VA_ARGS__ } ) }, CLAY__ELEMENT_CONFIG_TYPE_BORDER_CONTAINER)

-- CLAY_BORDER_ALL_RADIUS(width, color, radius) Clay__AttachElementConfig(CLAY__INIT(Clay_ElementConfigUnion) { .borderElementConfig = Clay__StoreBorderElementConfig(CLAY__INIT(Clay_BorderElementConfig) { .left = { width, color }, .right = { width, color }, .top = { width, color }, .bottom = { width, color }, .betweenChildren = { width, color }, .cornerRadius = CLAY_CORNER_RADIUS(radius)}) }, CLAY__ELEMENT_CONFIG_TYPE_BORDER_CONTAINER)

-- CLAY_CORNER_RADIUS(radius) (CLAY__INIT(Clay_CornerRadius) { radius, radius, radius, radius })

-- CLAY_PADDING_ALL(padding) CLAY__CONFIG_WRAPPER(Clay_Padding, { padding, padding, padding, padding })

-- CLAY_SIZING_FIT(...) (CLAY__INIT(Clay_SizingAxis) { .size = { .minMax = { __VA_ARGS__ } }, .type = CLAY__SIZING_TYPE_FIT })

-- CLAY_SIZING_GROW(...) (CLAY__INIT(Clay_SizingAxis) { .size = { .minMax = { __VA_ARGS__ } }, .type = CLAY__SIZING_TYPE_GROW })

-- CLAY_SIZING_FIXED(fixedSize) (CLAY__INIT(Clay_SizingAxis) { .size = { .minMax = { fixedSize, fixedSize } }, .type = CLAY__SIZING_TYPE_FIXED })

-- CLAY_SIZING_PERCENT(percentOfParent) (CLAY__INIT(Clay_SizingAxis) { .size = { .percent = (percentOfParent) }, .type = CLAY__SIZING_TYPE_PERCENT })

-- CLAY_ID(label) Clay__AttachId(Clay__HashString(CLAY_STRING(label), 0, 0))

-- CLAY_IDI(label, index) Clay__AttachId(Clay__HashString(CLAY_STRING(label), index, 0))

-- CLAY_ID_LOCAL(label) CLAY_IDI_LOCAL(label, 0)

-- CLAY_IDI_LOCAL(label, index) Clay__AttachId(Clay__HashString(CLAY_STRING(label), index, Clay__GetParentElementId()))

-- CLAY__STRING_LENGTH(s) ((sizeof(s) / sizeof((s)[0])) - sizeof((s)[0]))

-- CLAY__ENSURE_STRING_LITERAL(x) ("" x "")

-- // Note: If an error led you here, it's because CLAY_STRING can only be used with string literals, i.e. CLAY_STRING("SomeString") and not CLAY_STRING(yourString)
clay_utils.CLAY_STRING = function(str) 
    return ffi.new("Clay_String", { length = #str, chars = ffi.string(str) })
end

clay_utils.CLAY_STRING_CONST = CLAY_STRING

local CLAY__ELEMENT_DEFINITION_LATCH = 0

-- /* This macro looks scary on the surface, but is actually quite simple.
--   It turns a macro call like this:

--   CLAY(
--     CLAY_RECTANGLE(),
--     CLAY_ID()
--   ) {
--       ...children declared here
--   }

--   Into calls like this:

--   Clay_OpenElement();
--   CLAY_RECTANGLE();
--   CLAY_ID();
--   Clay_ElementPostConfiguration();
--   ...children declared here
--   Clay_CloseElement();

--   The for loop will only ever run a single iteration, putting Clay__CloseElement() in the increment of the loop
--   means that it will run after the body - where the children are declared. It just exists to make sure you don't forget
--   to call Clay_CloseElement().
-- */
clay_utils.CLAY = function(...)
	do
        clay.Clay__OpenElement()

        clay.Clay__ElementPostConfiguration()
        clay.CLAY__ELEMENT_DEFINITION_LATCH =  clay.CLAY__ELEMENT_DEFINITION_LATCH + 1
        clay.Clay__CloseElement()
    end
end

clay_utils.CLAY_START = function()
    clay.CLAY__ELEMENT_DEFINITION_LATCH = 0
    clay.Clay__OpenElement()
end

clay_utils.CLAY_POSTCONFIG = function()
    clay.Clay__ElementPostConfiguration()
end

clay_utils.CLAY_END = function()
    clay.CLAY__ELEMENT_DEFINITION_LATCH =  clay.CLAY__ELEMENT_DEFINITION_LATCH + 1
    clay.Clay__CloseElement()
end

clay_utils.CLAY_TEXT = function(text, textConfig) 
    return clay.Clay__OpenTextElement(text, textConfig) 
end


return clay_utils