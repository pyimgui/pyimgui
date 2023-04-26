#-----------------------------------------------------------------------------
# [SECTION] Forward Declarations, Helpers
#-----------------------------------------------------------------------------

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

#-----------------------------------------------------------------------------
# [SECTION] Demo Window / ShowDemoWindow()
#-----------------------------------------------------------------------------
# - ShowDemoWindowWidgets()
# - ShowDemoWindowLayout()
# - ShowDemoWindowPopups()
# - ShowDemoWindowTables()
# - ShowDemoWindowColumns()
# - ShowDemoWindowMisc()
#-----------------------------------------------------------------------------

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

#-----------------------------------------------------------------------------
# [SECTION] About Window / ShowAboutWindow()
# Access from Dear ImGui Demo -> Tools -> About
#-----------------------------------------------------------------------------

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

#-----------------------------------------------------------------------------
# [SECTION] Style Editor / ShowStyleEditor()
#-----------------------------------------------------------------------------
# - ShowStyleSelector()
# - ShowFontSelector()
# - ShowStyleEditor()
#-----------------------------------------------------------------------------

def show_style_selector(str label):
    return cimgui.ShowStyleSelector(_bytes(label))

def show_font_selector(str label):
    cimgui.ShowFontSelector(_bytes(label))

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

#-----------------------------------------------------------------------------
# [SECTION] Example App: Main Menu Bar / ShowExampleAppMainMenuBar()
#-----------------------------------------------------------------------------
# - ShowExampleAppMainMenuBar()
# - ShowExampleMenuFile()
#-----------------------------------------------------------------------------

# Nothing to be mapped here

#-----------------------------------------------------------------------------
# [SECTION] Example App: Debug Console / ShowExampleAppConsole()
#-----------------------------------------------------------------------------

# Nothing to be mapped here

#-----------------------------------------------------------------------------
# [SECTION] Example App: Debug Log / ShowExampleAppLog()
#-----------------------------------------------------------------------------

# Nothing to be mapped here

#-----------------------------------------------------------------------------
# [SECTION] Example App: Simple Layout / ShowExampleAppLayout()
#-----------------------------------------------------------------------------

# Nothing to be mapped here

#-----------------------------------------------------------------------------
# [SECTION] Example App: Property Editor / ShowExampleAppPropertyEditor()
#-----------------------------------------------------------------------------

# Nothing to be mapped here

#-----------------------------------------------------------------------------
# [SECTION] Example App: Long Text / ShowExampleAppLongText()
#-----------------------------------------------------------------------------

# Nothing to be mapped here

#-----------------------------------------------------------------------------
# [SECTION] Example App: Auto Resize / ShowExampleAppAutoResize()
#-----------------------------------------------------------------------------

# Nothing to be mapped here

#-----------------------------------------------------------------------------
# [SECTION] Example App: Constrained Resize / ShowExampleAppConstrainedResize()
#-----------------------------------------------------------------------------

# Nothing to be mapped here

#-----------------------------------------------------------------------------
# [SECTION] Example App: Simple overlay / ShowExampleAppSimpleOverlay()
#-----------------------------------------------------------------------------

# Nothing to be mapped here

#-----------------------------------------------------------------------------
# [SECTION] Example App: Fullscreen window / ShowExampleAppFullscreen()
#-----------------------------------------------------------------------------

# Nothing to be mapped here

#-----------------------------------------------------------------------------
# [SECTION] Example App: Manipulating Window Titles / ShowExampleAppWindowTitles()
#-----------------------------------------------------------------------------

# Nothing to be mapped here

#-----------------------------------------------------------------------------
# [SECTION] Example App: Custom Rendering using ImDrawList API / ShowExampleAppCustomRendering()
#-----------------------------------------------------------------------------

# Nothing to be mapped here

#-----------------------------------------------------------------------------
# [SECTION] Example App: Documents Handling / ShowExampleAppDocuments()
#-----------------------------------------------------------------------------

# Nothing to be mapped here
