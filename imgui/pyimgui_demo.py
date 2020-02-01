import imgui


def show_pyimgui_demo(p_open = True):
    
    # Examples Apps (accessible from the "Examples" menu)
    show_app_main_menu_bar = False
    show_app_console = False
    show_app_log = False
    show_app_layout = False
    show_app_property_editor = False
    show_app_long_text = False
    show_app_auto_resize = False
    show_app_constrained_resize = False
    show_app_simple_overlay = False
    show_app_window_titles = False
    show_app_custom_rendering = False

    # We haven't passed any arguments to the window functions. Add them later
    # when function is implemented
    if show_app_main_menu_bar:
        show_example_app_main_menu_bar()
    if show_app_console:
        show_example_app_console()
    if show_app_log:
        show_example_app_log()
    if show_app_layout:
        show_example_app_layout()
    if show_app_property_editor:
        show_example_app_property_editor()
    if show_app_long_text:
        show_example_app_long_text()
    if show_app_constrained_resize:
        show_example_app_constrained_resize()
    if show_app_simple_overlay:
        show_example_app_simple_overlay()
    if show_app_window_titles:
        show_example_app_window_titles()
    if show_app_custom_rendering:
        show_example_app_custom_rendering()

    # pyimgui apps (access from the help menu)
    show_app_metrics = True
    show_app_style_editor = True
    show_app_about = True

    if show_app_metrics:
        imgui.show_metrics_window(show_app_metrics)
    if show_app_style_editor:
        show_example_app_style_editor(show_app_style_editor)
    if show_app_about:
        show_example_app_about(show_app_about)

    # Use various window flags. The default values usually work fine.
    

#Example app functions

def show_example_app_main_menu_bar():
    pass

def show_example_app_console():
    pass

def show_example_app_log():
    pass

def show_example_app_layout():
    pass

def show_example_app_property_editor():
    pass

def show_example_app_long_text():
    pass

def show_example_app_auto_resize():
    pass

def show_example_app_constrained_resize():
    pass

def show_example_app_simple_overlay():
    pass

def show_example_app_window_titles():
    pass

def show_example_app_custom_rendering():
    pass

# Help menu apps


def show_example_app_style_editor(show_app_style_editor):
    imgui.begin("Style Editor", closable = show_app_style_editor)
    imgui.show_style_editor()
    imgui.end()

def show_example_app_about(show_app_about):
    imgui.begin("About PyImgui", closable = show_app_about,
    flags = imgui.WINDOW_ALWAYS_AUTO_RESIZE)
    imgui.text("PyImgui, " + str(imgui.get_version()))
    imgui.separator()
    imgui.text("Enter info about author here.")
    imgui.text("Enter licensing info here.")
    imgui.end()