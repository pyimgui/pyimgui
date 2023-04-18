# distutils: language = c++
# distutils: sources = imgui-cpp/imgui.cpp imgui-cpp/imgui_draw.cpp imgui-cpp/imgui_demo.cpp imgui-cpp/imgui_widgets.cpp imgui-cpp/imgui_tables.cpp config-cpp/py_imconfig.cpp
# distutils: include_dirs = imgui-cpp ansifeed-cpp
# cython: embedsignature=True
"""

.. todo:: consider inlining every occurence of ``_cast_args_ImVecX`` (profile)
.. todo: verify mem safety of char* variables and check for leaks
"""

import cython
from cython.view cimport array as cvarray
from cython.operator cimport dereference as deref

from collections import namedtuple
import warnings
from contextlib import contextmanager
try:
    from itertools import izip_longest
except ImportError:
    from itertools import zip_longest as izip_longest

from libc.stdlib cimport malloc, realloc, free
from libc.stdint cimport uintptr_t
from libc.string cimport strdup
from libc.string cimport strncpy, strlen
from libc.float  cimport FLT_MIN
from libc.float  cimport FLT_MAX
from libcpp cimport bool

FLOAT_MIN = FLT_MIN
FLOAT_MAX = FLT_MAX

cimport cimgui
cimport core
cimport enums
cimport ansifeed
cimport internal

from cpython.version cimport PY_MAJOR_VERSION

# todo: find a way to cimport this directly from imgui.h
DEF TARGET_IMGUI_VERSION = (1, 79)

cdef unsigned int* _LATIN_ALL = [0x0020, 0x024F , 0]

# ==== Condition enum redefines ====
NONE = enums.ImGuiCond_None
ALWAYS = enums.ImGuiCond_Always
ONCE = enums.ImGuiCond_Once
FIRST_USE_EVER = enums.ImGuiCond_FirstUseEver
APPEARING = enums.ImGuiCond_Appearing

# ==== Style var enum redefines ====
STYLE_ALPHA = enums.ImGuiStyleVar_Alpha # float
STYLE_WINDOW_PADDING = enums.ImGuiStyleVar_WindowPadding  # Vec2
STYLE_WINDOW_ROUNDING = enums.ImGuiStyleVar_WindowRounding  # float
STYLE_WINDOW_BORDERSIZE = enums.ImGuiStyleVar_WindowBorderSize  # float
STYLE_WINDOW_MIN_SIZE = enums.ImGuiStyleVar_WindowMinSize  # Vec2
STYLE_WINDOW_TITLE_ALIGN = enums.ImGuiStyleVar_WindowTitleAlign  # Vec2
STYLE_CHILD_ROUNDING = enums.ImGuiStyleVar_ChildRounding  # float
STYLE_CHILD_BORDERSIZE = enums.ImGuiStyleVar_ChildBorderSize  # float
STYLE_POPUP_ROUNDING = enums.ImGuiStyleVar_PopupRounding  # float
STYLE_POPUP_BORDERSIZE = enums.ImGuiStyleVar_PopupBorderSize  # float
STYLE_FRAME_PADDING = enums.ImGuiStyleVar_FramePadding # Vec2
STYLE_FRAME_ROUNDING = enums.ImGuiStyleVar_FrameRounding # float
STYLE_FRAME_BORDERSIZE = enums.ImGuiStyleVar_FrameBorderSize  # float
STYLE_ITEM_SPACING = enums.ImGuiStyleVar_ItemSpacing # Vec2
STYLE_ITEM_INNER_SPACING = enums.ImGuiStyleVar_ItemInnerSpacing # Vec2
STYLE_INDENT_SPACING = enums.ImGuiStyleVar_IndentSpacing # float
STYLE_CELL_PADDING = enums.ImGuiStyleVar_CellPadding # ImVec2    CellPadding
STYLE_SCROLLBAR_SIZE = enums.ImGuiStyleVar_ScrollbarSize # float
STYLE_SCROLLBAR_ROUNDING = enums.ImGuiStyleVar_ScrollbarRounding # float
STYLE_GRAB_MIN_SIZE = enums.ImGuiStyleVar_GrabMinSize # float
STYLE_GRAB_ROUNDING = enums.ImGuiStyleVar_GrabRounding # float
STYLE_TAB_ROUNDING = enums.ImGuiStyleVar_TabRounding # flot
STYLE_BUTTON_TEXT_ALIGN = enums.ImGuiStyleVar_ButtonTextAlign # Vec2
STYLE_SELECTABLE_TEXT_ALIGN = enums.ImGuiStyleVar_SelectableTextAlign # Vec2

# ==== Button Flags ====
BUTTON_NONE = enums.ImGuiButtonFlags_None                   
BUTTON_MOUSE_BUTTON_LEFT = enums.ImGuiButtonFlags_MouseButtonLeft        
BUTTON_MOUSE_BUTTON_RIGHT = enums.ImGuiButtonFlags_MouseButtonRight       
BUTTON_MOUSE_BUTTON_MIDDLE = enums.ImGuiButtonFlags_MouseButtonMiddle      

# ==== Key map enum redefines ====
KEY_TAB = enums.ImGuiKey_Tab                 # for tabbing through fields
KEY_LEFT_ARROW = enums.ImGuiKey_LeftArrow    # for text edit
KEY_RIGHT_ARROW = enums.ImGuiKey_RightArrow  # for text edit
KEY_UP_ARROW = enums.ImGuiKey_UpArrow        # for text edit
KEY_DOWN_ARROW = enums.ImGuiKey_DownArrow    # for text edit
KEY_PAGE_UP = enums.ImGuiKey_PageUp
KEY_PAGE_DOWN = enums.ImGuiKey_PageDown
KEY_HOME = enums.ImGuiKey_Home               # for text edit
KEY_END = enums.ImGuiKey_End                 # for text edit
KEY_INSERT = enums.ImGuiKey_Insert           # for text edit
KEY_DELETE = enums.ImGuiKey_Delete           # for text edit
KEY_BACKSPACE = enums.ImGuiKey_Backspace     # for text edit
KEY_SPACE = enums.ImGuiKey_Space             # for text edit
KEY_ENTER = enums.ImGuiKey_Enter             # for text edit
KEY_ESCAPE = enums.ImGuiKey_Escape           # for text edit
KEY_PAD_ENTER = enums.ImGuiKey_KeyPadEnter
KEY_A = enums.ImGuiKey_A                     # for text edit CTRL+A: select all
KEY_C = enums.ImGuiKey_C                     # for text edit CTRL+C: copy
KEY_V = enums.ImGuiKey_V                     # for text edit CTRL+V: paste
KEY_X = enums.ImGuiKey_X                     # for text edit CTRL+X: cut
KEY_Y = enums.ImGuiKey_Y                     # for text edit CTRL+Y: redo
KEY_Z = enums.ImGuiKey_Z                     # for text edit CTRL+Z: undo

# ==== Key Mod Flags ====
KEY_MOD_NONE = enums.ImGuiKeyModFlags_None       
KEY_MOD_CTRL = enums.ImGuiKeyModFlags_Ctrl       
KEY_MOD_SHIFT = enums.ImGuiKeyModFlags_Shift      
KEY_MOD_ALT = enums.ImGuiKeyModFlags_Alt        
KEY_MOD_SUPER = enums.ImGuiKeyModFlags_Super     

# ==== Nav Input ====
NAV_INPUT_ACTIVATE = enums.ImGuiNavInput_Activate
NAV_INPUT_CANCEL = enums.ImGuiNavInput_Cancel
NAV_INPUT_INPUT = enums.ImGuiNavInput_Input
NAV_INPUT_MENU = enums.ImGuiNavInput_Menu
NAV_INPUT_DPAD_LEFT = enums.ImGuiNavInput_DpadLeft
NAV_INPUT_DPAD_RIGHT = enums.ImGuiNavInput_DpadRight
NAV_INPUT_DPAD_UP = enums.ImGuiNavInput_DpadUp
NAV_INPUT_DPAD_DOWN = enums.ImGuiNavInput_DpadDown
NAV_INPUT_L_STICK_LEFT = enums.ImGuiNavInput_LStickLeft
NAV_INPUT_L_STICK_RIGHT = enums.ImGuiNavInput_LStickRight
NAV_INPUT_L_STICK_UP = enums.ImGuiNavInput_LStickUp
NAV_INPUT_L_STICK_DOWN = enums.ImGuiNavInput_LStickDown
NAV_INPUT_FOCUS_PREV = enums.ImGuiNavInput_FocusPrev
NAV_INPUT_FOCUS_NEXT = enums.ImGuiNavInput_FocusNext
NAV_INPUT_TWEAK_SLOW = enums.ImGuiNavInput_TweakSlow
NAV_INPUT_TWEAK_FAST = enums.ImGuiNavInput_TweakFast
NAV_INPUT_COUNT = enums.ImGuiNavInput_COUNT

# ==== Window flags enum redefines ====
WINDOW_NONE = enums.ImGuiWindowFlags_None
WINDOW_NO_TITLE_BAR = enums.ImGuiWindowFlags_NoTitleBar
WINDOW_NO_RESIZE = enums.ImGuiWindowFlags_NoResize
WINDOW_NO_MOVE = enums.ImGuiWindowFlags_NoMove
WINDOW_NO_SCROLLBAR = enums.ImGuiWindowFlags_NoScrollbar
WINDOW_NO_SCROLL_WITH_MOUSE = enums.ImGuiWindowFlags_NoScrollWithMouse
WINDOW_NO_COLLAPSE = enums.ImGuiWindowFlags_NoCollapse
WINDOW_ALWAYS_AUTO_RESIZE = enums.ImGuiWindowFlags_AlwaysAutoResize
WINDOW_NO_BACKGROUND = enums.ImGuiWindowFlags_NoBackground 
WINDOW_NO_SAVED_SETTINGS = enums.ImGuiWindowFlags_NoSavedSettings
WINDOW_NO_MOUSE_INPUTS = enums.ImGuiWindowFlags_NoMouseInputs
WINDOW_MENU_BAR = enums.ImGuiWindowFlags_MenuBar
WINDOW_HORIZONTAL_SCROLLING_BAR = enums.ImGuiWindowFlags_HorizontalScrollbar
WINDOW_NO_FOCUS_ON_APPEARING = enums.ImGuiWindowFlags_NoFocusOnAppearing
WINDOW_NO_BRING_TO_FRONT_ON_FOCUS = enums.ImGuiWindowFlags_NoBringToFrontOnFocus
WINDOW_ALWAYS_VERTICAL_SCROLLBAR = enums.ImGuiWindowFlags_AlwaysVerticalScrollbar
WINDOW_ALWAYS_HORIZONTAL_SCROLLBAR = enums.ImGuiWindowFlags_AlwaysHorizontalScrollbar
WINDOW_ALWAYS_USE_WINDOW_PADDING = enums.ImGuiWindowFlags_AlwaysUseWindowPadding
WINDOW_NO_NAV_INPUTS = enums.ImGuiWindowFlags_NoNavInputs
WINDOW_NO_NAV_FOCUS = enums.ImGuiWindowFlags_NoNavFocus
WINDOW_UNSAVED_DOCUMENT = enums.ImGuiWindowFlags_UnsavedDocument
WINDOW_NO_NAV = enums.ImGuiWindowFlags_NoNav
WINDOW_NO_DECORATION = enums.ImGuiWindowFlags_NoDecoration
WINDOW_NO_INPUTS = enums.ImGuiWindowFlags_NoInputs

# ==== Color Edit Flags ====
COLOR_EDIT_NONE = enums.ImGuiColorEditFlags_None            
COLOR_EDIT_NO_ALPHA = enums.ImGuiColorEditFlags_NoAlpha         
COLOR_EDIT_NO_PICKER = enums.ImGuiColorEditFlags_NoPicker        
COLOR_EDIT_NO_OPTIONS = enums.ImGuiColorEditFlags_NoOptions       
COLOR_EDIT_NO_SMALL_PREVIEW = enums.ImGuiColorEditFlags_NoSmallPreview  
COLOR_EDIT_NO_INPUTS = enums.ImGuiColorEditFlags_NoInputs        
COLOR_EDIT_NO_TOOLTIP = enums.ImGuiColorEditFlags_NoTooltip       
COLOR_EDIT_NO_LABEL = enums.ImGuiColorEditFlags_NoLabel         
COLOR_EDIT_NO_SIDE_PREVIEW = enums.ImGuiColorEditFlags_NoSidePreview   
COLOR_EDIT_NO_DRAG_DROP = enums.ImGuiColorEditFlags_NoDragDrop      
COLOR_EDIT_NO_BORDER = enums.ImGuiColorEditFlags_NoBorder        

COLOR_EDIT_ALPHA_BAR = enums.ImGuiColorEditFlags_AlphaBar        
COLOR_EDIT_ALPHA_PREVIEW = enums.ImGuiColorEditFlags_AlphaPreview    
COLOR_EDIT_ALPHA_PREVIEW_HALF = enums.ImGuiColorEditFlags_AlphaPreviewHalf
COLOR_EDIT_HDR = enums.ImGuiColorEditFlags_HDR             
COLOR_EDIT_DISPLAY_RGB = enums.ImGuiColorEditFlags_DisplayRGB      
COLOR_EDIT_DISPLAY_HSV = enums.ImGuiColorEditFlags_DisplayHSV      
COLOR_EDIT_DISPLAY_HEX = enums.ImGuiColorEditFlags_DisplayHex      
COLOR_EDIT_UINT8 = enums.ImGuiColorEditFlags_Uint8           
COLOR_EDIT_FLOAT = enums.ImGuiColorEditFlags_Float           
COLOR_EDIT_PICKER_HUE_BAR = enums.ImGuiColorEditFlags_PickerHueBar    
COLOR_EDIT_PICKER_HUE_WHEEL = enums.ImGuiColorEditFlags_PickerHueWheel  
COLOR_EDIT_INPUT_RGB = enums.ImGuiColorEditFlags_InputRGB        
COLOR_EDIT_INPUT_HSV = enums.ImGuiColorEditFlags_InputHSV        

COLOR_EDIT_DEFAULT_OPTIONS = enums.ImGuiColorEditFlags__OptionsDefault

# ==== TreeNode flags enum redefines ====
TREE_NODE_NONE = enums.ImGuiTreeNodeFlags_None
TREE_NODE_SELECTED = enums.ImGuiTreeNodeFlags_Selected
TREE_NODE_FRAMED = enums.ImGuiTreeNodeFlags_Framed
TREE_NODE_ALLOW_ITEM_OVERLAP = enums.ImGuiTreeNodeFlags_AllowItemOverlap
TREE_NODE_NO_TREE_PUSH_ON_OPEN = enums.ImGuiTreeNodeFlags_NoTreePushOnOpen
TREE_NODE_NO_AUTO_OPEN_ON_LOG = enums.ImGuiTreeNodeFlags_NoAutoOpenOnLog
TREE_NODE_DEFAULT_OPEN = enums.ImGuiTreeNodeFlags_DefaultOpen
TREE_NODE_OPEN_ON_DOUBLE_CLICK = enums.ImGuiTreeNodeFlags_OpenOnDoubleClick
TREE_NODE_OPEN_ON_ARROW = enums.ImGuiTreeNodeFlags_OpenOnArrow
TREE_NODE_LEAF = enums.ImGuiTreeNodeFlags_Leaf
TREE_NODE_BULLET = enums.ImGuiTreeNodeFlags_Bullet
TREE_NODE_FRAME_PADDING = enums.ImGuiTreeNodeFlags_FramePadding
TREE_NODE_SPAN_AVAILABLE_WIDTH = enums.ImGuiTreeNodeFlags_SpanAvailWidth      
TREE_NODE_SPAN_FULL_WIDTH = enums.ImGuiTreeNodeFlags_SpanFullWidth       
TREE_NODE_NAV_LEFT_JUPS_BACK_HERE = enums.ImGuiTreeNodeFlags_NavLeftJumpsBackHere
TREE_NODE_COLLAPSING_HEADER = enums.ImGuiTreeNodeFlags_CollapsingHeader

# ==== Popup Flags ====
POPUP_NONE = enums.ImGuiPopupFlags_None                    
POPUP_MOUSE_BUTTON_LEFT = enums.ImGuiPopupFlags_MouseButtonLeft         
POPUP_MOUSE_BUTTON_RIGHT = enums.ImGuiPopupFlags_MouseButtonRight        
POPUP_MOUSE_BUTTON_MIDDLE = enums.ImGuiPopupFlags_MouseButtonMiddle       
POPUP_MOUSE_BUTTON_MASK = enums.ImGuiPopupFlags_MouseButtonMask_        
POPUP_MOUSE_BUTTON_DEFAULT = enums.ImGuiPopupFlags_MouseButtonDefault_     
POPUP_NO_OPEN_OVER_EXISTING_POPUP = enums.ImGuiPopupFlags_NoOpenOverExistingPopup 
POPUP_NO_OPEN_OVER_ITEMS = enums.ImGuiPopupFlags_NoOpenOverItems         
POPUP_ANY_POPUP_ID = enums.ImGuiPopupFlags_AnyPopupId              
POPUP_ANY_POPUP_LEVEL = enums.ImGuiPopupFlags_AnyPopupLevel           
POPUP_ANY_POPUP = enums.ImGuiPopupFlags_AnyPopup                

# ==== Selectable flags enum redefines ====
SELECTABLE_NONE = enums.ImGuiSelectableFlags_None
SELECTABLE_DONT_CLOSE_POPUPS = enums.ImGuiSelectableFlags_DontClosePopups
SELECTABLE_SPAN_ALL_COLUMNS = enums.ImGuiSelectableFlags_SpanAllColumns
SELECTABLE_ALLOW_DOUBLE_CLICK = enums.ImGuiSelectableFlags_AllowDoubleClick
SELECTABLE_DISABLED = enums.ImGuiSelectableFlags_Disabled           
SELECTABLE_ALLOW_ITEM_OVERLAP = enums.ImGuiSelectableFlags_AllowItemOverlap   

# ==== Combo flags enum redefines ====
COMBO_NONE = enums.ImGuiComboFlags_None
COMBO_POPUP_ALIGN_LEFT = enums.ImGuiComboFlags_PopupAlignLeft
COMBO_HEIGHT_SMALL = enums.ImGuiComboFlags_HeightSmall
COMBO_HEIGHT_REGULAR = enums.ImGuiComboFlags_HeightRegular
COMBO_HEIGHT_LARGE = enums.ImGuiComboFlags_HeightLarge
COMBO_HEIGHT_LARGEST = enums.ImGuiComboFlags_HeightLargest
COMBO_NO_ARROW_BUTTON = enums.ImGuiComboFlags_NoArrowButton
COMBO_NO_PREVIEW = enums.ImGuiComboFlags_NoPreview
COMBO_HEIGHT_MASK = enums.ImGuiComboFlags_HeightMask_

# ==== Tab Bar Flags ====
TAB_BAR_NONE = enums.ImGuiTabBarFlags_None                           
TAB_BAR_REORDERABLE = enums.ImGuiTabBarFlags_Reorderable                    
TAB_BAR_AUTO_SELECT_NEW_TABS = enums.ImGuiTabBarFlags_AutoSelectNewTabs              
TAB_BAR_TAB_LIST_POPUP_BUTTON = enums.ImGuiTabBarFlags_TabListPopupButton             
TAB_BAR_NO_CLOSE_WITH_MIDDLE_MOUSE_BUTTON = enums.ImGuiTabBarFlags_NoCloseWithMiddleMouseButton   
TAB_BAR_NO_TAB_LIST_SCROLLING_BUTTONS = enums.ImGuiTabBarFlags_NoTabListScrollingButtons      
TAB_BAR_NO_TOOLTIP = enums.ImGuiTabBarFlags_NoTooltip                      
TAB_BAR_FITTING_POLICY_RESIZE_DOWN = enums.ImGuiTabBarFlags_FittingPolicyResizeDown        
TAB_BAR_FITTING_POLICY_SCROLL = enums.ImGuiTabBarFlags_FittingPolicyScroll            
TAB_BAR_FITTING_POLICY_MASK = enums.ImGuiTabBarFlags_FittingPolicyMask_             
TAB_BAR_FITTING_POLICY_DEFAULT = enums.ImGuiTabBarFlags_FittingPolicyDefault_       

# ==== Tab Item Flags ====
TAB_ITEM_NONE = enums.ImGuiTabItemFlags_None                          
TAB_ITEM_UNSAVED_DOCUMENT = enums.ImGuiTabItemFlags_UnsavedDocument               
TAB_ITEM_SET_SELECTED = enums.ImGuiTabItemFlags_SetSelected                   
TAB_ITEM_NO_CLOSE_WITH_MIDDLE_MOUSE_BUTTON = enums.ImGuiTabItemFlags_NoCloseWithMiddleMouseButton  
TAB_ITEM_NO_PUSH_ID = enums.ImGuiTabItemFlags_NoPushId                      
TAB_ITEM_NO_TOOLTIP = enums.ImGuiTabItemFlags_NoTooltip                     
TAB_ITEM_NO_REORDER = enums.ImGuiTabItemFlags_NoReorder                     
TAB_ITEM_LEADING = enums.ImGuiTabItemFlags_Leading                       
TAB_ITEM_TRAILING = enums.ImGuiTabItemFlags_Trailing        

# === Table Flags ===
# Features
TABLE_NONE = enums.ImGuiTableFlags_None
TABLE_RESIZABLE = enums.ImGuiTableFlags_Resizable
TABLE_REORDERABLE = enums.ImGuiTableFlags_Reorderable
TABLE_HIDEABLE = enums.ImGuiTableFlags_Hideable
TABLE_SORTABLE = enums.ImGuiTableFlags_Sortable
TABLE_NO_SAVED_SETTINGS = enums.ImGuiTableFlags_NoSavedSettings
TABLE_CONTEXT_MENU_IN_BODY = enums.ImGuiTableFlags_ContextMenuInBody
# Decorations
TABLE_ROW_BACKGROUND = enums.ImGuiTableFlags_RowBg
TABLE_BORDERS_INNER_HORIZONTAL = enums.ImGuiTableFlags_BordersInnerH
TABLE_BORDERS_OUTER_HORIZONTAL = enums.ImGuiTableFlags_BordersOuterH
TABLE_BORDERS_INNER_VERTICAL = enums.ImGuiTableFlags_BordersInnerV
TABLE_BORDERS_OUTER_VERTICAL = enums.ImGuiTableFlags_BordersOuterV
TABLE_BORDERS_HORIZONTAL = enums.ImGuiTableFlags_BordersH
TABLE_BORDERS_VERTICAL = enums.ImGuiTableFlags_BordersV
TABLE_BORDERS_INNER = enums.ImGuiTableFlags_BordersInner
TABLE_BORDERS_OUTER = enums.ImGuiTableFlags_BordersOuter
TABLE_BORDERS = enums.ImGuiTableFlags_Borders
TABLE_NO_BORDERS_IN_BODY = enums.ImGuiTableFlags_NoBordersInBody
TABLE_NO_BORDERS_IN_BODY_UTIL_RESIZE = enums.ImGuiTableFlags_NoBordersInBodyUntilResize
# Sizing Policy (read above for defaults)
TABLE_SIZING_FIXED_FIT = enums.ImGuiTableFlags_SizingFixedFit
TABLE_SIZING_FIXED_SAME = enums.ImGuiTableFlags_SizingFixedSame
TABLE_SIZING_STRETCH_PROP = enums.ImGuiTableFlags_SizingStretchProp
TABLE_SIZING_STRETCH_SAME = enums.ImGuiTableFlags_SizingStretchSame
# Sizing Extra Options
TABLE_NO_HOST_EXTEND_X = enums.ImGuiTableFlags_NoHostExtendX
TABLE_NO_HOST_EXTEND_Y = enums.ImGuiTableFlags_NoHostExtendY
TABLE_NO_KEEP_COLUMNS_VISIBLE = enums.ImGuiTableFlags_NoKeepColumnsVisible
TABLE_PRECISE_WIDTHS = enums.ImGuiTableFlags_PreciseWidths
# Clipping
TABLE_NO_CLIP = enums.ImGuiTableFlags_NoClip
# Padding
TABLE_PAD_OUTER_X = enums.ImGuiTableFlags_PadOuterX
TABLE_NO_PAD_OUTER_X = enums.ImGuiTableFlags_NoPadOuterX
TABLE_NO_PAD_INNER_X = enums.ImGuiTableFlags_NoPadInnerX
# Scrolling
TABLE_SCROLL_X = enums.ImGuiTableFlags_ScrollX
TABLE_SCROLL_Y = enums.ImGuiTableFlags_ScrollY
# Sorting
TABLE_SORT_MULTI = enums.ImGuiTableFlags_SortMulti
TABLE_SORT_TRISTATE = enums.ImGuiTableFlags_SortTristate

# === Table Column Flags ===
# Input configuration flags
TABLE_COLUMN_NONE = enums.ImGuiTableColumnFlags_None
TABLE_COLUMN_DEFAULT_HIDE = enums.ImGuiTableColumnFlags_DefaultHide
TABLE_COLUMN_DEFAULT_SORT = enums.ImGuiTableColumnFlags_DefaultSort
TABLE_COLUMN_WIDTH_STRETCH = enums.ImGuiTableColumnFlags_WidthStretch
TABLE_COLUMN_WIDTH_FIXED = enums.ImGuiTableColumnFlags_WidthFixed
TABLE_COLUMN_NO_RESIZE = enums.ImGuiTableColumnFlags_NoResize
TABLE_COLUMN_NO_REORDER = enums.ImGuiTableColumnFlags_NoReorder
TABLE_COLUMN_NO_HIDE = enums.ImGuiTableColumnFlags_NoHide
TABLE_COLUMN_NO_CLIP = enums.ImGuiTableColumnFlags_NoClip
TABLE_COLUMN_NO_SORT = enums.ImGuiTableColumnFlags_NoSort
TABLE_COLUMN_NO_SORT_ASCENDING = enums.ImGuiTableColumnFlags_NoSortAscending
TABLE_COLUMN_NO_SORT_DESCENDING = enums.ImGuiTableColumnFlags_NoSortDescending
TABLE_COLUMN_NO_HEADER_WIDTH = enums.ImGuiTableColumnFlags_NoHeaderWidth
TABLE_COLUMN_PREFER_SORT_ASCENDING = enums.ImGuiTableColumnFlags_PreferSortAscending
TABLE_COLUMN_PREFER_SORT_DESCENDING = enums.ImGuiTableColumnFlags_PreferSortDescending
TABLE_COLUMN_INDENT_ENABLE = enums.ImGuiTableColumnFlags_IndentEnable
TABLE_COLUMN_INDENT_DISABLE = enums.ImGuiTableColumnFlags_IndentDisable
# Output status flags, read-only via TableGetColumnFlags()
TABLE_COLUMN_IS_ENABLED = enums.ImGuiTableColumnFlags_IsEnabled
TABLE_COLUMN_IS_VISIBLE = enums.ImGuiTableColumnFlags_IsVisible
TABLE_COLUMN_IS_SORTED = enums.ImGuiTableColumnFlags_IsSorted
TABLE_COLUMN_IS_HOVERED = enums.ImGuiTableColumnFlags_IsHovered

# === Table Row Flags ===
TABLE_ROW_NONE = enums.ImGuiTableRowFlags_None
TABLE_ROW_HEADERS = enums.ImGuiTableRowFlags_Headers

# === Table Background Target ===
TABLE_BACKGROUND_TARGET_NONE = enums.ImGuiTableBgTarget_None
TABLE_BACKGROUND_TARGET_ROW_BG0 = enums.ImGuiTableBgTarget_RowBg0
TABLE_BACKGROUND_TARGET_ROW_BG1 = enums.ImGuiTableBgTarget_RowBg1
TABLE_BACKGROUND_TARGET_CELL_BG = enums.ImGuiTableBgTarget_CellBg


# === Focus flag enum redefines ====
# TODO: Change to FOCUSED_ ?
FOCUS_NONE = enums.ImGuiFocusedFlags_None
FOCUS_CHILD_WINDOWS = enums.ImGuiFocusedFlags_ChildWindows
FOCUS_ROOT_WINDOW = enums.ImGuiFocusedFlags_RootWindow
FOCUS_ANY_WINDOW = enums.ImGuiFocusedFlags_AnyWindow
FOCUS_ROOT_AND_CHILD_WINDOWS = enums.ImGuiFocusedFlags_RootAndChildWindows

# === Hovered flag enum redefines ====
HOVERED_NONE = enums.ImGuiHoveredFlags_None
HOVERED_CHILD_WINDOWS = enums.ImGuiHoveredFlags_ChildWindows
HOVERED_ROOT_WINDOW = enums.ImGuiHoveredFlags_RootWindow
HOVERED_ANY_WINDOW = enums.ImGuiHoveredFlags_AnyWindow
HOVERED_ALLOW_WHEN_BLOCKED_BY_POPUP = enums.ImGuiHoveredFlags_AllowWhenBlockedByPopup
HOVERED_ALLOW_WHEN_BLOCKED_BY_ACTIVE_ITEM = enums.ImGuiHoveredFlags_AllowWhenBlockedByActiveItem
HOVERED_ALLOW_WHEN_OVERLAPPED = enums.ImGuiHoveredFlags_AllowWhenOverlapped
HOVERED_ALLOW_WHEN_DISABLED = enums.ImGuiHoveredFlags_AllowWhenDisabled
HOVERED_RECT_ONLY = enums.ImGuiHoveredFlags_RectOnly
HOVERED_ROOT_AND_CHILD_WINDOWS = enums.ImGuiHoveredFlags_RootAndChildWindows

# === Drag Drop flag enum redefines ====
DRAG_DROP_NONE = enums.ImGuiDragDropFlags_None
DRAG_DROP_SOURCE_NO_PREVIEW_TOOLTIP = enums.ImGuiDragDropFlags_SourceNoPreviewTooltip
DRAG_DROP_SOURCE_NO_DISABLE_HOVER = enums.ImGuiDragDropFlags_SourceNoDisableHover
DRAG_DROP_SOURCE_NO_HOLD_TO_OPEN_OTHERS = enums.ImGuiDragDropFlags_SourceNoHoldToOpenOthers
DRAG_DROP_SOURCE_ALLOW_NULL_ID = enums.ImGuiDragDropFlags_SourceAllowNullID
DRAG_DROP_SOURCE_EXTERN = enums.ImGuiDragDropFlags_SourceExtern
DRAG_DROP_SOURCE_AUTO_EXPIRE_PAYLOAD = enums.ImGuiDragDropFlags_SourceAutoExpirePayload

# === Accept Drag Drop Payload flag enum redefines ====
DRAG_DROP_ACCEPT_BEFORE_DELIVERY = enums.ImGuiDragDropFlags_AcceptBeforeDelivery
DRAG_DROP_ACCEPT_NO_DRAW_DEFAULT_RECT = enums.ImGuiDragDropFlags_AcceptNoDrawDefaultRect
DRAG_DROP_ACCEPT_NO_PREVIEW_TOOLTIP = enums.ImGuiDragDropFlags_AcceptNoPreviewTooltip
DRAG_DROP_ACCEPT_PEEK_ONLY = enums.ImGuiDragDropFlags_AcceptPeekOnly

# === Cardinal Direction enum redefines ====
DIRECTION_NONE = enums.ImGuiDir_None
DIRECTION_LEFT = enums.ImGuiDir_Left
DIRECTION_RIGHT = enums.ImGuiDir_Right
DIRECTION_UP = enums.ImGuiDir_Up
DIRECTION_DOWN = enums.ImGuiDir_Down

# === Sorting Direction ===
SORT_DIRECTION_NONE = enums.ImGuiSortDirection_None      
SORT_DIRECTION_ASCENDING = enums.ImGuiSortDirection_Ascending 
SORT_DIRECTION_DESCENDING = enums.ImGuiSortDirection_Descending

# ==== Mouse Cursors ====
MOUSE_CURSOR_NONE = enums.ImGuiMouseCursor_None
MOUSE_CURSOR_ARROW = enums.ImGuiMouseCursor_Arrow
MOUSE_CURSOR_TEXT_INPUT = enums.ImGuiMouseCursor_TextInput
MOUSE_CURSOR_RESIZE_ALL = enums.ImGuiMouseCursor_ResizeAll
MOUSE_CURSOR_RESIZE_NS = enums.ImGuiMouseCursor_ResizeNS
MOUSE_CURSOR_RESIZE_EW = enums.ImGuiMouseCursor_ResizeEW
MOUSE_CURSOR_RESIZE_NESW = enums.ImGuiMouseCursor_ResizeNESW
MOUSE_CURSOR_RESIZE_NWSE = enums.ImGuiMouseCursor_ResizeNWSE
MOUSE_CURSOR_HAND = enums.ImGuiMouseCursor_Hand
MOUSE_CURSOR_NOT_ALLOWED = enums.ImGuiMouseCursor_NotAllowed

# ==== Color identifiers for styling ====
COLOR_TEXT = enums.ImGuiCol_Text
COLOR_TEXT_DISABLED = enums.ImGuiCol_TextDisabled
COLOR_WINDOW_BACKGROUND = enums.ImGuiCol_WindowBg
COLOR_CHILD_BACKGROUND = enums.ImGuiCol_ChildBg
COLOR_POPUP_BACKGROUND = enums.ImGuiCol_PopupBg
COLOR_BORDER = enums.ImGuiCol_Border
COLOR_BORDER_SHADOW = enums.ImGuiCol_BorderShadow
COLOR_FRAME_BACKGROUND = enums.ImGuiCol_FrameBg
COLOR_FRAME_BACKGROUND_HOVERED = enums.ImGuiCol_FrameBgHovered
COLOR_FRAME_BACKGROUND_ACTIVE = enums.ImGuiCol_FrameBgActive
COLOR_TITLE_BACKGROUND = enums.ImGuiCol_TitleBg
COLOR_TITLE_BACKGROUND_ACTIVE = enums.ImGuiCol_TitleBgActive
COLOR_TITLE_BACKGROUND_COLLAPSED = enums.ImGuiCol_TitleBgCollapsed
COLOR_MENUBAR_BACKGROUND = enums.ImGuiCol_MenuBarBg
COLOR_SCROLLBAR_BACKGROUND = enums.ImGuiCol_ScrollbarBg
COLOR_SCROLLBAR_GRAB = enums.ImGuiCol_ScrollbarGrab
COLOR_SCROLLBAR_GRAB_HOVERED = enums.ImGuiCol_ScrollbarGrabHovered
COLOR_SCROLLBAR_GRAB_ACTIVE = enums.ImGuiCol_ScrollbarGrabActive
COLOR_CHECK_MARK = enums.ImGuiCol_CheckMark
COLOR_SLIDER_GRAB = enums.ImGuiCol_SliderGrab
COLOR_SLIDER_GRAB_ACTIVE = enums.ImGuiCol_SliderGrabActive
COLOR_BUTTON = enums.ImGuiCol_Button
COLOR_BUTTON_HOVERED = enums.ImGuiCol_ButtonHovered
COLOR_BUTTON_ACTIVE = enums.ImGuiCol_ButtonActive
COLOR_HEADER = enums.ImGuiCol_Header
COLOR_HEADER_HOVERED = enums.ImGuiCol_HeaderHovered
COLOR_HEADER_ACTIVE = enums.ImGuiCol_HeaderActive
COLOR_SEPARATOR = enums.ImGuiCol_Separator
COLOR_SEPARATOR_HOVERED = enums.ImGuiCol_SeparatorHovered
COLOR_SEPARATOR_ACTIVE = enums.ImGuiCol_SeparatorActive
COLOR_RESIZE_GRIP = enums.ImGuiCol_ResizeGrip
COLOR_RESIZE_GRIP_HOVERED = enums.ImGuiCol_ResizeGripHovered
COLOR_RESIZE_GRIP_ACTIVE = enums.ImGuiCol_ResizeGripActive
COLOR_TAB = enums.ImGuiCol_Tab
COLOR_TAB_HOVERED = enums.ImGuiCol_TabHovered
COLOR_TAB_ACTIVE = enums.ImGuiCol_TabActive
COLOR_TAB_UNFOCUSED = enums.ImGuiCol_TabUnfocused
COLOR_TAB_UNFOCUSED_ACTIVE = enums.ImGuiCol_TabUnfocusedActive
COLOR_PLOT_LINES = enums.ImGuiCol_PlotLines
COLOR_PLOT_LINES_HOVERED = enums.ImGuiCol_PlotLinesHovered
COLOR_PLOT_HISTOGRAM = enums.ImGuiCol_PlotHistogram
COLOR_PLOT_HISTOGRAM_HOVERED = enums.ImGuiCol_PlotHistogramHovered
COLOR_TABLE_HEADER_BACKGROUND = enums.ImGuiCol_TableHeaderBg
COLOR_TABLE_BORDER_STRONG = enums.ImGuiCol_TableBorderStrong
COLOR_TABLE_BORDER_LIGHT = enums.ImGuiCol_TableBorderLight
COLOR_TABLE_ROW_BACKGROUND = enums.ImGuiCol_TableRowBg
COLOR_TABLE_ROW_BACKGROUND_ALT = enums.ImGuiCol_TableRowBgAlt
COLOR_TEXT_SELECTED_BACKGROUND = enums.ImGuiCol_TextSelectedBg
COLOR_DRAG_DROP_TARGET = enums.ImGuiCol_DragDropTarget
COLOR_NAV_HIGHLIGHT = enums.ImGuiCol_NavHighlight
COLOR_NAV_WINDOWING_HIGHLIGHT = enums.ImGuiCol_NavWindowingHighlight
COLOR_NAV_WINDOWING_DIM_BACKGROUND = enums.ImGuiCol_NavWindowingDimBg
COLOR_MODAL_WINDOW_DIM_BACKGROUND = enums.ImGuiCol_ModalWindowDimBg
COLOR_COUNT = enums.ImGuiCol_COUNT

# ==== Data Type ====
DATA_TYPE_S8     = enums.ImGuiDataType_S8     
DATA_TYPE_U8     = enums.ImGuiDataType_U8     
DATA_TYPE_S16    = enums.ImGuiDataType_S16    
DATA_TYPE_U16    = enums.ImGuiDataType_U16    
DATA_TYPE_S32    = enums.ImGuiDataType_S32    
DATA_TYPE_U32    = enums.ImGuiDataType_U32    
DATA_TYPE_S64    = enums.ImGuiDataType_S64    
DATA_TYPE_U64    = enums.ImGuiDataType_U64    
DATA_TYPE_FLOAT  = enums.ImGuiDataType_Float  
DATA_TYPE_DOUBLE = enums.ImGuiDataType_Double 

# ==== Text input flags ====
INPUT_TEXT_NONE = enums.ImGuiInputTextFlags_None
INPUT_TEXT_CHARS_DECIMAL = enums.ImGuiInputTextFlags_CharsDecimal
INPUT_TEXT_CHARS_HEXADECIMAL = enums.ImGuiInputTextFlags_CharsHexadecimal
INPUT_TEXT_CHARS_UPPERCASE = enums.ImGuiInputTextFlags_CharsUppercase
INPUT_TEXT_CHARS_NO_BLANK = enums.ImGuiInputTextFlags_CharsNoBlank
INPUT_TEXT_AUTO_SELECT_ALL = enums.ImGuiInputTextFlags_AutoSelectAll
INPUT_TEXT_ENTER_RETURNS_TRUE = enums.ImGuiInputTextFlags_EnterReturnsTrue
INPUT_TEXT_CALLBACK_COMPLETION = enums.ImGuiInputTextFlags_CallbackCompletion
INPUT_TEXT_CALLBACK_HISTORY = enums.ImGuiInputTextFlags_CallbackHistory
INPUT_TEXT_CALLBACK_ALWAYS = enums.ImGuiInputTextFlags_CallbackAlways
INPUT_TEXT_CALLBACK_CHAR_FILTER = enums.ImGuiInputTextFlags_CallbackCharFilter
INPUT_TEXT_ALLOW_TAB_INPUT = enums.ImGuiInputTextFlags_AllowTabInput
INPUT_TEXT_CTRL_ENTER_FOR_NEW_LINE = enums.ImGuiInputTextFlags_CtrlEnterForNewLine
INPUT_TEXT_NO_HORIZONTAL_SCROLL = enums.ImGuiInputTextFlags_NoHorizontalScroll
INPUT_TEXT_ALWAYS_OVERWRITE = enums.ImGuiInputTextFlags_AlwaysOverwrite
INPUT_TEXT_ALWAYS_INSERT_MODE = enums.ImGuiInputTextFlags_AlwaysInsertMode # OBSOLETED in 1.82 (from Mars 2021)
INPUT_TEXT_READ_ONLY = enums.ImGuiInputTextFlags_ReadOnly
INPUT_TEXT_PASSWORD = enums.ImGuiInputTextFlags_Password
INPUT_TEXT_NO_UNDO_REDO = enums.ImGuiInputTextFlags_NoUndoRedo
INPUT_TEXT_CHARS_SCIENTIFIC = enums.ImGuiInputTextFlags_CharsScientific
INPUT_TEXT_CALLBACK_RESIZE = enums.ImGuiInputTextFlags_CallbackResize
INPUT_TEXT_CALLBACK_EDIT = enums.ImGuiInputTextFlags_CallbackEdit

# ==== Draw Corner Flags ===
# OBSOLETED in 1.82 (from Mars 2021), use ImDrawFlags_xxx
DRAW_CORNER_NONE = enums.ImDrawCornerFlags_None      
DRAW_CORNER_TOP_LEFT = enums.ImDrawCornerFlags_TopLeft   
DRAW_CORNER_TOP_RIGHT = enums.ImDrawCornerFlags_TopRight  
DRAW_CORNER_BOTTOM_LEFT = enums.ImDrawCornerFlags_BotLeft   
DRAW_CORNER_BOTTOM_RIGHT = enums.ImDrawCornerFlags_BotRight  
DRAW_CORNER_TOP = enums.ImDrawCornerFlags_Top       
DRAW_CORNER_BOTTOM = enums.ImDrawCornerFlags_Bot       
DRAW_CORNER_LEFT = enums.ImDrawCornerFlags_Left      
DRAW_CORNER_RIGHT = enums.ImDrawCornerFlags_Right     
DRAW_CORNER_ALL = enums.ImDrawCornerFlags_All       


# ==== Draw Flags ====
DRAW_NONE = enums.ImDrawFlags_None
DRAW_CLOSED = enums.ImDrawFlags_Closed
DRAW_ROUND_CORNERS_TOP_LEFT = enums.ImDrawFlags_RoundCornersTopLeft
DRAW_ROUND_CORNERS_TOP_RIGHT = enums.ImDrawFlags_RoundCornersTopRight
DRAW_ROUND_CORNERS_BOTTOM_LEFT = enums.ImDrawFlags_RoundCornersBottomLeft
DRAW_ROUND_CORNERS_BOTTOM_RIGHT = enums.ImDrawFlags_RoundCornersBottomRight
DRAW_ROUND_CORNERS_NONE = enums.ImDrawFlags_RoundCornersNone
DRAW_ROUND_CORNERS_TOP = enums.ImDrawFlags_RoundCornersTop
DRAW_ROUND_CORNERS_BOTTOM = enums.ImDrawFlags_RoundCornersBottom
DRAW_ROUND_CORNERS_LEFT = enums.ImDrawFlags_RoundCornersLeft
DRAW_ROUND_CORNERS_RIGHT = enums.ImDrawFlags_RoundCornersRight
DRAW_ROUND_CORNERS_ALL = enums.ImDrawFlags_RoundCornersAll

# ==== Draw List Flags ====
DRAW_LIST_NONE = enums.ImDrawListFlags_None                    
DRAW_LIST_ANTI_ALIASED_LINES = enums.ImDrawListFlags_AntiAliasedLines        
DRAW_LIST_ANTI_ALIASED_LINES_USE_TEX = enums.ImDrawListFlags_AntiAliasedLinesUseTex  
DRAW_LIST_ANTI_ALIASED_FILL = enums.ImDrawListFlags_AntiAliasedFill         
DRAW_LIST_ALLOW_VTX_OFFSET = enums.ImDrawListFlags_AllowVtxOffset      

# ==== Font Atlas Flags ====
FONT_ATLAS_NONE = enums.ImFontAtlasFlags_None               
FONT_ATLAS_NO_POWER_OF_TWO_HEIGHT = enums.ImFontAtlasFlags_NoPowerOfTwoHeight 
FONT_ATLAS_NO_MOUSE_CURSOR = enums.ImFontAtlasFlags_NoMouseCursors     
FONT_ATLAS_NO_BAKED_LINES = enums.ImFontAtlasFlags_NoBakedLines           

# ==== Config Flags ====
CONFIG_NONE = enums.ImGuiConfigFlags_None
CONFIG_NAV_ENABLE_KEYBOARD = enums.ImGuiConfigFlags_.ImGuiConfigFlags_NavEnableKeyboard
CONFIG_NAV_ENABLE_GAMEPAD = enums.ImGuiConfigFlags_.ImGuiConfigFlags_NavEnableGamepad
CONFIG_NAV_ENABLE_SET_MOUSE_POS = enums.ImGuiConfigFlags_.ImGuiConfigFlags_NavEnableSetMousePos
CONFIG_NAV_NO_CAPTURE_KEYBOARD = enums.ImGuiConfigFlags_.ImGuiConfigFlags_NavNoCaptureKeyboard
CONFIG_NO_MOUSE = enums.ImGuiConfigFlags_.ImGuiConfigFlags_NoMouse
CONFIG_NO_MOUSE_CURSOR_CHANGE = enums.ImGuiConfigFlags_.ImGuiConfigFlags_NoMouseCursorChange
CONFIG_IS_RGB = enums.ImGuiConfigFlags_.ImGuiConfigFlags_IsSRGB
CONFIG_IS_TOUCH_SCREEN = enums.ImGuiConfigFlags_.ImGuiConfigFlags_IsTouchScreen

# ==== Backend Flags ====
BACKEND_NONE = enums.ImGuiBackendFlags_None
BACKEND_HAS_GAMEPAD = enums.ImGuiBackendFlags_.ImGuiBackendFlags_HasGamepad
BACKEND_HAS_MOUSE_CURSORS = enums.ImGuiBackendFlags_.ImGuiBackendFlags_HasMouseCursors
BACKEND_HAS_SET_MOUSE_POS = enums.ImGuiBackendFlags_.ImGuiBackendFlags_HasSetMousePos
BACKEND_RENDERER_HAS_VTX_OFFSET = enums.ImGuiBackendFlags_RendererHasVtxOffset

# ==== Slider Flags ====
SLIDER_FLAGS_NONE = enums.ImGuiSliderFlags_None
SLIDER_FLAGS_ALWAYS_CLAMP = enums.ImGuiSliderFlags_AlwaysClamp
SLIDER_FLAGS_LOGARITHMIC = enums.ImGuiSliderFlags_Logarithmic
SLIDER_FLAGS_NO_ROUND_TO_FORMAT = enums.ImGuiSliderFlags_NoRoundToFormat
SLIDER_FLAGS_NO_INPUT = enums.ImGuiSliderFlags_NoInput

# ==== Mouse Button ====
MOUSE_BUTTON_LEFT = enums.ImGuiMouseButton_Left 
MOUSE_BUTTON_RIGHT = enums.ImGuiMouseButton_Right 
MOUSE_BUTTON_MIDDLE = enums.ImGuiMouseButton_Middle

# ==== Viewport Flags ====
VIEWPORT_FLAGS_NONE = enums.ImGuiViewportFlags_None                     #
VIEWPORT_FLAGS_IS_PLATFORM_WINDOW = enums.ImGuiViewportFlags_IsPlatformWindow         # Represent a Platform Window
VIEWPORT_FLAGS_IS_PLATFORM_MONITOR = enums.ImGuiViewportFlags_IsPlatformMonitor        # Represent a Platform Monitor (unused yet)
VIEWPORT_FLAGS_OWNED_BY_APP = enums.ImGuiViewportFlags_OwnedByApp               # Platform Window: is created/managed by the application (rather than a dear imgui backend)

include "imgui/common.pyx"

_contexts = {}
cdef class _ImGuiContext(object):
    cdef cimgui.ImGuiContext* _ptr

    # For objects that cimgui stores as void* (such as texture_id) but need to be kept alive for rendering.
    # The cache is cleared on new_frame().
    _keepalive_cache = []

    @staticmethod
    cdef from_ptr(cimgui.ImGuiContext* ptr):
        if ptr == NULL:
            return None

        if (<uintptr_t>ptr) not in _contexts:
            instance = _ImGuiContext()
            instance._ptr = ptr
            _contexts[<uintptr_t>ptr] = instance

        return _contexts[<uintptr_t>ptr]

    def __eq__(_ImGuiContext self, _ImGuiContext other):
        return other._ptr == self._ptr


cdef class _DrawCmd(object):
    cdef cimgui.ImDrawCmd* _ptr

    # todo: consider using fast instantiation here
    #       see: http://cython.readthedocs.io/en/latest/src/userguide/extension_types.html#fast-instantiation
    @staticmethod
    cdef from_ptr(cimgui.ImDrawCmd* ptr):
        if ptr == NULL:
            return None

        instance = _DrawCmd()
        instance._ptr = ptr
        return instance

    @property
    def texture_id(self):
        return <object>self._ptr.TextureId

    @property
    def clip_rect(self):
        return _cast_ImVec4_tuple(self._ptr.ClipRect)

    @property
    def elem_count(self):
        return self._ptr.ElemCount


cdef class _DrawList(object):
    """ Low level drawing API.

    _DrawList instance can be acquired by calling :func:`get_window_draw_list`.
    """
    cdef cimgui.ImDrawList* _ptr

    @staticmethod
    cdef from_ptr(cimgui.ImDrawList* ptr):
        if ptr == NULL:
            return None

        instance = _DrawList()
        instance._ptr = ptr
        return instance

    @property
    def cmd_buffer_size(self):
        return self._ptr.CmdBuffer.Size

    @property
    def cmd_buffer_data(self):
        return <uintptr_t>self._ptr.CmdBuffer.Data

    @property
    def vtx_buffer_size(self):
        return self._ptr.VtxBuffer.Size

    @property
    def vtx_buffer_data(self):
        return <uintptr_t>self._ptr.VtxBuffer.Data

    @property
    def idx_buffer_size(self):
        return self._ptr.IdxBuffer.Size

    @property
    def idx_buffer_data(self):
        return <uintptr_t>self._ptr.IdxBuffer.Data
    
    @property
    def flags(self):
        return self._ptr.Flags
        
    @flags.setter
    def flags(self, cimgui.ImDrawListFlags flags):
        self._ptr.Flags = flags
    
    def push_clip_rect(
        self,
        float clip_rect_min_x, float clip_rect_min_y,
        float clip_rect_max_x, float clip_rect_max_y,
        bool intersect_with_current_clip_rect = False
        ):
        """Render-level scissoring. This is passed down to your render function 
        but not used for CPU-side coarse clipping. Prefer using higher-level :func:`push_clip_rect()` 
        to affect logic (hit-testing and widget culling)
        
        .. wraps::
            void PushClipRect(ImVec2 clip_rect_min, ImVec2 clip_rect_max, bool intersect_with_current_clip_rect = false)
        """
        self._ptr.PushClipRect(
            _cast_args_ImVec2(clip_rect_min_x, clip_rect_min_y),
            _cast_args_ImVec2(clip_rect_max_x, clip_rect_max_y),
            intersect_with_current_clip_rect
        )
    
    def push_clip_rect_full_screen(self):
        """
        .. wraps::
            void PushClipRectFullScreen()
        """
        self._ptr.PushClipRectFullScreen()
    
    def pop_clip_rect(self):
        """Render-level scisoring. 
        
        .. wraps::
            void PopClipRect()
        """
        self._ptr.PopClipRect()
    
    def push_texture_id(self, texture_id):
        """
        .. wraps::
            void PushTextureID(ImTextureID texture_id)
        """
        get_current_context()._keepalive_cache.append(texture_id)
        self._ptr.PushTextureID(<void*>texture_id)
    
    
    def pop_texture_id(self):
        """
        .. wraps::
            void PopTextureID()
        """
        self._ptr.PopTextureID()
    
    def get_clip_rect_min(self):
        """
        .. wraps::
            ImVec2 GetClipRectMin()
        """
        return _cast_ImVec2_tuple(self._ptr.GetClipRectMin())
    
    def get_clip_rect_max(self):
        """
        .. wraps::
            ImVec2 GetClipRectMax()
        """
        return _cast_ImVec2_tuple(self._ptr.GetClipRectMax())
    
    def add_line(
            self,
            float start_x, float start_y,
            float end_x, float end_y,
            cimgui.ImU32 col,
            # note: optional
            float thickness=1.0,
        ):
        """Add a straight line to the draw list.

        .. visual-example::
            :auto_layout:
            :width: 200
            :height: 100

            imgui.begin("Line example")
            draw_list = imgui.get_window_draw_list()
            draw_list.add_line(20, 35, 180, 80, imgui.get_color_u32_rgba(1,1,0,1), 3)
            draw_list.add_line(180, 35, 20, 80, imgui.get_color_u32_rgba(1,0,0,1), 3)
            imgui.end()

        Args:
            start_x (float): X coordinate of first point
            start_y (float): Y coordinate of first point
            end_x (float): X coordinate of second point
            end_y (float): Y coordinate of second point
            col (ImU32): RGBA color specification
            thickness (float): Line thickness in pixels

        .. wraps::
            void ImDrawList::AddLine(
                const ImVec2& a,
                const ImVec2& b,
                ImU32 col,
                float thickness = 1.0f
            )
        """
        self._ptr.AddLine(
            _cast_args_ImVec2(start_x, start_y),
            _cast_args_ImVec2(end_x, end_y),
            col,
            thickness,
        )

    def add_rect(
            self,
            float upper_left_x, float upper_left_y,
            float lower_right_x, float lower_right_y,
            cimgui.ImU32 col,
            # note: optional
            float rounding = 0.0,
            cimgui.ImDrawFlags flags = 0,
            float thickness = 1.0,
        ):
        """Add a rectangle outline to the draw list.

        .. visual-example::
            :auto_layout:
            :width: 200
            :height: 100

            imgui.begin("Rect example")
            draw_list = imgui.get_window_draw_list()
            draw_list.add_rect(20, 35, 90, 80, imgui.get_color_u32_rgba(1,1,0,1), thickness=3)
            draw_list.add_rect(110, 35, 180, 80, imgui.get_color_u32_rgba(1,0,0,1), rounding=5, thickness=3)
            imgui.end()

        Args:
            upper_left_x (float): X coordinate of top-left corner
            upper_left_y (float): Y coordinate of top-left corner
            lower_right_x (float): X coordinate of lower-right corner
            lower_right_y (float): Y coordinate of lower-right corner
            col (ImU32): RGBA color specification
            rounding (float): Degree of rounding, defaults to 0.0
            flags (ImDrawFlags): Draw flags, defaults to 0. See:
                :ref:`list of available flags <draw-flag-options>`.
            thickness (float): Line thickness, defaults to 1.0

        .. wraps::
            void ImDrawList::AddRect(
                const ImVec2& a,
                const ImVec2& b,
                ImU32 col,
                float rounding = 0.0f,
                ImDrawFlags flags = 0,
                float thickness = 1.0f
            )
        """
        self._ptr.AddRect(
            _cast_args_ImVec2(upper_left_x, upper_left_y),
            _cast_args_ImVec2(lower_right_x, lower_right_y),
            col,
            rounding,
            flags,
            thickness,
        )

    def add_rect_filled(
            self,
            float upper_left_x, float upper_left_y,
            float lower_right_x, float lower_right_y,
            cimgui.ImU32 col,
            # note: optional
            float rounding = 0.0,
            cimgui.ImDrawFlags flags = 0,
        ):
        """Add a filled rectangle to the draw list.

        .. visual-example::
            :auto_layout:
            :width: 200
            :height: 100

            imgui.begin("Filled rect example")
            draw_list = imgui.get_window_draw_list()
            draw_list.add_rect_filled(20, 35, 90, 80, imgui.get_color_u32_rgba(1,1,0,1))
            draw_list.add_rect_filled(110, 35, 180, 80, imgui.get_color_u32_rgba(1,0,0,1), 5)
            imgui.end()

        Args:
            upper_left_x (float): X coordinate of top-left corner
            upper_left_y (float): Y coordinate of top-left corner
            lower_right_x (float): X coordinate of lower-right corner
            lower_right_y (float): Y coordinate of lower-right corner
            col (ImU32): RGBA color specification
            rounding (float): Degree of rounding, defaults to 0.0
            flags (ImDrawFlags): Draw flags, defaults to 0. See:
                :ref:`list of available flags <draw-flag-options>`.

        .. wraps::
            void ImDrawList::AddRectFilled(
                const ImVec2& a,
                const ImVec2& b,
                ImU32 col,
                float rounding = 0.0f,
                ImDrawFlags flags = 0
            )
        """
        self._ptr.AddRectFilled(
            _cast_args_ImVec2(upper_left_x, upper_left_y),
            _cast_args_ImVec2(lower_right_x, lower_right_y),
            col,
            rounding,
            flags
        )

    def add_rect_filled_multicolor(
            self,
            float upper_left_x, float upper_left_y,
            float lower_right_x, float lower_right_y,
            cimgui.ImU32 col_upr_left,
            cimgui.ImU32 col_upr_right,
            cimgui.ImU32 col_bot_right,
            cimgui.ImU32 col_bot_left
        ):
        """Add a multicolor filled rectangle to the draw list.

        .. visual-example::
            :auto_layout:
            :width: 200
            :height: 100

            imgui.begin("Multicolored filled rect example")
            draw_list = imgui.get_window_draw_list()
            draw_list.add_rect_filled_multicolor(20, 35, 190, 80, imgui.get_color_u32_rgba(1,0,0,1),
                imgui.get_color_u32_rgba(0,1,0,1), imgui.get_color_u32_rgba(0,0,1,1),
                imgui.get_color_u32_rgba(1,1,1,1))
            imgui.end()

        Args:
            upper_left_x (float): X coordinate of top-left corner
            upper_left_y (float): Y coordinate of top-left corner
            lower_right_x (float): X coordinate of lower-right corner
            lower_right_y (float): Y coordinate of lower-right corner
            col_upr_left (ImU32): RGBA color for the top left corner
            col_upr_right (ImU32): RGBA color for the top right corner
            col_bot_right (ImU32): RGBA color for the bottom right corner
            col_bot_left (ImU32): RGBA color for the bottom left corner

        .. wraps::
            void ImDrawList::AddRectFilledMultiColor(
                const ImVec2& a,
                const ImVec2& b,
                ImU32 col_upr_left,
                ImU32 col_upr_right,
                ImU32 col_bot_right,
                ImU32 col_bot_left
            )
        """
        self._ptr.AddRectFilledMultiColor(
            _cast_args_ImVec2(upper_left_x, upper_left_y),
            _cast_args_ImVec2(lower_right_x, lower_right_y),
            col_upr_left,
            col_upr_right,
            col_bot_right,
            col_bot_left
        )

    def add_quad(
            self,
            float point1_x, float point1_y,
            float point2_x, float point2_y,
            float point3_x, float point3_y,
            float point4_x, float point4_y,
            cimgui.ImU32 col,
            # note: optional
            float thickness = 1.0
        ):
        """Add a quad to the list.

            .. visual-example::
                :auto_layout:
                :width: 200
                :height: 100

                imgui.begin("Quad example")
                draw_list = imgui.get_window_draw_list()
                draw_list.add_quad(20, 35, 85, 30, 90, 80, 17, 76, imgui.get_color_u32_rgba(1,1,0,1))
                draw_list.add_quad(110, 35, 177, 33, 180, 80, 112, 79, imgui.get_color_u32_rgba(1,0,0,1), 5)
                imgui.end()

            Args:
                point1_x (float): X coordinate of first corner
                point1_y (float): Y coordinate of first corner
                point2_x (float): X coordinate of second corner
                point2_y (float): Y coordinate of second corner
                point3_x (float): X coordinate of third corner
                point3_y (float): Y coordinate of third corner
                point4_x (float): X coordinate of fourth corner
                point4_y (float): Y coordinate of fourth corner
                col (ImU32): RGBA color specification
                thickness (float): Line thickness

            .. wraps::
                void ImDrawList::AddQuad(
                    const ImVec2& p1,
                    const ImVec2& p2,
                    const ImVec2& p3,
                    const ImVec2& p4,
                    ImU32 col,
                    float thickness = 1.0
                )
        """
        self._ptr.AddQuad(
            _cast_args_ImVec2(point1_x, point1_y),
            _cast_args_ImVec2(point2_x, point2_y),
            _cast_args_ImVec2(point3_x, point3_y),
            _cast_args_ImVec2(point4_x, point4_y),
            col,
            thickness
        )

    def add_quad_filled(
            self,
            float point1_x, float point1_y,
            float point2_x, float point2_y,
            float point3_x, float point3_y,
            float point4_x, float point4_y,
            cimgui.ImU32 col,
        ):
        """Add a filled quad to the list.

            .. visual-example::
                :auto_layout:
                :width: 200
                :height: 100

                imgui.begin("Filled Quad example")
                draw_list = imgui.get_window_draw_list()
                draw_list.add_quad_filled(20, 35, 85, 30, 90, 80, 17, 76, imgui.get_color_u32_rgba(1,1,0,1))
                draw_list.add_quad_filled(110, 35, 177, 33, 180, 80, 112, 79, imgui.get_color_u32_rgba(1,0,0,1))
                imgui.end()

            Args:
                point1_x (float): X coordinate of first corner
                point1_y (float): Y coordinate of first corner
                point2_x (float): X coordinate of second corner
                point2_y (float): Y coordinate of second corner
                point3_x (float): X coordinate of third corner
                point3_y (float): Y coordinate of third corner
                point4_x (float): X coordinate of fourth corner
                point4_y (float): Y coordinate of fourth corner
                col (ImU32): RGBA color specification

            .. wraps::
                void ImDrawList::AddQuadFilled(
                    const ImVec2& p1,
                    const ImVec2& p2,
                    const ImVec2& p3,
                    const ImVec2& p4,
                    ImU32 col
                )
        """
        self._ptr.AddQuadFilled(
            _cast_args_ImVec2(point1_x, point1_y),
            _cast_args_ImVec2(point2_x, point2_y),
            _cast_args_ImVec2(point3_x, point3_y),
            _cast_args_ImVec2(point4_x, point4_y),
            col
        )

    def add_triangle(
            self,
            float point1_x, float point1_y,
            float point2_x, float point2_y,
            float point3_x, float point3_y,
            cimgui.ImU32 col,
            # note: optional
            float thickness = 1.0
        ):
        """Add a triangle to the list.

            .. visual-example::
                :auto_layout:
                :width: 200
                :height: 100

                imgui.begin("Triangle example")
                draw_list = imgui.get_window_draw_list()
                draw_list.add_triangle(20, 35, 90, 35, 55, 80, imgui.get_color_u32_rgba(1,1,0,1))
                draw_list.add_triangle(110, 35, 180, 35, 145, 80, imgui.get_color_u32_rgba(1,0,0,1), 5)
                imgui.end()

            Args:
                point1_x (float): X coordinate of first corner
                point1_y (float): Y coordinate of first corner
                point2_x (float): X coordinate of second corner
                point2_y (float): Y coordinate of second corner
                point3_x (float): X coordinate of third corner
                point3_y (float): Y coordinate of third corner
                col (ImU32): RGBA color specification
                thickness (float): Line thickness

            .. wraps::
                void ImDrawList::AddTriangle(
                    const ImVec2& p1,
                    const ImVec2& p2,
                    const ImVec2& p3,
                    ImU32 col,
                    float thickness = 1.0
                )
        """
        self._ptr.AddTriangle(
            _cast_args_ImVec2(point1_x, point1_y),
            _cast_args_ImVec2(point2_x, point2_y),
            _cast_args_ImVec2(point3_x, point3_y),
            col,
            thickness
        )

    def add_triangle_filled(
            self,
            float point1_x, float point1_y,
            float point2_x, float point2_y,
            float point3_x, float point3_y,
            cimgui.ImU32 col,
        ):
        """Add a filled triangle to the list.

            .. visual-example::
                :auto_layout:
                :width: 200
                :height: 100

                imgui.begin("Filled triangle example")
                draw_list = imgui.get_window_draw_list()
                draw_list.add_triangle_filled(20, 35, 90, 35, 55, 80, imgui.get_color_u32_rgba(1,1,0,1))
                draw_list.add_triangle_filled(110, 35, 180, 35, 145, 80, imgui.get_color_u32_rgba(1,0,0,1))
                imgui.end()

            Args:
                point1_x (float): X coordinate of first corner
                point1_y (float): Y coordinate of first corner
                point2_x (float): X coordinate of second corner
                point2_y (float): Y coordinate of second corner
                point3_x (float): X coordinate of third corner
                point3_y (float): Y coordinate of third corner
                col (ImU32): RGBA color specification

            .. wraps::
                void ImDrawList::AddTriangleFilled(
                    const ImVec2& p1,
                    const ImVec2& p2,
                    const ImVec2& p3,
                    ImU32 col
                )
        """
        self._ptr.AddTriangleFilled(
            _cast_args_ImVec2(point1_x, point1_y),
            _cast_args_ImVec2(point2_x, point2_y),
            _cast_args_ImVec2(point3_x, point3_y),
            col
        )

    def add_bezier_cubic(
            self,
            float point1_x, float point1_y,
            float point2_x, float point2_y,
            float point3_x, float point3_y,
            float point4_x, float point4_y,
            cimgui.ImU32 col,
            float thickness,
            # note: optional
            int num_segments = 0
        ):
        """Add a cubic bezier curve to the list.

            .. visual-example::
                :auto_layout:
                :width: 200
                :height: 100

                imgui.begin("Cubic bezier example")
                draw_list = imgui.get_window_draw_list()
                draw_list.add_bezier_cubic(20, 35, 90, 80, 110, 180, 145, 35, imgui.get_color_u32_rgba(1,1,0,1), 2)
                imgui.end()

            Args:
                point1_x (float): X coordinate of first point
                point1_y (float): Y coordinate of first point
                point2_x (float): X coordinate of second point
                point2_y (float): Y coordinate of second point
                point3_x (float): X coordinate of third point
                point3_y (float): Y coordinate of third point
                point4_x (float): X coordinate of fourth point
                point4_y (float): Y coordinate of fourth point
                col (ImU32): RGBA color specification
                thickness (float): Line thickness
                num_segments (ImU32): Number of segments, defaults to 0 meaning auto-tesselation

            .. wraps::
                void ImDrawList::AddBezierCubic(
                    const ImVec2& p1,
                    const ImVec2& p2,
                    const ImVec2& p3,
                    const ImVec2& p4,
                    ImU32 col,
                    float thickness,
                    int num_segments = 0
                )
        """
        self._ptr.AddBezierCubic(
            _cast_args_ImVec2(point1_x, point1_y),
            _cast_args_ImVec2(point2_x, point2_y),
            _cast_args_ImVec2(point3_x, point3_y),
            _cast_args_ImVec2(point4_x, point4_y),
            col,
            thickness,
            num_segments
        )

    def add_bezier_quadratic(
            self,
            float point1_x, float point1_y,
            float point2_x, float point2_y,
            float point3_x, float point3_y,
            cimgui.ImU32 col,
            float thickness,
            # note: optional
            int num_segments = 0
        ):
        """Add a quadratic bezier curve to the list.

            .. visual-example::
                :auto_layout:
                :width: 200
                :height: 100

                imgui.begin("Quadratic bezier example")
                draw_list = imgui.get_window_draw_list()
                draw_list.add_bezier_quadratic(20, 35, 90, 80, 145, 35, imgui.get_color_u32_rgba(1,1,0,1), 2)
                imgui.end()

            Args:
                point1_x (float): X coordinate of first point
                point1_y (float): Y coordinate of first point
                point2_x (float): X coordinate of second point
                point2_y (float): Y coordinate of second point
                point3_x (float): X coordinate of third point
                point3_y (float): Y coordinate of third point
                col (ImU32): RGBA color specification
                thickness (float): Line thickness
                num_segments (ImU32): Number of segments, defaults to 0 meaning auto-tesselation

            .. wraps::
                void ImDrawList::AddBezierCubic(
                    const ImVec2& p1,
                    const ImVec2& p2,
                    const ImVec2& p3,
                    ImU32 col,
                    float thickness,
                    int num_segments = 0
                )
        """
        self._ptr.AddBezierQuadratic(
            _cast_args_ImVec2(point1_x, point1_y),
            _cast_args_ImVec2(point2_x, point2_y),
            _cast_args_ImVec2(point3_x, point3_y),
            col,
            thickness,
            num_segments
        )

    def add_circle(
            self,
            float centre_x, float centre_y,
            float radius,
            cimgui.ImU32 col,
            # note: optional
            int num_segments = 0,
            float thickness = 1.0
        ):
        """Add a circle to the draw list.

        .. visual-example::
            :auto_layout:
            :width: 200
            :height: 100

            imgui.begin("Circle example")
            draw_list = imgui.get_window_draw_list()
            draw_list.add_circle(100, 60, 30, imgui.get_color_u32_rgba(1,1,0,1), thickness=3)
            imgui.end()

        Args:
            centre_x (float): circle centre coordinates
            centre_y (float): circle centre coordinates
            radius (float): circle radius
            col (ImU32): RGBA color specification
            num_segments (ImU32): Number of segments, defaults to 0 meaning auto-tesselation
            thickness (float): Line thickness

        .. wraps::
            void ImDrawList::AddCircle(
                const ImVec2& centre,
                float radius,
                ImU32 col,
                int num_segments = 0,
                float thickness = 1.0
            )
        """
        self._ptr.AddCircle(
            _cast_args_ImVec2(centre_x, centre_y),
            radius,
            col,
            num_segments,
            thickness
        )

    def add_circle_filled(
            self,
            float centre_x, float centre_y,
            float radius,
            cimgui.ImU32 col,
            # note: optional
            cimgui.ImU32 num_segments = 0
        ):

        """Add a filled circle to the draw list.

        .. visual-example::
            :auto_layout:
            :width: 200
            :height: 100

            imgui.begin("Filled circle example")
            draw_list = imgui.get_window_draw_list()
            draw_list.add_circle_filled(100, 60, 30, imgui.get_color_u32_rgba(1,1,0,1))
            imgui.end()

        Args:
            centre_x (float): circle centre coordinates
            centre_y (float): circle centre coordinates
            radius (float): circle radius
            col (ImU32): RGBA color specification
            num_segments (ImU32): Number of segments, defaults to 0 meaning auto-tesselation

        .. wraps::
            void ImDrawList::AddCircleFilled(
                const ImVec2& centre,
                float radius,
                ImU32 col,
                int num_segments = 0
            )
        """
        self._ptr.AddCircleFilled(
            _cast_args_ImVec2(centre_x, centre_y),
            radius,
            col,
            num_segments
        )
    
    def add_ngon(
        self,
        float centre_x, float centre_y,
        float radius, 
        cimgui.ImU32 col, 
        int num_segments, 
        float thickness = 1.0
    ):
        """Draw a regular Ngon
        
        Args:
            centre_x (float): circle centre coordinates
            centre_y (float): circle centre coordinates
            radius (float): Distance of points to center
            col (ImU32): RGBA color specification
            num_segments (int): Number of segments
            thickness (float): Line thickness

        .. visual-example::
            :auto_layout:
            :width: 200
            :height: 100

            imgui.begin("Ngon Example")
            draw_list = imgui.get_window_draw_list()
            draw_list.add_ngon(100, 60, 30, imgui.get_color_u32_rgba(1,1,0,1), 5)
            imgui.end()
        
        .. wraps::
            void  AddNgon(
                const ImVec2& center, 
                float radius, 
                ImU32 col, 
                int num_segments, 
                float thickness = 1.0f
            )
        """
        self._ptr.AddNgon(
            _cast_args_ImVec2(centre_x, centre_y),
            radius, col, num_segments, thickness
        )
    
    def add_ngon_filled(
        self,
        float centre_x, float centre_y,
        float radius, 
        cimgui.ImU32 col, 
        int num_segments
    ):
        """Draw a regular Ngon
        
        Args:
            centre_x (float): circle centre coordinates
            centre_y (float): circle centre coordinates
            radius (float): Distance of points to center
            col (ImU32): RGBA color specification
            num_segments (int): Number of segments

        .. visual-example::
            :auto_layout:
            :width: 200
            :height: 100

            imgui.begin("Filled Ngon Example")
            draw_list = imgui.get_window_draw_list()
            draw_list.add_ngon_filled(100, 60, 30, imgui.get_color_u32_rgba(1,1,0,1), 5)
            imgui.end()
        
        .. wraps::
            void  AddNgonFilled(
                const ImVec2& center, 
                float radius, 
                ImU32 col, 
                int num_segments
            )
        """
        self._ptr.AddNgonFilled(
            _cast_args_ImVec2(centre_x, centre_y),
            radius, col, num_segments
        )
    
    def add_text(
            self,
            float pos_x, float pos_y,
            cimgui.ImU32 col,
            str text
        ):
        """Add text to the draw list.

        .. visual-example::
            :auto_layout:
            :width: 200
            :height: 100

            imgui.begin("Text example")
            draw_list = imgui.get_window_draw_list()
            draw_list.add_text(20, 35, imgui.get_color_u32_rgba(1,1,0,1), "Hello!")
            imgui.end()

        Args:
            pos_x (float): X coordinate of the text's upper-left corner
            pos_y (float): Y coordinate of the text's upper-left corner
            col (ImU32): RGBA color specification
            text (str): text

        .. wraps::
            void ImDrawList::AddText(
                const ImVec2& pos,
                ImU32 col,
                const char* text_begin,
                const char* text_end = NULL
            )
        """
        self._ptr.AddText(
            _cast_args_ImVec2(pos_x, pos_y),
            col,
            _bytes(text),
            NULL
        )

    def add_image(self,
        texture_id,
        tuple a,
        tuple b,
        tuple uv_a=(0,0),
        tuple uv_b=(1,1),
        cimgui.ImU32 col=0xffffffff):
        """Add image to the draw list. Aspect ratio is not preserved.

        .. visual-example::
            :auto_layout:
            :width: 200
            :height: 100

            imgui.begin("Image example")
            texture_id = imgui.get_io().fonts.texture_id
            draw_list = imgui.get_window_draw_list()
            draw_list.add_image(texture_id, (20, 35), (180, 80), col=imgui.get_color_u32_rgba(0.5,0.5,1,1))
            imgui.end()

        Args:
            texture_id (object): ID of the texture to draw
            a (tuple): top-left image corner coordinates,
            b (tuple): bottom-right image corner coordinates,
            uv_a (tuple): UV coordinates of the top-left corner, defaults to (0, 0)
            uv_b (tuple): UV coordinates of the bottom-right corner, defaults to (1, 1)
            col (ImU32): tint color, defaults to 0xffffffff (no tint)

        .. wraps::
            void ImDrawList::AddImage(
                ImTextureID user_texture_id,
                const ImVec2& a,
                const ImVec2& b,
                const ImVec2& uv_a = ImVec2(0,0),
                const ImVec2& uv_b = ImVec2(1,1),
                ImU32 col = 0xFFFFFFFF
            )
        """
        get_current_context()._keepalive_cache.append(texture_id)
        self._ptr.AddImage(
            <void*>texture_id,
            _cast_tuple_ImVec2(a),
            _cast_tuple_ImVec2(b),
            _cast_tuple_ImVec2(uv_a),
            _cast_tuple_ImVec2(uv_b),
            col
        )

    def add_image_rounded(self,
        texture_id,
        tuple a,
        tuple b,
        tuple uv_a=(0,0),
        tuple uv_b=(1,1),
        cimgui.ImU32 col=0xffffffff,
        float rounding = 0.0,
        cimgui.ImDrawFlags flags = 0):
        """Add rounded image to the draw list. Aspect ratio is not preserved.

        .. visual-example::
            :auto_layout:
            :width: 200
            :height: 100

            imgui.begin("Image example")
            texture_id = imgui.get_io().fonts.texture_id
            draw_list = imgui.get_window_draw_list()
            draw_list.add_image_rounded(texture_id, (20, 35), (180, 80), col=imgui.get_color_u32_rgba(0.5,0.5,1,1), rounding=10)
            imgui.end()

        Args:
            texture_id (object): ID of the texture to draw
            a (tuple): top-left image corner coordinates,
            b (tuple): bottom-right image corner coordinates,
            uv_a (tuple): UV coordinates of the top-left corner, defaults to (0, 0)
            uv_b (tuple): UV coordinates of the bottom-right corner, defaults to (1, 1)
            col (ImU32): tint color, defaults to 0xffffffff (no tint)
            rounding (float): degree of rounding, defaults to 0.0
            flags (ImDrawFlags): draw flags, defaults to 0. See:
                :ref:`list of available flags <draw-flag-options>`.

        .. wraps::
            void ImDrawList::AddImageRounded(
                ImTextureID user_texture_id,
                const ImVec2& a,
                const ImVec2& b,
                const ImVec2& uv_a = ImVec2(0,0),
                const ImVec2& uv_b = ImVec2(1,1),
                ImU32 col = 0xFFFFFFFF,
                float rounding = 0.0f,
                ImDrawFlags flags = 0
            )
        """
        get_current_context()._keepalive_cache.append(texture_id)
        self._ptr.AddImageRounded(
            <void*>texture_id,
            _cast_tuple_ImVec2(a),
            _cast_tuple_ImVec2(b),
            _cast_tuple_ImVec2(uv_a),
            _cast_tuple_ImVec2(uv_b),
            col,
            rounding,
            flags
        )

    def add_polyline(
            self,
            list points,
            cimgui.ImU32 col,
            cimgui.ImDrawFlags flags = 0,
            float thickness=1.0
        ):
        """Add a optionally closed polyline to the draw list.

        .. visual-example::
            :auto_layout:
            :width: 200
            :height: 100

            imgui.begin("Polyline example")
            draw_list = imgui.get_window_draw_list()
            draw_list.add_polyline([(20, 35), (90, 35), (55, 80)], imgui.get_color_u32_rgba(1,1,0,1), flags=imgui.DRAW_NONE, thickness=3)
            draw_list.add_polyline([(110, 35), (180, 35), (145, 80)], imgui.get_color_u32_rgba(1,0,0,1), flags=imgui.DRAW_CLOSED, thickness=3)
            imgui.end()

        Args:
            points (list): list of points
            col (float): RGBA color specification
            flags (ImDrawFlags): Drawing flags. See:
                :ref:`list of available flags <draw-flag-options>`.
            thickness (float): line thickness

        .. wraps::
            void ImDrawList::AddPolyline(
                const ImVec2* points,
                int num_points,
                ImU32 col,
                flags flags,
                float thickness
            )
        """
        num_points = len(points)
        cdef cimgui.ImVec2 *pts
        pts = <cimgui.ImVec2 *>malloc(num_points * cython.sizeof(cimgui.ImVec2))
        for i in range(num_points):
            pts[i] = _cast_args_ImVec2(points[i][0], points[i][1])
        self._ptr.AddPolyline(
            pts,
            num_points,
            col,
            flags,
            thickness
        )
        free(pts)

    # Path related functions

    def path_clear(self):
        """
        Clear the current list of path point

        .. wraps::
            void ImDrawList::PathClear()
        """
        self._ptr.PathClear()

    def path_line_to(self, float x, float y):
        """
        Add a point to the path list

        .. visual-example::
            :auto_layout:
            :width: 200
            :height: 100

            imgui.begin("Path line to example")
            draw_list = imgui.get_window_draw_list()
            draw_list.path_clear()
            draw_list.path_line_to(20, 35)
            draw_list.path_line_to(180, 80)
            draw_list.path_stroke(imgui.get_color_u32_rgba(1,1,0,1), flags=0, thickness=3)
            draw_list.path_clear()
            draw_list.path_line_to(180, 35)
            draw_list.path_line_to(20, 80)
            draw_list.path_stroke(imgui.get_color_u32_rgba(1,0,0,1), flags=0, thickness=3)
            imgui.end()

        Args:
            x (float): path point x coordinate
            y (float): path point y coordinate

        .. wraps::
            void ImDrawList::PathLineTo(
                const ImVec2& pos,
            )
        """
        self._ptr.PathLineTo(
            _cast_args_ImVec2(x, y)
        )

    def path_arc_to(
            self,
            float center_x, float center_y,
            float radius,
            float a_min, float a_max,
            # note: optional
            cimgui.ImU32 num_segments = 0
        ):
        """
        Add an arc to the path list

        .. visual-example::
            :auto_layout:
            :width: 200
            :height: 100

            imgui.begin("Path arc to example")
            draw_list = imgui.get_window_draw_list()
            draw_list.path_clear()
            draw_list.path_arc_to(55, 60, 30, 1, 5)
            draw_list.path_stroke(imgui.get_color_u32_rgba(1,1,0,1), flags=0, thickness=3)
            draw_list.path_clear()
            draw_list.path_arc_to(155, 60, 30, -2, 2)
            draw_list.path_fill_convex(imgui.get_color_u32_rgba(1,0,0,1))
            imgui.end()

        Args:
            center_x (float): arc center x coordinate
            center_y (float): arc center y coordinate
            radius (flaot): radius of the arc
            a_min (float): minimum angle of the arc (in radian)
            a_max (float): maximum angle of the arc (in radian)
            num_segments (ImU32): Number of segments, defaults to 0 meaning auto-tesselation

        .. wraps::
            void ImDrawList::PathArcTo(
                const ImVec2& center,
                float radius,
                float a_min,
                float a_max,
                int num_segments = 0
            )
        """
        self._ptr.PathArcTo(
            _cast_args_ImVec2(center_x, center_y),
            radius,
            a_min, a_max,
            num_segments
        )

    def path_arc_to_fast(
            self,
            float center_x, float center_y,
            float radius,
            cimgui.ImU32 a_min_of_12,
            cimgui.ImU32 a_max_of_12,
        ):
        """
        Add an arc to the path list

        .. visual-example::
            :auto_layout:
            :width: 200
            :height: 100

            imgui.begin("Path arc to fast example")
            draw_list = imgui.get_window_draw_list()
            draw_list.path_clear()
            draw_list.path_arc_to_fast(55, 60, 30, 0, 6)
            draw_list.path_stroke(imgui.get_color_u32_rgba(1,1,0,1), flags=0, thickness=3)
            draw_list.path_clear()
            draw_list.path_arc_to_fast(155, 60, 30, 3, 9)
            draw_list.path_fill_convex(imgui.get_color_u32_rgba(1,0,0,1))
            imgui.end()

        Args:
            center_x (float): arc center x coordinate
            center_y (float): arc center y coordinate
            radius (flaot): radius of the arc
            a_min_of_12 (ImU32): minimum angle of the arc
            a_max_of_12 (ImU32): maximum angle of the arc

        .. wraps::
            void ImDrawList::PathArcToFast(
                const ImVec2& center,
                float radius,
                int a_min_of_12,
                int a_max_of_12
            )
        """
        self._ptr.PathArcToFast(
            _cast_args_ImVec2(center_x, center_y),
            radius,
            a_min_of_12,
            a_max_of_12,
        )

    def path_rect(
            self,
            float point1_x, float point1_y,
            float point2_x, float point2_y,
            # note: optional
            float rounding = 0.0,
            cimgui.ImDrawFlags flags = 0
        ):
        """
        Add a rect to the path list

        .. visual-example::
            :auto_layout:
            :width: 200
            :height: 100

            imgui.begin("Path arc to fast example")
            draw_list = imgui.get_window_draw_list()
            draw_list.path_clear()
            draw_list.path_rect(20, 35, 90, 80)
            draw_list.path_stroke(imgui.get_color_u32_rgba(1,1,0,1), flags=0, thickness=3)
            draw_list.path_clear()
            draw_list.path_rect(110, 35, 180, 80, 5)
            draw_list.path_fill_convex(imgui.get_color_u32_rgba(1,0,0,1))
            imgui.end()

        Args:
            point1_x (float): point1 x coordinate
            point1_y (float): point1 y coordinate
            point2_x (float): point2 x coordinate
            point2_y (float): point2 y coordinate
            rounding (flaot): Degree of rounding, defaults to 0.0
            flags (ImDrawFlags):Draw flags, defaults to 0. See:
                :ref:`list of available flags <draw-flag-options>`.

        .. wraps::
            void ImDrawList::PathRect(
                const ImVec2& p1,
                const ImVec2& p2,
                float rounding = 0.0,
                ImDrawFlags flags = 0
            )
        """
        self._ptr.PathRect(
            _cast_args_ImVec2(point1_x, point1_y),
            _cast_args_ImVec2(point2_x, point2_y),
            rounding,
            flags
        )

    # Path rendering functions

    def path_fill_convex(self, cimgui.ImU32 col):
        """

        Note: Filled shapes must always use clockwise winding order.
        The anti-aliasing fringe depends on it. Counter-clockwise shapes
        will have "inward" anti-aliasing.

        .. visual-example::
            :auto_layout:
            :width: 200
            :height: 100

            imgui.begin("Path fill convex example")
            draw_list = imgui.get_window_draw_list()
            draw_list.path_clear()
            draw_list.path_line_to(100, 60)
            draw_list.path_arc_to(100, 60, 30, 0.5, 5.5)
            draw_list.path_fill_convex(imgui.get_color_u32_rgba(1,1,0,1))
            imgui.end()

        Args:
            col (ImU32): color to fill the path shape with

        .. wraps::
            void ImDrawList::PathFillConvex(
                ImU32   col
            );
        """
        self._ptr.PathFillConvex(col)

    def path_stroke(
            self,
            cimgui.ImU32 col,
            # note: optional
            cimgui.ImDrawFlags flags = 0,
            float thickness = 1.0
        ):
        """
        Args:
            col (ImU32): color to fill the path shape with
            flags (ImDrawFlags): draw flags, defaults to 0. See:
                :ref:`list of available flags <draw-flag-options>`.
            thickness (float): Line thickness in pixels

        .. visual-example::
            :auto_layout:
            :width: 200
            :height: 100

            imgui.begin("Path stroke example")
            draw_list = imgui.get_window_draw_list()
            draw_list.path_clear()
            draw_list.path_line_to(100, 60)
            draw_list.path_arc_to(100, 60, 30, 0.5, 5.5)
            draw_list.path_stroke(imgui.get_color_u32_rgba(1,1,0,1), flags=imgui.DRAW_CLOSED, thickness=3)
            imgui.end()


        .. wraps::
            void ImDrawList::PathStroke(
                ImU32 col,
                ImDrawFlags flags = 0,
                float thickness = 1.0
            );
        """
        self._ptr.PathStroke(
            col,
            flags,
            thickness
        )

    # channels

    def channels_split(self, int channels_count):
        """Use to split render into layers. 
        By switching channels to can render out-of-order (e.g. submit FG primitives before BG primitives)
        Use to minimize draw calls (e.g. if going back-and-forth between multiple clipping rectangles, prefer to append into separate channels then merge at the end)
        
        Prefer using your own persistent instance of ImDrawListSplitter as you can stack them.
        Using the ImDrawList::ChannelsXXXX you cannot stack a split over another.
        
        Warning - be careful with using channels as "layers".
        Child windows are always drawn after their parent, so they will
        paint over its channels.
        To paint over child windows, use `OverlayDrawList`.
        """
        # TODO: document
        self._ptr.ChannelsSplit(channels_count)

    def channels_set_current(self, int idx):
        # TODO: document
        self._ptr.ChannelsSetCurrent(idx)

    def channels_merge(self):
        # TODO: document
        self._ptr.ChannelsMerge()
        
    def prim_reserve(self, int idx_count, int vtx_count):
        """Reserve space for a number of vertices and indices.
        You must finish filling your reserved data before calling `prim_reserve()` again, as it may 
        reallocate or submit the intermediate results. `prim_unreserve()` can be used to release 
        unused allocations.
        
        Drawing a quad is 6 idx (2 triangles) with 2 sharing vertices for a total of 4 vertices.
        
        Args:
            idx_count (int): Number of indices to add to IdxBuffer
            vtx_count (int): Number of verticies to add to VtxBuffer
        
        .. wraps::
            void PrimReserve(int idx_count, int vtx_count)
        """
        self._ptr.PrimReserve(idx_count, vtx_count)
    
    def prim_unreserve(self, int idx_count, int vtx_count):
        """Release the a number of reserved vertices/indices from the end of the 
        last reservation made with `prim_reserve()`.
        
        Args:
            idx_count (int): Number of indices to remove from IdxBuffer
            vtx_count (int): Number of verticies to remove from VtxBuffer
        
        .. wraps::
            void PrimUnreserve(int idx_count, int vtx_count)
        """
        self._ptr.PrimUnreserve(idx_count, vtx_count)
    
    def prim_rect(self, float a_x, float a_y, float b_x, float b_y, cimgui.ImU32 color = 0xFFFFFFFF):
        """Axis aligned rectangle (2 triangles)
        Reserve primitive space with `prim_rect()` before calling `prim_quad_UV()`.
        Each call to `prim_rect()` is 6 idx and 4 vtx.
        
        Args:
            a_x, a_y (float): First rectangle point coordinates
            b_x, b_y (float): Opposite rectangle point coordinates
            color (ImU32): Color
        
        .. wraps::
            void PrimRect(const ImVec2& a, const ImVec2& b, ImU32 col)
        """
        self._ptr.PrimRect(
            _cast_args_ImVec2(a_x, a_y),
            _cast_args_ImVec2(b_x, b_y),
            color
        )
    
    def prim_rect_UV(
        self, 
        float a_x, float a_y, 
        float b_x, float b_y,
        float uv_a_u, float uv_a_v,
        float uv_b_u, float uv_b_v,
        cimgui.ImU32 color = 0xFFFFFFFF
        ):
        """Axis aligned rectangle (2 triangles) with custom UV coordinates.
        Reserve primitive space with `prim_reserve()` before calling `prim_rect_UV()`.
        Each call to `prim_rect_UV()` is 6 idx and 4 vtx.
        Set the texture ID using `push_texture_id()`.
        
        Args:
            a_x, a_y (float): First rectangle point coordinates
            b_x, b_y (float): Opposite rectangle point coordinates
            uv_a_u, uv_a_v (float): First rectangle point UV coordinates
            uv_b_u, uv_b_v (float): Opposite rectangle point UV coordinates
            color (ImU32): Color
        
        .. wraps::
            void PrimRectUV(const ImVec2& a, const ImVec2& b, const ImVec2& uv_a, const ImVec2& uv_b, ImU32 col)
        """
        self._ptr.PrimRectUV(
            _cast_args_ImVec2(a_x, a_y),
            _cast_args_ImVec2(b_x, b_y),
            _cast_args_ImVec2(uv_a_u, uv_a_v),
            _cast_args_ImVec2(uv_b_u, uv_b_v),
            color
        )
    
    def prim_quad_UV(
        self, 
        float a_x, float a_y, 
        float b_x, float b_y, 
        float c_x, float c_y, 
        float d_x, float d_y,
        float uv_a_u, float uv_a_v,
        float uv_b_u, float uv_b_v,
        float uv_c_u, float uv_c_v,
        float uv_d_u, float uv_d_v,
        cimgui.ImU32 color = 0xFFFFFFFF
        ):
        """Custom quad (2 triangles) with custom UV coordinates.
        Reserve primitive space with `prim_reserve()` before calling `prim_quad_UV()`.
        Each call to `prim_quad_UV()` is 6 idx and 4 vtx.
        Set the texture ID using `push_texture_id()`.
        
        Args:
            a_x, a_y (float): Point 1 coordinates
            b_x, b_y (float): Point 2 coordinates
            c_x, c_y (float): Point 3 coordinates
            d_x, d_y (float): Point 4 coordinates
            uv_a_u, uv_a_v (float): Point 1 UV coordinates
            uv_b_u, uv_b_v (float): Point 2 UV coordinates
            uv_c_u, uv_c_v (float): Point 3 UV coordinates
            uv_d_u, uv_d_v (float): Point 4 UV coordinates
            color (ImU32): Color
        
        .. wraps::
            void PrimQuadUV(const ImVec2& a, const ImVec2& b, const ImVec2& c, const ImVec2& d, const ImVec2& uv_a, const ImVec2& uv_b, const ImVec2& uv_c, const ImVec2& uv_d, ImU32 col)
        """
        self._ptr.PrimQuadUV(
            _cast_args_ImVec2(a_x, a_y),
            _cast_args_ImVec2(b_x, b_y),
            _cast_args_ImVec2(c_x, c_y),
            _cast_args_ImVec2(d_x, d_y),
            _cast_args_ImVec2(uv_a_u, uv_a_v),
            _cast_args_ImVec2(uv_b_u, uv_b_v),
            _cast_args_ImVec2(uv_c_u, uv_c_v),
            _cast_args_ImVec2(uv_d_u, uv_d_v),
            color
        )
    
    def prim_write_vtx(self, float pos_x, float pos_y, float u, float v, cimgui.ImU32 color = 0xFFFFFFFF):
        """Write a vertex
        
        Args:
            pos_x, pos_y (float): Point coordinates
            u, v (float): Point UV coordinates
            color (ImU32): Color
        
        .. wraps::
            void  PrimWriteVtx(const ImVec2& pos, const ImVec2& uv, ImU32 col)
        """
        self._ptr.PrimWriteVtx(
            _cast_args_ImVec2(pos_x, pos_y),
            _cast_args_ImVec2(u, v),
            color
        )
    
    def prim_write_idx(self, cimgui.ImDrawIdx idx):
        """Write index
        
        Args:
            idx (ImDrawIdx): index to write
        
        .. wraps::
            void  PrimWriteIdx(ImDrawIdx idx)
        """
        self._ptr.PrimWriteIdx(idx)
    
    def prim_vtx(self, float pos_x, float pos_y, float u, float v, cimgui.ImU32 color = 0xFFFFFFFF):
        """Write vertex with unique index
        
        Args:
            pos_x, pos_y (float): Point coordinates
            u, v (float): Point UV coordinates
            color (ImU32): Color
        
        .. wraps::
            void PrimVtx(const ImVec2& pos, const ImVec2& uv, ImU32 col)
        """
        self._ptr.PrimVtx(
            _cast_args_ImVec2(pos_x, pos_y),
            _cast_args_ImVec2(u,v),
            color
        )
    
    @property
    def commands(self):
        return [
            # todo: consider operator overloading in pxd file
            _DrawCmd.from_ptr(&self._ptr.CmdBuffer.Data[idx])
            # perf: short-wiring instead of using property
            # note: add py3k compat
            for idx in xrange(self._ptr.CmdBuffer.Size)
        ]


cdef class _Colors(object):
    cdef GuiStyle _style

    def __cinit__(self):
        self._style = None

    def __init__(self, GuiStyle gui_style):
        self._style = gui_style

    cdef inline _check_color(self, cimgui.ImGuiCol variable):
        if not (0 <= variable < enums.ImGuiCol_COUNT):
            raise ValueError("Unknown style variable: {}".format(variable))

    def __getitem__(self, cimgui.ImGuiCol variable):
        self._check_color(variable)
        self._style._check_ptr()
        cdef int ix = variable
        return _cast_ImVec4_tuple(self._style._ptr.Colors[ix])

    def __setitem__(self, cimgui.ImGuiCol variable, value):
        self._check_color(variable)
        self._style._check_ptr()
        cdef int ix = variable
        self._style._ptr.Colors[ix] = _cast_tuple_ImVec4(value)


cdef class GuiStyle(object):
    """
    Container for ImGui style information

    """
    cdef cimgui.ImGuiStyle* _ptr
    cdef bool _owner
    cdef _Colors _colors

    def __cinit__(self):
        self._ptr = NULL
        self._owner = False
        self._colors = None

    def __dealloc__(self):
        if self._owner:
            del self._ptr
            self._ptr = NULL


    cdef inline _check_ptr(self):
        if self._ptr is NULL:
            raise RuntimeError(
                "Improperly initialized, use imgui.get_style() or "
                "GuiStyle.created() to obtain style classes"
            )

    def __eq__(GuiStyle self, GuiStyle other):
        return other._ptr == self._ptr

    @staticmethod
    def create():
        return GuiStyle._create()

    @staticmethod
    cdef GuiStyle from_ref(cimgui.ImGuiStyle& ref):
        cdef GuiStyle instance = GuiStyle()
        instance._ptr = &ref
        instance._colors = _Colors(instance)
        return instance

    @staticmethod
    cdef GuiStyle _create():
        cdef cimgui.ImGuiStyle* _ptr = new cimgui.ImGuiStyle()
        cdef GuiStyle instance = GuiStyle.from_ref(deref(_ptr))
        instance._owner = True
        instance._colors = _Colors(instance)
        return instance

    @property
    def alpha(self):
        """Global alpha blending parameter for windows

        Returns:
            float
        """
        self._check_ptr()
        return self._ptr.Alpha

    @alpha.setter
    def alpha(self, float value):
        self._check_ptr()
        self._ptr.Alpha = value

    @property
    def window_padding(self):
        self._check_ptr()
        return _cast_ImVec2_tuple(self._ptr.WindowPadding)

    @window_padding.setter
    def window_padding(self, value):
        self._check_ptr()
        self._ptr.WindowPadding = _cast_tuple_ImVec2(value)

    @property
    def window_min_size(self):
        self._check_ptr()
        return _cast_ImVec2_tuple(self._ptr.WindowMinSize)

    @window_min_size.setter
    def window_min_size(self, value):
        self._check_ptr()
        self._ptr.WindowMinSize = _cast_tuple_ImVec2(value)

    @property
    def window_rounding(self):
        self._check_ptr()
        return self._ptr.WindowRounding

    @window_rounding.setter
    def window_rounding(self, float value):
        self._check_ptr()
        self._ptr.WindowRounding = value

    @property
    def window_border_size(self):
        self._check_ptr()
        return self._ptr.WindowBorderSize

    @window_border_size.setter
    def window_border_size(self, float value):
        self._check_ptr()
        self._ptr.WindowBorderSize = value

    @property
    def child_rounding(self):
        self._check_ptr()
        return self._ptr.ChildRounding

    @child_rounding.setter
    def child_rounding(self, float value):
        self._check_ptr()
        self._ptr.ChildRounding = value

    @property
    def child_border_size(self):
        self._check_ptr()
        return self._ptr.ChildBorderSize

    @child_border_size.setter
    def child_border_size(self, float value):
        self._check_ptr()
        self._ptr.ChildBorderSize = value

    @property
    def popup_rounding(self):
        self._check_ptr()
        return self._ptr.PopupRounding

    @popup_rounding.setter
    def popup_rounding(self, float value):
        self._check_ptr()
        self._ptr.PopupRounding = value

    @property
    def popup_border_size(self):
        self._check_ptr()
        return self._ptr.PopupBorderSize

    @popup_border_size.setter
    def popup_border_size(self, float value):
        self._check_ptr()
        self._ptr.ChildBorderSize = value

    @property
    def window_title_align(self):
        self._check_ptr()
        return _cast_ImVec2_tuple(self._ptr.WindowTitleAlign)

    @window_title_align.setter
    def window_title_align(self, value):
        self._check_ptr()
        self._ptr.WindowTitleAlign = _cast_tuple_ImVec2(value)
        
    @property
    def window_menu_button_position(self):
        self._check_ptr()
        return self._ptr.WindowMenuButtonPosition

    @window_menu_button_position.setter
    def window_menu_button_position(self, cimgui.ImGuiDir value):
        self._check_ptr()
        self._ptr.WindowMenuButtonPosition = value

    @property
    def frame_padding(self):
        self._check_ptr()
        return _cast_ImVec2_tuple(self._ptr.FramePadding)

    @frame_padding.setter
    def frame_padding(self, value):
        self._check_ptr()
        self._ptr.FramePadding = _cast_tuple_ImVec2(value)

    @property
    def frame_rounding(self):
        self._check_ptr()
        return self._ptr.FrameRounding

    @frame_rounding.setter
    def frame_rounding(self, float value):
        self._check_ptr()
        self._ptr.FrameRounding = value

    @property
    def frame_border_size(self):
        self._check_ptr()
        return self._ptr.FrameBorderSize

    @frame_border_size.setter
    def frame_border_size(self, float value):
        self._check_ptr()
        self._ptr.FrameBorderSize = value

    @property
    def item_spacing(self):
        self._check_ptr()
        return _cast_ImVec2_tuple(self._ptr.ItemSpacing)

    @item_spacing.setter
    def item_spacing(self, value):
        self._check_ptr()
        self._ptr.ItemSpacing = _cast_tuple_ImVec2(value)

    @property
    def item_inner_spacing(self):
        self._check_ptr()
        return _cast_ImVec2_tuple(self._ptr.ItemInnerSpacing)

    @item_inner_spacing.setter
    def item_inner_spacing(self, value):
        self._check_ptr()
        self._ptr.ItemInnerSpacing = _cast_tuple_ImVec2(value)
    
    @property
    def cell_padding(self):
        self._check_ptr()
        return _cast_ImVec2_tuple(self._ptr.CellPadding)
    
    @cell_padding.setter
    def cell_padding(self, value):
        self._check_ptr()
        self._ptr.CellPadding = _cast_tuple_ImVec2(value)

    @property
    def touch_extra_padding(self):
        self._check_ptr()
        return _cast_ImVec2_tuple(self._ptr.TouchExtraPadding)

    @touch_extra_padding.setter
    def touch_extra_padding(self, value):
        self._check_ptr()
        self._ptr.TouchExtraPadding = _cast_tuple_ImVec2(value)

    @property
    def indent_spacing(self):
        self._check_ptr()
        return self._ptr.IndentSpacing

    @indent_spacing.setter
    def indent_spacing(self, float value):
        self._check_ptr()
        self._ptr.IndentSpacing = value

    @property
    def columns_min_spacing(self):
        self._check_ptr()
        return self._ptr.ColumnsMinSpacing

    @columns_min_spacing.setter
    def columns_min_spacing(self, float value):
        self._check_ptr()
        self._ptr.ColumnsMinSpacing = value

    @property
    def scrollbar_size(self):
        self._check_ptr()
        return self._ptr.ScrollbarSize

    @scrollbar_size.setter
    def scrollbar_size(self, float value):
        self._check_ptr()
        self._ptr.ScrollbarSize = value

    @property
    def scrollbar_rounding(self):
        self._check_ptr()
        return self._ptr.ScrollbarRounding

    @scrollbar_rounding.setter
    def scrollbar_rounding(self, float value):
        self._check_ptr()
        self._ptr.ScrollbarRounding = value

    @property
    def grab_min_size(self):
        self._check_ptr()
        return self._ptr.GrabMinSize

    @grab_min_size.setter
    def grab_min_size(self, float value):
        self._check_ptr()
        self._ptr.GrabMinSize = value

    @property
    def grab_rounding(self):
        self._check_ptr()
        return self._ptr.GrabRounding

    @grab_rounding.setter
    def grab_rounding(self, float value):
        self._check_ptr()
        self._ptr.GrabRounding = value
        
    @property
    def log_slider_deadzone(self):
        self._check_ptr()
        return self._ptr.LogSliderDeadzone

    @log_slider_deadzone.setter
    def log_slider_deadzone(self, float value):
        self._check_ptr()
        self._ptr.LogSliderDeadzone = value
    
    @property
    def tab_rounding(self):
        self._check_ptr()
        return self._ptr.TabRounding

    @tab_rounding.setter
    def tab_rounding(self, float value):
        self._check_ptr()
        self._ptr.TabRounding = value
    
    @property
    def tab_border_size(self):
        self._check_ptr()
        return self._ptr.TabBorderSize

    @tab_border_size.setter
    def tab_border_size(self, float value):
        self._check_ptr()
        self._ptr.TabBorderSize= value
    
    @property
    def tab_min_width_for_close_button(self):
        self._check_ptr()
        return self._ptr.TabMinWidthForCloseButton

    @tab_min_width_for_close_button.setter
    def tab_min_width_for_close_button(self, float value):
        self._check_ptr()
        self._ptr.TabMinWidthForCloseButton = value
        
    @property
    def color_button_position(self):
        self._check_ptr()
        return self._ptr.ColorButtonPosition

    @color_button_position.setter
    def color_button_position(self, cimgui.ImGuiDir value):
        self._check_ptr()
        self._ptr.ColorButtonPosition = value

    @property
    def button_text_align(self):
        self._check_ptr()
        return _cast_ImVec2_tuple(self._ptr.ButtonTextAlign)

    @button_text_align.setter
    def button_text_align(self, value):
        self._check_ptr()
        self._ptr.ButtonTextAlign = _cast_tuple_ImVec2(value)
    
    @property
    def selectable_text_align(self):
        self._check_ptr()
        return _cast_ImVec2_tuple(self._ptr.SelectableTextAlign)

    @selectable_text_align.setter
    def selectable_text_align(self, value):
        self._check_ptr()
        self._ptr.SelectableTextAlign = _cast_tuple_ImVec2(value)

    @property
    def display_window_padding(self):
        self._check_ptr()
        return _cast_ImVec2_tuple(self._ptr.DisplayWindowPadding)

    @display_window_padding.setter
    def display_window_padding(self, value):
        self._check_ptr()
        self._ptr.DisplayWindowPadding = _cast_tuple_ImVec2(value)

    @property
    def display_safe_area_padding(self):
        self._check_ptr()
        return _cast_ImVec2_tuple(self._ptr.DisplaySafeAreaPadding)

    @display_safe_area_padding.setter
    def display_safe_area_padding(self, value):
        self._check_ptr()
        self._ptr.DisplaySafeAreaPadding = _cast_tuple_ImVec2(value)

    @property
    def mouse_cursor_scale(self):
        self._check_ptr()
        return self._ptr.MouseCursorScale

    @mouse_cursor_scale.setter
    def mouse_cursor_scale(self, value):
        self._check_ptr()
        self._ptr.MouseCursorScale = value

    @property
    def anti_aliased_lines(self):
        self._check_ptr()
        return self._ptr.AntiAliasedLines

    @anti_aliased_lines.setter
    def anti_aliased_lines(self, cimgui.bool value):
        self._check_ptr()
        self._ptr.AntiAliasedLines = value
        
    @property
    def anti_aliased_line_use_tex(self):
        self._check_ptr()
        return self._ptr.AntiAliasedLinesUseTex

    @anti_aliased_line_use_tex.setter
    def anti_aliased_line_use_tex(self, cimgui.bool value):
        self._check_ptr()
        self._ptr.AntiAliasedLinesUseTex = value

    @property
    def anti_aliased_fill(self):
        self._check_ptr()
        return self._ptr.AntiAliasedFill

    @anti_aliased_fill.setter
    def anti_aliased_fill(self, cimgui.bool value):
        self._check_ptr()
        self._ptr.AntiAliasedFill = value

    @property
    def curve_tessellation_tolerance(self):
        self._check_ptr()
        return self._ptr.CurveTessellationTol

    @curve_tessellation_tolerance.setter
    def curve_tessellation_tolerance(self, float value):
        self._check_ptr()
        self._ptr.CurveTessellationTol = value
    
    # OBSOLETED in 1.82 (from Mars 2021)
    @property
    def circle_segment_max_error(self):
        self._check_ptr()
        return self._ptr.CircleTessellationMaxError
    
    # OBSOLETED in 1.82 (from Mars 2021)
    @circle_segment_max_error.setter
    def circle_segment_max_error(self, float value):
        self._check_ptr()
        self._ptr.CircleTessellationMaxError = value
    
    @property
    def circle_tessellation_max_error(self):
        self._check_ptr()
        return self._ptr.CircleTessellationMaxError
    
    @circle_tessellation_max_error.setter
    def circle_tessellation_max_error(self, float value):
        self._check_ptr()
        self._ptr.CircleTessellationMaxError = value

    def color(self, cimgui.ImGuiCol variable):
        if not (0 <= variable < enums.ImGuiCol_COUNT):
            raise ValueError("Unknown style variable: {}".format(variable))

        self._check_ptr()
        cdef int ix = variable
        return _cast_ImVec4_tuple(self._ptr.Colors[ix])

    @property
    def colors(self):
        """Retrieve and modify style colors through list-like interface.

        .. visual-example::
            :width: 700
            :height: 500
            :auto_layout:

            style = imgui.get_style()
            imgui.begin("Color window")
            imgui.columns(4)
            for color in range(0, imgui.COLOR_COUNT):
                imgui.text("Color: {}".format(color))
                imgui.color_button("color#{}".format(color), *style.colors[color])
                imgui.next_column()

            imgui.end()
        """
        self._check_ptr()
        return self._colors

cdef class _ImGuiTableColumnSortSpecs(object):
    cdef cimgui.ImGuiTableColumnSortSpecs* _ptr

    def __init__(self):
        pass

    def _require_pointer(self):
        if self._ptr == NULL:
            raise RuntimeError(
                "%s improperly initialized" % self.__class__.__name__
            )

    @staticmethod
    cdef from_ptr(cimgui.ImGuiTableColumnSortSpecs* ptr):
        if ptr == NULL:
            return None
        instance = _ImGuiTableColumnSortSpecs()
        instance._ptr = ptr
        return instance
    
    @property
    def column_user_id(self):
        self._require_pointer()
        return self._ptr.ColumnUserID
    
    @column_user_id.setter
    def column_user_id(self, cimgui.ImGuiID column_user_id):
        self._require_pointer()
        self._ptr.ColumnUserID = column_user_id
    
    @property
    def column_index(self):
        self._require_pointer()
        return self._ptr.ColumnIndex
    
    @column_index.setter
    def column_index(self, cimgui.ImS16 column_index):
        self._require_pointer()
        self._ptr.ColumnIndex = column_index
    
    @property
    def sort_order(self):
        self._require_pointer()
        return self._ptr.SortOrder
    
    @sort_order.setter
    def sort_order(self, cimgui.ImS16 sort_order):
        self._require_pointer()
        self._ptr.SortOrder = sort_order
    
    @property
    def sort_direction(self):
        self._require_pointer()
        return self._ptr.SortDirection
    
    @sort_direction.setter
    def sort_direction(self, cimgui.ImGuiSortDirection sort_direction):
        self._require_pointer()
        self._ptr.SortDirection = sort_direction


    
cdef class _ImGuiTableColumnSortSpecs_array(object):
    
    cdef cimgui.ImGuiTableSortSpecs* _ptr
    cdef size_t idx
    
    def __init__(self):
        self.idx = 0
        pass

    def _require_pointer(self):
        if self._ptr == NULL:
            raise RuntimeError(
                "%s improperly initialized" % self.__class__.__name__
            )

    @staticmethod
    cdef from_ptr(cimgui.ImGuiTableSortSpecs* ptr):
        if ptr == NULL:
            return None
        instance = _ImGuiTableColumnSortSpecs_array()
        instance._ptr = ptr
        return instance
    
    cdef _get_item(self, size_t idx):
        self._require_pointer()
        if idx >= self._ptr.SpecsCount:
            raise ValueError("Out of bound access to idx %i of an array of size %i" % (idx, self._ptr.SpecsCount))
        cdef size_t offset = idx*sizeof(cimgui.ImGuiTableColumnSortSpecs)
        cdef size_t pointer = <size_t>self._ptr.Specs + offset
        return _ImGuiTableColumnSortSpecs.from_ptr(<cimgui.ImGuiTableColumnSortSpecs *>pointer)
    
    def __getitem__(self, idx):
        return self._get_item(idx)
    
    def __iter__(self):
        self.idx = 0
        return self
        
    def __next__(self):
        if self.idx < self._ptr.SpecsCount:
            item = self._get_item(self.idx)
            self.idx += 1
            return item
        else:
            raise StopIteration
    
    #def __setitem__(self, idx):
    #    self._table_sort_specs._require_pointer()

cdef class _ImGuiTableSortSpecs(object):
    cdef cimgui.ImGuiTableSortSpecs* _ptr
    cdef _ImGuiTableColumnSortSpecs_array specs
    
    def __init__(self):
        #self.specs = _ImGuiTableColumnSortSpecs_array(self)
        pass

    def _require_pointer(self):
        if self._ptr == NULL:
            raise RuntimeError(
                "%s improperly initialized" % self.__class__.__name__
            )

    @staticmethod
    cdef from_ptr(cimgui.ImGuiTableSortSpecs* ptr):
        if ptr == NULL:
            return None
        instance = _ImGuiTableSortSpecs()
        instance._ptr = ptr
        instance.specs = _ImGuiTableColumnSortSpecs_array.from_ptr(ptr)
        return instance
    
    @property
    def specs(self):
        return self.specs
    
    @property
    def specs_count(self):
        self._require_pointer()
        return self._ptr.SpecsCount
    
    @property
    def specs_dirty(self):
        self._require_pointer()
        return self._ptr.SpecsDirty
    
    @specs_dirty.setter
    def specs_dirty(self, cimgui.bool specs_dirty):
        self._require_pointer()
        self._ptr.SpecsDirty = specs_dirty

cdef class _ImGuiViewport(object):
    """Currently represents the Platform Window created by the application which is hosting our Dear ImGui windows.
       
       About Main Area vs Work Area:
       - Main Area = entire viewport.
       - Work Area = entire viewport minus sections used by main menu bars (for platform windows), or by task bar (for platform monitor).
       - Windows are generally trying to stay within the Work Area of their host viewport.
    """
    
    cdef cimgui.ImGuiViewport* _ptr

    def __init__(self):
        pass

    def _require_pointer(self):
        if self._ptr == NULL:
            raise RuntimeError(
                "%s improperly initialized" % self.__class__.__name__
            )

    @staticmethod
    cdef from_ptr(cimgui.ImGuiViewport* ptr):
        if ptr == NULL:
            return None

        instance = _ImGuiViewport()
        instance._ptr = ptr
        return instance
    
    @property
    def flags(self):
        self._require_pointer()
        return self._ptr.Flags
    
    @property
    def pos(self):
        """Main Area: Position of the viewport (Dear ImGui coordinates are the same as OS desktop/native coordinates)"""
        self._require_pointer()
        return _cast_ImVec2_tuple(self._ptr.Pos)
    
    @property
    def size(self):
        """Main Area: Size of the viewport."""
        self._require_pointer()
        return _cast_ImVec2_tuple(self._ptr.Size)
    
    @property
    def work_pos(self):
        """Work Area: Position of the viewport minus task bars, menus bars, status bars (>= Pos)"""
        self._require_pointer()
        return _cast_ImVec2_tuple(self._ptr.WorkPos)
    
    @property
    def work_size(self):
        """Work Area: Size of the viewport minus task bars, menu bars, status bars (<= Size)"""
        self._require_pointer()
        return _cast_ImVec2_tuple(self._ptr.WorkSize)
        
    def get_center(self):
        self._require_pointer()
        return _cast_ImVec2_tuple(self._ptr.GetCenter())
    
    def get_work_center(self):
        self._require_pointer()
        return _cast_ImVec2_tuple(self._ptr.GetWorkCenter())

cdef class _DrawData(object):
    cdef cimgui.ImDrawData* _ptr

    def __init__(self):
        pass

    def _require_pointer(self):
        if self._ptr == NULL:
            raise RuntimeError(
                "%s improperly initialized" % self.__class__.__name__
            )

    @staticmethod
    cdef from_ptr(cimgui.ImDrawData* ptr):
        if ptr == NULL:
            return None

        instance = _DrawData()
        instance._ptr = ptr
        return instance

    def deindex_all_buffers(self):
        self._require_pointer()
        self._ptr.DeIndexAllBuffers()

    def scale_clip_rects(self, width, height):
        self._require_pointer()
        self._ptr.ScaleClipRects(_cast_args_ImVec2(width, height))

    @property
    def valid(self):
        self._require_pointer()
        return self._ptr.Valid

    @property
    def cmd_count(self):
        self._require_pointer()
        return self._ptr.CmdListsCount

    @property
    def total_vtx_count(self):
        self._require_pointer()
        return self._ptr.TotalVtxCount
        
    @property
    def display_pos(self):
        self._require_pointer()
        return _cast_ImVec2_tuple(self._ptr.DisplayPos)
        
    @property
    def display_size(self):
        self._require_pointer()
        return _cast_ImVec2_tuple(self._ptr.DisplaySize)
        
    @property
    def frame_buffer_scale(self):
        self._require_pointer()
        return _cast_ImVec2_tuple(self._ptr.FramebufferScale)

    @property
    def total_idx_count(self):
        self._require_pointer()
        return self._ptr.TotalIdxCount

    @property
    def commands_lists(self):
        return [
            _DrawList.from_ptr(self._ptr.CmdLists[idx])
            # perf: short-wiring instead of using property
            for idx in xrange(self._ptr.CmdListsCount)
        ]

cdef class _StaticGlyphRanges(object):
    cdef const cimgui.ImWchar* ranges_ptr

    @staticmethod
    cdef from_ptr(const cimgui.ImWchar* ptr):
        if ptr == NULL:
            return None

        instance = _StaticGlyphRanges()
        instance.ranges_ptr = ptr
        return instance


cdef class GlyphRanges(object):
    cdef const cimgui.ImWchar* ranges_ptr

    def __init__(self, glyph_ranges):
        self.ranges_ptr = NULL
        range_list = list(glyph_ranges)
        if len(range_list) % 2 != 1 or range_list[-1] != 0:
            raise RuntimeError('glyph_ranges must be pairs of integers (inclusive range) followed by a zero')
        arr = <cimgui.ImWchar*>malloc(sizeof(cimgui.ImWchar) * len(range_list))
        self.ranges_ptr = arr
        for i, value in enumerate(range_list):
            i_value = int(value)
            if i_value < 0:
                raise RuntimeError('glyph_ranges cannot contain negative values')
            arr[i] = i_value

    def __del__(self):
        free(<void*>self.ranges_ptr)
        self.ranges_ptr = NULL


cdef class FontConfig(object):
    cdef cimgui.ImFontConfig config

    def __init__(
        self,
        font_no=None,
        size_pixels=None,
        oversample_h=None,
        oversample_v=None,
        pixel_snap_h=None,
        glyph_extra_spacing_x=None,
        glyph_extra_spacing_y=None,
        glyph_offset_x=None,
        glyph_offset_y=None,
        glyph_min_advance_x=None,
        glyph_max_advance_x=None,
        merge_mode=None,
        font_builder_flags=None,
        rasterizer_multiply=None,
        ellipsis_char=None
        ):
        if font_no is not None:
            self.config.FontNo = font_no
        if size_pixels is not None:
            self.config.SizePixels = size_pixels
        if oversample_h is not None:
            self.config.OversampleH = oversample_h
        if oversample_v is not None:
            self.config.OversampleV = oversample_v
        if pixel_snap_h is not None:
            self.config.PixelSnapH = pixel_snap_h
        if glyph_extra_spacing_x is not None:
            self.config.GlyphExtraSpacing.x = glyph_extra_spacing_x
        if glyph_extra_spacing_y is not None:
            self.config.GlyphExtraSpacing.y = glyph_extra_spacing_y
        if glyph_offset_x is not None:
            self.config.GlyphOffset.x = glyph_offset_x
        if glyph_offset_y is not None:
            self.config.GlyphOffset.y = glyph_offset_y
        if glyph_min_advance_x is not None:
            self.config.GlyphMinAdvanceX = glyph_min_advance_x
        if glyph_max_advance_x is not None:
            self.config.GlyphMaxAdvanceX = glyph_max_advance_x
        if merge_mode is not None:
            self.config.MergeMode = merge_mode
        #if font_builder_flags is not None:
        #    self.config.FontBuilderFlags = font_builder_flags
        if rasterizer_multiply is not None:
            self.config.RasterizerMultiply = rasterizer_multiply
        if ellipsis_char is not None:
            self.config.EllipsisChar = ellipsis_char


cdef class _Font(object):
    @staticmethod
    cdef from_ptr(cimgui.ImFont* ptr):
        if ptr == NULL:
            return None

        instance = _Font()
        instance._ptr = ptr
        return instance


cdef class _FontAtlas(object):
    """Font atlas object responsible for controling and loading fonts.

    This class is not intended to be instantiated by user (thus `_`
    name prefix). It should be accessed through :any:`_IO.fonts` attribute
    of :class:`_IO` obtained with :func:`get_io` function.

    Example::

        import imgui

        io = imgui.get_io()
        io.fonts.add_font_default()

    """
    cdef cimgui.ImFontAtlas* _ptr

    def __init__(self):
        pass

    @staticmethod
    cdef from_ptr(cimgui.ImFontAtlas* ptr):
        if ptr == NULL:
            return None

        instance = _FontAtlas()
        instance._ptr = ptr
        return instance

    def _require_pointer(self):
        if self._ptr == NULL:
            raise RuntimeError(
                "%s improperly initialized" % self.__class__.__name__
            )

        return self._ptr != NULL

    def add_font_default(self):
        self._require_pointer()

        return _Font.from_ptr(self._ptr.AddFontDefault(NULL))

    def add_font_from_file_ttf(
        self, str filename, float size_pixels,
        font_config=None,
        glyph_ranges=None
    ):
        self._require_pointer()

        cdef const cimgui.ImWchar* p_glyph_ranges;

        if glyph_ranges is None:
            p_glyph_ranges = NULL
        elif isinstance(glyph_ranges, _StaticGlyphRanges):
            p_glyph_ranges = (<_StaticGlyphRanges>glyph_ranges).ranges_ptr
        elif isinstance(glyph_ranges, GlyphRanges):
            p_glyph_ranges = (<GlyphRanges>glyph_ranges).ranges_ptr
        else:
            raise RuntimeError('glyph_ranges: invalid type')

        cdef cimgui.ImFontConfig config
        if font_config is not None:
            config = (<FontConfig>font_config).config

        return _Font.from_ptr(self._ptr.AddFontFromFileTTF(
            _bytes(filename), size_pixels,  &config,
            p_glyph_ranges
        ))

    def clear_tex_data(self):
        self._ptr.ClearTexData()

    def clear_input_data(self):
        self._ptr.ClearInputData()

    def clear_fonts(self):
        self._ptr.ClearFonts()

    def clear(self):
        self._ptr.Clear()

    def get_glyph_ranges_default(self):
        return _StaticGlyphRanges.from_ptr(self._ptr.GetGlyphRangesDefault())

    def get_glyph_ranges_korean(self):
        return _StaticGlyphRanges.from_ptr(self._ptr.GetGlyphRangesKorean())

    def get_glyph_ranges_japanese(self):
        return _StaticGlyphRanges.from_ptr(self._ptr.GetGlyphRangesJapanese())

    def get_glyph_ranges_chinese_full(self):
        return _StaticGlyphRanges.from_ptr(self._ptr.GetGlyphRangesChineseFull())

    def get_glyph_ranges_chinese(self):
        return _StaticGlyphRanges.from_ptr(self._ptr.GetGlyphRangesChineseSimplifiedCommon())

    def get_glyph_ranges_cyrillic(self):
        return _StaticGlyphRanges.from_ptr(self._ptr.GetGlyphRangesCyrillic())
    
    def get_glyph_ranges_thai(self):
        return _StaticGlyphRanges.from_ptr(self._ptr.GetGlyphRangesThai())
    
    def get_glyph_ranges_vietnamese(self):
        return _StaticGlyphRanges.from_ptr(self._ptr.GetGlyphRangesVietnamese())

    def get_glyph_ranges_latin(self):
        # note: this is a custom glyph range with full latin character set
        return _StaticGlyphRanges.from_ptr(_LATIN_ALL)

    def get_tex_data_as_alpha8(self):
        self._require_pointer()

        cdef int width
        cdef int height
        cdef unsigned char* pixels

        self._ptr.GetTexDataAsAlpha8(&pixels, &width, &height)

        return width, height, bytes(pixels[:width*height])

    def get_tex_data_as_rgba32(self):
        self._require_pointer()

        cdef int width
        cdef int height
        cdef unsigned char* pixels
        self._ptr.GetTexDataAsRGBA32(&pixels, &width, &height)

        return width, height, bytes(pixels[:width*height*4])

    @property
    def texture_id(self):
        """
        Note: difference in mapping (maps actual TexID and not TextureID)

        Note: texture ID type is implementation dependent. It is usually
        integer (at least for OpenGL).

        """
        return <object>self._ptr.TexID


    @property
    def texture_width(self):
        return <int>self._ptr.TexWidth

    @property
    def texture_height(self):
        return <int>self._ptr.TexHeight

    @property
    def texture_desired_width(self):
        return <int>self._ptr.TexDesiredWidth

    @texture_desired_width.setter
    def texture_desired_width(self, int value):
        self._ptr.TexDesiredWidth = value


    @texture_id.setter
    def texture_id(self, value):
        get_current_context()._keepalive_cache.append(value)
        self._ptr.TexID = <void *> value

cdef class _IO(object):
    """Main ImGui I/O context class used for ImGui configuration.

    This class is not intended to be instantiated by user (thus `_`
    name prefix). It should be accessed through obtained with :func:`get_io`
    function.

    Example::

        import imgui

        io = imgui.get_io()
    """

    cdef cimgui.ImGuiIO* _ptr
    cdef object _fonts
    cdef object _keep_ini_alive
    cdef object _keep_logfile_alive

    def __init__(self):
        
        self._ptr = &cimgui.GetIO()
        self._fonts = _FontAtlas.from_ptr(self._ptr.Fonts)

        self._keep_ini_alive = None
        self._keep_logfile_alive = None

        if <uintptr_t>cimgui.GetCurrentContext() not in _io_clipboard:
            _io_clipboard[<uintptr_t>cimgui.GetCurrentContext()] = {'_get_clipboard_text_fn': None,
                                                                    '_set_clipboard_text_fn': None}

    # ... maping of input properties ...
    @property
    def config_flags(self):
        return self._ptr.ConfigFlags

    @config_flags.setter
    def config_flags(self, cimgui.ImGuiConfigFlags value):
        self._ptr.ConfigFlags = value

    @property
    def backend_flags(self):
        return self._ptr.BackendFlags

    @backend_flags.setter
    def backend_flags(self, cimgui.ImGuiBackendFlags value):
        self._ptr.BackendFlags = value

    @property
    def display_size(self):
        return _cast_ImVec2_tuple(self._ptr.DisplaySize)

    @display_size.setter
    def display_size(self, value):
        self._ptr.DisplaySize = _cast_tuple_ImVec2(value)

    @property
    def delta_time(self):
        return self._ptr.DeltaTime

    @delta_time.setter
    def delta_time(self, float time):
        self._ptr.DeltaTime = time

    @property
    def ini_saving_rate(self):
        return self._ptr.IniSavingRate

    @ini_saving_rate.setter
    def ini_saving_rate(self, float value):
        self._ptr.IniSavingRate = value

    @property
    def log_file_name(self):
        return _from_bytes(self._ptr.LogFilename)

    @log_file_name.setter
    def log_file_name(self, value):
        assert (value is None or isinstance(value, str) or isinstance(value, bytes)), "`log_file_name` must be a string or None"
        value_bytes = None
        if value is None: value_bytes = b''
        elif isinstance(value, str): value_bytes = _bytes(value)
        else: value_bytes = value

        self._keep_logfile_alive = value_bytes
        self._ptr.LogFilename = value_bytes

    @property
    def ini_file_name(self):
        return _from_bytes(self._ptr.IniFilename)

    @ini_file_name.setter
    def ini_file_name(self, value):
        assert (value is None or isinstance(value, str) or isinstance(value, bytes)), "`ini_file_name` must be a string or None"
        value_bytes = None
        if value is None: value_bytes = b''
        elif isinstance(value, str): value_bytes = _bytes(value)
        else: value_bytes = value

        self._keep_ini_alive = value_bytes
        self._ptr.IniFilename = value_bytes

    @property
    def mouse_double_click_time(self):
        return self._ptr.MouseDoubleClickTime

    @mouse_double_click_time.setter
    def mouse_double_click_time(self, float value):
        self._ptr.MouseDoubleClickTime = value

    @property
    def mouse_double_click_max_distance(self):
        return self._ptr.MouseDoubleClickMaxDist

    @mouse_double_click_max_distance.setter
    def mouse_double_click_max_distance(self, float value):
        self._ptr.MouseDoubleClickMaxDist = value

    @property
    def mouse_drag_threshold(self):
        return self._ptr.MouseDragThreshold

    @mouse_drag_threshold.setter
    def mouse_drag_threshold(self, float value):
        self._ptr.MouseDragThreshold = value

    @property
    def key_map(self):
        cdef cvarray key_map = cvarray(
            shape=(enums.ImGuiKey_COUNT,),
            format='i',
            itemsize=sizeof(int),
            allocate_buffer=False
        )
        key_map.data = <char*>self._ptr.KeyMap
        return key_map

    @property
    def key_repeat_delay(self):
        return self._ptr.KeyRepeatDelay

    @key_repeat_delay.setter
    def key_repeat_delay(self, float value):
        self._ptr.KeyRepeatDelay = value

    @property
    def key_repeat_rate(self):
        return self._ptr.KeyRepeatRate

    @key_repeat_rate.setter
    def key_repeat_rate(self, float value):
        self._ptr.KeyRepeatRate = value

    @property
    def fonts(self):
        return self._fonts

    @property
    def font_global_scale(self):
        return self._ptr.FontGlobalScale

    @font_global_scale.setter
    def font_global_scale(self, float value):
        self._ptr.FontGlobalScale = value

    @property
    def font_allow_user_scaling(self):
        return self._ptr.FontAllowUserScaling

    @font_allow_user_scaling.setter
    def font_allow_user_scaling(self, cimgui.bool value):
        self._ptr.FontAllowUserScaling = value

    @property
    def display_fb_scale(self):
        return _cast_ImVec2_tuple(self._ptr.DisplayFramebufferScale)

    @display_fb_scale.setter
    def display_fb_scale(self, value):
        self._ptr.DisplayFramebufferScale = _cast_tuple_ImVec2(value)

    # DEPRECIATED
    #@property
    #def display_visible_min(self):
    #    return _cast_ImVec2_tuple(self._ptr.DisplayVisibleMin)

    # DEPRECIATED
    #@display_visible_min.setter
    #def display_visible_min(self,  value):
    #    self._ptr.DisplayVisibleMin = _cast_tuple_ImVec2(value)

    # DEPRECIATED
    #@property
    #def display_visible_max(self):
    #    return _cast_ImVec2_tuple(self._ptr.DisplayVisibleMax)

    # DEPRECIATED
    #@display_visible_max.setter
    #def display_visible_max(self,  value):
    #    self._ptr.DisplayVisibleMax = _cast_tuple_ImVec2(value)

    @property
    def config_mac_osx_behaviors(self):
        return self._ptr.ConfigMacOSXBehaviors

    @config_mac_osx_behaviors.setter
    def config_mac_osx_behaviors(self, cimgui.bool value):
        self._ptr.ConfigMacOSXBehaviors = value

    @property
    def config_cursor_blink(self):
        return self._ptr.ConfigInputTextCursorBlink

    @config_cursor_blink.setter
    def config_cursor_blink(self, cimgui.bool value):
        self._ptr.ConfigInputTextCursorBlink = value
    
    @property
    def config_drag_click_to_input_text(self):
        return self._ptr.ConfigDragClickToInputText
    
    @config_drag_click_to_input_text.setter
    def config_drag_click_to_input_text(self, cimgui.bool value):
        self._ptr.ConfigDragClickToInputText = value

    # RENAMED from config_resize_windows_from_edges
    @property
    def config_windows_resize_from_edges(self):
        return self._ptr.ConfigWindowsResizeFromEdges
    
    # RENAMED from config_resize_windows_from_edges
    @config_windows_resize_from_edges.setter
    def config_windows_resize_from_edges(self, cimgui.bool value):
        self._ptr.ConfigWindowsResizeFromEdges = value

    @property
    def config_windows_move_from_title_bar_only(self):
        return self._ptr.ConfigWindowsMoveFromTitleBarOnly
    
    @config_windows_move_from_title_bar_only.setter
    def config_windows_move_from_title_bar_only(self, cimgui.bool value):
        self._ptr.ConfigWindowsMoveFromTitleBarOnly = value

    @property
    def config_memory_compact_timer(self):
        return self._ptr.ConfigMemoryCompactTimer
    
    @config_memory_compact_timer.setter
    def config_memory_compact_timer(self, float value):
        self._ptr.ConfigMemoryCompactTimer = value

    @staticmethod
    cdef const char* _get_clipboard_text(void* user_data):
        text = _io_clipboard[<uintptr_t>cimgui.GetCurrentContext()]['_get_clipboard_text_fn']()
        
        # get_clipboard_text_fn() may return None
        # (e.g. if the user copied non text data)
        if text is None:
            return ""
        
        if type(text) is bytes:
            return text
        return _bytes(text)

    @property
    def get_clipboard_text_fn(self):
        return _io_clipboard[<uintptr_t>cimgui.GetCurrentContext()]['_get_clipboard_text_fn']

    @get_clipboard_text_fn.setter
    def get_clipboard_text_fn(self, func):
        if callable(func):
            _io_clipboard[<uintptr_t>cimgui.GetCurrentContext()]['_get_clipboard_text_fn'] = func
            self._ptr.GetClipboardTextFn = self._get_clipboard_text
        else:
            raise ValueError("func is not a callable: %s" % str(func))

    @staticmethod
    cdef void _set_clipboard_text(void* user_data, const char* text):
        _io_clipboard[<uintptr_t>cimgui.GetCurrentContext()]['_set_clipboard_text_fn'](_from_bytes(text))

    @property
    def set_clipboard_text_fn(self):
        return _io_clipboard[<uintptr_t>cimgui.GetCurrentContext()]['_set_clipboard_text_fn']

    @set_clipboard_text_fn.setter
    def set_clipboard_text_fn(self, func):
        if callable(func):
            _io_clipboard[<uintptr_t>cimgui.GetCurrentContext()]['_set_clipboard_text_fn'] = func
            self._ptr.SetClipboardTextFn = self._set_clipboard_text
        else:
            raise ValueError("func is not a callable: %s" % str(func))
    
    @property
    def mouse_pos(self):
        return _cast_ImVec2_tuple(self._ptr.MousePos)

    @mouse_pos.setter
    def mouse_pos(self, value):
        self._ptr.MousePos = _cast_tuple_ImVec2(value)

    @property
    def mouse_down(self):
        # todo: consider adding setter despite the fact that it can be
        # todo: modified in place
        cdef cvarray mouse_down = cvarray(
            shape=(5,),
            format='b',
            itemsize=sizeof(bool),
            allocate_buffer=False
        )
        mouse_down.data = <char*>self._ptr.MouseDown
        return mouse_down

    @property
    def mouse_wheel(self):
        return self._ptr.MouseWheel

    @mouse_wheel.setter
    def mouse_wheel(self, float value):
        self._ptr.MouseWheel = value

    @property
    def mouse_wheel_horizontal(self):
        return self._ptr.MouseWheelH

    @mouse_wheel_horizontal.setter
    def mouse_wheel_horizontal(self, float value):
        self._ptr.MouseWheelH = value

    @property
    def mouse_draw_cursor(self):
        return self._ptr.MouseDrawCursor

    @mouse_draw_cursor.setter
    def mouse_draw_cursor(self, cimgui.bool value):
        self._ptr.MouseDrawCursor = value

    @property
    def key_ctrl(self):
        return self._ptr.KeyCtrl

    @key_ctrl.setter
    def key_ctrl(self, cimgui.bool value):
        self._ptr.KeyCtrl = value

    @property
    def key_shift(self):
        return self._ptr.KeyShift

    @key_shift.setter
    def key_shift(self, cimgui.bool value):
        self._ptr.KeyShift = value

    @property
    def key_alt(self):
        return self._ptr.KeyAlt

    @key_alt.setter
    def key_alt(self, cimgui.bool value):
        self._ptr.KeyAlt = value

    @property
    def key_super(self):
        return self._ptr.KeySuper

    @key_super.setter
    def key_super(self, cimgui.bool value):
        self._ptr.KeySuper = value

    @property
    def keys_down(self):
        # todo: consider adding setter despite the fact that it can be
        # todo: modified in place
        cdef cvarray keys_down = cvarray(
            shape=(512,),
            format='b',
            itemsize=sizeof(bool),
            allocate_buffer=False
        )
        keys_down.data = <char*>self._ptr.KeysDown
        return keys_down
        
    @property
    def nav_inputs(self):
        cdef cvarray nav_inputs = cvarray(
            shape=(enums.ImGuiNavInput_COUNT,),
            format='f',
            itemsize=sizeof(float),
            allocate_buffer=False
        )
        nav_inputs.data = <char*>self._ptr.NavInputs
        return nav_inputs

    def add_input_character(self, unsigned int c):
        self._ptr.AddInputCharacter(c)
    
    def add_input_character_utf16(self, str utf16_chars):
        self._ptr.AddInputCharacterUTF16(_bytes(utf16_chars))

    def add_input_characters_utf8(self, str utf8_chars):
        self._ptr.AddInputCharactersUTF8(_bytes(utf8_chars))

    def clear_input_characters(self):
        self._ptr.ClearInputCharacters()

    # ... mapping of output properties ...
    @property
    def want_capture_mouse(self):
        return self._ptr.WantCaptureMouse

    @property
    def want_capture_keyboard(self):
        return self._ptr.WantCaptureKeyboard

    @property
    def want_text_input(self):
        return self._ptr.WantTextInput

    @property
    def want_set_mouse_pos(self):
        return self._ptr.WantSetMousePos

    @property
    def want_save_ini_settings(self):
        return self._ptr.WantSaveIniSettings

    @property
    def nav_active(self):
        return self._ptr.NavActive

    @property
    def nav_visible(self):
        return self._ptr.NavVisible

    @property
    def framerate(self):
        return self._ptr.Framerate

    @property
    def metrics_render_vertices(self):
        return self._ptr.MetricsRenderVertices

    @property
    def metrics_render_indices(self):
        return self._ptr.MetricsRenderIndices

    @property
    def metrics_render_windows(self):
        return self._ptr.MetricsRenderWindows

    @property
    def metrics_active_windows(self):
        return self._ptr.MetricsActiveWindows

    @property
    def metrics_active_allocations(self):
        return self._ptr.MetricsActiveAllocations

    @property
    def mouse_delta(self):
        return _cast_ImVec2_tuple(self._ptr.MouseDelta)
        
cdef class _callback_user_info(object):
    
    cdef object callback_fn
    cdef user_data

    def __init__(self):
        pass
    
    def __cinit__(self):
        text_input_buffer = NULL
        text_input_buffer_size = 0
    
    def populate(self, callback_fn, user_data):
        if callable(callback_fn):
            self.callback_fn = callback_fn
            self.user_data = user_data
        else:
            raise ValueError("callback_fn is not a callable: %s" % str(callback_fn))
    
    cdef set_text_input_buffer(self, char* text_input_buffer, int text_input_buffer_size):
        self.text_input_buffer = text_input_buffer
        self.text_input_buffer_size = text_input_buffer_size

cdef class _InputTextSharedBuffer(object):

    cdef char* buffer
    cdef int size
    cdef int capacity

    def __cinit__(self):
        self.buffer = NULL
        self.size = 0
        self.capacity = 0
    
    cdef reserve_memory(self, int buffer_size):
        if self.buffer is NULL:
            self.buffer = <char*>malloc(buffer_size*sizeof(char))
            self.size = buffer_size
            self.capacity = buffer_size
        elif buffer_size > self.capacity:
            while self.capacity < buffer_size:
                self.capacity = self.capacity * 2
            self.buffer = <char*>realloc(self.buffer, self.capacity*sizeof(char))
            self.size = buffer_size
        else:
            self.size = buffer_size
    
    cdef free_memory(self):
        if self.buffer != NULL:
            free(self.buffer)
            self.buffer = NULL
            self.size = 0
            self.capacity = 0

    def __dealloc__(self):
        self.free_memory()

cdef _InputTextSharedBuffer _input_text_shared_buffer = _InputTextSharedBuffer() 
    
cdef int _ImGuiInputTextCallback(cimgui.ImGuiInputTextCallbackData* data):
    cdef _ImGuiInputTextCallbackData callback_data = _ImGuiInputTextCallbackData.from_ptr(data)
    callback_data._require_pointer()
    
    if data.EventFlag == enums.ImGuiInputTextFlags_CallbackResize:
        if data.BufSize != _input_text_shared_buffer.size:
            _input_text_shared_buffer.reserve_memory(data.BufSize)
            data.Buf = _input_text_shared_buffer.buffer

    cdef ret = (<_callback_user_info>callback_data._ptr.UserData).callback_fn(callback_data)
    return ret if ret is not None else 0

cdef int _ImGuiInputTextOnlyResizeCallback(cimgui.ImGuiInputTextCallbackData* data):
    # This callback is used internally if user asks for buffer resizing but does not provide any python callback function.

    if data.EventFlag == enums.ImGuiInputTextFlags_CallbackResize:
        if data.BufSize != _input_text_shared_buffer.size:
            _input_text_shared_buffer.reserve_memory(data.BufSize)
            data.Buf = _input_text_shared_buffer.buffer

    return 0
    
cdef class _ImGuiInputTextCallbackData(object):
    
    cdef cimgui.ImGuiInputTextCallbackData* _ptr

    def __init__(self):
        pass

    @staticmethod
    cdef from_ptr(cimgui.ImGuiInputTextCallbackData* ptr):
        if ptr == NULL:
            return None

        instance = _ImGuiInputTextCallbackData()
        instance._ptr = ptr
        return instance

    def _require_pointer(self):
        if self._ptr == NULL:
            raise RuntimeError(
                "%s improperly initialized" % self.__class__.__name__
            )

        return self._ptr != NULL
        
    @property
    def event_flag(self):
        self._require_pointer()
        return self._ptr.EventFlag
    
    @property
    def flags(self):
        self._require_pointer()
        return self._ptr.Flags
        
    @property
    def user_data(self):
        self._require_pointer()
        return (<_callback_user_info>self._ptr.UserData).user_data
    
    @property
    def event_char(self):
        self._require_pointer()
        return chr(self._ptr.EventChar)
    
    @event_char.setter
    def event_char(self, str event_char):
        self._require_pointer()
        self._ptr.EventChar = ord(event_char)
    
    @property
    def event_key(self):
        self._require_pointer()
        return self._ptr.EventKey
    
    @property
    def buffer(self):
        self._require_pointer()
        return _from_bytes(self._ptr.Buf)
    
    @buffer.setter
    def buffer(self, str buffer):
        self._require_pointer()
        _buffer = _bytes(buffer)
        _buffer_length = len(_buffer)
        if _buffer_length < self._ptr.BufSize:
            # Note: When copying several characters at once, there is this
            #       one frame where _ptr.BufSize is not yet updated (bug?).
            #       thus we skip it here.
            strncpy(self._ptr.Buf, _buffer, _buffer_length)
            self._ptr.BufTextLen = _buffer_length
            self._ptr.BufDirty = True

    @property
    def buffer_text_length(self):
        self._require_pointer()
        return self._ptr.BufTextLen
    
    @property
    def buffer_size(self):
        self._require_pointer()
        return self._ptr.BufSize
    
    @property
    def buffer_dirty(self):
        self._require_pointer()
        return self._ptr.BufDirty
        
    @buffer_dirty.setter
    def buffer_dirty(self, bool dirty):
        self._require_pointer()
        self._ptr.BufDirty = dirty
    
    @property
    def cursor_pos(self):
        self._require_pointer()
        return self._ptr.CursorPos
        
    @cursor_pos.setter
    def cursor_pos(self, int pos):
        self._require_pointer()
        self._ptr.CursorPos = pos
    
    @property
    def selection_start(self):
        self._require_pointer()
        return self._ptr.SelectionStart
        
    @selection_start.setter
    def selection_start(self, int start):
        self._require_pointer()
        self._ptr.SelectionStart = start
    
    @property
    def selection_end(self):
        self._require_pointer()
        return self._ptr.SelectionEnd
        
    @selection_end.setter
    def selection_end(self, int end):
        self._require_pointer()
        self._ptr.SelectionEnd = end
    
    def delete_chars(self, int pos, int bytes_count):
        self._require_pointer()
        self._ptr.DeleteChars(pos, bytes_count)
        
    def insert_chars(self, int pos, str text):
        self._require_pointer()
        self._ptr.InsertChars(pos, _bytes(text))
    
    def select_all(self):
        self._require_pointer()
        self._ptr.SelectAll()
    
    def clear_selection(self):
        self._require_pointer()
        self._ptr.ClearSelection()
        
    def has_selection(self):
        self._require_pointer()
        return self._ptr.HasSelection()
        
        

cdef void _ImGuiSizeCallback(cimgui.ImGuiSizeCallbackData* data):
    cdef _ImGuiSizeCallbackData callback_data = _ImGuiSizeCallbackData.from_ptr(data)
    callback_data._require_pointer()
    (<_callback_user_info>callback_data._ptr.UserData).callback_fn(callback_data)
    return
    
cdef class _ImGuiSizeCallbackData(object):
    
    cdef cimgui.ImGuiSizeCallbackData* _ptr

    def __init__(self):
        pass

    @staticmethod
    cdef from_ptr(cimgui.ImGuiSizeCallbackData* ptr):
        if ptr == NULL:
            return None

        instance = _ImGuiSizeCallbackData()
        instance._ptr = ptr
        return instance

    def _require_pointer(self):
        if self._ptr == NULL:
            raise RuntimeError(
                "%s improperly initialized" % self.__class__.__name__
            )

        return self._ptr != NULL
        
    @property
    def user_data(self):
        self._require_pointer()
        return (<_callback_user_info>self._ptr.UserData).user_data
    
    @property
    def pos(self):
        self._require_pointer()
        return _cast_ImVec2_tuple(self._ptr.Pos)
        
    @property
    def current_size(self):
        self._require_pointer()
        return _cast_ImVec2_tuple(self._ptr.CurrentSize)
    
    @property
    def desired_size(self):
        self._require_pointer()
        return _cast_ImVec2_tuple(self._ptr.DesiredSize)
    
    @desired_size.setter
    def desired_size(self, tuple size):
        self._require_pointer()
        self._ptr.DesiredSize = _cast_args_ImVec2(size[0], size[1])
       
_io_clipboard = {}
def get_io():
    return _IO()

def get_style():
    return GuiStyle.from_ref(cimgui.GetStyle())


def new_frame():
    """Start a new frame.

    After calling this you can submit any command from this point until
    next :any:`new_frame()` or :any:`render()`.

    .. wraps::
        void NewFrame()
    """
    get_current_context()._keepalive_cache.clear()
    cimgui.NewFrame()


def end_frame():
    """End a frame.

    ends the ImGui frame. automatically called by Render(), so most likely
    don't need to ever call that yourself directly. If you don't need to
    render you may call end_frame() but you'll have wasted CPU already.
    If you don't need to render, better to not create any imgui windows
    instead!

    .. wraps::
        void EndFrame()
    """
    cimgui.EndFrame()


def render():
    """Finalize frame, set rendering data, and run render callback (if set).

    .. wraps::
        void Render()
    """
    cimgui.Render()


def show_user_guide():
    """Show ImGui user guide editor.

    .. visual-example::
        :width: 700
        :height: 500
        :auto_layout:

        imgui.begin("Example: user guide")
        imgui.show_user_guide()
        imgui.end()


    .. wraps::
        void ShowUserGuide()
    """
    cimgui.ShowUserGuide()


def get_version():
    """Get the version of Dear ImGui.

    .. wraps::
        void GetVersion()
    """
    cdef const char* c_string = cimgui.GetVersion()
    cdef bytes py_string = c_string
    return c_string.decode("utf-8")


def style_colors_dark(GuiStyle dst = None):
    """Set the style to Dark.

       new, recommended style (default)

    .. wraps::
        void StyleColorsDark(ImGuiStyle* dst = NULL)
    """
    if dst:
        cimgui.StyleColorsDark(dst._ptr)
    else:
        cimgui.StyleColorsDark(NULL)


def style_colors_classic(GuiStyle dst = None):
    """Set the style to Classic.

       classic imgui style.

    .. wraps::
        void StyleColorsClassic(ImGuiStyle* dst = NULL)
    """
    if dst:
        cimgui.StyleColorsClassic(dst._ptr)
    else:
        cimgui.StyleColorsClassic(NULL)



def style_colors_light(GuiStyle dst = None):
    """Set the style to Light.

       best used with borders and a custom, thicker font

    .. wraps::
        void StyleColorsLight(ImGuiStyle* dst = NULL)
    """
    if dst:
        cimgui.StyleColorsLight(dst._ptr)
    else:
        cimgui.StyleColorsLight(NULL)


def show_style_editor(GuiStyle style=None):
    """Show ImGui style editor.

    .. visual-example::
        :width: 300
        :height: 300
        :auto_layout:

        imgui.begin("Example: my style editor")
        imgui.show_style_editor()
        imgui.end()

    Args:
        style (GuiStyle): style editor state container.

    .. wraps::
        void ShowStyleEditor(ImGuiStyle* ref = NULL)
    """
    if style:
        cimgui.ShowStyleEditor(style._ptr)
    else:
        cimgui.ShowStyleEditor()


def show_demo_window(closable=False):
    """Show ImGui demo window.

    .. visual-example::
        :width: 700
        :height: 600
        :auto_layout:

        imgui.show_demo_window()

    Args:
        closable (bool): define if window is closable.

    Returns:
        bool: True if window is not closed (False trigerred by close button).

    .. wraps::
        void ShowDemoWindow(bool* p_open = NULL)
    """
    cdef cimgui.bool opened = True

    if closable:
        cimgui.ShowDemoWindow(&opened)
    else:
        cimgui.ShowDemoWindow()

    return opened
    
def show_about_window(closable=False):
    """ Create About window. 
    Display Dear ImGui version, credits and build/system information.
    
    Args:
        closable (bool): define if window is closable
    
    Return:
        bool: True if window is not closed (False trigerred by close button).
    
    .. wraps::
        void ShowAboutWindow(bool* p_open = NULL)
    """
    cdef cimgui.bool opened = True
    
    if closable:
        cimgui.ShowAboutWindow(&opened)
    else:
        cimgui.ShowAboutWindow()
    
    return opened


def show_test_window():
    """Show ImGui demo window.

    .. visual-example::
        :width: 700
        :height: 600
        :auto_layout:

        imgui.show_test_window()

    .. wraps::
        void ShowDemoWindow()
    """
    cimgui.ShowDemoWindow()



def show_metrics_window(closable=False):
    """Show ImGui metrics window.

    .. visual-example::
        :width: 700
        :height: 200
        :auto_layout:

        imgui.show_metrics_window()

    Args:
        closable (bool): define if window is closable.

    Returns:
        bool: True if window is not closed (False trigerred by close button).

    .. wraps::
        void ShowMetricsWindow(bool* p_open = NULL)
    """
    cdef cimgui.bool opened = True

    if closable:
        cimgui.ShowMetricsWindow(&opened)
    else:
        cimgui.ShowMetricsWindow()

    return opened


def show_style_selector(str label):
    return cimgui.ShowStyleSelector(_bytes(label))


def show_font_selector(str label):
    cimgui.ShowFontSelector(_bytes(label))


cdef class _BeginEnd(object):
    """
    Return value of :func:`begin` exposing ``expanded`` and ``opened`` boolean attributes.
    See :func:`begin` for an explanation of these attributes and examples.

    For legacy support, the attributes can also be accessed by unpacking or indexing into this object.

    Can be used as a context manager (in a ``with`` statement) to automatically call :func:`end` to end the window
    created with :func:`begin` when the block ends, even if an exception is raised.

    This class is not intended to be instantiated by the user (thus the `_` name prefix).
    It should be obtained as the return value of the :func:`begin` function.
    """

    cdef readonly bool expanded
    cdef readonly bool opened

    def __cinit__(self, bool expanded, bool opened):
        self.expanded = expanded
        self.opened = opened

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        cimgui.End()

    def __getitem__(self, item):
        """For legacy support, returns ``(expanded, opened)[item]``."""
        return (self.expanded, self.opened)[item]

    def __iter__(self):
        """For legacy support, returns ``iter((expanded, opened))``."""
        return iter((self.expanded, self.opened))

    def __repr__(self):
        return "{}(expanded={}, opened={})".format(
            self.__class__.__name__, self.expanded, self.opened
        )

    def __eq__(self, other):
        if other.__class__ is self.__class__:
            return (self.expanded, self.opened) == (other.expanded, other.opened)
        return (self.expanded, self.opened) == other


def begin(str label, closable=False, cimgui.ImGuiWindowFlags flags=0):
    """Begin a window.

    .. visual-example::
        :auto_layout:

        with imgui.begin("Example: empty window"):
            pass

    Example::
        imgui.begin("Example: empty window")
        imgui.end()

    Args:
        label (str): label of the window.
        closable (bool): define if window is closable.
        flags: Window flags. See:
            :ref:`list of available flags <window-flag-options>`.

    Returns:
        _BeginEnd: ``(expanded, opened)`` struct of bools. If window is collapsed
        ``expanded==True``. The value of ``opened`` is always True for
        non-closable and open windows but changes state to False on close
        button click for closable windows. Use with ``with`` to automatically call
        :func:`end` when the block ends.

    .. wraps::
        Begin(
            const char* name,
            bool* p_open = NULL,
            ImGuiWindowFlags flags = 0
        )
    """
    cdef cimgui.bool opened = True

    return _BeginEnd.__new__(
        _BeginEnd,
        cimgui.Begin(_bytes(label), &opened if closable else NULL, flags),
        opened
    )


def get_draw_data():
    """Get draw data.

    valid after :any:`render()` and until the next call
    to :any:`new_frame()`.  This is what you have to render.

    Returns:
        _DrawData: draw data for all draw calls required to display gui

    .. wraps::
        ImDrawData* GetDrawData()
    """
    return _DrawData.from_ptr(cimgui.GetDrawData())


def end():
    """End a window.

    This finishes appending to current window, and pops it off the window
    stack. See: :any:`begin()`.

    .. wraps::
        void End()
    """
    cimgui.End()


cdef class _BeginEndChild(object):
    """
    Return value of :func:`begin_child` exposing ``visible`` boolean attribute.
    See :func:`begin_child` for an explanation and examples.

    Can be used as a context manager (in a ``with`` statement) to automatically
    call :func:`end_child` to end the child created with :func:`begin_child`
    when the block ends, even if an exception is raised.

    This class is not intended to be instantiated by the user (thus the `_` name prefix).
    It should be obtained as the return value of the :func:`begin_child` function.
    """

    cdef readonly bool visible

    def __cinit__(self, bool visible):
        self.visible = visible

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        cimgui.EndChild()

    def __bool__(self):
        """For legacy support, returns ``visible``."""
        return self.visible

    def __repr__(self):
        return "{}(visible={})".format(
            self.__class__.__name__, self.visible
        )

    def __eq__(self, other):
        if other.__class__ is self.__class__:
            return self.visible is other.visible
        return self.visible is other


ctypedef fused child_id:
    str
    cimgui.ImGuiID


def begin_child(
    child_id label, float width = 0, float height = 0, bool border = False,
    cimgui.ImGuiWindowFlags flags = 0
):
    """Begin a scrolling region.

    **Note:** sizing of child region allows for three modes:
    * ``0.0`` - use remaining window size
    * ``>0.0`` - fixed size
    * ``<0.0`` - use remaining window size minus abs(size)

    .. visual-example::
        :width: 200
        :height: 200
        :auto_layout:

        with imgui.begin("Example: child region"):
            with imgui.begin_child("region", 150, -50, border=True):
                imgui.text("inside region")
            imgui.text("outside region")

    Example::
        imgui.begin("Example: child region")

        imgui.begin_child("region", 150, -50, border=True)
        imgui.text("inside region")
        imgui.end_child()

        imgui.text("outside region")
        imgui.end()

    Args:
        label (str or int): Child region identifier.
        width (float): Region width. See note about sizing.
        height (float): Region height. See note about sizing.
        border (bool): True if should display border. Defaults to False.
        flags: Window flags. See:
            :ref:`list of available flags <window-flag-options>`.

    Returns:
        _BeginEndChild: Struct with ``visible`` bool attribute. Use with ``with``
        to automatically call :func:`end_child` when the block ends.`

    .. wraps::
        bool BeginChild(
            const char* str_id,
            const ImVec2& size = ImVec2(0,0),
            bool border = false,
            ImGuiWindowFlags flags = 0
        )

        bool BeginChild(
            ImGuiID id,
            const ImVec2& size = ImVec2(0,0),
            bool border = false,
            ImGuiWindowFlags flags = 0
        )
    """
    # note: we do not take advantage of C++ function overloading
    #       in order to take advantage of Python keyword arguments
    return _BeginEndChild.__new__(
        _BeginEndChild,
        cimgui.BeginChild(
            _bytes(label), _cast_args_ImVec2(width, height), border, flags
        )
    )
def end_child():
    """End scrolling region.
    Only call if ``begin_child().visible`` is True.

    .. wraps::
        void EndChild()
    """
    cimgui.EndChild()


def get_content_region_max():
    """Get current content boundaries in window coordinates.

    Typically window boundaries include scrolling, or current
    column boundaries.

    Returns:
        Vec2: content boundaries two-tuple ``(width, height)``

    .. wraps::
        ImVec2 GetContentRegionMax()
    """
    return _cast_ImVec2_tuple(cimgui.GetContentRegionMax())


def get_content_region_available():
    """Get available content region.

    It is shortcut for:

    .. code-block: python
        imgui.get_content_region_max() - imgui.get_cursor_position()

    Returns:
        Vec2: available content region size two-tuple ``(width, height)``

    .. wraps::
        ImVec2 GetContentRegionMax()
    """
    return _cast_ImVec2_tuple(cimgui.GetContentRegionAvail())


# OBSOLETED in 1.70 (from May 2019)
def get_content_region_available_width():
    """Get available content region width.

    Returns:
        float: available content region width.

    .. wraps::
        float GetContentRegionAvailWidth()
    """
    return cimgui.GetContentRegionAvailWidth()


def get_window_content_region_min():
    """Get minimal current window content boundaries in window coordinates.

    It translates roughly to: ``(0, 0) - Scroll``

    Returns:
        Vec2: content boundaries two-tuple ``(width, height)``

    .. wraps::
        ImVec2 GetWindowContentRegionMin()
    """
    return _cast_ImVec2_tuple(cimgui.GetWindowContentRegionMin())


def get_window_content_region_max():
    """Get maximal current window content boundaries in window coordinates.

    It translates roughly to: ``(0, 0) + Size - Scroll``

    Returns:
        Vec2: content boundaries two-tuple ``(width, height)``

    .. wraps::
        ImVec2 GetWindowContentRegionMin()
    """
    return _cast_ImVec2_tuple(cimgui.GetWindowContentRegionMax())


def get_window_content_region_width():
    """Get available current window content region width.

    Returns:
        float: available content region width.

    .. wraps::
        float GetWindowContentRegionWidth()
    """
    return cimgui.GetWindowContentRegionWidth()


def set_window_focus():
    """Set window to be focused

    Call inside :func:`begin()`.

    .. visual-example::
        :title: Window focus
        :height: 100

        imgui.begin("Window 1")
        imgui.end()

        imgui.begin("Window 2")
        imgui.set_window_focus()
        imgui.end()

    .. wraps::
        void SetWindowFocus()
    """
    cimgui.SetWindowFocus()

def set_window_focus_labeled(str label):
    """Set focus to the window named label

    Args:
        label(string): the name of the window that will be focused

    .. visual-example::
        :title: Window focus
        :height: 100

        imgui.set_window_focus_labeled("Window 2")

        imgui.begin("Window 1", True)
        imgui.text("Apples")
        imgui.end()

        imgui.begin("Window 2", True)
        imgui.text("Orange")
        imgui.end()

        imgui.begin("Window 3", True)
        imgui.text("Mango")
        imgui.end()

    .. wraps::
        void SetWindowFocus(
            const char* name
        )
    """
    cimgui.SetWindowFocus(_bytes(label))

def set_window_size(
    float width, float height, cimgui.ImGuiCond condition=ONCE):
    """Set window size

    Call inside :func:`begin()`.

    **Note:** usage of this function is not recommended. prefer using
    :func:`set_next_window_size()` as this may incur tearing and minor
    side-effects.

    Args:
        width (float): window width. Value 0.0 enables autofit.
        height (float): window height. Value 0.0 enables autofit.
        condition (:ref:`condition flag <condition-options>`): defines on which
            condition value should be set. Defaults to :any:`imgui.ONCE`.

    .. visual-example::
        :title: window sizing
        :height: 200

        imgui.begin("Window size")
        imgui.set_window_size(80, 180)
        imgui.end()

    .. wraps::
        void SetWindowSize(
            const ImVec2& size,
            ImGuiCond cond = 0,
        )
    """
    cimgui.SetWindowSize(_cast_args_ImVec2(width, height), condition)

def set_window_size_named(str label, float width, float height, cimgui.ImGuiCond condition = ONCE):
    """Set the window with label to some size

    Args:
        label(string): name of the window
        width(float): new width of the window
        height(float): new height of the window
        condition (:ref:`condition flag <condition-options>`): defines on which
            condition value should be set. Defaults to :any:`imgui.ONCE`.

    .. visual-example::
        :title: Window size
        :height: 200

        imgui.set_window_size_named("Window 1",100,100)
        imgui.set_window_size_named("Window 2",100,200)

        imgui.begin("Window 1")
        imgui.end()

        imgui.begin("Window 2")
        imgui.end()

    .. wraps::
        void SetWindowSize(
            const char* name,
            const ImVec2& size,
             ImGuiCond cond
        )
    
    """
    cimgui.SetWindowSize(
        _bytes(label),
        _cast_args_ImVec2(width, height),
        condition
    )

def get_scroll_x():
    """get scrolling amount [0..GetScrollMaxX()]

    Returns:
        float: the current scroll X value

    .. wraps::
        int GetScrollX()
    """
    return cimgui.GetScrollX()


def get_scroll_y():
    """get scrolling amount [0..GetScrollMaxY()]

    Returns:
        float: the current scroll Y value

    .. wraps::
        int GetScrollY()
    """
    return cimgui.GetScrollY()


def get_scroll_max_x():
    """get maximum scrolling amount ~~ ContentSize.X - WindowSize.X

    Returns:
        float: the maximum scroll X amount

    .. wraps::
        int GetScrollMaxX()
    """
    return cimgui.GetScrollMaxX()


def get_scroll_max_y():
    """get maximum scrolling amount ~~ ContentSize.X - WindowSize.X

    Returns:
        float: the maximum scroll Y amount

    .. wraps::
        int GetScrollMaxY()
    """
    return cimgui.GetScrollMaxY()


def set_scroll_x(float scroll_x):
    """set scrolling amount [0..SetScrollMaxX()]

    .. wraps::
        int SetScrollX(float)
    """
    cimgui.SetScrollX(scroll_x)


def set_scroll_y(float scroll_y):
    """set scrolling amount [0..SetScrollMaxY()]

    .. wraps::
        int SetScrollY(flot)
    """
    return cimgui.SetScrollY(scroll_y)


def set_window_font_scale(float scale):
    """Adjust per-window font scale for current window.

    Function should be called inside window context so after calling
    :any:`begin()`.

    Note: use ``get_io().font_global_scale`` if you want to scale all windows.

    .. visual-example::
        :auto_layout:
        :height: 100

        imgui.begin("Example: font scale")
        imgui.set_window_font_scale(2.0)
        imgui.text("Bigger font")
        imgui.end()

    Args:
        scale (float): font scale

    .. wraps::
        void SetWindowFontScale(float scale)
    """
    cimgui.SetWindowFontScale(scale)


def set_next_window_collapsed(
    cimgui.bool collapsed, cimgui.ImGuiCond condition=ALWAYS
):
    """Set next window collapsed state.

    .. visual-example::
        :auto_layout:
        :height: 60
        :width: 400

        imgui.set_next_window_collapsed(True)
        imgui.begin("Example: collapsed window")
        imgui.end()


    Args:
        collapsed (bool): set to True if window has to be collapsed.
        condition (:ref:`condition flag <condition-options>`): defines on
            which condition value should be set. Defaults to
            :any:`imgui.ALWAYS`.

    .. wraps::
         void SetNextWindowCollapsed(
             bool collapsed, ImGuiCond cond = 0
         )

    """
    cimgui.SetNextWindowCollapsed(collapsed, condition)


def set_next_window_focus():
    """Set next window to be focused (most front).

    .. wraps::
        void SetNextWindowFocus()
    """
    cimgui.SetNextWindowFocus()


def set_next_window_bg_alpha(float alpha):
    """set next window background color alpha. helper to easily modify ImGuiCol_WindowBg/ChildBg/PopupBg.

    .. wraps::
        void SetNextWindowBgAlpha(float)
    """
    cimgui.SetNextWindowBgAlpha(alpha)


def get_window_draw_list():
    """Get the draw list associated with the window, to append your own drawing primitives

    It may be useful if you want to do your own drawing via the :class:`_DrawList`
    API.

    .. visual-example::
        :auto_layout:
        :height: 100
        :width: 200
        :click: 10 10


        pos_x = 10
        pos_y = 10
        sz = 20

        draw_list = imgui.get_window_draw_list()

        for i in range(0, imgui.COLOR_COUNT):
            name = imgui.get_style_color_name(i);
            draw_list.add_rect_filled(pos_x, pos_y, pos_x+sz, pos_y+sz, imgui.get_color_u32_idx(i));
            imgui.dummy(sz, sz);
            imgui.same_line();

        rgba_color = imgui.get_color_u32_rgba(1, 1, 0, 1);
        draw_list.add_rect_filled(pos_x, pos_y, pos_x+sz, pos_y+sz, rgba_color);


    Returns:
        ImDrawList*

    .. wraps::
        ImDrawList* GetWindowDrawList()
    """
    return _DrawList.from_ptr(cimgui.GetWindowDrawList())


# OBSOLETED in 1.69 (from Mar 2019)
def get_overlay_draw_list():
    """Get a special draw list that will be drawn last (over all windows).

    Useful for drawing overlays.

    Returns:
        ImDrawList*

    .. wraps::
        ImDrawList* GetWindowDrawList()
    """
    return _DrawList.from_ptr(cimgui.GetOverlayDrawList())


def get_window_position():
    """Get current window position.

    It may be useful if you want to do your own drawing via the DrawList
    api.

    Returns:
        Vec2: two-tuple of window coordinates in screen space.

    .. wraps::
        ImVec2 GetWindowPos()
    """
    return _cast_ImVec2_tuple(cimgui.GetWindowPos())


def get_window_size():
    """Get current window size.

    Returns:
        Vec2: two-tuple of window dimensions.

    .. wraps::
        ImVec2 GetWindowSize()
    """
    return _cast_ImVec2_tuple(cimgui.GetWindowSize())


def get_window_width():
    """Get current window width.

    Returns:
        float: width of current window.

    .. wraps::
        float GetWindowWidth()
    """
    return cimgui.GetWindowWidth()


def get_window_height():
    """Get current window height.

    Returns:
        float: height of current window.

    .. wraps::
        float GetWindowHeight()
    """
    return cimgui.GetWindowHeight()


def set_next_window_position(
    float x, float y, cimgui.ImGuiCond condition=ALWAYS, float pivot_x=0, float pivot_y=0
):
    """Set next window position.

    Call before :func:`begin()`.

    Args:
        x (float): x window coordinate
        y (float): y window coordinate
        condition (:ref:`condition flag <condition-options>`): defines on which
            condition value should be set. Defaults to :any:`imgui.ALWAYS`.
        pivot_x (float): pivot x window coordinate
        pivot_y (float): pivot y window coordinate

    .. visual-example::
        :title: window positioning
        :height: 50

        imgui.set_next_window_size(20, 20)

        for index in range(5):
            imgui.set_next_window_position(index * 40, 5)
            imgui.begin(str(index))
            imgui.end()

    .. wraps::
        void SetNextWindowPos(
            const ImVec2& pos,
            ImGuiCond cond = 0,
            const ImVec2& pivot = ImVec2(0,0)
        )

    """
    cimgui.SetNextWindowPos(_cast_args_ImVec2(x, y), condition, _cast_args_ImVec2(pivot_x, pivot_y))


def set_next_window_size(
    float width, float height, cimgui.ImGuiCond condition=ALWAYS
):
    """Set next window size.

    Call before :func:`begin()`.

    Args:
        width (float): window width. Value 0.0 enables autofit.
        height (float): window height. Value 0.0 enables autofit.
        condition (:ref:`condition flag <condition-options>`): defines on which
            condition value should be set. Defaults to :any:`imgui.ALWAYS`.

    .. visual-example::
        :title: window sizing
        :height: 200

        imgui.set_next_window_position(io.display_size.x * 0.5, io.display_size.y * 0.5, 1, pivot_x = 0.5, pivot_y = 0.5)

        imgui.set_next_window_size(80, 180)
        imgui.begin("High")
        imgui.end()


    .. wraps::
        void SetNextWindowSize(
            const ImVec2& size, ImGuiCond cond = 0
        )
    """
    cimgui.SetNextWindowSize(_cast_args_ImVec2(width, height), condition)

# Useful for non trivial constraints
cdef _callback_user_info _global_next_window_size_constraints_callback_user_info = _callback_user_info()
def set_next_window_size_constraints(
    tuple size_min,
    tuple size_max,
    object callback = None,
    user_data = None):
    """Set next window size limits. use -1,-1 on either X/Y axis to preserve the current size.
    Sizes will be rounded down.

    Call before :func:`begin()`.

    Args:
        size_min (tuple): Minimum window size, use -1 to conserve current size
        size_max (tuple): Maximum window size, use -1 to conserve current size
        callback (callable): a callable.
            Callable takes an imgui._ImGuiSizeCallbackData object as argument
            Callable should return None
        user_data: Any data that the user want to use in the callback.

    .. visual-example::
        :title: Window size constraints
        :height: 200

        imgui.set_next_window_size_constraints((175,50), (200, 100))
        imgui.begin("Constrained Window")
        imgui.text("...")
        imgui.end()

    .. wraps::
        void SetNextWindowSizeConstraints(
            const ImVec2& size_min,
            const ImVec2& size_max,
            ImGuiSizeCallback custom_callback = NULL,
            void* custom_callback_user_data = NULL
        )

    """
    cdef cimgui.ImGuiSizeCallback _callback = NULL
    cdef void *_user_data = NULL
    if callback is not None:
        _callback = _ImGuiSizeCallback
        _global_next_window_size_constraints_callback_user_info.populate(callback, user_data)
        _user_data = <void*>_global_next_window_size_constraints_callback_user_info

    cimgui.SetNextWindowSizeConstraints(
        _cast_tuple_ImVec2(size_min),
        _cast_tuple_ImVec2(size_max),
        _callback, _user_data)

def set_next_window_content_size(float width, float height):
    """Set content size of the next window. Show scrollbars
       if content doesn't fit in the window

    Call before :func:`begin()`.

    Args:
        width(float): width of the content area
        height(float): height of the content area

    .. visual-example::
        :title: Content Size Demo
        :height: 30

        imgui.set_window_size(20,20)
        imgui.set_next_window_content_size(100,100)

        imgui.begin("Window", True)
        imgui.text("Some example text")
        imgui.end()

    .. wraps::
        void SetNextWindowContentSize(
            const ImVec2& size
        )
    """
    cimgui.SetNextWindowContentSize(_cast_args_ImVec2(width, height))

def set_window_position(float x, float y, cimgui.ImGuiCond condition = ALWAYS):
    """Set the size of the current window

    Call inside: func: 'begin()'

    Args:
        x(float): position on the x axis
        y(float): position on the y axis
        condition (:ref:`condition flag <condition-options>`): defines on which
            condition value should be set. Defaults to :any:`imgui.ALWAYS`.

    .. visual-example::
        :title: Window Size Demo
        :height: 200

        imgui.begin("Window 1")
        imgui.set_window_position(20,20)
        imgui.end()

        imgui.begin("Window 2")
        imgui.set_window_position(20,50)
        imgui.end()

    .. wraps::
        void SetWindowPos(
            const ImVec2& pos,
            ImGuiCond cond
        )
    """
    cimgui.SetWindowPos(_cast_args_ImVec2(x,y), condition)

def set_window_position_labeled(str label, float x, float y, cimgui.ImGuiCond condition = ALWAYS):
    """Set the size of the window with label

    Args:
        label(str): name of the window to be resized
        x(float): position on the x axis
        y(float): position on the y axis
        condition (:ref:`condition flag <condition-options>`): defines on which
            condition value should be set. Defaults to :any:`imgui.ALWAYS`.

    .. visual-example::
        :title: Window Size Demo
        :height: 200

        imgui.set_window_position_labeled("Window 1", 20, 50)
        imgui.set_window_position_labeled("Window 2", 20, 100)

        imgui.begin("Window 1")
        imgui.end()

        imgui.begin("Window 2")
        imgui.end()

    .. wraps::
        void SetWindowPos(
            const char* name,
            const ImVec2& pos,
            ImGuiCond cond
        )
    
    """
    cimgui.SetWindowPos(
        _bytes(label),
        _cast_args_ImVec2(x,y),
        condition
    )

def set_window_collapsed(bool collapsed, cimgui.ImGuiCond condition = ALWAYS):
    """Set the current window to be collapsed

    Call inside: func: 'begin()'

    Args:
        collapsed(bool): set boolean for collapsing the window. Set True for closed
        condition (:ref:`condition flag <condition-options>`): defines on which
            condition value should be set. Defaults to :any:`imgui.ALWAYS`.

    .. visual-example::
        :title: Window Collapsed Demo
        :height: 200

        imgui.begin("Window 1")
        imgui.set_window_collapsed(True)
        imgui.end()

    .. wraps::
        void SetWindowCollapsed(
            bool collapsed,
            ImGuiCond cond
        )
    """
    cimgui.SetWindowCollapsed(collapsed, condition)

def set_window_collapsed_labeled(str label, bool collapsed, cimgui.ImGuiCond condition = ALWAYS):
    """Set window with label to collapse

    Args:
        label(string): name of the window
        collapsed(bool): set boolean for collapsing the window. Set True for closed
        condition (:ref:`condition flag <condition-options>`): defines on which
            condition value should be set. Defaults to :any:`imgui.ALWAYS`.

    .. visual-example::
        :title: Window Collapsed Demo
        :height: 200

        imgui.set_window_collapsed_labeled("Window 1", True)
        imgui.begin("Window 1")
        imgui.end()

    .. wraps::
        void SetWindowCollapsed(
            const char* name,
            bool collapsed,
            ImGuiCond cond
        )
    """
    cimgui.SetWindowCollapsed(_bytes(label), collapsed, condition)


def is_window_collapsed():
    """Check if current window is collapsed.

    Returns:
        bool: True if window is collapsed
    """
    return cimgui.IsWindowCollapsed()


def is_window_appearing():
    """Check if current window is appearing.

    Returns:
        bool: True if window is appearing
    """
    return cimgui.IsWindowAppearing()



def tree_node(str text, cimgui.ImGuiTreeNodeFlags flags=0):
    """Draw a tree node.

    Returns 'true' if the node is drawn, call :func:`tree_pop()` to finish.

    .. visual-example::
        :auto_layout:
        :height: 100
        :width: 200
        :click: 80 40

        imgui.begin("Example: tree node")
        if imgui.tree_node("Expand me!", imgui.TREE_NODE_DEFAULT_OPEN):
            imgui.text("Lorem Ipsum")
            imgui.tree_pop()
        imgui.end()

    Args:
        text (str): Tree node label
        flags: TreeNode flags. See:
            :ref:`list of available flags <treenode-flag-options>`.

    Returns:
        bool: True if tree node is displayed (opened).

    .. wraps::
        bool TreeNode(const char* label)
        bool TreeNodeEx(const char* label, ImGuiTreeNodeFlags flags = 0)
    """
    return cimgui.TreeNodeEx(_bytes(text), flags)


def tree_pop():
    """Called to clear the tree nodes stack and return back the identation.

    For a tree example see :func:`tree_node()`.
    Same as calls to :func:`unindent()` and :func:`pop_id()`.

    .. wraps::
        void TreePop()
    """
    cimgui.TreePop()

def get_tree_node_to_label_spacing():
    """Horizontal distance preceding label when using ``tree_node*()``
    or ``bullet() == (g.FontSize + style.FramePadding.x*2)`` for a
    regular unframed TreeNode

    Returns:
        float: spacing

    .. visual-example::
        :auto_layout:
        :height: 100
        :width: 200

        imgui.begin("TreeNode")
        imgui.text("<- 0px offset here")
        if imgui.tree_node("Expand me!", imgui.TREE_NODE_DEFAULT_OPEN):
            imgui.text("<- %.2fpx offset here" % imgui.get_tree_node_to_label_spacing())
            imgui.tree_pop()
        imgui.end()

    .. wraps::
        float GetTreeNodeToLabelSpacing()
    """
    return cimgui.GetTreeNodeToLabelSpacing()

def collapsing_header(
    str text,
    visible=None,
    cimgui.ImGuiTreeNodeFlags flags=0
):
    """Collapsable/Expandable header view.

    Returns 'true' if the header is open. Doesn't indent or push to stack,
    so no need to call any pop function.

    .. visual-example::
        :auto_layout:
        :height: 100
        :width: 200
        :click: 80 40

        visible = True

        imgui.begin("Example: collapsing header")
        expanded, visible = imgui.collapsing_header("Expand me!", visible)

        if expanded:
            imgui.text("Now you see me!")
        imgui.end()

    Args:
        text (str): Tree node label
        visible (bool or None): Force visibility of a header. If set to True
            shows additional (X) close button. If set to False header is not
            visible at all. If set to None header is always visible and close
            button is not displayed.
        flags: TreeNode flags. See:
            :ref:`list of available flags <treenode-flag-options>`.

    Returns:
        tuple: a ``(expanded, visible)`` two-tuple indicating if item was
        expanded and whether the header is visible or not (only if ``visible``
        input argument is True/False).

    .. wraps::
        bool CollapsingHeader(const char* label, ImGuiTreeNodeFlags flags = 0)

        bool CollapsingHeader(
            const char* label,
            bool* p_visible,
            ImGuiTreeNodeFlags flags = 0
        )
    """
    cdef cimgui.bool inout_opened = visible
    if visible is None:
        clicked = cimgui.CollapsingHeader(_bytes(text), NULL, flags)
    else:
        clicked = cimgui.CollapsingHeader(_bytes(text), &inout_opened, flags)
    return clicked, None if visible is None else inout_opened

def set_next_item_open(bool is_open, cimgui.ImGuiCond condition = 0):
    """Set next TreeNode/CollapsingHeader open state.

    Args:
        is_open (bool):
        condition (:ref:`condition flag <condition-options>`): defines on which
            condition value should be set. Defaults to :any:`imgui.NONE`.

    .. wraps::
        void SetNextItemOpen(bool is_open, ImGuiCond cond = 0)
    """
    cimgui.SetNextItemOpen(is_open, condition)

def selectable(
    str label,
    selected=False,
    cimgui.ImGuiTreeNodeFlags flags=0,
    width=0,
    height=0
):
    """Selectable text. Returns 'true' if the item is pressed.

    Width of 0.0 will use the available width in the parent container.
    Height of 0.0 will use the available height in the parent container.

    .. visual-example::
        :auto_layout:
        :height: 200
        :width: 200
        :click: 80 40

        selected = [False, False]
        imgui.begin("Example: selectable")
        _, selected[0] = imgui.selectable(
            "1. I am selectable", selected[0]
        )
        _, selected[1] = imgui.selectable(
            "2. I am selectable too", selected[1]
        )
        imgui.text("3. I am not selectable")
        imgui.end()

    Args:
        label (str): The label.
        selected (bool): defines if item is selected or not.
        flags: Selectable flags. See:
            :ref:`list of available flags <selectable-flag-options>`.
        width (float): button width.
        height (float): button height.

    Returns:
        tuple: a ``(opened, selected)`` two-tuple indicating if item was
        clicked by the user and the current state of item.

    .. wraps::
        bool Selectable(
            const char* label,
            bool selected = false,
            ImGuiSelectableFlags flags = 0,
            const ImVec2& size = ImVec2(0,0)
        )

        bool Selectable(
            const char* label,
            bool* selected,
            ImGuiSelectableFlags flags = 0,
            const ImVec2& size = ImVec2(0,0)
        )
    """
    cdef cimgui.bool inout_selected = selected
    return cimgui.Selectable(
        _bytes(label),
        &inout_selected,
        flags,
        _cast_args_ImVec2(width, height)), inout_selected


def listbox(
    str label,
    int current,
    list items,
    int height_in_items=-1
):
    """Show listbox widget.

    .. visual-example::
        :auto_layout:
        :height: 100
        :width: 200

        current = 2
        imgui.begin("Example: listbox widget")

        clicked, current = imgui.listbox(
            "List", current, ["first", "second", "third"]
        )

        imgui.end()

    Args:
        label (str): The label.
        current (int): index of selected item.
        items (list): list of string labels for items.
        height_in_items (int): height of dropdown in items. Defaults to -1
            (autosized).

    Returns:
        tuple: a ``(changed, current)`` tuple indicating change of selection
        and current index of selected item.

    .. wraps::
        bool ListBox(
            const char* label,
            int* current_item,
            const char* items[],
            int items_count,
            int height_in_items = -1
        )

    """

    cdef int inout_current = current
    cdef const char** in_items = <const char**> malloc(len(items) * sizeof(char*))

    for index, item in enumerate(items):
        in_items[index] = strdup(_bytes(item))

    opened = cimgui.ListBox(
        _bytes(label),
        &inout_current,
        in_items,
        <int>len(items),
        height_in_items
    )

    for i in range(len(items)):
        free(<char*>in_items[i])

    free(in_items)

    return opened, inout_current


cdef class _BeginEndListBox(object):
    """
    Return value of :func:`begin_list_box` exposing ``opened`` boolean attribute.
    See :func:`begin_list_box` for an explanation and examples.

    Can be used as a context manager (in a ``with`` statement) to automatically call :func:`end_list_box`
    (if necessary) to end the list box created with :func:`begin_list_box` when the block ends,
    even if an exception is raised.

    This class is not intended to be instantiated by the user (thus the `_` name prefix).
    It should be obtained as the return value of the :func:`begin_list_box` function.
    """

    cdef readonly bool opened

    def __cinit__(self, bool opened):
        self.opened = opened

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        if self.opened:
            cimgui.EndListBox()

    def __bool__(self):
        """For legacy support, returns ``opened``."""
        return self.opened

    def __repr__(self):
        return "{}(opened={})".format(
            self.__class__.__name__, self.opened
        )

    def __eq__(self, other):
        if other.__class__ is self.__class__:
            return self.opened is other.opened
        return self.opened is other


def begin_list_box(
    str label,
    width = 0,
    height = 0
):
    """Open a framed scrolling region.

    For use if you want to reimplement :func:`listbox` with custom data
    or interactions. You need to call :func:`end_list_box` at the end
    if ``opened`` is True, or use ``with`` to do so automatically.

    .. visual-example::
        :auto_layout:
        :height: 200
        :width: 200
        :click: 80 40

        with imgui.begin("Example: custom listbox"):
            with imgui.begin_list_box("List", 200, 100) as list_box:
                if list_box.opened:
                    imgui.selectable("Selected", True)
                    imgui.selectable("Not Selected", False)

    Example::
        imgui.begin("Example: custom listbox")

        if imgui.begin_list_box("List", 200, 100).opened:

            imgui.selectable("Selected", True)
            imgui.selectable("Not Selected", False)

            imgui.end_list_box()

        imgui.end()

    Args:
        label (str): The label.
        width (float): Button width. w > 0.0f: custom; w < 0.0f or -FLT_MIN: right-align; w = 0.0f (default): use current ItemWidth
        height (float): Button height. h > 0.0f: custom; h < 0.0f or -FLT_MIN: bottom-align; h = 0.0f (default): arbitrary default height which can fit ~7 items

    Returns:
        _BeginEndListBox: Use ``opened`` bool attribute to tell if the item is opened or closed.
        Only call :func:`end_list_box` if ``opened`` is True.
        Use with ``with`` to automatically call :func:`end_list_box` if necessary when the block ends.

    .. wraps::
        bool BeginListBox(
            const char* label,
            const ImVec2& size = ImVec2(0,0)
        )

    """
    return _BeginEndListBox.__new__(
        _BeginEndListBox,
        cimgui.BeginListBox(
            _bytes(label),
            _cast_args_ImVec2(width, height)
        )
    )

def listbox_header( # OBSOLETED in 1.81 (from February 2021)
    str label,
    width=0,
    height=0
):
    """*Obsoleted in imgui v1.81 from February 2021, refer to :func:`begin_list_box()`*

    For use if you want to reimplement :func:`listbox()` with custom data
    or interactions. You need to call :func:`listbox_footer()` at the end.

    Args:
        label (str): The label.
        width (float): button width.
        height (float): button height.

    Returns:
        opened (bool): If the item is opened or closed.

    .. wraps::
        bool ListBoxHeader(
            const char* label,
            const ImVec2& size = ImVec2(0,0)
        )
    """
    return begin_list_box(label, width, height)

def end_list_box():
    """

    Closing the listbox, previously opened by :func:`begin_list_box()`.
    Only call if ``begin_list_box().opened`` is True.

    See :func:`begin_list_box()` for usage example.

    .. wraps::
        void EndListBox()
    """
    cimgui.EndListBox()

def listbox_footer(): # OBSOLETED in 1.81 (from February 2021)
    """*Obsoleted in imgui v1.81 from February 2021, refer to :func:`end_list_box()`*

    Closing the listbox, previously opened by :func:`listbox_header()`.

    See :func:`listbox_header()` for usage example.

    .. wraps::
        void ListBoxFooter()
    """
    end_list_box()


def set_tooltip(str text):
    """Set tooltip under mouse-cursor.

    Usually used with :func:`is_item_hovered()`.
    For a complex tooltip window see :func:`begin_tooltip()`.

    .. visual-example::
        :auto_layout:
        :height: 100
        :width: 200
        :click: 80 40

        imgui.begin("Example: tooltip")
        imgui.button("Hover me!")
        if imgui.is_item_hovered():
            imgui.set_tooltip("Please?")
        imgui.end()

    .. wraps::
        void SetTooltip(const char* fmt, ...)
    """
    # note: "%s" required for safety and to favor of Python string formatting
    cimgui.SetTooltip("%s", _bytes(text))


cdef class _BeginEndTooltip(object):
    """
    Return value of :func:`begin_tooltip`.
    See :func:`begin_tooltip` for an explanation and examples.

    Can be used as a context manager (in a ``with`` statement) to automatically call :func:`end_tooltip`
    to end the tooltip created with :func:`begin_tooltip` when the block ends,
    even if an exception is raised.

    This class is not intended to be instantiated by the user (thus the `_` name prefix).
    It should be obtained as the return value of the :func:`begin_tooltip` function.
    """

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        cimgui.EndTooltip()

    def __repr__(self):
        return "{}()".format(self.__class__.__name__)


def begin_tooltip():
    """Use to create full-featured tooltip windows that aren't just text.

    .. visual-example::
        :auto_layout:
        :width: 600
        :height: 200
        :click: 80 40

        with imgui.begin("Example: tooltip"):
            imgui.button("Click me!")
            if imgui.is_item_hovered():
                with imgui.begin_tooltip():
                    imgui.text("This button is clickable.")
                    imgui.text("This button has full window tooltip.")
                    texture_id = imgui.get_io().fonts.texture_id
                    imgui.image(texture_id, 512, 64, border_color=(1, 0, 0, 1))
    
    .. wraps::
        void BeginTooltip()
    
    Returns:
        _BeginEndTooltip: Use with ``with`` to automatically call :func:`end_tooltip` when the block ends.

    
    """
    cimgui.BeginTooltip()
    return _BeginEndTooltip.__new__(_BeginEndTooltip)


def end_tooltip():
    """End tooltip window.

    See :func:`begin_tooltip()` for full usage example.

    .. wraps::
        void EndTooltip()
    """
    cimgui.EndTooltip()


cdef class _BeginEndMainMenuBar(object):
    """
    Return value of :func:`begin_main_menu_bar` exposing ``opened`` (displayed) boolean attribute.
    See :func:`begin_main_menu_bar` for an explanation and examples.

    Can be used as a context manager (in a ``with`` statement) to automatically call :func:`end_main_menu_bar`
    (if necessary) to end the main menu bar created with :func:`begin_main_menu_bar` when the block ends,
    even if an exception is raised.

    This class is not intended to be instantiated by the user (thus the `_` name prefix).
    It should be obtained as the return value of the :func:`begin_main_menu_bar` function.
    """

    cdef readonly bool opened

    def __cinit__(self, bool opened):
        self.opened = opened

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        if self.opened:
            cimgui.EndMainMenuBar()

    def __bool__(self):
        """For legacy support, returns ``opened``."""
        return self.opened

    def __repr__(self):
        return "{}(opened={})".format(
            self.__class__.__name__, self.opened
        )

    def __eq__(self, other):
        if other.__class__ is self.__class__:
            return self.opened is other.opened
        return self.opened is other


def begin_main_menu_bar():
    """Create new full-screen menu bar.

    Use with ``with`` to automatically call :func:`end_main_menu_bar` if necessary.
    Otherwise, only call :func:`end_main_menu_bar` if ``opened`` is True.

    .. visual-example::
        :auto_layout:
        :height: 100
        :width: 200
        :click: 10 10

        with imgui.begin_main_menu_bar() as main_menu_bar:
            if main_menu_bar.opened:
                # first menu dropdown
                with imgui.begin_menu('File', True) as file_menu:
                    if file_menu.opened:
                        imgui.menu_item('New', 'Ctrl+N', False, True)
                        imgui.menu_item('Open ...', 'Ctrl+O', False, True)

                        # submenu
                        with imgui.begin_menu('Open Recent', True) as open_recent_menu:
                            if open_recent_menu.opened:
                                imgui.menu_item('doc.txt', None, False, True)

    Example::

        if imgui.begin_main_menu_bar().opened:
            # first menu dropdown
            if imgui.begin_menu('File', True).opened:
                imgui.menu_item('New', 'Ctrl+N', False, True)
                imgui.menu_item('Open ...', 'Ctrl+O', False, True)

                # submenu
                if imgui.begin_menu('Open Recent', True).opened:
                    imgui.menu_item('doc.txt', None, False, True)
                    imgui.end_menu()

                imgui.end_menu()

            imgui.end_main_menu_bar()

    Returns:
        _BeginEndMainMenuBar: Use ``opened`` to tell if main menu bar is displayed (opened).
        Only call :func:`end_main_menu_bar` if ``opened`` is True.
        Use with ``with`` to automatically call :func:`end_main_menu_bar` if necessary when the block ends.

    .. wraps::
        bool BeginMainMenuBar()
    """
    return _BeginEndMainMenuBar.__new__(
        _BeginEndMainMenuBar,
        cimgui.BeginMainMenuBar()
    )


def end_main_menu_bar():
    """Close main menu bar context.

    Only call this function if the ``end_main_menu_bar().opened`` is True.

    For practical example how to use this function see documentation of
    :func:`begin_main_menu_bar`.

    .. wraps::
        bool EndMainMenuBar()
    """
    cimgui.EndMainMenuBar()


cdef class _BeginEndMenuBar(object):
    """
    Return value of :func:`begin_menu_bar` exposing ``opened`` (displayed) boolean attribute.
    See :func:`begin_menu_bar` for an explanation and examples.

    Can be used as a context manager (in a ``with`` statement) to automatically call :func:`end_menu_bar`
    (if necessary) to end the menu bar created with :func:`begin_menu_bar` when the block ends,
    even if an exception is raised.

    This class is not intended to be instantiated by the user (thus the `_` name prefix).
    It should be obtained as the return value of the :func:`begin_menu_bar` function.
    """

    cdef readonly bool opened

    def __cinit__(self, bool opened):
        self.opened = opened

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        if self.opened:
            cimgui.EndMenuBar()

    def __bool__(self):
        """For legacy support, returns ``opened``."""
        return self.opened

    def __repr__(self):
        return "{}(opened={})".format(
            self.__class__.__name__, self.opened
        )

    def __eq__(self, other):
        if other.__class__ is self.__class__:
            return self.opened is other.opened
        return self.opened is other


def begin_menu_bar():
    """Append new menu menu bar to current window.

    This function is different from :func:`begin_main_menu_bar`, as this is
    child-window specific. Use with ``with`` to automatically call
    :func:`end_menu_bar` if necessary.
    Otherwise, only call :func:`end_menu_bar` if ``opened`` is True.

    **Note:** this requires :ref:`WINDOW_MENU_BAR <window-flag-options>` flag
    to be set for the current window. Without this flag set the
    ``begin_menu_bar()`` function will always return ``False``.

    .. visual-example::
        :auto_layout:
        :click: 25 30

        flags = imgui.WINDOW_MENU_BAR

        with imgui.begin("Child Window - File Browser", flags=flags):
            with imgui.begin_menu_bar() as menu_bar:
                if menu_bar.opened:
                    with imgui.begin_menu('File') as file_menu:
                        if file_menu.opened:
                            imgui.menu_item('Close')

    Example::

        flags = imgui.WINDOW_MENU_BAR

        imgui.begin("Child Window - File Browser", flags=flags)

        if imgui.begin_menu_bar().opened:
            if imgui.begin_menu('File').opened:
                imgui.menu_item('Close')
                imgui.end_menu()

            imgui.end_menu_bar()

        imgui.end()

    Returns:
        _BeginEndMenuBar: Use ``opened`` to tell if menu bar is displayed (opened).
        Only call :func:`end_menu_bar` if ``opened`` is True.
        Use with ``with`` to automatically call :func:`end_menu_bar` if necessary when the block ends.

    .. wraps::
        bool BeginMenuBar()
    """
    return _BeginEndMenuBar.__new__(
        _BeginEndMenuBar,
        cimgui.BeginMenuBar()
    )


def end_menu_bar():
    """Close menu bar context.

    Only call this function if ``begin_menu_bar().opened`` is True.

    For practical example how to use this function see documentation of
    :func:`begin_menu_bar`.

    .. wraps::
        void EndMenuBar()
    """
    cimgui.EndMenuBar()


cdef class _BeginEndMenu(object):
    """
    Return value of :func:`begin_menu` exposing ``opened`` boolean attribute.
    See :func:`begin_menu` for an explanation and examples.

    Can be used as a context manager (in a ``with`` statement) to automatically call :func:`end_menu`
    (if necessary) to end the menu created with :func:`begin_menu` when the block ends,
    even if an exception is raised.

    This class is not intended to be instantiated by the user (thus the `_` name prefix).
    It should be obtained as the return value of the :func:`begin_menu` function.
    """

    cdef readonly bool opened

    def __cinit__(self, bool opened):
        self.opened = opened

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        if self.opened:
            cimgui.EndMenu()

    def __bool__(self):
        """For legacy support, returns ``opened``."""
        return self.opened

    def __repr__(self):
        return "{}(opened={})".format(
            self.__class__.__name__, self.opened
        )

    def __eq__(self, other):
        if other.__class__ is self.__class__:
            return self.opened is other.opened
        return self.opened is other


def begin_menu(str label, enabled=True):
    """Create new expandable menu in current menu bar.

    Use with ``with`` to automatically call :func:`end_menu` if necessary.
    Otherwise, only call :func:`end_menu` if ``opened`` is True.

    For practical example how to use this function, please see documentation
    of :func:`begin_main_menu_bar` or :func:`begin_menu_bar`.

    Args:
        label (str): label of the menu.
        enabled (bool): define if menu is enabled or disabled.

    Returns:
        _BeginEndMenu: Use ``opened`` to tell if the menu is displayed (opened).
        Only call :func:`end_menu` if ``opened`` is True.
        Use with ``with`` to automatically call :func:`end_menu` if necessary when the block ends.

    .. wraps::
        bool BeginMenu(
            const char* label,
            bool enabled
        )
    """
    return _BeginEndMenu.__new__(
        _BeginEndMenu,
        cimgui.BeginMenu(_bytes(label), enabled)
    )


def end_menu():
    """Close menu context.

    Only call this function if ``begin_menu().opened`` returns True.

    For practical example how to use this function, please see documentation
    of :func:`begin_main_menu_bar` or :func:`begin_menu_bar`.

    .. wraps::
        void EndMenu()
    """
    cimgui.EndMenu()


def menu_item(
    str label, str shortcut=None, cimgui.bool selected=False, enabled=True
):
    """Create a menu item.

    Item shortcuts are displayed for convenience but not processed by ImGui at
    the moment. Using ``selected`` argument it is possible to show and trigger
    a check mark next to the menu item label.

    For practical example how to use this function, please see documentation
    of :func:`begin_main_menu_bar` or :func:`begin_menu_bar`.

    Args:
        label (str): label of the menu item.
        shortcut (str): shortcut text of the menu item.
        selected (bool): define if menu item is selected.
        enabled (bool): define if menu item is enabled or disabled.

    Returns:
        tuple: a ``(clicked, state)`` two-tuple indicating if item was
        clicked by the user and the current state of item (visibility of
        the check mark).

    .. wraps::
        MenuItem(
            const char* label,
            const char* shortcut,
            bool* p_selected,
            bool enabled = true
        )
    """
    cdef cimgui.bool inout_selected = selected

    # note: wee need to split this into two separate calls depending
    #       on the value of shortcut in order to support None instead
    #       of empty strings.
    if shortcut is None:
        clicked = cimgui.MenuItem(
            _bytes(label),
            NULL,
            &inout_selected,
            <bool>enabled
        )
    else:
        clicked = cimgui.MenuItem(
            _bytes(label),
            _bytes(shortcut),
            &inout_selected,
            <bool>enabled
        )
    return clicked, inout_selected


def open_popup(str label, cimgui.ImGuiPopupFlags flags=0):
    """Open a popup window.

    Marks a popup window as open. Popups are closed when user click outside,
    or activate a pressable item, or :func:`close_current_popup()` is
    called within a :func:`begin_popup()`/:func:`end_popup()` block.
    Popup identifiers are relative to the current ID-stack
    (so :func:`open_popup` and :func:`begin_popup` needs to be at
    the same level).

    .. visual-example::
        :title: Simple popup window
        :height: 100
        :width: 220
        :auto_layout:

        imgui.begin("Example: simple popup")
        if imgui.button('Toggle..'):
            imgui.open_popup("toggle")
        if imgui.begin_popup("toggle"):
            if imgui.begin_menu('Sub-menu'):
                _, _ = imgui.menu_item('Click me')
                imgui.end_menu()
            imgui.end_popup()
        imgui.end()

    Args:
        label (str): label of the modal window.

    .. wraps::
        void OpenPopup(
            const char* str_id,
            ImGuiPopupFlags popup_flags = 0
        )
    """
    cimgui.OpenPopup(_bytes(label), flags)

def open_popup_on_item_click(str label = None, cimgui.ImGuiPopupFlags popup_flags = 1):
    """Helper to open popup when clicked on last item.
    (note: actually triggers on the mouse _released_ event to be consistent with popup behaviors)

    Args:
        label (str): label of the modal window
        flags: ImGuiWindowFlags

    .. wraps::
        void OpenPopupOnItemClick(const char* str_id = NULL, ImGuiPopupFlags popup_flags = 1)
    """
    if label is None:
        cimgui.OpenPopupOnItemClick(NULL, popup_flags)
    else:
        cimgui.OpenPopupOnItemClick(_bytes(label), popup_flags)


cdef class _BeginEndPopup(object):
    """
    Return value of :func:`begin_popup` exposing ``opened`` boolean attribute.
    See :func:`begin_popup` for an explanation and examples.

    Can be used as a context manager (in a ``with`` statement) to automatically call :func:`end_popup`
    (if necessary) to end the popup created with :func:`begin_popup` when the block ends,
    even if an exception is raised.

    This class is not intended to be instantiated by the user (thus the `_` name prefix).
    It should be obtained as the return value of the :func:`begin_popup` function.
    """

    cdef readonly bool opened

    def __cinit__(self, bool opened):
        self.opened = opened

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        if self.opened:
            cimgui.EndPopup()

    def __bool__(self):
        """For legacy support, returns ``opened``."""
        return self.opened

    def __repr__(self):
        return "{}(opened={})".format(
            self.__class__.__name__, self.opened
        )

    def __eq__(self, other):
        if other.__class__ is self.__class__:
            return self.opened is other.opened
        return self.opened is other


def begin_popup(str label, cimgui.ImGuiWindowFlags flags=0):
    """Open a popup window.

    The attribute ``opened`` is True if the popup is open and you can start outputting
    content to it.
    Use with ``with`` to automatically call :func:`end_popup` if necessary.
    Otherwise, only call :func:`end_popup` if ``opened`` is True.

    .. visual-example::
        :title: Simple popup window
        :height: 100
        :width: 220
        :auto_layout:

        with imgui.begin("Example: simple popup"):
            if imgui.button("select"):
                imgui.open_popup("select-popup")

            imgui.same_line()

            with imgui.begin_popup("select-popup") as select_popup:
                if select_popup.opened:
                    imgui.text("Select one")
                    imgui.separator()
                    imgui.selectable("One")
                    imgui.selectable("Two")
                    imgui.selectable("Three")

    Example::

        imgui.begin("Example: simple popup")

        if imgui.button("select"):
            imgui.open_popup("select-popup")

        imgui.same_line()

        if imgui.begin_popup("select-popup"):
            imgui.text("Select one")
            imgui.separator()
            imgui.selectable("One")
            imgui.selectable("Two")
            imgui.selectable("Three")
            imgui.end_popup()

        imgui.end()

    Args:
        label (str): label of the modal window.

    Returns:
        _BeginEndPopup: Use ``opened`` bool attribute to tell if the popup is opened.
        Only call :func:`end_popup` if ``opened`` is True.
        Use with ``with`` to automatically call :func:`end_popup` if necessary when the block ends.

    .. wraps::
        bool BeginPopup(
            const char* str_id,
            ImGuiWindowFlags flags = 0
        )
    """
    return _BeginEndPopup.__new__(
        _BeginEndPopup,
        cimgui.BeginPopup(_bytes(label), flags)
    )


cdef class _BeginEndPopupModal(object):
    """
    Return value of :func:`begin_popup_modal` exposing ``opened`` and ``visible`` boolean attributes.
    See :func:`begin_popup_modal` for an explanation and examples.

    For legacy support, the attributes can also be accessed by unpacking or indexing into this object.

    Can be used as a context manager (in a ``with`` statement) to automatically call :func:`end_popup`
    (if necessary) to end the popup created with :func:`begin_popup_modal` when the block ends,
    even if an exception is raised.

    This class is not intended to be instantiated by the user (thus the `_` name prefix).
    It should be obtained as the return value of the :func:`begin_popup_modal` function.
    """

    cdef readonly bool opened
    cdef readonly bool visible

    def __cinit__(self, bool opened, bool visible):
        self.opened = opened
        self.visible = visible

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        if self.opened:
            cimgui.EndPopup()

    def __getitem__(self, item):
        """For legacy support, returns ``(opened, visible)[item]``."""
        return (self.opened, self.visible)[item]

    def __iter__(self):
        """For legacy support, returns ``iter((opened, visible))``."""
        return iter((self.opened, self.visible))

    def __repr__(self):
        return "{}(opened={}, visible={})".format(
            self.__class__.__name__, self.opened, self.visible
        )

    def __eq__(self, other):
        if other.__class__ is self.__class__:
            return (self.opened, self.visible) == (other.opened, other.visible)
        return (self.opened, self.visible) == other


def begin_popup_modal(str title, visible=None, cimgui.ImGuiWindowFlags flags=0):
    """Begin pouring popup contents.

    Differs from :func:`begin_popup` with its modality - meaning it
    opens up on top of every other window.

    The attribute ``opened`` is True if the popup is open and you can start outputting
    content to it.
    Use with ``with`` to automatically call :func:`end_popup` if necessary.
    Otherwise, only call :func:`end_popup` if ``opened`` is True.

    .. visual-example::
        :title: Simple popup window
        :height: 100
        :width: 220
        :auto_layout:

        with imgui.begin("Example: simple popup modal"):
            if imgui.button("Open Modal popup"):
                imgui.open_popup("select-popup")

            imgui.same_line()

            with imgui.begin_popup_modal("select-popup") as select_popup:
                if select_popup.opened:
                    imgui.text("Select an option:")
                    imgui.separator()
                    imgui.selectable("One")
                    imgui.selectable("Two")
                    imgui.selectable("Three")

    Example::

        imgui.begin("Example: simple popup modal")

        if imgui.button("Open Modal popup"):
            imgui.open_popup("select-popup")

        imgui.same_line()

        if imgui.begin_popup_modal("select-popup").opened:
            imgui.text("Select an option:")
            imgui.separator()
            imgui.selectable("One")
            imgui.selectable("Two")
            imgui.selectable("Three")
            imgui.end_popup()

        imgui.end()

    Args:
        title (str): label of the modal window.
        visible (bool): define if popup is visible or not.
        flags: Window flags. See:
            :ref:`list of available flags <window-flag-options>`.

    Returns:
        _BeginEndPopupModal: ``(opened, visible)`` struct of bools.
        Only call :func:`end_popup` if ``opened`` is True.
        Use with ``with`` to automatically call :func:`end_popup` if necessary when the block ends.
        The ``opened`` attribute can be False when the popup is completely clipped
        (e.g. zero size display).

    .. wraps::
        bool BeginPopupModal(
            const char* name,
            bool* p_open = NULL,
            ImGuiWindowFlags extra_flags = 0
        )
    """
    cdef cimgui.bool inout_visible = visible

    return _BeginEndPopupModal.__new__(
        _BeginEndPopupModal,
        cimgui.BeginPopupModal(
            _bytes(title),
            &inout_visible if visible is not None else NULL,
            flags
        ),
        inout_visible
    )


def begin_popup_context_item(str label = None, cimgui.ImGuiPopupFlags mouse_button = 1):
    """This is a helper function to handle the most simple case of associating
    one named popup to one given widget.

    .. visual-example::
        :title: Popup context view
        :height: 100
        :width: 200
        :auto_layout:
        :click: 40 40

        with imgui.begin("Example: popup context view"):
            imgui.text("Right-click to set value.")
            with imgui.begin_popup_context_item("Item Context Menu", mouse_button=0) as popup:
                if popup.opened:
                    imgui.selectable("Set to Zero")

    Example::

        imgui.begin("Example: popup context view")
        imgui.text("Right-click to set value.")
        if imgui.begin_popup_context_item("Item Context Menu", mouse_button=0):
            imgui.selectable("Set to Zero")
            imgui.end_popup()
        imgui.end()

    Args:
        label (str): label of item.
        mouse_button: ImGuiPopupFlags

    Returns:
        _BeginEndPopup: Use ``opened`` bool attribute to tell if the popup is opened.
        Only call :func:`end_popup` if ``opened`` is True.
        Use with ``with`` to automatically call :func:`end_popup` if necessary when the block ends.

    .. wraps::
        bool BeginPopupContextItem(
            const char* str_id = NULL,
            int mouse_button = 1
        )
    """
    if label is None:
        return _BeginEndPopup.__new__(_BeginEndPopup, cimgui.BeginPopupContextItem(NULL, mouse_button))
    else:
        return _BeginEndPopup.__new__(_BeginEndPopup, cimgui.BeginPopupContextItem(_bytes(label), mouse_button))


def begin_popup_context_window(
    str label = None,
    cimgui.ImGuiPopupFlags popup_flags = 1,
    bool also_over_items = True # OBSOLETED in 1.77 (from June 2020)
):
    """Helper function to open and begin popup when clicked on current window.

    As all popup functions it should end with :func:`end_popup`.

    .. visual-example::
        :title: Popup context view
        :height: 100
        :width: 200
        :auto_layout:
        :click: 40 40

        with imgui.begin("Example: popup context window"):
            with imgui.begin_popup_context_window(popup_flags=imgui.POPUP_NONE) as context_window:
                if context_window.opened:
                    imgui.selectable("Clear")

    Example::

        imgui.begin("Example: popup context window")
        if imgui.begin_popup_context_window(popup_flags=imgui.POPUP_NONE):
            imgui.selectable("Clear")
            imgui.end_popup()
        imgui.end()

    Args:
        label (str): label of the window
        popup_flags: ImGuiPopupFlags
        also_over_items (bool): display on top of widget. OBSOLETED in ImGui 1.77 (from June 2020)

    Returns:
        _BeginEndPopup: Use ``opened`` bool attribute to tell if the context window is opened.
        Only call :func:`end_popup` if ``opened`` is True.
        Use with ``with`` to automatically call :func:`end_popup` if necessary when the block ends.

    .. wraps::
        bool BeginPopupContextWindow(
            const char* str_id = NULL,
            ImGuiPopupFlags popup_flags = 1
        )
    """

    if label is None:
        return _BeginEndPopup.__new__(
            _BeginEndPopup,
            cimgui.BeginPopupContextWindow(
                NULL,
                popup_flags | (0 if also_over_items else POPUP_NO_OPEN_OVER_ITEMS)
            )
        )
    else:
        return _BeginEndPopup.__new__(
            _BeginEndPopup,
            cimgui.BeginPopupContextWindow(
                _bytes(label),
                popup_flags | (0 if also_over_items else POPUP_NO_OPEN_OVER_ITEMS)
            )
        )

def begin_popup_context_void(str label = None, cimgui.ImGuiPopupFlags popup_flags = 1):
    """Open+begin popup when clicked in void (where there are no windows).

    Args:
        label (str): label of the window
        popup_flags: ImGuiPopupFlags

    Returns:
        _BeginEndPopup: Use ``opened`` bool attribute to tell if the context window is opened.
        Only call :func:`end_popup` if ``opened`` is True.
        Use with ``with`` to automatically call :func:`end_popup` if necessary when the block ends.

    .. wraps::
        bool BeginPopupContextVoid(const char* str_id = NULL, ImGuiPopupFlags popup_flags = 1)
    """

    if label is None:
        return _BeginEndPopup.__new__(
            _BeginEndPopup,
            cimgui.BeginPopupContextVoid(NULL, popup_flags)
        )
    else:
        return _BeginEndPopup.__new__(
            _BeginEndPopup,
            cimgui.BeginPopupContextVoid(_bytes(label), popup_flags)
        )

def is_popup_open( str label,  cimgui.ImGuiPopupFlags flags = 0):
    """Popups: test function

    * ``is_popup_open()`` with POPUP_ANY_POPUP_ID: return true if any popup is open at the current BeginPopup() level of the popup stack.
    * ``is_popup_open()`` with POPUP_ANY_POPUP_ID + POPUP_ANY_POPUP_LEVEL: return true if any popup is open.

    Returns:
        bool: True if the popup is open at the current ``begin_popup()`` level of the popup stack.

    .. wraps::
        bool IsPopupOpen(const char* str_id, ImGuiPopupFlags flags = 0)
    """
    return cimgui.IsPopupOpen(_bytes(label), flags)

def end_popup():
    """End a popup window.

    Should be called after each XYZPopupXYZ function.
    Only call this function if ``begin_popup_XYZ().opened`` is True.

    For practical example how to use this function, please see documentation
    of :func:`open_popup`.

    .. wraps::
        void EndPopup()
    """
    cimgui.EndPopup()


def close_current_popup():
    """Close the current popup window begin-ed directly above this call.
    Clicking on a :func:`menu_item()` or :func:`selectable()` automatically
    close the current popup.

    For practical example how to use this function, please see documentation
    of :func:`open_popup`.

    .. wraps::
        void CloseCurrentPopup()
    """
    cimgui.CloseCurrentPopup()


cdef class _BeginEndTable(object):
    """
    Return value of :func:`begin_table` exposing ``opened`` boolean attribute.
    See :func:`begin_table` for an explanation and examples.

    Can be used as a context manager (in a ``with`` statement) to automatically call :func:`end_table`
    (if necessary) to end the table created with :func:`begin_table` when the block ends,
    even if an exception is raised.

    This class is not intended to be instantiated by the user (thus the `_` name prefix).
    It should be obtained as the return value of the :func:`begin_table` function.
    """

    cdef readonly bool opened

    def __cinit__(self, bool opened):
        self.opened = opened

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        if self.opened:
            cimgui.EndTable()

    def __bool__(self):
        """For legacy support, returns ``opened``."""
        return self.opened

    def __repr__(self):
        return "{}(opened={})".format(
            self.__class__.__name__, self.opened
        )

    def __eq__(self, other):
        if other.__class__ is self.__class__:
            return self.opened is other.opened
        return self.opened is other


def begin_table(
    str label,
    int column,
    cimgui.ImGuiTableFlags flags = 0,
    float outer_size_width = 0.0,
    float outer_size_height = 0.0,
    float inner_width = 0.0
    ):
    """

    Returns:
        _BeginEndPopup: Use ``opened`` bool attribute to tell if the table is opened.
        Only call :func:`end_table` if ``opened`` is True.
        Use with ``with`` to automatically call :func:`end_table` if necessary when the block ends.

    .. wraps::
        bool BeginTable(
            const char* str_id,
            int column,
            ImGuiTableFlags flags = 0,
            const ImVec2& outer_size = ImVec2(0.0f, 0.0f),
            float inner_width = 0.0f
        )
    """
    return _BeginEndTable.__new__(
        _BeginEndTable,
        cimgui.BeginTable(
            _bytes(label),
            column,
            flags,
            _cast_args_ImVec2(outer_size_width, outer_size_height),
            inner_width
        )
    )

def end_table():
    """
    End a previously opened table.
    Only call this function if ``begin_table().opened`` is True.

    .. wraps::
        void EndTable()
    """
    cimgui.EndTable()

def table_next_row(
        cimgui.ImGuiTableRowFlags row_flags = 0,
        float min_row_height = 0.0
    ):
    """

    .. wraps::
        void TableNextRow(
            ImGuiTableRowFlags row_flags = 0,
            float min_row_height = 0.0f
        )
    """
    cimgui.TableNextRow(row_flags, min_row_height)

def table_next_column():
    """

    .. wraps::
        bool TableNextColumn()
    """
    return cimgui.TableNextColumn()

def table_set_column_index(int column_n):
    """

    .. wraps::
        bool TableSetColumnIndex(int column_n)
    """
    return cimgui.TableSetColumnIndex(column_n)

def table_setup_column(
        str label,
        cimgui.ImGuiTableColumnFlags flags = 0,
        float init_width_or_weight = 0.0,
        cimgui.ImU32 user_id = 0
    ):
    """

    .. wraps::
        void TableSetupColumn(
            const char* label,
            ImGuiTableColumnFlags flags = 0,
            float init_width_or_weight = 0.0f,
            ImU32 user_id  = 0
        )
    """
    cimgui.TableSetupColumn(
        _bytes(label),
        flags,
        init_width_or_weight,
        user_id)

def table_setup_scroll_freeze(int cols, int rows):
    """

    .. wraps::
        void TableSetupScrollFreeze(int cols, int rows)
    """
    cimgui.TableSetupScrollFreeze(cols, rows)

def table_headers_row():
    """

    .. wraps::
        void TableHeadersRow()
    """
    cimgui.TableHeadersRow()

def table_header(str label):
    """

    .. wraps::
        void TableHeader(const char* label)
    """
    cimgui.TableHeader(_bytes(label))

def table_get_sort_specs():
    """

    .. wraps::
        ImGuiTableSortSpecs* TableGetSortSpecs()
    """
    cdef cimgui.ImGuiTableSortSpecs* imgui_sort_spec = cimgui.TableGetSortSpecs()
    if imgui_sort_spec == NULL:
        return None
    else:
        return _ImGuiTableSortSpecs.from_ptr(imgui_sort_spec)

def table_get_column_count():
    """

    .. wraps::
        int TableGetColumnCount()
    """
    return cimgui.TableGetColumnCount()

def table_get_column_index():
    """

    .. wraps::
        int TableGetColumnIndex()
    """
    return cimgui.TableGetColumnIndex()

def table_get_row_index():
    """

    .. wraps::
        int TableGetRowIndex()
    """
    return cimgui.TableGetRowIndex()

def table_get_column_name(int column_n = -1):
    """

    .. wraps::
        const char* TableGetColumnName(
            int column_n  = -1
        )
    """
    return _from_bytes(cimgui.TableGetColumnName(column_n))

def table_get_column_flags(int column_n = -1):
    """

    .. wraps::
        ImGuiTableColumnFlags TableGetColumnFlags(
            int column_n = -1
        )
    """
    return cimgui.TableGetColumnFlags(column_n)

def table_set_background_color(
        cimgui.ImGuiTableBgTarget target,
        cimgui.ImU32 color,
        int column_n = -1
    ):
    """

    .. wraps::
        void TableSetBgColor(
            ImGuiTableBgTarget target,
            ImU32 color,
            int column_n  = -1
        )
    """
    cimgui.TableSetBgColor(target, color, column_n)

def text(str text):
    """Add text to current widget stack.

    .. visual-example::
        :title: simple text widget
        :height: 80
        :auto_layout:

        imgui.begin("Example: simple text")
        imgui.text("Simple text")
        imgui.end()

    Args:
        text (str): text to display.

    .. wraps::
        Text(const char* fmt, ...)
    """
    # note: "%s" required for safety and to favor of Python string formating
    cimgui.Text("%s", _bytes(text))


def text_colored(str text, float r, float g, float b, float a=1.):
    """Add colored text to current widget stack.

    It is a shortcut for:

    .. code-block:: python

        imgui.push_style_color(imgui.COLOR_TEXT, r, g, b, a)
        imgui.text(text)
        imgui.pop_style_color()


    .. visual-example::
        :title: colored text widget
        :height: 100
        :auto_layout:

        imgui.begin("Example: colored text")
        imgui.text_colored("Colored text", 1, 0, 0)
        imgui.end()

    Args:
        text (str): text to display.
        r (float): red color intensity.
        g (float): green color intensity.
        b (float): blue color instensity.
        a (float): alpha intensity.

    .. wraps::
        TextColored(const ImVec4& col, const char* fmt, ...)
    """
    # note: "%s" required for safety and to favor of Python string formating
    cimgui.TextColored(_cast_args_ImVec4(r, g, b, a), "%s", _bytes(text))


def text_disabled(str text):
    """Add disabled(grayed out) text to current widget stack.

    .. visual-example::
        :title: disabled text widget
        :height: 80
        :auto_layout:

        imgui.begin("Example: disabled text")
        imgui.text_disabled("Disabled text")
        imgui.end()

    Args:
        text (str): text to display.

    .. wraps::
        TextDisabled(const char*, ...)
    """
    # note: "%s" required for safety and to favor of Python string formating
    cimgui.TextDisabled("%s", _bytes(text))

def text_wrapped(str text):
    """Add wrappable text to current widget stack.

    .. visual-example::
        :title: Wrappable Text
        :height: 80
        :width: 40
        :auto_layout:

        imgui.begin("Text wrap")
        # Resize the window to see text wrapping
        imgui.text_wrapped("This text will wrap around.")
        imgui.end()

    Args:
        text (str): text to display

    .. wraps::
        TextWrapped(const char* fmt, ...)
    """
    # note: "%s" required for safety and to favor of Python string formating
    cimgui.TextWrapped("%s", _bytes(text))


def label_text(str label, str text):
    """Display text+label aligned the same way as value+label widgets.

    .. visual-example::
        :auto_layout:
        :height: 80
        :width: 300

        imgui.begin("Example: text with label")
        imgui.label_text("my label", "my text")
        imgui.end()

    Args:
        label (str): label to display.
        text (str): text to display.

    .. wraps::
        void LabelText(const char* label, const char* fmt, ...)
    """
    # note: "%s" required for safety and to favor of Python string formating
    cimgui.LabelText(_bytes(label), "%s", _bytes(text))


def text_unformatted(str text):
    """Big area text display - the size is defined by it's container.
    Recommended for long chunks of text.

    .. visual-example::
        :title: simple text widget
        :height: 100
        :width: 200
        :auto_layout:

        imgui.begin("Example: unformatted text")
        imgui.text_unformatted("Really ... long ... text")
        imgui.end()

    Args:
        text (str): text to display.

    .. wraps::
        TextUnformatted(const char* text, const char* text_end = NULL)
    """
    cimgui.TextUnformatted(_bytes(text))


def bullet():
    """Display a small circle and keep the cursor on the same line.

    .. advance cursor x position by ``get_tree_node_to_label_spacing()``,
       same distance that TreeNode() uses

    .. visual-example::
        :auto_layout:
        :height: 80

        imgui.begin("Example: bullets")

        for i in range(10):
            imgui.bullet()

        imgui.end()

    .. wraps::
        void Bullet()
    """
    cimgui.Bullet()


def bullet_text(str text):
    """Display bullet and text.

    This is shortcut for:

    .. code-block:: python

        imgui.bullet()
        imgui.text(text)

    .. visual-example::
        :auto_layout:
        :height: 100

        imgui.begin("Example: bullet text")
        imgui.bullet_text("Bullet 1")
        imgui.bullet_text("Bullet 2")
        imgui.bullet_text("Bullet 3")
        imgui.end()

    Args:
        text (str): text to display.

    .. wraps::
        void BulletText(const char* fmt, ...)
    """
    # note: "%s" required for safety and to favor of Python string formating
    cimgui.BulletText("%s", _bytes(text))


def button(str label, width=0, height=0):
    """Display button.

    .. visual-example::
        :auto_layout:
        :height: 100

        imgui.begin("Example: button")
        imgui.button("Button 1")
        imgui.button("Button 2")
        imgui.end()

    Args:
        label (str): button label.
        width (float): button width.
        height (float): button height.

    Returns:
        bool: True if clicked.

    .. wraps::
        bool Button(const char* label, const ImVec2& size = ImVec2(0,0))
    """
    return cimgui.Button(_bytes(label), _cast_args_ImVec2(width, height))


def small_button(str label):
    """Display small button (with 0 frame padding).

    .. visual-example::
        :auto_layout:
        :height: 100

        imgui.begin("Example: button")
        imgui.small_button("Button 1")
        imgui.small_button("Button 2")
        imgui.end()

    Args:
        label (str): button label.

    Returns:
        bool: True if clicked.

    .. wraps::
        bool SmallButton(const char* label)
    """
    return cimgui.SmallButton(_bytes(label))

def arrow_button(str label, cimgui.ImGuiDir direction = DIRECTION_NONE):
    """Display an arrow button

    .. visual-example::
        :auto_layout:
        :height: 100

        imgui.begin("Arrow button")
        imgui.arrow_button("Button", imgui.DIRECTION_LEFT)
        imgui.end()

    Args:
        label (str): button label.
        direction = imgui direction constant

    Returns:
        bool: True if clicked.

    .. wraps::
        bool ArrowButton(const char*, ImGuiDir)
    """
    if direction == DIRECTION_NONE:
        raise ValueError("Direction wasn't specified.")
    return cimgui.ArrowButton(_bytes(label), direction)

def invisible_button(str identifier, float width, float height, cimgui.ImGuiButtonFlags flags = 0):
    """Create invisible button.

    Flexible button behavior without the visuals, frequently useful to build custom behaviors using the public api (along with IsItemActive, IsItemHovered, etc.)

    .. visual-example::
        :auto_layout:
        :height: 300
        :width: 300

        imgui.begin("Example: invisible button :)")
        imgui.invisible_button("Button 1", 200, 200)
        imgui.small_button("Button 2")
        imgui.end()

    Args:
        identifier (str): Button identifier. Like label on :any:`button()`
            but it is not displayed.
        width (float): button width.
        height (float): button height.
        flags: ImGuiButtonFlags

    Returns:
        bool: True if button is clicked.

    .. wraps::
        bool InvisibleButton(const char* str_id, const ImVec2& size, ImGuiButtonFlags flags = 0)
    """
    return cimgui.InvisibleButton(
        _bytes(identifier),
        _cast_args_ImVec2(width, height),
        flags
    )


def color_button(
        str desc_id,
        float r, float g, float b, a=1.,
        flags=0,
        float width=0, float height=0,
):
    """Display colored button.

    .. visual-example::
        :auto_layout:
        :height: 150

        imgui.begin("Example: color button")
        imgui.color_button("Button 1", 1, 0, 0, 1, 0, 10, 10)
        imgui.color_button("Button 2", 0, 1, 0, 1, 0, 10, 10)
        imgui.color_button("Wide Button", 0, 0, 1, 1, 0, 20, 10)
        imgui.color_button("Tall Button", 1, 0, 1, 1, 0, 10, 20)
        imgui.end()

    Args:
        #r (float): red color intensity.
        #g (float): green color intensity.
        #b (float): blue color instensity.
        #a (float): alpha intensity.
        #ImGuiColorEditFlags: Color edit flags.  Zero for none.
        #width (float): Width of the color button
        #height (float): Height of the color button

    Returns:
        bool: True if button is clicked.

    .. wraps::
        bool ColorButton(
            const char* desc_id,
            const ImVec4& col,
            ImGuiColorEditFlags flags,
            ImVec2 size
        )
    """
    return cimgui.ColorButton(
        _bytes(desc_id), _cast_args_ImVec4(r, g, b, a), flags, _cast_args_ImVec2(width, height)
    )


def image_button(
    texture_id,
    float width,
    float height,
    tuple uv0=(0, 0),
    tuple uv1=(1, 1),
    tuple tint_color=(1, 1, 1, 1),
    tuple border_color=(0, 0, 0, 0),
    int frame_padding=-1,
):
    """Display image.

    .. todo:: add example with some preconfigured image

    Args:
        texture_id (object): user data defining texture id. Argument type
            is implementation dependent. For OpenGL it is usually an integer.
        size (Vec2): image display size two-tuple.
        uv0 (Vec2): UV coordinates for 1st corner (lower-left for OpenGL).
            Defaults to ``(0, 0)``.
        uv1 (Vec2): UV coordinates for 2nd corner (upper-right for OpenGL).
            Defaults to ``(1, 1)``.
        tint_color (Vec4): Image tint color. Defaults to white.
        border_color (Vec4): Image border color. Defaults to transparent.
        frame_padding (int): Frame padding (``0``: no padding, ``<0`` default
            padding).

    Returns:
        bool: True if clicked.

    .. wraps::
        bool ImageButton(
            ImTextureID user_texture_id,
            const ImVec2& size,
            const ImVec2& uv0 = ImVec2(0,0),
            const ImVec2& uv1 = ImVec2(1,1),
            int frame_padding = -1,
            const ImVec4& bg_col = ImVec4(0,0,0,0),
            const ImVec4& tint_col = ImVec4(1,1,1,1)
        )
    """
    get_current_context()._keepalive_cache.append(texture_id)
    return cimgui.ImageButton(
        <void*>texture_id,
        _cast_args_ImVec2(width, height),  # todo: consider inlining
        _cast_tuple_ImVec2(uv0),
        _cast_tuple_ImVec2(uv1),
        # note: slightly different order of params than in ImGui::Image()
        frame_padding,
        _cast_tuple_ImVec4(border_color),
        _cast_tuple_ImVec4(tint_color),
    )


def image(
    texture_id,
    float width,
    float height,
    tuple uv0=(0, 0),
    tuple uv1=(1, 1),
    tuple tint_color=(1, 1, 1, 1),
    tuple border_color=(0, 0, 0, 0),
):
    """Display image.

    .. visual-example::
        :auto_layout:
        :width: 550
        :height: 200

        texture_id = imgui.get_io().fonts.texture_id

        imgui.begin("Example: image display")
        imgui.image(texture_id, 512, 64, border_color=(1, 0, 0, 1))
        imgui.end()

    Args:
        texture_id (object): user data defining texture id. Argument type
            is implementation dependent. For OpenGL it is usually an integer.
        size (Vec2): image display size two-tuple.
        uv0 (Vec2): UV coordinates for 1st corner (lower-left for OpenGL).
            Defaults to ``(0, 0)``.
        uv1 (Vec2): UV coordinates for 2nd corner (upper-right for OpenGL).
            Defaults to ``(1, 1)``.
        tint_color(Vec4): Image tint color. Defaults to white.
        border_color(Vec4): Image border color. Defaults to transparent.

    .. wraps::
        void Image(
            ImTextureID user_texture_id,
            const ImVec2& size,
            const ImVec2& uv0 = ImVec2(0,0),
            const ImVec2& uv1 = ImVec2(1,1),
            const ImVec4& tint_col = ImVec4(1,1,1,1),
            const ImVec4& border_col = ImVec4(0,0,0,0)
        )
    """
    get_current_context()._keepalive_cache.append(texture_id)
    cimgui.Image(
        <void*>texture_id,
        _cast_args_ImVec2(width, height),  # todo: consider inlining
        _cast_tuple_ImVec2(uv0),
        _cast_tuple_ImVec2(uv1),
        _cast_tuple_ImVec4(tint_color),
        _cast_tuple_ImVec4(border_color),
    )


def checkbox(str label, cimgui.bool state):
    """Display checkbox widget.

    .. visual-example::
        :auto_layout:
        :width: 400


        # note: these should be initialized outside of the main interaction
        #       loop
        checkbox1_enabled = True
        checkbox2_enabled = False

        imgui.new_frame()
        imgui.begin("Example: checkboxes")

        # note: first element of return two-tuple notifies if there was a click
        #       event in currently processed frame and second element is actual
        #       checkbox state.
        _, checkbox1_enabled = imgui.checkbox("Checkbox 1", checkbox1_enabled)
        _, checkbox2_enabled = imgui.checkbox("Checkbox 2", checkbox2_enabled)

        imgui.text("Checkbox 1 state value: {}".format(checkbox1_enabled))
        imgui.text("Checkbox 2 state value: {}".format(checkbox2_enabled))

        imgui.end()


    Args:
        label (str): text label for checkbox widget.
        state (bool): current (desired) state of the checkbox. If it has to
            change, the new state will be returned as a second item of
            the return value.

    Returns:
        tuple: a ``(clicked, state)`` two-tuple indicating click event and the
        current state of the checkbox.

    .. wraps::
        bool Checkbox(const char* label, bool* v)
    """
    cdef cimgui.bool inout_state = state
    return cimgui.Checkbox(_bytes(label), &inout_state), inout_state


def checkbox_flags(str label, unsigned int flags, unsigned int flags_value):
    """Display checkbox widget that handle integer flags (bit fields).

    It is useful for handling window/style flags or any kind of flags
    implemented as integer bitfields.

    .. visual-example::
        :auto_layout:
        :width: 500

        flags = imgui.WINDOW_NO_RESIZE | imgui.WINDOW_NO_MOVE

        imgui.begin("Example: checkboxes for flags", flags=flags)

        clicked, flags = imgui.checkbox_flags(
            "No resize", flags, imgui.WINDOW_NO_RESIZE
        )
        clicked, flags = imgui.checkbox_flags(
            "No move", flags, imgui.WINDOW_NO_MOVE
        )
        clicked, flags = imgui.checkbox_flags(
            "No collapse", flags, imgui.WINDOW_NO_COLLAPSE
        )
        # note: it also allows to use multiple flags at once
        clicked, flags = imgui.checkbox_flags(
            "No resize & no move", flags,
            imgui.WINDOW_NO_RESIZE | imgui.WINDOW_NO_MOVE
        )
        imgui.text("Current flags value: {0:b}".format(flags))
        imgui.end()

    Args:
        label (str): text label for checkbox widget.
        flags (int): current state of the flags associated with checkbox.
            Actual state of checkbox (toggled/untoggled) is calculated from
            this argument and ``flags_value`` argument. If it has to change,
            the new state will be returned as a second item of the return
            value.
        flags_value (int): values of flags this widget can toggle. Represents
            bitmask in flags bitfield. Allows multiple flags to be toggled
            at once (specify using bit OR operator `|`, see example above).

    Returns:
        tuple: a ``(clicked, flags)`` two-tuple indicating click event and the
        current state of the flags controlled with this checkbox.

    .. wraps::
        bool CheckboxFlags(
            const char* label, unsigned int* flags,
            unsigned int flags_value
        )
    """
    cdef unsigned int inout_flags = flags

    return cimgui.CheckboxFlags(_bytes(label), &inout_flags, flags_value), inout_flags


def radio_button(str label, cimgui.bool active):
    """Display radio button widget

    .. visual-example::
        :auto_layout:
        :height: 100

        # note: the variable that contains the state of the radio_button, should be initialized
        #       outside of the main interaction loop
        radio_active = True

        imgui.begin("Example: radio buttons")

        if imgui.radio_button("Radio button", radio_active):
            radio_active = not radio_active

        imgui.end()

    Args:
        label (str): button label.
        active (bool): state of the radio button.

    Returns:
        bool: True if clicked.

    .. wraps::
        bool RadioButton(const char* label, bool active)
    """
    return cimgui.RadioButton(_bytes(label), active)


cdef class _BeginEndCombo(object):
    """
    Return value of :func:`begin_combo` exposing ``opened`` boolean attribute.
    See :func:`begin_combo` for an explanation and examples.

    Can be used as a context manager (in a ``with`` statement) to automatically
    call :func:`end_combo` to end the combo created with :func:`begin_combo`
    when the block ends, even if an exception is raised.

    This class is not intended to be instantiated by the user (thus the `_` name prefix).
    It should be obtained as the return value of the :func:`begin_combo` function.
    """

    cdef readonly bool opened

    def __cinit__(self, bool opened):
        self.opened = opened

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        if self.opened:
            cimgui.EndCombo()

    def __bool__(self):
        """For legacy support, returns ``opened``."""
        return self.opened

    def __repr__(self):
        return "{}(opened={})".format(
            self.__class__.__name__, self.opened
        )

    def __eq__(self, other):
        if other.__class__ is self.__class__:
            return self.opened is other.opened
        return self.opened is other


def begin_combo(str label, str preview_value, cimgui.ImGuiComboFlags flags = 0):
    """Begin a combo box with control over how items are displayed.

    .. visual-example::
        :width: 200
        :height: 200
        :auto_layout:

        selected = 0
        items = ["AAAA", "BBBB", "CCCC", "DDDD"]
        
        # ...
        
        with imgui.begin("Example: begin combo"):
            with imgui.begin_combo("combo", items[selected]) as combo:
                if combo.opened:
                    for i, item in enumerate(items):
                        is_selected = (i == selected)
                        if imgui.selectable(item, is_selected)[0]:
                            selected = i

                        # Set the initial focus when opening the combo (scrolling + keyboard navigation focus)
                        if is_selected:
                            imgui.set_item_default_focus()
    
    Example::
    
        selected = 0
        items = ["AAAA", "BBBB", "CCCC", "DDDD"]
        
        # ...

        imgui.begin("Example: begin combo")
        if imgui.begin_combo("combo", items[selected]):
            for i, item in enumerate(items):
                is_selected = (i == selected)
                if imgui.selectable(item, is_selected)[0]:
                    selected = i
                    
                # Set the initial focus when opening the combo (scrolling + keyboard navigation focus)                    
                if is_selected:
                    imgui.set_item_default_focus()

            imgui.end_combo()

        imgui.end()

    Args:
        label (str): Identifier for the combo box.
        preview_value (str): String preview for currently selected item.
        flags: Combo flags. See:
            :ref:`list of available flags <combo-flag-options>`.

    Returns:
        _BeginEndCombo: Struct with ``opened`` bool attribute. Use with ``with`` to automatically call :func:`end_combo` when the block ends.`

    .. wraps::
        bool BeginCombo(
            const char* label,
            const char* preview_value,
            ImGuiComboFlags flags = 0
        )
    
    """
    return _BeginEndCombo.__new__(
        _BeginEndCombo,
        cimgui.BeginCombo(
            _bytes(label), _bytes(preview_value), flags
        )
    )
def end_combo():
    """End combo box.
    Only call if ``begin_combo().opened`` is True.

    .. wraps::
        void EndCombo()
    """
    cimgui.EndCombo()


def combo(str label, int current, list items, int height_in_items=-1):
    """Display combo widget.

    .. visual-example::
        :auto_layout:
        :height: 200
        :click: 80 40

        current = 2
        imgui.begin("Example: combo widget")

        clicked, current = imgui.combo(
            "combo", current, ["first", "second", "third"]
        )

        imgui.end()

    Args:
        label (str): combo label.
        current (int): index of selected item.
        items (list): list of string labels for items.
        height_in_items (int): height of dropdown in items. Defaults to -1
            (autosized).

    Returns:
        tuple: a ``(changed, current)`` tuple indicating change of selection and current index of selected item.

    .. wraps::
        bool Combo(
            const char* label, int* current_item,
            const char* items_separated_by_zeros,
            int height_in_items = -1
        )

    """
    cdef int inout_current = current

    in_items = "\0".join(items) + "\0"

    return cimgui.Combo(
        _bytes(label), &inout_current, _bytes(in_items), height_in_items
    ), inout_current


def color_edit3(str label, float r, float g, float b, cimgui.ImGuiColorEditFlags flags = 0):
    """Display color edit widget for color without alpha value.

    .. visual-example::
        :auto_layout:
        :width: 300

        # note: the variable that contains the color data, should be initialized
        #       outside of the main interaction loop
        color_1 = 1., .0, .5
        color_2 = 0., .8, .3

        imgui.begin("Example: color edit without alpha")

        # note: first element of return two-tuple notifies if the color was changed
        #       in currently processed frame and second element is current value
        #       of color
        changed, color_1 = imgui.color_edit3("Color 1", *color_1)
        changed, color_2 = imgui.color_edit3("Color 2", *color_2)

        imgui.end()

    Args:
        label (str): color edit label.
        r (float): red color intensity.
        g (float): green color intensity.
        b (float): blue color instensity.
        flags (ImGuiColorEditFlags): Color edit flags.  Zero for none.

    Returns:
        tuple: a ``(bool changed, float color[3])`` tuple that contains indicator of color
        change and current value of color

    .. wraps::
        bool ColorEdit3(const char* label, float col[3], ImGuiColorEditFlags flags = 0)
    """

    cdef float[3] inout_color = [r, g, b]

    return cimgui.ColorEdit3(
        _bytes(label), <float *>(&inout_color), flags
    ), (inout_color[0], inout_color[1], inout_color[2])


def color_edit4(str label, float r, float g, float b, float a, cimgui.ImGuiColorEditFlags flags = 0):
    """Display color edit widget for color with alpha value.

    .. visual-example::
        :auto_layout:
        :width: 400

        # note: the variable that contains the color data, should be initialized
        #       outside of the main interaction loop
        color = 1., .0, .5, 1.

        imgui.begin("Example: color edit with alpha")

        # note: first element of return two-tuple notifies if the color was changed
        #       in currently processed frame and second element is current value
        #       of color and alpha
        _, color = imgui.color_edit4("Alpha", *color)
        _, color = imgui.color_edit4("No alpha", *color, imgui.COLOR_EDIT_NO_ALPHA)

        imgui.end()

    Args:
        label (str): color edit label.
        r (float): red color intensity.
        g (float): green color intensity.
        b (float): blue color instensity.
        a (float): alpha intensity.
        flags (ImGuiColorEditFlags): Color edit flags.  Zero for none.

    Returns:
        tuple: a ``(bool changed, float color[4])`` tuple that contains indicator of color
        change and current value of color and alpha

    .. wraps::
        ColorEdit4(
            const char* label, float col[4], ImGuiColorEditFlags flags
        )
    """
    cdef float[4] inout_color = [r, g, b, a]

    return cimgui.ColorEdit4(
        _bytes(label), <float *>(&inout_color), flags
    ), (inout_color[0], inout_color[1], inout_color[2], inout_color[3])


def drag_float(
    str label, float value,
    float change_speed = 1.0,
    float min_value=0.0,
    float max_value=0.0,
    str format = "%.3f",
    cimgui.ImGuiSliderFlags flags = 0,
    float power = 1. # OBSOLETED in 1.78 (from June 2020)
):
    """Display float drag widget.

    .. todo::
        Consider replacing ``format`` with something that allows
        for safer way to specify display format without loosing the
        functionality of wrapped function.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 130

        value = 42.0

        imgui.begin("Example: drag float")
        changed, value = imgui.drag_float(
            "Default", value,
        )
        changed, value = imgui.drag_float(
            "Less precise", value, format="%.1f"
        )
        imgui.text("Changed: %s, Value: %s" % (changed, value))
        imgui.end()

    Args:
        label (str): widget label.
        value (float): drag values,
        change_speed (float): how fast values change on drag.
        min_value (float): min value allowed by widget.
        max_value (float): max value allowed by widget.
        format (str): display format string as C-style ``printf``
            format string. **Warning:** Highly unsafe when used without care.
            May lead to segmentation faults and other memory violation issues.
        flags: SliderFlags flags. See:
            :ref:`list of available flags <slider-flag-options>`.
        power (float): OBSOLETED in ImGui 1.78 (from June 2020)

    Returns:
        tuple: a ``(changed, value)`` tuple that contains indicator of
        widget state change and the current drag value.

    .. wraps::
        bool DragFloat(
            const char* label,
            float* v,
            float v_speed = 1.0f,
            float v_min = 0.0f,
            float v_max = 0.0f,
            const char* format = "%.3f",
            ImGuiSliderFlags flags = 0
        )
    """
    assert (power == 1), "power parameter obsoleted in ImGui 1.78, use imgui.SLIDER_FLAGS_LOGARITHMIC instead"
    cdef float inout_value = value

    return cimgui.DragFloat(
        _bytes(label), &inout_value,
        change_speed, min_value, max_value, _bytes(format), flags
    ), inout_value


def drag_float2(
    str label, float value0, float value1,
    float change_speed = 1.0,
    float min_value=0.0,
    float max_value=0.0,
    str format = "%.3f",
    cimgui.ImGuiSliderFlags flags = 0,
    float power = 1. # OBSOLETED in 1.78 (from June 2020)
):
    """Display float drag widget with 2 values.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 130

        values = 88.0, 42.0

        imgui.begin("Example: drag float")
        changed, values = imgui.drag_float2(
            "Default", *values
        )
        changed, values = imgui.drag_float2(
            "Less precise", *values, format="%.1f"
        )
        imgui.text("Changed: %s, Values: %s" % (changed, values))
        imgui.end()

    Args:
        label (str): widget label.
        value0, value1 (float): drag values.
        change_speed (float): how fast values change on drag.
        min_value (float): min value allowed by widget.
        max_value (float): max value allowed by widget.
        format (str): display format string as C-style ``printf``
            format string. **Warning:** highly unsafe. See :any:`drag_float()`.
        flags: SliderFlags flags. See:
            :ref:`list of available flags <slider-flag-options>`.
        power (float): OBSOLETED in ImGui 1.78 (from June 2020)

    Returns:
        tuple: a ``(changed, values)`` tuple that contains indicator of
        widget state change and the tuple of current drag values.

    .. wraps::
        bool DragFloat2(
            const char* label,
            float v[2],
            float v_speed = 1.0f,
            float v_min = 0.0f,
            float v_max = 0.0f,
            const char* format = "%.3f",
            ImGuiSliderFlags flags = 0
        )
    """
    assert (power == 1), "power parameter obsoleted in ImGui 1.78, use imgui.SLIDER_FLAGS_LOGARITHMIC instead"
    cdef float[2] inout_values = [value0, value1]
    return cimgui.DragFloat2(
        _bytes(label), <float*>&inout_values,
        change_speed, min_value, max_value, _bytes(format), flags
    ), (inout_values[0], inout_values[1])


def drag_float3(
    str label, float value0, float value1, float value2,
    float change_speed = 1.0,
    float min_value=0.0,
    float max_value=0.0,
    str format = "%.3f",
    cimgui.ImGuiSliderFlags flags = 0,
    float power = 1. # OBSOLETED in 1.78 (from June 2020)
):
    """Display float drag widget with 3 values.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 130

        values = 88.0, 42.0, 69.0

        imgui.begin("Example: drag float")
        changed, values = imgui.drag_float3(
            "Default", *values
        )
        changed, values = imgui.drag_float3(
            "Less precise", *values, format="%.1f"
        )
        imgui.text("Changed: %s, Values: %s" % (changed, values))
        imgui.end()

    Args:
        label (str): widget label.
        value0, value1, value2 (float): drag values.
        change_speed (float): how fast values change on drag.
        min_value (float): min value allowed by widget.
        max_value (float): max value allowed by widget.
        format (str): display format string as C-style ``printf``
            format string. **Warning:** highly unsafe. See :any:`drag_float()`.
        flags: SliderFlags flags. See:
            :ref:`list of available flags <slider-flag-options>`.
        power (float): OBSOLETED in ImGui 1.78 (from June 2020)

    Returns:
        tuple: a ``(changed, values)`` tuple that contains indicator of
        widget state change and the tuple of current drag values.

    .. wraps::
        bool DragFloat3(
            const char* label,
            float v[3],
            float v_speed = 1.0f,
            float v_min = 0.0f,
            float v_max = 0.0f,
            const char* format = "%.3f",
            ImGuiSliderFlags flags = 0
        )
    """
    assert (power == 1), "power parameter obsoleted in ImGui 1.78, use imgui.SLIDER_FLAGS_LOGARITHMIC instead"
    cdef float[3] inout_values = [value0, value1, value2]
    return cimgui.DragFloat3(
        _bytes(label), <float*>&inout_values,
        change_speed, min_value, max_value, _bytes(format), flags
    ), (inout_values[0], inout_values[1], inout_values[2])


def drag_float4(
    str label, float value0, float value1, float value2, float value3,
    float change_speed = 1.0,
    float min_value=0.0,
    float max_value=0.0,
    str format = "%.3f",
    cimgui.ImGuiSliderFlags flags = 0,
    float power = 1. # OBSOLETED in 1.78 (from June 2020)
):
    """Display float drag widget with 4 values.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 130

        values = 88.0, 42.0, 69.0, 0.0

        imgui.begin("Example: drag float")
        changed, values = imgui.drag_float4(
            "Default", *values
        )
        changed, values = imgui.drag_float4(
            "Less precise", *values, format="%.1f"
        )
        imgui.text("Changed: %s, Values: %s" % (changed, values))
        imgui.end()

    Args:
        label (str): widget label.
        value0, value1, value2, value3 (float): drag values.
        change_speed (float): how fast values change on drag.
        min_value (float): min value allowed by widget.
        max_value (float): max value allowed by widget.
        format (str): display format string as C-style ``printf``
            format string. **Warning:** highly unsafe. See :any:`drag_float()`.
        flags: SliderFlags flags. See:
            :ref:`list of available flags <slider-flag-options>`.
        power (float): OBSOLETED in ImGui 1.78 (from June 2020)

    Returns:
        tuple: a ``(changed, values)`` tuple that contains indicator of
        widget state change and the tuple of current drag values.

    .. wraps::
        bool DragFloat4(
            const char* label,
            float v[4],
            float v_speed = 1.0f,
            float v_min = 0.0f,
            float v_max = 0.0f,
            const char* format = "%.3f",
            ImGuiSliderFlags flags = 0
        )
    """
    assert (power == 1), "power parameter obsoleted in ImGui 1.78, use imgui.SLIDER_FLAGS_LOGARITHMIC instead"
    cdef float[4] inout_values = [value0, value1, value2, value3]
    return cimgui.DragFloat4(
        _bytes(label), <float*>&inout_values,
        change_speed, min_value, max_value, _bytes(format), flags
    ), (inout_values[0], inout_values[1], inout_values[2], inout_values[3])

def drag_float_range2(
    str label,
    float current_min,
    float current_max,
    float speed = 1.0,
    float min_value = 0.0,
    float max_value = 0.0,
    str format = "%.3f",
    str format_max = None,
    cimgui.ImGuiSliderFlags flags = 0
    ):
    """Display drag float range widget

    Args:
        label (str): widget label
        current_min (float): current value of minimum
        current_max (float): current value of maximum
        speed (float): widget speed of change
        min_value (float): minimal possible value
        max_value (float): maximal possible value
        format (str): display format
        format_max (str): display format for maximum. If None, ``format`` parameter is used.
        flags: SliderFlags flags. See:
            :ref:`list of available flags <slider-flag-options>`.

    Returns:
        tuple: a (changed, current_min, current_max) tuple, where ``changed`` indicate
               that the value has been updated.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 130

        vmin = 0
        vmax = 100

        imgui.begin("Example: drag float range")
        changed, vmin, vmax = imgui.drag_float_range2( "Drag Range", vmin, vmax )
        imgui.text("Changed: %s, Range: (%.2f, %.2f)" % (changed, vmin, vmax))
        imgui.end()


    .. wraps::
        bool DragFloatRange2(
            const char* label,
            float* v_current_min,
            float* v_current_max,
            float v_speed = 1.0f,
            float v_min = 0.0f,
            float v_max = 0.0f,
            const char* format = "%.3f",
            const char* format_max = NULL,
            ImGuiSliderFlags flags = 0
        )
    """

    cdef float inout_current_min = current_min
    cdef float inout_current_max = current_max

    cdef bytes b_format_max;
    cdef char* p_format_max = NULL
    if format_max is not None:
        b_format_max = _bytes(format_max)
        p_format_max = b_format_max

    changed = cimgui.DragFloatRange2(
        _bytes(label),
        &inout_current_min,
        &inout_current_max,
        speed,
        min_value,
        max_value,
        _bytes(format),
        p_format_max,
        flags
    )

    return changed, inout_current_min, inout_current_max



def drag_int(
    str label, int value,
    float change_speed = 1.0,
    int min_value=0,
    int max_value=0,
    str format = "%d",
    cimgui.ImGuiSliderFlags flags = 0
):
    """Display int drag widget.

    .. todo::
        Consider replacing ``format`` with something that allows
        for safer way to specify display format without loosing the
        functionality of wrapped function.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 130

        value = 42

        imgui.begin("Example: drag int")
        changed, value = imgui.drag_int("drag int", value,)
        imgui.text("Changed: %s, Value: %s" % (changed, value))
        imgui.end()

    Args:
        label (str): widget label.
        value (int): drag value,
        change_speed (float): how fast values change on drag.
        min_value (int): min value allowed by widget.
        max_value (int): max value allowed by widget.
        format (str): display format string as C-style ``printf``
            format string. **Warning:** Highly unsafe when used without care.
            May lead to segmentation faults and other memory violation issues.
        flags: SliderFlags flags. See:
            :ref:`list of available flags <slider-flag-options>`.

    Returns:
        tuple: a ``(changed, value)`` tuple that contains indicator of
        widget state change and the current drag value.

    .. wraps::
        bool DragInt(
            const char* label,
            int* v,
            float v_speed = 1.0f,
            int v_min = 0.0f,
            int v_max = 0.0f,
            const char* format = "%d",
            ImGuiSliderFlags flags = 0
        )
    """
    cdef int inout_value = value

    return cimgui.DragInt(
        _bytes(label), &inout_value,
        change_speed, min_value, max_value, _bytes(format), flags
    ), inout_value


def drag_int2(
    str label, int value0, int value1,
    float change_speed = 1.0,
    int min_value=0,
    int max_value=0,
    str format = "%d",
    cimgui.ImGuiSliderFlags flags = 0
):
    """Display int drag widget with 2 values.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 130

        values = 88, 42

        imgui.begin("Example: drag int")
        changed, values = imgui.drag_int2(
            "drag ints", *values
        )
        imgui.text("Changed: %s, Values: %s" % (changed, values))
        imgui.end()

    Args:
        label (str): widget label.
        value0, value1 (int): drag values.
        change_speed (float): how fast values change on drag.
        min_value (int): min value allowed by widget.
        max_value (int): max value allowed by widget.
        format (str): display format string as C-style ``printf``
            format string. **Warning:** highly unsafe. See :any:`drag_int()`.
        flags: SliderFlags flags. See:
            :ref:`list of available flags <slider-flag-options>`.

    Returns:
        tuple: a ``(changed, values)`` tuple that contains indicator of
        widget state change and the tuple of current drag values.

    .. wraps::
        bool DragInt2(
            const char* label,
            int v[2],
            float v_speed = 1.0f,
            int v_min = 0.0f,
            int v_max = 0.0f,
            const char* format = "%d",
            ImGuiSliderFlags flags = 0
        )
    """
    cdef int[2] inout_values = [value0, value1]
    return cimgui.DragInt2(
        _bytes(label), <int*>&inout_values,
        change_speed, min_value, max_value, _bytes(format), flags
    ), (inout_values[0], inout_values[1])


def drag_int3(
    str label, int value0, int value1, int value2,
    float change_speed = 1.0,
    int min_value=0,
    int max_value=0,
    str format = "%d",
    cimgui.ImGuiSliderFlags flags = 0
):
    """Display int drag widget with 3 values.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 130

        values = 88, 42, 69

        imgui.begin("Example: drag int")
        changed, values = imgui.drag_int3(
            "drag ints", *values
        )
        imgui.text("Changed: %s, Values: %s" % (changed, values))
        imgui.end()

    Args:
        label (str): widget label.
        value0, value1 (int): drag values.
        change_speed (float): how fast values change on drag.
        min_value (int): min value allowed by widget.
        max_value (int): max value allowed by widget.
        format (str): display format string as C-style ``printf``
            format string. **Warning:** highly unsafe. See :any:`drag_int()`.
        flags: SliderFlags flags. See:
            :ref:`list of available flags <slider-flag-options>`.

    Returns:
        tuple: a ``(changed, values)`` tuple that contains indicator of
        widget state change and the tuple of current drag values.

    .. wraps::
        bool DragInt3(
            const char* label,
            int v[3],
            float v_speed = 1.0f,
            int v_min = 0.0f,
            int v_max = 0.0f,
            const char* format = "%d",
            ImGuiSliderFlags flags = 0
        )
    """
    cdef int[3] inout_values = [value0, value1, value2]
    return cimgui.DragInt3(
        _bytes(label), <int*>&inout_values,
        change_speed, min_value, max_value, _bytes(format), flags
    ), (inout_values[0], inout_values[1], inout_values[2])


def drag_int4(
    str label, int value0, int value1, int value2, int value3,
    float change_speed = 1.0,
    int min_value=0,
    int max_value=0,
    str format = "%d",
    cimgui.ImGuiSliderFlags flags = 0
):
    """Display int drag widget with 4 values.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 130

        values = 88, 42, 69, 0

        imgui.begin("Example: drag int")
        changed, values = imgui.drag_int4(
            "drag ints", *values
        )
        imgui.text("Changed: %s, Values: %s" % (changed, values))
        imgui.end()

    Args:
        label (str): widget label.
        value0, value1 (int): drag values.
        change_speed (float): how fast values change on drag.
        min_value (int): min value allowed by widget.
        max_value (int): max value allowed by widget.
        format (str): display format string as C-style ``printf``
            format string. **Warning:** highly unsafe. See :any:`drag_int()`.
        flags: SliderFlags flags. See:
            :ref:`list of available flags <slider-flag-options>`.

    Returns:
        tuple: a ``(changed, values)`` tuple that contains indicator of
        widget state change and the tuple of current drag values.

    .. wraps::
        bool DragInt4(
            const char* label,
            int v[4],
            float v_speed = 1.0f,
            int v_min = 0.0f,
            int v_max = 0.0f,
            const char* format = "%d",
            ImGuiSliderFlags flags = 0
        )
    """
    cdef int[4] inout_values = [value0, value1, value2, value3]
    return cimgui.DragInt4(
        _bytes(label), <int*>&inout_values,
        change_speed, min_value, max_value, _bytes(format), flags
    ), (inout_values[0], inout_values[1], inout_values[2], inout_values[3])

def drag_int_range2(
    str label,
    int current_min,
    int current_max,
    float speed = 1.0,
    int min_value = 0,
    int max_value = 0,
    str format = "%d",
    str format_max = None,
    cimgui.ImGuiSliderFlags flags = 0
    ):
    """Display drag int range widget

    Args:
        label (str): widget label
        current_min (int): current value of minimum
        current_max (int): current value of maximum
        speed (float): widget speed of change
        min_value (int): minimal possible value
        max_value (int): maximal possible value
        format (str): display format
        format_max (str): display format for maximum. If None, ``format`` parameter is used.
        flags: SliderFlags flags. See:
            :ref:`list of available flags <slider-flag-options>`.

    Returns:
        tuple: a (changed, current_min, current_max) tuple, where ``changed`` indicate
               that the value has been updated.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 130

        vmin = 0
        vmax = 100

        imgui.begin("Example: drag float range")
        changed, vmin, vmax = imgui.drag_int_range2( "Drag Range", vmin, vmax )
        imgui.text("Changed: %s, Range: (%d, %d)" % (changed, vmin, vmax))
        imgui.end()


    .. wraps::
        bool DragIntRange2(
            const char* label,
            int* v_current_min,
            int* v_current_max,
            float v_speed = 1.0f,
            int v_min = 0,
            int v_max = 0,
            const char* format = "%d",
            const char* format_max = NULL,
            ImGuiSliderFlags flags = 0
        )
    """

    cdef int inout_current_min = current_min
    cdef int inout_current_max = current_max

    cdef bytes b_format_max;
    cdef char* p_format_max = NULL
    if format_max is not None:
        b_format_max = _bytes(format_max)
        p_format_max = b_format_max

    changed = cimgui.DragIntRange2(
        _bytes(label),
        &inout_current_min,
        &inout_current_max,
        speed,
        min_value,
        max_value,
        _bytes(format),
        p_format_max,
        flags
    )

    return changed, inout_current_min, inout_current_max


def drag_scalar(
    str label,
    cimgui.ImGuiDataType data_type,
    bytes data,
    float change_speed,
    bytes min_value = None,
    bytes max_value = None,
    str format = None,
    cimgui.ImGuiSliderFlags flags = 0):
    """Display scalar drag widget.
    Data is passed via ``bytes`` and the type is separatelly given using ``data_type``.
    This is useful to work with specific types (e.g. unsigned 8bit integer, float, double)
    like when interfacing with Numpy.

    Args:
        label (str): widget label
        data_type: ImGuiDataType enum, type of the given data
        data (bytes): data value as a bytes array
        change_speed (float): how fast values change on drag
        min_value (bytes): min value allowed by widget
        max_value (bytes): max value allowed by widget
        format (str): display format string as C-style ``printf``
            format string. **Warning:** highly unsafe. See :any:`drag_int()`.
        flags: ImGuiSlider flags. See:
            :ref:`list of available flags <slider-flag-options>`.

    Returns:
        tuple: a ``(changed, value)`` tuple that contains indicator of
        drag state change and the current drag content.

    .. wraps::
        bool DragScalar(
            const char* label,
            ImGuiDataType data_type,
            void* p_data,
            float v_speed,
            const void* p_min = NULL,
            const void* p_max = NULL,
            const char* format = NULL,
            ImGuiSliderFlags flags = 0
        )
    """

    cdef char* p_data = data
    cdef char* p_min = NULL
    if min_value is not None:
        p_min = min_value
    cdef char* p_max = NULL
    if max_value is not None:
        p_max = max_value
    cdef char* fmt = NULL
    cdef bytes fmt_data;
    if format is not None:
        fmt_data = _bytes(format)
        fmt = fmt_data

    cdef changed = cimgui.DragScalar(
        _bytes(label),
        data_type,
        p_data,
        change_speed,
        p_min,
        p_max,
        fmt,
        flags
    )

    return changed, data

def drag_scalar_N(
    str label,
    cimgui.ImGuiDataType data_type,
    bytes data,
    int components,
    float change_speed,
    bytes min_value = None,
    bytes max_value = None,
    str format = None,
    cimgui.ImGuiSliderFlags flags = 0):
    """Display multiple scalar drag widget.
    Data is passed via ``bytes`` and the type is separatelly given using ``data_type``.
    This is useful to work with specific types (e.g. unsigned 8bit integer, float, double)
    like when interfacing with Numpy.

    Args:
        label (str): widget label
        data_type: ImGuiDataType enum, type of the given data
        data (bytes): data value as a bytes array
        components (int): number of widgets
        change_speed (float): how fast values change on drag
        min_value (bytes): min value allowed by widget
        max_value (bytes): max value allowed by widget
        format (str): display format string as C-style ``printf``
            format string. **Warning:** highly unsafe. See :any:`drag_int()`.
        flags: ImGuiSlider flags. See:
            :ref:`list of available flags <slider-flag-options>`.

    Returns:
        tuple: a ``(changed, value)`` tuple that contains indicator of
        drag state change and the current drag content.

    .. wraps::
        bool DragScalarN(
            const char* label,
            ImGuiDataType data_type,
            void* p_data,
            int components,
            float v_speed,
            const void* p_min = NULL,
            const void* p_max = NULL,
            const char* format = NULL,
            ImGuiSliderFlags flags = 0
        )
    """

    cdef char* p_data = data
    cdef char* p_min = NULL
    if min_value is not None:
        p_min = min_value
    cdef char* p_max = NULL
    if max_value is not None:
        p_max = max_value
    cdef char* fmt = NULL
    cdef bytes fmt_data;
    if format is not None:
        fmt_data = _bytes(format)
        fmt = fmt_data

    cdef changed = cimgui.DragScalarN(
        _bytes(label),
        data_type,
        p_data,
        components,
        change_speed,
        p_min,
        p_max,
        fmt,
        flags
    )

    return changed, data

def input_text(
    str label,
    str value,
    int buffer_length = -1,
    cimgui.ImGuiInputTextFlags flags=0,
    object callback = None,
    user_data = None
):
    """Display text input widget.

    The ``buffer_length`` is the maximum allowed length of the content. It is the size in bytes, which may not correspond to the number of characters.
    If set to -1, the internal buffer will have an adaptive size, which is equivalent to using the ``imgui.INPUT_TEXT_CALLBACK_RESIZE`` flag.
    When a callback is provided, it is called after the internal buffer has been resized.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 100

        text_val = 'Please, type the coefficient here.'
        imgui.begin("Example: text input")
        changed, text_val = imgui.input_text('Coefficient:', text_val)
        imgui.text('You wrote:')
        imgui.same_line()
        imgui.text(text_val)
        imgui.end()

    Args:
        label (str): widget label.
        value (str): textbox value
        buffer_length (int): length of the content buffer
        flags: InputText flags. See:
            :ref:`list of available flags <inputtext-flag-options>`.
        callback (callable): a callable that is called depending on choosen flags.
            Callable takes an imgui._ImGuiInputTextCallbackData object as argument
            Callable should return None or integer
        user_data: Any data that the user want to use in the callback.

    Returns:
        tuple: a ``(changed, value)`` tuple that contains indicator of
        textbox state change and the current text contents.

    .. wraps::
        bool InputText(
            const char* label,
            char* buf,
            size_t buf_size,
            ImGuiInputTextFlags flags = 0,
            ImGuiInputTextCallback callback = NULL,
            void* user_data = NULL
        )
    """

    _value_bytes = _bytes(value)
    cdef int _buffer_length = buffer_length+1
    if buffer_length < 0:
        _buffer_length = len(_value_bytes)+1
        flags = flags | enums.ImGuiInputTextFlags_CallbackResize
    _input_text_shared_buffer.reserve_memory(_buffer_length)
    strncpy(_input_text_shared_buffer.buffer, _value_bytes, _buffer_length)

    cdef _callback_user_info _user_info = _callback_user_info()
    cdef cimgui.ImGuiInputTextCallback _callback = NULL
    cdef void *_user_data = NULL
    if callback is not None:
        _callback = _ImGuiInputTextCallback
        _user_info.populate(callback, user_data)
        _user_data = <void*>_user_info
    elif flags & enums.ImGuiInputTextFlags_CallbackResize:
        _callback = _ImGuiInputTextOnlyResizeCallback
        _user_data = <void*>_user_info

    changed = cimgui.InputText(
        _bytes(label), _input_text_shared_buffer.buffer, _buffer_length, flags, _callback, _user_data
    )
    _buffer_length = strlen(_input_text_shared_buffer.buffer)
    output = _from_bytes(_input_text_shared_buffer.buffer[:_buffer_length])

    return changed, output


def input_text_multiline(
    str label,
    str value,
    int buffer_length = -1,
    float width=0,
    float height=0,
    cimgui.ImGuiInputTextFlags flags=0,
    object callback = None,
    user_data = None
):
    """Display multiline text input widget.

    The ``buffer_length`` is the maximum allowed length of the content. It is the size in bytes, which may not correspond to the number of characters.
    If set to -1, the internal buffer will have an adaptive size, which is equivalent to using the ``imgui.INPUT_TEXT_CALLBACK_RESIZE`` flag.
    When a callback is provided, it is called after the internal buffer has been resized.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 200

        text_val = 'Type the your message here.'
        imgui.begin("Example: text input")
        changed, text_val = imgui.input_text_multiline(
            'Message:',
            text_val,
            2056
        )
        imgui.text('You wrote:')
        imgui.same_line()
        imgui.text(text_val)
        imgui.end()

    Args:
        label (str): widget label.
        value (str): textbox value
        buffer_length (int): length of the content buffer
        width (float): width of the textbox
        height (float): height of the textbox
        flags: InputText flags. See:
            :ref:`list of available flags <inputtext-flag-options>`.
        callback (callable): a callable that is called depending on choosen flags.
            Callable takes an imgui._ImGuiInputTextCallbackData object as argument
            Callable should return None or integer
        user_data: Any data that the user want to use in the callback.

    Returns:
        tuple: a ``(changed, value)`` tuple that contains indicator of
        textbox state change and the current text contents.

    .. wraps::
        bool InputTextMultiline(
            const char* label,
            char* buf,
            size_t buf_size,
            const ImVec2& size = ImVec2(0,0),
            ImGuiInputTextFlags flags = 0,
            ImGuiInputTextCallback callback = NULL,
            void* user_data = NULL
        )
    """

    _value_bytes = _bytes(value)
    cdef int _buffer_length = buffer_length+1
    if buffer_length < 0:
        _buffer_length = len(_value_bytes)+1
        flags = flags | enums.ImGuiInputTextFlags_CallbackResize
    _input_text_shared_buffer.reserve_memory(_buffer_length)
    strncpy(_input_text_shared_buffer.buffer, _value_bytes, _buffer_length)

    cdef _callback_user_info _user_info = _callback_user_info()
    cdef cimgui.ImGuiInputTextCallback _callback = NULL
    cdef void *_user_data = NULL
    if callback is not None:
        _callback = _ImGuiInputTextCallback
        _user_info.populate(callback, user_data)
        _user_data = <void*>_user_info
    elif flags & enums.ImGuiInputTextFlags_CallbackResize:
        _callback = _ImGuiInputTextOnlyResizeCallback
        _user_data = <void*>_user_info

    changed = cimgui.InputTextMultiline(
        _bytes(label), _input_text_shared_buffer.buffer, _buffer_length,
        _cast_args_ImVec2(width, height), flags,
        _callback, _user_data
    )
    _buffer_length = strlen(_input_text_shared_buffer.buffer)
    output = _from_bytes(_input_text_shared_buffer.buffer[:_buffer_length])

    return changed, output

    

def input_text_with_hint(
    str label,
    str hint,
    str value,
    int buffer_length = -1,
    cimgui.ImGuiInputTextFlags flags = 0,
    object callback = None,
    user_data = None):
    """Display a text box, if the text is empty a hint on how to fill the box is given.

    The ``buffer_length`` is the maximum allowed length of the content. It is the size in bytes, which may not correspond to the number of characters.
    If set to -1, the internal buffer will have an adaptive size, which is equivalent to using the ``imgui.INPUT_TEXT_CALLBACK_RESIZE`` flag.
    When a callback is provided, it is called after the internal buffer has been resized.

    Args:
        label (str): Widget label
        hing (str): Hint displayed if text value empty
        value (str): Text value
        buffer_length (int): Length of the content buffer
        flags: InputText flags. See:
            :ref:`list of available flags <inputtext-flag-options>`.
        callback (callable): a callable that is called depending on choosen flags.
            Callable takes an imgui._ImGuiInputTextCallbackData object as argument
            Callable should return None or integer
        user_data: Any data that the user want to use in the callback.

    Returns:
        tuple: a ``(changed, value)`` tuple that contains indicator of
        textbox state change and the current text contents.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 200

        text_val = ''
        imgui.begin("Example Text With hing")
        changed, text_val = imgui.input_text_with_hint(
            'Email', 'your@email.com',
            text_val, 255)
        imgui.end()

    .. wraps::
        bool InputTextWithHint(
            const char* label,
            const char* hint,
            char* buf,
            size_t buf_size,
            ImGuiInputTextFlags flags = 0,
            ImGuiInputTextCallback callback = NULL,
            void* user_data = NULL
        )
    """

    _value_bytes = _bytes(value)
    cdef int _buffer_length = buffer_length+1
    if buffer_length < 0:
        _buffer_length = len(_value_bytes)+1
        flags = flags | enums.ImGuiInputTextFlags_CallbackResize
    _input_text_shared_buffer.reserve_memory(_buffer_length)
    strncpy(_input_text_shared_buffer.buffer, _value_bytes, _buffer_length)

    cdef _callback_user_info _user_info = _callback_user_info()
    cdef cimgui.ImGuiInputTextCallback _callback = NULL
    cdef void *_user_data = NULL
    if callback is not None:
        _callback = _ImGuiInputTextCallback
        _user_info.populate(callback, user_data)
        _user_data = <void*>_user_info
    elif flags & enums.ImGuiInputTextFlags_CallbackResize:
        _callback = _ImGuiInputTextOnlyResizeCallback
        _user_data = <void*>_user_info

    changed = cimgui.InputTextWithHint(
        _bytes(label), _bytes(hint), _input_text_shared_buffer.buffer, _buffer_length,
        flags, _callback, _user_data
    )
    _buffer_length = strlen(_input_text_shared_buffer.buffer)
    output = _from_bytes(_input_text_shared_buffer.buffer[:_buffer_length])

    return changed, output

def input_float(
    str label,
    float value,
    float step=0.0,
    float step_fast=0.0,
    str format = "%.3f",
    cimgui.ImGuiInputTextFlags flags=0
):
    """Display float input widget.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 100

        float_val = 0.4
        imgui.begin("Example: float input")
        changed, float_val = imgui.input_float('Type coefficient:', float_val)
        imgui.text('You wrote: %f' % float_val)
        imgui.end()

    Args:
        label (str): widget label.
        value (float): textbox value
        step (float): incremental step
        step_fast (float): fast incremental step
        format = (str): format string
        flags: InputText flags. See:
            :ref:`list of available flags <inputtext-flag-options>`.

    Returns:
        tuple: a ``(changed, value)`` tuple that contains indicator of
        textbox state change and the current textbox content.

    .. wraps::
        bool InputFloat(
            const char* label,
            float* v,
            float step = 0.0f,
            float step_fast = 0.0f,
            const char* format = "%.3f",
            ImGuiInputTextFlags extra_flags = 0
        )
    """
    cdef float inout_value = value

    return cimgui.InputFloat(
        _bytes(label), &inout_value, step,
        step_fast, _bytes(format), flags
    ), inout_value

def input_float2(
    str label,
    float value0, float value1,
    str format = "%.3f",
    cimgui.ImGuiInputTextFlags flags=0
):
    """Display two-float input widget.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 100

        values = 0.4, 3.2
        imgui.begin("Example: two float inputs")
        changed, values = imgui.input_float2('Type here:', *values)
        imgui.text("Changed: %s, Values: %s" % (changed, values))
        imgui.end()

    Args:
        label (str): widget label.
        value0, value1 (float): input values.
        format = (str): format string
        flags: InputText flags. See:
            :ref:`list of available flags <inputtext-flag-options>`.

    Returns:
        tuple: a ``(changed, values)`` tuple that contains indicator of
        textbox state change and the tuple of current values.

    .. wraps::
        bool InputFloat2(
            const char* label,
            float v[2],
            const char* format = "%.3f",
            ImGuiInputTextFlags extra_flags = 0
        )
    """
    cdef float[2] inout_values = [value0, value1]

    return cimgui.InputFloat2(
        _bytes(label), <float*>&inout_values,
        _bytes(format), flags
    ), (inout_values[0], inout_values[1])

def input_float3(
    str label,
    float value0, float value1, float value2,
    str format = "%.3f",
    cimgui.ImGuiInputTextFlags flags=0
):
    """Display three-float input widget.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 100

        values = 0.4, 3.2, 29.3
        imgui.begin("Example: three float inputs")
        changed, values = imgui.input_float3('Type here:', *values)
        imgui.text("Changed: %s, Values: %s" % (changed, values))
        imgui.end()

    Args:
        label (str): widget label.
        value0, value1, value2 (float): input values.
        format = (str): format string
        flags: InputText flags. See:
            :ref:`list of available flags <inputtext-flag-options>`.

    Returns:
        tuple: a ``(changed, values)`` tuple that contains indicator of
        textbox state change and the tuple of current values.

    .. wraps::
        bool InputFloat3(
            const char* label,
            float v[3],
            const char* format = "%.3f",
            ImGuiInputTextFlags extra_flags = 0
        )
    """
    cdef float[3] inout_values = [value0, value1, value2]

    return cimgui.InputFloat3(
        _bytes(label), <float*>&inout_values,
        _bytes(format), flags
    ), (inout_values[0], inout_values[1], inout_values[2])

def input_float4(
    str label,
    float value0, float value1, float value2, float value3,
    str format = "%.3f",
    cimgui.ImGuiInputTextFlags flags=0
):
    """Display four-float input widget.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 100

        values = 0.4, 3.2, 29.3, 12.9
        imgui.begin("Example: four float inputs")
        changed, values = imgui.input_float4('Type here:', *values)
        imgui.text("Changed: %s, Values: %s" % (changed, values))
        imgui.end()

    Args:
        label (str): widget label.
        value0, value1, value2, value3 (float): input values.
        format = (str): format string
        flags: InputText flags. See:
            :ref:`list of available flags <inputtext-flag-options>`.

    Returns:
        tuple: a ``(changed, values)`` tuple that contains indicator of
        textbox state change and the tuple of current values.

    .. wraps::
        bool InputFloat4(
            const char* label,
            float v[4],
            const char* format = "%.3f",
            ImGuiInputTextFlags extra_flags = 0
        )
    """
    cdef float[4] inout_values = [value0, value1, value2, value3]

    return cimgui.InputFloat4(
        _bytes(label), <float*>&inout_values,
        _bytes(format), flags
    ), (inout_values[0], inout_values[1], inout_values[2], inout_values[3])


def input_int(
    str label,
    int value,
    int step=1,
    int step_fast=100,
    cimgui.ImGuiInputTextFlags flags=0
):
    """Display integer input widget.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 100

        int_val = 3
        imgui.begin("Example: integer input")
        changed, int_val = imgui.input_int('Type multiplier:', int_val)
        imgui.text('You wrote: %i' % int_val)
        imgui.end()

    Args:
        label (str): widget label.
        value (int): textbox value
        step (int): incremental step
        step_fast (int): fast incremental step
        flags: InputText flags. See:
            :ref:`list of available flags <inputtext-flag-options>`.

    Returns:
        tuple: a ``(changed, value)`` tuple that contains indicator of
        textbox state change and the current textbox content.

    .. wraps::
        bool InputInt(
            const char* label,
            int* v,
            int step = 1,
            int step_fast = 100,
            ImGuiInputTextFlags extra_flags = 0
        )
    """
    cdef int inout_value = value

    return cimgui.InputInt(
        _bytes(label), &inout_value, step, step_fast, flags
    ), inout_value


def input_int2(
    str label,
    int value0, int value1,
    cimgui.ImGuiInputTextFlags flags=0
):
    """Display two-integer input widget.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 100

        values = 4, 12
        imgui.begin("Example: two int inputs")
        changed, values = imgui.input_int2('Type here:', *values)
        imgui.text("Changed: %s, Values: %s" % (changed, values))
        imgui.end()

    Args:
        label (str): widget label.
        value0, value1 (int): textbox values
        flags: InputText flags. See:
            :ref:`list of available flags <inputtext-flag-options>`.

    Returns:
        tuple: a ``(changed, value)`` tuple that contains indicator of
        textbox state change and the current textbox content.

    .. wraps::
        bool InputInt2(
            const char* label,
            int v[2],
            ImGuiInputTextFlags extra_flags = 0
        )
    """
    cdef int[2] inout_values = [value0, value1]

    return cimgui.InputInt2(
        _bytes(label), <int*>&inout_values, flags
    ), [inout_values[0], inout_values[1]]


def input_int3(
    str label,
    int value0, int value1, int value2,
    cimgui.ImGuiInputTextFlags flags=0
):
    """Display three-integer input widget.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 100

        values = 4, 12, 28
        imgui.begin("Example: three int inputs")
        changed, values = imgui.input_int3('Type here:', *values)
        imgui.text("Changed: %s, Values: %s" % (changed, values))
        imgui.end()

    Args:
        label (str): widget label.
        value0, value1, value2 (int): textbox values
        flags: InputText flags. See:
            :ref:`list of available flags <inputtext-flag-options>`.

    Returns:
        tuple: a ``(changed, value)`` tuple that contains indicator of
        textbox state change and the current textbox content.

    .. wraps::
        bool InputInt3(
            const char* label,
            int v[3],
            ImGuiInputTextFlags extra_flags = 0
        )
    """
    cdef int[3] inout_values = [value0, value1, value2]

    return cimgui.InputInt3(
        _bytes(label), <int*>&inout_values, flags
    ), [inout_values[0], inout_values[1], inout_values[2]]


def input_int4(
    str label,
    int value0, int value1, int value2, int value3,
    cimgui.ImGuiInputTextFlags flags=0
):
    """Display four-integer input widget.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 100

        values = 4, 12, 28, 73
        imgui.begin("Example: four int inputs")
        changed, values = imgui.input_int4('Type here:', *values)
        imgui.text("Changed: %s, Values: %s" % (changed, values))
        imgui.end()

    Args:
        label (str): widget label.
        value0, value1, value2, value3 (int): textbox values
        flags: InputText flags. See:
            :ref:`list of available flags <inputtext-flag-options>`.

    Returns:
        tuple: a ``(changed, value)`` tuple that contains indicator of
        textbox state change and the current textbox content.

    .. wraps::
        bool InputInt4(
            const char* label,
            int v[4],
            ImGuiInputTextFlags extra_flags = 0
        )
    """
    cdef int[4] inout_values = [value0, value1, value2, value3]

    return cimgui.InputInt4(
        _bytes(label), <int*>&inout_values, flags
    ), [inout_values[0], inout_values[1], inout_values[2], inout_values[3]]


def input_double(
    str label,
    double value,
    double step=0.0,
    double step_fast=0.0,
    str format = "%.6f",
    cimgui.ImGuiInputTextFlags flags=0
):
    """Display double input widget.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 100

        double_val = 3.14159265358979323846
        imgui.begin("Example: double input")
        changed, double_val = imgui.input_double('Type multiplier:', double_val)
        imgui.text('You wrote: %i' % double_val)
        imgui.end()

    Args:
        label (str): widget label.
        value (double): textbox value
        step (double): incremental step
        step_fast (double): fast incremental step
        format = (str): format string
        flags: InputText flags. See:
            :ref:`list of available flags <inputtext-flag-options>`.

    Returns:
        tuple: a ``(changed, value)`` tuple that contains indicator of
        textbox state change and the current textbox content.

    .. wraps::
        bool InputDouble(
            const char* label,
            double* v,
            double step = 0.0,
            double step_fast = 0.0,
            _bytes(format),
            ImGuiInputTextFlags extra_flags = 0
        )
    """
    cdef double inout_value = value

    return cimgui.InputDouble(
        _bytes(label), &inout_value, step, step_fast, _bytes(format), flags
    ), inout_value

def input_scalar(
    str label,
    cimgui.ImGuiDataType data_type,
    bytes data,
    bytes step = None,
    bytes step_fast = None,
    str format = None,
    cimgui.ImGuiInputTextFlags flags = 0):
    """Display scalar input widget.
    Data is passed via ``bytes`` and the type is separatelly given using ``data_type``.
    This is useful to work with specific types (e.g. unsigned 8bit integer, float, double)
    like when interfacing with Numpy.

    Args:
        label (str): widget label
        data_type: ImGuiDataType enum, type of the given data
        data (bytes): data value as a bytes array
        step (bytes): incremental step
        step_fast (bytes): fast incremental step
        format (str): format string
        flags: InputText flags. See:
            :ref:`list of available flags <inputtext-flag-options>`.

    Returns:
        tuple: a ``(changed, value)`` tuple that contains indicator of
        input state change and the current input content.

    .. wraps::
        bool InputScalar(
            const char* label,
            ImGuiDataType data_type,
            void* p_data,
            const void* p_step = NULL,
            const void* p_step_fast = NULL,
            const char* format = NULL,
            ImGuiInputTextFlags flags = 0
        )
    """

    cdef char* p_data = data
    cdef char* p_step = NULL
    if step is not None:
        p_step = step
    cdef char* p_step_fast = NULL
    if step_fast is not None:
        p_step_fast = step_fast
    cdef char* fmt = NULL
    cdef bytes fmt_data;
    if format is not None:
        fmt_data = _bytes(format)
        fmt = fmt_data

    cdef changed = cimgui.InputScalar(
        _bytes(label),
        data_type,
        p_data,
        p_step,
        p_step_fast,
        fmt,
        flags
    )

    return changed, data

def input_scalar_N(
    str label,
    cimgui.ImGuiDataType data_type,
    bytes data,
    int components,
    bytes step = None,
    bytes step_fast = None,
    str format = None,
    cimgui.ImGuiInputTextFlags flags = 0):
    """Display multiple scalar input widget.
    Data is passed via ``bytes`` and the type is separatelly given using ``data_type``.
    This is useful to work with specific types (e.g. unsigned 8bit integer, float, double)
    like when interfacing with Numpy.

    Args:
        label (str): widget label
        data_type: ImGuiDataType enum, type of the given data
        data (bytes): data value as a bytes array
        components (int): number of components to display
        step (bytes): incremental step
        step_fast (bytes): fast incremental step
        format (str): format string
        flags: InputText flags. See:
            :ref:`list of available flags <inputtext-flag-options>`.

    Returns:
        tuple: a ``(changed, value)`` tuple that contains indicator of
        input state change and the current input content.

    .. wraps::
        bool InputScalarN(
            const char* label,
            ImGuiDataType data_type,
            void* p_data,
            int components,
            const void* p_step = NULL,
            const void* p_step_fast = NULL,
            const char* format = NULL,
            ImGuiInputTextFlags flags = 0
        )
    """

    cdef char* p_data = data
    cdef char* p_step = NULL
    if step is not None:
        p_step = step
    cdef char* p_step_fast = NULL
    if step_fast is not None:
        p_step_fast = step_fast
    cdef char* fmt = NULL
    cdef bytes fmt_data;
    if format is not None:
        fmt_data = _bytes(format)
        fmt = fmt_data

    cdef changed = cimgui.InputScalarN(
        _bytes(label),
        data_type,
        p_data,
        components,
        p_step,
        p_step_fast,
        fmt,
        flags
    )

    return changed, data

def slider_float(
    str label,
    float value,
    float min_value,
    float max_value,
    str format = "%.3f",
    cimgui.ImGuiSliderFlags flags = 0,
    float power=1.0 # OBSOLETED in 1.78 (from June 2020)
):
    """Display float slider widget.
    Manually input values aren't clamped and can go off-bounds.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 130

        value = 88.2

        imgui.begin("Example: slider float")
        changed, value = imgui.slider_float(
            "slide floats", value,
            min_value=0.0, max_value=100.0,
            format="%.0f"
        )
        imgui.text("Changed: %s, Value: %s" % (changed, value))
        imgui.end()

    Args:
        label (str): widget label.
        value (float): slider values.
        min_value (float): min value allowed by widget.
        max_value (float): max value allowed by widget.
        format (str): display format string as C-style ``printf``
            format string. **Warning:** highly unsafe.
            See :any:`slider_float()`.
        flags: SliderFlags flags. See:
            :ref:`list of available flags <slider-flag-options>`.
        power (float): OBSOLETED in ImGui 1.78 (from June 2020)

    Returns:
        tuple: a ``(changed, values)`` tuple that contains indicator of
        widget state change and the current slider value.

    .. wraps::
        bool SliderFloat(
            const char* label,
            float v,
            float v_min,
            float v_max,
            const char* format = "%.3f",
            ImGuiSliderFlags flags = 0
        )
    """
    assert (power == 1), "power parameter obsoleted in ImGui 1.78, use imgui.SLIDER_FLAGS_LOGARITHMIC instead"
    cdef float inout_value = value
    return cimgui.SliderFloat(
        _bytes(label), <float*>&inout_value,
        min_value, max_value, _bytes(format), flags
    ), inout_value


def slider_float2(
    str label,
    float value0, float value1,
    float min_value,
    float max_value,
    str format = "%.3f",
    cimgui.ImGuiSliderFlags flags = 0,
    float power=1.0 # OBSOLETED in 1.78 (from June 2020)
):
    """Display float slider widget with 2 values.
    Manually input values aren't clamped and can go off-bounds.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 130

        values = 88.2, 42.6

        imgui.begin("Example: slider float2")
        changed, values = imgui.slider_float2(
            "slide floats", *values,
            min_value=0.0, max_value=100.0,
            format="%.0f"
        )
        imgui.text("Changed: %s, Values: %s" % (changed, values))
        imgui.end()
    
    Args:
        label (str): widget label.
        value0, value1 (float): slider values.
        min_value (float): min value allowed by widget.
        max_value (float): max value allowed by widget.
        format (str): display format string as C-style ``printf``
            format string. **Warning:** highly unsafe.
            See :any:`slider_float()`.
        flags: SliderFlags flags. See:
            :ref:`list of available flags <slider-flag-options>`.
        power (float): OBSOLETED in ImGui 1.78 (from June 2020)

    Returns:
        tuple: a ``(changed, values)`` tuple that contains indicator of
        widget state change and the tuple of current slider values.

    .. wraps::
        bool SliderFloat2(
            const char* label,
            float v[2],
            float v_min,
            float v_max,
            const char* format = "%.3f",
            ImGuiSliderFlags flags = 0
        )
    
    """
    assert (power == 1), "power parameter obsoleted in ImGui 1.78, use imgui.SLIDER_FLAGS_LOGARITHMIC instead"
    cdef float[2] inout_values = [value0, value1]
    return cimgui.SliderFloat2(
        _bytes(label), <float*>&inout_values,
        min_value, max_value, _bytes(format), flags
    ), (inout_values[0], inout_values[1])


def slider_float3(
    str label,
    float value0, float value1, float value2,
    float min_value,
    float max_value,
    str format = "%.3f",
    cimgui.ImGuiSliderFlags flags = 0,
    float power=1.0 # OBSOLETED in 1.78 (from June 2020)
):
    """Display float slider widget with 3 values.
    Manually input values aren't clamped and can go off-bounds.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 130

        values = 88.2, 42.6, 69.1

        imgui.begin("Example: slider float3")
        changed, values = imgui.slider_float3(
            "slide floats", *values,
            min_value=0.0, max_value=100.0,
            format="%.0f"
        )
        imgui.text("Changed: %s, Values: %s" % (changed, values))
        imgui.end()

    Args:
        label (str): widget label.
        value0, value1, value2 (float): slider values.
        min_value (float): min value allowed by widget.
        max_value (float): max value allowed by widget.
        format (str): display format string as C-style ``printf``
            format string. **Warning:** highly unsafe.
            See :any:`slider_float()`.
        flags: SliderFlags flags. See:
            :ref:`list of available flags <slider-flag-options>`.
        power (float): OBSOLETED in ImGui 1.78 (from June 2020)

    Returns:
        tuple: a ``(changed, values)`` tuple that contains indicator of
        widget state change and the tuple of current slider values.

    .. wraps::
        bool SliderFloat3(
            const char* label,
            float v[3],
            float v_min,
            float v_max,
            const char* format = "%.3f",
            ImGuiSliderFlags flags = 0
        )
    """
    assert (power == 1), "power parameter obsoleted in ImGui 1.78, use imgui.SLIDER_FLAGS_LOGARITHMIC instead"
    cdef float[3] inout_values = [value0, value1, value2]
    return cimgui.SliderFloat3(
        _bytes(label), <float*>&inout_values,
        min_value, max_value, _bytes(format), flags
    ), (inout_values[0], inout_values[1], inout_values[2])


def slider_float4(
    str label,
    float value0, float value1, float value2, float value3,
    float min_value,
    float max_value,
    str format = "%.3f",
    cimgui.ImGuiSliderFlags flags = 0,
    float power=1.0 # OBSOLETED in 1.78 (from June 2020)
):
    """Display float slider widget with 4 values.
    Manually input values aren't clamped and can go off-bounds.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 130

        values = 88.2, 42.6, 69.1, 0.3

        imgui.begin("Example: slider float4")
        changed, values = imgui.slider_float4(
            "slide floats", *values,
            min_value=0.0, max_value=100.0,
            format="%.0f"
        )
        imgui.text("Changed: %s, Values: %s" % (changed, values))
        imgui.end()

    Args:
        label (str): widget label.
        value0, value1, value2, value3 (float): slider values.
        min_value (float): min value allowed by widget.
        max_value (float): max value allowed by widget.
        format (str): display format string as C-style ``printf``
            format string. **Warning:** highly unsafe.
            See :any:`slider_float()`.
        flags: SliderFlags flags. See:
            :ref:`list of available flags <slider-flag-options>`.
        power (float): OBSOLETED in ImGui 1.78 (from June 2020)

    Returns:
        tuple: a ``(changed, values)`` tuple that contains indicator of
        widget state change and the tuple of current slider values.

    .. wraps::
        bool SliderFloat4(
            const char* label,
            float v[4],
            float v_min,
            float v_max,
            const char* format = "%.3f",
            ImGuiSliderFlags flags = 0
        )
    """
    assert (power == 1), "power parameter obsoleted in ImGui 1.78, use imgui.SLIDER_FLAGS_LOGARITHMIC instead"
    cdef float[4] inout_values = [value0, value1, value2, value3]
    return cimgui.SliderFloat4(
        _bytes(label), <float*>&inout_values,
        min_value, max_value, _bytes(format), flags
    ), (inout_values[0], inout_values[1], inout_values[2], inout_values[3])

def slider_angle(
    str label,
    float rad_value,
    float value_degrees_min = -360.0,
    float value_degrees_max = 360,
    str format = "%.0f deg",
    cimgui.ImGuiSliderFlags flags = 0):
    """Display angle slider widget.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 130

        radian = 3.1415/4

        imgui.begin("Example: slider angle")
        changed, radian = imgui.slider_angle(
            "slider angle", radian,
            value_degrees_min=0.0, value_degrees_max=180.0)
        imgui.text("Changed: %s, Value: %s" % (changed, radian))
        imgui.end()

    Args:
        labal (str): widget label
        rad_value (float): slider value in radian
        value_degrees_min (float): min value allowed in degrees
        value_degrees_max (float): max value allowed in degrees
        format (str): display format string as C-style ``printf``
            format string. **Warning:** highly unsafe.
        flags: SliderFlags flags. See:
            :ref:`list of available flags <slider-flag-options>`.

    Returns:
        tuple: a ``(changed, rad_value)`` tuple that contains indicator of
        widget state change and the current slider value in radian.


    .. wraps::
        bool SliderAngle(
            const char* label,
            float* v_rad, float
            v_degrees_min = -360.0f,
            float v_degrees_max = +360.0f,
            const char* format = "%.0f deg",
            ImGuiSliderFlags flags = 0
        )

    """
    cdef float inout_r_value = rad_value
    return cimgui.SliderAngle(
        _bytes(label), <float*>&inout_r_value,
        value_degrees_min, value_degrees_max,
        _bytes(format), flags
    ), inout_r_value

def slider_int(
    str label,
    int value,
    int min_value,
    int max_value,
    str format = "%.f",
    cimgui.ImGuiSliderFlags flags = 0
):
    """Display int slider widget

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 130

        value = 88

        imgui.begin("Example: slider int")
        changed, values = imgui.slider_int(
            "slide ints", value,
            min_value=0, max_value=100,
            format="%d"
        )
        imgui.text("Changed: %s, Values: %s" % (changed, value))
        imgui.end()

    Args:
        label (str): widget label.
        value (int): slider value.
        min_value (int): min value allowed by widget.
        max_value (int): max value allowed by widget.
        format (str): display format string as C-style ``printf``
            format string. **Warning:** highly unsafe.
            See :any:`slider_int()`.
        flags: SliderFlags flags. See:
            :ref:`list of available flags <slider-flag-options>`.

    Returns:
        tuple: a ``(changed, value)`` tuple that contains indicator of
        widget state change and the slider value.

    .. wraps::
        bool SliderInt(
            const char* label,
            int v,
            int v_min,
            int v_max,
            const char* format = "%.3f",
            ImGuiSliderFlags flags = 0
        )
    """
    cdef int inout_value = value
    return cimgui.SliderInt(
        _bytes(label), <int*>&inout_value,
        min_value, max_value, _bytes(format), flags
    ), inout_value


def slider_int2(
    str label,
    int value0, int value1,
    int min_value,
    int max_value,
    str format = "%.f",
    cimgui.ImGuiSliderFlags flags = 0
):
    """Display int slider widget with 2 values.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 130

        values = 88, 27

        imgui.begin("Example: slider int2")
        changed, values = imgui.slider_int2(
            "slide ints2", *values,
            min_value=0, max_value=100,
            format="%d"
        )
        imgui.text("Changed: %s, Values: %s" % (changed, values))
        imgui.end()

    Args:
        label (str): widget label.
        value0, value1 (int): slider values.
        min_value (int): min value allowed by widget.
        max_value (int): max value allowed by widget.
        format (str): display format string as C-style ``printf``
            format string. **Warning:** highly unsafe.
            See :any:`slider_int()`.
        flags: SliderFlags flags. See:
            :ref:`list of available flags <slider-flag-options>`.

    Returns:
        tuple: a ``(changed, values)`` tuple that contains indicator of
        widget state change and the tuple of current slider values.

    .. wraps::
        bool SliderInt2(
            const char* label,
            int v[2],
            int v_min,
            int v_max,
            const char* format = "%.3f",
            ImGuiSliderFlags flags = 0
        )
    """
    cdef int[2] inout_values = [value0, value1]
    return cimgui.SliderInt2(
        _bytes(label), <int*>&inout_values,
        min_value, max_value, _bytes(format), flags
    ), (inout_values[0], inout_values[1])


def slider_int3(
    str label,
    int value0, int value1, int value2,
    int min_value,
    int max_value,
    str format = "%.f",
    cimgui.ImGuiSliderFlags flags = 0
):
    """Display int slider widget with 3 values.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 130

        values = 88, 27, 3

        imgui.begin("Example: slider int3")
        changed, values = imgui.slider_int3(
            "slide ints3", *values,
            min_value=0, max_value=100,
            format="%d"
        )
        imgui.text("Changed: %s, Values: %s" % (changed, values))
        imgui.end()

    Args:
        label (str): widget label.
        value0, value1, value2 (int): slider values.
        min_value (int): min value allowed by widget.
        max_value (int): max value allowed by widget.
        format (str): display format string as C-style ``printf``
            format string. **Warning:** highly unsafe.
            See :any:`slider_int()`.
        flags: SliderFlags flags. See:
            :ref:`list of available flags <slider-flag-options>`.

    Returns:
        tuple: a ``(changed, values)`` tuple that contains indicator of
        widget state change and the tuple of current slider values.

    .. wraps::
        bool SliderInt3(
            const char* label,
            int v[3],
            int v_min,
            int v_max,
            const char* format = "%.3f",
            ImGuiSliderFlags flags = 0
        )
    """
    cdef int[3] inout_values = [value0, value1, value2]
    return cimgui.SliderInt3(
        _bytes(label), <int*>&inout_values,
        min_value, max_value, _bytes(format), flags
    ), (inout_values[0], inout_values[1], inout_values[2])


def slider_int4(
    str label,
    int value0, int value1, int value2, int value3,
    int min_value,
    int max_value,
    str format = "%.f",
    cimgui.ImGuiSliderFlags flags = 0
):
    """Display int slider widget with 4 values.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 130

        values = 88, 42, 69, 0

        imgui.begin("Example: slider int4")
        changed, values = imgui.slider_int4(
            "slide ints", *values,
            min_value=0, max_value=100, format="%d"
        )
        imgui.text("Changed: %s, Values: %s" % (changed, values))
        imgui.end()

    Args:
        label (str): widget label.
        value0, value1, value2, value3 (int): slider values.
        min_value (int): min value allowed by widget.
        max_value (int): max value allowed by widget.
        format (str): display format string as C-style ``printf``
            format string. **Warning:** highly unsafe.
            See :any:`slider_int()`.
        flags: SliderFlags flags. See:
            :ref:`list of available flags <slider-flag-options>`.

    Returns:
        tuple: a ``(changed, values)`` tuple that contains indicator of
        widget state change and the tuple of current slider values.

    .. wraps::
        bool SliderInt4(
            const char* label,
            int v[4],
            int v_min,
            int v_max,
            const char* format = "%.3f",
            ImGuiSliderFlags flags = 0
        )
    """
    cdef int[4] inout_values = [value0, value1, value2, value3]
    return cimgui.SliderInt4(
        _bytes(label), <int*>&inout_values,
        min_value, max_value, _bytes(format), flags
    ), (inout_values[0], inout_values[1], inout_values[2], inout_values[3])

def slider_scalar(
    str label,
    cimgui.ImGuiDataType data_type,
    bytes data,
    bytes min_value,
    bytes max_value,
    str format = None,
    cimgui.ImGuiSliderFlags flags = 0):
    """Display scalar slider widget.
    Data is passed via ``bytes`` and the type is separatelly given using ``data_type``.
    This is useful to work with specific types (e.g. unsigned 8bit integer, float, double)
    like when interfacing with Numpy.

    Args:
        label (str): widget label
        data_type: ImGuiDataType enum, type of the given data
        data (bytes): data value as a bytes array
        min_value (bytes): min value allowed by widget
        max_value (bytes): max value allowed by widget
        format (str): display format string as C-style ``printf``
            format string. **Warning:** highly unsafe. See :any:`drag_int()`.
        flags: ImGuiSlider flags. See:
            :ref:`list of available flags <slider-flag-options>`.

    Returns:
        tuple: a ``(changed, value)`` tuple that contains indicator of
        slider state change and the current slider content.

    .. wraps::
        bool SliderScalar(
            const char* label,
            ImGuiDataType data_type,
            void* p_data,
            const void* p_min,
            const void* p_max,
            const char* format = NULL,
            ImGuiSliderFlags flags = 0
        )
    """

    cdef char* p_data = data
    cdef char* p_min = min_value
    cdef char* p_max = max_value

    cdef char* fmt = NULL
    cdef bytes fmt_data;
    if format is not None:
        fmt_data = _bytes(format)
        fmt = fmt_data

    cdef changed = cimgui.SliderScalar(
        _bytes(label),
        data_type,
        p_data,
        p_min,
        p_max,
        fmt,
        flags
    )

    return changed, data

def slider_scalar_N(
    str label,
    cimgui.ImGuiDataType data_type,
    bytes data,
    int components,
    bytes min_value,
    bytes max_value,
    str format = None,
    cimgui.ImGuiSliderFlags flags = 0):
    """Display multiple scalar slider widget.
    Data is passed via ``bytes`` and the type is separatelly given using ``data_type``.
    This is useful to work with specific types (e.g. unsigned 8bit integer, float, double)
    like when interfacing with Numpy.

    Args:
        label (str): widget label
        data_type: ImGuiDataType enum, type of the given data
        data (bytes): data value as a bytes array
        components (int): number of widgets
        min_value (bytes): min value allowed by widget
        max_value (bytes): max value allowed by widget
        format (str): display format string as C-style ``printf``
            format string. **Warning:** highly unsafe. See :any:`drag_int()`.
        flags: ImGuiSlider flags. See:
            :ref:`list of available flags <slider-flag-options>`.

    Returns:
        tuple: a ``(changed, value)`` tuple that contains indicator of
        slider state change and the current slider content.

    .. wraps::
        bool SliderScalarN(
            const char* label,
            ImGuiDataType data_type,
            void* p_data,
            int components,
            const void* p_min,
            const void* p_max,
            const char* format = NULL,
            ImGuiSliderFlags flags = 0
        )
    """

    cdef char* p_data = data
    cdef char* p_min = min_value
    cdef char* p_max = max_value

    cdef char* fmt = NULL
    cdef bytes fmt_data;
    if format is not None:
        fmt_data = _bytes(format)
        fmt = fmt_data

    cdef changed = cimgui.SliderScalarN(
        _bytes(label),
        data_type,
        p_data,
        components,
        p_min,
        p_max,
        fmt,
        flags
    )

    return changed, data

def v_slider_float(
    str label,
    float width,
    float height,
    float value,
    float min_value,
    float max_value,
    str format = "%.f",
    cimgui.ImGuiSliderFlags flags = 0
):
    """Display vertical float slider widget with the specified width and
    height.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 130

        width = 20
        height = 100
        value = 88

        imgui.begin("Example: vertical slider float")
        changed, values = imgui.v_slider_float(
            "vertical slider float",
            width, height, value,
            min_value=0, max_value=100,
            format="%0.3f", flags=imgui.SLIDER_FLAGS_NONE
        )
        imgui.text("Changed: %s, Values: %s" % (changed, values))
        imgui.end()

    Args:
        label (str): widget label.
        value (float): slider value.
        min_value (float): min value allowed by widget.
        max_value (float): max value allowed by widget.
        format (str): display format string as C-style ``printf``
            format string. **Warning:** highly unsafe.
            See :any:`slider_float()`.
        flags: SliderFlags flags. See:
            :ref:`list of available flags <slider-flag-options>`.

    Returns:
        tuple: a ``(changed, value)`` tuple that contains indicator of
        widget state change and the slider value.

    .. wraps::
        bool VSliderFloat(
            const char* label,
            const ImVec2& size,
            float v,
            float v_min,
            floatint v_max,
            const char* format = "%.3f",
            ImGuiSliderFlags flags = 0
        )
    """
    cdef float inout_value = value
    return cimgui.VSliderFloat(
        _bytes(label), _cast_args_ImVec2(width, height),
        <float*>&inout_value,
        min_value, max_value, _bytes(format), flags
    ), inout_value


def v_slider_int(
    str label,
    float width,
    float height,
    int value,
    int min_value,
    int max_value,
    str format = "%d",
    cimgui.ImGuiSliderFlags flags = 0
):
    """Display vertical int slider widget with the specified width and height.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 130

        width = 20
        height = 100
        value = 88

        imgui.begin("Example: vertical slider int")
        changed, values = imgui.v_slider_int(
            "vertical slider int",
            width, height, value,
            min_value=0, max_value=100,
            format="%d"
        )
        imgui.text("Changed: %s, Values: %s" % (changed, values))
        imgui.end()

    Args:
        label (str): widget label.
        value (int): slider value.
        min_value (int): min value allowed by widget.
        max_value (int): max value allowed by widget.
        format (str): display format string as C-style ``printf``
            format string. **Warning:** highly unsafe.
            See :any:`slider_int()`.
        flags: SliderFlags flags. See:
            :ref:`list of available flags <slider-flag-options>`.

    Returns:
        tuple: a ``(changed, value)`` tuple that contains indicator of
        widget state change and the slider value.

    .. wraps::
        bool VSliderInt(
            const char* label,
            const ImVec2& size,
            int v,
            int v_min,
            int v_max,
            const char* format = "%.3f",
            ImGuiSliderFlags flags = 0
        )
    """
    cdef int inout_value = value
    return cimgui.VSliderInt(
        _bytes(label), _cast_args_ImVec2(width, height),
        <int*>&inout_value,
        min_value, max_value, _bytes(format), flags
    ), inout_value


def v_slider_scalar(
    str label,
    float width,
    float height,
    cimgui.ImGuiDataType data_type,
    bytes data,
    bytes min_value,
    bytes max_value,
    str format = None,
    cimgui.ImGuiSliderFlags flags = 0):
    """Display vertical scalar slider widget.
    Data is passed via ``bytes`` and the type is separatelly given using ``data_type``.
    This is useful to work with specific types (e.g. unsigned 8bit integer, float, double)
    like when interfacing with Numpy.

    Args:
        label (str): widget label
        width (float): width of the slider
        height (float): height of the slider
        data_type: ImGuiDataType enum, type of the given data
        data (bytes): data value as a bytes array
        min_value (bytes): min value allowed by widget
        max_value (bytes): max value allowed by widget
        format (str): display format string as C-style ``printf``
            format string. **Warning:** highly unsafe. See :any:`drag_int()`.
        flags: ImGuiSlider flags. See:
            :ref:`list of available flags <slider-flag-options>`.

    Returns:
        tuple: a ``(changed, value)`` tuple that contains indicator of
        slider state change and the current slider content.

    .. wraps::
        bool VSliderScalar(
            const char* label,
            const ImVec2& size,
            ImGuiDataType data_type,
            void* p_data,
            const void* p_min,
            const void* p_max,
            const char* format = NULL,
            ImGuiSliderFlags flags = 0
        )
    """

    cdef char* p_data = data
    cdef char* p_min = min_value
    cdef char* p_max = max_value

    cdef char* fmt = NULL
    cdef bytes fmt_data;
    if format is not None:
        fmt_data = _bytes(format)
        fmt = fmt_data

    cdef changed = cimgui.VSliderScalar(
        _bytes(label),
        _cast_args_ImVec2(width, height),
        data_type,
        p_data,
        p_min,
        p_max,
        fmt,
        flags
    )

    return changed, data

def plot_lines(
        str label not None,
        const float[:] values not None,
        int values_count  = -1,
        int values_offset = 0,
        str overlay_text = None,
        float scale_min = FLOAT_MAX,
        float scale_max = FLOAT_MAX,
        graph_size = (0, 0),
        int stride = sizeof(float),
    ):

    """
    Plot a 1D array of float values.

    Args:
        label (str): A plot label that will be displayed on the plot's right
            side. If you want the label to be invisible, add :code:`"##"`
            before the label's text: :code:`"my_label" -> "##my_label"`

        values (array of floats): the y-values.
            It must be a type that supports Cython's Memoryviews,
            (See: http://docs.cython.org/en/latest/src/userguide/memoryviews.html)
            for example a numpy array.

        overlay_text (str or None, optional): Overlay text.

        scale_min (float, optional): y-value at the bottom of the plot.
        scale_max (float, optional): y-value at the top of the plot.

        graph_size (tuple of two floats, optional): plot size in pixels.
            **Note:** In ImGui 1.49, (-1,-1) will NOT auto-size the plot.
            To do that, use :func:`get_content_region_available` and pass
            in the right size.

    **Note:** These low-level parameters are exposed if needed for
    performance:

    * **values_offset** (*int*): Index of first element to display
    * **values_count** (*int*): Number of values to display. -1 will use the
        entire array.
    * **stride** (*int*): Number of bytes to move to read next element.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 130

        from array import array
        from math import sin
        # NOTE: this example will not work under py27 due do incompatible
        # implementation of array and memoryview().
        plot_values = array('f', [sin(x * 0.1) for x in range(100)])

        imgui.begin("Plot example")
        imgui.plot_lines("Sin(t)", plot_values)
        imgui.end()

    .. wraps::
            void PlotLines(
                const char* label, const float* values, int values_count,

                int values_offset = 0,
                const char* overlay_text = NULL,
                float scale_min = FLT_MAX,
                float scale_max = FLT_MAX,
                ImVec2 graph_size = ImVec2(0,0),
                int stride = sizeof(float)
            )
    """
    if values_count == -1:
        values_count = <int>values.shape[0]

    # Would be nicer as something like
    #   _bytes(overlay_text) if overlay_text is not None else NULL
    # but then Cython complains about either types or pointers to temporary references.
    cdef const char* overlay_text_ptr = NULL
    cdef bytes overlay_text_b
    if overlay_text is not None:
        overlay_text_b = _bytes(overlay_text) # must be assigned to a variable
        overlay_text_ptr = overlay_text_b # auto-convert bytes to char*

    cimgui.PlotLines(
        _bytes(label), &values[0], values_count,
        values_offset,
        overlay_text_ptr,
        scale_min, scale_max,
        _cast_tuple_ImVec2(graph_size),
        stride
    )


def plot_histogram(
        str label not None,
        const float[:] values not None,
        int values_count  = -1,
        int values_offset = 0,
        str overlay_text = None,
        float scale_min = FLT_MAX,
        float scale_max = FLT_MAX,
        graph_size = (0, 0),
        int stride = sizeof(float),
    ):
    """
    Plot a histogram of float values.

    Args:
        label (str): A plot label that will be displayed on the plot's right
            side. If you want the label to be invisible, add :code:`"##"`
            before the label's text: :code:`"my_label" -> "##my_label"`

        values (array of floats): the y-values.
            It must be a type that supports Cython's Memoryviews,
            (See: http://docs.cython.org/en/latest/src/userguide/memoryviews.html)
            for example a numpy array.

        overlay_text (str or None, optional): Overlay text.

        scale_min (float, optional): y-value at the bottom of the plot.
        scale_max (float, optional): y-value at the top of the plot.

        graph_size (tuple of two floats, optional): plot size in pixels.
            **Note:** In ImGui 1.49, (-1,-1) will NOT auto-size the plot.
            To do that, use :func:`get_content_region_available` and pass
            in the right size.

    **Note:** These low-level parameters are exposed if needed for
    performance:

    * **values_offset** (*int*): Index of first element to display
    * **values_count** (*int*): Number of values to display. -1 will use the
        entire array.
    * **stride** (*int*): Number of bytes to move to read next element.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 130

        from array import array
        from random import random

        # NOTE: this example will not work under py27 due do incompatible
        # implementation of array and memoryview().
        histogram_values = array('f', [random() for _ in range(20)])

        imgui.begin("Plot example")
        imgui.plot_histogram("histogram(random())", histogram_values)
        imgui.end()

    .. wraps::
            void PlotHistogram(
                const char* label, const float* values, int values_count,
                # note: optional
                int values_offset,
                const char* overlay_text,
                float scale_min,
                float scale_max,
                ImVec2 graph_size,
                int stride
            )
    """
    if values_count == -1:
        values_count = <int>values.shape[0]

    # Would be nicer as something like
    #   _bytes(overlay_text) if overlay_text is not None else NULL
    # but then Cython complains about either types or pointers to temporary references.
    cdef const char* overlay_text_ptr = NULL
    cdef bytes overlay_text_b

    if overlay_text is not None:
        overlay_text_b = _bytes(overlay_text) # must be assigned to a variable
        overlay_text_ptr = overlay_text_b # auto-convert bytes to char*

    cimgui.PlotHistogram(
        _bytes(label), &values[0], values_count,
        values_offset,
        overlay_text_ptr,
        scale_min, scale_max,
        _cast_tuple_ImVec2(graph_size),
        stride
    )

def progress_bar(float fraction, size = (-FLOAT_MIN,0), str overlay = ""):
    """ Show a progress bar

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 200

        imgui.begin("Progress bar example")
        imgui.progress_bar(0.7, (100,20), "Overlay text")
        imgui.end()

    Args:
        fraction (float): A floating point number between 0.0 and 1.0
            0.0 means no progress and 1.0 means progress is completed
        size : a tuple (width, height) that sets the width and height
            of the progress bar
        overlay (str): Optional text that will be shown in the progress bar

    .. wraps::
        void ProgressBar(
            float fraction,
            const ImVec2& size_arg = ImVec2(-FLT_MIN, 0),
            const char* overlay = NULL
        )

    """
    cimgui.ProgressBar(fraction, _cast_tuple_ImVec2(size), _bytes(overlay))

def set_item_default_focus():
    """Make last item the default focused item of a window.
    Please use instead of "if (is_window_appearing()) set_scroll_here()" to signify "default item".

    .. wraps::
        void SetItemDefaultFocus()
    """
    cimgui.SetItemDefaultFocus()


def set_keyboard_focus_here(int offset = 0):
    """Focus keyboard on the next widget.
    Use positive 'offset' to access sub components of a multiple component widget. Use -1 to access previous widget.

    .. wraps::
        void SetKeyboardFocusHere(int offset = 0)
    """
    return cimgui.SetKeyboardFocusHere(offset)


def is_item_hovered(
        cimgui.ImGuiHoveredFlags flags=0
    ):
    """Check if the last item is hovered by mouse.

    Returns:
        bool: True if item is hovered by mouse, otherwise False.

    .. wraps::
        bool IsItemHovered(ImGuiHoveredFlags flags = 0)
    """
    return cimgui.IsItemHovered(flags)


def is_item_focused():
    """Check if the last item is focused

    Returns:
        bool: True if item is focused, otherwise False.

    .. wraps::
        bool IsItemFocused()
    """
    return cimgui.IsItemFocused()


def is_item_active():
    """Was the last item active? For ex. button being held or text field
    being edited. Items that don't interact will always return false.

    Returns:
        bool: True if item is active, otherwise False.

    .. wraps::
        bool IsItemActive()
    """
    return cimgui.IsItemActive()


def is_item_clicked(cimgui.ImGuiMouseButton mouse_button = 0):
    """ Was the last item hovered and mouse clicked on?
    Button or node that was just being clicked on.

    Args:
        mouse_button: ImGuiMouseButton

    Returns:
        bool: True if item is clicked, otherwise False.

    .. wraps::
        bool IsItemClicked(int mouse_button = 0)
    """
    return cimgui.IsItemClicked(mouse_button)


def is_item_visible():
    """Was the last item visible? Aka not out of sight due to
    clipping/scrolling.

    Returns:
        bool: True if item is visible, otherwise False.

    .. wraps::
        bool IsItemVisible()
    """
    return cimgui.IsItemVisible()

def is_item_edited():
    """Did the last item modify its underlying value this frame? or was pressed?
    This is generally the same as the "bool" return value of many widgets.

    Returns:
        bool: True if item is edited, otherwise False.

    .. wraps::
        bool IsItemEdited()
    """
    return cimgui.IsItemEdited()

def is_item_activated():
    """Was the last item just made active (item was previously inactive)?

    Returns:
        bool: True if item was just made active

    .. wraps::
        bool IsItemActivated()
    """
    return cimgui.IsItemActivated()

def is_item_deactivated():
    """Was the last item just made inactive (item was previously active)?
    Useful for Undo/Redo patterns with widgets that requires continuous editing.

    Results:
        bool: True if item just made inactive

    .. wraps:
        bool IsItemDeactivated()
    """
    return cimgui.IsItemDeactivated()

def is_item_deactivated_after_edit():
    """Was the last item just made inactive and made a value change when it was active? (e.g. Slider/Drag moved).
    Useful for Undo/Redo patterns with widgets that requires continuous editing.
    Note that you may get false positives (some widgets such as Combo()/ListBox()/Selectable() will return true even when clicking an already selected item).

    Results:
        bool: True if item just made inactive after an edition

    .. wraps::
        bool IsItemDeactivatedAfterEdit()
    """
    return cimgui.IsItemDeactivatedAfterEdit()

def is_item_toggled_open():
    """Was the last item open state toggled? set by TreeNode().

    .. wraps::
        bool IsItemToggledOpen()
    """
    return cimgui.IsItemToggledOpen()

def is_any_item_hovered():
    """Was any of the items hovered.

    Returns:
        bool: True if any item is hovered, otherwise False.

    .. wraps::
        bool IsAnyItemHovered()
    """
    return cimgui.IsAnyItemHovered()


def is_any_item_active():
    """Was any of the items active.

    Returns:
        bool: True if any item is active, otherwise False.

    .. wraps::
        bool IsAnyItemActive()
    """
    return cimgui.IsAnyItemActive()


def is_any_item_focused():
    """Is any of the items focused.

    Returns:
        bool: True if any item is focused, otherwise False.

    .. wraps::
        bool IsAnyItemFocused()
    """
    return cimgui.IsAnyItemFocused()


def get_item_rect_min():
    """Get bounding rect of the last item in screen space.

    Returns:
        Vec2: item minimum boundaries two-tuple ``(width, height)``

    .. wraps::
        ImVec2 GetItemRectMin()
    """
    return _cast_ImVec2_tuple(cimgui.GetItemRectMin())


def get_item_rect_max():
    """Get bounding rect of the last item in screen space.

    Returns:
        Vec2: item maximum boundaries two-tuple ``(width, height)``

    .. wraps::
        ImVec2 GetItemRectMax()
    """
    return _cast_ImVec2_tuple(cimgui.GetItemRectMax())


def get_item_rect_size():
    """Get bounding rect of the last item in screen space.

    Returns:
        Vec2: item boundaries two-tuple ``(width, height)``

    .. wraps::
        ImVec2 GetItemRectSize()
    """
    return _cast_ImVec2_tuple(cimgui.GetItemRectSize())


def set_item_allow_overlap():
    """Allow last item to be overlapped by a subsequent item.
    Sometimes useful with invisible buttons, selectables, etc.
    to catch unused area.

    .. wraps::
        void SetItemAllowOverlap()
    """
    cimgui.SetItemAllowOverlap()

def get_main_viewport():
    """Currently represents the Platform Window created by the application which is hosting
    our Dear ImGui windows.

    In the future we will extend this concept further to also represent Platform Monitor
    and support a "no main platform window" operation mode.

    Returns:
        _ImGuiViewport: Viewport

    .. wraps::
        ImGuiViewport* GetMainViewport()
    """
    return _ImGuiViewport.from_ptr(cimgui.GetMainViewport())

def is_window_hovered(
        cimgui.ImGuiHoveredFlags flags=0
    ):
    """Is current window hovered and hoverable (not blocked by a popup).
    Differentiate child windows from each others.

    Returns:
        bool: True if current window is hovered, otherwise False.

    .. wraps::
        bool IsWindowHovered(ImGuiFocusedFlags flags = 0)
    """
    return cimgui.IsWindowHovered(flags)


def is_window_focused(
        cimgui.ImGuiHoveredFlags flags=0
    ):
    """Is current window focused.

    Returns:
        bool: True if current window is on focus, otherwise False.

    .. wraps::
        bool IsWindowFocused(ImGuiFocusedFlags flags = 0)
    """
    return cimgui.IsWindowFocused(flags)


def is_rect_visible(float size_width, float size_height):
    """Test if a rectangle of the given size, starting from the cursor
    position is visible (not clipped).

    Args:
        size_width (float): width of the rect
        size_height (float): height of the rect

    Returns:
        bool: True if rect is visible, otherwise False.

    .. wraps::
        bool IsRectVisible(const ImVec2& size)
    """
    return cimgui.IsRectVisible(_cast_args_ImVec2(size_width, size_height))


def get_style_color_name(int index):
    """Get the style color name for a given ImGuiCol index.

    .. wraps::
        const char* GetStyleColorName(ImGuiCol idx)
    """
    cdef const char* c_string = cimgui.GetStyleColorName(index)
    cdef bytes py_string = c_string
    return c_string.decode("utf-8")


def get_time():
    """Seconds since program start.

    Returns:
        float: the time (seconds since program start)

    .. wraps::
        float GetTime()
    """
    return cimgui.GetTime()


def get_background_draw_list():
    """This draw list will be the first rendering one.
    Useful to quickly draw shapes/text behind dear imgui contents.

    Returns:
        DrawList*

    .. wraps::
        ImDrawList* GetBackgroundDrawList()
    """
    return _DrawList.from_ptr(cimgui.GetBackgroundDrawList())

def get_foreground_draw_list():
    """This draw list will be the last rendered one.
    Useful to quickly draw shapes/text over dear imgui contents.

    Returns:
        DrawList*

    .. wraps::
        ImDrawList* GetForegroundDrawList()
    """
    return _DrawList.from_ptr(cimgui.GetForegroundDrawList())


def get_key_index(int key):
    """Map ImGuiKey_* values into user's key index. == io.KeyMap[key]

    Returns:
       int: io.KeyMap[key]

    .. wraps::
        int GetKeyIndex(ImGuiKey imgui_key)
    """
    return cimgui.GetKeyIndex(key)


def is_key_pressed(int key_index, bool repeat = False):
    """Was key pressed (went from !Down to Down).
       If repeat=true, uses io.KeyRepeatDelay / KeyRepeatRate

    Returns:
        bool: True if specified key was pressed this frame

    .. wraps::
        bool IsKeyPressed(int user_key_index)
    """
    return cimgui.IsKeyPressed(key_index, repeat)


def is_key_down(int key_index):
    """Returns if key is being held -- io.KeysDown[user_key_index].
       Note that imgui doesn't know the semantic of each entry of
       io.KeysDown[]. Use your own indices/enums according to how
       your backend/engine stored them into io.KeysDown[]!

    Returns:
        bool: True if specified key is being held.

    .. wraps::
        bool IsKeyDown(int user_key_index)
    """
    return cimgui.IsKeyDown(key_index)


def is_mouse_hovering_rect(
    float r_min_x, float r_min_y,
    float r_max_x, float r_max_y,
    bool clip=True
):
    """Test if mouse is hovering rectangle with given coordinates.

    Args:
        r_min_x, r_min_y (float): x,y coordinate of the upper-left corner
        r_max_x, r_max_y (float): x,y coordinate of the lower-right corner

    Returns:
        bool: True if mouse is hovering the rectangle.

    .. wraps::
        bool IsMouseHoveringRect(
            const ImVec2& r_min,
            const ImVec2& r_max,
            bool clip = true
        )
    """
    return cimgui.IsMouseHoveringRect(
        _cast_args_ImVec2(r_min_x, r_min_y),
        _cast_args_ImVec2(r_max_x, r_max_y),
        clip
    )


def is_mouse_double_clicked(int button = 0):
    """Return True if mouse was double-clicked.

    **Note:** A double-click returns false in IsMouseClicked().

    Args:
        button (int): mouse button index.

    Returns:
        bool: if mouse is double clicked.

    .. wraps::
         bool IsMouseDoubleClicked(int button);
    """
    return cimgui.IsMouseDoubleClicked(button)


def is_mouse_clicked(int button = 0, bool repeat = False):
    """Returns if the mouse was clicked this frame.

    Args:
        button (int): mouse button index.
        repeat (float):

    Returns:
        bool: if the mouse was clicked this frame.

    .. wraps::
        bool IsMouseClicked(int button, bool repeat = false)
    """
    return cimgui.IsMouseClicked(button, repeat)


def is_mouse_released(int button = 0):
    """Returns if the mouse was released this frame.

    Args:
        button (int): mouse button index.

    Returns:
        bool: if the mouse was released this frame.

    .. wraps::
        bool IsMouseReleased(int button)
    """
    return cimgui.IsMouseReleased(button)


def is_mouse_down(int button = 0):
    """Returns if the mouse is down.

    Args:
        button (int): mouse button index.

    Returns:
        bool: if the mouse is down.

    .. wraps::
        bool IsMouseDown(int button)
    """
    return cimgui.IsMouseDown(button)


def is_mouse_dragging(int button, float lock_threshold = -1.0):
    """Returns if mouse is dragging.

    Args:
        button (int): mouse button index.
        lock_threshold (float): if less than -1.0
            uses io.MouseDraggingThreshold.

    Returns:
        bool: if mouse is dragging.

    .. wraps::
        bool IsMouseDragging(int button = 0, float lock_threshold = -1.0f)
    """
    return cimgui.IsMouseDragging(button, lock_threshold)


def get_mouse_drag_delta(int button=0, float lock_threshold = -1.0):
    """Dragging amount since clicking.

    Args:
        button (int): mouse button index.
        lock_threshold (float): if less than -1.0
            uses io.MouseDraggingThreshold.

    Returns:
        Vec2: mouse position two-tuple ``(x, y)``

    .. wraps::
        ImVec2 GetMouseDragDelta(int button = 0, float lock_threshold = -1.0f)
    """
    return _cast_ImVec2_tuple(
        cimgui.GetMouseDragDelta(button, lock_threshold)
    )


def get_mouse_pos():
    """Current mouse position.

    Returns:
        Vec2: mouse position two-tuple ``(x, y)``

    .. wraps::
        ImVec2 GetMousePos()
    """
    return _cast_ImVec2_tuple(
        cimgui.GetMousePos()
    )

get_mouse_position = get_mouse_pos


def reset_mouse_drag_delta(int button = 0):
    """Reset the mouse dragging delta.

    Args:
        button (int): mouse button index.

    .. wraps::
        void ResetMouseDragDelta(int button = 0)
    """
    cimgui.ResetMouseDragDelta(button)


def get_mouse_cursor():
    """Return the mouse cursor id.

    .. wraps::
        ImGuiMouseCursor GetMouseCursor()
    """
    return cimgui.GetMouseCursor()


def set_mouse_cursor(cimgui.ImGuiMouseCursor mouse_cursor_type):
    """Set the mouse cursor id.

    Args:
        mouse_cursor_type (ImGuiMouseCursor): mouse cursor type.

    .. wraps::
        void SetMouseCursor(ImGuiMouseCursor type)
    """
    return cimgui.SetMouseCursor(mouse_cursor_type)

def capture_mouse_from_app(bool want_capture_mouse_value = True):
    """Attention: misleading name!
    Manually override io.WantCaptureMouse flag next frame
    (said flag is entirely left for your application to handle).

    This is equivalent to setting "io.WantCaptureMouse = want_capture_mouse_value;"
    after the next NewFrame() call.

    .. wraps::
        void CaptureMouseFromApp(bool want_capture_mouse_value = true)
    """
    cimgui.CaptureMouseFromApp(want_capture_mouse_value)

def get_clipboard_text():
    """Also see the ``log_to_clipboard()`` function to capture GUI into clipboard,
    or easily output text data to the clipboard.

    Returns:
        str: Text content of the clipboard

    .. wraps::
        const char* GetClipboardText()
    """
    return _from_bytes(cimgui.GetClipboardText())

def load_ini_settings_from_disk(str ini_file_name):
    """Call after ``create_context()`` and before the first call to ``new_frame()``.
    ``new_frame()`` automatically calls ``load_ini_settings_from_disk(io.ini_file_name)``.

    Args:
        ini_file_name (str): Filename to load settings from.

    .. wraps::
        void LoadIniSettingsFromDisk(const char* ini_filename)
    """
    cimgui.LoadIniSettingsFromDisk(_bytes(ini_file_name))

def load_ini_settings_from_memory(str ini_data):
    """Call after ``create_context()`` and before the first call to ``new_frame()``
    to provide .ini data from your own data source.

    .. wraps::
        void LoadIniSettingsFromMemory(const char* ini_data, size_t ini_size=0)
    """
    #cdef size_t ini_size = len(ini_data)
    cimgui.LoadIniSettingsFromMemory(_bytes(ini_data), 0)

def save_ini_settings_to_disk(str ini_file_name):
    """This is automatically called (if ``io.ini_file_name`` is not empty)
    a few seconds after any modification that should be reflected in the .ini file
    (and also by ``destroy_context``).

    Args:
        ini_file_name (str): Filename to save settings to.

    .. wraps::
        void SaveIniSettingsToDisk(const char* ini_filename)
    """
    cimgui.SaveIniSettingsToDisk(_bytes(ini_file_name))

def save_ini_settings_to_memory():
    """Return a string with the .ini data which you can save by your own mean.
    Call when ``io.want_save_ini_settings`` is set, then save data by your own mean
    and clear ``io.want_save_ini_settings``.

    Returns:
        str: Settings data

    .. wraps::
       const char* SaveIniSettingsToMemory(size_t* out_ini_size = NULL)
    """
    return _from_bytes(cimgui.SaveIniSettingsToMemory(NULL))

def set_clipboard_text(str text):
    """Set the clipboard content

    Args:
        text (str): Text to copy in clipboard

    .. wraps:
        void SetClipboardText(const char* text)
    """
    cimgui.SetClipboardText(_bytes(text))

# REMOVED in 1.82 (from Mars 2021) use 'set_scroll_here_y()'
# OBSOLETED in 1.66 (from Sep 2018)
#def set_scroll_here(float center_y_ratio = 0.5):
#    """Set scroll here.
#
#    adjust scrolling amount to make current cursor position visible. center_y_ratio=0.0: top, 0.5: center, 1.0: bottom. When using to make a "default/current item" visible, consider using SetItemDefaultFocus() instead.
#
#    Args:
#        float center_y_ratio = 0.5f
#
#    .. wraps::
#        void SetScrollHere(float center_y_ratio = 0.5f)
#    """
#    return cimgui.SetScrollHere(center_y_ratio)

def set_scroll_here_x(float center_x_ratio = 0.5):
    """Set scroll here X.

    Adjust scrolling amount to make current cursor position visible.
    center_x_ratio =
    0.0: left,
    0.5: center,
    1.0: right.

    When using to make a "default/current item" visible, consider using SetItemDefaultFocus() instead.

    Args:
        float center_x_ratio = 0.5f

    .. wraps::
        void SetScrollHereX(float center_x_ratio = 0.5f)
    """
    return cimgui.SetScrollHereX(center_x_ratio)

def set_scroll_here_y(float center_y_ratio = 0.5):
    """Set scroll here Y.

    Adjust scrolling amount to make current cursor position visible.
    center_y_ratio =
    0.0: top,
    0.5: center,
    1.0: bottom.

    When using to make a "default/current item" visible, consider using SetItemDefaultFocus() instead.

    Args:
        float center_y_ratio = 0.5f

    .. wraps::
        void SetScrollHereY(float center_y_ratio = 0.5f)
    """
    return cimgui.SetScrollHereY(center_y_ratio)


def set_scroll_from_pos_x(float local_x, float center_x_ratio = 0.5):
    """Set scroll from position X

    Adjust scrolling amount to make given position visible.
    Generally GetCursorStartPos() + offset to compute a valid position.

    Args:
        float local_x
        float center_x_ratio = 0.5f

    .. wraps::
        void SetScrollFromPosX(float local_x, float center_x_ratio = 0.5f)
    """
    return cimgui.SetScrollFromPosX(local_x, center_x_ratio)


def set_scroll_from_pos_y(float local_y, float center_y_ratio = 0.5):
    """Set scroll from position Y

    Adjust scrolling amount to make given position visible.
    Generally GetCursorStartPos() + offset to compute a valid position.

    Args:
        float local_y
        float center_y_ratio = 0.5f

    .. wraps::
        void SetScrollFromPosY(float local_y, float center_y_ratio = 0.5f)
    """
    return cimgui.SetScrollFromPosY(local_y, center_y_ratio)


def push_font(_Font font):
    """Push font on a stack.

    .. visual-example::
        :auto_layout:
        :height: 100
        :width: 320

        io = imgui.get_io()

        new_font = io.fonts.add_font_from_file_ttf(
            "DroidSans.ttf", 20,
        )
        impl.refresh_font_texture()

        # later in frame code

        imgui.begin("Default Window")

        imgui.text("Text displayed using default font")

        imgui.push_font(new_font)
        imgui.text("Text displayed using custom font")
        imgui.pop_font()

        imgui.end()

    **Note:** Pushed fonts should be poped with :func:`pop_font()` within the
    same frame. In order to avoid manual push/pop functions you can use the
    :func:`font()` context manager.

    Args:
        font (_Font): font object retrieved from :any:`add_font_from_file_ttf`.

    .. wraps::
        void PushFont(ImFont*)
    """
    cimgui.PushFont(font._ptr)

def pop_font():
    """Pop font on a stack.

    For example usage see :func:`push_font()`.

    Args:
        font (_Font): font object retrieved from :any:`add_font_from_file_ttf`.

    .. wraps::
        void PopFont()
    """
    cimgui.PopFont()

cpdef calc_text_size(str text, bool hide_text_after_double_hash = False, float wrap_width = -1.0):
    """Calculate text size.
    Text can be multi-line.
    Optionally ignore text after a ## marker.

    .. visual-example::
        :auto_layout:
        :width: 300
        :height: 100

        imgui.begin("Text size calculation")
        text_content = "This is a ##text##!"
        text_size1 = imgui.calc_text_size(text_content)
        imgui.text('"%s" has size %ix%i' % (text_content, text_size1[0], text_size1[1]))
        text_size2 = imgui.calc_text_size(text_content, True)
        imgui.text('"%s" has size %ix%i' % (text_content, text_size2[0], text_size2[1]))
        text_size3 = imgui.calc_text_size(text_content, False, 30.0)
        imgui.text('"%s" has size %ix%i' % (text_content, text_size3[0], text_size3[1]))
        imgui.end()

    Args:
        text (str): text
        hide_text_after_double_hash (bool): if True, text after '##' is ignored
        wrap_width (float): if > 0.0 calculate size using text wrapping

    .. wraps::
        CalcTextSize(const char* text, const char* text_end, bool hide_text_after_double_hash, float wrap_width)
    """
    return _cast_ImVec2_tuple(
        cimgui.CalcTextSize(
            _bytes(text),
            NULL,
            hide_text_after_double_hash,
            wrap_width
        )
    )

def color_convert_u32_to_float4(cimgui.ImU32 in_):
    """Convert an unsigned int 32 to 4 component r, g, b, a

    Args:
        in_ (ImU32): Color in unsigned int 32 format

    Return:
        tuple: r, g, b, a components of the color

    .. wraps::
        ImVec4 ColorConvertU32ToFloat4(ImU32 in)
    """
    return _cast_ImVec4_tuple(cimgui.ColorConvertU32ToFloat4(in_))

def color_convert_float4_to_u32(float r, float g, float b, float a):
    """Convert a set of r, g, b, a floats to unsigned int 32 color

    Args:
        r, g, b, a (float): Components of the color

    Returns:
        ImU32: Unsigned int 32 color format

    .. wraps::
        ImU32 ColorConvertFloat4ToU32(const ImVec4& in)
    """
    cdef cimgui.ImVec4 color = _cast_args_ImVec4(r,g,b,a)
    return cimgui.ColorConvertFloat4ToU32(color)

def color_convert_rgb_to_hsv(float r, float g, float b):
    """Convert color from RGB space to HSV space

    Args:
        r, g, b (float): RGB color format

    Returns:
        tuple: h, s, v HSV color format

    .. wraps::
        void ColorConvertRGBtoHSV(float r, float g, float b, float& out_h, float& out_s, float& out_v)
    """
    cdef float out_h, out_s, out_v
    out_h = out_s = out_v = 0
    cimgui.ColorConvertRGBtoHSV(r,g,b,out_h,out_s,out_v)
    return out_h, out_s, out_v

def color_convert_hsv_to_rgb(float h, float s, float v):
    """Convert color from HSV space to RGB space

    Args:
        h, s, v (float): HSV color format

    Returns:
        tuple: r, g, b RGB color format

    .. wraps::
        void ColorConvertHSVtoRGB(float h, float s, float v, float& out_r, float& out_g, float& out_b)
    """
    cdef float out_r, out_g, out_b
    out_r = out_g = out_b = 0
    cimgui.ColorConvertHSVtoRGB(h,s,v,out_r,out_g,out_b)
    return out_r, out_g, out_b

cpdef push_style_var(cimgui.ImGuiStyleVar variable, value):
    """Push style variable on stack.

    This function accepts both float and float two-tuples as ``value``
    argument. ImGui core implementation will verify if passed value has
    type compatibile with given style variable. If not, it will raise
    exception.

    **Note:** variables pushed on stack need to be poped using
    :func:`pop_style_var()` until the end of current frame. This
    implementation guards you from segfaults caused by redundant stack pops
    (raises exception if this happens) but generally it is safer and easier to
    use :func:`styled` or :func:`istyled` context managers.

    .. visual-example::
        :auto_layout:
        :width: 200
        :height: 80

        imgui.begin("Example: style variables")
        imgui.push_style_var(imgui.STYLE_ALPHA, 0.2)
        imgui.text("Alpha text")
        imgui.pop_style_var(1)
        imgui.end()

    Args:
        variable: imgui style variable constant
        value (float or two-tuple): style variable value


    .. wraps::
        PushStyleVar(ImGuiStyleVar idx, float val)
    """
    if not (0 <= variable < enums.ImGuiStyleVar_COUNT):
        warnings.warn("Unknown style variable: {}".format(variable))
        return False

    try:
        if isinstance(value, (tuple, list)):
            cimgui.PushStyleVar(variable, _cast_tuple_ImVec2(value))
        else:
            cimgui.PushStyleVar(variable, <float>(float(value)))
    except ValueError:
        raise ValueError(
            "Style value must be float or two-elements list/tuple"
        )
    else:
        return True


cpdef push_style_color(
    cimgui.ImGuiCol variable,
    float r,
    float g,
    float b,
    float a = 1.
):
    """Push style color on stack.

    **Note:** variables pushed on stack need to be popped using
    :func:`pop_style_color()` until the end of current frame. This
    implementation guards you from segfaults caused by redundant stack pops
    (raises exception if this happens) but generally it is safer and easier to
    use :func:`styled` or :func:`istyled` context managers.

    .. visual-example::
        :auto_layout:
        :width: 200
        :height: 80

        imgui.begin("Example: Color variables")
        imgui.push_style_color(imgui.COLOR_TEXT, 1.0, 0.0, 0.0)
        imgui.text("Colored text")
        imgui.pop_style_color(1)
        imgui.end()

    Args:
        variable: imgui style color constant
        r (float): red color intensity.
        g (float): green color intensity.
        b (float): blue color instensity.
        a (float): alpha intensity.

    .. wraps::
        PushStyleColor(ImGuiCol idx, const ImVec4& col)
    """
    if not (0 <= variable < enums.ImGuiCol_COUNT):
        warnings.warn("Unknown style variable: {}".format(variable))
        return False

    cimgui.PushStyleColor(variable, _cast_args_ImVec4(r, g, b, a))
    return True


cpdef pop_style_var(unsigned int count=1):
    """Pop style variables from stack.

    **Note:** This implementation guards you from segfaults caused by
    redundant stack pops (raises exception if this happens) but generally
    it is safer and easier to use :func:`styled` or :func:`istyled` context
    managers. See: :any:`push_style_var()`.

    Args:
        count (int): number of variables to pop from style variable stack.

    .. wraps::
        void PopStyleVar(int count = 1)
    """
    cimgui.PopStyleVar(count)


cpdef get_font_size():
    """get current font size (= height in pixels) of current font with current scale applied

    Returns:
        float: current font size (height in pixels)

    .. wraps::
        float GetFontSize()
    """
    return cimgui.GetFontSize()

cpdef get_style_color_vec_4(cimgui.ImGuiCol idx):
    return _cast_ImVec4_tuple(cimgui.GetStyleColorVec4(idx))

cpdef get_font_tex_uv_white_pixel():
    return _cast_ImVec2_tuple(cimgui.GetFontTexUvWhitePixel())

# TODO: Can we implement function overloading? Prefer these are all named 'get_color_u32' with different signatures
# https://www.python.org/dev/peps/pep-0443/
# Neither singledispatch nor multipledispatch seems to be available in Cython :-/

cpdef get_color_u32_idx(cimgui.ImGuiCol idx, float alpha_mul = 1.0):
    """ retrieve given style color with style alpha applied and optional extra alpha multiplier

    Returns:
        ImU32: 32-bit RGBA color

    .. wraps::
        ImU32 GetColorU32(ImGuiCol idx, alpha_mul)
    """
    return cimgui.GetColorU32(idx, alpha_mul)


cpdef get_color_u32_rgba(float r, float g, float b, float a):
    """ retrieve given color with style alpha applied

    Returns:
        ImU32: 32-bit RGBA color

    .. wraps::
        ImU32 GetColorU32(const ImVec4& col)
    """
    return cimgui.GetColorU32( _cast_args_ImVec4(r, g, b, a) )


cpdef get_color_u32(cimgui.ImU32 col):
    """retrieve given style color with style alpha applied and optional extra alpha multiplier

    Returns:
        ImU32: 32-bit RGBA color

    .. wraps::
        ImU32 GetColorU32(ImU32 col)
    """
    return cimgui.GetColorU32(col)



cpdef push_item_width(float item_width):
    """Push item width in the stack.

    **Note:** sizing of child region allows for three modes:

    * ``0.0`` - default to ~2/3 of windows width
    * ``>0.0`` - width in pixels
    * ``<0.0`` - align xx pixels to the right of window
      (so -FLOAT_MIN always align width to the right side)

    **Note:** width pushed on stack need to be poped using
    :func:`pop_item_width()` or it will be applied to all subsequent
    children components.

    .. visual-example::
        :auto_layout:
        :width: 200
        :height: 200

        imgui.begin("Example: item width")

        # custom width
        imgui.push_item_width(imgui.get_window_width() * 0.33)
        imgui.text('Lorem Ipsum ...')
        imgui.slider_float('float slider', 10.2, 0.0, 20.0, '%.2f', 1.0)
        imgui.pop_item_width()

        # default width
        imgui.text('Lorem Ipsum ...')
        imgui.slider_float('float slider', 10.2, 0.0, 20.0, '%.2f', 1.0)

        imgui.end()

    Args:
        item_width (float): width of the component

    .. wraps::
        void PushItemWidth(float item_width)
    """
    cimgui.PushItemWidth(item_width)


cpdef pop_item_width():
    """Reset width back to the default width.

    **Note:** This implementation guards you from segfaults caused by
    redundant stack pops (raises exception if this happens) but generally
    it is safer and easier to use :func:`styled` or :func:`istyled` context
    managers. See: :any:`push_item_width()`.

    .. wraps::
        void PopItemWidth()
    """
    cimgui.PopItemWidth()

cpdef set_next_item_width(float item_width):
    """Set width of the _next_ common large "item+label" widget. 
    * ``>0.0`` - width in pixels
    * ``<0.0`` - align xx pixels to the right of window
    (so -FLOAT_MIN always align width to the right side)
    
    Helper to avoid using ``push_item_width()``/``pop_item_width()`` for single items.
    
    Args:
        item_width (float): width of the component
    
    .. visual-example::
        :auto_layout:
        :width: 200
        :height: 200
        
        imgui.begin("Exemple: Next item width")
        imgui.set_next_item_width(imgui.get_window_width() * 0.33)
        imgui.slider_float('Slider 1', 10.2, 0.0, 20.0, '%.2f', 1.0)
        imgui.slider_float('Slider 2', 10.2, 0.0, 20.0, '%.2f', 1.0)
        imgui.end()
    
    .. wraps::
        void SetNextItemWidth(float item_width)
    """
    cimgui.SetNextItemWidth(item_width)

cpdef calculate_item_width():
    """Calculate and return the current item width.

    Returns:
        float: calculated item width.

    .. wraps::
        float CalcItemWidth()
    """
    return cimgui.CalcItemWidth()


cpdef push_text_wrap_pos(float wrap_pos_x = 0.0):
    """Word-wrapping function for text*() commands.

    **Note:** wrapping position allows these modes:
    * ``0.0`` - wrap to end of window (or column)
    * ``>0.0`` - wrap at 'wrap_pos_x' position in window local space
    * ``<0.0`` - no wrapping

    Args:
        wrap_pos_x (float): calculated item width.

    .. wraps::
        float PushTextWrapPos(float wrap_pos_x = 0.0f)
    """
    cimgui.PushTextWrapPos(wrap_pos_x)

push_text_wrap_position = push_text_wrap_pos

cpdef pop_text_wrap_pos():
    """Pop the text wrapping position from the stack.

    **Note:** This implementation guards you from segfaults caused by
    redundant stack pops (raises exception if this happens) but generally
    it is safer and easier to use :func:`styled` or :func:`istyled` context
    managers. See: :func:`push_text_wrap_pos()`.

    .. wraps::
        void PopTextWrapPos()
    """
    cimgui.PopTextWrapPos()

pop_text_wrap_position = pop_text_wrap_pos

cpdef push_allow_keyboard_focus(bool allow_focus):
    cimgui.PushAllowKeyboardFocus(allow_focus)

cpdef pop_allow_keyboard_focus():
    cimgui.PopAllowKeyboardFocus()

cpdef push_button_repeat(bool repeat):
    cimgui.PushButtonRepeat(repeat)

cpdef pop_button_repeat():
    cimgui.PopButtonRepeat()

cpdef pop_style_color(unsigned int count=1):
    """Pop style color from stack.

    **Note:** This implementation guards you from segfaults caused by
    redundant stack pops (raises exception if this happens) but generally
    it is safer and easier to use :func:`styled` or :func:`istyled` context
    managers. See: :any:`push_style_color()`.

    Args:
        count (int): number of variables to pop from style color stack.

    .. wraps::
        void PopStyleColor(int count = 1)
    """
    cimgui.PopStyleColor(count)


def separator():
    """Add vertical line as a separator beween elements.

    .. visual-example::
        :auto_layout:
        :width: 300

        imgui.begin("Example: separators")

        imgui.text("Some text with bullets")
        imgui.bullet_text("Bullet A")
        imgui.bullet_text("Bullet A")

        imgui.separator()

        imgui.text("Another text with bullets")
        imgui.bullet_text("Bullet A")
        imgui.bullet_text("Bullet A")

        imgui.end()

    .. wraps::
        void Separator()
    """
    cimgui.Separator()


def same_line(float position=0.0, float spacing=-1.0):
    """Call between widgets or groups to layout them horizontally.

    .. visual-example::
        :auto_layout:
        :width: 300

        imgui.begin("Example: same line widgets")

        imgui.text("same_line() with defaults:")
        imgui.button("yes"); imgui.same_line()
        imgui.button("no")

        imgui.text("same_line() with fixed position:")
        imgui.button("yes"); imgui.same_line(position=50)
        imgui.button("no")

        imgui.text("same_line() with spacing:")
        imgui.button("yes"); imgui.same_line(spacing=50)
        imgui.button("no")

        imgui.end()

    Args:
        position (float): fixed horizontal position position.
        spacing (float): spacing between elements.

    .. wraps::
        void SameLine(float pos_x = 0.0f, float spacing_w = -1.0f)
    """
    cimgui.SameLine(position, spacing)


def new_line():
    """Undo :any:`same_line()` call.

    .. wraps::
        void NewLine()
    """
    cimgui.NewLine()


def spacing():
    """Add vertical spacing beween elements.

    .. visual-example::
        :auto_layout:
        :width: 300

        imgui.begin("Example: vertical spacing")

        imgui.text("Some text with bullets:")
        imgui.bullet_text("Bullet A")
        imgui.bullet_text("Bullet A")

        imgui.spacing(); imgui.spacing()

        imgui.text("Another text with bullets:")
        imgui.bullet_text("Bullet A")
        imgui.bullet_text("Bullet A")

        imgui.end()

    .. wraps::
        void Spacing()
    """
    cimgui.Spacing()


def dummy(width, height):
    """Add dummy element of given size.

    .. visual-example::
        :auto_layout:
        :width: 300

        imgui.begin("Example: dummy elements")

        imgui.text("Some text with bullets:")
        imgui.bullet_text("Bullet A")
        imgui.bullet_text("Bullet B")

        imgui.dummy(0, 50)
        imgui.bullet_text("Text after dummy")

        imgui.end()

    .. wraps::
        void Dummy(const ImVec2& size)
    """
    cimgui.Dummy(_cast_args_ImVec2(width, height))


def indent(float width=0.0):
    """Move content to right by indent width.

    .. visual-example::
        :auto_layout:
        :width: 300

        imgui.begin("Example: item indenting")

        imgui.text("Some text with bullets:")

        imgui.bullet_text("Bullet A")
        imgui.indent()
        imgui.bullet_text("Bullet B (first indented)")
        imgui.bullet_text("Bullet C (indent continues)")
        imgui.unindent()
        imgui.bullet_text("Bullet D (indent cleared)")

        imgui.end()

    Args:
        width (float): fixed width of indent. If less or equal 0 it defaults
            to global indent spacing or value set using style value  stack
            (see :any:`push_style_var`).

    .. wraps::
        void Indent(float indent_w = 0.0f)
    """
    cimgui.Indent(width)


def unindent(float width=0.0):
    """Move content to left by indent width.

    .. visual-example::
        :auto_layout:
        :width: 300

        imgui.begin("Example: item unindenting")

        imgui.text("Some text with bullets:")

        imgui.bullet_text("Bullet A")
        imgui.unindent(10)
        imgui.bullet_text("Bullet B (first unindented)")
        imgui.bullet_text("Bullet C (unindent continues)")
        imgui.indent(10)
        imgui.bullet_text("Bullet C (unindent cleared)")

        imgui.end()

    Args:
        width (float): fixed width of indent. If less or equal 0 it defaults
            to global indent spacing or value set using style value stack
            (see :any:`push_style_var`).

    .. wraps::
        void Unindent(float indent_w = 0.0f)
    """
    cimgui.Unindent(width)


def columns(int count=1, str identifier=None, bool border=True):
    """Setup number of columns. Use an identifier to distinguish multiple
    column sets. close with ``columns(1)``.

    Legacy Columns API (2020: prefer using Tables!)

    .. visual-example::
        :auto_layout:
        :width: 500
        :height: 300

        imgui.begin("Example: Columns - File list")
        imgui.columns(4, 'fileLlist')
        imgui.separator()
        imgui.text("ID")
        imgui.next_column()
        imgui.text("File")
        imgui.next_column()
        imgui.text("Size")
        imgui.next_column()
        imgui.text("Last Modified")
        imgui.next_column()
        imgui.separator()
        imgui.set_column_offset(1, 40)

        imgui.next_column()
        imgui.text('FileA.txt')
        imgui.next_column()
        imgui.text('57 Kb')
        imgui.next_column()
        imgui.text('12th Feb, 2016 12:19:01')
        imgui.next_column()

        imgui.next_column()
        imgui.text('ImageQ.png')
        imgui.next_column()
        imgui.text('349 Kb')
        imgui.next_column()
        imgui.text('1st Mar, 2016 06:38:22')
        imgui.next_column()

        imgui.columns(1)
        imgui.end()

    Args:
        count (int): Columns count.
        identifier (str): Table identifier.
        border (bool): Display border, defaults to ``True``.

    .. wraps::
        void Columns(
            int count = 1,
            const char* id = NULL,
            bool border = true
        )
    """
    if identifier is None:
        cimgui.Columns(count, NULL, border)
    else:
        cimgui.Columns(count, _bytes(identifier), border)


def next_column():
    """Move to the next column drawing.

    For a complete example see :func:`columns()`.

    Legacy Columns API (2020: prefer using Tables!)

    .. wraps::
        void NextColumn()
    """
    cimgui.NextColumn()


def get_column_index():
    """Returns the current column index.

    For a complete example see :func:`columns()`.

    Legacy Columns API (2020: prefer using Tables!)

    Returns:
        int: the current column index.

    .. wraps::
        int GetColumnIndex()
    """
    return cimgui.GetColumnIndex()


def get_column_offset(int column_index=-1):
    """Returns position of column line (in pixels, from the left side of the
    contents region). Pass -1 to use current column, otherwise 0 to
    :func:`get_columns_count()`. Column 0 is usually 0.0f and not resizable
    unless you call this method.

    For a complete example see :func:`columns()`.

    Legacy Columns API (2020: prefer using Tables!)

    Args:
        column_index (int): index of the column to get the offset for.

    Returns:
        float: the position in pixels from the left side.

    .. wraps::
        float GetColumnOffset(int column_index = -1)
    """
    return cimgui.GetColumnOffset(column_index)


def set_column_offset(int column_index, float offset_x):
    """Set the position of column line (in pixels, from the left side of the
    contents region). Pass -1 to use current column.

    For a complete example see :func:`columns()`.

    Legacy Columns API (2020: prefer using Tables!)

    Args:
        column_index (int): index of the column to get the offset for.
        offset_x (float): offset in pixels.

    .. wraps::
        void SetColumnOffset(int column_index, float offset_x)
    """
    cimgui.SetColumnOffset(column_index, offset_x)


def get_column_width(int column_index=-1):
    """Return the column width.

    For a complete example see :func:`columns()`.

    Legacy Columns API (2020: prefer using Tables!)

    Args:
        column_index (int): index of the column to get the width for.

    .. wraps::
        float GetColumnWidth(int column_index = -1)
    """
    return cimgui.GetColumnWidth(column_index)


def set_column_width(int column_index, float width):
    """Set the position of column line (in pixels, from the left side of the
    contents region). Pass -1 to use current column.

    For a complete example see :func:`columns()`.

    Legacy Columns API (2020: prefer using Tables!)

    Args:
        column_index (int): index of the column to set the width for.
        width (float): width in pixels.

    .. wraps::
        void SetColumnWidth(int column_index, float width)
    """
    cimgui.SetColumnWidth(column_index, width)


def get_columns_count():
    """Get count of the columns in the current table.

    For a complete example see :func:`columns()`.

    Legacy Columns API (2020: prefer using Tables!)

    Returns:
        int: columns count.

    .. wraps::
        int GetColumnsCount()
    """
    return cimgui.GetColumnsCount()

cdef class _BeginEndTabBar(object):
    """
    Return value of :func:`begin_tab_bar` exposing ``opened`` boolean attribute.
    See :func:`begin_tab_bar` for an explanation and examples.

    Can be used as a context manager (in a ``with`` statement) to automatically call :func:`end_tab_bar`
    (if necessary) to end the tar bar created with :func:`begin_tab_bar` when the block ends,
    even if an exception is raised.

    This class is not intended to be instantiated by the user (thus the `_` name prefix).
    It should be obtained as the return value of the :func:`begin_tab_bar` function.
    """

    cdef readonly bool opened

    def __cinit__(self, bool opened):
        self.opened = opened

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        if self.opened:
            cimgui.EndTabBar()

    def __bool__(self):
        """For legacy support, returns ``opened``."""
        return self.opened

    def __repr__(self):
        return "{}(opened={})".format(
            self.__class__.__name__, self.opened
        )

    def __eq__(self, other):
        if other.__class__ is self.__class__:
            return self.opened is other.opened
        return self.opened is other


def begin_tab_bar(str identifier, cimgui.ImGuiTabBarFlags flags = 0):
    """Create and append into a TabBar

    Args:
        identifier(str): String identifier of the tab window
        flags: ImGuiTabBarFlags flags. See:
            :ref:`list of available flags <tabbar-flag-options>`.

    Returns:
        _BeginEndTabBar: Use ``opened`` bool attribute to tell if the Tab Bar is open.
        Only call :func:`end_tab_bar` if ``opened`` is True.
        Use with ``with`` to automatically call :func:`end_tab_bar` if necessary when the block ends.

    .. wraps::
        bool BeginTabBar(const char* str_id, ImGuiTabBarFlags flags = 0)

    """
    return _BeginEndTabBar.__new__(
        _BeginEndTabBar,
        cimgui.BeginTabBar(_bytes(identifier), flags)
    )

def end_tab_bar():
    """End a previously opened tab bar.
    Only call this function if ``begin_tab_bar().opened`` is True.

    .. wraps::
        void EndTabBar()
    """
    cimgui.EndTabBar()

cdef class _BeginEndTabItem(object):
    """
    Return value of :func:`begin_tab_item` exposing ``selected`` and ``opened`` boolean attributes.
    See :func:`begin_tab_item` for an explanation of these attributes and examples.

    For legacy support, the attributes can also be accessed by unpacking or indexing into this object.

    Can be used as a context manager (in a ``with`` statement) to automatically call :func:`end_tab_item`
    to end the tab item created with :func:`begin_tab_item` when the block ends, even if an exception is raised.

    This class is not intended to be instantiated by the user (thus the `_` name prefix).
    It should be obtained as the return value of the :func:`begin_tab_item` function.
    """

    cdef readonly bool selected
    cdef readonly bool opened

    def __cinit__(self, bool selected, bool opened):
        self.selected = selected
        self.opened = opened

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        if self.selected:
            cimgui.EndTabItem()

    def __getitem__(self, item):
        """For legacy support, returns ``(selected, opened)[item]``."""
        return (self.selected, self.opened)[item]

    def __iter__(self):
        """For legacy support, returns ``iter((selected, opened))``."""
        return iter((self.selected, self.opened))

    def __repr__(self):
        return "{}(selected={}, opened={})".format(
            self.__class__.__name__, self.selected, self.opened
        )

    def __eq__(self, other):
        if other.__class__ is self.__class__:
            return (self.selected, self.opened) == (other.selected, other.opened)
        return (self.selected, self.opened) == other


def begin_tab_item(str label, opened = None, cimgui.ImGuiTabItemFlags flags = 0):
    """Create a Tab.

    .. visual-example::
        :auto_layout:
        :width: 300

        opened_state = True

        #...

        with imgui.begin("Example Tab Bar"):
            with imgui.begin_tab_bar("MyTabBar") as tab_bar:
                if tab_bar.opened:
                    with imgui.begin_tab_item("Item 1") as item1:
                        if item1.selected:
                            imgui.text("Here is the tab content!")

                    with imgui.begin_tab_item("Item 2") as item2:
                        if item2.selected:
                            imgui.text("Another content...")

                    with imgui.begin_tab_item("Item 3", opened=opened_state) as item3:
                        opened_state = item3.opened
                        if item3.selected:
                            imgui.text("Hello Saylor!")

    Example::

        opened_state = True

        #...

        imgui.begin("Example Tab Bar")
        if imgui.begin_tab_bar("MyTabBar"):

            if imgui.begin_tab_item("Item 1").selected:
                imgui.text("Here is the tab content!")
                imgui.end_tab_item()

            if imgui.begin_tab_item("Item 2").selected:
                imgui.text("Another content...")
                imgui.end_tab_item()

            selected, opened_state = imgui.begin_tab_item("Item 3", opened=opened_state)
            if selected:
                imgui.text("Hello Saylor!")
                imgui.end_tab_item()

            imgui.end_tab_bar()
        imgui.end()

    Args:
        label (str): Label of the tab item
        removable (bool): If True, the tab item can be removed
        flags: ImGuiTabItemFlags flags. See:
            :ref:`list of available flags <tabitem-flag-options>`.

    Returns:
        _BeginEndTabItem: ``(selected, opened)`` struct of bools. If tab item is selected
        ``selected==True``. The value of ``opened`` is always True for
        non-removable and open tab items but changes state to False on close
        button click for removable tab items.
        Only call :func:`end_tab_item` if ``selected`` is True.
        Use with ``with`` to automatically call :func:`end_tab_item` if necessary when the block ends.

    .. wraps::
        bool BeginTabItem(
            const char* label,
            bool* p_open = NULL,
            ImGuiTabItemFlags flags = 0
        )
    """
    cdef cimgui.bool inout_opened = opened
    return _BeginEndTabItem.__new__(
        _BeginEndTabItem,
        cimgui.BeginTabItem(
            _bytes(label),
            &inout_opened if opened is not None else NULL, flags
        ),
        inout_opened
    )

def end_tab_item():
    """End a previously opened tab item.
    Only call this function if ``begin_tab_item().selected`` is True.

    .. wraps::
        void EndTabItem()
    """
    cimgui.EndTabItem()

def tab_item_button(str label, cimgui.ImGuiTabItemFlags flags = 0):
    """Create a Tab behaving like a button.
    Cannot be selected in the tab bar.

    Args:
        label (str): Label of the button
        flags: ImGuiTabItemFlags flags. See:
            :ref:`list of available flags <tabitem-flag-options>`.

    Returns:
        (bool): Return true when clicked.

    .. visual-example:
        :auto_layout:
        :width: 300

        imgui.begin("Example Tab Bar")
        if imgui.begin_tab_bar("MyTabBar"):

            if imgui.begin_tab_item("Item 1")[0]:
                imgui.text("Here is the tab content!")
                imgui.end_tab_item()

            if imgui.tab_item_button("Click me!"):
                print('Clicked!')

            imgui.end_tab_bar()
        imgui.end()

    .. wraps::
        bool TabItemButton(const char* label, ImGuiTabItemFlags flags = 0)
    """
    return cimgui.TabItemButton(_bytes(label), flags)

def set_tab_item_closed(str tab_or_docked_window_label):
    """Notify TabBar or Docking system of a closed tab/window ahead (useful to reduce visual flicker on reorderable tab bars).
    For tab-bar: call after BeginTabBar() and before Tab submissions.
    Otherwise call with a window name.

    Args:
        tab_or_docked_window_label (str): Label of the targeted tab or docked window

    .. visual-example:
        :auto_layout:
        :width: 300

        imgui.begin("Example Tab Bar")
        if imgui.begin_tab_bar("MyTabBar"):

            if imgui.begin_tab_item("Item 1")[0]:
                imgui.text("Here is the tab content!")
                imgui.end_tab_item()

            if imgui.begin_tab_item("Item 2")[0]:
                imgui.text("This item won't whow !")
                imgui.end_tab_item()

            imgui.set_tab_item_closed("Item 2")

            imgui.end_tab_bar()
        imgui.end()

    .. wraps:
        void SetTabItemClosed(const char* tab_or_docked_window_label)
    """
    cimgui.SetTabItemClosed(_bytes(tab_or_docked_window_label))


cdef class _BeginEndDragDropSource(object):
    """
    Return value of :func:`begin_drag_drop_source` exposing ``dragging`` boolean attribute.
    See :func:`begin_drag_drop_source` for an explanation and examples.

    Can be used as a context manager (in a ``with`` statement) to automatically call :func:`end_drag_drop_source`
    (if necessary) to end the drag-drop source created with :func:`begin_drag_drop_source` when the block ends,
    even if an exception is raised.

    This class is not intended to be instantiated by the user (thus the `_` name prefix).
    It should be obtained as the return value of the :func:`begin_drag_drop_source` function.
    """

    cdef readonly bool dragging

    def __cinit__(self, bool dragging):
        self.dragging = dragging

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        if self.dragging:
            cimgui.EndDragDropSource()

    def __bool__(self):
        """For legacy support, returns ``dragging``."""
        return self.dragging

    def __repr__(self):
        return "{}(dragging={})".format(
            self.__class__.__name__, self.dragging
        )

    def __eq__(self, other):
        if other.__class__ is self.__class__:
            return self.dragging is other.dragging
        return self.dragging is other


def begin_drag_drop_source(cimgui.ImGuiDragDropFlags flags=0):
    """Set the current item as a drag and drop source. If ``dragging`` is True, you
    can call :func:`set_drag_drop_payload` and :func:`end_drag_drop_source`.
    Use with ``with`` to automatically call :func:`end_drag_drop_source` if necessary.

    **Note:** this is a beta API.

    .. visual-example::
        :auto_layout:
        :width: 300

        with imgui.begin("Example: drag and drop"):

            imgui.button('source')
            with imgui.begin_drag_drop_source() as drag_drop_src:
                if drag_drop_src.dragging:
                    imgui.set_drag_drop_payload('itemtype', b'payload')
                    imgui.button('dragged source')

            imgui.button('dest')
            with imgui.begin_drag_drop_target() as drag_drop_dst:
                if drag_drop_dst.hovered:
                    payload = imgui.accept_drag_drop_payload('itemtype')
                    if payload is not None:
                        print('Received:', payload)

    Example::

        imgui.begin("Example: drag and drop")

        imgui.button('source')
        if imgui.begin_drag_drop_source():
            imgui.set_drag_drop_payload('itemtype', b'payload')
            imgui.button('dragged source')
            imgui.end_drag_drop_source()

        imgui.button('dest')
        if imgui.begin_drag_drop_target():
            payload = imgui.accept_drag_drop_payload('itemtype')
            if payload is not None:
                print('Received:', payload)
            imgui.end_drag_drop_target()

        imgui.end()

    Args:
        flags (ImGuiDragDropFlags): DragDrop flags.

    Returns:
        _BeginEndDragDropSource: Use ``dragging`` to tell if a drag starting at this source is occurring.
        Only call :func:`end_drag_drop_source` if ``dragging`` is True.
        Use with ``with`` to automatically call :func:`end_drag_drop_source` if necessary when the block ends.

    .. wraps::
        bool BeginDragDropSource(ImGuiDragDropFlags flags = 0)
    """
    return _BeginEndDragDropSource.__new__(
        _BeginEndDragDropSource,
        cimgui.BeginDragDropSource(flags)
    )


def set_drag_drop_payload(str type, bytes data, cimgui.ImGuiCond condition=0):
    """Set the payload for a drag and drop source. Only call after
    :func:`begin_drag_drop_source` returns True.

    **Note:** this is a beta API.

    For a complete example see :func:`begin_drag_drop_source`.

    Args:
        type (str): user defined type with maximum 32 bytes.
        data (bytes): the data for the payload; will be copied and stored internally.
        condition (:ref:`condition flag <condition-options>`): defines on which
            condition value should be set. Defaults to :any:`imgui.ALWAYS`.

    .. wraps::
        bool SetDragDropPayload(const char* type, const void* data, size_t size, ImGuiCond cond = 0)
    """
    return cimgui.SetDragDropPayload(_bytes(type), <const char*>data, len(data), condition)


def end_drag_drop_source():
    """End the drag and drop source.
    Only call if ``begin_drag_drop_source().dragging`` is True.

    **Note:** this is a beta API.

    For a complete example see :func:`begin_drag_drop_source`.

    .. wraps::
        void EndDragDropSource()
    """
    cimgui.EndDragDropSource()


cdef class _BeginEndDragDropTarget(object):
    """
    Return value of :func:`begin_drag_drop_target` exposing ``hovered`` boolean attribute.
    See :func:`begin_drag_drop_target` for an explanation and examples.

    Can be used as a context manager (in a ``with`` statement) to automatically call :func:`end_drag_drop_target`
    (if necessary) to end the drag-drop target created with :func:`begin_drag_drop_target` when the block ends,
    even if an exception is raised.

    This class is not intended to be instantiated by the user (thus the `_` name prefix).
    It should be obtained as the return value of the :func:`begin_drag_drop_target` function.
    """

    cdef readonly bool hovered

    def __cinit__(self, bool hovered):
        self.hovered = hovered

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        if self.hovered:
            cimgui.EndDragDropTarget()

    def __bool__(self):
        """For legacy support, returns ``hovered``."""
        return self.hovered

    def __repr__(self):
        return "{}(hovered={})".format(
            self.__class__.__name__, self.hovered
        )

    def __eq__(self, other):
        if other.__class__ is self.__class__:
            return self.hovered is other.hovered
        return self.hovered is other


def begin_drag_drop_target():
    """Set the current item as a drag and drop target. If ``hovered`` is True, you
    can call :func:`accept_drag_drop_payload` and :func:`end_drag_drop_target`.
    Use with ``with`` to automatically call :func:`end_drag_drop_target` if necessary.

    For a complete example see :func:`begin_drag_drop_source`.

    **Note:** this is a beta API.

    Returns:
        _BeginEndDragDropTarget: Use ``hovered` to tell if a drag hovers over the target.
        Only call :func:`end_drag_drop_target` if ``hovered`` is True.
        Use with ``with`` to automatically call :func:`end_drag_drop_target` if necessary when the block ends.

    .. wraps::
        bool BeginDragDropTarget()
    """
    return _BeginEndDragDropTarget.__new__(
        _BeginEndDragDropTarget,
        cimgui.BeginDragDropTarget()
    )


def accept_drag_drop_payload(str type, cimgui.ImGuiDragDropFlags flags=0):
    """Get the drag and drop payload. Only call after :func:`begin_drag_drop_target`
    returns True.

    **Note:** this is a beta API.

    For a complete example see :func:`begin_drag_drop_source`.

    Args:
        type (str): user defined type with maximum 32 bytes.
        flags (ImGuiDragDropFlags): DragDrop flags.

    Returns:
        bytes: the payload data that was set by :func:`set_drag_drop_payload`.

    .. wraps::
        const ImGuiPayload* AcceptDragDropPayload(const char* type, ImGuiDragDropFlags flags = 0)
    """
    cdef const cimgui.ImGuiPayload* payload = cimgui.AcceptDragDropPayload(_bytes(type), flags)
    if payload == NULL:
        return None
    cdef const char* data = <const char *>payload.Data
    return <bytes>data[:payload.DataSize]


def end_drag_drop_target():
    """End the drag and drop source.
    Only call this function if ``begin_drag_drop_target().hovered`` is True.

    **Note:** this is a beta API.

    For a complete example see :func:`begin_drag_drop_source`.

    .. wraps::
        void EndDragDropTarget()
    """
    cimgui.EndDragDropTarget()


def get_drag_drop_payload():
    """Peek directly into the current payload from anywhere. 
    May return NULL. 
    
    .. todo:: Map ImGuiPayload::IsDataType() to test for the payload type.
    
    .. wraps::
        const ImGuiPayload* GetDragDropPayload()
    """
    cdef const cimgui.ImGuiPayload* payload = cimgui.GetDragDropPayload()
    if payload == NULL:
        return None
    cdef const char* data = <const char *>payload.Data
    return <bytes>data[:payload.DataSize]

def push_clip_rect(
        float clip_rect_min_x,
        float clip_rect_min_y,
        float clip_rect_max_x,
        float clip_rect_max_y,
        bool intersect_with_current_clip_rect = False
    ):
    """Push the clip region, i.e. the area of the screen to be rendered,on the stack. 
    If ``intersect_with_current_clip_rect`` is ``True``, the intersection between pushed 
    clip region and previous one is added on the stack. 
    See: :func:`pop_clip_rect()`
    
    Args:
        clip_rect_min_x, clip_rect_min_y (float): Position of the minimum point of the rectangle
        clip_rect_max_x, clip_rect_max_y (float): Position of the maximum point of the rectangle
        intersect_with_current_clip_rect (bool): If True, intersection with current clip region is pushed on stack.
    
    .. visual-example::
        :auto_layout:
        :width: 150
        :height: 150

        imgui.begin("Example Cliprect")
        
        winpos = imgui.get_window_position()
        imgui.push_clip_rect(0+winpos.x,0+winpos.y,100+winpos.x,100+winpos.y)
        imgui.push_clip_rect(50+winpos.x,50+winpos.y,100+winpos.x,100+winpos.y, True)
        
        imgui.text('Lorem ipsum dolor sit amet, consectetur adipiscing elit.')
        imgui.text('Vivamus mattis velit ac ex auctor gravida.')
        imgui.text('Quisque varius erat finibus porta interdum.')
        imgui.text('Nam neque magna, dapibus placerat urna eget, facilisis malesuada ipsum.')
        
        imgui.pop_clip_rect()
        imgui.pop_clip_rect()
        
        imgui.end()
    
    .. wraps::
        void PushClipRect(
            const ImVec2& clip_rect_min, 
            const ImVec2& clip_rect_max, 
            bool intersect_with_current_clip_rect
        )
    """
    cimgui.PushClipRect(
        _cast_args_ImVec2(clip_rect_min_x, clip_rect_min_y),
        _cast_args_ImVec2(clip_rect_max_x, clip_rect_max_y),
        intersect_with_current_clip_rect
    )
    
def pop_clip_rect():
    """Pop the last clip region from the stack. See: :func:`push_clip_rect()`.
    
    .. wraps::
        void PopClipRect()
    """
    cimgui.PopClipRect()


cdef class _BeginEndGroup(object):
    """
    Return value of :func:`begin_group`.
    See :func:`begin_group` for an explanation and examples.

    Can be used as a context manager (in a ``with`` statement) to automatically call :func:`end_group`
    to end the group created with :func:`begin_group` when the block ends,
    even if an exception is raised.

    This class is not intended to be instantiated by the user (thus the `_` name prefix).
    It should be obtained as the return value of the :func:`begin_group` function.
    """

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        cimgui.EndGroup()

    def __repr__(self):
        return "{}()".format(
            self.__class__.__name__
        )


def begin_group():
    """Start item group and lock its horizontal starting position.

    Captures group bounding box into one "item". Thanks to this you can use
    :any:`is_item_hovered()` or layout primitives such as :any:`same_line()`
    on whole group, etc.

    .. visual-example::
        :auto_layout:
        :width: 500

        with imgui.begin("Example: item groups"):

            with imgui.begin_group():
                imgui.text("First group (buttons):")
                imgui.button("Button A")
                imgui.button("Button B")

            imgui.same_line(spacing=50)

            with imgui.begin_group():
                imgui.text("Second group (text and bullet texts):")
                imgui.bullet_text("Bullet A")
                imgui.bullet_text("Bullet B")

    Example::

        imgui.begin("Example: item groups")

        imgui.begin_group()
        imgui.text("First group (buttons):")
        imgui.button("Button A")
        imgui.button("Button B")
        imgui.end_group()

        imgui.same_line(spacing=50)

        imgui.begin_group()
        imgui.text("Second group (text and bullet texts):")
        imgui.bullet_text("Bullet A")
        imgui.bullet_text("Bullet B")
        imgui.end_group()

        imgui.end()

    Returns:
        _BeginEndGrouop; use with ``with`` to automatically call :func:`end_group` when the block ends.

    .. wraps::
        void BeginGroup()
    """
    cimgui.BeginGroup()
    return _BeginEndGroup.__new__(_BeginEndGroup)


def end_group():
    """End group (see: :any:`begin_group`).

    .. wraps::
        void EndGroup()
    """
    cimgui.EndGroup()


def get_cursor_pos():
    """Get the cursor position.

    .. wraps::
        ImVec2 GetCursorPos()
    """
    return _cast_ImVec2_tuple(cimgui.GetCursorPos())


def get_cursor_pos_x():
    return cimgui.GetCursorPosX()


def get_cursor_pos_y():
    return cimgui.GetCursorPosY()


def set_cursor_pos(local_pos):
    """Set the cursor position in local coordinates [0..<window size>] (useful to work with ImDrawList API)

    .. wraps::
        ImVec2 SetCursorScreenPos(const ImVec2& screen_pos)
    """
    cimgui.SetCursorPos(_cast_tuple_ImVec2(local_pos))


def set_cursor_pos_x(float x):
    cimgui.SetCursorPosX(x)


def set_cursor_pos_y(float y):
    cimgui.SetCursorPosY(y)


def get_cursor_start_pos():
    """Get the initial cursor position.

    .. wraps::
        ImVec2 GetCursorStartPos()
    """
    return _cast_ImVec2_tuple(cimgui.GetCursorStartPos())


def get_cursor_screen_pos():
    """Get the cursor position in absolute screen coordinates [0..io.DisplaySize] (useful to work with ImDrawList API)

    .. wraps::
        ImVec2 GetCursorScreenPos()
    """
    return _cast_ImVec2_tuple(cimgui.GetCursorScreenPos())


def set_cursor_screen_pos(screen_pos):
    """Set the cursor position in absolute screen coordinates [0..io.DisplaySize] (useful to work with ImDrawList API)

    .. wraps::
        ImVec2 SetCursorScreenPos(const ImVec2& screen_pos)
    """
    cimgui.SetCursorScreenPos(_cast_tuple_ImVec2(screen_pos))


get_cursor_position = get_cursor_pos
set_cursor_position = set_cursor_pos
get_cursor_start_position = get_cursor_start_pos
get_cursor_screen_position = get_cursor_screen_pos
set_cursor_screen_position = set_cursor_screen_pos

def align_text_to_frame_padding():
    cimgui.AlignTextToFramePadding()

def get_text_line_height():
    """Get text line height.

    Returns:
        int: text line height.

    .. wraps::
        void GetTextLineHeight()
    """
    return cimgui.GetTextLineHeight()


def get_text_line_height_with_spacing():
    """Get text line height, with spacing.

    Returns:
        int: text line height, with spacing.

    .. wraps::
        void GetTextLineHeightWithSpacing()
    """
    return cimgui.GetTextLineHeightWithSpacing()


def get_frame_height():
    """~ FontSize + style.FramePadding.y * 2

    .. wraps::
        float GetFrameHeight()
        float GetFrameHeightWithSpacing() except +
    """
    return cimgui.GetFrameHeight()


def get_frame_height_with_spacing():
    """~ FontSize + style.FramePadding.y * 2 + style.ItemSpacing.y (distance in pixels between 2 consecutive lines of framed widgets)

    .. wraps::
        float GetFrameHeightWithSpacing()
    """
    return cimgui.GetFrameHeightWithSpacing()


def create_context(_FontAtlas shared_font_atlas = None):
    """CreateContext

    .. todo::
        Add an example

    .. wraps::
        ImGuiContext* CreateContext(
                # note: optional
                ImFontAtlas* shared_font_atlas = NULL);
        )
    """

    cdef cimgui.ImGuiContext* _ptr

    if (shared_font_atlas):
        _ptr = cimgui.CreateContext(shared_font_atlas._ptr)
    else:
        _ptr = cimgui.CreateContext(NULL)

    # Update submodules:
    internal.UpdateImGuiContext(_ptr)

    return _ImGuiContext.from_ptr(_ptr)


def destroy_context(_ImGuiContext ctx = None):
    """DestroyContext

    .. wraps::
        DestroyContext(
                # note: optional
                ImGuiContext* ctx = NULL);
    """

    if ctx and ctx._ptr != NULL:
        del _contexts[<uintptr_t>ctx._ptr]
        cimgui.DestroyContext(ctx._ptr)
        ctx._ptr = NULL
        
        # Update submodules:
        internal.UpdateImGuiContext(NULL)

    else:
        raise RuntimeError("Context invalid (None or destroyed)")


def get_current_context():
    """GetCurrentContext

    .. wraps::
        ImGuiContext* GetCurrentContext();
    """

    cdef cimgui.ImGuiContext* _ptr
    _ptr = cimgui.GetCurrentContext()
    return _ImGuiContext.from_ptr(_ptr)


def set_current_context(_ImGuiContext ctx):
    """SetCurrentContext

    .. wraps::
        SetCurrentContext(
                ImGuiContext *ctx);
    """
    cimgui.SetCurrentContext(ctx._ptr)
    
    # Update submodules:
    internal.UpdateImGuiContext(ctx._ptr)


def push_id(str str_id):
    """Push an ID into the ID stack

    Args:
        str_id (str): ID to push

      wraps::
        PushID(const char* str_id)
    """
    cimgui.PushID(_bytes(str_id))


def pop_id():
    """Pop from the ID stack

      wraps::
        PopID()
    """
    cimgui.PopID()

def _ansifeed_text_ansi(str text):
    """Add ANSI-escape-formatted text to current widget stack.

    Similar to imgui.text, but with ANSI parsing.
    imgui.text documentation below:

    .. visual-example::
        :title: simple text widget
        :height: 80
        :auto_layout:

        imgui.begin("Example: simple text")
        imgui.extra.text_ansi("Default \033[31m colored \033[m default")
        imgui.end()

    Args:
        text (str): text to display.

    .. wraps::
        Text(const char* fmt, ...)
    """
    # note: "%s" required for safety and to favor of Python string formating
    ansifeed.TextAnsi("%s", _bytes(text))


def _ansifeed_text_ansi_colored(str text, float r, float g, float b, float a=1.):
    """Add pre-colored ANSI-escape-formatted text to current widget stack.

    Similar to imgui.text_colored, but with ANSI parsing.
    imgui.text_colored documentation below:

    It is a shortcut for:

    .. code-block:: python

        imgui.push_style_color(imgui.COLOR_TEXT, r, g, b, a)
        imgui.extra.text_ansi(text)
        imgui.pop_style_color()


    .. visual-example::
        :title: colored text widget
        :height: 100
        :auto_layout:

        imgui.begin("Example: colored text")
        imgui.text_ansi_colored("Default \033[31m colored \033[m default", 1, 0, 0)
        imgui.end()

    Args:
        text (str): text to display.
        r (float): red color intensity.
        g (float): green color intensity.
        b (float): blue color instensity.
        a (float): alpha intensity.

    .. wraps::
        TextColored(const ImVec4& col, const char* fmt, ...)
    """
    # note: "%s" required for safety and to favor of Python string formating
    ansifeed.TextAnsiColored(_cast_args_ImVec4(r, g, b, a), "%s", _bytes(text))


# === Extra utilities ====

@contextmanager
@cython.binding(True)
def _py_font(_Font font):
    """Use specified font in given context.

    .. visual-example::
        :auto_layout:
        :height: 100
        :width: 320

        io = imgui.get_io()

        new_font = io.fonts.add_font_from_file_ttf("DroidSans.ttf", 20)
        impl.refresh_font_texture()

        # later in frame code

        imgui.begin("Default Window")

        imgui.text("Text displayed using default font")
        with imgui.font(new_font):
            imgui.text("Text displayed using custom font")

        imgui.end()

    Args:
        font (_Font): font object retrieved from :any:`add_font_from_file_ttf`.
    """
    push_font(font)
    yield
    pop_font()


@contextmanager
@cython.binding(True)
def _py_styled(cimgui.ImGuiStyleVar variable, value):
    # note: we treat bool value as integer to guess if we are required to pop
    #       anything because IMGUI may simply skip pushing
    count = push_style_var(variable, value)
    yield
    pop_style_var(count)


@contextmanager
@cython.binding(True)
def _py_colored(
    cimgui.ImGuiCol variable,
    float r,
    float g,
    float b,
    float a = 1.
):
    # note: we treat bool value as integer to guess if we are required to pop
    #       anything because IMGUI may simply skip pushing
    count = push_style_color(variable, r, g, b, a)
    yield
    pop_style_color(count)


@contextmanager
@cython.binding(True)
def _py_istyled(*variables_and_values):
    # todo: rename to nstyled?
    count = 0
    iterator = iter(variables_and_values)

    try:
        # note: this is a trick that allows us convert flat list to pairs
        for var, val in izip_longest(iterator, iterator, fillvalue=None):
            # note: since we group into pairs it is impossible to have
            #       var equal to None
            if val is not None:
                count += push_style_var(var, val)
            else:
                raise ValueError(
                    "Unsufficient style info: {} variable lacks a value"
                    "".format(var)
                )
    except:
        raise
    else:
        yield

    finally:
        # perf: short wiring despite we have a wrapper for this
        cimgui.PopStyleVar(count)


@contextmanager
@cython.binding(True)
def _py_scoped(str str_id):
    """Use scoped ID within a block of code.

    This context manager can be used to distinguish widgets sharing
    same implicit identifiers without manual calling of :func:`push_id`
    :func:`pop_id` functions.

    Example:

    Args:
        str_id (str): ID to push and pop within marked scope
    """
    push_id(str_id)
    yield
    pop_id()


def _py_vertex_buffer_vertex_pos_offset():
    return <uintptr_t><size_t>&(<cimgui.ImDrawVert*>NULL).pos

def _py_vertex_buffer_vertex_uv_offset():
    return <uintptr_t><size_t>&(<cimgui.ImDrawVert*>NULL).uv

def _py_vertex_buffer_vertex_col_offset():
    return <uintptr_t><size_t>&(<cimgui.ImDrawVert*>NULL).col

def _py_vertex_buffer_vertex_size():
    return sizeof(cimgui.ImDrawVert)

def _py_index_buffer_index_size():
    return sizeof(cimgui.ImDrawIdx)
