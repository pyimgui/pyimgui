# -*- coding: utf-8 -*-
from __future__ import absolute_import

import pyglet
from pyglet import gl

import imgui
# Note that we could explicitly choose to use PygletFixedPipelineRenderer
# or PygletProgrammablePipelineRenderer, but create_renderer handles the
# version checking for us.
from imgui.integrations.pyglet import create_renderer


def main():

    window = pyglet.window.Window(width=1280, height=720, resizable=True)
    gl.glClearColor(1, 1, 1, 1)
    imgui.create_context()
    impl = create_renderer(window)

    def update(dt):
        imgui.new_frame()
        if imgui.begin_main_menu_bar():
            if imgui.begin_menu("File", True):

                clicked_quit, selected_quit = imgui.menu_item(
                    "Quit", 'Cmd+Q', False, True
                )

                if clicked_quit:
                    exit(1)

                imgui.end_menu()
            imgui.end_main_menu_bar()

        imgui.show_test_window()

        imgui.begin("Custom window", True)
        imgui.text("Bar")
        imgui.text_colored("Eggs", 0.2, 1., 0.)
        imgui.end()

    @window.event
    def on_draw():
        update(1/60.0)
        window.clear()
        imgui.render()
        impl.render(imgui.get_draw_data())

    pyglet.app.run()
    impl.shutdown()


if __name__ == "__main__":
    main()
