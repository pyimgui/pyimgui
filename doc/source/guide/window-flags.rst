.. _guide-window-flags:

Using window flags
==================


New windows created using :any:`begin()` function can be customized/tuned
with additional ``flags`` argument. This argument is an integer bitfield
so many different flags can be joined together with ``|`` operator.

.. visual-example::
    :width: 320
    :title: Window flags


    imgui.set_next_window_size(300, 90)
    imgui.set_next_window_position(10, 0)
    imgui.begin(
        "Custom window",
        flags=imgui.WINDOW_MENU_BAR
    )
    imgui.text("Custom window with menu bar and borders")
    imgui.end()

    imgui.set_next_window_size(300, 90)
    imgui.set_next_window_position(10, 100)
    imgui.begin("Default Window")
    imgui.text("Default window with title bar")
    imgui.end()


Window flags are also available for new scrollable child regions created with
:any:`begin_child()` function.


.. visual-example::
    :width: 310
    :title: Child region flags
    :auto_layout:

    imgui.begin("Scrollale regions with flags")

    imgui.begin_child(
        "Child 1", height=70, border=True,
        flags=imgui.WINDOW_ALWAYS_HORIZONTAL_SCROLLBAR
    )
    imgui.text("inside region 1")
    imgui.end_child()

    imgui.begin_child(
        "Child 2", height=70, border=True,
        flags=imgui.WINDOW_ALWAYS_VERTICAL_SCROLLBAR
    )
    imgui.text("inside region 2")
    imgui.end_child()

    imgui.end()

List of all available window flags (click to see documentation):

.. _window-flag-options:

* :py:data:`imgui.WINDOW_NO_TITLE_BAR`
* :py:data:`imgui.WINDOW_NO_RESIZE`
* :py:data:`imgui.WINDOW_NO_MOVE` 
* :py:data:`imgui.WINDOW_NO_SCROLLBAR` 
* :py:data:`imgui.WINDOW_NO_SCROLL_WITH_MOUSE` 
* :py:data:`imgui.WINDOW_NO_COLLAPSE` 
* :py:data:`imgui.WINDOW_ALWAYS_AUTO_RESIZE` 
* :py:data:`imgui.WINDOW_NO_SAVED_SETTINGS` 
* :py:data:`imgui.WINDOW_NO_INPUTS` 
* :py:data:`imgui.WINDOW_MENU_BAR` 
* :py:data:`imgui.WINDOW_HORIZONTAL_SCROLLING_BAR` 
* :py:data:`imgui.WINDOW_NO_FOCUS_ON_APPEARING` 
* :py:data:`imgui.WINDOW_NO_BRING_TO_FRONT_ON_FOCUS` 
* :py:data:`imgui.WINDOW_ALWAYS_VERTICAL_SCROLLBAR` 
* :py:data:`imgui.WINDOW_ALWAYS_HORIZONTAL_SCROLLBAR` 
* :py:data:`imgui.WINDOW_ALWAYS_USE_WINDOW_PADDING` 
