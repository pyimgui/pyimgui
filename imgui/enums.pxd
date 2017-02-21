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
        ImGuiCol_ComboBg
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
        ImGuiCol_CloseButton
        ImGuiCol_CloseButtonHovered
        ImGuiCol_CloseButtonActive
        ImGuiCol_PlotLines
        ImGuiCol_PlotLinesHovered
        ImGuiCol_PlotHistogram
        ImGuiCol_PlotHistogramHovered
        ImGuiCol_TextSelectedBg
        ImGuiCol_ModalWindowDarkening  # Darken entire screen when a modal window is active
        ImGuiCol_COUNT

    ctypedef enum ImGuiStyleVar_:
        ImGuiStyleVar_Alpha               # float
        ImGuiStyleVar_WindowPadding       # ImVec2
        ImGuiStyleVar_WindowRounding      # float
        ImGuiStyleVar_WindowMinSize       # ImVec2
        ImGuiStyleVar_ChildWindowRounding # float
        ImGuiStyleVar_FramePadding        # ImVec2
        ImGuiStyleVar_FrameRounding       # float
        ImGuiStyleVar_ItemSpacing         # ImVec2
        ImGuiStyleVar_ItemInnerSpacing    # ImVec2
        ImGuiStyleVar_IndentSpacing       # float
        ImGuiStyleVar_GrabMinSize         # float
        ImGuiStyleVar_ButtonTextAlign     # flags ImGuiAlign_*
        ImGuiStyleVar_Count_

    ctypedef enum ImGuiSetCond_:
        ImGuiSetCond_Always               # Set the variable
        ImGuiSetCond_Once                 # Only set the variable on the first call per runtime session
        ImGuiSetCond_FirstUseEver         # Only set the variable if the window doesn't exist in the .ini file
        ImGuiSetCond_Appearing            # Only set the variable if the window is appearing after being inactive (or the first time)

    ctypedef enum ImGuiWindowFlags_:
        ImGuiWindowFlags_NoTitleBar                 # Disable title-bar
        ImGuiWindowFlags_NoResize                   # Disable user resizing with the lower-right grip
        ImGuiWindowFlags_NoMove                     # Disable user moving the window
        ImGuiWindowFlags_NoScrollbar                # Disable scrollbars (window can still scroll with mouse or programatically)
        ImGuiWindowFlags_NoScrollWithMouse          # Disable user vertically scrolling with mouse wheel
        ImGuiWindowFlags_NoCollapse                 # Disable user collapsing window by double-clicking on it
        ImGuiWindowFlags_AlwaysAutoResize           # Resize every window to its content every frame
        ImGuiWindowFlags_ShowBorders                # Show borders around windows and items
        ImGuiWindowFlags_NoSavedSettings            # Never load/save settings in .ini file
        ImGuiWindowFlags_NoInputs                   # Disable catching mouse or keyboard inputs
        ImGuiWindowFlags_MenuBar                    # Has a menu-bar
        ImGuiWindowFlags_HorizontalScrollbar        # Allow horizontal scrollbar to appear (off by default). You may use SetNextWindowContentSize(ImVec2(width,0.0f)); prior to calling Begin() to specify width. Read code in imgui_demo in the "Horizontal Scrolling" section.
        ImGuiWindowFlags_NoFocusOnAppearing         # Disable taking focus when transitioning from hidden to visible state
        ImGuiWindowFlags_NoBringToFrontOnFocus      # Disable bringing window to front when taking focus (e.g. clicking on it or programatically giving it focus)
        ImGuiWindowFlags_AlwaysVerticalScrollbar    # Always show vertical scrollbar (even if ContentSize.y < Size.y)
        ImGuiWindowFlags_AlwaysHorizontalScrollbar  # Always show horizontal scrollbar (even if ContentSize.x < Size.x)
        ImGuiWindowFlags_AlwaysUseWindowPadding     # Ensure child windows without border uses style.WindowPadding (ignored by default for non-bordered child windows, because more convenient)

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

    ctypedef enum ImGuiSelectableFlags_:
        ImGuiSelectableFlags_DontClosePopups    # Clicking this don't close parent popup window
        ImGuiSelectableFlags_SpanAllColumns     # Selectable frame can span all columns (text will still fit in current column)
        ImGuiSelectableFlags_AllowDoubleClick   # Generate press events on double clicks too
