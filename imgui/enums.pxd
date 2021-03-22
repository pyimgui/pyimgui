cdef extern from "imgui.h":
    ctypedef enum ImGuiKey_:
        ImGuiKey_Tab,
        ImGuiKey_LeftArrow,
        ImGuiKey_RightArrow,
        ImGuiKey_UpArrow,
        ImGuiKey_DownArrow,
        ImGuiKey_PageUp,
        ImGuiKey_PageDown,
        ImGuiKey_Home,
        ImGuiKey_End,
        ImGuiKey_Insert,
        ImGuiKey_Delete,
        ImGuiKey_Backspace,
        ImGuiKey_Space,
        ImGuiKey_Enter,
        ImGuiKey_Escape,
        ImGuiKey_KeyPadEnter,
        ImGuiKey_A,                 # for text edit CTRL+A: select all
        ImGuiKey_C,                 # for text edit CTRL+C: copy
        ImGuiKey_V,                 # for text edit CTRL+V: paste
        ImGuiKey_X,                 # for text edit CTRL+X: cut
        ImGuiKey_Y,                 # for text edit CTRL+Y: redo
        ImGuiKey_Z,                 # for text edit CTRL+Z: undo
        ImGuiKey_COUNT

    ctypedef enum ImGuiKeyModFlags_:
        ImGuiKeyModFlags_None       
        ImGuiKeyModFlags_Ctrl       
        ImGuiKeyModFlags_Shift      
        ImGuiKeyModFlags_Alt        
        ImGuiKeyModFlags_Super      


    ctypedef enum ImGuiNavInput_:       
        # Gamepad Mapping
        ImGuiNavInput_Activate,      # activate / open / toggle / tweak value       # e.g. Cross  (PS4), A (Xbox), A (Switch), Space (Keyboard)
        ImGuiNavInput_Cancel,        # cancel / close / exit                        # e.g. Circle (PS4), B (Xbox), B (Switch), Escape (Keyboard)
        ImGuiNavInput_Input,         # text input / on-screen keyboard              # e.g. Triang.(PS4), Y (Xbox), X (Switch), Return (Keyboard)
        ImGuiNavInput_Menu,          # tap: toggle menu / hold: focus, move, resize # e.g. Square (PS4), X (Xbox), Y (Switch), Alt (Keyboard)
        ImGuiNavInput_DpadLeft,      # move / tweak / resize window (w/ PadMenu)    # e.g. D-pad Left/Right/Up/Down (Gamepads), Arrow keys (Keyboard)
        ImGuiNavInput_DpadRight,     #
        ImGuiNavInput_DpadUp,        #
        ImGuiNavInput_DpadDown,      #
        ImGuiNavInput_LStickLeft,    # scroll / move window (w/ PadMenu)            # e.g. Left Analog Stick Left/Right/Up/Down
        ImGuiNavInput_LStickRight,   #
        ImGuiNavInput_LStickUp,      #
        ImGuiNavInput_LStickDown,    #
        ImGuiNavInput_FocusPrev,     # next window (w/ PadMenu)                     # e.g. L1 or L2 (PS4), LB or LT (Xbox), L or ZL (Switch)
        ImGuiNavInput_FocusNext,     # prev window (w/ PadMenu)                     # e.g. R1 or R2 (PS4), RB or RT (Xbox), R or ZL (Switch)
        ImGuiNavInput_TweakSlow,     # slower tweaks                                # e.g. L1 or L2 (PS4), LB or LT (Xbox), L or ZL (Switch)
        ImGuiNavInput_TweakFast,     # faster tweaks                                # e.g. R1 or R2 (PS4), RB or RT (Xbox), R or ZL (Switch)
        ImGuiNavInput_COUNT

    ctypedef enum ImGuiConfigFlags_:
        ImGuiConfigFlags_None                   #
        ImGuiConfigFlags_NavEnableKeyboard      # Master keyboard navigation enable flag. NewFrame() will automatically fill io.NavInputs[] based on io.KeysDown[].
        ImGuiConfigFlags_NavEnableGamepad       # Master gamepad navigation enable flag. This is mostly to instruct your imgui backend to fill io.NavInputs[]. Backend also needs to set ImGuiBackendFlags_HasGamepad.
        ImGuiConfigFlags_NavEnableSetMousePos   # Instruct navigation to move the mouse cursor. May be useful on TV/console systems where moving a virtual mouse is awkward. Will update io.MousePos and set io.WantSetMousePos=true. If enabled you MUST honor io.WantSetMousePos requests in your backend, otherwise ImGui will react as if the mouse is jumping around back and forth.
        ImGuiConfigFlags_NavNoCaptureKeyboard   # Instruct navigation to not set the io.WantCaptureKeyboard flag when io.NavActive is set.
        ImGuiConfigFlags_NoMouse                # Instruct imgui to clear mouse position/buttons in NewFrame(). This allows ignoring the mouse information set by the backend.
        ImGuiConfigFlags_NoMouseCursorChange    # Instruct backend to not alter mouse cursor shape and visibility. Use if the backend cursor changes are interfering with yours and you don't want to use SetMouseCursor() to change mouse cursor. You may want to honor requests from imgui by reading GetMouseCursor() yourself instead.

        # User storage (to allow your backend/engine to communicate to code that may be shared between multiple projects. Those flags are not used by core Dear ImGui)
        ImGuiConfigFlags_IsSRGB                 # Application is SRGB-aware.
        ImGuiConfigFlags_IsTouchScreen          # Application is using a touch screen instead of a mouse.

    
    ctypedef enum ImGuiBackendFlags_:
        ImGuiBackendFlags_None                  #
        ImGuiBackendFlags_HasGamepad            # Backend Platform supports gamepad and currently has one connected.
        ImGuiBackendFlags_HasMouseCursors       # Backend Platform supports honoring GetMouseCursor() value to change the OS cursor shape.
        ImGuiBackendFlags_HasSetMousePos        # Backend Platform supports io.WantSetMousePos requests to reposition the OS mouse position (only used if ImGuiConfigFlags_NavEnableSetMousePos is set).
        ImGuiBackendFlags_RendererHasVtxOffset  # Backend Renderer supports ImDrawCmd::VtxOffset. This enables output of large meshes (64K+ vertices) while still using 16-bit indices.


    ctypedef enum ImGuiCol_:
        ImGuiCol_Text,
        ImGuiCol_TextDisabled,
        ImGuiCol_WindowBg,              # Background of normal windows
        ImGuiCol_ChildBg,               # Background of child windows
        ImGuiCol_PopupBg,               # Background of popups, menus, tooltips windows
        ImGuiCol_Border,
        ImGuiCol_BorderShadow,
        ImGuiCol_FrameBg,               # Background of checkbox, radio button, plot, slider, text input
        ImGuiCol_FrameBgHovered,
        ImGuiCol_FrameBgActive,
        ImGuiCol_TitleBg,
        ImGuiCol_TitleBgActive,
        ImGuiCol_TitleBgCollapsed,
        ImGuiCol_MenuBarBg,
        ImGuiCol_ScrollbarBg,
        ImGuiCol_ScrollbarGrab,
        ImGuiCol_ScrollbarGrabHovered,
        ImGuiCol_ScrollbarGrabActive,
        ImGuiCol_CheckMark,
        ImGuiCol_SliderGrab,
        ImGuiCol_SliderGrabActive,
        ImGuiCol_Button,
        ImGuiCol_ButtonHovered,
        ImGuiCol_ButtonActive,
        ImGuiCol_Header,                # Header* colors are used for CollapsingHeader, TreeNode, Selectable, MenuItem
        ImGuiCol_HeaderHovered,
        ImGuiCol_HeaderActive,
        ImGuiCol_Separator,
        ImGuiCol_SeparatorHovered,
        ImGuiCol_SeparatorActive,
        ImGuiCol_ResizeGrip,
        ImGuiCol_ResizeGripHovered,
        ImGuiCol_ResizeGripActive,
        ImGuiCol_Tab,
        ImGuiCol_TabHovered,
        ImGuiCol_TabActive,
        ImGuiCol_TabUnfocused,
        ImGuiCol_TabUnfocusedActive,
        ImGuiCol_PlotLines,
        ImGuiCol_PlotLinesHovered,
        ImGuiCol_PlotHistogram,
        ImGuiCol_PlotHistogramHovered,
        ImGuiCol_TableHeaderBg,         # Table header background
        ImGuiCol_TableBorderStrong,     # Table outer and header borders (prefer using Alpha=1.0 here)
        ImGuiCol_TableBorderLight,      # Table inner borders (prefer using Alpha=1.0 here)
        ImGuiCol_TableRowBg,            # Table row background (even rows)
        ImGuiCol_TableRowBgAlt,         # Table row background (odd rows)
        ImGuiCol_TextSelectedBg,
        ImGuiCol_DragDropTarget,
        ImGuiCol_NavHighlight,          # Gamepad/keyboard: current highlighted item
        ImGuiCol_NavWindowingHighlight, # Highlight window when using CTRL+TAB
        ImGuiCol_NavWindowingDimBg,     # Darken/colorize entire screen behind the CTRL+TAB window list, when active
        ImGuiCol_ModalWindowDimBg,      # Darken/colorize entire screen behind a modal window, when one is active
        ImGuiCol_COUNT


    ctypedef enum ImGuiDataType_:
        ImGuiDataType_S8        # signed char / char (with sensible compilers)
        ImGuiDataType_U8        # unsigned char
        ImGuiDataType_S16       # short
        ImGuiDataType_U16       # unsigned short
        ImGuiDataType_S32       # int
        ImGuiDataType_U32       # unsigned int
        ImGuiDataType_S64       # long long / __int64
        ImGuiDataType_U64       # unsigned long long / unsigned __int64
        ImGuiDataType_Float     # float
        ImGuiDataType_Double    # double
        ImGuiDataType_COUNT


    ctypedef enum ImGuiStyleVar_:
        ImGuiStyleVar_Alpha,               # float     Alpha
        ImGuiStyleVar_WindowPadding,       # ImVec2    WindowPadding
        ImGuiStyleVar_WindowRounding,      # float     WindowRounding
        ImGuiStyleVar_WindowBorderSize,    # float     WindowBorderSize
        ImGuiStyleVar_WindowMinSize,       # ImVec2    WindowMinSize
        ImGuiStyleVar_WindowTitleAlign,    # ImVec2    WindowTitleAlign
        ImGuiStyleVar_ChildRounding,       # float     ChildRounding
        ImGuiStyleVar_ChildBorderSize,     # float     ChildBorderSize
        ImGuiStyleVar_PopupRounding,       # float     PopupRounding
        ImGuiStyleVar_PopupBorderSize,     # float     PopupBorderSize
        ImGuiStyleVar_FramePadding,        # ImVec2    FramePadding
        ImGuiStyleVar_FrameRounding,       # float     FrameRounding
        ImGuiStyleVar_FrameBorderSize,     # float     FrameBorderSize
        ImGuiStyleVar_ItemSpacing,         # ImVec2    ItemSpacing
        ImGuiStyleVar_ItemInnerSpacing,    # ImVec2    ItemInnerSpacing
        ImGuiStyleVar_IndentSpacing,       # float     IndentSpacing
        ImGuiStyleVar_CellPadding,         # ImVec2    CellPadding
        ImGuiStyleVar_ScrollbarSize,       # float     ScrollbarSize
        ImGuiStyleVar_ScrollbarRounding,   # float     ScrollbarRounding
        ImGuiStyleVar_GrabMinSize,         # float     GrabMinSize
        ImGuiStyleVar_GrabRounding,        # float     GrabRounding
        ImGuiStyleVar_TabRounding,         # float     TabRounding
        ImGuiStyleVar_ButtonTextAlign,     # ImVec2    ButtonTextAlign
        ImGuiStyleVar_SelectableTextAlign, # ImVec2    SelectableTextAlign
        ImGuiStyleVar_COUNT
    
    ctypedef enum ImGuiButtonFlags_:
        ImGuiButtonFlags_None                   #
        ImGuiButtonFlags_MouseButtonLeft        # React on left mouse button (default)
        ImGuiButtonFlags_MouseButtonRight       # React on right mouse button
        ImGuiButtonFlags_MouseButtonMiddle      # React on center mouse button

    ctypedef enum ImGuiCond_:
        ImGuiCond_None          # No condition (always set the variable), same as _Always
        ImGuiCond_Always        # No condition (always set the variable)
        ImGuiCond_Once          # Set the variable once per runtime session (only the first call will succeed)
        ImGuiCond_FirstUseEver  # Set the variable if the object/window has no persistently saved data (no entry in .ini file)
        ImGuiCond_Appearing     # Set the variable if the object/window is appearing after being hidden/inactive (or the first time)

    ctypedef enum ImGuiWindowFlags_:
        ImGuiWindowFlags_None                   
        ImGuiWindowFlags_NoTitleBar              # Disable title-bar
        ImGuiWindowFlags_NoResize                # Disable user resizing with the lower-right grip
        ImGuiWindowFlags_NoMove                  # Disable user moving the window
        ImGuiWindowFlags_NoScrollbar             # Disable scrollbars (window can still scroll with mouse or programmatically)
        ImGuiWindowFlags_NoScrollWithMouse       # Disable user vertically scrolling with mouse wheel. On child window, mouse wheel will be forwarded to the parent unless NoScrollbar is also set.
        ImGuiWindowFlags_NoCollapse              # Disable user collapsing window by double-clicking on it
        ImGuiWindowFlags_AlwaysAutoResize        # Resize every window to its content every frame
        ImGuiWindowFlags_NoBackground            # Disable drawing background color (WindowBg, etc.) and outside border. Similar as using SetNextWindowBgAlpha(0.0f).
        ImGuiWindowFlags_NoSavedSettings         # Never load/save settings in .ini file
        ImGuiWindowFlags_NoMouseInputs           # Disable catching mouse, hovering test with pass through.
        ImGuiWindowFlags_MenuBar                 # Has a menu-bar
        ImGuiWindowFlags_HorizontalScrollbar     # Allow horizontal scrollbar to appear (off by default). You may use SetNextWindowContentSize(ImVec2(width,0.0f)); prior to calling Begin() to specify width. Read code in imgui_demo in the "Horizontal Scrolling" section.
        ImGuiWindowFlags_NoFocusOnAppearing      # Disable taking focus when transitioning from hidden to visible state
        ImGuiWindowFlags_NoBringToFrontOnFocus   # Disable bringing window to front when taking focus (e.g. clicking on it or programmatically giving it focus)
        ImGuiWindowFlags_AlwaysVerticalScrollbar # Always show vertical scrollbar (even if ContentSize.y < Size.y)
        ImGuiWindowFlags_AlwaysHorizontalScrollbar=1 # Always show horizontal scrollbar (even if ContentSize.x < Size.x)
        ImGuiWindowFlags_AlwaysUseWindowPadding  # Ensure child windows without border uses style.WindowPadding (ignored by default for non-bordered child windows, because more convenient)
        ImGuiWindowFlags_NoNavInputs             # No gamepad/keyboard navigation within the window
        ImGuiWindowFlags_NoNavFocus              # No focusing toward this window with gamepad/keyboard navigation (e.g. skipped by CTRL+TAB)
        ImGuiWindowFlags_UnsavedDocument         # Append '*' to title without affecting the ID, as a convenience to avoid using the ### operator. When used in a tab/docking context, tab is selected on closure and closure is deferred by one frame to allow code to cancel the closure (with a confirmation popup, etc.) without flicker.
        ImGuiWindowFlags_NoNav                  = ImGuiWindowFlags_NoNavInputs | ImGuiWindowFlags_NoNavFocus,
        ImGuiWindowFlags_NoDecoration           = ImGuiWindowFlags_NoTitleBar | ImGuiWindowFlags_NoResize | ImGuiWindowFlags_NoScrollbar | ImGuiWindowFlags_NoCollapse,
        ImGuiWindowFlags_NoInputs               = ImGuiWindowFlags_NoMouseInputs | ImGuiWindowFlags_NoNavInputs | ImGuiWindowFlags_NoNavFocus,

        
    ctypedef enum ImGuiColorEditFlags_:
        ImGuiColorEditFlags_None            #
        ImGuiColorEditFlags_NoAlpha         #              # ColorEdit, ColorPicker, ColorButton: ignore Alpha component (will only read 3 components from the input pointer).
        ImGuiColorEditFlags_NoPicker        #              # ColorEdit: disable picker when clicking on color square.
        ImGuiColorEditFlags_NoOptions       #              # ColorEdit: disable toggling options menu when right-clicking on inputs/small preview.
        ImGuiColorEditFlags_NoSmallPreview  #              # ColorEdit, ColorPicker: disable color square preview next to the inputs. (e.g. to show only the inputs)
        ImGuiColorEditFlags_NoInputs        #              # ColorEdit, ColorPicker: disable inputs sliders/text widgets (e.g. to show only the small preview color square).
        ImGuiColorEditFlags_NoTooltip       #              # ColorEdit, ColorPicker, ColorButton: disable tooltip when hovering the preview.
        ImGuiColorEditFlags_NoLabel         #              # ColorEdit, ColorPicker: disable display of inline text label (the label is still forwarded to the tooltip and picker).
        ImGuiColorEditFlags_NoSidePreview   #              # ColorPicker: disable bigger color preview on right side of the picker, use small color square preview instead.
        ImGuiColorEditFlags_NoDragDrop      #              # ColorEdit: disable drag and drop target. ColorButton: disable drag and drop source.
        ImGuiColorEditFlags_NoBorder        #              # ColorButton: disable border (which is enforced by default)

        # User Options (right-click on widget to change some of them).
        ImGuiColorEditFlags_AlphaBar        #              # ColorEdit, ColorPicker: show vertical alpha bar/gradient in picker.
        ImGuiColorEditFlags_AlphaPreview    #              # ColorEdit, ColorPicker, ColorButton: display preview as a transparent color over a checkerboard, instead of opaque.
        ImGuiColorEditFlags_AlphaPreviewHalf#              # ColorEdit, ColorPicker, ColorButton: display half opaque / half checkerboard, instead of opaque.
        ImGuiColorEditFlags_HDR             #              # (WIP) ColorEdit: Currently only disable 0.0f..1.0f limits in RGBA edition (note: you probably want to use ImGuiColorEditFlags_Float flag as well).
        ImGuiColorEditFlags_DisplayRGB      # [Display]    # ColorEdit: override _display_ type among RGB/HSV/Hex. ColorPicker: select any combination using one or more of RGB/HSV/Hex.
        ImGuiColorEditFlags_DisplayHSV      # [Display]    # "
        ImGuiColorEditFlags_DisplayHex      # [Display]    # "
        ImGuiColorEditFlags_Uint8           # [DataType]   # ColorEdit, ColorPicker, ColorButton: _display_ values formatted as 0..255.
        ImGuiColorEditFlags_Float           # [DataType]   # ColorEdit, ColorPicker, ColorButton: _display_ values formatted as 0.0f..1.0f floats instead of 0..255 integers. No round-trip of value via integers.
        ImGuiColorEditFlags_PickerHueBar    # [Picker]     # ColorPicker: bar for Hue, rectangle for Sat/Value.
        ImGuiColorEditFlags_PickerHueWheel  # [Picker]     # ColorPicker: wheel for Hue, triangle for Sat/Value.
        ImGuiColorEditFlags_InputRGB        # [Input]      # ColorEdit, ColorPicker: input and output data in RGB format.
        ImGuiColorEditFlags_InputHSV        # [Input]      # ColorEdit, ColorPicker: input and output data in HSV format.

        # Defaults Options. You can set application defaults using SetColorEditOptions(). The intent is that you probably don't want to
        # override them in most of your calls. Let the user choose via the option menu and/or call SetColorEditOptions() once during startup.
        ImGuiColorEditFlags__OptionsDefault = ImGuiColorEditFlags_Uint8 | ImGuiColorEditFlags_DisplayRGB | ImGuiColorEditFlags_InputRGB | ImGuiColorEditFlags_PickerHueBar,


    ctypedef enum ImGuiSliderFlags_:
        ImGuiSliderFlags_None                   #
        ImGuiSliderFlags_AlwaysClamp            # Clamp value to min/max bounds when input manually with CTRL+Click. By default CTRL+Click allows going out of bounds.
        ImGuiSliderFlags_Logarithmic            # Make the widget logarithmic (linear otherwise). Consider using ImGuiSliderFlags_NoRoundToFormat with this if using a format-string with small amount of digits.
        ImGuiSliderFlags_NoRoundToFormat        # Disable rounding underlying value to match precision of the display format string (e.g. %.3f values are rounded to those 3 digits)
        ImGuiSliderFlags_NoInput                # Disable CTRL+Click or Enter key allowing to input text directly into the widget
        
        
    ctypedef enum ImGuiMouseButton_:
        ImGuiMouseButton_Left 
        ImGuiMouseButton_Right 
        ImGuiMouseButton_Middle
        ImGuiMouseButton_COUNT 


    ctypedef enum ImGuiTreeNodeFlags_:
        ImGuiTreeNodeFlags_None                 
        ImGuiTreeNodeFlags_Selected             # Draw as selected
        ImGuiTreeNodeFlags_Framed               # Draw frame with background (e.g. for CollapsingHeader)
        ImGuiTreeNodeFlags_AllowItemOverlap     # Hit testing to allow subsequent widgets to overlap this one
        ImGuiTreeNodeFlags_NoTreePushOnOpen     # Don't do a TreePush() when open (e.g. for CollapsingHeader) = no extra indent nor pushing on ID stack
        ImGuiTreeNodeFlags_NoAutoOpenOnLog      # Don't automatically and temporarily open node when Logging is active (by default logging will automatically open tree nodes)
        ImGuiTreeNodeFlags_DefaultOpen          # Default node to be open
        ImGuiTreeNodeFlags_OpenOnDoubleClick    # Need double-click to open node
        ImGuiTreeNodeFlags_OpenOnArrow          # Only open when clicking on the arrow part. If ImGuiTreeNodeFlags_OpenOnDoubleClick is also set, single-click arrow or double-click all box to open.
        ImGuiTreeNodeFlags_Leaf                 # No collapsing, no arrow (use as a convenience for leaf nodes).
        ImGuiTreeNodeFlags_Bullet               # Display a bullet instead of arrow
        ImGuiTreeNodeFlags_FramePadding         # Use FramePadding (even for an unframed text node) to vertically align text baseline to regular widget height. Equivalent to calling AlignTextToFramePadding().
        ImGuiTreeNodeFlags_SpanAvailWidth       # Extend hit box to the right-most edge, even if not framed. This is not the default in order to allow adding other items on the same line. In the future we may refactor the hit system to be front-to-back, allowing natural overlaps and then this can become the default.
        ImGuiTreeNodeFlags_SpanFullWidth        # Extend hit box to the left-most and right-most edges (bypass the indented area).
        ImGuiTreeNodeFlags_NavLeftJumpsBackHere # (WIP) Nav: left direction may move to this TreeNode() from any of its child (items submitted between TreeNode and TreePop)
        # ImGuiTreeNodeFlags_NoScrollOnOpen     # FIXME: TODO: Disable automatic scroll on TreePop() if node got just open and contents is not visible
        ImGuiTreeNodeFlags_CollapsingHeader     = ImGuiTreeNodeFlags_Framed | ImGuiTreeNodeFlags_NoTreePushOnOpen | ImGuiTreeNodeFlags_NoAutoOpenOnLog

        
    ctypedef enum ImGuiPopupFlags_:    
        ImGuiPopupFlags_None                    #
        ImGuiPopupFlags_MouseButtonLeft         # For BeginPopupContext*(): open on Left Mouse release. Guaranteed to always be == 0 (same as ImGuiMouseButton_Left)
        ImGuiPopupFlags_MouseButtonRight        # For BeginPopupContext*(): open on Right Mouse release. Guaranteed to always be == 1 (same as ImGuiMouseButton_Right)
        ImGuiPopupFlags_MouseButtonMiddle       # For BeginPopupContext*(): open on Middle Mouse release. Guaranteed to always be == 2 (same as ImGuiMouseButton_Middle)
        ImGuiPopupFlags_MouseButtonMask_        #
        ImGuiPopupFlags_MouseButtonDefault_     #
        ImGuiPopupFlags_NoOpenOverExistingPopup # For OpenPopup*(), BeginPopupContext*(): don't open if there's already a popup at the same level of the popup stack
        ImGuiPopupFlags_NoOpenOverItems         # For BeginPopupContextWindow(): don't return true when hovering items, only when hovering empty space
        ImGuiPopupFlags_AnyPopupId              # For IsPopupOpen(): ignore the ImGuiID parameter and test for any popup.
        ImGuiPopupFlags_AnyPopupLevel           # For IsPopupOpen(): search/test at any level of the popup stack (default test in the current level)
        ImGuiPopupFlags_AnyPopup                = ImGuiPopupFlags_AnyPopupId | ImGuiPopupFlags_AnyPopupLevel

    
    ctypedef enum ImGuiSelectableFlags_:
        ImGuiSelectableFlags_None               
        ImGuiSelectableFlags_DontClosePopups    # Clicking this don't close parent popup window
        ImGuiSelectableFlags_SpanAllColumns     # Selectable frame can span all columns (text will still fit in current column)
        ImGuiSelectableFlags_AllowDoubleClick   # Generate press events on double clicks too
        ImGuiSelectableFlags_Disabled           # Cannot be selected, display grayed out text
        ImGuiSelectableFlags_AllowItemOverlap   # (WIP) Hit testing to allow subsequent widgets to overlap this one


    ctypedef enum ImGuiComboFlags_:
        ImGuiComboFlags_None                    
        ImGuiComboFlags_PopupAlignLeft          # Align the popup toward the left by default
        ImGuiComboFlags_HeightSmall             # Max ~4 items visible. Tip: If you want your combo popup to be a specific size you can use SetNextWindowSizeConstraints() prior to calling BeginCombo()
        ImGuiComboFlags_HeightRegular           # Max ~8 items visible (default)
        ImGuiComboFlags_HeightLarge             # Max ~20 items visible
        ImGuiComboFlags_HeightLargest           # As many fitting items as possible
        ImGuiComboFlags_NoArrowButton           # Display on the preview box without the square arrow button
        ImGuiComboFlags_NoPreview               # Display only a square arrow button
        ImGuiComboFlags_HeightMask_             = ImGuiComboFlags_HeightSmall | ImGuiComboFlags_HeightRegular | ImGuiComboFlags_HeightLarge | ImGuiComboFlags_HeightLargest

    
    ctypedef enum ImGuiTabBarFlags_:
        ImGuiTabBarFlags_None                           #
        ImGuiTabBarFlags_Reorderable                    # Allow manually dragging tabs to re-order them + New tabs are appended at the end of list
        ImGuiTabBarFlags_AutoSelectNewTabs              # Automatically select new tabs when they appear
        ImGuiTabBarFlags_TabListPopupButton             # Disable buttons to open the tab list popup
        ImGuiTabBarFlags_NoCloseWithMiddleMouseButton   # Disable behavior of closing tabs (that are submitted with p_open != NULL) with middle mouse button. You can still repro this behavior on user's side with if (IsItemHovered() && IsMouseClicked(2)) *p_open = false.
        ImGuiTabBarFlags_NoTabListScrollingButtons      # Disable scrolling buttons (apply when fitting policy is ImGuiTabBarFlags_FittingPolicyScroll)
        ImGuiTabBarFlags_NoTooltip                      # Disable tooltips when hovering a tab
        ImGuiTabBarFlags_FittingPolicyResizeDown        # Resize tabs when they don't fit
        ImGuiTabBarFlags_FittingPolicyScroll            # Add scroll buttons when tabs don't fit
        ImGuiTabBarFlags_FittingPolicyMask_             = ImGuiTabBarFlags_FittingPolicyResizeDown | ImGuiTabBarFlags_FittingPolicyScroll
        ImGuiTabBarFlags_FittingPolicyDefault_          = ImGuiTabBarFlags_FittingPolicyResizeDown

        
    ctypedef enum ImGuiTabItemFlags_:
        ImGuiTabItemFlags_None                          #
        ImGuiTabItemFlags_UnsavedDocument               # Append '*' to title without affecting the ID, as a convenience to avoid using the ### operator. Also: tab is selected on closure and closure is deferred by one frame to allow code to undo it without flicker.
        ImGuiTabItemFlags_SetSelected                   # Trigger flag to programmatically make the tab selected when calling BeginTabItem()
        ImGuiTabItemFlags_NoCloseWithMiddleMouseButton  # Disable behavior of closing tabs (that are submitted with p_open != NULL) with middle mouse button. You can still repro this behavior on user's side with if (IsItemHovered() && IsMouseClicked(2)) *p_open = false.
        ImGuiTabItemFlags_NoPushId                      # Don't call PushID(tab->ID)/PopID() on BeginTabItem()/EndTabItem()
        ImGuiTabItemFlags_NoTooltip                     # Disable tooltip for the given tab
        ImGuiTabItemFlags_NoReorder                     # Disable reordering this tab or having another tab cross over this tab
        ImGuiTabItemFlags_Leading                       # Enforce the tab position to the left of the tab bar (after the tab list popup button)
        ImGuiTabItemFlags_Trailing                      # Enforce the tab position to the right of the tab bar (before the scrolling buttons)
    
    # [BETA API] API may evolve slightly!
    ctypedef enum ImGuiTableFlags_:
        # Features
        ImGuiTableFlags_None                       #
        ImGuiTableFlags_Resizable                  # Enable resizing columns.
        ImGuiTableFlags_Reorderable                # Enable reordering columns in header row (need calling TableSetupColumn() + TableHeadersRow() to display headers)
        ImGuiTableFlags_Hideable                   # Enable hiding/disabling columns in context menu.
        ImGuiTableFlags_Sortable                   # Enable sorting. Call TableGetSortSpecs() to obtain sort specs. Also see ImGuiTableFlags_SortMulti and ImGuiTableFlags_SortTristate.
        ImGuiTableFlags_NoSavedSettings            # Disable persisting columns order, width and sort settings in the .ini file.
        ImGuiTableFlags_ContextMenuInBody          # Right-click on columns body/contents will display table context menu. By default it is available in TableHeadersRow().
        # Decorations
        ImGuiTableFlags_RowBg                      # Set each RowBg color with ImGuiCol_TableRowBg or ImGuiCol_TableRowBgAlt (equivalent of calling TableSetBgColor with ImGuiTableBgFlags_RowBg0 on each row manually)
        ImGuiTableFlags_BordersInnerH              # Draw horizontal borders between rows.
        ImGuiTableFlags_BordersOuterH              # Draw horizontal borders at the top and bottom.
        ImGuiTableFlags_BordersInnerV              # Draw vertical borders between columns.
        ImGuiTableFlags_BordersOuterV              # Draw vertical borders on the left and right sides.
        ImGuiTableFlags_BordersH                   = ImGuiTableFlags_BordersInnerH | ImGuiTableFlags_BordersOuterH  # Draw horizontal borders.
        ImGuiTableFlags_BordersV                   = ImGuiTableFlags_BordersInnerV | ImGuiTableFlags_BordersOuterV  # Draw vertical borders.
        ImGuiTableFlags_BordersInner               = ImGuiTableFlags_BordersInnerV | ImGuiTableFlags_BordersInnerH  # Draw inner borders.
        ImGuiTableFlags_BordersOuter               = ImGuiTableFlags_BordersOuterV | ImGuiTableFlags_BordersOuterH  # Draw outer borders.
        ImGuiTableFlags_Borders                    = ImGuiTableFlags_BordersInner | ImGuiTableFlags_BordersOuter    # Draw all borders.
        ImGuiTableFlags_NoBordersInBody            # [ALPHA] Disable vertical borders in columns Body (borders will always appears in Headers). -> May move to style
        ImGuiTableFlags_NoBordersInBodyUntilResize # [ALPHA] Disable vertical borders in columns Body until hovered for resize (borders will always appears in Headers). -> May move to style
        # Sizing Policy (read above for defaults)
        ImGuiTableFlags_SizingFixedFit             # Columns default to _WidthFixed or _WidthAuto (if resizable or not resizable), matching contents width.
        ImGuiTableFlags_SizingFixedSame            # Columns default to _WidthFixed or _WidthAuto (if resizable or not resizable), matching the maximum contents width of all columns. Implicitly enable ImGuiTableFlags_NoKeepColumnsVisible.
        ImGuiTableFlags_SizingStretchProp          # Columns default to _WidthStretch with default weights proportional to each columns contents widths.
        ImGuiTableFlags_SizingStretchSame          # Columns default to _WidthStretch with default weights all equal, unless overriden by TableSetupColumn().
        # Sizing Extra Options
        ImGuiTableFlags_NoHostExtendX              # Make outer width auto-fit to columns, overriding outer_size.x value. Only available when ScrollX/ScrollY are disabled and Stretch columns are not used.
        ImGuiTableFlags_NoHostExtendY              # Make outer height stop exactly at outer_size.y (prevent auto-extending table past the limit). Only available when ScrollX/ScrollY are disabled. Data below the limit will be clipped and not visible.
        ImGuiTableFlags_NoKeepColumnsVisible       # Disable keeping column always minimally visible when ScrollX is off and table gets too small. Not recommended if columns are resizable.
        ImGuiTableFlags_PreciseWidths              # Disable distributing remainder width to stretched columns (width allocation on a 100-wide table with 3 columns: Without this flag: 33,33,34. With this flag: 33,33,33). With larger number of columns, resizing will appear to be less smooth.
        # Clipping
        ImGuiTableFlags_NoClip                     # Disable clipping rectangle for every individual columns (reduce draw command count, items will be able to overflow into other columns). Generally incompatible with TableSetupScrollFreeze().
        # Padding
        ImGuiTableFlags_PadOuterX                  # Default if BordersOuterV is on. Enable outer-most padding. Generally desirable if you have headers.
        ImGuiTableFlags_NoPadOuterX                # Default if BordersOuterV is off. Disable outer-most padding.
        ImGuiTableFlags_NoPadInnerX                # Disable inner padding between columns (double inner padding if BordersOuterV is on, single inner padding if BordersOuterV is off).
        # Scrolling
        ImGuiTableFlags_ScrollX                    # Enable horizontal scrolling. Require 'outer_size' parameter of BeginTable() to specify the container size. Changes default sizing policy. Because this create a child window, ScrollY is currently generally recommended when using ScrollX.
        ImGuiTableFlags_ScrollY                    # Enable vertical scrolling. Require 'outer_size' parameter of BeginTable() to specify the container size.
        # Sorting
        ImGuiTableFlags_SortMulti                  # Hold shift when clicking headers to sort on multiple column. TableGetSortSpecs() may return specs where (SpecsCount > 1).
        ImGuiTableFlags_SortTristate               # Allow no sorting, disable default sorting. TableGetSortSpecs() may return specs where (SpecsCount == 0).
    
    ctypedef enum ImGuiTableColumnFlags_:
        # Input configuration flags
        ImGuiTableColumnFlags_None                  #
        ImGuiTableColumnFlags_DefaultHide           # Default as a hidden/disabled column.
        ImGuiTableColumnFlags_DefaultSort           # Default as a sorting column.
        ImGuiTableColumnFlags_WidthStretch          # Column will stretch. Preferable with horizontal scrolling disabled (default if table sizing policy is _SizingStretchSame or _SizingStretchProp).
        ImGuiTableColumnFlags_WidthFixed            # Column will not stretch. Preferable with horizontal scrolling enabled (default if table sizing policy is _SizingFixedFit and table is resizable).
        ImGuiTableColumnFlags_NoResize              # Disable manual resizing.
        ImGuiTableColumnFlags_NoReorder             # Disable manual reordering this column, this will also prevent other columns from crossing over this column.
        ImGuiTableColumnFlags_NoHide                # Disable ability to hide/disable this column.
        ImGuiTableColumnFlags_NoClip                # Disable clipping for this column (all NoClip columns will render in a same draw command).
        ImGuiTableColumnFlags_NoSort                # Disable ability to sort on this field (even if ImGuiTableFlags_Sortable is set on the table).
        ImGuiTableColumnFlags_NoSortAscending       # Disable ability to sort in the ascending direction.
        ImGuiTableColumnFlags_NoSortDescending      # Disable ability to sort in the descending direction.
        ImGuiTableColumnFlags_NoHeaderWidth         # Disable header text width contribution to automatic column width.
        ImGuiTableColumnFlags_PreferSortAscending   # Make the initial sort direction Ascending when first sorting on this column (default).
        ImGuiTableColumnFlags_PreferSortDescending  # Make the initial sort direction Descending when first sorting on this column.
        ImGuiTableColumnFlags_IndentEnable          # Use current Indent value when entering cell (default for column 0).
        ImGuiTableColumnFlags_IndentDisable         # Ignore current Indent value when entering cell (default for columns > 0). Indentation changes _within_ the cell will still be honored.

        # Output status flags, read-only via TableGetColumnFlags()
        ImGuiTableColumnFlags_IsEnabled             # Status: is enabled == not hidden by user/api (referred to as "Hide" in _DefaultHide and _NoHide) flags.
        ImGuiTableColumnFlags_IsVisible             # Status: is visible == is enabled AND not clipped by scrolling.
        ImGuiTableColumnFlags_IsSorted              # Status: is currently part of the sort specs
        ImGuiTableColumnFlags_IsHovered             # Status: is hovered by mouse
    
    ctypedef enum ImGuiTableRowFlags_:
        ImGuiTableRowFlags_None                         #
        ImGuiTableRowFlags_Headers                      # Identify header row (set default background color + width of its contents accounted different for auto column width)
    
    ctypedef enum ImGuiTableBgTarget_:
        ImGuiTableBgTarget_None                         #
        ImGuiTableBgTarget_RowBg0                       # Set row background color 0 (generally used for background, automatically set when ImGuiTableFlags_RowBg is used)
        ImGuiTableBgTarget_RowBg1                       # Set row background color 1 (generally used for selection marking)
        ImGuiTableBgTarget_CellBg                       # Set cell background color (top-most color)

    
    ctypedef enum ImGuiFocusedFlags_:
        ImGuiFocusedFlags_None                          #
        ImGuiFocusedFlags_ChildWindows                  # IsWindowFocused(): Return true if any children of the window is focused
        ImGuiFocusedFlags_RootWindow                    # IsWindowFocused(): Test from root window (top most parent of the current hierarchy)
        ImGuiFocusedFlags_AnyWindow                     # IsWindowFocused(): Return true if any window is focused. Important: If you are trying to tell how to dispatch your low-level inputs, do NOT use this. Use 'io.WantCaptureMouse' instead! Please read the FAQ!
        ImGuiFocusedFlags_RootAndChildWindows           = ImGuiFocusedFlags_RootWindow | ImGuiFocusedFlags_ChildWindows


    ctypedef enum ImGuiHoveredFlags_:
        ImGuiHoveredFlags_None                          # Return true if directly over the item/window, not obstructed by another window, not obstructed by an active popup or modal blocking inputs under them.
        ImGuiHoveredFlags_ChildWindows                  # IsWindowHovered() only: Return true if any children of the window is hovered
        ImGuiHoveredFlags_RootWindow                    # IsWindowHovered() only: Test from root window (top most parent of the current hierarchy)
        ImGuiHoveredFlags_AnyWindow                     # IsWindowHovered() only: Return true if any window is hovered
        ImGuiHoveredFlags_AllowWhenBlockedByPopup       # Return true even if a popup window is normally blocking access to this item/window
        # ImGuiHoveredFlags_AllowWhenBlockedByModal     # Return true even if a modal popup window is normally blocking access to this item/window. FIXME-TODO: Unavailable yet.
        ImGuiHoveredFlags_AllowWhenBlockedByActiveItem  # Return true even if an active item is blocking access to this item/window. Useful for Drag and Drop patterns.
        ImGuiHoveredFlags_AllowWhenOverlapped           # Return true even if the position is obstructed or overlapped by another window
        ImGuiHoveredFlags_AllowWhenDisabled             # Return true even if the item is disabled
        ImGuiHoveredFlags_RectOnly                      = ImGuiHoveredFlags_AllowWhenBlockedByPopup | ImGuiHoveredFlags_AllowWhenBlockedByActiveItem | ImGuiHoveredFlags_AllowWhenOverlapped,
        ImGuiHoveredFlags_RootAndChildWindows           = ImGuiHoveredFlags_RootWindow | ImGuiHoveredFlags_ChildWindows


    ctypedef enum ImGuiDragDropFlags_:
        ImGuiDragDropFlags_None                         
        #  BeginDragDropSource() flags
        ImGuiDragDropFlags_SourceNoPreviewTooltip       # By default, a successful call to BeginDragDropSource opens a tooltip so you can display a preview or description of the source contents. This flag disable this behavior.
        ImGuiDragDropFlags_SourceNoDisableHover         # By default, when dragging we clear data so that IsItemHovered() will return false, to avoid subsequent user code submitting tooltips. This flag disable this behavior so you can still call IsItemHovered() on the source item.
        ImGuiDragDropFlags_SourceNoHoldToOpenOthers     # Disable the behavior that allows to open tree nodes and collapsing header by holding over them while dragging a source item.
        ImGuiDragDropFlags_SourceAllowNullID            # Allow items such as Text(), Image() that have no unique identifier to be used as drag source, by manufacturing a temporary identifier based on their window-relative position. This is extremely unusual within the dear imgui ecosystem and so we made it explicit.
        ImGuiDragDropFlags_SourceExtern                 # External source (from outside of dear imgui), won't attempt to read current item/window info. Will always return true. Only one Extern source can be active simultaneously.
        ImGuiDragDropFlags_SourceAutoExpirePayload      # Automatically expire the payload if the source cease to be submitted (otherwise payloads are persisting while being dragged)
        #  AcceptDragDropPayload() flags                
        ImGuiDragDropFlags_AcceptBeforeDelivery         # AcceptDragDropPayload() will returns true even before the mouse button is released. You can then call IsDelivery() to test if the payload needs to be delivered.
        ImGuiDragDropFlags_AcceptNoDrawDefaultRect      # Do not draw the default highlight rectangle when hovering over target.
        ImGuiDragDropFlags_AcceptNoPreviewTooltip       # Request hiding the BeginDragDropSource tooltip from the BeginDragDropTarget site.
        ImGuiDragDropFlags_AcceptPeekOnly               = ImGuiDragDropFlags_AcceptBeforeDelivery | ImGuiDragDropFlags_AcceptNoDrawDefaultRect  # For peeking ahead and inspecting the payload before delivery.
  
    ctypedef enum ImGuiDir_:
        ImGuiDir_None   
        ImGuiDir_Left   
        ImGuiDir_Right  
        ImGuiDir_Up     
        ImGuiDir_Down   
        ImGuiDir_COUNT
    
    ctypedef enum ImGuiSortDirection_:
        ImGuiSortDirection_None         #
        ImGuiSortDirection_Ascending    # Ascending = 0->9, A->Z etc.
        ImGuiSortDirection_Descending   # Descending = 9->0, Z->A etc.

    ctypedef enum ImGuiMouseCursor_:
        ImGuiMouseCursor_None 
        ImGuiMouseCursor_Arrow 
        ImGuiMouseCursor_TextInput,         # When hovering over InputText, etc.
        ImGuiMouseCursor_ResizeAll,         # (Unused by Dear ImGui functions)
        ImGuiMouseCursor_ResizeNS,          # When hovering over an horizontal border
        ImGuiMouseCursor_ResizeEW,          # When hovering over a vertical border or a column
        ImGuiMouseCursor_ResizeNESW,        # When hovering over the bottom-left corner of a window
        ImGuiMouseCursor_ResizeNWSE,        # When hovering over the bottom-right corner of a window
        ImGuiMouseCursor_Hand,              # (Unused by Dear ImGui functions. Use for e.g. hyperlinks)
        ImGuiMouseCursor_NotAllowed,        # When hovering something with disallowed interaction. Usually a crossed circle.
        ImGuiMouseCursor_COUNT

    ctypedef enum ImGuiInputTextFlags_:
        ImGuiInputTextFlags_None                #
        ImGuiInputTextFlags_CharsDecimal        # Allow 0123456789.+-*/
        ImGuiInputTextFlags_CharsHexadecimal    # Allow 0123456789ABCDEFabcdef
        ImGuiInputTextFlags_CharsUppercase      # Turn a..z into A..Z
        ImGuiInputTextFlags_CharsNoBlank        # Filter out spaces, tabs
        ImGuiInputTextFlags_AutoSelectAll       # Select entire text when first taking mouse focus
        ImGuiInputTextFlags_EnterReturnsTrue    # Return 'true' when Enter is pressed (as opposed to every time the value was modified). Consider looking at the IsItemDeactivatedAfterEdit() function.
        ImGuiInputTextFlags_CallbackCompletion  # Callback on pressing TAB (for completion handling)
        ImGuiInputTextFlags_CallbackHistory     # Callback on pressing Up/Down arrows (for history handling)
        ImGuiInputTextFlags_CallbackAlways      # Callback on each iteration. User code may query cursor position, modify text buffer.
        ImGuiInputTextFlags_CallbackCharFilter  # Callback on character inputs to replace or discard them. Modify 'EventChar' to replace or discard, or return 1 in callback to discard.
        ImGuiInputTextFlags_AllowTabInput       # Pressing TAB input a '\t' character into the text field
        ImGuiInputTextFlags_CtrlEnterForNewLine # In multi-line mode, unfocus with Enter, add new line with Ctrl+Enter (default is opposite: unfocus with Ctrl+Enter, add line with Enter).
        ImGuiInputTextFlags_NoHorizontalScroll  # Disable following the cursor horizontally
        ImGuiInputTextFlags_AlwaysOverwrite     # Overwrite mode
        ImGuiInputTextFlags_AlwaysInsertMode    # OBSOLETED in 1.82
        ImGuiInputTextFlags_ReadOnly            # Read-only mode
        ImGuiInputTextFlags_Password            # Password mode, display all characters as '*'
        ImGuiInputTextFlags_NoUndoRedo          # Disable undo/redo. Note that input text owns the text data while active, if you want to provide your own undo/redo stack you need e.g. to call ClearActiveID().
        ImGuiInputTextFlags_CharsScientific     # Allow 0123456789.+-*/eE (Scientific notation input)
        ImGuiInputTextFlags_CallbackResize      # Callback on buffer capacity changes request (beyond 'buf_size' parameter value), allowing the string to grow. Notify when the string wants to be resized (for string types which hold a cache of their Size). You will be provided a new BufSize in the callback and NEED to honor it. (see misc/cpp/imgui_stdlib.h for an example of using this)
        ImGuiInputTextFlags_CallbackEdit        # Callback on any edit (note that InputText() already returns true on edit, the callback is useful mainly to manipulate the underlying buffer while focus is active)
        
    # OBSOLETED in 1.82 (from Mars 2021) -> use ImDrawFlags_
    ctypedef enum ImDrawCornerFlags_:
        ImDrawCornerFlags_None      #
        ImDrawCornerFlags_TopLeft   # 0x1
        ImDrawCornerFlags_TopRight  # 0x2
        ImDrawCornerFlags_BotLeft   # 0x4
        ImDrawCornerFlags_BotRight  # 0x8
        ImDrawCornerFlags_Top       = ImDrawCornerFlags_TopLeft | ImDrawCornerFlags_TopRight,   # 0x3
        ImDrawCornerFlags_Bot       = ImDrawCornerFlags_BotLeft | ImDrawCornerFlags_BotRight,   # 0xC
        ImDrawCornerFlags_Left      = ImDrawCornerFlags_TopLeft | ImDrawCornerFlags_BotLeft,    # 0x5
        ImDrawCornerFlags_Right     = ImDrawCornerFlags_TopRight | ImDrawCornerFlags_BotRight,  # 0xA
        ImDrawCornerFlags_All       # In your function calls you may use ~0 (= all bits sets) instead of ImDrawCornerFlags_All, as a convenience
    
    ctypedef enum ImDrawFlags_:
        ImDrawFlags_None                        #
        ImDrawFlags_Closed                      # PathStroke(), AddPolyline(): specify that shape should be closed (Important: this is always == 1 for legacy reason)
        ImDrawFlags_RoundCornersTopLeft         # AddRect(), AddRectFilled(), PathRect(): enable rounding top-left corner only (when rounding > 0.0f, we default to all corners). Was 0x01.
        ImDrawFlags_RoundCornersTopRight        # AddRect(), AddRectFilled(), PathRect(): enable rounding top-right corner only (when rounding > 0.0f, we default to all corners). Was 0x02.
        ImDrawFlags_RoundCornersBottomLeft      # AddRect(), AddRectFilled(), PathRect(): enable rounding bottom-left corner only (when rounding > 0.0f, we default to all corners). Was 0x04.
        ImDrawFlags_RoundCornersBottomRight     # AddRect(), AddRectFilled(), PathRect(): enable rounding bottom-right corner only (when rounding > 0.0f, we default to all corners). Wax 0x08.
        ImDrawFlags_RoundCornersNone            # AddRect(), AddRectFilled(), PathRect(): disable rounding on all corners (when rounding > 0.0f). This is NOT zero, NOT an implicit flag!
        ImDrawFlags_RoundCornersTop             = ImDrawFlags_RoundCornersTopLeft | ImDrawFlags_RoundCornersTopRight,
        ImDrawFlags_RoundCornersBottom          = ImDrawFlags_RoundCornersBottomLeft | ImDrawFlags_RoundCornersBottomRight,
        ImDrawFlags_RoundCornersLeft            = ImDrawFlags_RoundCornersBottomLeft | ImDrawFlags_RoundCornersTopLeft,
        ImDrawFlags_RoundCornersRight           = ImDrawFlags_RoundCornersBottomRight | ImDrawFlags_RoundCornersTopRight,
        ImDrawFlags_RoundCornersAll             = ImDrawFlags_RoundCornersTopLeft | ImDrawFlags_RoundCornersTopRight | ImDrawFlags_RoundCornersBottomLeft | ImDrawFlags_RoundCornersBottomRight,
        ImDrawFlags_RoundCornersDefault_        = ImDrawFlags_RoundCornersAll, # Default to ALL corners if none of the _RoundCornersXX flags are specified.
        ImDrawFlags_RoundCornersMask_           = ImDrawFlags_RoundCornersAll | ImDrawFlags_RoundCornersNone

    
    ctypedef enum ImDrawListFlags_:
        ImDrawListFlags_None                    #
        ImDrawListFlags_AntiAliasedLines        # Enable anti-aliased lines/borders (*2 the number of triangles for 1.0f wide line or lines thin enough to be drawn using textures, otherwise *3 the number of triangles)
        ImDrawListFlags_AntiAliasedLinesUseTex  # Enable anti-aliased lines/borders using textures when possible. Require backend to render with bilinear filtering.
        ImDrawListFlags_AntiAliasedFill         # Enable anti-aliased edge around filled shapes (rounded rectangles, circles).
        ImDrawListFlags_AllowVtxOffset          # Can emit 'VtxOffset > 0' to allow large meshes. Set when 'ImGuiBackendFlags_RendererHasVtxOffset' is enabled.
    
    ctypedef enum ImFontAtlasFlags_:
        ImFontAtlasFlags_None               #
        ImFontAtlasFlags_NoPowerOfTwoHeight # Don't round the height to next power of two
        ImFontAtlasFlags_NoMouseCursors     # Don't build software mouse cursors into the atlas (save a little texture memory)
        ImFontAtlasFlags_NoBakedLines       # Don't build thick line textures into the atlas (save a little texture memory). The AntiAliasedLinesUseTex features uses them, otherwise they will be rendered using polygons (more expensive for CPU/GPU).
    
    ctypedef enum ImGuiViewportFlags_:
        ImGuiViewportFlags_None                     #
        ImGuiViewportFlags_IsPlatformWindow         # Represent a Platform Window
        ImGuiViewportFlags_IsPlatformMonitor        # Represent a Platform Monitor (unused yet)
        ImGuiViewportFlags_OwnedByApp               # Platform Window: is created/managed by the application (rather than a dear imgui backend)
        