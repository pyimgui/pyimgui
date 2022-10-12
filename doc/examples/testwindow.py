# -*- coding: utf-8 -*-
import imgui
import sys
import math
import os
import itertools
from array import array
import colorsys

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


# Dear ImGui Apps (accessible from the "Help" menu)
show_app_metrics = False
show_app_style_editor = False
show_app_about = False


# Demonstrate the various window flags. Typically you would just use the default!
no_titlebar = False
no_scrollbar = False
no_menu = False
no_move = False
no_resize = False
no_collapse = False
no_close = False
no_nav = False

widgets_basic_button_clicked = 0
widgets_basic_checkbox_checked = True
widgets_basic_radio_button = 0
widgets_basic_counter = 0
widgets_basic_arr = array("f", [0.6, 0.1, 1.0, 0.5, 0.92, 0.1, 0.2])
widgets_basic_items = [
    "AAAA",
    "BBBB",
    "CCCC",
    "DDDD",
    "EEEE",
    "FFFF",
    "GGGG",
    "HHHH",
    "IIII",
    "JJJJ",
    "KKKK",
    "LLLLLLL",
    "MMMM",
    "OOOOOOO",
]
widgets_basic_item_current = 0
widgets_basic_str0 = "Hello, world!"
widgets_basic_i0 = 123
widgets_basic_f0 = 0.001
widgets_basic_d0 = 999999.00000001
widgets_basic_f1 = 1.0e10
widgets_basic_vec4a = [0.10, 0.20, 0.30, 0.44]
widgets_basic_i1 = 50
widgets_basic_i2 = 42
widgets_basic_f1 = 1.0
widgets_basic_f2 = 0.0067
widgets_basic_i1_1 = 0
widgets_basic_f1_1 = 0.123
widgets_basic_f2_1 = 0.0
widgets_basic_angle = 0.0
widgets_basic_col1 = [1.0, 0.0, 0.2]
widgets_basic_col2 = [0.4, 0.7, 0.0, 0.5]
widgets_basic_listbox_items = [
    "Apple",
    "Banana",
    "Cherry",
    "Kiwi",
    "Mango",
    "Orange",
    "Pineapple",
    "Strawberry",
    "Watermelon",
]
widgets_basic_listbox_item_current = 1

widgets_basic_wrap_width = 200.0

images_pressed_count = 0

combo_flags = 0
combo_items = [
    "AAAA",
    "BBBB",
    "CCCC",
    "DDDD",
    "EEEE",
    "FFFF",
    "GGGG",
    "HHHH",
    "IIII",
    "JJJJ",
    "KKKK",
    "LLLLLLL",
    "MMMM",
    "OOOOOOO",
]
combo_current_item = combo_items[0]

selectables_basic_selection = [False, True, False, False, False]
selectables_basic_selected = -1
selectables_basic_selection_2 = [False, False, False, False, False]
selectables_basic_selected_2 = [False, False, False]
selectables_basic_selected_3 = [
    False,
    False,
    False,
    False,
    False,
    False,
    False,
    False,
    False,
    False,
    False,
    False,
    False,
    False,
    False,
    False,
]
selectables_basic_selected_4 = [
    True,
    False,
    False,
    False,
    False,
    True,
    False,
    False,
    False,
    False,
    True,
    False,
    False,
    False,
    False,
    True,
]

filtered_text_input_buf1 = ""
filtered_text_input_buf2 = ""
filtered_text_input_buf3 = ""
filtered_text_input_buf4 = ""
filtered_text_input_buf5 = ""
filtered_text_input_buf6 = ""
filtered_text_input_buf_pass = "password123"

multi_line_text_input_read_only = False
multi_line_text_input_text = """/*\n"
 The Pentium F00F bug, shorthand for F0 0F C7 C8,
 the hexadecimal encoding of one offending instruction,
 more formally, the invalid operand with locked CMPXCHG8B
 instruction bug, is a design flaw in the majority of
 Intel Pentium, Pentium MMX, and Pentium OverDrive
 processors (all in the P5 microarchitecture).
*/\n
label:
\tlock cmpxchg8b eax
"""

plots_widgets_animate = True
plots_widgets_array = array("f", [0.6, 0.1, 1.0, 0.5, 0.92, 0.1, 0.2])
plots_widgets_values = array("f", list(itertools.repeat(0.0, 90)))
plots_widgets_offset = 0
plots_widgets_refresh_time = 0.0
plots_widgets_phase = 0.0
plots_progress = 0.0
plots_progress_dir = 1.0

color_picker_color = (114, 144, 154, 200)
color_picker_alpha_preview = True
color_picker_alpha_half_preview = False
color_picker_drag_and_drop = True
color_picker_options_menu = True
color_picker_hdr = False

range_widgets_begin = 10
range_widgets_end = 90
range_widgets_begin_i = 100
range_widgets_end_i = 1000


multi_component_vec4f = [0.10, 0.20, 0.30, 0.44]
multi_component_vec4i = [1, 5, 100, 255]


child_regions_disable_mouse_wheel = False
child_regions_disable_menu = False
child_regions_line = 50

example_menu_file_enabled = True
example_menu_file_options_f = 0.5
example_menu_file_options_n = 0
example_menu_file_options_b = True

popups_selected_fish = -1
popups_toggles = [True, False, False, False, False]

context_menus_value = 0.5
context_menus_name = "Label1"
context_menus_dont_ask_me_next_time = False
context_menus_modal_item = 1
context_menus_modal_color = [0.4, 0.7, 0.0, 0.5]

columns_selected = -1

mixed_items_foo = 1.0
mixed_items_bar = 1.0


borders_h_borders = True
borders_v_borders = True

collapsing_headers_closable_group = True

filtering_filter = None # Todo - bind this in cimgui.pxd

def show_help_marker(desc):

    imgui.text_disabled("(?)")
    if imgui.is_item_hovered():
        imgui.begin_tooltip()
        imgui.push_text_wrap_pos(imgui.get_font_size() * 35.0)
        imgui.text_unformatted(desc)
        imgui.pop_text_wrap_pos()
        imgui.end_tooltip()


# Demonstrate creating a fullscreen menu bar and populating it.
def show_example_app_main_menu_bar():
    if imgui.begin_main_menu_bar():
        if imgui.begin_menu("File"):
            show_example_menu_file()
            imgui.end_menu()
        if imgui.begin_menu("Edit"):
            if imgui.menu_item(label="Undo", shortcut="CTRL+Z"):
                pass
            if imgui.menu_item(
                label="Redo", shortcut="CTRL+Y", selected=False, enabled=False
            ):
                pass
            imgui.separator()
            if imgui.menu_item(label="Cut", shortcut="CTRL+X"):
                pass
            if imgui.menu_item(label="Copy", shortcut="CTRL+C"):
                pass
            if imgui.menu_item(label="Paste", shortcut="CTRL+V"):
                pass
            imgui.end_menu()
        imgui.end_main_menu_bar()


def show_example_menu_file():

    global example_menu_file_enabled
    global example_menu_file_options_f
    global example_menu_file_options_n
    global example_menu_file_options_b

    imgui.menu_item(label="(dummy menu)", shortcut=None, selected=False, enabled=False)
    if imgui.menu_item("New"):
        pass
    if imgui.menu_item(label="Open", shortcut="Ctrl+O"):
        pass
    if imgui.begin_menu(label="Open Recent"):
        imgui.menu_item(label="fish_hat.c")
        imgui.menu_item(label="fish_hat.inl")
        imgui.menu_item(label="fish_hat.h")
        if imgui.begin_menu(label="More.."):
            imgui.menu_item(label="Hello")
            imgui.menu_item(label="Sailor")
            if imgui.begin_menu(label="Recurse.."):
                show_example_menu_file()
                imgui.end_menu()
            imgui.end_menu()
        imgui.end_menu()

    if imgui.menu_item(label="Save", shortcut="Ctrl+S"):
        pass
    if imgui.menu_item(label="Save As.."):
        pass
    imgui.separator()
    if imgui.begin_menu("Options"):
        clicked, example_menu_file_enabled = imgui.menu_item(
            label="Enabled",
            shortcut=None,
            selected=example_menu_file_enabled,
            enabled=True,
        )

        imgui.begin_child(label="child", width=300, height=60, border=True)
        for i in range(10):
            imgui.text("Scrolling Text " + str(i))
        imgui.end_child()
        clicked, example_menu_file_options_f = imgui.slider_float(
            label="Value",
            value=example_menu_file_options_f,
            min_value=0.0,
            max_value=1.0,
        )
        changed, example_menu_file_options_f = imgui.input_float(
            label="Input", value=example_menu_file_options_f, step=0.1
        )
        changed, example_menu_file_options_n = imgui.combo(
            label="Combo",
            current=example_menu_file_options_n,
            items=["Yes", "No", "Maybe"],
        )
        changed, example_menu_file_options_b = imgui.checkbox(
            label="Check", state=example_menu_file_options_b
        )
        imgui.end_menu()
    if imgui.begin_menu("Colors"):
        sz = imgui.get_text_line_height()
        for i in range(imgui.COLOR_COUNT):
            name = imgui.get_style_color_name(i)
            p = imgui.get_cursor_screen_pos()
            imgui.get_window_draw_list().add_rect_filled(
                p.x, p.y, p.x + sz, p.y + sz, imgui.get_color_u32_idx(i)
            )

            imgui.dummy(sz, sz)
            imgui.same_line()
            imgui.menu_item(name)
        imgui.end_menu()
    if imgui.begin_menu("Disabled", False):  # // Disabled
        pass
        #     IM_ASSERT(0);
    if imgui.menu_item("Checked", None, True):
        pass
    if imgui.menu_item("Quit", "Alt+F4"):
        pass


def show_test_window():

    global show_app_main_menu_bar
    global show_app_console
    global show_app_log
    global show_app_layout
    global show_app_property_editor
    global show_app_long_text
    global show_app_auto_resize
    global show_app_constrained_resize
    global show_app_simple_overlay
    global show_app_window_titles
    global show_app_custom_rendering

    global show_app_metrics
    global show_app_style_editor
    global show_app_about

    global no_titlebar
    global no_scrollbar
    global no_menu
    global no_move
    global no_resize
    global no_collapse
    global no_close
    global no_nav

    global widgets_basic_button_clicked
    global widgets_basic_checkbox_checked
    global widgets_basic_radio_button
    global widgets_basic_counter
    global widgets_basic_arr
    global widgets_basic_items
    global widgets_basic_item_current
    global widgets_basic_str0
    global widgets_basic_i0
    global widgets_basic_f0
    global widgets_basic_d0
    global widgets_basic_f1
    global widgets_basic_vec4a
    global widgets_basic_i1
    global widgets_basic_i2
    global widgets_basic_f1
    global widgets_basic_f2
    global widgets_basic_i1_1
    global widgets_basic_f1_1
    global widgets_basic_f2_1
    global widgets_basic_angle
    global widgets_basic_col1
    global widgets_basic_col2
    global widgets_basic_listbox_items
    global widgets_basic_listbox_item_current
    global widgets_basic_wrap_width

    global images_pressed_count

    global combo_flags
    global combo_items
    global combo_current_item

    global selectables_basic_selection
    global selectables_basic_selected
    global selectables_basic_selection_2
    global selectables_basic_selected_2
    global selectables_basic_selected_3
    global selectables_basic_selected_4

    global filtered_text_input_buf1
    global filtered_text_input_buf2
    global filtered_text_input_buf3
    global filtered_text_input_buf4
    global filtered_text_input_buf5
    global filtered_text_input_buf6
    global filtered_text_input_buf_pass

    global multi_line_text_input_read_only
    global multi_line_text_input_text

    global plots_widgets_animate
    global plots_widgets_array
    global plots_widgets_values
    global plots_widgets_offset
    global plots_widgets_refresh_time
    global plots_widgets_phase
    global plots_progress
    global plots_progress_dir

    global color_picker_color
    global color_picker_alpha_preview
    global color_picker_alpha_half_preview
    global color_picker_drag_and_drop
    global color_picker_options_menu
    global color_picker_hdr

    global range_widgets_begin
    global range_widgets_end
    global range_widgets_begin_i
    global range_widgets_end_i

    global child_regions_disable_mouse_wheel
    global child_regions_disable_menu
    global child_regions_line

    global example_menu_file_enabled

    global popups_selected_fish
    global popups_toggles

    global context_menus_value
    global context_menus_name
    global context_menus_dont_ask_me_next_time
    global context_menus_modal_item
    global context_menus_modal_color

    global columns_selected

    global mixed_items_foo
    global mixed_items_bar

    global borders_h_borders
    global borders_v_borders

    global collapsing_headers_closable_group

    if show_app_main_menu_bar:
        # TODO -- implement this
        show_example_app_main_menu_bar()
        pass
    if show_app_console:
        # TODO - make sure this returns the parameter back
        # show_app_console = ShowExampleAppConsole(show_app_console)
        pass
    if show_app_log:
        # TODO - make sure this returns the parameter back
        # TODO -- implement this
        # show_app_log = ShowExampleAppLog(show_app_log)
        pass
    if show_app_layout:
        # TODO - make sure this returns the parameter back
        # TODO -- implement this
        # show_app_layout = ShowExampleAppLayout(show_app_layout)
        pass
    if show_app_property_editor:
        # TODO - make sure this returns the parameter back
        # TODO -- implement this
        # show_app_property_editor = ShowExampleAppPropertyEditor(show_app_property_editor)
        pass
    if show_app_long_text:
        # TODO - make sure this returns the parameter back
        # TODO -- implement this
        # show_app_long_text = ShowExampleAppLongText(show_app_long_text)
        pass
    if show_app_auto_resize:
        # TODO - make sure this returns the parameter back
        # TODO -- implement this
        # show_app_auto_resize = ShowExampleAppAutoResize(show_app_auto_resize)
        pass
    if show_app_constrained_resize:
        # TODO - make sure this returns the parameter back
        # TODO -- implement this
        # show_app_constrained_resize = ShowExampleAppConstrainedResize(show_app_constrained_resize)
        pass
    if show_app_simple_overlay:
        # TODO - make sure this returns the parameter back
        # TODO -- implement this
        # show_app_simple_overlay = ShowExampleAppSimpleOverlay(show_app_simple_overlay)
        pass
    if show_app_window_titles:
        # TODO - make sure this returns the parameter back
        # TODO -- implement this
        # show_app_window_titles = ShowExampleAppWindowTitles(show_app_window_titles)
        pass
    if show_app_custom_rendering:
        # TODO - make sure this returns the parameter back
        # TODO -- implement this
        # show_app_custom_rendering = ShowExampleAppCustomRendering(show_app_custom_rendering)
        pass

    if show_app_metrics:
        show_app_metrics = imgui.show_metrics_window(closable=show_app_metrics)
    if show_app_style_editor:
        show_app_style_editor = imgui.begin(
            label="Style Editor", closable=show_app_style_editor
        )
        imgui.show_style_editor()
        imgui.end()
    if show_app_about:
        is_expand, show_app_about = imgui.begin(
            label="About Dear ImGui",
            closable=show_app_about,
            flags=imgui.WINDOW_ALWAYS_AUTO_RESIZE,
        )
        if is_expand:
            imgui.text("Dear ImGui, " + imgui.get_version())
            imgui.separator()
            imgui.text("By Omar Cornut and all dear imgui contributors.")
            imgui.text(
                "Dear ImGui is licensed under the MIT License, see LICENSE for more information."
            )
        imgui.end()

    window_flags = 0
    if no_titlebar:
        window_flags |= imgui.WINDOW_NO_TITLE_BAR
    if no_scrollbar:
        window_flags |= imgui.WINDOW_NO_SCROLLBAR
    if not no_menu:
        window_flags |= imgui.WINDOW_MENU_BAR
    if no_move:
        window_flags |= imgui.WINDOW_NO_MOVE
    if no_resize:
        window_flags |= imgui.WINDOW_NO_RESIZE
    if no_collapse:
        window_flags |= imgui.WINDOW_NO_COLLAPSE
    if no_nav:
        window_flags |= imgui.WINDOW_NO_NAV
    if no_close:
        pass

    # We specify a default position/size in case there's no data in the .ini file. Typically this isn't required! We only do it to make the Demo applications a little more welcoming.
    # imgui.set_next_window_position(650, 20, condition=imgui.FIRST_USE_EVER)
    imgui.set_next_window_size(550, 680, condition=imgui.FIRST_USE_EVER)

    # Main body of the Demo window starts here.
    if not imgui.begin(label="ImGui Demo", closable=no_close, flags=window_flags):
        # Early out if the window is collapsed, as an optimization.
        imgui.end()
        sys.exit(1)

    imgui.text("dear imgui says hello. (" + str(imgui.get_version()) + ")")

    # TODO - uncomment the below
    # Most "big" widgets share a common width settings by default.
    imgui.push_item_width(imgui.get_window_width() * 0.65)
    # Use 2/3 of the space for widgets and 1/3 for labels (default)
    imgui.push_item_width(imgui.get_font_size() * -12)
    # Use fixed width for labels (by passing a negative value), the rest goes to widgets. We choose a width proportional to our font size.

    # Menu
    if imgui.begin_menu_bar():
        if imgui.begin_menu(label="Menu"):
            # TODO - implement this
            show_example_menu_file()
            imgui.end_menu()

        if imgui.begin_menu(label="Examples"):
            clicked, show_app_main_menu_bar = imgui.menu_item(
                label="Main menu bar", shortcut=None, selected=show_app_main_menu_bar
            )
            clicked, show_app_console = imgui.menu_item(
                label="Console", shortcut=None, selected=show_app_console
            )
            clicked, show_app_log = imgui.menu_item(
                label="Log", shortcut=None, selected=show_app_log
            )
            clicked, show_app_layout = imgui.menu_item(
                label="Simple layout", shortcut=None, selected=show_app_layout
            )
            clicked, show_app_property_editor = imgui.menu_item(
                label="Property editor",
                shortcut=None,
                selected=show_app_property_editor,
            )
            clicked, show_app_long_text = imgui.menu_item(
                label="Long text display", shortcut=None, selected=show_app_long_text
            )
            clicked, show_app_auto_resize = imgui.menu_item(
                label="Auto-resizing window",
                shortcut=None,
                selected=show_app_auto_resize,
            )
            clicked, show_app_constrained_resize = imgui.menu_item(
                label="Constrained-resizing window",
                shortcut=None,
                selected=show_app_constrained_resize,
            )
            clicked, show_app_simple_overlay = imgui.menu_item(
                label="Simple overlay", shortcut=None, selected=show_app_simple_overlay
            )
            clicked, show_app_window_titles = imgui.menu_item(
                label="Manipulating window titles",
                shortcut=None,
                selected=show_app_window_titles,
            )
            clicked, show_app_custom_rendering = imgui.menu_item(
                label="Custom rendering",
                shortcut=None,
                selected=show_app_custom_rendering,
            )
            imgui.end_menu()

        if imgui.begin_menu(label="Help"):
            clicked, show_app_metrics = imgui.menu_item(
                label="Metrics", shortcut=None, selected=show_app_metrics
            )
            clicked, show_app_style_editor = imgui.menu_item(
                label="Style Editor", shortcut=None, selected=show_app_style_editor
            )
            clicked, show_app_about = imgui.menu_item(
                label="About Dear ImGui", shortcut=None, selected=show_app_about
            )
            imgui.end_menu()

        imgui.end_menu_bar()

        imgui.spacing()

        show, _ = imgui.collapsing_header("Help")
        if show:

            imgui.text("PROGRAMMER GUIDE:")
            imgui.bullet_text(
                "Please see the _show_demo_window() code in imgui_demo.cpp. <- you are here!"
            )
            imgui.bullet_text("Please see the comments in imgui.cpp.")
            imgui.bullet_text("Please see the examples/ in application.")
            imgui.bullet_text(
                "Enable 'io.config_flags |= _nav_enable_keyboard' for keyboard controls."
            )
            imgui.bullet_text(
                "Enable 'io.config_flags |= _nav_enable_gamepad' for gamepad controls."
            )
            imgui.separator()

            imgui.text("USER GUIDE:")
            imgui.show_user_guide()

    show, _ = imgui.collapsing_header("Configuration")
    if show:

        io = imgui.get_io()

        if imgui.tree_node("Configuration##2"):

            # TODO - for some reason this causes an error about space not being mapped, which doesn't happen in the C++ version
            clicked, io.config_flags = imgui.checkbox_flags(
                "io.ConfigFlags: NavEnableKeyboard",
                io.config_flags,
                imgui.CONFIG_NAV_ENABLE_KEYBOARD,
            )
            clicked, io.config_flags = imgui.checkbox_flags(
                "io.ConfigFlags: NavEnableGamepad",
                io.config_flags,
                imgui.CONFIG_NAV_ENABLE_GAMEPAD,
            )
            imgui.same_line()
            show_help_marker(
                "Required back-end to feed in gamepad inputs in io.NavInputs[] and set io.BackendFlags |= ImGuiBackendFlags_HasGamepad.\n\nRead instructions in imgui.cpp for details."
            )
            clicked, io.config_flags = imgui.checkbox_flags(
                "io.ConfigFlags: NavEnableSetMousePos",
                io.config_flags,
                imgui.CONFIG_NAV_ENABLE_SET_MOUSE_POS,
            )
            imgui.same_line()
            show_help_marker(
                "Instruct navigation to move the mouse cursor. See comment for ImGuiConfigFlags_NavEnableSetMousePos."
            )
            clicked, io.config_flags = imgui.checkbox_flags(
                "io.ConfigFlags: NoMouse", io.config_flags, imgui.CONFIG_NO_MOUSE
            )
            if (
                io.config_flags & imgui.CONFIG_NO_MOUSE
            ):  # Create a way to restore this flag otherwise we could be stuck completely!
                if math.fmod(imgui.get_time(), 0.40) < 0.20:
                    imgui.same_line()
                    imgui.text("<<PRESS SPACE TO DISABLE>>")
                if imgui.is_key_pressed(imgui.get_key_index(imgui.KEY_SPACE)):
                    io.config_flags &= ~ imgui.CONFIG_NO_MOUSE
                #     clicked, io.config_flags = imgui.checkbox_flags("io.ConfigFlags: NoMouseCursorChange", io.config_flags, imgui.CONFIG_NO_MOUSE_CURSOR_CHANGE)

            imgui.same_line()
            show_help_marker(
                "Instruct back-end to not alter mouse cursor shape and visibility."
            )
            imgui.checkbox(
                label="io.ConfigInputTextCursorBlink", state=io.config_cursor_blink
            )
            imgui.same_line()
            show_help_marker(
                "Set to False to disable blinking cursor, for users who consider it distracting"
            )
            imgui.checkbox(
                label="io.ConfigResizeWindowsFromEdges [beta]",
                state=io.config_windows_resize_from_edges,
            )
            imgui.same_line()
            show_help_marker(
                "Enable resizing of windows from their edges and from the lower-left corner.\nThis requires (io.BackendFlags & ImGuiBackendFlags_HasMouseCursors) because it needs mouse cursor feedback."
            )
            imgui.checkbox(label="io.MouseDrawCursor", state=io.mouse_draw_cursor)
            imgui.same_line()
            show_help_marker(
                "Instruct Dear ImGui to render a mouse cursor for you. Note that a mouse cursor rendered via your application GPU rendering path will feel more laggy than hardware cursor, but will be more in sync with your other visuals.\n\nSome desktop applications may use both kinds of cursors (e.g. enable software cursor only when resizing/dragging something)."
            )
            imgui.tree_pop()
            imgui.separator()

        if imgui.tree_node("Backend Flags"):

            backend_flags = io.backend_flags
            # Make a local copy to avoid modifying the back-end flags.
            clicked, backend_flags = imgui.checkbox_flags(
                "io.BackendFlags: HasGamepad", backend_flags, imgui.BACKEND_HAS_GAMEPAD
            )
            clicked, backend_flags = imgui.checkbox_flags(
                "io.BackendFlags: HasMouseCursors",
                backend_flags,
                imgui.BACKEND_HAS_MOUSE_CURSORS,
            )
            clicked, backend_flags = imgui.checkbox_flags(
                "io.BackendFlags: HasSetMousePos",
                backend_flags,
                imgui.BACKEND_HAS_SET_MOUSE_POS,
            )
            imgui.tree_pop()
            imgui.separator()

        if imgui.tree_node("Style"):

            # TODO - implement show_style_editor
            imgui.show_style_editor()
            imgui.tree_pop()
            imgui.separator()

        if imgui.tree_node("Capture/Logging"):

            # TODO -- check to see if pyimgui actually implements this functionality, then add it in

            # imgui.text_wrapped("The logging API redirects all text output so you can easily capture the content of a window or a block. Tree nodes can be automatically expanded.")
            # show_help_marker("Try opening any of the contents below in this window and then click one of the \"Log To\" button.")
            # imgui.log_buttons()
            # imgui.text_wrapped("You can also call imgui.LogText() to output directly to the log without a visual output.")
            # if imgui.button(label="Copy \"Hello, world!\" to clipboard"):

            #     imgui.log_to_clipboard()
            #     imgui.log_text("Hello, world!")
            #     imgui.log_finish()
            imgui.tree_pop()

        show, _ = imgui.collapsing_header("Window options")
        if show:
            clicked, no_titlebar = imgui.checkbox(
                label="No titlebar", state=no_titlebar
            )
            imgui.same_line(150)
            clicked, no_scrollbar = imgui.checkbox(
                label="No scrollbar", state=no_scrollbar
            )
            imgui.same_line(300)
            clicked, no_menu = imgui.checkbox(label="No menu", state=no_menu)
            clicked, no_move = imgui.checkbox(label="No move", state=no_move)
            imgui.same_line(150)
            clicked, no_resize = imgui.checkbox(label="No resize", state=no_resize)
            imgui.same_line(300)
            clicked, no_collapse = imgui.checkbox(
                label="No collapse", state=no_collapse
            )
            clicked, no_close = imgui.checkbox(label="No close", state=no_close)
            imgui.same_line(150)
            clicked, no_nav = imgui.checkbox(label="No nav", state=no_nav)

    # aoeua
    show, _ = imgui.collapsing_header("Widgets")
    if show:
        if imgui.tree_node("Basic"):
            if imgui.button(label="Button"):
                widgets_basic_button_clicked += 1
            if widgets_basic_button_clicked & 1:
                imgui.same_line()
                imgui.text("Thanks for clicking me!")

            clicked, widgets_basic_checkbox_checked = imgui.checkbox(
                label="checkbox", state=widgets_basic_checkbox_checked
            )

            # TODO -- make the radio button actually work like in the CPP demo.
            #  independent radio buttons make no sense.  Make it like the cpp demo,
            #  in which only one is selected at a time.  This will involve modifying
            #  core.pyx, as they only define one of the "RadioButton" functions.
            #
            # clicked, widgets_basic_radio_button = imgui.radio_button("radio a", widgets_basic_radio_button)
            # imgui.same_line()
            # clicked, widgets_basic_radio_button = imgui.radio_button("radio b", widgets_basic_radio_button)
            # imgui.same_line()
            # clicked, widgets_basic_radio_button = imgui.radio_button("radio c", widgets_basic_radio_button)

            #      Color buttons, demonstrate using PushID() to add unique identifier in the ID stack, and changing style.
            for i in range(7):
                if i > 0:
                    imgui.same_line()
                imgui.push_id(str(i))

                r, g, b = colorsys.hsv_to_rgb(i / 7.0, 0.6, 0.6)
                imgui.push_style_color(imgui.COLOR_BUTTON, r, g, b)
                r, g, b = colorsys.hsv_to_rgb(i / 7.0, 0.7, 0.7)
                imgui.push_style_color(imgui.COLOR_BUTTON_HOVERED, r, g, b)
                r, g, b = colorsys.hsv_to_rgb(i / 7.0, 0.8, 0.8)
                imgui.push_style_color(imgui.COLOR_BUTTON_ACTIVE, r, g, b)
                imgui.button(label="Click")
                imgui.pop_style_color(3)
                imgui.pop_id()

            # // Arrow buttons
            spacing = imgui.get_style().item_inner_spacing.x
            imgui.push_button_repeat(True)
            if imgui.arrow_button("##left", imgui.DIRECTION_LEFT):
                widgets_basic_counter -= 1
            imgui.same_line(0.0, spacing)
            if imgui.arrow_button("##right", imgui.DIRECTION_RIGHT):
                widgets_basic_counter += 1
            imgui.pop_button_repeat()
            imgui.same_line()
            imgui.text(str(widgets_basic_counter))

            imgui.text("Hover over me")
            if imgui.is_item_hovered():
                imgui.set_tooltip("I am a tooltip")

            imgui.same_line()
            imgui.text("- or me")
            if imgui.is_item_hovered():
                imgui.begin_tooltip()
                imgui.text("I am a fancy tooltip")
                imgui.plot_lines("Curve", widgets_basic_arr)
                imgui.end_tooltip()

            imgui.separator()

            imgui.label_text("label", "Value")

            # // Using the _simplified_ one-liner Combo() api here
            # // See "Combo" section for examples of how to use the more complete BeginCombo()/EndCombo() api.
            clicked, widgets_basic_item_current = imgui.combo(
                "combo", widgets_basic_item_current, widgets_basic_items
            )
            imgui.same_line()
            show_help_marker(
                'Refer to the "Combo" section below for an explanation of the full BeginCombo/EndCombo API, and demonstration of various flags.\n'
            )

            # TODO - if you change the buffer length, why does it not work correctly?
            changed, widgets_basic_str0 = imgui.input_text(
                label="input text", value=widgets_basic_str0, buffer_length=400
            )
            imgui.same_line()
            show_help_marker(
                "USER:\nHold SHIFT or use mouse to select text.\n"
                "CTRL+Left/Right to word jump.\n"
                "CTRL+A or double-click to select all.\n"
                "CTRL+X,CTRL+C,CTRL+V clipboard.\n"
                "CTRL+Z,CTRL+Y undo/redo.\n"
                "ESCAPE to revert.\n\nPROGRAMMER:\nYou can use the ImGuiInputTextFlags_CallbackResize facility if you need to wire InputText() to a dynamic string type. See misc/stl/imgui_stl.h for an example (this is not demonstrated in imgui_demo.cpp)."
            )

            changed, widgets_basic_i0 = imgui.input_int("input int", widgets_basic_i0)
            imgui.same_line()
            show_help_marker(
                "You can apply arithmetic operators +,*,/ on numerical values.\n  e.g. [ 100 ], input '*2', result becomes [ 200 ]\nUse +- to subtract.\n"
            )

            changed, widgets_basic_f0 = imgui.input_float(
                label="input float", value=widgets_basic_f0, step=0.01, step_fast=1.0
            )

            changed, widgets_basic_d0 = imgui.input_double(
                label="input double",
                value=widgets_basic_d0,
                step=0.01,
                step_fast=1.0,
                format="%.8f",
            )

            changed, widgets_basic_f1 = imgui.input_float(
                "input scientific", widgets_basic_f1, 0.0, 0.0, "%e"
            )
            imgui.same_line()
            show_help_marker(
                'You can input value using the scientific notation,\n  e.g. "1e+8" becomes "100000000".\n'
            )

            changed, widgets_basic_vec4a = imgui.input_float4(
                "input float4", *widgets_basic_vec4a
            )

            changed, widgets_basic_i1 = imgui.drag_int("drag int", widgets_basic_i1, 1)
            imgui.same_line()
            show_help_marker(
                "Click and drag to edit value.\nHold SHIFT/ALT for faster/slower edit.\nDouble-click or CTRL+click to input value."
            )

            changed, widgets_basic_i2 = imgui.drag_int(
                "drag int 0..100", widgets_basic_i2, 1, 0, 100, "%d%%"
            )

            changed, widgets_basic_f1 = imgui.drag_float(
                "drag float", widgets_basic_f1, 0.005
            )
            changed, widgets_basic_f2 = imgui.drag_float(
                "drag small float", widgets_basic_f2, 0.0001, 0.0, 0.0, "%.06f ns"
            )

            changed, widgets_basic_i1_1 = imgui.slider_int(
                "slider int", widgets_basic_i1_1, -1, 3
            )
            imgui.same_line()
            show_help_marker("CTRL+click to input value.")

            changed, widgets_basic_f1_1 = imgui.slider_float(
                label="slider float",
                value=widgets_basic_f1_1,
                min_value=0.0,
                max_value=1.0,
                format="ratio = %.3f",
            )
            # TODO -- figure out how to fix this power argument
            # and change it into an Enum
            # changed, widgets_basic_f2_1 = imgui.slider_float(
            #     label="slider float (curve)",
            #     value=widgets_basic_f2_1,
            #     min_value=-10.0,
            #     max_value=10.0,
            #     format="%.4f",
            #     power=2.0,
            # )
            # in degrees
            changed, widgets_basic_angle = imgui.slider_angle(
                label="slider angle",
                rad_value=widgets_basic_angle,
                value_degrees_min=0.0,
                value_degrees_max=180.0,
            )

            changed, widgets_basic_col1 = imgui.color_edit3(
                "color 1", *widgets_basic_col1
            )
            imgui.same_line()
            show_help_marker(
                "Click on the colored square to open a color picker.\nClick and hold to use drag and drop.\nRight-click on the colored square to show options.\nCTRL+click on individual component to input value.\n"
            )

            changed, widgets_basic_col2 = imgui.color_edit4(
                "color 2", *widgets_basic_col2
            )

            changed, widgets_basic_listbox_item_current = imgui.listbox(
                label="listbox\n(single select)",
                current=widgets_basic_listbox_item_current,
                items=widgets_basic_listbox_items,
                height_in_items=4,
            )

            # //static int listbox_item_current2 = 2;
            # //imgui.push_item_width(-1);
            # //imgui.list_box("##listbox2", &listbox_item_current2, listbox_items, IM_ARRAYSIZE(listbox_items), 4);
            # //imgui.pop_item_width();

            imgui.tree_pop()

        # // Testing ImGuiOnceUponAFrame helper.
        # //static ImGuiOnceUponAFrame once;
        # //for (int i = 0; i < 5; i++)
        # //    if (once)
        # //        imgui.text("This will be displayed only once.");

        if imgui.tree_node("Trees"):

            if imgui.tree_node("Basic trees"):
                for i in range(5):
                    if imgui.tree_node(text="Child " + str(i)):
                        imgui.text("blah blah")
                        imgui.same_line()
                        if imgui.small_button("button"):
                            pass
                        imgui.tree_pop()
                imgui.tree_pop()

            if imgui.tree_node("Advanced, with Selectable nodes"):
                # show_help_marker("This is a more standard looking tree with selectable nodes.\nClick to select, CTRL+Click to toggle, click on arrows or double-click to open.");
                # static bool align_label_with_current_x_position = False;
                # imgui.checkbox(label="Align label with current X position)", state=&align_label_with_current_x_position);
                # imgui.text("Hello!");
                # if align_label_with_current_x_position:
                #     imgui.unindent(imgui.get_tree_node_to_label_spacing());

                # static int selection_mask = (1 << 2); // Dumb representation of what may be user-side selection state. You may carry selection state inside or outside your objects in whatever format you see fit.
                # int node_clicked = -1;                // Temporary storage of what node we have clicked to process selection at the end of the loop. May be a pointer to your own node type, etc.
                # imgui.push_style_var(ImGuiStyleVar_IndentSpacing, imgui.get_font_size()*3); // Increase spacing to differentiate leaves from expanded contents.
                # for (int i = 0; i < 6; i++)
                # {
                #     // Disable the default open on single-click behavior and pass in Selected flag according to our selection state.
                #     ImGuiTreeNodeFlags node_flags = ImGuiTreeNodeFlags_OpenOnArrow | ImGuiTreeNodeFlags_OpenOnDoubleClick | ((selection_mask & (1 << i)) ? ImGuiTreeNodeFlags_Selected : 0);
                #     if i < 3:
                #     {
                #         // Node
                #         bool node_open = imgui.tree_node_ex((void*)(intptr_t)i, node_flags, "Selectable Node %d", i);
                #         if imgui.is_item_clicked():
                #             node_clicked = i;
                #         if node_open:
                #         {
                #             imgui.text("Blah blah\nBlah Blah");
                #             imgui.tree_pop();
                #         }
                #     }
                #     else
                #     {
                #         // Leaf: The only reason we have a TreeNode at all is to allow selection of the leaf. Otherwise we can use BulletText() or TreeAdvanceToLabelPos()+Text().
                #         node_flags |= ImGuiTreeNodeFlags_Leaf | ImGuiTreeNodeFlags_NoTreePushOnOpen; // ImGuiTreeNodeFlags_Bullet
                #         imgui.tree_node_ex((void*)(intptr_t)i, node_flags, "Selectable Leaf %d", i);
                #         if imgui.is_item_clicked():
                #             node_clicked = i;
                #     }
                # }
                # if node_clicked != -1:
                # {
                #     // Update selection state. Process outside of tree loop to avoid visual inconsistencies during the clicking-frame.
                #     if imgui.get_i_o().KeyCtrl:
                #         selection_mask ^= (1 << node_clicked);          // CTRL+click to toggle
                #     else //if (!(selection_mask & (1 << node_clicked))) // Depending on selection behavior you want, this commented bit preserve selection when clicking on item that is part of the selection
                #         selection_mask = (1 << node_clicked);           // Click to single-select
                # }
                # imgui.pop_style_var();
                # if align_label_with_current_x_position:
                #     imgui.indent(imgui.get_tree_node_to_label_spacing());
                imgui.tree_pop()
            imgui.tree_pop()

        if imgui.tree_node("Collapsing Headers"):
            clicked, collapsing_headers_closable_group = imgui.checkbox(
                label="Enable extra group", state=collapsing_headers_closable_group
            )

            show, _ = imgui.collapsing_header("Header")
            if show:
                imgui.text("IsItemHovered: " + str(imgui.is_item_hovered()))
                for i in range(5):
                    imgui.text("Some content " + str(i))
            show, collapsing_headers_closable_group = imgui.collapsing_header(
                "Header with a close button", collapsing_headers_closable_group
            )
            if show:
                imgui.text("IsItemHovered: " + str(imgui.is_item_hovered()))
                for i in range(5):
                    imgui.text("More content " + str(i))
            imgui.tree_pop()

        if imgui.tree_node("Bullets"):
            imgui.bullet_text("Bullet point 1")
            imgui.bullet_text("Bullet point 2" + os.linesep + "newOn multiple lines")
            imgui.bullet()
            imgui.text("Bullet point 3 (two calls)")
            imgui.bullet()
            imgui.small_button("Button")
            imgui.tree_pop()

        if imgui.tree_node("Text"):
            if imgui.tree_node("Colored Text"):
                # // Using shortcut. You can use PushStyleColor()/PopStyleColor() for more flexibility.
                imgui.text_colored(text="Pink", r=1.0, g=0.0, b=1.0, a=1.0)
                imgui.text_colored(text="Yellow", r=1.0, g=1.0, b=0.0, a=1.0)
                imgui.text_disabled("Disabled")
                imgui.same_line()
                show_help_marker("The TextDisabled color is stored in ImGuiStyle.")
                imgui.tree_pop()

            if imgui.tree_node("Word Wrapping"):
                # // Using shortcut. You can use PushTextWrapPos()/PopTextWrapPos() for more flexibility.
                imgui.text_wrapped(
                    "This text should automatically wrap on the edge of the window. The current implementation for text wrapping follows simple rules suitable for English and possibly other languages."
                )
                imgui.spacing()

                clicked, widgets_basic_wrap_width = imgui.slider_float(
                    label="Wrap width",
                    value=widgets_basic_wrap_width,
                    min_value=-20,
                    max_value=600,
                    format="%.0f",
                )

                imgui.text("Test paragraph 1:")
                pos = imgui.get_cursor_screen_pos()
                imgui.get_window_draw_list().add_rect_filled(
                    pos.x + widgets_basic_wrap_width,
                    pos.y,
                    pos.x + widgets_basic_wrap_width + 10,
                    pos.y + imgui.get_text_line_height(),
                    imgui.get_color_u32_rgba(255, 0, 255, 255),
                )

                imgui.push_text_wrap_pos(
                    imgui.get_cursor_pos().x + widgets_basic_wrap_width
                )
                imgui.text(
                    "The lazy dog is a good dog. This paragraph is made to fit within "
                    + str(widgets_basic_wrap_width)
                    + " pixels. Testing a 1 character word. The quick brown fox jumps over the lazy dog."
                )
                min_x, min_y = imgui.get_item_rect_min()
                max_x, max_y = imgui.get_item_rect_max()
                imgui.get_window_draw_list().add_rect(
                    upper_left_x=min_x,
                    upper_left_y=min_y,
                    lower_right_x=max_x,
                    lower_right_y=max_y,
                    col=imgui.get_color_u32_rgba(1, 1, 0, 1),
                )
                imgui.pop_text_wrap_pos()

                imgui.text("Test paragraph 2:")
                pos = imgui.get_cursor_screen_pos()
                imgui.get_window_draw_list().add_rect_filled(
                    upper_left_x=pos.x + widgets_basic_wrap_width,
                    upper_left_y=pos.y,
                    lower_right_x=pos.x + widgets_basic_wrap_width + 10,
                    lower_right_y=pos.y + imgui.get_text_line_height(),
                    col=imgui.get_color_u32_rgba(1, 0, 1, 1),
                )
                imgui.push_text_wrap_pos(
                    imgui.get_cursor_pos().x + widgets_basic_wrap_width
                )
                imgui.text(
                    "aaaaaaaa bbbbbbbb, c cccccccc,dddddddd. d eeeeeeee   ffffffff. gggggggg!hhhhhhhh"
                )
                min_x, min_y = imgui.get_item_rect_min()
                max_x, max_y = imgui.get_item_rect_max()
                imgui.get_window_draw_list().add_rect(
                    upper_left_x=min_x,
                    upper_left_y=min_y,
                    lower_right_x=max_x,
                    lower_right_y=max_y,
                    col=imgui.get_color_u32_rgba(1, 1, 0, 1),
                )
                imgui.pop_text_wrap_pos()

                imgui.tree_pop()

            if imgui.tree_node("UTF-8 Text"):
                # // UTF-8 test with Japanese characters
                # // (Needs a suitable font, try Noto, or Arial Unicode, or M+ fonts. Read misc/fonts/README.txt for details.)
                # // - From C++11 you can use the u8"my text" syntax to encode literal strings as UTF-8
                # // - For earlier compiler, you may be able to encode your sources as UTF-8 (e.g. Visual Studio save your file as 'UTF-8 without signature')
                # // - FOR THIS DEMO FILE ONLY, BECAUSE WE WANT TO SUPPORT OLD COMPILERS, WE ARE *NOT* INCLUDING RAW UTF-8 CHARACTERS IN THIS SOURCE FILE.
                # //   Instead we are encoding a few strings with hexadecimal constants. Don't do this in your application!
                # //   Please use u8"text in any language" in your application!
                # // Note that characters values are preserved even by InputText() if the font cannot be displayed, so you can safely copy & paste garbled characters into another application.
                # imgui.text_wrapped("CJK text will only appears if the font was loaded with the appropriate CJK character ranges. Call io.Font->LoadFromFileTTF() manually to load extra character ranges. Read misc/fonts/README.txt for details.");
                # imgui.text("Hiragana: \xe3\x81\x8b\xe3\x81\x8d\xe3\x81\x8f\xe3\x81\x91\xe3\x81\x93 (kakikukeko)"); // Normally we would use u8"blah blah" with the proper characters directly in the string.
                # imgui.text("Kanjis: \xe6\x97\xa5\xe6\x9c\xac\xe8\xaa\x9e (nihongo)");
                # static char buf[32] = "\xe6\x97\xa5\xe6\x9c\xac\xe8\xaa\x9e";
                # //static char buf[32] = u8"NIHONGO"; // <- this is how you would write it with C++11, using real kanjis
                # imgui.input_text("UTF-8 input", buf, IM_ARRAYSIZE(buf));

                imgui.tree_pop()
            imgui.tree_pop()

        if imgui.tree_node("Images"):
            io = imgui.get_io()
            imgui.text_wrapped(
                "Below we are displaying the font texture (which is the only texture we have access to in this demo). Use the 'ImTextureID' type as storage to pass pointers or identifier to your own texture data. Hover the texture for a zoomed view!"
            )

            #  Here we are grabbing the font texture because that's the only one we have access to inside the demo code.
            #  Remember that ImTextureID is just storage for whatever you want it to be, it is essentially a value that will be passed to the render function inside the ImDrawCmd structure.
            #  // If you use one of the default imgui_impl_XXXX.cpp renderer, they all have comments at the top of their file to specify what they expect to be stored in ImTextureID.
            # // (for example, the imgui_impl_dx11.cpp renderer expect a 'ID3D11ShaderResourceView*' pointer. The imgui_impl_glfw_gl3.cpp renderer expect a GLuint OpenGL texture identifier etc.)
            # // If you decided that ImTextureID = MyEngineTexture*, then you can pass your MyEngineTexture* pointers to imgui.image(), and gather width/height through your own functions, etc.
            # // Using ShowMetricsWindow() as a "debugger" to inspect the draw data that are being passed to your render will help you debug issues if you are confused about this.
            # // Consider using the lower-level ImDrawList::AddImage() API, via imgui.get_window_draw_list()->AddImage().
            my_tex_id = io.fonts.texture_id
            my_tex_w = float(io.fonts.texture_width)
            my_tex_h = float(io.fonts.texture_height)

            imgui.text(str(my_tex_w) + str(my_tex_h))
            pos = imgui.get_cursor_screen_pos()
            imgui.image(
                texture_id=my_tex_id,
                width=my_tex_w,
                height=my_tex_h,
                uv0=(0, 0),
                uv1=(1, 1),
                tint_color=(255, 255, 255, 255),
                border_color=(255, 255, 255, 128),
            )
            if imgui.is_item_hovered():
                imgui.begin_tooltip()
                region_sz = 32.0
                region_x = imgui.get_mouse_position().x - pos.x - region_sz * 0.5
                if region_x < 0.0:
                    region_x = 0.0
                elif region_x > my_tex_w - region_sz:
                    region_x = my_tex_w - region_sz
                region_y = imgui.get_mouse_position().y - pos.y - region_sz * 0.5
                if region_y < 0.0:
                    region_y = 0.0
                elif region_y > my_tex_h - region_sz:
                    region_y = my_tex_h - region_sz
                zoom = 4.0
                imgui.text("Min: (" + str(region_x) + ", " + str(region_y))
                imgui.text(
                    "Max: ("
                    + str(region_x + region_sz)
                    + ", "
                    + str(region_y + region_sz)
                )

                uv0 = ((region_x) / my_tex_w, (region_y) / my_tex_h)
                uv1 = (
                    (region_x + region_sz) / my_tex_w,
                    (region_y + region_sz) / my_tex_h,
                )
                imgui.image(
                    texture_id=my_tex_id,
                    width=region_sz * zoom,
                    height=region_sz * zoom,
                    uv0=uv0,
                    uv1=uv1,
                    tint_color=(255, 255, 255, 255),
                    border_color=(255, 255, 255, 128),
                )
                imgui.end_tooltip()

            imgui.text_wrapped("And now some textured buttons..")
            for i in range(8):
                imgui.push_id(str(i))
                frame_padding = -1 + i
                # -1 = uses default padding
                if imgui.image_button(
                    texture_id=my_tex_id,
                    width=32,
                    height=32,
                    uv0=(0, 0),
                    uv1=(32.0 / my_tex_w, 32.0 / my_tex_h),
                    tint_color=(0, 0, 0, 255),
                    frame_padding=frame_padding,
                ):
                    images_pressed_count += 1
                imgui.pop_id()
                imgui.same_line()

            imgui.new_line()
            imgui.text("Pressed " + str(images_pressed_count) + " times.")
            imgui.tree_pop()

        if imgui.tree_node("Combo"):

            # Expose flags as checkbox for the demo
            clicked, combo_flags = imgui.checkbox_flags(
                "ImGuiComboFlags_PopupAlignLeft",
                combo_flags,
                imgui.COMBO_POPUP_ALIGN_LEFT,
            )
            clicked, combo_flags = imgui.checkbox_flags(
                label="ImGuiComboFlags_NoArrowButton",
                flags=combo_flags,
                flags_value=imgui.COMBO_NO_ARROW_BUTTON,
            )

            if clicked:
                combo_flags &= (
                    ~imgui.COMBO_NO_PREVIEW
                )  # Clear the other flag, as we cannot combine both

            clicked, combo_flags = imgui.checkbox_flags(
                label="ImGuiComboFlags_NoPreview",
                flags=combo_flags,
                flags_value=imgui.COMBO_NO_PREVIEW,
            )
            if clicked:
                combo_flags &= (
                    ~imgui.COMBO_NO_ARROW_BUTTON
                )  # Clear the other flag, as we cannot combine both

            # // General BeginCombo() API, you have full control over your selection data and display type.
            # // (your selection data could be an index, a pointer to the object, an id for the object, a flag stored in the object itself, etc.)

            # TODO -- implement begin_combo/end_combo/combo, then uncomment the below
            # if imgui.begin_combo("combo 1", item_current, flags): # The second parameter is the label previewed before opening the combo.

            #     for n in combo_items:
            #         is_selected = (combo_item_current == combo_items[n])
            #         if imgui.selectable(items[n], is_selected):
            #             item_current = items[n];
            #         if is_selected:
            #             imgui.set_item_default_focus();   // Set the initial focus when opening the combo (scrolling + for keyboard navigation support in the upcoming navigation branch)
            #     imgui.end_combo();

            # // Simplified one-liner Combo() API, using values packed in a single constant string
            # static int item_current_2 = 0;
            # imgui.combo("combo 2 (one-liner)", &item_current_2, "aaaa\0bbbb\0cccc\0dddd\0eeee\0\0");

            # // Simplified one-liner Combo() using an array of const char*
            # static int item_current_3 = -1; // If the selection isn't within 0..count, Combo won't display a preview
            # imgui.combo("combo 3 (array)", &item_current_3, items, IM_ARRAYSIZE(items));

            # // Simplified one-liner Combo() using an accessor function
            # struct FuncHolder { static bool ItemGetter(void* data, int idx, const char** out_str) { *out_str = ((const char**)data)[idx]; return True; } };
            # static int item_current_4 = 0;
            # imgui.combo("combo 4 (function)", &item_current_4, &FuncHolder::ItemGetter, items, IM_ARRAYSIZE(items));

            imgui.tree_pop()

        if imgui.tree_node("Selectables"):

            # Selectable() has 2 overloads:
            #  The one taking "bool selected" as a read-only selection information. When Selectable() has been clicked is returns True and you can alter selection state accordingly.
            #  The one taking "bool* p_selected" as a read-write selection information (convenient in some cases)
            # The earlier is more flexible, as in real application your selection may be stored in a different manner (in flags within objects, as an external list, etc).

            if imgui.tree_node("Basic"):

                _, selectables_basic_selection[0] = imgui.selectable(
                    label="1. I am selectable", selected=selectables_basic_selection[0]
                )
                _, selectables_basic_selection[1] = imgui.selectable(
                    label="2. I am selectable", selected=selectables_basic_selection[1]
                )
                imgui.text("3. I am not selectable")
                _, selectables_basic_selection[3] = imgui.selectable(
                    label="4. I am selectable", selected=selectables_basic_selection[3]
                )
                clicked, selectables_basic_selection[4] = imgui.selectable(
                    label="5. I am double clickable",
                    selected=selectables_basic_selection[4],
                    flags=imgui.SELECTABLE_ALLOW_DOUBLE_CLICK,
                )
                if clicked:
                    if imgui.is_mouse_double_clicked(0):
                        selectables_basic_selection[
                            4
                        ] = not selectables_basic_selection[4]
                imgui.tree_pop()

            if imgui.tree_node("Selection State: Single Selection"):

                for n in range(5):
                    buf = "Object " + str(n)
                    clicked, _ = imgui.selectable(
                        label=buf, selected=(selectables_basic_selected == n)
                    )
                    if clicked:
                        selectables_basic_selected = n

                imgui.tree_pop()

            if imgui.tree_node("Selection State: Multiple Selection"):

                show_help_marker("Hold CTRL and click to select multiple items.")

                for n in range(5):

                    buf = "Object " + str(n)
                    clicked, selectables_basic_selection_2[n] = imgui.selectable(
                        label=buf, selected=selectables_basic_selection_2[n]
                    )
                    if clicked:
                        if (
                            not imgui.get_io().key_ctrl
                        ):  # Clear selection when CTRL is not held
                            selectables_basic_selection_2 = list(
                                map(lambda b: False, selectables_basic_selection_2)
                            )
                            selectables_basic_selection_2[n] = True

                imgui.tree_pop()

            if imgui.tree_node("Rendering more text into the same line"):

                #  Using the Selectable() override that takes "bool* p_selected" parameter and toggle your booleans automatically.
                clicked, selectables_basic_selected_2[0] = imgui.selectable(
                    label="main.c", selected=selectables_basic_selected_2[0]
                )
                imgui.same_line(300)
                imgui.text(" 2,345 bytes")
                clicked, selectables_basic_selected_2[1] = imgui.selectable(
                    label="Hello.cpp", selected=selectables_basic_selected_2[1]
                )
                imgui.same_line(300)
                imgui.text("12,345 bytes")
                clicked, selectables_basic_selected_2[2] = imgui.selectable(
                    label="Hello.h", selected=selectables_basic_selected_2[2]
                )
                imgui.same_line(300)
                imgui.text(" 2,345 bytes")
                imgui.tree_pop()

            if imgui.tree_node("In columns"):

                imgui.columns(count=3, identifier=None, border=False)
                for index in range(len(selectables_basic_selected_3)):
                    label = "Item " + str(index)
                    clicked, selectables_basic_selected_3[index] = imgui.selectable(
                        label=label, selected=selectables_basic_selected_3[index]
                    )
                    imgui.next_column()
                imgui.columns(1)
                imgui.tree_pop()

            if imgui.tree_node("Grid"):

                for index in range(len(selectables_basic_selected_4)):

                    imgui.push_id(str(index))
                    clicked, selectables_basic_selected_4[index] = imgui.selectable(
                        label="Sailor",
                        selected=selectables_basic_selected_4[index],
                        flags=0,
                        width=50,
                        height=50,
                    )
                    if clicked:

                        x = index % 4
                        y = index // 4
                        if x > 0:
                            selectables_basic_selected_4[
                                index - 1
                            ] = not selectables_basic_selected_4[index - 1]
                        if x < 3:
                            selectables_basic_selected_4[
                                index + 1
                            ] = not selectables_basic_selected_4[index + 1]
                        if y > 0:
                            selectables_basic_selected_4[
                                index - 4
                            ] = not selectables_basic_selected_4[index - 4]
                        if y < 3:
                            selectables_basic_selected_4[
                                index + 4
                            ] = not selectables_basic_selected_4[index + 4]
                    if (index % 4) < 3:
                        imgui.same_line()
                    imgui.pop_id()

                imgui.tree_pop()

            imgui.tree_pop()

        if imgui.tree_node("Filtered Text Input"):

            clicked, filtered_text_input_buf1 = imgui.input_text(
                label="default", value=filtered_text_input_buf1, buffer_length=64
            )
            clicked, filtered_text_input_buf2 = imgui.input_text(
                label="decimal",
                value=filtered_text_input_buf2,
                buffer_length=64,
                flags=imgui.INPUT_TEXT_CHARS_DECIMAL,
            )
            clicked, filtered_text_input_buf3 = imgui.input_text(
                label="hexadecimal",
                value=filtered_text_input_buf3,
                buffer_length=64,
                flags=imgui.INPUT_TEXT_CHARS_HEXADECIMAL
                | imgui.INPUT_TEXT_CHARS_UPPERCASE,
            )
            clicked, filtered_text_input_buf4 = imgui.input_text(
                label="uppercase",
                value=filtered_text_input_buf4,
                buffer_length=64,
                flags=imgui.INPUT_TEXT_CHARS_UPPERCASE,
            )
            clicked, filtered_text_input_buf5 = imgui.input_text(
                label="no blank",
                value=filtered_text_input_buf5,
                buffer_length=64,
                flags=imgui.INPUT_TEXT_CHARS_NO_BLANK,
            )

            # TODO - figure out how to make a lambda as a filter

            # struct TextFilters { static int FilterImGuiLetters(ImGuiInputTextCallbackData* data) { if (data->EventChar < 256 && strchr("imgui", (char)data->EventChar)) return 0;
            # return 1; } };
            # static char buf6[64] = "";
            # imgui.input_text("\"imgui\" letters", buf6, 64, ImGuiInputTextFlags_CallbackCharFilter, TextFilters::FilterImGuiLetters);

            imgui.text("Password input")
            clicked, filtered_text_input_buf_pass = imgui.input_text(
                label="password",
                value=filtered_text_input_buf_pass,
                buffer_length=64,
                flags=imgui.INPUT_TEXT_PASSWORD | imgui.INPUT_TEXT_CHARS_NO_BLANK,
            )
            imgui.same_line()
            show_help_marker(
                "Display all characters as '*'."
                + os.linesep
                + "Disable clipboard cut and copy."
                + os.linesep
                + "Disable logging."
                + os.linesep
            )
            imgui.input_text(
                label="password (clear)",
                value=filtered_text_input_buf_pass,
                buffer_length=64,
                flags=imgui.INPUT_TEXT_CHARS_NO_BLANK,
            )

            imgui.tree_pop()

        if imgui.tree_node("Multi-line Text Input"):

            show_help_marker(
                "You can use the ImGuiInputTextFlags_CallbackResize facility if you need to wire InputTextMultiline() to a dynamic string type. See misc/stl/imgui_stl.h for an example. (This is not demonstrated in imgui_demo.cpp)"
            )
            clicked, multi_line_text_input_read_only = imgui.checkbox(
                label="Read-only", state=multi_line_text_input_read_only
            )
            flags = imgui.INPUT_TEXT_ALLOW_TAB_INPUT | (
                imgui.INPUT_TEXT_READ_ONLY if multi_line_text_input_read_only else 0
            )
            changed, multi_line_text_input_text = imgui.input_text_multiline(
                label="##source",
                value=multi_line_text_input_text,
                buffer_length=1024 * 16,
                width=-1.0,
                height=imgui.get_text_line_height() * 16,
                flags=flags,
            )
            imgui.tree_pop()

        if imgui.tree_node("Plots Widgets"):

            clicked, plots_widgets_animate = imgui.checkbox(
                label="Animate", state=plots_widgets_animate
            )

            imgui.plot_lines(
                label="Frame Times",
                values=plots_widgets_array,
                values_count=len(plots_widgets_array),
            )

            # Create a dummy array of contiguous float values to plot
            # Tip: If your float aren't contiguous but part of a structure, you can pass a pointer to your first float and the sizeof() of your structure in the Stride parameter.
            if (not plots_widgets_animate) or plots_widgets_refresh_time == 0.0:
                plots_widgets_refresh_time = imgui.get_time()
                print(plots_widgets_refresh_time)

            while (
                plots_widgets_refresh_time < imgui.get_time()
            ):  # Create dummy data at fixed 60 hz rate for the demo
                plots_widgets_values[plots_widgets_offset] = math.cos(
                    plots_widgets_phase
                )
                plots_widgets_offset = (plots_widgets_offset + 1) % len(
                    plots_widgets_values
                )
                plots_widgets_phase += 0.10 * plots_widgets_offset
                plots_widgets_refresh_time += 1.0 / 60.0

            imgui.plot_lines(
                label="Lines",
                values=plots_widgets_values,
                values_count=len(plots_widgets_values),
                values_offset=plots_widgets_offset,
                overlay_text="avg 0.0",
                scale_min=-1.0,
                scale_max=1.0,
                graph_size=(0, 80),
            )

            imgui.plot_histogram(
                label="Histogram",
                values=plots_widgets_array,
                values_count=len(plots_widgets_array),
                values_offset=0,
                overlay_text=None,
                scale_min=0.0,
                scale_max=1.0,
                graph_size=(0, 80),
            )

            # // Use functions to generate output
            # TODO -- add this to core.pyx
            # // FIXME: This is rather awkward because current plot API only pass in indices. We probably want an API passing floats and user provide sample rate/count.
            # struct Funcs
            # {
            #     static float Sin(void*, int i) { return sinf(i * 0.1f); }
            #     static float Saw(void*, int i) { return (i & 1) ? 1.0f : -1.0f; }
            # };
            # static int func_type = 0, display_count = 70;
            # imgui.separator();
            # imgui.push_item_width(100#);
            # imgui.combo("func", &func_type, "Sin\0Saw\0");
            # imgui.pop_item_width();
            # imgui.same_line();
            # imgui.slider_int("Sample count", &display_count, 1, 400);
            # float (*func)(void*, int) = (func_type == 0) ? Funcs::Sin : Funcs::Saw;
            # imgui.plot_lines("Lines", func, NULL, display_count, 0, NULL, -1.0, 1.0, ImVec2(0,80));
            # imgui.plot_histogram("Histogram", func, NULL, display_count, 0, NULL, -1.0, 1.0, ImVec2(0,80));

            imgui.separator()

            # Animate a simple progress bar
            if plots_widgets_animate:
                plots_progress += plots_progress_dir * 0.4 * imgui.get_io().delta_time
            if plots_progress >= +1.1:
                plots_progress = +1.1
                plots_progress_dir *= -1.0

            if plots_progress <= -0.1:
                plots_progress = -0.1
                plots_progress_dir *= -1.0

            # // Typically we would use ImVec2(-1.0,0.0f) to use all available width, or ImVec2(width,0.0f) for a specified width. ImVec2(0.0,0.0f) uses ItemWidth.
            imgui.progress_bar(fraction=plots_progress, size=(0.0, 0.0))
            imgui.same_line(
                position=0.0, spacing=imgui.get_style().item_inner_spacing.x
            )
            imgui.text("Progress Bar")

            progress_saturated = (
                0.0
                if (plots_progress < 0.0)
                else (1.0 if plots_progress > 1.0 else plots_progress)
            )

            progress_text = str(progress_saturated * 1753) + "/" + "1753"
            imgui.progress_bar(
                fraction=plots_progress, size=(0.0, 0.0), overlay=progress_text
            )
            imgui.tree_pop()

        if imgui.tree_node("Color/Picker Widgets"):

            checked, color_picker_alpha_preview = imgui.checkbox(
                label="With Alpha Preview", state=color_picker_alpha_preview
            )
            checked, color_picker_alpha_half_preview = imgui.checkbox(
                label="With Half Alpha Preview", state=color_picker_alpha_half_preview
            )
            checked, color_picker_drag_and_drop = imgui.checkbox(
                label="With Drag and Drop", state=color_picker_drag_and_drop
            )
            checked, color_picker_options_menu = imgui.checkbox(
                label="With Options Menu", state=color_picker_options_menu
            )
            imgui.same_line()
            show_help_marker(
                "Right-click on the individual color widget to show options."
            )
            checked, color_picker_hdr = imgui.checkbox(
                label="With HDR", state=color_picker_hdr
            )
            imgui.same_line()
            show_help_marker(
                "Currently all this does is to lift the 0..1 limits on dragging widgets."
            )

            misc_flags = (
                (imgui.COLOR_EDIT_HDR
                if color_picker_hdr
                else 0)
                | (0 if color_picker_drag_and_drop else imgui.COLOR_EDIT_NO_DRAG_DROP)
                | (
                    imgui.COLOR_EDIT_ALPHA_PREVIEW_HALF
                    if color_picker_alpha_half_preview
                    else (
                        imgui.COLOR_EDIT_ALPHA_PREVIEW
                        if color_picker_alpha_preview
                        else 0
                    )
                )
                | (0 if color_picker_options_menu else imgui.COLOR_EDIT_NO_OPTIONS)
            )

            imgui.text("Color widget:")
            imgui.same_line()
            show_help_marker(
                "Click on the colored square to open a color picker."
                + os.linesep
                + "CTRL+click on individual component to input value."
                + os.linesep
            )
            changed, color_picker_color = imgui.color_edit3(
                "MyColor##1", *color_picker_color[:3], misc_flags
            )

            imgui.text("Color widget HSV with Alpha:")
            changed, color_picker_color = imgui.color_edit4("MyColor##2", *color_picker_color, imgui.COLOR_EDIT_HSV  | misc_flags)

            imgui.text("Color widget with Float Display:");
            changed, color_picker_color = imgui.color_edit4("MyColor##2f", *color_picker_color, imgui.COLOR_EDIT_FLOAT | misc_flags)

            # imgui.text("Color button with Picker:");
            # imgui.same_line();
            # show_help_marker("With the ImGuiColorEditFlags_NoInputs flag you can hide all the slider/text inputs.\nWith the ImGuiColorEditFlags_NoLabel flag you can pass a non-empty label which will only be used for the tooltip and picker popup.");
            # imgui.color_edit4("MyColor##3", (float*)&color, ImGuiColorEditFlags_NoInputs | ImGuiColorEditFlags_NoLabel | misc_flags);

            # imgui.text("Color button with Custom Picker Popup:");

            # // Generate a dummy palette
            # static bool saved_palette_inited = False;
            # static ImVec4 saved_palette[32];
            # if !saved_palette_inited:
            #     for (int n = 0; n < IM_ARRAYSIZE(saved_palette); n++)
            #     {
            #         imgui.color_convert_h_s_vto_r_g_b(n / 31.0, 0.8, 0.8, saved_palette[n].x, saved_palette[n].y, saved_palette[n].z);
            #         saved_palette[n].w = 1.0f; // Alpha
            #     }
            # saved_palette_inited = True;

            # static ImVec4 backup_color;
            # bool open_popup = imgui.color_button("MyColor##3b", color, misc_flags);
            # imgui.same_line();
            # open_popup |= imgui.button(label="Palette");
            # if open_popup:
            # {
            #     imgui.open_popup("mypicker");
            #     backup_color = color;
            # }
            # if imgui.begin_popup("mypicker"):
            # {
            #     // FIXME: Adding a drag and drop example here would be perfect!
            #     imgui.text("MY CUSTOM COLOR PICKER WITH AN AMAZING PALETTE!");
            #     imgui.separator();
            #     imgui.color_picker4("##picker", (float*)&color, misc_flags | ImGuiColorEditFlags_NoSidePreview | ImGuiColorEditFlags_NoSmallPreview);
            #     imgui.same_line();
            #     imgui.begin_group();
            #     imgui.text("Current");
            #     imgui.color_button("##current", color, ImGuiColorEditFlags_NoPicker | ImGuiColorEditFlags_AlphaPreviewHalf, ImVec2(60,40));
            #     imgui.text("Previous");
            #     if imgui.color_button("##previous", backup_color, ImGuiColorEditFlags_NoPicker | ImGuiColorEditFlags_AlphaPreviewHalf, ImVec2(60,40)):
            #         color = backup_color;
            #     imgui.separator();
            #     imgui.text("Palette");
            #     for (int n = 0; n < IM_ARRAYSIZE(saved_palette); n++)
            #     {
            #         imgui.push_id(str(n));
            #         if (n % 8) != 0:
            #             imgui.same_line(0.0, imgui.get_style().ItemSpacing.y);
            #         if imgui.color_button("##palette", saved_palette[n], ImGuiColorEditFlags_NoAlpha | ImGuiColorEditFlags_NoPicker | ImGuiColorEditFlags_NoTooltip, ImVec2(20,20)):
            #             color = ImVec4(saved_palette[n].x, saved_palette[n].y, saved_palette[n].z, color.w); // Preserve alpha!

            #         if imgui.begin_drag_drop_target():
            #         {
            #             if const ImGuiPayload* payload = AcceptDragDropPayload(IMGUI_PAYLOAD_TYPE_COLOR_3F):
            #                 memcpy((float*)&saved_palette[n], payload->Data, sizeof(float) * 3);
            #             if const ImGuiPayload* payload = AcceptDragDropPayload(IMGUI_PAYLOAD_TYPE_COLOR_4F):
            #                 memcpy((float*)&saved_palette[n], payload->Data, sizeof(float) * 4);
            #             EndDragDropTarget();
            #         }

            #         imgui.pop_id();
            #     }
            #     imgui.end_group();
            #     imgui.end_popup();
            # }

            # imgui.text("Color button only:");
            # imgui.color_button("MyColor##3c", *(ImVec4*)&color, misc_flags, ImVec2(80,80));

            # imgui.text("Color picker:");
            # static bool alpha = True;
            # static bool alpha_bar = True;
            # static bool side_preview = True;
            # static bool ref_color = False;
            # static ImVec4 ref_color_v(1.0,0.0,1.0,0.5);
            # static int inputs_mode = 2;
            # static int picker_mode = 0;
            # imgui.checkbox(label="With Alpha", state=&alpha);
            # imgui.checkbox(label="With Alpha Bar", state=&alpha_bar);
            # imgui.checkbox(label="With Side Preview", state=&side_preview);
            # if side_preview:
            # {
            #     imgui.same_line();
            #     imgui.checkbox(label="With Ref Color", state=&ref_color);
            #     if ref_color:
            #     {
            #         imgui.same_line();
            #         imgui.color_edit4("##RefColor", &ref_color_v.x, ImGuiColorEditFlags_NoInputs | misc_flags);
            #     }
            # }
            # imgui.combo("Inputs Mode", &inputs_mode, "All Inputs\0No Inputs\0RGB Input\0HSV Input\0HEX Input\0");
            # imgui.combo("Picker Mode", &picker_mode, "Auto/Current\0Hue bar + SV rect\0Hue wheel + SV triangle\0");
            # imgui.same_line();
            # show_help_marker("User can right-click the picker to change mode.");
            # ImGuiColorEditFlags flags = misc_flags;
            # if !alpha: flags |= ImGuiColorEditFlags_NoAlpha;
            # // This is by default if you call ColorPicker3() instead of ColorPicker4()
            # if alpha_bar: flags |= ImGuiColorEditFlags_AlphaBar;
            # if !side_preview: flags |= ImGuiColorEditFlags_NoSidePreview;
            # if picker_mode == 1: flags |= ImGuiColorEditFlags_PickerHueBar;
            # if picker_mode == 2: flags |= ImGuiColorEditFlags_PickerHueWheel;
            # if inputs_mode == 1: flags |= ImGuiColorEditFlags_NoInputs;
            # if inputs_mode == 2: flags |= ImGuiColorEditFlags_RGB;
            # if inputs_mode == 3: flags |= ImGuiColorEditFlags_HSV;
            # if inputs_mode == 4: flags |= ImGuiColorEditFlags_HEX;
            # imgui.color_picker4("MyColor##4", (float*)&color, flags, ref_color ? &ref_color_v.x : NULL);

            # imgui.text("Programmatically set defaults:");
            # imgui.same_line();
            # show_help_marker("SetColorEditOptions() is designed to allow you to set boot-time default.\nWe don't have Push/Pop functions because you can force options on a per-widget basis if needed, and the user can change non-forced ones with the options menu.\nWe don't have a getter to avoid encouraging you to persistently save values that aren't forward-compatible.");
            # if imgui.button(label="Default: Uint8 + HSV + Hue Bar"):
            #     imgui.set_color_edit_options(ImGuiColorEditFlags_Uint8 | ImGuiColorEditFlags_HSV | ImGuiColorEditFlags_PickerHueBar);
            # if imgui.button(label="Default: Float + HDR + Hue Wheel"):
            #     imgui.set_color_edit_options(ImGuiColorEditFlags_Float | ImGuiColorEditFlags_HDR | ImGuiColorEditFlags_PickerHueWheel);

            imgui.tree_pop()

        if imgui.tree_node("Range Widgets"):

            # TODO - this should call drag_float_range2 instead, so implement it and do it
            # changed, (range_widgets_begin, range_widgets_end) = imgui.drag_float2(label="range",
            #                   value0=range_widgets_begin,
            #                   value1=range_widgets_end,
            #                   change_speed=0.25,
            #                   min_value=0.0,
            #                   max_value=100.0,
            #                   format="Min: %.1f %% Max: %.1f %% %.1f")
            # imgui.drag_int_range2("range int (no bounds)", &begin_i, &end_i, 5, 0, 0, "Min: %d units", "Max: %d units");
            imgui.tree_pop()

        if imgui.tree_node("Data Types"):

            # // The DragScalar/InputScalar/SliderScalar functions allow various data types: signed/unsigned int/long long and float/double
            # // To avoid polluting the public API with all possible combinations, we use the ImGuiDataType enum to pass the type,
            # // and passing all arguments by address.
            # // This is the reason the test code below creates local variables to hold "zero" "one" etc. for each types.
            # // In practice, if you frequently use a given type that is not covered by the normal API entry points, you can wrap it
            # // yourself inside a 1 line function which can take typed argument as value instead of void*, and then pass their address
            # // to the generic function. For example:
            # //   bool MySliderU64(const char *label, u64* value, u64 min = 0, u64 max = 0, const char* format = "%lld")
            # //   {
            # //      return SliderScalar(label, ImGuiDataType_U64, value, &min, &max, format);
            # //   }

            # // Limits (as helper variables that we can take the address of)
            # // Note that the SliderScalar function has a maximum usable range of half the natural type maximum, hence the /2 below.
            # #ifndef LLONG_MIN
            # ImS64 LLONG_MIN = -9223372036854775807LL - 1;
            # ImS64 LLONG_MAX = 9223372036854775807LL;
            # ImU64 ULLONG_MAX = (2ULL * 9223372036854775807LL + 1);
            # #endif
            # const ImS32   s32_zero = 0,   s32_one = 1,   s32_fifty = 50, s32_min = INT_MIN/2,   s32_max = INT_MAX/2,    s32_hi_a = INT_MAX/2 - 100,    s32_hi_b = INT_MAX/2;
            # const ImU32   u32_zero = 0,   u32_one = 1,   u32_fifty = 50, u32_min = 0,           u32_max = UINT_MAX/2,   u32_hi_a = UINT_MAX/2 - 100,   u32_hi_b = UINT_MAX/2;
            # const ImS64   s64_zero = 0,   s64_one = 1,   s64_fifty = 50, s64_min = LLONG_MIN/2, s64_max = LLONG_MAX/2,  s64_hi_a = LLONG_MAX/2 - 100,  s64_hi_b = LLONG_MAX/2;
            # const ImU64   u64_zero = 0,   u64_one = 1,   u64_fifty = 50, u64_min = 0,           u64_max = ULLONG_MAX/2, u64_hi_a = ULLONG_MAX/2 - 100, u64_hi_b = ULLONG_MAX/2;
            # const float   f32_zero = 0.0, f32_one = 1., f32_lo_a = -10000000000.0, f32_hi_a = +10000000000.0f;
            # const double  f64_zero = 0.,  f64_one = 1.,  f64_lo_a = -1000000000000000.0, f64_hi_a = +1000000000000000.0;

            # // State
            # static ImS32  s32_v = -1;
            # static ImU32  u32_v = (ImU32)-1;
            # static ImS64  s64_v = -1;
            # static ImU64  u64_v = (ImU64)-1;
            # static float  f32_v = 0.123f;
            # static double f64_v = 90000.01234567890123456789;

            # const float drag_speed = 0.2f;
            # static bool drag_clamp = False;
            # imgui.text("Drags:");
            # imgui.checkbox(label="Clamp integers to 0..50", state=&drag_clamp);
            # imgui.same_line();
            # show_help_marker("As with every widgets in dear imgui, we never modify values unless there is a user interaction.\nYou can override the clamping limits by using CTRL+Click to input a value.");
            # imgui.drag_scalar("drag s32",       ImGuiDataType_S32,    &s32_v, drag_speed, drag_clamp ? &s32_zero : NULL, drag_clamp ? &s32_fifty : NULL);
            # imgui.drag_scalar("drag u32",       ImGuiDataType_U32,    &u32_v, drag_speed, drag_clamp ? &u32_zero : NULL, drag_clamp ? &u32_fifty : NULL, "%u ms");
            # imgui.drag_scalar("drag s64",       ImGuiDataType_S64,    &s64_v, drag_speed, drag_clamp ? &s64_zero : NULL, drag_clamp ? &s64_fifty : NULL);
            # imgui.drag_scalar("drag u64",       ImGuiDataType_U64,    &u64_v, drag_speed, drag_clamp ? &u64_zero : NULL, drag_clamp ? &u64_fifty : NULL);
            # imgui.drag_scalar("drag float",     ImGuiDataType_Float,  &f32_v, 0.005,  &f32_zero, &f32_one, "%f", 1.0f);
            # imgui.drag_scalar("drag float ^2",  ImGuiDataType_Float,  &f32_v, 0.005,  &f32_zero, &f32_one, "%f", 2.0f);
            # imgui.same_line();
            # show_help_marker("You can use the 'power' parameter to increase tweaking precision on one side of the range.");
            # imgui.drag_scalar("drag double",    ImGuiDataType_Double, &f64_v, 0.0005, &f64_zero, NULL,     "%.10f grams", 1.0f);
            # imgui.drag_scalar("drag double ^2", ImGuiDataType_Double, &f64_v, 0.0005, &f64_zero, &f64_one, "0 < %.10f < 1", 2.0f);

            # imgui.text("Sliders");
            # imgui.slider_scalar("slider s32 low",     ImGuiDataType_S32,    &s32_v, &s32_zero, &s32_fifty,"%d");
            # imgui.slider_scalar("slider s32 high",    ImGuiDataType_S32,    &s32_v, &s32_hi_a, &s32_hi_b, "%d");
            # imgui.slider_scalar("slider s32 full",    ImGuiDataType_S32,    &s32_v, &s32_min,  &s32_max,  "%d");
            # imgui.slider_scalar("slider u32 low",     ImGuiDataType_U32,    &u32_v, &u32_zero, &u32_fifty,"%u");
            # imgui.slider_scalar("slider u32 high",    ImGuiDataType_U32,    &u32_v, &u32_hi_a, &u32_hi_b, "%u");
            # imgui.slider_scalar("slider u32 full",    ImGuiDataType_U32,    &u32_v, &u32_min,  &u32_max,  "%u");
            # imgui.slider_scalar("slider s64 low",     ImGuiDataType_S64,    &s64_v, &s64_zero, &s64_fifty,"%I64d");
            # imgui.slider_scalar("slider s64 high",    ImGuiDataType_S64,    &s64_v, &s64_hi_a, &s64_hi_b, "%I64d");
            # imgui.slider_scalar("slider s64 full",    ImGuiDataType_S64,    &s64_v, &s64_min,  &s64_max,  "%I64d");
            # imgui.slider_scalar("slider u64 low",     ImGuiDataType_U64,    &u64_v, &u64_zero, &u64_fifty,"%I64u ms");
            # imgui.slider_scalar("slider u64 high",    ImGuiDataType_U64,    &u64_v, &u64_hi_a, &u64_hi_b, "%I64u ms");
            # imgui.slider_scalar("slider u64 full",    ImGuiDataType_U64,    &u64_v, &u64_min,  &u64_max,  "%I64u ms");
            # imgui.slider_scalar("slider float low",   ImGuiDataType_Float,  &f32_v, &f32_zero, &f32_one);
            # imgui.slider_scalar("slider float low^2", ImGuiDataType_Float,  &f32_v, &f32_zero, &f32_one,  "%.10f", 2.0f);
            # imgui.slider_scalar("slider float high",  ImGuiDataType_Float,  &f32_v, &f32_lo_a, &f32_hi_a, "%e");
            # imgui.slider_scalar("slider double low",  ImGuiDataType_Double, &f64_v, &f64_zero, &f64_one,  "%.10f grams", 1.0f);
            # imgui.slider_scalar("slider double low^2",ImGuiDataType_Double, &f64_v, &f64_zero, &f64_one,  "%.10f", 2.0f);
            # imgui.slider_scalar("slider double high", ImGuiDataType_Double, &f64_v, &f64_lo_a, &f64_hi_a, "%e grams", 1.0f);

            # static bool inputs_step = True;
            # imgui.text("Inputs");
            # imgui.checkbox(label="Show step buttons", state=&inputs_step);
            # imgui.input_scalar("input s32",     ImGuiDataType_S32,    &s32_v, inputs_step ? &s32_one : NULL, NULL, "%d");
            # imgui.input_scalar("input s32 hex", ImGuiDataType_S32,    &s32_v, inputs_step ? &s32_one : NULL, NULL, "%08X", ImGuiInputTextFlags_CharsHexadecimal);
            # imgui.input_scalar("input u32",     ImGuiDataType_U32,    &u32_v, inputs_step ? &u32_one : NULL, NULL, "%u");
            # imgui.input_scalar("input u32 hex", ImGuiDataType_U32,    &u32_v, inputs_step ? &u32_one : NULL, NULL, "%08X", ImGuiInputTextFlags_CharsHexadecimal);
            # imgui.input_scalar("input s64",     ImGuiDataType_S64,    &s64_v, inputs_step ? &s64_one : NULL);
            # imgui.input_scalar("input u64",     ImGuiDataType_U64,    &u64_v, inputs_step ? &u64_one : NULL);
            # imgui.input_scalar("input float",   ImGuiDataType_Float,  &f32_v, inputs_step ? &f32_one : NULL);
            # imgui.input_scalar("input double",  ImGuiDataType_Double, &f64_v, inputs_step ? &f64_one : NULL);

            imgui.tree_pop()

        if imgui.tree_node("Multi-component Widgets"):

            changed, (
                multi_component_vec4f[0],
                multi_component_vec4f[1],
            ) = imgui.input_float2(
                label="input float2",
                value0=multi_component_vec4f[0],
                value1=multi_component_vec4f[1],
            )
            changed, (
                multi_component_vec4f[0],
                multi_component_vec4f[1],
            ) = imgui.drag_float2(
                label="drag float2",
                value0=multi_component_vec4f[0],
                value1=multi_component_vec4f[1],
                change_speed=0.01,
                min_value=0.0,
                max_value=1.0,
            )
            changed, (
                multi_component_vec4f[0],
                multi_component_vec4f[1],
            ) = imgui.slider_float2(
                label="slider float2",
                value0=multi_component_vec4f[0],
                value1=multi_component_vec4f[1],
                min_value=0.0,
                max_value=1.0,
            )

            changed, (
                multi_component_vec4i[0],
                multi_component_vec4i[1],
            ) = imgui.input_int2(
                label="input int2",
                value0=multi_component_vec4i[0],
                value1=multi_component_vec4i[1],
            )
            changed, (
                multi_component_vec4i[0],
                multi_component_vec4i[1],
            ) = imgui.drag_int2(
                label="drag int2",
                value0=multi_component_vec4i[0],
                value1=multi_component_vec4i[1],
                change_speed=1,
                min_value=0,
                max_value=255,
            )
            changed, (
                multi_component_vec4i[0],
                multi_component_vec4i[1],
            ) = imgui.slider_int2(
                label="slider int2",
                value0=multi_component_vec4i[0],
                value1=multi_component_vec4i[1],
                min_value=0,
                max_value=255,
            )
            imgui.spacing()

            changed, (
                multi_component_vec4f[0],
                multi_component_vec4f[1],
                multi_component_vec4f[2],
            ) = imgui.input_float3(
                label="input float3",
                value0=multi_component_vec4f[0],
                value1=multi_component_vec4f[1],
                value2=multi_component_vec4f[2],
            )
            changed, (
                multi_component_vec4f[0],
                multi_component_vec4f[1],
                multi_component_vec4f[2],
            ) = imgui.drag_float3(
                label="drag float3",
                value0=multi_component_vec4f[0],
                value1=multi_component_vec4f[1],
                value2=multi_component_vec4f[2],
                change_speed=0.01,
                min_value=0.0,
                max_value=1.0,
            )
            changed, (
                multi_component_vec4f[0],
                multi_component_vec4f[1],
                multi_component_vec4f[2],
            ) = imgui.slider_float3(
                label="slider float3",
                value0=multi_component_vec4f[0],
                value1=multi_component_vec4f[1],
                value2=multi_component_vec4f[2],
                min_value=0.0,
                max_value=1.0,
            )
            changed, (
                multi_component_vec4i[0],
                multi_component_vec4i[1],
                multi_component_vec4i[2],
            ) = imgui.input_int3(
                label="input int3",
                value0=multi_component_vec4i[0],
                value1=multi_component_vec4i[1],
                value2=multi_component_vec4i[2],
            )
            changed, (
                multi_component_vec4i[0],
                multi_component_vec4i[1],
                multi_component_vec4i[2],
            ) = imgui.drag_int3(
                label="drag int3",
                value0=multi_component_vec4i[0],
                value1=multi_component_vec4i[1],
                value2=multi_component_vec4i[2],
                change_speed=1,
                min_value=0,
                max_value=255,
            )
            changed, (
                multi_component_vec4i[0],
                multi_component_vec4i[1],
                multi_component_vec4i[2],
            ) = imgui.slider_int3(
                label="slider int3",
                value0=multi_component_vec4i[0],
                value1=multi_component_vec4i[1],
                value2=multi_component_vec4i[2],
                min_value=0,
                max_value=255,
            )
            imgui.spacing()

            changed, (
                multi_component_vec4f[0],
                multi_component_vec4f[1],
                multi_component_vec4f[2],
                multi_component_vec4f[3],
            ) = imgui.input_float4(
                label="input float4",
                value0=multi_component_vec4f[0],
                value1=multi_component_vec4f[1],
                value2=multi_component_vec4f[2],
                value3=multi_component_vec4f[3],
            )
            changed, (
                multi_component_vec4f[0],
                multi_component_vec4f[1],
                multi_component_vec4f[2],
                multi_component_vec4f[3],
            ) = imgui.drag_float4(
                label="drag float4",
                value0=multi_component_vec4f[0],
                value1=multi_component_vec4f[1],
                value2=multi_component_vec4f[2],
                value3=multi_component_vec4f[3],
                change_speed=0.01,
                min_value=0.0,
                max_value=1.0,
            )
            changed, (
                multi_component_vec4f[0],
                multi_component_vec4f[1],
                multi_component_vec4f[2],
                multi_component_vec4f[3],
            ) = imgui.slider_float4(
                label="slider float4",
                value0=multi_component_vec4f[0],
                value1=multi_component_vec4f[1],
                value2=multi_component_vec4f[2],
                value3=multi_component_vec4f[3],
                min_value=0.0,
                max_value=1.0,
            )
            changed, (
                multi_component_vec4i[0],
                multi_component_vec4i[1],
                multi_component_vec4i[2],
                multi_component_vec4i[3],
            ) = imgui.input_int4(
                label="input int4",
                value0=multi_component_vec4i[0],
                value1=multi_component_vec4i[1],
                value2=multi_component_vec4i[2],
                value3=multi_component_vec4i[3],
            )
            changed, (
                multi_component_vec4i[0],
                multi_component_vec4i[1],
                multi_component_vec4i[2],
                multi_component_vec4i[3],
            ) = imgui.drag_int4(
                label="drag int4",
                value0=multi_component_vec4i[0],
                value1=multi_component_vec4i[1],
                value2=multi_component_vec4i[2],
                value3=multi_component_vec4i[3],
                change_speed=1,
                min_value=0,
                max_value=255,
            )
            changed, (
                multi_component_vec4i[0],
                multi_component_vec4i[1],
                multi_component_vec4i[2],
                multi_component_vec4i[3],
            ) = imgui.slider_int4(
                label="slider int4",
                value0=multi_component_vec4i[0],
                value1=multi_component_vec4i[1],
                value2=multi_component_vec4i[2],
                value3=multi_component_vec4i[3],
                min_value=0,
                max_value=255,
            )

            imgui.tree_pop()

        if imgui.tree_node("Vertical Sliders"):

            # const float spacing = 4;
            # imgui.push_style_var(ImGuiStyleVar_ItemSpacing, ImVec2(spacing, spacing));

            # static int int_value = 0;
            # imgui.v_slider_int("##int", ImVec2(18,160), &int_value, 0, 5);
            # imgui.same_line();

            # static float values[7] = { 0.0, 0.60, 0.35, 0.9, 0.70, 0.20, 0.0 };
            # imgui.push_id(str("set1"));
            # for (int i = 0; i < 7; i++)
            # {
            #     if i > 0: imgui.same_line();
            #     imgui.push_id(str(i));
            #     imgui.push_style_color(ImGuiCol_FrameBg, (ImVec4)ImColor::HSV(i/7.0, 0.5, 0.5));
            #     imgui.push_style_color(ImGuiCol_FrameBgHovered, (ImVec4)ImColor::HSV(i/7.0, 0.6, 0.5));
            #     imgui.push_style_color(ImGuiCol_FrameBgActive, (ImVec4)ImColor::HSV(i/7.0, 0.7, 0.5));
            #     imgui.push_style_color(ImGuiCol_SliderGrab, (ImVec4)ImColor::HSV(i/7.0, 0.9, 0.9));
            #     imgui.v_slider_float("##v", ImVec2(18,160), &values[i], 0.0, 1.0, "");
            #     if imgui.is_item_active() || imgui.is_item_hovered():
            #         imgui.set_tooltip("%.3f", values[i]);
            #     imgui.pop_style_color(4);
            #     imgui.pop_id();
            # }
            # imgui.pop_id();

            # imgui.same_line();
            # imgui.push_id(str("set2"));
            # static float values2[4] = { 0.20, 0.80, 0.40, 0.25 };
            # const int rows = 3;
            # const ImVec2 small_slider_size(18, (160.0f-(rows-1)*spacing)/rows);
            # for (int nx = 0; nx < 4; nx++)
            # {
            #     if nx > 0: imgui.same_line();
            #     imgui.begin_group();
            #     for (int ny = 0; ny < rows; ny++)
            #     {
            #         imgui.push_id(str(nx*rows+ny));
            #         imgui.v_slider_float("##v", small_slider_size, &values2[nx], 0.0, 1.0, "");
            #         if imgui.is_item_active() || imgui.is_item_hovered():
            #             imgui.set_tooltip("%.3f", values2[nx]);
            #         imgui.pop_id();
            #     }
            #     imgui.end_group();
            # }
            # imgui.pop_id();

            # imgui.same_line();
            # imgui.push_id(str("set3"));
            # for (int i = 0; i < 4; i++)
            # {
            #     if i > 0: imgui.same_line();
            #     imgui.push_id(str(i));
            #     imgui.push_style_var(ImGuiStyleVar_GrabMinSize, 40);
            #     imgui.v_slider_float("##v", ImVec2(40,160), &values[i], 0.0, 1.0, "%.2f\nsec");
            #     imgui.pop_style_var();
            #     imgui.pop_id();
            # }
            # imgui.pop_id();
            # imgui.pop_style_var();
            imgui.tree_pop()

        if imgui.tree_node("Drag and Drop"):

            # {
            #     // ColorEdit widgets automatically act as drag source and drag target.
            #     // They are using standardized payload strings IMGUI_PAYLOAD_TYPE_COLOR_3F and IMGUI_PAYLOAD_TYPE_COLOR_4F to allow your own widgets
            #     // to use colors in their drag and drop interaction. Also see the demo in Color Picker -> Palette demo.
            #     imgui.bullet_text("Drag and drop in standard widgets");
            #     imgui.indent();
            #     static float col1[3] = { 1.0,0.0,0.2 };
            #     static float col2[4] = { 0.4,0.7,0.0,0.5f };
            #     imgui.color_edit3("color 1", col1);
            #     imgui.color_edit4("color 2", col2);
            #     imgui.unindent();
            # }

            # {
            #     imgui.bullet_text("Drag and drop to copy/swap items");
            #     imgui.indent();
            #     enum Mode
            #     {
            #         Mode_Copy,
            #         Mode_Move,
            #         Mode_Swap
            #     };
            #     static int mode = 0;
            #     if imgui.radio_button("Copy", mode == Mode_Copy):
            #           { mode = Mode_Copy;
            #     }
            #     imgui.same_line();
            #     if imgui.radio_button("Move", mode == Mode_Move))
            #        { mode = Mode_Move;
            #        }
            #     imgui.same_line();
            #     if imgui.radio_button("Swap", mode == Mode_Swap):
            #       { mode = Mode_Swap;
            #       }
            #     static const char* names[9] = { "Bobby", "Beatrice", "Betty", "Brianna", "Barry", "Bernard", "Bibi", "Blaine", "Bryn" };
            #     for (int n = 0; n < IM_ARRAYSIZE(names); n++)
            #     {
            #         imgui.push_id(str(n));
            #         if (n % 3) != 0:
            #             imgui.same_line();
            #         imgui.button(label=names[n], ImVec2(60,60));

            #         // Our buttons are both drag sources and drag targets here!
            #         if imgui.begin_drag_drop_source(ImGuiDragDropFlags_None):
            #         {
            #             imgui.set_drag_drop_payload("DND_DEMO_CELL", &n, sizeof(int));        // Set payload to carry the index of our item (could be anything)
            #             if (mode == Mode_Copy) { imgui.text("Copy %s", names[n]); }        // Display preview (could be anything, e.g. when dragging an image we could decide to display the filename and a small preview of the image, etc.)
            #             if (mode == Mode_Move) { imgui.text("Move %s", names[n]); }
            #             if (mode == Mode_Swap) { imgui.text("Swap %s", names[n]); }
            #             imgui.end_drag_drop_source();
            #         }
            #         if imgui.begin_drag_drop_target():
            #         {
            #             if const ImGuiPayload* payload = imgui.accept_drag_drop_payload("DND_DEMO_CELL"):
            #             {
            #                 IM_ASSERT(payload->DataSize == sizeof(int));
            #                 int payload_n = *(const int*)payload->Data;
            #                 if mode == Mode_Copy:
            #                 {
            #                     names[n] = names[payload_n];
            #                 }
            #                 if mode == Mode_Move:
            #                 {
            #                     names[n] = names[payload_n];
            #                     names[payload_n] = "";
            #                 }
            #                 if mode == Mode_Swap:
            #                 {
            #                     const char* tmp = names[n];
            #                     names[n] = names[payload_n];
            #                     names[payload_n] = tmp;
            #                 }
            #             }
            #             imgui.end_drag_drop_target();
            #         }
            #         imgui.pop_id();
            #     }
            #     imgui.unindent();
            # }

            imgui.tree_pop()

        if imgui.tree_node("Querying Status (Active/Focused/Hovered etc.)"):

            # // Display the value of IsItemHovered() and other common item state functions. Note that the flags can be combined.
            # // (because BulletText is an item itself and that would affect the output of IsItemHovered() we pass all state in a single call to simplify the code).
            # static int item_type = 1;
            # static bool b = False;
            # static float col4f[4] = { 1.0, 0.5, 0.0, 1.0f };
            # imgui.radio_button("Text", &item_type, 0);
            # imgui.radio_button("Button", &item_type, 1);
            # imgui.radio_button("CheckBox", &item_type, 2);
            # imgui.radio_button("SliderFloat", &item_type, 3);
            # imgui.radio_button("ColorEdit4", &item_type, 4);
            # imgui.radio_button("ListBox", &item_type, 5);
            # imgui.separator();
            # bool ret = False;
            # if item_type == 0: { imgui.text("ITEM: Text"); }                                              // Testing text items with no identifier/interaction
            # if item_type == 1: { ret = imgui.button(label="ITEM: Button"); }                                    // Testing button
            # if item_type == 2: { ret = imgui.checkbox(label="ITEM: CheckBox", state=&b); }                            // Testing checkbox
            # if item_type == 3: { ret = imgui.slider_float("ITEM: SliderFloat", &col4f[0], 0.0, 1.0f); }   // Testing basic item
            # if item_type == 4: { ret = imgui.color_edit4("ITEM: ColorEdit4", col4f); }                     // Testing multi-component items (IsItemXXX flags are reported merged)
            # if item_type == 5: { const char* items[] = { "Apple", "Banana", "Cherry", "Kiwi" }
            # ; static int current = 1;
            # ret = imgui.list_box("ITEM: ListBox", &current, items, IM_ARRAYSIZE(items), IM_ARRAYSIZE(items)); }
            # imgui.bullet_text(
            #     "Return value = %d\n"
            #     "IsItemFocused() = %d\n"
            #     "IsItemHovered() = %d\n"
            #     "IsItemHovered(_AllowWhenBlockedByPopup) = %d\n"
            #     "IsItemHovered(_AllowWhenBlockedByActiveItem) = %d\n"
            #     "IsItemHovered(_AllowWhenOverlapped) = %d\n"
            #     "IsItemHovered(_RectOnly) = %d\n"
            #     "IsItemActive() = %d\n"
            #     "IsItemEdited() = %d\n"
            #     "IsItemDeactivated() = %d\n"
            #     "IsItemDeactivatedEdit() = %d\n"
            #     "IsItemVisible() = %d\n"
            #     "GetItemRectMin() = (%.1f, %.1f)\n"
            #     "GetItemRectMax() = (%.1f, %.1f)\n"
            #     "GetItemRectSize() = (%.1f, %.1f)",
            #     ret,
            #     imgui.is_item_focused(),
            #     imgui.is_item_hovered(),
            #     imgui.is_item_hovered(ImGuiHoveredFlags_AllowWhenBlockedByPopup),
            #     imgui.is_item_hovered(ImGuiHoveredFlags_AllowWhenBlockedByActiveItem),
            #     imgui.is_item_hovered(ImGuiHoveredFlags_AllowWhenOverlapped),
            #     imgui.is_item_hovered(ImGuiHoveredFlags_RectOnly),
            #     imgui.is_item_active(),
            #     imgui.is_item_edited(),
            #     imgui.is_item_deactivated(),
            #     imgui.is_item_deactivated_after_edit(),
            #     imgui.is_item_visible(),
            #     imgui.get_item_rect_min().x, imgui.get_item_rect_min().y,
            #     imgui.get_item_rect_max().x, imgui.get_item_rect_max().y,
            #     imgui.get_item_rect_size().x, imgui.get_item_rect_size().y
            # );

            # static bool embed_all_inside_a_child_window = False;
            # imgui.checkbox(label="Embed everything inside a child window (for additional testing)", state=&embed_all_inside_a_child_window);
            # if embed_all_inside_a_child_window:
            #     imgui.begin_child("outer_child", ImVec2(0, imgui.get_font_size() * 20), True);

            # // Testing IsWindowFocused() function with its various flags. Note that the flags can be combined.
            # imgui.bullet_text(
            #     "IsWindowFocused() = %d\n"
            #     "IsWindowFocused(_ChildWindows) = %d\n"
            #     "IsWindowFocused(_ChildWindows|_RootWindow) = %d\n"
            #     "IsWindowFocused(_RootWindow) = %d\n"
            #     "IsWindowFocused(_AnyWindow) = %d\n",
            #     imgui.is_window_focused(),
            #     imgui.is_window_focused(ImGuiFocusedFlags_ChildWindows),
            #     imgui.is_window_focused(ImGuiFocusedFlags_ChildWindows | ImGuiFocusedFlags_RootWindow),
            #     imgui.is_window_focused(ImGuiFocusedFlags_RootWindow),
            #     imgui.is_window_focused(ImGuiFocusedFlags_AnyWindow));

            # // Testing IsWindowHovered() function with its various flags. Note that the flags can be combined.
            # imgui.bullet_text(
            #     "IsWindowHovered() = %d\n"
            #     "IsWindowHovered(_AllowWhenBlockedByPopup) = %d\n"
            #     "IsWindowHovered(_AllowWhenBlockedByActiveItem) = %d\n"
            #     "IsWindowHovered(_ChildWindows) = %d\n"
            #     "IsWindowHovered(_ChildWindows|_RootWindow) = %d\n"
            #     "IsWindowHovered(_RootWindow) = %d\n"
            #     "IsWindowHovered(_AnyWindow) = %d\n",
            #     imgui.is_window_hovered(),
            #     imgui.is_window_hovered(ImGuiHoveredFlags_AllowWhenBlockedByPopup),
            #     imgui.is_window_hovered(ImGuiHoveredFlags_AllowWhenBlockedByActiveItem),
            #     imgui.is_window_hovered(ImGuiHoveredFlags_ChildWindows),
            #     imgui.is_window_hovered(ImGuiHoveredFlags_ChildWindows | ImGuiHoveredFlags_RootWindow),
            #     imgui.is_window_hovered(ImGuiHoveredFlags_RootWindow),
            #     imgui.is_window_hovered(ImGuiHoveredFlags_AnyWindow));

            # imgui.begin_child("child", ImVec2(0, 50), True);
            # imgui.text("This is another child window for testing with the _ChildWindows flag.");
            # imgui.end_child();
            # if embed_all_inside_a_child_window:
            #     EndChild();

            # // Calling IsItemHovered() after begin returns the hovered status of the title bar.
            # // This is useful in particular if you want to create a context menu (with BeginPopupContextItem) associated to the title bar of a window.
            # static bool test_window = False;
            # imgui.checkbox(label="Hovered/Active tests after Begin() for title bar testing", state=&test_window);
            # if test_window:
            # {
            #     imgui.begin("Title bar Hovered/Active tests", &test_window);
            #     if imgui.begin_popup_context_item(): # // <-- This is using IsItemHovered()
            #     {
            #         if imgui.menu_item("Close"): { test_window = False; }
            #         imgui.end_popup();
            #     }
            #     imgui.text(
            #         "IsItemHovered() after begin = %d (== is title bar hovered)\n"
            #         "IsItemActive() after begin = %d (== is window being clicked/moved)\n",
            #         imgui.is_item_hovered(), imgui.is_item_active());
            #     imgui.end();
            # }

            imgui.tree_pop()

    show, _ = imgui.collapsing_header("Layout")
    if show:
        if imgui.tree_node("Child regions"):
            checked, child_regions_disable_mouse_wheel = imgui.checkbox(
                label="Disable Mouse Wheel", state=child_regions_disable_mouse_wheel
            )
            checked, child_regions_disable_menu = imgui.checkbox(
                label="Disable Menu", state=child_regions_disable_menu
            )

            goto_line = imgui.button(label="Goto")
            imgui.same_line()
            imgui.push_item_width(100)
            changed, child_regions_line = imgui.input_int(
                label="##Line",
                value=child_regions_line,
                step=0,
                step_fast=0,
                flags=imgui.INPUT_TEXT_ENTER_RETURNS_TRUE,
            )
            goto_line |= child_regions_line
            imgui.pop_item_width()

            # // Child 1: no border, enable horizontal scrollbar
            # {
            #     imgui.begin_child("Child1", ImVec2(imgui.get_window_content_region_width() * 0.5f, 300), False, ImGuiWindowFlags_HorizontalScrollbar | (disable_mouse_wheel ? ImGuiWindowFlags_NoScrollWithMouse : 0));
            #     for (int i = 0; i < 100; i++)
            #     {
            #         imgui.text("%04d: scrollable region", i);
            #         if goto_line && line == i:
            #             imgui.set_scroll_here();
            #     }
            #     if goto_line && line >= 100:
            #         imgui.set_scroll_here();
            #     imgui.end_child();
            # }

            # imgui.same_line();

            # // Child 2: rounded border
            # {
            #     imgui.push_style_var(ImGuiStyleVar_ChildRounding, 5.0f);
            #     imgui.begin_child("Child2", ImVec2(0,300), True, (disable_mouse_wheel ? ImGuiWindowFlags_NoScrollWithMouse : 0) | (disable_menu ? 0 : ImGuiWindowFlags_MenuBar));
            #     if !disable_menu && imgui.begin_menu_bar():
            #     {
            #         if imgui.begin_menu("Menu"):
            #         {
            #             show_example_menu_file();
            #             imgui.end_menu();
            #         }
            #         imgui.end_menu_bar();
            #     }
            #     imgui.columns(2);
            #     for (int i = 0; i < 100; i++)
            #     {
            #         char buf[32];
            #         sprintf(buf, "%03d", i);
            #         imgui.button(label=buf, ImVec2(-1.0f, 0.0f));
            #         imgui.next_column();
            #     }
            #     imgui.end_child();
            #     imgui.pop_style_var();
            # }

            imgui.tree_pop()
            #     }

        if imgui.tree_node("Widgets Width"):
            # static float f = 0.0f;
            # imgui.text("PushItemWidth(100)");
            # imgui.same_line();
            # ShowHelpMarker("Fixed width.");
            # imgui.push_item_width(100);
            # imgui.drag_float("float##1", &f);
            # imgui.pop_item_width();

            # imgui.text("PushItemWidth(GetWindowWidth() * 0.5f)");
            # imgui.same_line();
            # ShowHelpMarker("Half of window width.");
            # imgui.push_item_width(imgui.get_window_width() * 0.5f);
            # imgui.drag_float("float##2", &f);
            # imgui.pop_item_width();

            # imgui.text("PushItemWidth(ImGui::GetContentRegionAvail().x * 0.5f)");
            # imgui.same_line();
            # ShowHelpMarker("Half of available width.\n(~ right-cursor_pos)\n(works within a column set)");
            # imgui.push_item_width(imgui.get_content_region_avail_width() * 0.5f);
            # imgui.drag_float("float##3", &f);
            # imgui.pop_item_width();

            # imgui.text("PushItemWidth(-100)");
            # imgui.same_line();
            # ShowHelpMarker("Align to right edge minus 100");
            # imgui.push_item_width(-100);
            # imgui.drag_float("float##4", &f);
            # imgui.pop_item_width();

            # imgui.text("PushItemWidth(-1)");
            # imgui.same_line();
            # ShowHelpMarker("Align to right edge");
            # imgui.push_item_width(-1);
            # imgui.drag_float("float##5", &f);
            # imgui.pop_item_width();

            imgui.tree_pop()

        if imgui.tree_node("Basic Horizontal Layout"):
            #     {
            # imgui.text_wrapped("(Use imgui.same_line() to keep adding items to the right of the preceding item)");

            # // Text
            # imgui.text("Two items: Hello");
            # imgui.same_line();
            # imgui.text_colored(ImVec4(1,1,0,1), "Sailor");

            # // Adjust spacing
            # imgui.text("More spacing: Hello");
            # imgui.same_line(0, 20);
            # imgui.text_colored(ImVec4(1,1,0,1), "Sailor");

            # // Button
            # imgui.align_text_to_frame_padding();
            # imgui.text("Normal buttons");
            # imgui.same_line();
            # imgui.button(label="Banana");
            # imgui.same_line();
            # imgui.button(label="Apple");
            # imgui.same_line();
            # imgui.button(label="Corniflower");

            # // Button
            # imgui.text("Small buttons");
            # imgui.same_line();
            # imgui.small_button("Like this one");
            # imgui.same_line();
            # imgui.text("can fit within a text block.");

            # // Aligned to arbitrary position. Easy/cheap column.
            # imgui.text("Aligned");
            # imgui.same_line(150);
            # imgui.text("x=150");
            # imgui.same_line(300);
            # imgui.text("x=300");
            # imgui.text("Aligned");
            # imgui.same_line(150);
            # imgui.small_button("x=150");
            # imgui.same_line(300);
            # imgui.small_button("x=300");

            # // Checkbox
            # static bool c1=False,c2=False,c3=False,c4=False;
            # imgui.checkbox(label="My", state=&c1);
            # imgui.same_line();
            # imgui.checkbox(label="Tailor", state=&c2);
            # imgui.same_line();
            # imgui.checkbox(label="Is", state=&c3);
            # imgui.same_line();
            # imgui.checkbox(label="Rich", state=&c4);

            # // Various
            # static float f0=1.0f, f1=2.0f, f2=3.0f;
            # imgui.push_item_width(80);
            # const char* items[] = { "AAAA", "BBBB", "CCCC", "DDDD" };
            # static int item = -1;
            # imgui.combo("Combo", &item, items, IM_ARRAYSIZE(items));
            # imgui.same_line();
            # imgui.slider_float("X", &f0, 0.0f,5.0f);
            # imgui.same_line();
            # imgui.slider_float("Y", &f1, 0.0f,5.0f);
            # imgui.same_line();
            # imgui.slider_float("Z", &f2, 0.0f,5.0f);
            # imgui.pop_item_width();

            # imgui.push_item_width(80);
            # imgui.text("Lists:");
            # static int selection[4] = { 0, 1, 2, 3 };
            # for (int i = 0; i < 4; i++)
            # {
            #     if i > 0: imgui.same_line();
            #     imgui.push_id(i);
            #     imgui.list_box("", &selection[i], items, IM_ARRAYSIZE(items));
            #     imgui.pop_id();
            #     //if (imgui.is_item_hovered()) imgui.set_tooltip("ListBox %d hovered", i);
            # }
            # imgui.pop_item_width();

            # // Dummy
            # ImVec2 button_sz(40,40);
            # imgui.button(label="A", button_sz);
            # imgui.same_line();
            # imgui.dummy(button_sz);
            # imgui.same_line();
            # imgui.button(label="B", button_sz);

            # // Manually wrapping (we should eventually provide this as an automatic layout feature, but for now you can do it manually)
            # imgui.text("Manually wrapping:");
            # ImGuiStyle& style = imgui.get_style();
            # int buttons_count = 20;
            # float window_visible_x2 = imgui.get_window_pos().x + imgui.get_window_content_region_max().x;
            # for (int n = 0; n < buttons_count; n++)
            # {
            #     imgui.push_id(n);
            #     imgui.button(label="Box", button_sz);
            #     float last_button_x2 = imgui.get_item_rect_max().x;
            #     float next_button_x2 = last_button_x2 + style.ItemSpacing.x + button_sz.x; // Expected position if next button was on same line
            #     if n + 1 < buttons_count && next_button_x2 < window_visible_x2:
            #         imgui.same_line();
            #     imgui.pop_id();

            imgui.tree_pop()

        if imgui.tree_node("Groups"):
            #     {
            # imgui.text_wrapped("(Using imgui.begin_group()/EndGroup() to layout items. BeginGroup() basically locks the horizontal position. EndGroup() bundles the whole group so that you can use functions such as IsItemHovered() on it.)");
            # imgui.begin_group();
            # {
            #     imgui.begin_group();
            #     imgui.button(label="AAA");
            #     imgui.same_line();
            #     imgui.button(label="BBB");
            #     imgui.same_line();
            #     imgui.begin_group();
            #     imgui.button(label="CCC");
            #     imgui.button(label="DDD");
            #     imgui.end_group();
            #     imgui.same_line();
            #     imgui.button(label="EEE");
            #     imgui.end_group();
            #     if imgui.is_item_hovered():
            #         imgui.set_tooltip("First group hovered");
            # }
            # // Capture the group size and create widgets using the same size
            # ImVec2 size = imgui.get_item_rect_size();
            # const float values[5] = { 0.5f, 0.20f, 0.80f, 0.60f, 0.25f };
            # imgui.plot_histogram("##values", values, IM_ARRAYSIZE(values), 0, NULL, 0.0f, 1.0f, size);

            # imgui.button(label="ACTION", ImVec2((size.x - imgui.get_style().ItemSpacing.x)*0.5f,size.y));
            # imgui.same_line();
            # imgui.button(label="REACTION", ImVec2((size.x - imgui.get_style().ItemSpacing.x)*0.5f,size.y));
            # imgui.end_group();
            # imgui.same_line();

            # imgui.button(label="LEVERAGE\nBUZZWORD", size);
            # imgui.same_line();

            # if imgui.list_box_header("List", size):
            # {
            #     imgui.selectable("Selected", True);
            #     imgui.selectable("Not Selected", False);
            #     imgui.list_box_footer();
            # }

            imgui.tree_pop()

        if imgui.tree_node("Text Baseline Alignment"):
            #     {
            # imgui.text_wrapped("(This is testing the vertical alignment that occurs on text to keep it at the same baseline as widgets. Lines only composed of text or \"small\" widgets fit in less vertical spaces than lines with normal widgets)");

            # imgui.text("One\nTwo\nThree");
            # imgui.same_line();
            # imgui.text("Hello\nWorld");
            # imgui.same_line();
            # imgui.text("Banana");

            # imgui.text("Banana");
            # imgui.same_line();
            # imgui.text("Hello\nWorld");
            # imgui.same_line();
            # imgui.text("One\nTwo\nThree");

            # imgui.button(label="HOP##1");
            # imgui.same_line();
            # imgui.text("Banana");
            # imgui.same_line();
            # imgui.text("Hello\nWorld");
            # imgui.same_line();
            # imgui.text("Banana");

            # imgui.button(label="HOP##2");
            # imgui.same_line();
            # imgui.text("Hello\nWorld");
            # imgui.same_line();
            # imgui.text("Banana");

            # imgui.button(label="TEST##1");
            # imgui.same_line();
            # imgui.text("TEST");
            # imgui.same_line();
            # imgui.small_button("TEST##2");

            # imgui.align_text_to_frame_padding();
            # // If your line starts with text, call this to align it to upcoming widgets.
            # imgui.text("Text aligned to Widget");
            # imgui.same_line();
            # imgui.button(label="Widget##1");
            # imgui.same_line();
            # imgui.text("Widget");
            # imgui.same_line();
            # imgui.small_button("Widget##2");
            # imgui.same_line();
            # imgui.button(label="Widget##3");

            # // Tree
            # const float spacing = imgui.get_style().ItemInnerSpacing.x;
            # imgui.button(label="Button##1");
            # imgui.same_line(0.0f, spacing);
            # if imgui.tree_node("Node##1"):
            #    { for (int i = 0; i < 6; i++) imgui.bullet_text("Item %d..", i); imgui.tree_pop(); }    // Dummy tree data

            # imgui.align_text_to_frame_padding();         // Vertically align text node a bit lower so it'll be vertically centered with upcoming widget. Otherwise you can use SmallButton (smaller fit).
            # bool node_open = imgui.tree_node("Node##2");  // Common mistake to avoid: if we want to SameLine after TreeNode we need to do it before we add child content.
            # imgui.same_line(0.0f, spacing); imgui.button(label="Button##2");
            # if node_open:
            #   { for (int i = 0; i < 6; i++) imgui.bullet_text("Item %d..", i); imgui.tree_pop(); }   // Dummy tree data

            # // Bullet
            # imgui.button(label="Button##3");
            # imgui.same_line(0.0f, spacing);
            # imgui.bullet_text("Bullet text");

            # imgui.align_text_to_frame_padding();
            # imgui.bullet_text("Node");
            # imgui.same_line(0.0f, spacing);
            # imgui.button(label="Button##4");

            imgui.tree_pop()

        if imgui.tree_node("Scrolling"):
            #     {
            # imgui.text_wrapped("(Use SetScrollHere() or SetScrollFromPosY() to scroll to a given position.)");
            # static bool track = True;
            # static int track_line = 50, scroll_to_px = 200;
            # imgui.checkbox(label="Track", state=&track);
            # imgui.push_item_width(100);
            # imgui.same_line(130);
            # track |= imgui.drag_int("##line", &track_line, 0.25f, 0, 99, "Line = %d");
            # bool scroll_to = imgui.button(label="Scroll To Pos");
            # imgui.same_line(130);
            # scroll_to |= imgui.drag_int("##pos_y", &scroll_to_px, 1.00f, 0, 9999, "Y = %d px");
            # imgui.pop_item_width();
            # if scroll_to: track = False;

            # for (int i = 0; i < 5; i++)
            # {
            #     if i > 0: imgui.same_line();
            #     imgui.begin_group();
            #     imgui.text("%s", i == 0 ? "Top" : i == 1 ? "25%" : i == 2 ? "Center" : i == 3 ? "75%" : "Bottom");
            #     imgui.begin_child(imgui.get_i_d((void*)(intptr_t)i), ImVec2(imgui.get_window_width() * 0.17f, 200.0f), True);
            #     if scroll_to:
            #         imgui.set_scroll_from_pos_y(imgui.get_cursor_start_pos().y + scroll_to_px, i * 0.25f);
            #     for (int line = 0; line < 100; line++)
            #     {
            #         if track && line == track_line:
            #         {
            #             imgui.text_colored(ImColor(255,255,0), "Line %d", line);
            #             imgui.set_scroll_here(i * 0.25f); // 0.0f:top, 0.5f:center, 1.0f:bottom
            #         }
            #         else
            #         {
            #             imgui.text("Line %d", line);
            #         }
            #     }
            #     float scroll_y = imgui.get_scroll_y(), scroll_max_y = imgui.get_scroll_max_y();
            #     imgui.end_child();
            #     imgui.text("%.0f/%0.f", scroll_y, scroll_max_y);
            #     imgui.end_group();
            # }
            imgui.tree_pop()

        if imgui.tree_node("Horizontal Scrolling"):
            #     {
            # imgui.bullet();
            # imgui.text_wrapped("Horizontal scrolling for a window has to be enabled explicitly via the ImGuiWindowFlags_HorizontalScrollbar flag.");
            # imgui.bullet();
            # imgui.text_wrapped("You may want to explicitly specify content width by calling SetNextWindowContentWidth() before Begin().");
            # static int lines = 7;
            # imgui.slider_int("Lines", &lines, 1, 15);
            # imgui.push_style_var(ImGuiStyleVar_FrameRounding, 3.0f);
            # imgui.push_style_var(ImGuiStyleVar_FramePadding, ImVec2(2.0f, 1.0f));
            # imgui.begin_child("scrolling", ImVec2(0, imgui.get_frame_height_with_spacing()*7 + 30), True, ImGuiWindowFlags_HorizontalScrollbar);
            # for (int line = 0; line < lines; line++)
            # {
            #     // Display random stuff (for the sake of this trivial demo we are using basic Button+SameLine. If you want to create your own time line for a real application you may be better off
            #     // manipulating the cursor position yourself, aka using SetCursorPos/SetCursorScreenPos to position the widgets yourself. You may also want to use the lower-level ImDrawList API)
            #     int num_buttons = 10 + ((line & 1) ? line * 9 : line * 3);
            #     for (int n = 0; n < num_buttons; n++)
            #     {
            #         if n > 0: imgui.same_line();
            #         imgui.push_id(n + line * 1000);
            #         char num_buf[16];
            #         sprintf(num_buf, "%d", n);
            #         const char* label = (!(n%15)) ? "FizzBuzz" : (!(n%3)) ? "Fizz" : (!(n%5)) ? "Buzz" : num_buf;
            #         float hue = n*0.05f;
            #         imgui.push_style_color(ImGuiCol_Button, (ImVec4)ImColor::HSV(hue, 0.6f, 0.6f));
            #         imgui.push_style_color(ImGuiCol_ButtonHovered, (ImVec4)ImColor::HSV(hue, 0.7f, 0.7f));
            #         imgui.push_style_color(ImGuiCol_ButtonActive, (ImVec4)ImColor::HSV(hue, 0.8f, 0.8f));
            #         imgui.button(label=label, ImVec2(40.0f + sinf((float)(line + n)) * 20.0f, 0.0f));
            #         imgui.pop_style_color(3);
            #         imgui.pop_id();
            #     }
            # }
            # float scroll_x = imgui.get_scroll_x(), scroll_max_x = imgui.get_scroll_max_x();
            # imgui.end_child();
            # imgui.pop_style_var(2);
            # float scroll_x_delta = 0.0f;
            # imgui.small_button("<<");
            # if imgui.is_item_active(): scroll_x_delta = -imgui.get_i_o().DeltaTime * 1000.0f;
            # imgui.same_line();
            # imgui.text("Scroll from code");
            # imgui.same_line();
            # imgui.small_button(">>");
            # if imgui.is_item_active(): scroll_x_delta = +imgui.get_i_o().DeltaTime * 1000.0f;
            # imgui.same_line();
            # imgui.text("%.0f/%.0f", scroll_x, scroll_max_x);
            # if scroll_x_delta != 0.0f:
            # {
            #     imgui.begin_child("scrolling");
            # // Demonstrate a trick: you can use Begin to set yourself in the context of another window (here we are already out of your child window)
            #     imgui.set_scroll_x(imgui.get_scroll_x() + scroll_x_delta);
            #     imgui.end();
            # }
            imgui.tree_pop()

        if imgui.tree_node("Clipping"):
            #     {
            # static ImVec2 size(100, 100), offset(50, 20);
            # imgui.text_wrapped("On a per-widget basis we are occasionally clipping text CPU-side if it won't fit in its frame. Otherwise we are doing coarser clipping + passing a scissor rectangle to the renderer. The system is designed to try minimizing both execution and CPU/GPU rendering cost.");
            # imgui.drag_float2("size", (float*)&size, 0.5f, 0.0f, 200.0f, "%.0f");
            # imgui.text_wrapped("(Click and drag)");
            # ImVec2 pos = imgui.get_cursor_screen_pos();
            # ImVec4 clip_rect(pos.x, pos.y, pos.x+size.x, pos.y+size.y);
            # imgui.invisible_button("##dummy", size);
            # if imgui.is_item_active() && imgui.is_mouse_dragging(): { offset.x += imgui.get_i_o().MouseDelta.x;
            # offset.y += imgui.get_i_o().MouseDelta.y; }
            # imgui.get_window_draw_list()->AddRectFilled(pos, ImVec2(pos.x+size.x,pos.y+size.y), IM_COL32(90,90,120,255));
            # imgui.get_window_draw_list()->AddText(imgui.get_font(), imgui.get_font_size()*2.0f, ImVec2(pos.x+offset.x,pos.y+offset.y), IM_COL32(255,255,255,255), "Line 1 hello\nLine 2 clip me!", NULL, 0.0f, &clip_rect);
            imgui.tree_pop()

    show, _ = imgui.collapsing_header("Popups & Modal windows")
    if show:
        if imgui.tree_node("Popups"):
            imgui.text_wrapped(
                "When a popup is active, it inhibits interacting with windows that are behind the popup. Clicking outside the popup closes it."
            )

            names = ["Bream", "Haddock", "Mackerel", "Pollock", "Tilefish"]

            # // Simple selection popup
            # // (If you want to show the current selection inside the Button itself, you may want to build a string using the "###" operator to preserve a constant ID with a variable label)
            if imgui.button(label="Select.."):
                imgui.open_popup("select")
            imgui.same_line()
            imgui.text_unformatted(
                "<None>" if popups_selected_fish == -1 else names[popups_selected_fish]
            )
            if imgui.begin_popup("select"):
                imgui.text("Aquarium")
                imgui.separator()
                for i in range(len(names)):
                    _, names[i] = imgui.selectable(names[i])
                    if names[i]:
                        popups_selected_fish = i
                imgui.end_popup()

            # // Showing a menu with toggles
            if imgui.button(label="Toggle.."):
                imgui.open_popup("toggle")
            if imgui.begin_popup("toggle"):
                for i in range(len(names)):
                    clicked, popups_toggles[i] = imgui.menu_item(
                        label=names[i], shortcut=None, selected=popups_toggles[i]
                    )
                if imgui.begin_menu("Sub-menu"):
                    imgui.menu_item("Click me")
                    imgui.end_menu()

                imgui.separator()
                imgui.text("Tooltip here")
                if imgui.is_item_hovered():
                    imgui.set_tooltip("I am a tooltip over a popup")

                if imgui.button(label="Stacked Popup"):
                    imgui.open_popup("another popup")
                if imgui.begin_popup("another popup"):
                    for i in range(len(names)):
                        clicked, popups_toggles[i] = imgui.menu_item(
                            label=names[i], shortcut=None, selected=popups_toggles[i]
                        )
                    if imgui.begin_menu("Sub-menu"):
                        imgui.menu_item("Click me")
                        imgui.end_menu()
                    imgui.end_popup()
                imgui.end_popup()

            if imgui.button(label="Popup Menu.."):
                imgui.open_popup("FilePopup")
            if imgui.begin_popup("FilePopup"):
                show_example_menu_file()
                imgui.end_popup()

            imgui.tree_pop()

        if imgui.tree_node("Context menus"):
            # // BeginPopupContextItem() is a helper to provide common/simple popup behavior of essentially doing:
            # //    if (IsItemHovered() && IsMouseClicked(0))
            # //       OpenPopup(id);
            # //    return BeginPopup(id);
            # // For more advanced uses you may want to replicate and cuztomize this code. This the comments inside BeginPopupContextItem() implementation.

            imgui.text(
                "Value = " + str(context_menus_value) + " (<-- right-click here)"
            )
            if imgui.begin_popup_context_item("item context menu"):
                changed, _ = imgui.selectable("Set to zero")
                if changed:
                    context_menus_value = 0.0
                changed, _ = imgui.selectable("Set to PI")
                if changed:
                    context_menus_value = 3.1415
                imgui.push_item_width(-1)
                changed, context_menus_value = imgui.drag_float(
                    label="##Value",
                    value=context_menus_value,
                    change_speed=0.1,
                    min_value=0.0,
                    max_value=20.0,
                )
                imgui.pop_item_width()
                imgui.end_popup()

            buf = "Button: " + str(context_menus_name) + "###Button"
            imgui.button(label=buf)
            if imgui.begin_popup_context_item():
                # // When used after an item that has an ID (here the Button), we can skip providing an ID to BeginPopupContextItem().
                imgui.text("Edit name:")
                changed, context_menus_name = imgui.input_text(
                    label="##edit", value=context_menus_name, buffer_length=100
                )
                if imgui.button(label="Close"):
                    imgui.close_current_popup()
                imgui.end_popup()
            imgui.same_line()
            imgui.text("(<-- right-click here)")

            imgui.tree_pop()

        if imgui.tree_node("Modals"):

            imgui.text_wrapped(
                "Modal windows are like popups but the user cannot close them by clicking outside the window."
            )

            if imgui.button(label="Delete.."):
                imgui.open_popup("Delete?")
            if imgui.begin_popup_modal(
                title="Delete?", visible=None, flags=imgui.WINDOW_ALWAYS_AUTO_RESIZE
            )[0]:
                imgui.text(
                    "All those beautiful files will be deleted.\nThis operation cannot be undone!\n\n"
                )
                imgui.separator()

                # TODO -- figure out how to make the framepadding

                # imgui.push_style_var(ImGuiStyleVar_FramePadding, ImVec2(0,0));
                changed, context_menus_dont_ask_me_next_time = imgui.checkbox(
                    label="Don't ask me next time",
                    state=context_menus_dont_ask_me_next_time,
                )
                # imgui.pop_style_var()

                if imgui.button(label="OK", width=120, height=0):
                    imgui.close_current_popup()
                imgui.set_item_default_focus()
                imgui.same_line()
                if imgui.button(label="Cancel", width=120, height=0):
                    imgui.close_current_popup()
                imgui.end_popup()

            if imgui.button(label="Stacked modals.."):
                imgui.open_popup("Stacked 1")
            if imgui.begin_popup_modal("Stacked 1")[0]:
                imgui.text(
                    "Hello from Stacked The First\nUsing style.Colors[ImGuiCol_ModalWindowDimBg] behind it."
                )

                changed, context_menus_modal_item = imgui.combo(
                    label="Combo",
                    current=context_menus_modal_item,
                    items=["aaaa", "bbbb", "cccc", "dddd", "eeee"],
                )

                changed, context_menus_modal_color = imgui.color_edit4(
                    "color", *context_menus_modal_color
                )
                # // This is to test behavior of stacked regular popups over a modal

                if imgui.button(label="Add another modal.."):
                    imgui.open_popup("Stacked 2")
                if imgui.begin_popup_modal("Stacked 2")[0]:
                    imgui.text("Hello from Stacked The Second!")
                    if imgui.button(label="Close"):
                        imgui.close_current_popup()
                    imgui.end_popup()

                if imgui.button(label="Close"):
                    imgui.close_current_popup()
                imgui.end_popup()

            imgui.tree_pop()

        if imgui.tree_node("Menus inside a regular window"):
            imgui.text_wrapped(
                "Below we are testing adding menu items to a regular window. It's rather unusual but should work!"
            )
            imgui.separator()
            # // NB: As a quirk in this very specific example, we want to differentiate the parent of this menu from the parent of the various popup menus above.
            # // To do so we are encloding the items in a PushID()/PopID() block to make them two different menusets. If we don't, opening any popup above and hovering our menu here
            # // would open it. This is because once a menu is active, we allow to switch to a sibling menu by just hovering on it, which is the desired behavior for regular menus.
            imgui.push_id("foo")
            imgui.menu_item(label="Menu item", shortcut="CTRL+M")
            if imgui.begin_menu("Menu inside a regular window"):
                show_example_menu_file()
                imgui.end_menu()
            imgui.pop_id()
            imgui.separator()
            imgui.tree_pop()

    show, _ = imgui.collapsing_header("Columns")
    if show:
        imgui.push_id("Columns")

        #     // Basic columns
        if imgui.tree_node("Basic"):
            imgui.text("Without border:")
            imgui.columns(3, "mycolumns3", False)
            # // 3-ways, no border
            imgui.separator()
            for n in range(14):
                label = "Item " + str(n)
                if imgui.selectable(label):
                    pass
                # //if (imgui.button(label=label, ImVec2(-1,0))) {}
                imgui.next_column()
            imgui.columns(1)
            imgui.separator()

            imgui.text("With border:")
            imgui.columns(4, "mycolumns")
            # // 4-ways, with border
            imgui.separator()
            imgui.text("ID")
            imgui.next_column()
            imgui.text("Name")
            imgui.next_column()
            imgui.text("Path")
            imgui.next_column()
            imgui.text("Hovered")
            imgui.next_column()
            imgui.separator()
            names = ["One", "Two", "Three"]
            paths = ["/path/one", "/path/two", "/path/three"]
            for i in range(3):
                label = str(i)

                clicked, _ = imgui.selectable(
                    label=label,
                    selected=columns_selected == i,
                    flags=imgui.SELECTABLE_SPAN_ALL_COLUMNS,
                )
                if clicked:
                    columns_selected = i
                hovered = imgui.is_item_hovered()
                imgui.next_column()
                imgui.text(names[i])
                imgui.next_column()
                imgui.text(paths[i])
                imgui.next_column()
                imgui.text(str(hovered))
                imgui.next_column()
            imgui.columns(1)
            imgui.separator()
            imgui.tree_pop()

        #     // Create multiple items in a same cell before switching to next column
        if imgui.tree_node("Mixed items"):
            imgui.columns(3, "mixed")
            imgui.separator()

            imgui.text("Hello")
            imgui.button(label="Banana")
            imgui.next_column()

            imgui.text("ImGui")
            imgui.button(label="Apple")

            changed, mixed_items_foo = imgui.input_float(
                label="red",
                value=mixed_items_foo,
                step=0.05,
                step_fast=0,
                format="%.3f",
            )
            imgui.text("An extra line here.")
            imgui.next_column()

            imgui.text("Sailor")
            imgui.button(label="Corniflower")
            changed, mixed_items_bar = imgui.input_float(
                label="blue",
                value=mixed_items_bar,
                step=0.05,
                step_fast=0,
                format="%.3f",
            )
            imgui.next_column()

            show, _ = imgui.collapsing_header("Category A")
            if show:
                imgui.text("Blah blah blah")
            imgui.next_column()
            show, _ = imgui.collapsing_header("Category B")
            if show:
                imgui.text("Blah blah blah")
            imgui.next_column()
            show, _ = imgui.collapsing_header("Category C")
            if show:
                imgui.text("Blah blah blah")
            imgui.next_column()
            imgui.columns(1)
            imgui.separator()
            imgui.tree_pop()

        #     // Word wrapping
        if imgui.tree_node("Word-wrapping"):
            imgui.columns(2, "word-wrapping")
            imgui.separator()
            imgui.text_wrapped("The quick brown fox jumps over the lazy dog.")
            imgui.text_wrapped("Hello Left")
            imgui.next_column()
            imgui.text_wrapped("The quick brown fox jumps over the lazy dog.")
            imgui.text_wrapped("Hello Right")
            imgui.columns(1)
            imgui.separator()
            imgui.tree_pop()

        if imgui.tree_node("Borders"):

            def char_add_to_a(amount):
                # add "amount" to the character 'a'
                return chr(ord("a") + amount)

            changed, borders_h_borders = imgui.checkbox(
                label="horizontal", state=borders_h_borders
            )
            imgui.same_line()
            changed, borders_v_borders = imgui.checkbox(
                label="vertical", state=borders_v_borders
            )
            imgui.columns(count=4, identifier=None, border=borders_v_borders)
            for i in range(4 * 3):
                if borders_h_borders and imgui.get_column_index() == 0:
                    imgui.separator()
                imgui.text(
                    char_add_to_a(i) + " " + char_add_to_a(i) + " " + char_add_to_a(i)
                )
                imgui.text(
                    "Width "
                    + str(imgui.get_column_width())
                    + os.linesep
                    + "Offset "
                    + str(imgui.get_column_offset())
                )
                imgui.next_column()
            imgui.columns(1)
            if borders_h_borders:
                imgui.separator()
            imgui.tree_pop()

        if imgui.tree_node("Horizontal Scrolling"):
            pass
            # TODO -- implement ListClipper and uncomment the section below

            # imgui.set_next_window_content_size(1500.0, 0.0)
            # imgui.begin_child(label="##ScrollingRegion", width=0, height=imgui.get_font_size() * 20), border=False, flags=ImGuiWindowFlags_HorizontalScrollbar)
            # imgui.columns(10)
            # ITEMS_COUNT = 2000
            # ImGuiListClipper clipper(ITEMS_COUNT);  // Also demonstrate using the clipper for large list
            # while (clipper.Step()):
            # {
            #     for (int i = clipper.DisplayStart; i < clipper.DisplayEnd; i++)
            #         for (int j = 0; j < 10; j++)
            #         {
            #             imgui.text("Line %d Column %d...", i, j);
            #             imgui.next_column();
            #         }
            # }
            # imgui.columns(1);
            # imgui.end_child();
            imgui.tree_pop()

        node_open = imgui.tree_node("Tree within single cell")
        imgui.same_line()
        show_help_marker(
            "NB: Tree node must be poped before ending the cell. There's no storage of state per-cell."
        )
        if node_open:
            imgui.columns(2, "tree items")
            imgui.separator()
            if imgui.tree_node("Hello"):
                imgui.bullet_text("Sailor")
                imgui.tree_pop()
            imgui.next_column()
            if imgui.tree_node("Bonjour"):
                imgui.bullet_text("Marin")
                imgui.tree_pop()
            imgui.next_column()
            imgui.columns(1)
            imgui.separator()
            imgui.tree_pop()
        imgui.pop_id()

    show, _ = imgui.collapsing_header("Filtering")
    if show:
        # TODO - implement
        #     static ImGuiTextFilter filter;
        #     imgui.text("Filter usage:\n"
        #         "  \"\"         display all lines\n"
        #         "  \"xxx\"      display lines containing \"xxx\"\n"
        #         "  \"xxx,yyy\"  display lines containing \"xxx\" or \"yyy\"\n"
        #         "  \"-xxx\"     hide lines containing \"xxx\"");
        #     filter.Draw();
        #     const char* lines[] = { "aaa1.c", "bbb1.c", "ccc1.c", "aaa2.cpp", "bbb2.cpp", "ccc2.cpp", "abc.h", "hello, world" };
        #     for (int i = 0; i < IM_ARRAYSIZE(lines); i++)
        # if filter.PassFilter(lines[i]):
        #     imgui.bullet_text("%s", lines[i]);
        # }
        pass

    show, _ = imgui.collapsing_header("Inputs, Navigation & Focus")
    if show:
        io = imgui.get_io()

        imgui.text("WantCaptureMouse: " + str(io.want_capture_mouse))
        imgui.text("WantCaptureKeyboard: " + str(io.want_capture_keyboard))
        imgui.text("WantTextInput: " + str(io.want_text_input))
        imgui.text("WantSetMousePos: " + str(io.want_set_mouse_pos))
        imgui.text("NavActive: " + str(io.nav_active) +  "NavVisible: " + str(io.nav_visible))

        #     if imgui.tree_node("Keyboard, Mouse & Navigation State"):
        #     {
        # if imgui.is_mouse_pos_valid():
        #     imgui.text("Mouse pos: (%g, %g)", io.MousePos.x, io.MousePos.y);
        # else
        #     imgui.text("Mouse pos: <INVALID>");
        # imgui.text("Mouse delta: (%g, %g)", io.MouseDelta.x, io.MouseDelta.y);
        # imgui.text("Mouse down:");
        # for (int i = 0; i < IM_ARRAYSIZE(io.MouseDown); i++) if (io.MouseDownDuration[i] >= 0.0f)   { imgui.same_line();
        # imgui.text("b%d (%.02f secs)", i, io.MouseDownDuration[i]); }
        # imgui.text("Mouse clicked:");
        # for (int i = 0; i < IM_ARRAYSIZE(io.MouseDown); i++) if (imgui.is_mouse_clicked(i))          { imgui.same_line(); imgui.text("b%d", i); }
        # imgui.text("Mouse dbl-clicked:"); for (int i = 0; i < IM_ARRAYSIZE(io.MouseDown); i++) if (imgui.is_mouse_double_clicked(i)) { imgui.same_line(); imgui.text("b%d", i); }
        # imgui.text("Mouse released:"); for (int i = 0; i < IM_ARRAYSIZE(io.MouseDown); i++) if (imgui.is_mouse_released(i))         { imgui.same_line(); imgui.text("b%d", i); }
        # imgui.text("Mouse wheel: %.1f", io.MouseWheel);

        # imgui.text("Keys down:");      for (int i = 0; i < IM_ARRAYSIZE(io.KeysDown); i++) if (io.KeysDownDuration[i] >= 0.0f)     { imgui.same_line(); imgui.text("%d (%.02f secs)", i, io.KeysDownDuration[i]); }
        # imgui.text("Keys pressed:");   for (int i = 0; i < IM_ARRAYSIZE(io.KeysDown); i++) if (imgui.is_key_pressed(i))             { imgui.same_line(); imgui.text("%d", i); }
        # imgui.text("Keys release:");   for (int i = 0; i < IM_ARRAYSIZE(io.KeysDown); i++) if (imgui.is_key_released(i))            { imgui.same_line(); imgui.text("%d", i); }
        # imgui.text("Keys mods: %s%s%s%s", io.KeyCtrl ? "CTRL " : "", io.KeyShift ? "SHIFT " : "", io.KeyAlt ? "ALT " : "", io.KeySuper ? "SUPER " : "");

        # imgui.text("NavInputs down:"); for (int i = 0; i < IM_ARRAYSIZE(io.NavInputs); i++) if (io.NavInputs[i] > 0.0f)                    { imgui.same_line(); imgui.text("[%d] %.2f", i, io.NavInputs[i]); }
        # imgui.text("NavInputs pressed:"); for (int i = 0; i < IM_ARRAYSIZE(io.NavInputs); i++) if (io.NavInputsDownDuration[i] == 0.0f)    { imgui.same_line(); imgui.text("[%d]", i); }
        # imgui.text("NavInputs duration:"); for (int i = 0; i < IM_ARRAYSIZE(io.NavInputs); i++) if (io.NavInputsDownDuration[i] >= 0.0f)   { imgui.same_line(); imgui.text("[%d] %.2f", i, io.NavInputsDownDuration[i]); }

        # imgui.button(label="Hovering me sets the\nkeyboard capture flag");
        # if imgui.is_item_hovered():
        #     imgui.capture_keyboard_from_app(True);
        # imgui.same_line();
        # imgui.button(label="Holding me clears the\nthe keyboard capture flag");
        # if imgui.is_item_active():
        #     imgui.capture_keyboard_from_app(False);

        # imgui.tree_pop();
        #     }

        #     if imgui.tree_node("Tabbing"):
        #     {
        # imgui.text("Use TAB/SHIFT+TAB to cycle through keyboard editable fields.");
        # static char buf[32] = "dummy";
        # imgui.input_text(label="1", value=buf, buffer_length=IM_ARRAYSIZE(buf));
        # imgui.input_text(label="2", value=buf, buffer_length=IM_ARRAYSIZE(buf));
        # imgui.input_text(label="3", value=buf, buffer_length=IM_ARRAYSIZE(buf));
        # imgui.push_allow_keyboard_focus(False);
        # imgui.input_text(label="4 (tab skip)", value=buf, buffer_length=IM_ARRAYSIZE(buf));
        # //imgui.same_line(); ShowHelperMarker("Use imgui.push_allow_keyboard_focus(bool)\nto disable tabbing through certain widgets.");
        # imgui.pop_allow_keyboard_focus();
        # imgui.input_text(label="5", value=buf, buffer_length=IM_ARRAYSIZE(buf));
        # imgui.tree_pop();
        #     }

        #     if imgui.tree_node("Focus from code"):
        #     {
        # bool focus_1 = imgui.button(label="Focus on 1");
        # imgui.same_line();
        # bool focus_2 = imgui.button(label="Focus on 2");
        # imgui.same_line();
        # bool focus_3 = imgui.button(label="Focus on 3");
        # int has_focus = 0;
        # static char buf[128] = "click on a button to set focus";

        # if focus_1: imgui.set_keyboard_focus_here();
        # imgui.input_text(label="1", value=buf, buffer_length=IM_ARRAYSIZE(buf));
        # if imgui.is_item_active(): has_focus = 1;

        # if focus_2: imgui.set_keyboard_focus_here();
        # imgui.input_text(label="2", value=buf, buffer_length=IM_ARRAYSIZE(buf));
        # if imgui.is_item_active(): has_focus = 2;

        # imgui.push_allow_keyboard_focus(False);
        # if focus_3: imgui.set_keyboard_focus_here();
        # imgui.input_text(label="3 (tab skip)", value=buf, buffer_length=IM_ARRAYSIZE(buf));
        # if imgui.is_item_active(): has_focus = 3;
        # imgui.pop_allow_keyboard_focus();

        # if has_focus:
        #     imgui.text("Item with focus: %d", has_focus);
        # else
        #     imgui.text("Item with focus: <none>");

        # // Use >= 0 parameter to SetKeyboardFocusHere() to focus an upcoming item
        # static float f3[3] = { 0.0f, 0.0f, 0.0f };
        # int focus_ahead = -1;
        # if imgui.button(label="Focus on X"): focus_ahead = 0;
        # imgui.same_line();
        # if imgui.button(label="Focus on Y"): focus_ahead = 1;
        # imgui.same_line();
        # if imgui.button(label="Focus on Z"): focus_ahead = 2;
        # if focus_ahead != -1: imgui.set_keyboard_focus_here(focus_ahead);
        # imgui.slider_float3("Float3", &f3[0], 0.0f, 1.0f);

        # imgui.text_wrapped("NB: Cursor & selection are preserved when refocusing last used item in code.");
        # imgui.tree_pop();
        #     }

        #     if imgui.tree_node("Dragging"):
        #     {
        # imgui.text_wrapped("You can use imgui.get_mouse_drag_delta(0) to query for the dragged amount on any widget.");
        # for (int button = 0; button < 3; button++)
        #     imgui.text("IsMouseDragging(%d):\n  w/ default threshold: %d,\n  w/ zero threshold: %d\n  w/ large threshold: %d",
        #         button, imgui.is_mouse_dragging(button), imgui.is_mouse_dragging(button, 0.0f), imgui.is_mouse_dragging(button, 20.0f));
        # imgui.button(label="Drag Me");
        # if imgui.is_item_active():
        # {
        #     // Draw a line between the button and the mouse cursor
        #     ImDrawList* draw_list = imgui.get_window_draw_list();
        #     draw_list->PushClipRectFullScreen();
        #     draw_list->AddLine(io.MouseClickedPos[0], io.MousePos, imgui.get_color_u32(ImGuiCol_Button), 4.0f);
        #     draw_list->PopClipRect();

        #     // Drag operations gets "unlocked" when the mouse has moved past a certain threshold (the default threshold is stored in io.MouseDragThreshold)
        #     // You can request a lower or higher threshold using the second parameter of IsMouseDragging() and GetMouseDragDelta()
        #     ImVec2 value_raw = imgui.get_mouse_drag_delta(0, 0.0f);
        #     ImVec2 value_with_lock_threshold = imgui.get_mouse_drag_delta(0);
        #     ImVec2 mouse_delta = io.MouseDelta;
        #     imgui.same_line()
        # ; imgui.text("Raw (%.1f, %.1f), WithLockThresold (%.1f, %.1f), MouseDelta (%.1f, %.1f)", value_raw.x, value_raw.y, value_with_lock_threshold.x, value_with_lock_threshold.y, mouse_delta.x, mouse_delta.y);
        # }
        # imgui.tree_pop();
        #     }

        #     if imgui.tree_node("Mouse cursors"):
        #     {
        # const char* mouse_cursors_names[] = { "Arrow", "TextInput", "Move", "ResizeNS", "ResizeEW", "ResizeNESW", "ResizeNWSE", "Hand" };
        # IM_ASSERT(IM_ARRAYSIZE(mouse_cursors_names) == ImGuiMouseCursor_COUNT);

        # imgui.text("Current mouse cursor = %d: %s", imgui.get_mouse_cursor(), mouse_cursors_names[imgui.get_mouse_cursor()]);
        # imgui.text("Hover to see mouse cursors:");
        # imgui.same_line();
        # ShowHelpMarker("Your application can render a different mouse cursor based on what imgui.get_mouse_cursor() returns. If software cursor rendering (io.MouseDrawCursor) is set ImGui will draw the right cursor for you, otherwise your backend needs to handle it.");
        # for (int i = 0; i < ImGuiMouseCursor_COUNT; i++)
        # {
        #     char label[32];
        #     sprintf(label, "Mouse cursor %d: %s", i, mouse_cursors_names[i]);
        #     imgui.bullet();
        # imgui.selectable(label, False);
        #     if imgui.is_item_hovered() || imgui.is_item_focused():
        #         imgui.set_mouse_cursor(i);
        # }
        # imgui.tree_pop();
        #     }
        # }

    imgui.end()
