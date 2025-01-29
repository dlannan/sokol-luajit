local ffi  = require( "ffi" )

local sokol_filename = _G.SOKOL_DLL or "sokol_imgui_dll"
local libs = ffi_sokol_imgui or {
   OSX     = { x64 = sokol_filename..".so" },
   Windows = { x64 = sokol_filename..".dll" },
   Linux   = { x64 = sokol_filename..".so", arm = sokol_filename..".so" },
   BSD     = { x64 = sokol_filename..".so" },
   POSIX   = { x64 = sokol_filename..".so" },
   Other   = { x64 = sokol_filename..".so" },
}

local lib  = ffi_sokol_imgui or libs[ ffi.os ][ ffi.arch ]
local sokol_imgui   = ffi.load( lib )

ffi.cdef[[

/********** cimgui ****************************************************************/

typedef unsigned int ImGuiID;
typedef signed char ImS8;
typedef unsigned char ImU8;
typedef signed short ImS16;
typedef unsigned short ImU16;
typedef signed int ImS32;
typedef unsigned int ImU32;
typedef signed long long ImS64;
typedef unsigned long long ImU64;
struct ImDrawChannel;
struct ImDrawCmd;
struct ImDrawData;
struct ImDrawList;
struct ImDrawListSharedData;
struct ImDrawListSplitter;
struct ImDrawVert;
struct ImFont;
struct ImFontAtlas;
struct ImFontBuilderIO;
struct ImFontConfig;
struct ImFontGlyph;
struct ImFontGlyphRangesBuilder;
struct ImColor;
struct ImGuiContext;
struct ImGuiIO;
struct ImGuiInputTextCallbackData;
struct ImGuiKeyData;
struct ImGuiListClipper;
struct ImGuiMultiSelectIO;
struct ImGuiOnceUponAFrame;
struct ImGuiPayload;
struct ImGuiPlatformIO;
struct ImGuiPlatformImeData;
struct ImGuiSelectionBasicStorage;
struct ImGuiSelectionExternalStorage;
struct ImGuiSelectionRequest;
struct ImGuiSizeCallbackData;
struct ImGuiStorage;
struct ImGuiStoragePair;
struct ImGuiStyle;
struct ImGuiTableSortSpecs;
struct ImGuiTableColumnSortSpecs;
struct ImGuiTextBuffer;
struct ImGuiTextFilter;
struct ImGuiViewport;
typedef int ImGuiCol;
typedef int ImGuiCond;
typedef int ImGuiDataType;
typedef int ImGuiMouseButton;
typedef int ImGuiMouseCursor;
typedef int ImGuiStyleVar;
typedef int ImGuiTableBgTarget;
typedef int ImDrawFlags;
typedef int ImDrawListFlags;
typedef int ImFontAtlasFlags;
typedef int ImGuiBackendFlags;
typedef int ImGuiButtonFlags;
typedef int ImGuiChildFlags;
typedef int ImGuiColorEditFlags;
typedef int ImGuiConfigFlags;
typedef int ImGuiComboFlags;
typedef int ImGuiDragDropFlags;
typedef int ImGuiFocusedFlags;
typedef int ImGuiHoveredFlags;
typedef int ImGuiInputFlags;
typedef int ImGuiInputTextFlags;
typedef int ImGuiItemFlags;
typedef int ImGuiKeyChord;
typedef int ImGuiPopupFlags;
typedef int ImGuiMultiSelectFlags;
typedef int ImGuiSelectableFlags;
typedef int ImGuiSliderFlags;
typedef int ImGuiTabBarFlags;
typedef int ImGuiTabItemFlags;
typedef int ImGuiTableFlags;
typedef int ImGuiTableColumnFlags;
typedef int ImGuiTableRowFlags;
typedef int ImGuiTreeNodeFlags;
typedef int ImGuiViewportFlags;
typedef int ImGuiWindowFlags;
typedef void* ImTextureID;
typedef unsigned short ImDrawIdx;
typedef unsigned int ImWchar32;
typedef unsigned short ImWchar16;
typedef ImWchar16 ImWchar;
typedef ImS64 ImGuiSelectionUserData;

typedef struct ImVector_ImWchar {int Size;int Capacity;ImWchar* Data;} ImVector_ImWchar;

typedef struct ImVec2 {
   float x;
   float y;
} ImVec2;

typedef struct ImVec4 {
   float x;
   float y;
   float z;
   float w;
} ImVec4;

typedef struct ImVec2ih {
   int16_t x;
   int16_t y;
} ImVec2ih;

typedef struct ImRect {
   ImVec2 Min;
   ImVec2 Max;
} ImRect;

typedef struct ImGuiKeyData
{
    bool Down;
    float DownDuration;
    float DownDurationPrev;
    float AnalogValue;
} ImGuiKeyData;

typedef enum {
   ImGuiSliderFlags_None = 0,
   ImGuiSliderFlags_AlwaysClamp = 1 << 4,
   ImGuiSliderFlags_Logarithmic = 1 << 5,
   ImGuiSliderFlags_NoRoundToFormat = 1 << 6,
   ImGuiSliderFlags_NoInput = 1 << 7,
   ImGuiSliderFlags_WrapAround = 1 << 8,
   ImGuiSliderFlags_InvalidMask_ = 0x7000000F,
}ImGuiSliderFlags_;

typedef enum {
   ImGuiInputTextFlags_None = 0,
   ImGuiInputTextFlags_CharsDecimal = 1 << 0,
   ImGuiInputTextFlags_CharsHexadecimal = 1 << 1,
   ImGuiInputTextFlags_CharsScientific = 1 << 2,
   ImGuiInputTextFlags_CharsUppercase = 1 << 3,
   ImGuiInputTextFlags_CharsNoBlank = 1 << 4,
   ImGuiInputTextFlags_AllowTabInput = 1 << 5,
   ImGuiInputTextFlags_EnterReturnsTrue = 1 << 6,
   ImGuiInputTextFlags_EscapeClearsAll = 1 << 7,
   ImGuiInputTextFlags_CtrlEnterForNewLine = 1 << 8,
   ImGuiInputTextFlags_ReadOnly = 1 << 9,
   ImGuiInputTextFlags_Password = 1 << 10,
   ImGuiInputTextFlags_AlwaysOverwrite = 1 << 11,
   ImGuiInputTextFlags_AutoSelectAll = 1 << 12,
   ImGuiInputTextFlags_ParseEmptyRefVal = 1 << 13,
   ImGuiInputTextFlags_DisplayEmptyRefVal = 1 << 14,
   ImGuiInputTextFlags_NoHorizontalScroll = 1 << 15,
   ImGuiInputTextFlags_NoUndoRedo = 1 << 16,
   ImGuiInputTextFlags_CallbackCompletion = 1 << 17,
   ImGuiInputTextFlags_CallbackHistory = 1 << 18,
   ImGuiInputTextFlags_CallbackAlways = 1 << 19,
   ImGuiInputTextFlags_CallbackCharFilter = 1 << 20,
   ImGuiInputTextFlags_CallbackResize = 1 << 21,
   ImGuiInputTextFlags_CallbackEdit = 1 << 22,
}ImGuiInputTextFlags_;

typedef enum {
   ImGuiComboFlags_None = 0,
   ImGuiComboFlags_PopupAlignLeft = 1 << 0,
   ImGuiComboFlags_HeightSmall = 1 << 1,
   ImGuiComboFlags_HeightRegular = 1 << 2,
   ImGuiComboFlags_HeightLarge = 1 << 3,
   ImGuiComboFlags_HeightLargest = 1 << 4,
   ImGuiComboFlags_NoArrowButton = 1 << 5,
   ImGuiComboFlags_NoPreview = 1 << 6,
   ImGuiComboFlags_WidthFitPreview = 1 << 7,
   ImGuiComboFlags_HeightMask_ = ImGuiComboFlags_HeightSmall | ImGuiComboFlags_HeightRegular | ImGuiComboFlags_HeightLarge | ImGuiComboFlags_HeightLargest,
}ImGuiComboFlags_;

typedef enum {
   ImGuiConfigFlags_None = 0,
   ImGuiConfigFlags_NavEnableKeyboard = 1 << 0,
   ImGuiConfigFlags_NavEnableGamepad = 1 << 1,
   ImGuiConfigFlags_NavEnableSetMousePos = 1 << 2,
   ImGuiConfigFlags_NavNoCaptureKeyboard = 1 << 3,
   ImGuiConfigFlags_NoMouse = 1 << 4,
   ImGuiConfigFlags_NoMouseCursorChange = 1 << 5,
   ImGuiConfigFlags_NoKeyboard = 1 << 6,
   ImGuiConfigFlags_IsSRGB = 1 << 20,
   ImGuiConfigFlags_IsTouchScreen = 1 << 21,
}ImGuiConfigFlags_;

typedef enum {
   ImGuiBackendFlags_None = 0,
   ImGuiBackendFlags_HasGamepad = 1 << 0,
   ImGuiBackendFlags_HasMouseCursors = 1 << 1,
   ImGuiBackendFlags_HasSetMousePos = 1 << 2,
   ImGuiBackendFlags_RendererHasVtxOffset = 1 << 3,
}ImGuiBackendFlags_;

typedef enum {
   ImGuiMouseSource_Mouse=0,
   ImGuiMouseSource_TouchScreen=1,
   ImGuiMouseSource_Pen=2,
   ImGuiMouseSource_COUNT=3,
}ImGuiMouseSource;

typedef enum {
   ImGuiCond_None = 0,
   ImGuiCond_Always = 1 << 0,
   ImGuiCond_Once = 1 << 1,
   ImGuiCond_FirstUseEver = 1 << 2,
   ImGuiCond_Appearing = 1 << 3,
}ImGuiCond_;

typedef enum {
   ImGuiDir_None=-1,
   ImGuiDir_Left=0,
   ImGuiDir_Right=1,
   ImGuiDir_Up=2,
   ImGuiDir_Down=3,
   ImGuiDir_COUNT=4,
   }ImGuiDir;
   typedef enum {
   ImGuiSortDirection_None=0,
   ImGuiSortDirection_Ascending=1,
   ImGuiSortDirection_Descending=2,
   }ImGuiSortDirection;
   typedef enum {
   ImGuiKey_None=0,
   ImGuiKey_Tab=512,
   ImGuiKey_LeftArrow=513,
   ImGuiKey_RightArrow=514,
   ImGuiKey_UpArrow=515,
   ImGuiKey_DownArrow=516,
   ImGuiKey_PageUp=517,
   ImGuiKey_PageDown=518,
   ImGuiKey_Home=519,
   ImGuiKey_End=520,
   ImGuiKey_Insert=521,
   ImGuiKey_Delete=522,
   ImGuiKey_Backspace=523,
   ImGuiKey_Space=524,
   ImGuiKey_Enter=525,
   ImGuiKey_Escape=526,
   ImGuiKey_LeftCtrl=527,
   ImGuiKey_LeftShift=528,
   ImGuiKey_LeftAlt=529,
   ImGuiKey_LeftSuper=530,
   ImGuiKey_RightCtrl=531,
   ImGuiKey_RightShift=532,
   ImGuiKey_RightAlt=533,
   ImGuiKey_RightSuper=534,
   ImGuiKey_Menu=535,
   ImGuiKey_0=536,
   ImGuiKey_1=537,
   ImGuiKey_2=538,
   ImGuiKey_3=539,
   ImGuiKey_4=540,
   ImGuiKey_5=541,
   ImGuiKey_6=542,
   ImGuiKey_7=543,
   ImGuiKey_8=544,
   ImGuiKey_9=545,
   ImGuiKey_A=546,
   ImGuiKey_B=547,
   ImGuiKey_C=548,
   ImGuiKey_D=549,
   ImGuiKey_E=550,
   ImGuiKey_F=551,
   ImGuiKey_G=552,
   ImGuiKey_H=553,
   ImGuiKey_I=554,
   ImGuiKey_J=555,
   ImGuiKey_K=556,
   ImGuiKey_L=557,
   ImGuiKey_M=558,
   ImGuiKey_N=559,
   ImGuiKey_O=560,
   ImGuiKey_P=561,
   ImGuiKey_Q=562,
   ImGuiKey_R=563,
   ImGuiKey_S=564,
   ImGuiKey_T=565,
   ImGuiKey_U=566,
   ImGuiKey_V=567,
   ImGuiKey_W=568,
   ImGuiKey_X=569,
   ImGuiKey_Y=570,
   ImGuiKey_Z=571,
   ImGuiKey_F1=572,
   ImGuiKey_F2=573,
   ImGuiKey_F3=574,
   ImGuiKey_F4=575,
   ImGuiKey_F5=576,
   ImGuiKey_F6=577,
   ImGuiKey_F7=578,
   ImGuiKey_F8=579,
   ImGuiKey_F9=580,
   ImGuiKey_F10=581,
   ImGuiKey_F11=582,
   ImGuiKey_F12=583,
   ImGuiKey_F13=584,
   ImGuiKey_F14=585,
   ImGuiKey_F15=586,
   ImGuiKey_F16=587,
   ImGuiKey_F17=588,
   ImGuiKey_F18=589,
   ImGuiKey_F19=590,
   ImGuiKey_F20=591,
   ImGuiKey_F21=592,
   ImGuiKey_F22=593,
   ImGuiKey_F23=594,
   ImGuiKey_F24=595,
   ImGuiKey_Apostrophe=596,
   ImGuiKey_Comma=597,
   ImGuiKey_Minus=598,
   ImGuiKey_Period=599,
   ImGuiKey_Slash=600,
   ImGuiKey_Semicolon=601,
   ImGuiKey_Equal=602,
   ImGuiKey_LeftBracket=603,
   ImGuiKey_Backslash=604,
   ImGuiKey_RightBracket=605,
   ImGuiKey_GraveAccent=606,
   ImGuiKey_CapsLock=607,
   ImGuiKey_ScrollLock=608,
   ImGuiKey_NumLock=609,
   ImGuiKey_PrintScreen=610,
   ImGuiKey_Pause=611,
   ImGuiKey_Keypad0=612,
   ImGuiKey_Keypad1=613,
   ImGuiKey_Keypad2=614,
   ImGuiKey_Keypad3=615,
   ImGuiKey_Keypad4=616,
   ImGuiKey_Keypad5=617,
   ImGuiKey_Keypad6=618,
   ImGuiKey_Keypad7=619,
   ImGuiKey_Keypad8=620,
   ImGuiKey_Keypad9=621,
   ImGuiKey_KeypadDecimal=622,
   ImGuiKey_KeypadDivide=623,
   ImGuiKey_KeypadMultiply=624,
   ImGuiKey_KeypadSubtract=625,
   ImGuiKey_KeypadAdd=626,
   ImGuiKey_KeypadEnter=627,
   ImGuiKey_KeypadEqual=628,
   ImGuiKey_AppBack=629,
   ImGuiKey_AppForward=630,
   ImGuiKey_GamepadStart=631,
   ImGuiKey_GamepadBack=632,
   ImGuiKey_GamepadFaceLeft=633,
   ImGuiKey_GamepadFaceRight=634,
   ImGuiKey_GamepadFaceUp=635,
   ImGuiKey_GamepadFaceDown=636,
   ImGuiKey_GamepadDpadLeft=637,
   ImGuiKey_GamepadDpadRight=638,
   ImGuiKey_GamepadDpadUp=639,
   ImGuiKey_GamepadDpadDown=640,
   ImGuiKey_GamepadL1=641,
   ImGuiKey_GamepadR1=642,
   ImGuiKey_GamepadL2=643,
   ImGuiKey_GamepadR2=644,
   ImGuiKey_GamepadL3=645,
   ImGuiKey_GamepadR3=646,
   ImGuiKey_GamepadLStickLeft=647,
   ImGuiKey_GamepadLStickRight=648,
   ImGuiKey_GamepadLStickUp=649,
   ImGuiKey_GamepadLStickDown=650,
   ImGuiKey_GamepadRStickLeft=651,
   ImGuiKey_GamepadRStickRight=652,
   ImGuiKey_GamepadRStickUp=653,
   ImGuiKey_GamepadRStickDown=654,
   ImGuiKey_MouseLeft=655,
   ImGuiKey_MouseRight=656,
   ImGuiKey_MouseMiddle=657,
   ImGuiKey_MouseX1=658,
   ImGuiKey_MouseX2=659,
   ImGuiKey_MouseWheelX=660,
   ImGuiKey_MouseWheelY=661,
   ImGuiKey_ReservedForModCtrl=662,
   ImGuiKey_ReservedForModShift=663,
   ImGuiKey_ReservedForModAlt=664,
   ImGuiKey_ReservedForModSuper=665,
   ImGuiKey_COUNT=666,
   ImGuiMod_None=0,
   ImGuiMod_Ctrl=1 << 12,
   ImGuiMod_Shift=1 << 13,
   ImGuiMod_Alt=1 << 14,
   ImGuiMod_Super=1 << 15,
   ImGuiMod_Mask_=0xF000,
   ImGuiKey_NamedKey_BEGIN=512,
   ImGuiKey_NamedKey_END=ImGuiKey_COUNT,
   ImGuiKey_NamedKey_COUNT=ImGuiKey_NamedKey_END - ImGuiKey_NamedKey_BEGIN,
   ImGuiKey_KeysData_SIZE=ImGuiKey_NamedKey_COUNT,
   ImGuiKey_KeysData_OFFSET=ImGuiKey_NamedKey_BEGIN,
}ImGuiKey;

typedef struct ImGuiInputTextCallbackData
{
   void* Ctx;
   ImGuiInputTextFlags EventFlag;
   ImGuiInputTextFlags Flags;
   void* UserData;
   ImWchar EventChar;
   ImGuiKey EventKey;
   char* Buf;
   int BufTextLen;
   int BufSize;
   bool BufDirty;
   int CursorPos;
   int SelectionStart;
   int SelectionEnd;
} ImGuiInputTextCallbackData;

typedef struct ImFontGlyph
{
    unsigned int Colored : 1;
    unsigned int Visible : 1;
    unsigned int Codepoint : 30;
    float AdvanceX;
    float X0, Y0, X1, Y1;
    float U0, V0, U1, V1;
} ImFontGlyph;
typedef struct ImVector_ImU32 {int Size;int Capacity;ImU32* Data;} ImVector_ImU32;

struct ImFontGlyphRangesBuilder
{
    ImVector_ImU32 UsedChars;
};

typedef enum {
    ImFontAtlasFlags_None = 0,
    ImFontAtlasFlags_NoPowerOfTwoHeight = 1 << 0,
    ImFontAtlasFlags_NoMouseCursors = 1 << 1,
    ImFontAtlasFlags_NoBakedLines = 1 << 2,
}ImFontAtlasFlags_;

typedef struct ImVector_float {int Size;int Capacity;float* Data;} ImVector_float;

typedef struct ImVector_ImFontGlyph {int Size;int Capacity;ImFontGlyph* Data;} ImVector_ImFontGlyph;

struct ImFontAtlas;

typedef struct ImFont
{
    ImVector_float IndexAdvanceX;
    float FallbackAdvanceX;
    float FontSize;
    ImVector_ImWchar IndexLookup;
    ImVector_ImFontGlyph Glyphs;
    const ImFontGlyph* FallbackGlyph;
    void* ContainerAtlas;
    const void* ConfigData;
    short ConfigDataCount;
    ImWchar FallbackChar;
    ImWchar EllipsisChar;
    short EllipsisCharCount;
    float EllipsisWidth;
    float EllipsisCharStep;
    bool DirtyLookupTables;
    float Scale;
    float Ascent, Descent;
    int MetricsTotalSurface;
    ImU8 Used4kPagesMap[(0xFFFF +1)/4096/8];
} ImFont;

typedef struct ImVector_ImFontPtr {int Size;int Capacity;ImFont** Data;} ImVector_ImFontPtr;

typedef struct ImFontAtlasCustomRect
{
    unsigned short Width, Height;
    unsigned short X, Y;
    unsigned int GlyphID;
    float GlyphAdvanceX;
    ImVec2 GlyphOffset;
    ImFont* Font;
}ImFontAtlasCustomRect;

typedef struct ImFontConfig
{
    void* FontData;
    int FontDataSize;
    bool FontDataOwnedByAtlas;
    int FontNo;
    float SizePixels;
    int OversampleH;
    int OversampleV;
    bool PixelSnapH;
    ImVec2 GlyphExtraSpacing;
    ImVec2 GlyphOffset;
    const ImWchar* GlyphRanges;
    float GlyphMinAdvanceX;
    float GlyphMaxAdvanceX;
    bool MergeMode;
    unsigned int FontBuilderFlags;
    float RasterizerMultiply;
    float RasterizerDensity;
    ImWchar EllipsisChar;
    char Name[40];
    ImFont* DstFont;
} ImFontConfig;

typedef struct ImVector_ImFontAtlasCustomRect {int Size;int Capacity;ImFontAtlasCustomRect* Data;} ImVector_ImFontAtlasCustomRect;

typedef struct ImVector_ImFontConfig {int Size;int Capacity;ImFontConfig* Data;} ImVector_ImFontConfig;

typedef struct ImFontAtlas
{
    ImFontAtlasFlags Flags;
    ImTextureID TexID;
    int TexDesiredWidth;
    int TexGlyphPadding;
    bool Locked;
    void* UserData;
    bool TexReady;
    bool TexPixelsUseColors;
    unsigned char* TexPixelsAlpha8;
    unsigned int* TexPixelsRGBA32;
    int TexWidth;
    int TexHeight;
    ImVec2 TexUvScale;
    ImVec2 TexUvWhitePixel;
    ImVector_ImFontPtr Fonts;
    ImVector_ImFontAtlasCustomRect CustomRects;
    ImVector_ImFontConfig ConfigData;
    ImVec4 TexUvLines[(63) + 1];
    const void* FontBuilderIO;
    unsigned int FontBuilderFlags;
    int PackIdMouseCursors;
    int PackIdLines;
} ImFontAtlas;


typedef struct ImGuiIO
{
    ImGuiConfigFlags ConfigFlags;
    ImGuiBackendFlags BackendFlags;
    ImVec2 DisplaySize;
    float DeltaTime;
    float IniSavingRate;
    const char* IniFilename;
    const char* LogFilename;
    void* UserData;
    ImFontAtlas*Fonts;
    float FontGlobalScale;
    bool FontAllowUserScaling;
    ImFont* FontDefault;
    ImVec2 DisplayFramebufferScale;
    bool MouseDrawCursor;
    bool ConfigMacOSXBehaviors;
    bool ConfigNavSwapGamepadButtons;
    bool ConfigInputTrickleEventQueue;
    bool ConfigInputTextCursorBlink;
    bool ConfigInputTextEnterKeepActive;
    bool ConfigDragClickToInputText;
    bool ConfigWindowsResizeFromEdges;
    bool ConfigWindowsMoveFromTitleBarOnly;
    float ConfigMemoryCompactTimer;
    float MouseDoubleClickTime;
    float MouseDoubleClickMaxDist;
    float MouseDragThreshold;
    float KeyRepeatDelay;
    float KeyRepeatRate;
    bool ConfigDebugIsDebuggerPresent;
    bool ConfigDebugBeginReturnValueOnce;
    bool ConfigDebugBeginReturnValueLoop;
    bool ConfigDebugIgnoreFocusLoss;
    bool ConfigDebugIniSettings;
    const char* BackendPlatformName;
    const char* BackendRendererName;
    void* BackendPlatformUserData;
    void* BackendRendererUserData;
    void* BackendLanguageUserData;
    bool WantCaptureMouse;
    bool WantCaptureKeyboard;
    bool WantTextInput;
    bool WantSetMousePos;
    bool WantSaveIniSettings;
    bool NavActive;
    bool NavVisible;
    float Framerate;
    int MetricsRenderVertices;
    int MetricsRenderIndices;
    int MetricsRenderWindows;
    int MetricsActiveWindows;
    ImVec2 MouseDelta;
    void* Ctx;
    ImVec2 MousePos;
    bool MouseDown[5];
    float MouseWheel;
    float MouseWheelH;
    ImGuiMouseSource MouseSource;
    bool KeyCtrl;
    bool KeyShift;
    bool KeyAlt;
    bool KeySuper;
    ImGuiKeyChord KeyMods;
    ImGuiKeyData KeysData[ImGuiKey_KeysData_SIZE];
    bool WantCaptureMouseUnlessPopupClose;
    ImVec2 MousePosPrev;
    ImVec2 MouseClickedPos[5];
    double MouseClickedTime[5];
    bool MouseClicked[5];
    bool MouseDoubleClicked[5];
    ImU16 MouseClickedCount[5];
    ImU16 MouseClickedLastCount[5];
    bool MouseReleased[5];
    bool MouseDownOwned[5];
    bool MouseDownOwnedUnlessPopupClose[5];
    bool MouseWheelRequestAxisSwap;
    bool MouseCtrlLeftAsRightClick;
    float MouseDownDuration[5];
    float MouseDownDurationPrev[5];
    float MouseDragMaxDistanceSqr[5];
    float PenPressure;
    bool AppFocusLost;
    bool AppAcceptingEvents;
    ImS8 BackendUsingLegacyKeyArrays;
    bool BackendUsingLegacyNavInputArray;
    ImWchar16 InputQueueSurrogate;
    ImVector_ImWchar InputQueueCharacters;
} ImGuiIO;

typedef int (*ImGuiInputTextCallback)(ImGuiInputTextCallbackData* data);

void igTextUnformatted(const char* text,const char* text_end);
void igText(const char* fmt,...);
void igTextV(const char* fmt,va_list args);
void igTextColored(const ImVec4 col,const char* fmt,...);
void igTextColoredV(const ImVec4 col,const char* fmt,va_list args);
void igTextDisabled(const char* fmt,...);
void igTextDisabledV(const char* fmt,va_list args);
void igTextWrapped(const char* fmt,...);
void igTextWrappedV(const char* fmt,va_list args);
void igLabelText(const char* label,const char* fmt,...);
void igLabelTextV(const char* label,const char* fmt,va_list args);
void igBulletText(const char* fmt,...);
void igBulletTextV(const char* fmt,va_list args);
void igSeparatorText(const char* label);
bool igButton(const char* label,const ImVec2 size);
bool igSmallButton(const char* label);
bool igInvisibleButton(const char* str_id,const ImVec2 size,ImGuiButtonFlags flags);
bool igArrowButton(const char* str_id,ImGuiDir dir);
bool igCheckbox(const char* label,bool* v);
bool igCheckboxFlags_IntPtr(const char* label,int* flags,int flags_value);
bool igCheckboxFlags_UintPtr(const char* label,unsigned int* flags,unsigned int flags_value);
bool igRadioButton_Bool(const char* label,bool active);
bool igRadioButton_IntPtr(const char* label,int* v,int v_button);
void igProgressBar(float fraction,const ImVec2 size_arg,const char* overlay);
void igBullet(void);
bool igTextLink(const char* label);
void igTextLinkOpenURL(const char* label,const char* url);
void igImage(ImTextureID user_texture_id,const ImVec2 image_size,const ImVec2 uv0,const ImVec2 uv1,const ImVec4 tint_col,const ImVec4 border_col);
bool igImageButton(const char* str_id,ImTextureID user_texture_id,const ImVec2 image_size,const ImVec2 uv0,const ImVec2 uv1,const ImVec4 bg_col,const ImVec4 tint_col);
bool igBeginCombo(const char* label,const char* preview_value,ImGuiComboFlags flags);
void igEndCombo(void);
bool igCombo_Str_arr(const char* label,int* current_item,const char* const items[],int items_count,int popup_max_height_in_items);
bool igCombo_Str(const char* label,int* current_item,const char* items_separated_by_zeros,int popup_max_height_in_items);
bool igCombo_FnStrPtr(const char* label,int* current_item,const char*(*getter)(void* user_data,int idx),void* user_data,int items_count,int popup_max_height_in_items);
bool igDragFloat(const char* label,float* v,float v_speed,float v_min,float v_max,const char* format,ImGuiSliderFlags flags);
bool igDragFloat2(const char* label,float v[2],float v_speed,float v_min,float v_max,const char* format,ImGuiSliderFlags flags);
bool igDragFloat3(const char* label,float v[3],float v_speed,float v_min,float v_max,const char* format,ImGuiSliderFlags flags);
bool igDragFloat4(const char* label,float v[4],float v_speed,float v_min,float v_max,const char* format,ImGuiSliderFlags flags);
bool igDragFloatRange2(const char* label,float* v_current_min,float* v_current_max,float v_speed,float v_min,float v_max,const char* format,const char* format_max,ImGuiSliderFlags flags);
bool igDragInt(const char* label,int* v,float v_speed,int v_min,int v_max,const char* format,ImGuiSliderFlags flags);
bool igDragInt2(const char* label,int v[2],float v_speed,int v_min,int v_max,const char* format,ImGuiSliderFlags flags);
bool igDragInt3(const char* label,int v[3],float v_speed,int v_min,int v_max,const char* format,ImGuiSliderFlags flags);
bool igDragInt4(const char* label,int v[4],float v_speed,int v_min,int v_max,const char* format,ImGuiSliderFlags flags);
bool igDragIntRange2(const char* label,int* v_current_min,int* v_current_max,float v_speed,int v_min,int v_max,const char* format,const char* format_max,ImGuiSliderFlags flags);
bool igDragScalar(const char* label,ImGuiDataType data_type,void* p_data,float v_speed,const void* p_min,const void* p_max,const char* format,ImGuiSliderFlags flags);
bool igDragScalarN(const char* label,ImGuiDataType data_type,void* p_data,int components,float v_speed,const void* p_min,const void* p_max,const char* format,ImGuiSliderFlags flags);
bool igSliderFloat(const char* label,float* v,float v_min,float v_max,const char* format,ImGuiSliderFlags flags);
bool igSliderFloat2(const char* label,float v[2],float v_min,float v_max,const char* format,ImGuiSliderFlags flags);
bool igSliderFloat3(const char* label,float v[3],float v_min,float v_max,const char* format,ImGuiSliderFlags flags);
bool igSliderFloat4(const char* label,float v[4],float v_min,float v_max,const char* format,ImGuiSliderFlags flags);
bool igSliderAngle(const char* label,float* v_rad,float v_degrees_min,float v_degrees_max,const char* format,ImGuiSliderFlags flags);
bool igSliderInt(const char* label,int* v,int v_min,int v_max,const char* format,ImGuiSliderFlags flags);
bool igSliderInt2(const char* label,int v[2],int v_min,int v_max,const char* format,ImGuiSliderFlags flags);
bool igSliderInt3(const char* label,int v[3],int v_min,int v_max,const char* format,ImGuiSliderFlags flags);
bool igSliderInt4(const char* label,int v[4],int v_min,int v_max,const char* format,ImGuiSliderFlags flags);

bool igInputText(const char* label,char* buf,size_t buf_size,ImGuiInputTextFlags flags,ImGuiInputTextCallback callback,void* user_data);
bool igInputTextMultiline(const char* label,char* buf,size_t buf_size,const ImVec2 size,ImGuiInputTextFlags flags,ImGuiInputTextCallback callback,void* user_data);
bool igInputTextWithHint(const char* label,const char* hint,char* buf,size_t buf_size,ImGuiInputTextFlags flags,ImGuiInputTextCallback callback,void* user_data);
bool igInputFloat(const char* label,float* v,float step,float step_fast,const char* format,ImGuiInputTextFlags flags);
bool igInputFloat2(const char* label,float v[2],const char* format,ImGuiInputTextFlags flags);
bool igInputFloat3(const char* label,float v[3],const char* format,ImGuiInputTextFlags flags);
bool igInputFloat4(const char* label,float v[4],const char* format,ImGuiInputTextFlags flags);
bool igInputInt(const char* label,int* v,int step,int step_fast,ImGuiInputTextFlags flags);
bool igInputInt2(const char* label,int v[2],ImGuiInputTextFlags flags);
bool igInputInt3(const char* label,int v[3],ImGuiInputTextFlags flags);
bool igInputInt4(const char* label,int v[4],ImGuiInputTextFlags flags);
bool igInputDouble(const char* label,double* v,double step,double step_fast,const char* format,ImGuiInputTextFlags flags);
bool igInputScalar(const char* label,ImGuiDataType data_type,void* p_data,const void* p_step,const void* p_step_fast,const char* format,ImGuiInputTextFlags flags);
bool igInputScalarN(const char* label,ImGuiDataType data_type,void* p_data,int components,const void* p_step,const void* p_step_fast,const char* format,ImGuiInputTextFlags flags);
bool igColorEdit3(const char* label,float col[3],ImGuiColorEditFlags flags);
bool igColorEdit4(const char* label,float col[4],ImGuiColorEditFlags flags);
bool igColorPicker3(const char* label,float col[3],ImGuiColorEditFlags flags);
bool igColorPicker4(const char* label,float col[4],ImGuiColorEditFlags flags,const float* ref_col);
bool igColorButton(const char* desc_id,const ImVec4 col,ImGuiColorEditFlags flags,const ImVec2 size);
void igSetColorEditOptions(ImGuiColorEditFlags flags);

void igSetNextWindowPos(const ImVec2 pos,ImGuiCond cond,const ImVec2 pivot);
void igSetNextWindowSize(const ImVec2 size,ImGuiCond cond);

bool igBegin(const char* name,bool* p_open,ImGuiWindowFlags flags);
void igEnd(void);

void igShowDemoWindow(bool* p_open);

ImGuiIO* igGetIO(void);

/********** sokol_imgui ****************************************************************/

/*
    simgui_image_t

    A combined image-sampler pair used to inject custom images and samplers into Dear ImGui.

    Create with simgui_make_image(), and convert to an ImTextureID handle via
    simgui_imtextureid().
*/
typedef struct simgui_image_t { uint32_t id; } simgui_image_t;

/*
    simgui_image_desc_t

    Descriptor struct for simgui_make_image(). You must provide
    at least an sg_image handle. Keeping the sg_sampler handle
    zero-initialized will select the builtin default sampler
    which uses linear filtering.
*/
typedef struct simgui_image_desc_t {
    sg_image image;
    sg_sampler sampler;
} simgui_image_desc_t;

/*
    simgui_allocator_t

    Used in simgui_desc_t to provide custom memory-alloc and -free functions
    to sokol_imgui.h. If memory management should be overridden, both the
    alloc_fn and free_fn function must be provided (e.g. it's not valid to
    override one function but not the other).
*/
typedef struct simgui_allocator_t {
    void* (*alloc_fn)(size_t size, void* user_data);
    void (*free_fn)(void* ptr, void* user_data);
    void* user_data;
} simgui_allocator_t;

/*
    simgui_logger

    Used in simgui_desc_t to provide a logging function. Please be aware
    that without logging function, sokol-imgui will be completely
    silent, e.g. it will not report errors, warnings and
    validation layer messages. For maximum error verbosity,
    compile in debug mode (e.g. NDEBUG *not* defined) and install
    a logger (for instance the standard logging function from sokol_log.h).
*/
typedef struct simgui_logger_t {
    void (*func)(
        const char* tag,                // always "simgui"
        uint32_t log_level,             // 0=panic, 1=error, 2=warning, 3=info
        uint32_t log_item_id,           // SIMGUI_LOGITEM_*
        const char* message_or_null,    // a message string, may be nullptr in release mode
        uint32_t line_nr,               // line number in sokol_imgui.h
        const char* filename_or_null,   // source filename, may be nullptr in release mode
        void* user_data);
    void* user_data;
} simgui_logger_t;

typedef struct simgui_desc_t {
    int max_vertices;               // default: 65536
    int image_pool_size;            // default: 256
    sg_pixel_format color_format;
    sg_pixel_format depth_format;
    int sample_count;
    const char* ini_filename;
    bool no_default_font;
    bool disable_paste_override;    // if true, don't send Ctrl-V on EVENTTYPE_CLIPBOARD_PASTED
    bool disable_set_mouse_cursor;  // if true, don't control the mouse cursor type via sapp_set_mouse_cursor()
    bool disable_windows_resize_from_edges; // if true, only resize edges from the bottom right corner
    bool write_alpha_channel;       // if true, alpha values get written into the framebuffer
    simgui_allocator_t allocator;   // optional memory allocation overrides (default: malloc/free)
    simgui_logger_t logger;         // optional log function override
} simgui_desc_t;

typedef struct simgui_frame_desc_t {
    int width;
    int height;
    double delta_time;
    float dpi_scale;
} simgui_frame_desc_t;

typedef struct simgui_font_tex_desc_t {
    sg_filter min_filter;
    sg_filter mag_filter;
} simgui_font_tex_desc_t;

void simgui_setup(const simgui_desc_t* desc);
void simgui_new_frame(const simgui_frame_desc_t* desc);
void simgui_render(void);
simgui_image_t simgui_make_image(const simgui_image_desc_t* desc);
void simgui_destroy_image(simgui_image_t img);
simgui_image_desc_t simgui_query_image_desc(simgui_image_t img);
void* simgui_imtextureid(simgui_image_t img);
simgui_image_t simgui_image_from_imtextureid(void* im_texture_id);
void simgui_add_focus_event(bool focus);
void simgui_add_mouse_pos_event(float x, float y);
void simgui_add_touch_pos_event(float x, float y);
void simgui_add_mouse_button_event(int mouse_button, bool down);
void simgui_add_mouse_wheel_event(float wheel_x, float wheel_y);
void simgui_add_key_event(int imgui_key, bool down);
void simgui_add_input_character(uint32_t c);
void simgui_add_input_characters_utf8(const char* c);
void simgui_add_touch_button_event(int mouse_button, bool down);

bool simgui_handle_event(const sapp_event* ev);
int simgui_map_keycode(sapp_keycode keycode);  // returns ImGuiKey_*

void simgui_shutdown(void);
void simgui_create_fonts_texture(const simgui_font_tex_desc_t* desc);
void simgui_destroy_fonts_texture(void);

]]

return sokol_imgui