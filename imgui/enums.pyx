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
WINDOW_NO_DOCKING = enums.ImGuiWindowFlags_NoDocking
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

# === Flags for ImGui::DockSpace(), shared/inherited by child nodes.===
DOCKNODE_NONE = enums.ImGuiDockNodeFlags_None
DOCKNODE_KEEPALIVE_ONLY = enums.ImGuiDockNodeFlags_KeepAliveOnly
#ImGuiDockNodeFlags_NoCentralNode
DOCKNODE_NO_DOCKING_IN_CENTRAL_NODE = enums.ImGuiDockNodeFlags_NoDockingInCentralNode
DOCKNODE_PASSTHRU_CENTRAL_NODE = enums.ImGuiDockNodeFlags_PassthruCentralNode
DOCKNODE_NO_SPLIT = enums.ImGuiDockNodeFlags_NoSplit
DOCKNODE_NO_RESIZE = enums.ImGuiDockNodeFlags_NoResize
DOCKNODE_AUTO_HIDE_TABBAR = enums.ImGuiDockNodeFlags_AutoHideTabBar

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
COLOR_DOCKING_PREVIEW = enums.ImGuiCol_DockingPreview
COLOR_DOCKING_EMPTY_BACKGROUND = enums.ImGuiCol_DockingEmptyBg
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
CONFIG_DOCKING_ENABLE = enums.ImGuiConfigFlags_.ImGuiConfigFlags_DockingEnable
CONFIG_VIEWPORTS_ENABLE = enums.ImGuiConfigFlags_.ImGuiConfigFlags_ViewportsEnable
CONFIG_DPI_ENABLE_SCALE_VIEWPORTS = enums.ImGuiConfigFlags_.ImGuiConfigFlags_DpiEnableScaleViewports
CONFIG_DPI_ENABLE_SCALE_FONTS = enums.ImGuiConfigFlags_.ImGuiConfigFlags_DpiEnableScaleFonts
CONFIG_IS_RGB = enums.ImGuiConfigFlags_.ImGuiConfigFlags_IsSRGB
CONFIG_IS_TOUCH_SCREEN = enums.ImGuiConfigFlags_.ImGuiConfigFlags_IsTouchScreen

# ==== Backend Flags ====
BACKEND_NONE = enums.ImGuiBackendFlags_None
BACKEND_HAS_GAMEPAD = enums.ImGuiBackendFlags_.ImGuiBackendFlags_HasGamepad
BACKEND_HAS_MOUSE_CURSORS = enums.ImGuiBackendFlags_.ImGuiBackendFlags_HasMouseCursors
BACKEND_HAS_SET_MOUSE_POS = enums.ImGuiBackendFlags_.ImGuiBackendFlags_HasSetMousePos
BACKEND_RENDERER_HAS_VTX_OFFSET = enums.ImGuiBackendFlags_RendererHasVtxOffset
BACKEND_PLATFORM_HAS_VIEWPORTS = enums.ImGuiBackendFlags_PlatformHasViewports
BACKEND_HAS_MOUSE_HOVERED_VIEWPORT = enums.ImGuiBackendFlags_HasMouseHoveredViewport
BACKEND_RENDERER_HAS_VIEWPORTS = enums.ImGuiBackendFlags_RendererHasViewports

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
VIEWPORT_FLAGS_NO_DECORATION = enums.ImGuiViewportFlags_NoDecoration
VIEWPORT_FLAGS_NO_TASK_BAR_ICON = enums.ImGuiViewportFlags_NoTaskBarIcon
VIEWPORT_FLAGS_NO_FOCUS_ON_APPEARING = enums.ImGuiViewportFlags_NoFocusOnAppearing
VIEWPORT_FLAGS_NO_FOCUS_ON_CLICK = enums.ImGuiViewportFlags_NoFocusOnClick
VIEWPORT_FLAGS_NO_INPUTS = enums.ImGuiViewportFlags_NoInputs
VIEWPORT_FLAGS_NO_RENDERER_CLEAR = enums.ImGuiViewportFlags_NoRendererClear
VIEWPORT_FLAGS_TOP_MOST = enums.ImGuiViewportFlags_TopMost
VIEWPORT_FLAGS_MINIMIZED = enums.ImGuiViewportFlags_Minimized
VIEWPORT_FLAGS_NO_AUTO_MERGE = enums.ImGuiViewportFlags_NoAutoMerge
VIEWPORT_FLAGS_CAN_HOST_OTHER_WINDOWS = enums.ImGuiViewportFlags_CanHostOtherWindows