.. _guide-draw-flags:

Using draw flags
================


Certains commands link with the DrawList do accept a flag parameter to customise
how lines and shapes are drawn. This argument is an integer bitfield
so many different flags can be joined together with ``|`` operator.

It has to be noted that not all flag apply to all functions using them. For
example :func:`_DrawList.path_stroke()` do not use the rounded corner flags.

.. visual-example::
    :auto_layout:
    :width: 320
    :title: Draw flags


    imgui.set_next_window_size(300, 300)
    imgui.set_next_window_position(10, 0)
    imgui.begin("Draw flags examples")

    draw_list = imgui.get_window_draw_list()
    draw_list.path_clear()
    draw_list.path_line_to(80, 80)
    draw_list.path_arc_to(80, 80, 30, 0.5, 5.5)
    draw_list.path_stroke(imgui.get_color_u32_rgba(1,1,0,1),
            flags=imgui.DRAW_CLOSED, thickness=10)

    draw_list.path_clear()
    draw_list.path_line_to(240, 80)
    draw_list.path_arc_to(240, 80, 30, 0.5, 5.5)
    draw_list.path_stroke(imgui.get_color_u32_rgba(1,1,0,1),
            flags=imgui.DRAW_NONE, thickness=10)

    draw_list.add_rect(20, 135, 60, 190,
            imgui.get_color_u32_rgba(1,1,0,1), rounding=5,
            flags=imgui.DRAW_ROUND_CORNERS_ALL, thickness=10)
    draw_list.add_rect(100, 135, 140, 190,
            imgui.get_color_u32_rgba(1,1,0,1), rounding=5,
            flags=imgui.DRAW_ROUND_CORNERS_NONE, thickness=10)
    draw_list.add_rect(180, 135, 220, 190,
            imgui.get_color_u32_rgba(1,1,0,1), rounding=5,
            flags=imgui.DRAW_ROUND_CORNERS_LEFT, thickness=10)
    draw_list.add_rect(260, 135, 300, 190,
            imgui.get_color_u32_rgba(1,1,0,1), rounding=5,
            flags=imgui.DRAW_ROUND_CORNERS_BOTTOM_RIGHT, thickness=10)

    imgui.end()


List of all available draw flags (click to see documentation):

.. _draw-flag-options:

* :py:data:`imgui.DRAW_NONE`
* :py:data:`imgui.DRAW_CLOSED`
* :py:data:`imgui.DRAW_ROUND_CORNERS_TOP_LEFT`
* :py:data:`imgui.DRAW_ROUND_CORNERS_TOP_RIGHT`
* :py:data:`imgui.DRAW_ROUND_CORNERS_BOTTOM_LEFT`
* :py:data:`imgui.DRAW_ROUND_CORNERS_BOTTOM_RIGHT`
* :py:data:`imgui.DRAW_ROUND_CORNERS_NONE`
* :py:data:`imgui.DRAW_ROUND_CORNERS_TOP`
* :py:data:`imgui.DRAW_ROUND_CORNERS_BOTTOM`
* :py:data:`imgui.DRAW_ROUND_CORNERS_LEFT`
* :py:data:`imgui.DRAW_ROUND_CORNERS_RIGHT`
* :py:data:`imgui.DRAW_ROUND_CORNERS_ALL`
