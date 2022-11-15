# distutils: language = c++
# distutils: sources = imgui-cpp/imgui.cpp imgui-cpp/imgui_draw.cpp imgui-cpp/imgui_demo.cpp imgui-cpp/imgui_widgets.cpp imgui-cpp/imgui_tables.cpp config-cpp/py_imconfig.cpp
# distutils: include_dirs = imgui-cpp ansifeed-cpp
# cython: embedsignature=True

import cython

cimport cimgui
cimport internal
cimport enums_internal

from cpython.version cimport PY_MAJOR_VERSION

include "imgui/common.pyx"

cdef UpdateImGuiContext(cimgui.ImGuiContext* _ptr):
    cimgui.SetCurrentContext(_ptr)

# === Enums ===

# Item Flags
ITEM_NONE = enums_internal.ImGuiItemFlags_None                     
ITEM_NO_TAB_STOP = enums_internal.ImGuiItemFlags_NoTabStop                
ITEM_BUTTON_REPEAT = enums_internal.ImGuiItemFlags_ButtonRepeat             
ITEM_DISABLED = enums_internal.ImGuiItemFlags_Disabled                 
ITEM_NO_NAV = enums_internal.ImGuiItemFlags_NoNav                    
ITEM_NO_NAV_DEFAULT_FOCUS = enums_internal.ImGuiItemFlags_NoNavDefaultFocus        
ITEM_SELECTABLE_DONT_CLOSE_POPUP = enums_internal.ImGuiItemFlags_SelectableDontClosePopup 
ITEM_MIXED_VALUE = enums_internal.ImGuiItemFlags_MixedValue               
ITEM_READ_ONLY = enums_internal.ImGuiItemFlags_ReadOnly                 
ITEM_DEFAULT = enums_internal.ImGuiItemFlags_Default_                 

# Item Status Flags
ITEM_STATUS_NONE = enums_internal.ImGuiItemStatusFlags_None
ITEM_STATUS_HOVERED_RECT = enums_internal.ImGuiItemStatusFlags_HoveredRect
ITEM_STATUS_HAS_DISPLAY_RECT = enums_internal.ImGuiItemStatusFlags_HasDisplayRect
ITEM_STATUS_EDITED = enums_internal.ImGuiItemStatusFlags_Edited
ITEM_STATUS_TOGGLED_SELECTION = enums_internal.ImGuiItemStatusFlags_ToggledSelection
ITEM_STATUS_TOGGLED_OPEN = enums_internal.ImGuiItemStatusFlags_ToggledOpen
ITEM_STATUS_HAS_DEACTIVATED = enums_internal.ImGuiItemStatusFlags_HasDeactivated
ITEM_STATUS_DEACTIVATED = enums_internal.ImGuiItemStatusFlags_Deactivated

# Button Flags Private
BUTTON_PRESSED_ON_CLICK = enums_internal.ImGuiButtonFlags_PressedOnClick
BUTTON_PRESSED_ON_CLICK_RELEASE = enums_internal.ImGuiButtonFlags_PressedOnClickRelease
BUTTON_PRESSED_ON_CLICK_RELEASE_ANYWHERE = enums_internal.ImGuiButtonFlags_PressedOnClickReleaseAnywhere
BUTTON_PRESSED_ON_RELEASE = enums_internal.ImGuiButtonFlags_PressedOnRelease
BUTTON_PRESSED_ON_DOUBLE_CLICK = enums_internal.ImGuiButtonFlags_PressedOnDoubleClick
BUTTON_PRESSED_ON_DRAG_DROP_HOLD = enums_internal.ImGuiButtonFlags_PressedOnDragDropHold
BUTTON_REPEAT = enums_internal.ImGuiButtonFlags_Repeat
BUTTON_FLATTEN_CHILDREN = enums_internal.ImGuiButtonFlags_FlattenChildren
BUTTON_ALLOW_ITEM_OVERLAP = enums_internal.ImGuiButtonFlags_AllowItemOverlap
BUTTON_DONT_CLOSE_POPUPS = enums_internal.ImGuiButtonFlags_DontClosePopups
BUTTON_DISABLED = enums_internal.ImGuiButtonFlags_Disabled
BUTTON_ALIGN_TEXT_BASE_LINE = enums_internal.ImGuiButtonFlags_AlignTextBaseLine
BUTTON_NO_KEY_MODIFIERS = enums_internal.ImGuiButtonFlags_NoKeyModifiers
BUTTON_NO_HOLDING_ACTIVE_ID = enums_internal.ImGuiButtonFlags_NoHoldingActiveId
BUTTON_NO_NAV_FOCUS = enums_internal.ImGuiButtonFlags_NoNavFocus
BUTTON_NO_HOVERED_ON_FOCUS = enums_internal.ImGuiButtonFlags_NoHoveredOnFocus
BUTTON_PRESSED_ON_MASK = enums_internal.ImGuiButtonFlags_PressedOnMask_
BUTTON_PRESSED_ON_DEFAULT = enums_internal.ImGuiButtonFlags_PressedOnDefault_
    
# Slider Flags Private
SLIDER_VERTICAL = enums_internal.ImGuiSliderFlags_Vertical
SLIDER_READ_ONLY = enums_internal.ImGuiSliderFlags_ReadOnly
        
# Selectable Flags Private
SELECTABLE_NO_HOLDING_ACTIVE_ID = enums_internal.ImGuiSelectableFlags_NoHoldingActiveID
SELECTABLE_SELECT_ON_CLICK = enums_internal.ImGuiSelectableFlags_SelectOnClick
SELECTABLE_SELECT_ON_RELEASE = enums_internal.ImGuiSelectableFlags_SelectOnRelease
SELECTABLE_SPAN_AVAILABLE_WIDTH = enums_internal.ImGuiSelectableFlags_SpanAvailWidth
SELECTABLE_DRAW_HOVERED_WHEN_HELD = enums_internal.ImGuiSelectableFlags_DrawHoveredWhenHeld
SELECTABLE_SET_NAV_ID_ON_HOVER = enums_internal.ImGuiSelectableFlags_SetNavIdOnHover
SELECTABLE_NO_PAD_WIDHT_HALF_SPACING = enums_internal.ImGuiSelectableFlags_NoPadWithHalfSpacing

# Tree Node Flags Private
TREE_NODE_CLIP_LABEL_FOR_TRAILING_BUTTON = enums_internal.ImGuiTreeNodeFlags_ClipLabelForTrailingButton
    
# Separator Flags
SEPARATOR_NONE = enums_internal.ImGuiSeparatorFlags_None
SEPARATOR_HORIZONTAL = enums_internal.ImGuiSeparatorFlags_Horizontal
SEPARATOR_VERTICAL = enums_internal.ImGuiSeparatorFlags_Vertical
SEPARATOR_SPAN_ALL_COLUMNS = enums_internal.ImGuiSeparatorFlags_SpanAllColumns

# Text Flags
TEXT_NONE = enums_internal.ImGuiTextFlags_None
TEXT_NO_WIDTH_FRO_LARGE_CLIPPED_TEXT = enums_internal.ImGuiTextFlags_NoWidthForLargeClippedText

# Tooltip Flags
TOOLTIP_NONE = enums_internal.ImGuiTooltipFlags_None
TOOLTIP_OVERRIDE_PREVIOUS_TOOLTIP = enums_internal.ImGuiTooltipFlags_OverridePreviousTooltip

# Layout Type
LAYOUT_TYPE_HORIZONTAL = enums_internal.ImGuiLayoutType_Horizontal
LAYOUT_TYPE_VERTICAL = enums_internal.ImGuiLayoutType_Vertical

# Log Type
LOG_TYPE_NONE = enums_internal.ImGuiLogType_None
LOG_TYPE_LOG_TYPE_TTY = enums_internal.ImGuiLogType_TTY
LOG_TYPE_LOG_TYPE_FILE = enums_internal.ImGuiLogType_File
LOG_TYPE_LOG_TYPE_BUFFER = enums_internal.ImGuiLogType_Buffer
LOG_TYPE_LOG_TYPE_CLIPBOARD = enums_internal.ImGuiLogType_Clipboard

# Axis
AXIS_NONE = enums_internal.ImGuiAxis_None
AXIS_X = enums_internal.ImGuiAxis_X
AXIS_Y = enums_internal.ImGuiAxis_Y

# Plot Type
PLOT_TYPE_LINES = enums_internal.ImGuiPlotType_Lines
PLOT_TYPE_HISTOGRAM = enums_internal.ImGuiPlotType_Histogram

# Input Source
INPUT_SOURCE_NONE = enums_internal.ImGuiInputSource_None
INPUT_SOURCE_MOUSE = enums_internal.ImGuiInputSource_Mouse
INPUT_SOURCE_KEYBOARD = enums_internal.ImGuiInputSource_Keyboard
INPUT_SOURCE_GAMEPAD = enums_internal.ImGuiInputSource_Gamepad
INPUT_SOURCE_NAV = enums_internal.ImGuiInputSource_Nav
INPUT_SOURCE_COUNT = enums_internal.ImGuiInputSource_COUNT

# Input Read Mode
INPUT_READ_MODE_DOWN = enums_internal.ImGuiInputReadMode_Down
INPUT_READ_MODE_PRESSED = enums_internal.ImGuiInputReadMode_Pressed
INPUT_READ_MODE_RELEASED = enums_internal.ImGuiInputReadMode_Released
INPUT_READ_MODE_REPEAT = enums_internal.ImGuiInputReadMode_Repeat
INPUT_READ_MODE_REPEAT_SLOW = enums_internal.ImGuiInputReadMode_RepeatSlow
INPUT_READ_MODE_REPEAT_FAST = enums_internal.ImGuiInputReadMode_RepeatFast

# Nav Highlight Flags
NAV_HIGHLIGHT_NONE = enums_internal.ImGuiNavHighlightFlags_None         
NAV_HIGHLIGHT_TYPE_DEFAULT = enums_internal.ImGuiNavHighlightFlags_TypeDefault  
NAV_HIGHLIGHT_TYPE_THIN = enums_internal.ImGuiNavHighlightFlags_TypeThin     
NAV_HIGHLIGHT_ALWAYS_DRAW = enums_internal.ImGuiNavHighlightFlags_AlwaysDraw
NAV_HIGHLIGHT_NO_ROUNDING = enums_internal.ImGuiNavHighlightFlags_NoRounding   

# Nav Dir Source Flags
NAV_DIR_SOURCE_NONE = enums_internal.ImGuiNavDirSourceFlags_None      
NAV_DIR_SOURCE_KEYBOARD = enums_internal.ImGuiNavDirSourceFlags_Keyboard  
NAV_DIR_SOURCE_PAD_D_PAD = enums_internal.ImGuiNavDirSourceFlags_PadDPad   
NAV_DIR_SOURCE_PAD_L_STICK = enums_internal.ImGuiNavDirSourceFlags_PadLStick 

# Nav Move Flags
NAV_MOVE_NONE = enums_internal.ImGuiNavMoveFlags_None
NAV_MOVE_LOOP_X = enums_internal.ImGuiNavMoveFlags_LoopX
NAV_MOVE_LOOP_Y = enums_internal.ImGuiNavMoveFlags_LoopY
NAV_MOVE_WRAP_X = enums_internal.ImGuiNavMoveFlags_WrapX
NAV_MOVE_WRAP_Y = enums_internal.ImGuiNavMoveFlags_WrapY
NAV_MOVE_ALLOW_CURRENT_NAV_ID = enums_internal.ImGuiNavMoveFlags_AllowCurrentNavId
NAV_MOVE_ALSO_SCORE_VISIBLE_SET = enums_internal.ImGuiNavMoveFlags_AlsoScoreVisibleSet
NAV_MOVE_SCROLL_TO_EDGE = enums_internal.ImGuiNavMoveFlags_ScrollToEdge

# Nav Forward
NAV_FORWARD_NONE = enums_internal.ImGuiNavForward_None
NAV_FORWARD_FORWARD_QUEUED = enums_internal.ImGuiNavForward_ForwardQueued
NAV_FORWARD_FORWARD_ACTIVE = enums_internal.ImGuiNavForward_ForwardActive

# Nav Layer
NAV_LAYER_MAIN = enums_internal.ImGuiNavLayer_Main
NAV_LAYER_MENU = enums_internal.ImGuiNavLayer_Menu
NAV_LAYER_COUNT = enums_internal.ImGuiNavLayer_COUNT

# Popup Position Policy
POPUP_POSITION_POLICY_DEFAULT = enums_internal.ImGuiPopupPositionPolicy_Default
POPUP_POSITION_POLICY_COMBO_BOX = enums_internal.ImGuiPopupPositionPolicy_ComboBox
POPUP_POSITION_POLICY_TOOLTIP = enums_internal.ImGuiPopupPositionPolicy_Tooltip

# Next Window Data Flags
NEXT_WINDOW_DATA_NONE = enums_internal.ImGuiNextWindowDataFlags_None               
NEXT_WINDOW_DATA_HAS_POS = enums_internal.ImGuiNextWindowDataFlags_HasPos             
NEXT_WINDOW_DATA_HAS_SIZE = enums_internal.ImGuiNextWindowDataFlags_HasSize            
NEXT_WINDOW_DATA_HAS_CONTENT_SIZE = enums_internal.ImGuiNextWindowDataFlags_HasContentSize     
NEXT_WINDOW_DATA_HAS_COLLAPSED = enums_internal.ImGuiNextWindowDataFlags_HasCollapsed       
NEXT_WINDOW_DATA_HAS_SIZE_CONSTRAINT = enums_internal.ImGuiNextWindowDataFlags_HasSizeConstraint  
NEXT_WINDOW_DATA_HAS_FOCUS = enums_internal.ImGuiNextWindowDataFlags_HasFocus           
NEXT_WINDOW_DATA_HAS_BACKGROUND_ALPHA = enums_internal.ImGuiNextWindowDataFlags_HasBgAlpha         
NEXT_WINDOW_DATA_HAS_SCROLL = enums_internal.ImGuiNextWindowDataFlags_HasScroll          

# Next Item Data Flags
NEXT_ITEM_DATA_NONE = enums_internal.ImGuiNextItemDataFlags_None     
NEXT_ITEM_DATA_HAS_WIDTH = enums_internal.ImGuiNextItemDataFlags_HasWidth 
NEXT_ITEM_DATA_HAS_OPEN = enums_internal.ImGuiNextItemDataFlags_HasOpen  

# Columns Flags
OLD_COLUMNS_NONE = enums_internal.ImGuiOldColumnFlags_None
OLD_COLUMNS_NO_BORDER = enums_internal.ImGuiOldColumnFlags_NoBorder
OLD_COLUMNS_NO_RESIZE = enums_internal.ImGuiOldColumnFlags_NoResize
OLD_COLUMNS_NO_PRESERVE_WIDTHS = enums_internal.ImGuiOldColumnFlags_NoPreserveWidths
OLD_COLUMNS_NO_FORCE_WIDTHIN_WINDOW = enums_internal.ImGuiOldColumnFlags_NoForceWithinWindow
OLD_COLUMNS_GROW_PARENT_CONTENTS_SIZE = enums_internal.ImGuiOldColumnFlags_GrowParentContentsSize

# Tab Bar Flags Private
TAB_BAR_DOCK_NODE = enums_internal.ImGuiTabBarFlags_DockNode
TAB_BAR_IS_FOCUSED = enums_internal.ImGuiTabBarFlags_IsFocused
TAB_BAR_SAVE_SETTINGS = enums_internal.ImGuiTabBarFlags_SaveSettings

# Tab Item Flags Private
TAB_ITEM_NO_CLOSE_BUTTON = enums_internal.ImGuiTabItemFlags_NoCloseButton
TAB_ITEM_BUTTON = enums_internal.ImGuiTabItemFlags_Button

# === API ===

def push_item_flag(internal.ImGuiItemFlags option, bool enabled):
    # TODO: document
    internal.PushItemFlag(option, enabled)
    
def pop_item_flag():
    internal.PopItemFlag()
