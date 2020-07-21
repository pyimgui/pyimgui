cdef extern from "imgui.h":
    ctypedef enum ImGuiKey_:
        ImGuiKey_Tab
        ImGuiKey_LeftArrow
        ImGuiKey_RightArrow
        ImGuiKey_UpArrow
        ImGuiKey_DownArrow
        ImGuiKey_PageUp
        ImGuiKey_PageDown
        ImGuiKey_Home
        ImGuiKey_End
        ImGuiKey_Insert
        ImGuiKey_Delete
        ImGuiKey_Backspace
        ImGuiKey_Space
        ImGuiKey_Enter
        ImGuiKey_Escape
        ImGuiKey_KeyPadEnter
        ImGuiKey_A            # for text edit CTRL+A: select all
        ImGuiKey_C            # for text edit CTRL+C: copy
        ImGuiKey_V            # for text edit CTRL+V: paste
        ImGuiKey_X            # for text edit CTRL+X: cut
        ImGuiKey_Y            # for text edit CTRL+Y: redo
        ImGuiKey_Z            # for text edit CTRL+Z: undo
        ImGuiKey_COUNT

    ctypedef enum ImGuiNavInput_:
        ImGuiNavInput_Activate        # activate / open / toggle / tweak value//e.g. Cross  (PS4), A (Xbox), A (Switch), Space (Keyboard)
        ImGuiNavInput_Cancel          # cancel / close / exit//e.g. Circle (PS4), B (Xbox), B (Switch), Escape (Keyboard)
        ImGuiNavInput_Input           # text input / on-screen keyboard//e.g. Triang.(PS4), Y (Xbox), X (Switch), Return (Keyboard)
        ImGuiNavInput_Menu            # tap: toggle menu / hold: focus, move, resize//e.g. Square (PS4), X (Xbox), Y (Switch), Alt (Keyboard)
        ImGuiNavInput_DpadLeft        # move / tweak / resize window (w/ PadMenu)//e.g. D-pad Left/Right/Up/Down (Gamepads), Arrow keys (Keyboard)
        ImGuiNavInput_DpadRight
        ImGuiNavInput_DpadUp
        ImGuiNavInput_DpadDown
        ImGuiNavInput_LStickLeft      # scroll / move window (w/ PadMenu)//e.g. Left Analog Stick Left/Right/Up/Down
        ImGuiNavInput_LStickRight
        ImGuiNavInput_LStickUp
        ImGuiNavInput_LStickDown
        ImGuiNavInput_FocusPrev       # next window (w/ PadMenu)//e.g. L1 or L2 (PS4), LB or LT (Xbox), L or ZL (Switch)
        ImGuiNavInput_FocusNext       # prev window (w/ PadMenu)//e.g. R1 or R2 (PS4), RB or RT (Xbox), R or ZL (Switch)
        ImGuiNavInput_TweakSlow       # slower tweaks//e.g. L1 or L2 (PS4), LB or LT (Xbox), L or ZL (Switch)
        ImGuiNavInput_TweakFast       # faster tweaks//e.g. R1 or R2 (PS4), RB or RT (Xbox), R or ZL (Switch)
        ImGuiNavInput_KeyMenu_        # toggle menu//= io.KeyAlt
        ImGuiNavInput_KeyLeft_        # move left//= Arrow keys
        ImGuiNavInput_KeyRight_       # move right
        ImGuiNavInput_KeyUp_          # move up
        ImGuiNavInput_KeyDown_        # move down
        ImGuiNavInput_COUNT
        ImGuiNavInput_InternalStart_

    ctypedef enum ImGuiConfigFlags_:
        ImGuiConfigFlags_None
        ImGuiConfigFlags_NavEnableKeyboard     # Master keyboard navigation enable flag. NewFrame() will automatically fill io.NavInputs[] based on io.KeysDown[].
        ImGuiConfigFlags_NavEnableGamepad      # Master gamepad navigation enable flag. This is mostly to instruct your imgui back-end to fill io.NavInputs[]. Back-end also needs to set ImGuiBackendFlags_HasGamepad.
        ImGuiConfigFlags_NavEnableSetMousePos  # Instruct navigation to move the mouse cursor. May be useful on TV/console systems where moving a virtual mouse is awkward. Will update io.MousePos and set io.WantSetMousePos=true. If enabled you MUST honor io.WantSetMousePos requests in your binding, otherwise ImGui will react as if the mouse is jumping around back and forth.
        ImGuiConfigFlags_NavNoCaptureKeyboard  # Instruct navigation to not set the io.WantCaptureKeyboard flag when io.NavActive is set.
        ImGuiConfigFlags_NoMouse               # Instruct imgui to clear mouse position/buttons in NewFrame(). This allows ignoring the mouse information set by the back-end.
        ImGuiConfigFlags_NoMouseCursorChange   # Instruct back-end to not alter mouse cursor shape and visibility. Use if the back-end cursor changes are interfering with yours and you don't want to use SetMouseCursor() to change mouse cursor. You may want to honor requests from imgui by reading GetMouseCursor() yourself instead.
        ImGuiConfigFlags_IsSRGB                # Application is SRGB-aware.
        ImGuiConfigFlags_IsTouchScreen         # Application is using a touch screen instead of a mouse.

    ctypedef enum ImGuiBackendFlags_:
        ImGuiBackendFlags_None
        ImGuiBackendFlags_HasGamepad            # Back-end Platform supports gamepad and currently has one connected.
        ImGuiBackendFlags_HasMouseCursors       # Back-end Platform supports honoring GetMouseCursor() value to change the OS cursor shape.
        ImGuiBackendFlags_HasSetMousePos        # Back-end Platform supports io.WantSetMousePos requests to reposition the OS mouse position (only used if ImGuiConfigFlags_NavEnableSetMousePos is set).
        ImGuiBackendFlags_RendererHasVtxOffset  # Back-end Renderer supports ImDrawCmd::VtxOffset. This enables output of large meshes (64K+ vertices) while still using 16-bit indices.

    ctypedef enum ImGuiCol_:
        ImGuiCol_Text
        ImGuiCol_TextDisabled
        ImGuiCol_WindowBg               # Background of normal windows
        ImGuiCol_ChildBg                # Background of child windows
        ImGuiCol_PopupBg                # Background of popups, menus, tooltips windows
        ImGuiCol_Border
        ImGuiCol_BorderShadow
        ImGuiCol_FrameBg                # Background of checkbox, radio button, plot, slider, text input
        ImGuiCol_FrameBgHovered
        ImGuiCol_FrameBgActive
        ImGuiCol_TitleBg
        ImGuiCol_TitleBgActive
        ImGuiCol_TitleBgCollapsed
        ImGuiCol_MenuBarBg
        ImGuiCol_ScrollbarBg
        ImGuiCol_ScrollbarGrab
        ImGuiCol_ScrollbarGrabHovered
        ImGuiCol_ScrollbarGrabActive
        ImGuiCol_CheckMark
        ImGuiCol_SliderGrab
        ImGuiCol_SliderGrabActive
        ImGuiCol_Button
        ImGuiCol_ButtonHovered
        ImGuiCol_ButtonActive
        ImGuiCol_Header                 # Header* colors are used for CollapsingHeader, TreeNode, Selectable, MenuItem
        ImGuiCol_HeaderHovered
        ImGuiCol_HeaderActive
        ImGuiCol_Separator
        ImGuiCol_SeparatorHovered
        ImGuiCol_SeparatorActive
        ImGuiCol_ResizeGrip
        ImGuiCol_ResizeGripHovered
        ImGuiCol_ResizeGripActive
        ImGuiCol_Tab
        ImGuiCol_TabHovered
        ImGuiCol_TabActive
        ImGuiCol_TabUnfocused
        ImGuiCol_TabUnfocusedActive
        ImGuiCol_PlotLines
        ImGuiCol_PlotLinesHovered
        ImGuiCol_PlotHistogram
        ImGuiCol_PlotHistogramHovered
        ImGuiCol_TextSelectedBg
        ImGuiCol_DragDropTarget
        ImGuiCol_NavHighlight           # Gamepad/keyboard: current highlighted item
        ImGuiCol_NavWindowingHighlight  # Highlight window when using CTRL+TAB
        ImGuiCol_NavWindowingDimBg      # Darken/colorize entire screen behind the CTRL+TAB window list, when active
        ImGuiCol_ModalWindowDimBg       # Darken/colorize entire screen behind a modal window, when one is active
        ImGuiCol_COUNT

    ctypedef enum ImGuiDataType_:
        ImGuiDataType_S8      # signed char / char (with sensible compilers)
        ImGuiDataType_U8      # unsigned char
        ImGuiDataType_S16     # short
        ImGuiDataType_U16     # unsigned short
        ImGuiDataType_S32     # int
        ImGuiDataType_U32     # unsigned int
        ImGuiDataType_S64     # long long / __int64
        ImGuiDataType_U64     # unsigned long long / unsigned __int64
        ImGuiDataType_Float   # float
        ImGuiDataType_Double  # double
        ImGuiDataType_COUNT

    ctypedef enum ImGuiStyleVar_:
        ImGuiStyleVar_Alpha                # float     Alpha
        ImGuiStyleVar_WindowPadding        # ImVec2    WindowPadding
        ImGuiStyleVar_WindowRounding       # float     WindowRounding
        ImGuiStyleVar_WindowBorderSize     # float     WindowBorderSize
        ImGuiStyleVar_WindowMinSize        # ImVec2    WindowMinSize
        ImGuiStyleVar_WindowTitleAlign     # ImVec2    WindowTitleAlign
        ImGuiStyleVar_ChildRounding        # float     ChildRounding
        ImGuiStyleVar_ChildBorderSize      # float     ChildBorderSize
        ImGuiStyleVar_PopupRounding        # float     PopupRounding
        ImGuiStyleVar_PopupBorderSize      # float     PopupBorderSize
        ImGuiStyleVar_FramePadding         # ImVec2    FramePadding
        ImGuiStyleVar_FrameRounding        # float     FrameRounding
        ImGuiStyleVar_FrameBorderSize      # float     FrameBorderSize
        ImGuiStyleVar_ItemSpacing          # ImVec2    ItemSpacing
        ImGuiStyleVar_ItemInnerSpacing     # ImVec2    ItemInnerSpacing
        ImGuiStyleVar_IndentSpacing        # float     IndentSpacing
        ImGuiStyleVar_ScrollbarSize        # float     ScrollbarSize
        ImGuiStyleVar_ScrollbarRounding    # float     ScrollbarRounding
        ImGuiStyleVar_GrabMinSize          # float     GrabMinSize
        ImGuiStyleVar_GrabRounding         # float     GrabRounding
        ImGuiStyleVar_TabRounding          # float     TabRounding
        ImGuiStyleVar_ButtonTextAlign      # ImVec2    ButtonTextAlign
        ImGuiStyleVar_SelectableTextAlign  # ImVec2    SelectableTextAlign
        ImGuiStyleVar_COUNT

    ctypedef enum ImGuiCond_:
        ImGuiCond_None          # No condition (always set the variable), same as _Always
        ImGuiCond_Always        # No condition (always set the variable)
        ImGuiCond_Once          # Set the variable once per runtime session (only the first call will succeed)
        ImGuiCond_FirstUseEver  # Set the variable if the object/window has no persistently saved data (no entry in .ini file)
        ImGuiCond_Appearing     # Set the variable if the object/window is appearing after being hidden/inactive (or the first time)

    ctypedef enum ImGuiWindowFlags_:
        ImGuiWindowFlags_None
        ImGuiWindowFlags_NoTitleBar                 # Disable title-bar
        ImGuiWindowFlags_NoResize                   # Disable user resizing with the lower-right grip
        ImGuiWindowFlags_NoMove                     # Disable user moving the window
        ImGuiWindowFlags_NoScrollbar                # Disable scrollbars (window can still scroll with mouse or programmatically)
        ImGuiWindowFlags_NoScrollWithMouse          # Disable user vertically scrolling with mouse wheel. On child window, mouse wheel will be forwarded to the parent unless NoScrollbar is also set.
        ImGuiWindowFlags_NoCollapse                 # Disable user collapsing window by double-clicking on it
        ImGuiWindowFlags_AlwaysAutoResize           # Resize every window to its content every frame
        ImGuiWindowFlags_NoBackground               # Disable drawing background color (WindowBg, etc.) and outside border. Similar as using SetNextWindowBgAlpha(0.0f).
        ImGuiWindowFlags_NoSavedSettings            # Never load/save settings in .ini file
        ImGuiWindowFlags_NoMouseInputs              # Disable catching mouse, hovering test with pass through.
        ImGuiWindowFlags_MenuBar                    # Has a menu-bar
        ImGuiWindowFlags_HorizontalScrollbar        # Allow horizontal scrollbar to appear (off by default). You may use SetNextWindowContentSize(ImVec2(width,0.0f)); prior to calling Begin() to specify width. Read code in imgui_demo in the "Horizontal Scrolling" section.
        ImGuiWindowFlags_NoFocusOnAppearing         # Disable taking focus when transitioning from hidden to visible state
        ImGuiWindowFlags_NoBringToFrontOnFocus      # Disable bringing window to front when taking focus (e.g. clicking on it or programmatically giving it focus)
        ImGuiWindowFlags_AlwaysVerticalScrollbar    # Always show vertical scrollbar (even if ContentSize.y < Size.y)
        ImGuiWindowFlags_AlwaysHorizontalScrollbar  # Always show horizontal scrollbar (even if ContentSize.x < Size.x)
        ImGuiWindowFlags_AlwaysUseWindowPadding     # Ensure child windows without border uses style.WindowPadding (ignored by default for non-bordered child windows, because more convenient)
        ImGuiWindowFlags_NoNavInputs                # No gamepad/keyboard navigation within the window
        ImGuiWindowFlags_NoNavFocus                 # No focusing toward this window with gamepad/keyboard navigation (e.g. skipped by CTRL+TAB)
        ImGuiWindowFlags_UnsavedDocument            # Append '*' to title without affecting the ID, as a convenience to avoid using the ### operator. When used in a tab/docking context, tab is selected on closure and closure is deferred by one frame to allow code to cancel the closure (with a confirmation popup, etc.) without flicker.
        ImGuiWindowFlags_NoNav
        ImGuiWindowFlags_NoDecoration
        ImGuiWindowFlags_NoInputs
        ImGuiWindowFlags_NavFlattened               # [BETA] Allow gamepad/keyboard navigation to cross over parent border to this child (only use on child that have no scrolling!)
        ImGuiWindowFlags_ChildWindow                # Don't use! For internal use by BeginChild()
        ImGuiWindowFlags_Tooltip                    # Don't use! For internal use by BeginTooltip()
        ImGuiWindowFlags_Popup                      # Don't use! For internal use by BeginPopup()
        ImGuiWindowFlags_Modal                      # Don't use! For internal use by BeginPopupModal()
        ImGuiWindowFlags_ChildMenu                  # Don't use! For internal use by BeginMenu()

    ctypedef enum ImGuiColorEditFlags_:
        ImGuiColorEditFlags_None
        ImGuiColorEditFlags_NoAlpha           # //ColorEdit, ColorPicker, ColorButton: ignore Alpha component (will only read 3 components from the input pointer).
        ImGuiColorEditFlags_NoPicker          # //ColorEdit: disable picker when clicking on colored square.
        ImGuiColorEditFlags_NoOptions         # //ColorEdit: disable toggling options menu when right-clicking on inputs/small preview.
        ImGuiColorEditFlags_NoSmallPreview    # //ColorEdit, ColorPicker: disable colored square preview next to the inputs. (e.g. to show only the inputs)
        ImGuiColorEditFlags_NoInputs          # //ColorEdit, ColorPicker: disable inputs sliders/text widgets (e.g. to show only the small preview colored square).
        ImGuiColorEditFlags_NoTooltip         # //ColorEdit, ColorPicker, ColorButton: disable tooltip when hovering the preview.
        ImGuiColorEditFlags_NoLabel           # //ColorEdit, ColorPicker: disable display of inline text label (the label is still forwarded to the tooltip and picker).
        ImGuiColorEditFlags_NoSidePreview     # //ColorPicker: disable bigger color preview on right side of the picker, use small colored square preview instead.
        ImGuiColorEditFlags_NoDragDrop        # //ColorEdit: disable drag and drop target. ColorButton: disable drag and drop source.
        ImGuiColorEditFlags_NoBorder          # //ColorButton: disable border (which is enforced by default)
        ImGuiColorEditFlags_AlphaBar          # //ColorEdit, ColorPicker: show vertical alpha bar/gradient in picker.
        ImGuiColorEditFlags_AlphaPreview      # //ColorEdit, ColorPicker, ColorButton: display preview as a transparent color over a checkerboard, instead of opaque.
        ImGuiColorEditFlags_AlphaPreviewHalf  # //ColorEdit, ColorPicker, ColorButton: display half opaque / half checkerboard, instead of opaque.
        ImGuiColorEditFlags_HDR               # //(WIP) ColorEdit: Currently only disable 0.0f..1.0f limits in RGBA edition (note: you probably want to use ImGuiColorEditFlags_Float flag as well).
        ImGuiColorEditFlags_DisplayRGB        # [Display]//ColorEdit: override _display_ type among RGB/HSV/Hex. ColorPicker: select any combination using one or more of RGB/HSV/Hex.
        ImGuiColorEditFlags_DisplayHSV        # [Display]//"
        ImGuiColorEditFlags_DisplayHex        # [Display]//"
        ImGuiColorEditFlags_Uint8             # [DataType]//ColorEdit, ColorPicker, ColorButton: _display_ values formatted as 0..255.
        ImGuiColorEditFlags_Float             # [DataType]//ColorEdit, ColorPicker, ColorButton: _display_ values formatted as 0.0f..1.0f floats instead of 0..255 integers. No round-trip of value via integers.
        ImGuiColorEditFlags_PickerHueBar      # [Picker]//ColorPicker: bar for Hue, rectangle for Sat/Value.
        ImGuiColorEditFlags_PickerHueWheel    # [Picker]//ColorPicker: wheel for Hue, triangle for Sat/Value.
        ImGuiColorEditFlags_InputRGB          # [Input]//ColorEdit, ColorPicker: input and output data in RGB format.
        ImGuiColorEditFlags_InputHSV          # [Input]//ColorEdit, ColorPicker: input and output data in HSV format.
        ImGuiColorEditFlags__OptionsDefault
        ImGuiColorEditFlags__DisplayMask
        ImGuiColorEditFlags__DataTypeMask
        ImGuiColorEditFlags__PickerMask
        ImGuiColorEditFlags__InputMask

    ctypedef enum ImGuiTreeNodeFlags_:
        ImGuiTreeNodeFlags_None
        ImGuiTreeNodeFlags_Selected              # Draw as selected
        ImGuiTreeNodeFlags_Framed                # Full colored frame (e.g. for CollapsingHeader)
        ImGuiTreeNodeFlags_AllowItemOverlap      # Hit testing to allow subsequent widgets to overlap this one
        ImGuiTreeNodeFlags_NoTreePushOnOpen      # Don't do a TreePush() when open (e.g. for CollapsingHeader) = no extra indent nor pushing on ID stack
        ImGuiTreeNodeFlags_NoAutoOpenOnLog       # Don't automatically and temporarily open node when Logging is active (by default logging will automatically open tree nodes)
        ImGuiTreeNodeFlags_DefaultOpen           # Default node to be open
        ImGuiTreeNodeFlags_OpenOnDoubleClick     # Need double-click to open node
        ImGuiTreeNodeFlags_OpenOnArrow           # Only open when clicking on the arrow part. If ImGuiTreeNodeFlags_OpenOnDoubleClick is also set, single-click arrow or double-click all box to open.
        ImGuiTreeNodeFlags_Leaf                  # No collapsing, no arrow (use as a convenience for leaf nodes).
        ImGuiTreeNodeFlags_Bullet                # Display a bullet instead of arrow
        ImGuiTreeNodeFlags_FramePadding          # Use FramePadding (even for an unframed text node) to vertically align text baseline to regular widget height. Equivalent to calling AlignTextToFramePadding().
        ImGuiTreeNodeFlags_SpanAvailWidth        # Extend hit box to the right-most edge, even if not framed. This is not the default in order to allow adding other items on the same line. In the future we may refactor the hit system to be front-to-back, allowing natural overlaps and then this can become the default.
        ImGuiTreeNodeFlags_SpanFullWidth         # Extend hit box to the left-most and right-most edges (bypass the indented area).
        ImGuiTreeNodeFlags_NavLeftJumpsBackHere  # (WIP) Nav: left direction may move to this TreeNode() from any of its child (items submitted between TreeNode and TreePop)
        ImGuiTreeNodeFlags_CollapsingHeader

    ctypedef enum ImGuiSelectableFlags_:
        ImGuiSelectableFlags_None
        ImGuiSelectableFlags_DontClosePopups   # Clicking this don't close parent popup window
        ImGuiSelectableFlags_SpanAllColumns    # Selectable frame can span all columns (text will still fit in current column)
        ImGuiSelectableFlags_AllowDoubleClick  # Generate press events on double clicks too
        ImGuiSelectableFlags_Disabled          # Cannot be selected, display grayed out text
        ImGuiSelectableFlags_AllowItemOverlap  # (WIP) Hit testing to allow subsequent widgets to overlap this one

    ctypedef enum ImGuiComboFlags_:
        ImGuiComboFlags_None
        ImGuiComboFlags_PopupAlignLeft  # Align the popup toward the left by default
        ImGuiComboFlags_HeightSmall     # Max ~4 items visible. Tip: If you want your combo popup to be a specific size you can use SetNextWindowSizeConstraints() prior to calling BeginCombo()
        ImGuiComboFlags_HeightRegular   # Max ~8 items visible (default)
        ImGuiComboFlags_HeightLarge     # Max ~20 items visible
        ImGuiComboFlags_HeightLargest   # As many fitting items as possible
        ImGuiComboFlags_NoArrowButton   # Display on the preview box without the square arrow button
        ImGuiComboFlags_NoPreview       # Display only a square arrow button
        ImGuiComboFlags_HeightMask_

    ctypedef enum ImGuiFocusedFlags_:
        ImGuiFocusedFlags_None
        ImGuiFocusedFlags_ChildWindows         # IsWindowFocused(): Return true if any children of the window is focused
        ImGuiFocusedFlags_RootWindow           # IsWindowFocused(): Test from root window (top most parent of the current hierarchy)
        ImGuiFocusedFlags_AnyWindow            # IsWindowFocused(): Return true if any window is focused. Important: If you are trying to tell how to dispatch your low-level inputs, do NOT use this. Use 'io.WantCaptureMouse' instead! Please read the FAQ!
        ImGuiFocusedFlags_RootAndChildWindows

    ctypedef enum ImGuiHoveredFlags_:
        ImGuiHoveredFlags_None                          # Return true if directly over the item/window, not obstructed by another window, not obstructed by an active popup or modal blocking inputs under them.
        ImGuiHoveredFlags_ChildWindows                  # IsWindowHovered() only: Return true if any children of the window is hovered
        ImGuiHoveredFlags_RootWindow                    # IsWindowHovered() only: Test from root window (top most parent of the current hierarchy)
        ImGuiHoveredFlags_AnyWindow                     # IsWindowHovered() only: Return true if any window is hovered
        ImGuiHoveredFlags_AllowWhenBlockedByPopup       # Return true even if a popup window is normally blocking access to this item/window
        ImGuiHoveredFlags_AllowWhenBlockedByActiveItem  # Return true even if an active item is blocking access to this item/window. Useful for Drag and Drop patterns.
        ImGuiHoveredFlags_AllowWhenOverlapped           # Return true even if the position is obstructed or overlapped by another window
        ImGuiHoveredFlags_AllowWhenDisabled             # Return true even if the item is disabled
        ImGuiHoveredFlags_RectOnly
        ImGuiHoveredFlags_RootAndChildWindows

    ctypedef enum ImGuiDragDropFlags_:
        ImGuiDragDropFlags_None
        ImGuiDragDropFlags_SourceNoPreviewTooltip    # By default, a successful call to BeginDragDropSource opens a tooltip so you can display a preview or description of the source contents. This flag disable this behavior.
        ImGuiDragDropFlags_SourceNoDisableHover      # By default, when dragging we clear data so that IsItemHovered() will return false, to avoid subsequent user code submitting tooltips. This flag disable this behavior so you can still call IsItemHovered() on the source item.
        ImGuiDragDropFlags_SourceNoHoldToOpenOthers  # Disable the behavior that allows to open tree nodes and collapsing header by holding over them while dragging a source item.
        ImGuiDragDropFlags_SourceAllowNullID         # Allow items such as Text(), Image() that have no unique identifier to be used as drag source, by manufacturing a temporary identifier based on their window-relative position. This is extremely unusual within the dear imgui ecosystem and so we made it explicit.
        ImGuiDragDropFlags_SourceExtern              # External source (from outside of dear imgui), won't attempt to read current item/window info. Will always return true. Only one Extern source can be active simultaneously.
        ImGuiDragDropFlags_SourceAutoExpirePayload   # Automatically expire the payload if the source cease to be submitted (otherwise payloads are persisting while being dragged)
        ImGuiDragDropFlags_AcceptBeforeDelivery      # AcceptDragDropPayload() will returns true even before the mouse button is released. You can then call IsDelivery() to test if the payload needs to be delivered.
        ImGuiDragDropFlags_AcceptNoDrawDefaultRect   # Do not draw the default highlight rectangle when hovering over target.
        ImGuiDragDropFlags_AcceptNoPreviewTooltip    # Request hiding the BeginDragDropSource tooltip from the BeginDragDropTarget site.
        ImGuiDragDropFlags_AcceptPeekOnly            # For peeking ahead and inspecting the payload before delivery.

    ctypedef enum ImGuiDir_:
        ImGuiDir_None
        ImGuiDir_Left
        ImGuiDir_Right
        ImGuiDir_Up
        ImGuiDir_Down
        ImGuiDir_COUNT

    ctypedef enum ImGuiMouseCursor_:
        ImGuiMouseCursor_None
        ImGuiMouseCursor_Arrow
        ImGuiMouseCursor_TextInput   # When hovering over InputText, etc.
        ImGuiMouseCursor_ResizeAll   # (Unused by Dear ImGui functions)
        ImGuiMouseCursor_ResizeNS    # When hovering over an horizontal border
        ImGuiMouseCursor_ResizeEW    # When hovering over a vertical border or a column
        ImGuiMouseCursor_ResizeNESW  # When hovering over the bottom-left corner of a window
        ImGuiMouseCursor_ResizeNWSE  # When hovering over the bottom-right corner of a window
        ImGuiMouseCursor_Hand        # (Unused by Dear ImGui functions. Use for e.g. hyperlinks)
        ImGuiMouseCursor_NotAllowed  # When hovering something with disallowed interaction. Usually a crossed circle.
        ImGuiMouseCursor_COUNT

    ctypedef enum ImGuiInputTextFlags_:
        ImGuiInputTextFlags_None
        ImGuiInputTextFlags_CharsDecimal         # Allow 0123456789.+-*/
        ImGuiInputTextFlags_CharsHexadecimal     # Allow 0123456789ABCDEFabcdef
        ImGuiInputTextFlags_CharsUppercase       # Turn a..z into A..Z
        ImGuiInputTextFlags_CharsNoBlank         # Filter out spaces, tabs
        ImGuiInputTextFlags_AutoSelectAll        # Select entire text when first taking mouse focus
        ImGuiInputTextFlags_EnterReturnsTrue     # Return 'true' when Enter is pressed (as opposed to every time the value was modified). Consider looking at the IsItemDeactivatedAfterEdit() function.
        ImGuiInputTextFlags_CallbackCompletion   # Callback on pressing TAB (for completion handling)
        ImGuiInputTextFlags_CallbackHistory      # Callback on pressing Up/Down arrows (for history handling)
        ImGuiInputTextFlags_CallbackAlways       # Callback on each iteration. User code may query cursor position, modify text buffer.
        ImGuiInputTextFlags_CallbackCharFilter   # Callback on character inputs to replace or discard them. Modify 'EventChar' to replace or discard, or return 1 in callback to discard.
        ImGuiInputTextFlags_AllowTabInput        # Pressing TAB input a '\t' character into the text field
        ImGuiInputTextFlags_CtrlEnterForNewLine  # In multi-line mode, unfocus with Enter, add new line with Ctrl+Enter (default is opposite: unfocus with Ctrl+Enter, add line with Enter).
        ImGuiInputTextFlags_NoHorizontalScroll   # Disable following the cursor horizontally
        ImGuiInputTextFlags_AlwaysInsertMode     # Insert mode
        ImGuiInputTextFlags_ReadOnly             # Read-only mode
        ImGuiInputTextFlags_Password             # Password mode, display all characters as '*'
        ImGuiInputTextFlags_NoUndoRedo           # Disable undo/redo. Note that input text owns the text data while active, if you want to provide your own undo/redo stack you need e.g. to call ClearActiveID().
        ImGuiInputTextFlags_CharsScientific      # Allow 0123456789.+-*/eE (Scientific notation input)
        ImGuiInputTextFlags_CallbackResize       # Callback on buffer capacity changes request (beyond 'buf_size' parameter value), allowing the string to grow. Notify when the string wants to be resized (for string types which hold a cache of their Size). You will be provided a new BufSize in the callback and NEED to honor it. (see misc/cpp/imgui_stdlib.h for an example of using this)
        ImGuiInputTextFlags_Multiline            # For internal use by InputTextMultiline()
        ImGuiInputTextFlags_NoMarkEdited         # For internal use by functions using InputText() before reformatting data
