
local clay_utils = {}

local CLAY__INIT = function(ctype, init) return ffi.cdef( ctype, init ) end
local CLAY__WRAPPER_TYPE = function(ctype) return "Clay__"..ctype.."Wrapper" end
local CLAY__WRAPPER_STRUCT = function(ctype) return [[typedef struct { ]]..ctype..[[ wrapped; } ]]..CLAY__WRAPPER_TYPE(ctype)..";" end
local CLAY__CONFIG_WRAPPER = function(ctype, ...) CLAY__INIT(CLAY__WRAPPER_TYPE(ctype)), { ... }).wrapped end

local CLAY__MAX(x, y) = function return math.max(x, y) end
local CLAY__MIN(x, y) = function return math.min(x, y) end

CLAY_LAYOUT(...) Clay__AttachLayoutConfig(Clay__StoreLayoutConfig(CLAY__CONFIG_WRAPPER(Clay_LayoutConfig, __VA_ARGS__)))

CLAY_RECTANGLE(...) Clay__AttachElementConfig(CLAY__INIT(Clay_ElementConfigUnion) { .rectangleElementConfig = Clay__StoreRectangleElementConfig(CLAY__CONFIG_WRAPPER(Clay_RectangleElementConfig, __VA_ARGS__)) }, CLAY__ELEMENT_CONFIG_TYPE_RECTANGLE)

CLAY_TEXT_CONFIG(...) Clay__StoreTextElementConfig(CLAY__CONFIG_WRAPPER(Clay_TextElementConfig, __VA_ARGS__))

CLAY_IMAGE(...) Clay__AttachElementConfig(CLAY__INIT(Clay_ElementConfigUnion) { .imageElementConfig = Clay__StoreImageElementConfig(CLAY__CONFIG_WRAPPER(Clay_ImageElementConfig, __VA_ARGS__)) }, CLAY__ELEMENT_CONFIG_TYPE_IMAGE)

CLAY_FLOATING(...) Clay__AttachElementConfig(CLAY__INIT(Clay_ElementConfigUnion) { .floatingElementConfig = Clay__StoreFloatingElementConfig(CLAY__CONFIG_WRAPPER(Clay_FloatingElementConfig, __VA_ARGS__)) }, CLAY__ELEMENT_CONFIG_TYPE_FLOATING_CONTAINER)

CLAY_CUSTOM_ELEMENT(...) Clay__AttachElementConfig(CLAY__INIT(Clay_ElementConfigUnion) { .customElementConfig = Clay__StoreCustomElementConfig(CLAY__CONFIG_WRAPPER(Clay_CustomElementConfig, __VA_ARGS__)) }, CLAY__ELEMENT_CONFIG_TYPE_CUSTOM)

CLAY_SCROLL(...) Clay__AttachElementConfig(CLAY__INIT(Clay_ElementConfigUnion) { .scrollElementConfig = Clay__StoreScrollElementConfig(CLAY__CONFIG_WRAPPER(Clay_ScrollElementConfig, __VA_ARGS__)) }, CLAY__ELEMENT_CONFIG_TYPE_SCROLL_CONTAINER)

CLAY_BORDER(...) Clay__AttachElementConfig(CLAY__INIT(Clay_ElementConfigUnion) { .borderElementConfig = Clay__StoreBorderElementConfig(CLAY__CONFIG_WRAPPER(Clay_BorderElementConfig, __VA_ARGS__)) }, CLAY__ELEMENT_CONFIG_TYPE_BORDER_CONTAINER)

CLAY_BORDER_OUTSIDE(...) Clay__AttachElementConfig(CLAY__INIT(Clay_ElementConfigUnion) { .borderElementConfig = Clay__StoreBorderElementConfig(CLAY__INIT(Clay_BorderElementConfig) { .left = __VA_ARGS__, .right = __VA_ARGS__, .top = __VA_ARGS__, .bottom = __VA_ARGS__ }) }, CLAY__ELEMENT_CONFIG_TYPE_BORDER_CONTAINER)

CLAY_BORDER_OUTSIDE_RADIUS(width, color, radius) Clay__AttachElementConfig(CLAY__INIT(Clay_ElementConfigUnion) { .borderElementConfig = Clay__StoreBorderElementConfig(CLAY__INIT(Clay_BorderElementConfig) { .left = { width, color }, .right = { width, color }, .top = { width, color }, .bottom = { width, color }, .cornerRadius = CLAY_CORNER_RADIUS(radius) })}, CLAY__ELEMENT_CONFIG_TYPE_BORDER_CONTAINER)

CLAY_BORDER_ALL(...) Clay__AttachElementConfig(CLAY__INIT(Clay_ElementConfigUnion) { .borderElementConfig = Clay__StoreBorderElementConfig(CLAY__INIT(Clay_BorderElementConfig) { .left = __VA_ARGS__, .right = __VA_ARGS__, .top = __VA_ARGS__, .bottom = __VA_ARGS__, .betweenChildren = __VA_ARGS__ } ) }, CLAY__ELEMENT_CONFIG_TYPE_BORDER_CONTAINER)

CLAY_BORDER_ALL_RADIUS(width, color, radius) Clay__AttachElementConfig(CLAY__INIT(Clay_ElementConfigUnion) { .borderElementConfig = Clay__StoreBorderElementConfig(CLAY__INIT(Clay_BorderElementConfig) { .left = { width, color }, .right = { width, color }, .top = { width, color }, .bottom = { width, color }, .betweenChildren = { width, color }, .cornerRadius = CLAY_CORNER_RADIUS(radius)}) }, CLAY__ELEMENT_CONFIG_TYPE_BORDER_CONTAINER)

CLAY_CORNER_RADIUS(radius) (CLAY__INIT(Clay_CornerRadius) { radius, radius, radius, radius })

CLAY_PADDING_ALL(padding) CLAY__CONFIG_WRAPPER(Clay_Padding, { padding, padding, padding, padding })

CLAY_SIZING_FIT(...) (CLAY__INIT(Clay_SizingAxis) { .size = { .minMax = { __VA_ARGS__ } }, .type = CLAY__SIZING_TYPE_FIT })

CLAY_SIZING_GROW(...) (CLAY__INIT(Clay_SizingAxis) { .size = { .minMax = { __VA_ARGS__ } }, .type = CLAY__SIZING_TYPE_GROW })

CLAY_SIZING_FIXED(fixedSize) (CLAY__INIT(Clay_SizingAxis) { .size = { .minMax = { fixedSize, fixedSize } }, .type = CLAY__SIZING_TYPE_FIXED })

CLAY_SIZING_PERCENT(percentOfParent) (CLAY__INIT(Clay_SizingAxis) { .size = { .percent = (percentOfParent) }, .type = CLAY__SIZING_TYPE_PERCENT })

CLAY_ID(label) Clay__AttachId(Clay__HashString(CLAY_STRING(label), 0, 0))

CLAY_IDI(label, index) Clay__AttachId(Clay__HashString(CLAY_STRING(label), index, 0))

CLAY_ID_LOCAL(label) CLAY_IDI_LOCAL(label, 0)

CLAY_IDI_LOCAL(label, index) Clay__AttachId(Clay__HashString(CLAY_STRING(label), index, Clay__GetParentElementId()))

CLAY__STRING_LENGTH(s) ((sizeof(s) / sizeof((s)[0])) - sizeof((s)[0]))

CLAY__ENSURE_STRING_LITERAL(x) ("" x "")

-- // Note: If an error led you here, it's because CLAY_STRING can only be used with string literals, i.e. CLAY_STRING("SomeString") and not CLAY_STRING(yourString)
CLAY_STRING(string) (CLAY__INIT(Clay_String) { .length = CLAY__STRING_LENGTH(CLAY__ENSURE_STRING_LITERAL(string)), .chars = (string) })

CLAY_STRING_CONST(string) { .length = CLAY__STRING_LENGTH(CLAY__ENSURE_STRING_LITERAL(string)), .chars = (string) }
