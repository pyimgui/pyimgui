cdef extern from "imgui.h":
    ctypedef enum ImGuiKey_:
        ImGuiKey_Tab         # for tabbing through fields
        ImGuiKey_LeftArrow   # for text edit
        ImGuiKey_RightArrow  # for text edit
        ImGuiKey_UpArrow     # for text edit
        ImGuiKey_DownArrow   # for text edit
        ImGuiKey_PageUp
        ImGuiKey_PageDown
        ImGuiKey_Home        # for text edit
        ImGuiKey_End         # for text edit
        ImGuiKey_Delete      # for text edit
        ImGuiKey_Backspace   # for text edit
        ImGuiKey_Enter       # for text edit
        ImGuiKey_Escape      # for text edit
        ImGuiKey_A           # for text edit CTRL+A: select all
        ImGuiKey_C           # for text edit CTRL+C: copy
        ImGuiKey_V           # for text edit CTRL+V: paste
        ImGuiKey_X           # for text edit CTRL+X: cut
        ImGuiKey_Y           # for text edit CTRL+Y: redo
        ImGuiKey_Z           # for text edit CTRL+Z: undo
        ImGuiKey_COUNT


    ctypedef enum ImGuiCol_:
        ImGuiCol_Text
        ImGuiCol_TextDisabled
        ImGuiCol_WindowBg              # Background of normal windows
        ImGuiCol_ChildWindowBg         # Background of child windows
        ImGuiCol_PopupBg               # Background of popups, menus, tooltips windows
        ImGuiCol_Border
        ImGuiCol_BorderShadow
        ImGuiCol_FrameBg               # Background of checkbox, radio button, plot, slider, text input
        ImGuiCol_FrameBgHovered
        ImGuiCol_FrameBgActive
        ImGuiCol_TitleBg
        ImGuiCol_TitleBgCollapsed
        ImGuiCol_TitleBgActive
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
        ImGuiCol_Header
        ImGuiCol_HeaderHovered
        ImGuiCol_HeaderActive
        ImGuiCol_Column
        ImGuiCol_ColumnHovered
        ImGuiCol_ColumnActive
        ImGuiCol_ResizeGrip
        ImGuiCol_ResizeGripHovered
        ImGuiCol_ResizeGripActive
        ImGuiCol_PlotLines
        ImGuiCol_PlotLinesHovered
        ImGuiCol_PlotHistogram
        ImGuiCol_PlotHistogramHovered
        ImGuiCol_TextSelectedBg
        ImGuiCol_ModalWindowDarkening  # Darken entire screen when a modal window is active
        ImGuiCol_DragDropTarget
        ImGuiCol_NavHighlight
        ImGuiCol_NavWindowingHighlight
        ImGuiCol_COUNT

    ctypedef enum ImGuiStyleVar_:
        ImGuiStyleVar_Alpha               # float
        ImGuiStyleVar_WindowPadding       # ImVec2
        ImGuiStyleVar_WindowRounding      # float
        ImGuiStyleVar_WindowMinSize       # ImVec2
        ImGuiStyleVar_FramePadding        # ImVec2
        ImGuiStyleVar_FrameRounding       # float
        ImGuiStyleVar_ItemSpacing         # ImVec2
        ImGuiStyleVar_ItemInnerSpacing    # ImVec2
        ImGuiStyleVar_IndentSpacing       # float
        ImGuiStyleVar_ScrollbarSize       # float
        ImGuiStyleVar_ScrollbarRounding   # float
        ImGuiStyleVar_GrabMinSize         # float
        ImGuiStyleVar_GrabRounding        # float
        ImGuiStyleVar_ButtonTextAlign     # flags ImGuiAlign_*
        ImGuiStyleVar_Count_

    ctypedef enum ImGuiAlign_:
        ImGuiAlign_Left
        ImGuiAlign_Center
        ImGuiAlign_Right
        ImGuiAlign_Top
        ImGuiAlign_VCenter
        ImGuiAlign_Default

    ctypedef enum ImGuiCond_:
        ImGuiCond_Always               # Set the variable
        ImGuiCond_Once                 # Only set the variable on the first call per runtime session
        ImGuiCond_FirstUseEver         # Only set the variable if the window doesn't exist in the .ini file
        ImGuiCond_Appearing            # Only set the variable if the window is appearing after being inactive (or the first time)

    ctypedef enum ImGuiWindowFlags_:
        ImGuiWindowFlags_NoTitleBar                 # Disable title-bar
        ImGuiWindowFlags_NoResize                   # Disable user resizing with the lower-right grip
        ImGuiWindowFlags_NoMove                     # Disable user moving the window
        ImGuiWindowFlags_NoScrollbar                # Disable scrollbars (window can still scroll with mouse or programatically)
        ImGuiWindowFlags_NoScrollWithMouse          # Disable user vertically scrolling with mouse wheel
        ImGuiWindowFlags_NoCollapse                 # Disable user collapsing window by double-clicking on it
        ImGuiWindowFlags_AlwaysAutoResize           # Resize every window to its content every frame
        ImGuiWindowFlags_NoSavedSettings            # Never load/save settings in .ini file
        ImGuiWindowFlags_NoInputs                   # Disable catching mouse or keyboard inputs
        ImGuiWindowFlags_MenuBar                    # Has a menu-bar
        ImGuiWindowFlags_HorizontalScrollbar        # Allow horizontal scrollbar to appear (off by default). You may use SetNextWindowContentSize(ImVec2(width,0.0f)); prior to calling Begin() to specify width. Read code in imgui_demo in the "Horizontal Scrolling" section.
        ImGuiWindowFlags_NoFocusOnAppearing         # Disable taking focus when transitioning from hidden to visible state
        ImGuiWindowFlags_NoBringToFrontOnFocus      # Disable bringing window to front when taking focus (e.g. clicking on it or programatically giving it focus)
        ImGuiWindowFlags_AlwaysVerticalScrollbar    # Always show vertical scrollbar (even if ContentSize.y < Size.y)
        ImGuiWindowFlags_AlwaysHorizontalScrollbar  # Always show horizontal scrollbar (even if ContentSize.x < Size.x)
        ImGuiWindowFlags_AlwaysUseWindowPadding     # Ensure child windows without border uses style.WindowPadding (ignored by default for non-bordered child windows, because more convenient)

    ctypedef enum ImGuiColorEditFlags_:
        ImGuiColorEditFlags_NoAlpha
        ImGuiColorEditFlags_NoPicker               # ColorEdit: disable picker when clicking on colored square.
        ImGuiColorEditFlags_NoOptions              # ColorEdit: disable toggling options menu when right-clicking on inputs/small preview.
        ImGuiColorEditFlags_NoSmallPreview         # ColorEdit, ColorPicker: disable colored square preview next to the inputs. (e.g. to show only the inputs)
        ImGuiColorEditFlags_NoInputs               # ColorEdit, ColorPicker: disable inputs sliders/text widgets (e.g. to show only the small preview colored square).
        ImGuiColorEditFlags_NoTooltip              # ColorEdit, ColorPicker, ColorButton: disable tooltip when hovering the preview.
        ImGuiColorEditFlags_NoLabel                # ColorEdit, ColorPicker: disable display of inline text label (the label is still forwarded to the tooltip and picker).
        ImGuiColorEditFlags_NoSidePreview          # ColorPicker: disable bigger color preview on right side of the picker, use small colored square preview instead.
        # User Options (right-click on widget to change some of them). You can set application defaults using SetColorEditOptions(). The idea is that you probably don't want to override them in most of your calls, let the user choose and/or call SetColorEditOptions() during startup.
        ImGuiColorEditFlags_AlphaBar               # ColorEdit, ColorPicker: show vertical alpha bar/gradient in picker.
        ImGuiColorEditFlags_AlphaPreview           # ColorEdit, ColorPicker, ColorButton: display preview as a transparent color over a checkerboard, instead of opaque.
        ImGuiColorEditFlags_AlphaPreviewHalf       # ColorEdit, ColorPicker, ColorButton: display half opaque / half checkerboard, instead of opaque.
        ImGuiColorEditFlags_HDR                    # (WIP) ColorEdit: Currently only disable 0.0f..1.0f limits in RGBA edition (note: you probably want to use ImGuiColorEditFlags_Float flag as well).
        ImGuiColorEditFlags_RGB                    # ColorEdit: choose one among RGB/HSV/HEX. ColorPicker: choose any combination using RGB/HSV/HEX.
        ImGuiColorEditFlags_HSV                    # "
        ImGuiColorEditFlags_HEX                    # "
        ImGuiColorEditFlags_Uint8                  # ColorEdit, ColorPicker, ColorButton: _display_ values formatted as 0..255.
        ImGuiColorEditFlags_Float                  # ColorEdit, ColorPicker, ColorButton: _display_ values formatted as 0.0f..1.0f floats instead of 0..255 integers. No round-trip of value via integers.
        ImGuiColorEditFlags_PickerHueBar           # ColorPicker: bar for Hue, rectangle for Sat/Value.
        ImGuiColorEditFlags_PickerHueWheel         # ColorPicker: wheel for Hue, triangle for Sat/Value.
        # Internals/Masks
        ImGuiColorEditFlags__InputsMask     = ImGuiColorEditFlags_RGB|ImGuiColorEditFlags_HSV|ImGuiColorEditFlags_HEX
        ImGuiColorEditFlags__DataTypeMask   = ImGuiColorEditFlags_Uint8|ImGuiColorEditFlags_Float
        ImGuiColorEditFlags__PickerMask     = ImGuiColorEditFlags_PickerHueWheel|ImGuiColorEditFlags_PickerHueBar
        ImGuiColorEditFlags__OptionsDefault



    ctypedef enum ImGuiTreeNodeFlags_:
        ImGuiTreeNodeFlags_Selected             # Draw as selected
        ImGuiTreeNodeFlags_Framed               # Full colored frame (e.g. for CollapsingHeader)
        ImGuiTreeNodeFlags_AllowOverlapMode     # Hit testing to allow subsequent widgets to overlap this one
        ImGuiTreeNodeFlags_NoTreePushOnOpen     # Don't do a TreePush() when open (e.g. for CollapsingHeader) = no extra indent nor pushing on ID stack
        ImGuiTreeNodeFlags_NoAutoOpenOnLog      # Don't automatically and temporarily open node when Logging is active (by default logging will automatically open tree nodes)
        ImGuiTreeNodeFlags_DefaultOpen          # Default node to be open
        ImGuiTreeNodeFlags_OpenOnDoubleClick    # Need double-click to open node
        ImGuiTreeNodeFlags_OpenOnArrow          # Only open when clicking on the arrow part. If ImGuiTreeNodeFlags_OpenOnDoubleClick is also set, single-click arrow or double-click all box to open.
        ImGuiTreeNodeFlags_Leaf                 # No collapsing, no arrow (use as a convenience for leaf nodes).
        ImGuiTreeNodeFlags_Bullet               # Display a bullet instead of arrow
        ImGuiTreeNodeFlags_CollapsingHeader     # ImGuiTreeNodeFlags_Framed | ImGuiTreeNodeFlags_NoAutoOpenOnLog

    ctypedef enum ImGuiSelectableFlags_:
        ImGuiSelectableFlags_DontClosePopups    # Clicking this don't close parent popup window
        ImGuiSelectableFlags_SpanAllColumns     # Selectable frame can span all columns (text will still fit in current column)
        ImGuiSelectableFlags_AllowDoubleClick   # Generate press events on double clicks too

    ctypedef enum ImGuiMouseCursor_:
        ImGuiMouseCursor_None
        ImGuiMouseCursor_Arrow
        ImGuiMouseCursor_TextInput              # When hovering over InputText, etc.
        ImGuiMouseCursor_ResizeAll
        ImGuiMouseCursor_ResizeNS               # Unused
        ImGuiMouseCursor_ResizeEW               # When hovering over a column
        ImGuiMouseCursor_ResizeNESW             # Unused
        ImGuiMouseCursor_ResizeNWSE             # When hovering over the bottom-right corner of a window
        ImGuiMouseCursor_Count_

    ctypedef enum ImGuiInputTextFlags_:
        ImGuiInputTextFlags_CharsDecimal        # Allow 0123456789.+-*/
        ImGuiInputTextFlags_CharsHexadecimal    # Allow 0123456789ABCDEFabcdef
        ImGuiInputTextFlags_CharsUppercase      # Turn a..z into A..Z
        ImGuiInputTextFlags_CharsNoBlank        # Filter out spaces, tabs
        ImGuiInputTextFlags_AutoSelectAll       # Select entire text when first taking mouse focus
        ImGuiInputTextFlags_EnterReturnsTrue    # Return 'true' when Enter is pressed (as opposed to when the value was modified)
        ImGuiInputTextFlags_CallbackCompletion  # Call user function on pressing TAB (for completion handling)
        ImGuiInputTextFlags_CallbackHistory     # Call user function on pressing Up/Down arrows (for history handling)
        ImGuiInputTextFlags_CallbackAlways      # Call user function every time. User code may query cursor position, modify text buffer.
        ImGuiInputTextFlags_CallbackCharFilter  # Call user function to filter character. Modify data->EventChar to replace/filter input, or return 1 to discard character.
        ImGuiInputTextFlags_AllowTabInput       # Pressing TAB input a '\t' character into the text field
        ImGuiInputTextFlags_CtrlEnterForNewLine # In multi-line mode, allow exiting edition by pressing Enter. Ctrl+Enter to add new line (by default adds new lines with Enter).
        ImGuiInputTextFlags_NoHorizontalScroll  # Disable following the cursor horizontally
        ImGuiInputTextFlags_AlwaysInsertMode    # Insert mode
        ImGuiInputTextFlags_ReadOnly            # Read-only mode
        ImGuiInputTextFlags_Password            # Password mode, display all characters as '*'
