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
