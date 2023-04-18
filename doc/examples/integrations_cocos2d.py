#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import absolute_import
from cocos.director import director
from imgui.integrations.cocos2d import ImguiLayer
from pyglet import gl
import cocos
import imgui
import sys


class HelloWorld(ImguiLayer):
    is_event_handler = True

    def __init__(self):
        super(HelloWorld, self).__init__()
        self._text = "Input text here"
        self.show_custom_window = True

    def draw(self, *args, **kwargs):
        self.process_inputs()
        imgui.new_frame()

        if imgui.begin_main_menu_bar():
            if imgui.begin_menu("File", True):

                clicked_quit, selected_quit = imgui.menu_item(
                    "Quit", "Cmd+Q", False, True
                )

                if clicked_quit:
                    sys.exit()

                imgui.end_menu()
            imgui.end_main_menu_bar()

        imgui.show_test_window()

        if self.show_custom_window:
            is_expand, self.show_custom_window = imgui.begin("Custom window", True)
            if is_expand:
                imgui.text("Bar")
                imgui.text_colored("Eggs", 0.2, 1.0, 0.0)
            imgui.end()

        gl.glClearColor(1.0, 1.0, 1.0, 1)
        gl.glClear(gl.GL_COLOR_BUFFER_BIT)

        imgui.render()
        self.renderer.render(imgui.get_draw_data())


def main():
    director.init(width=800, height=600, resizable=True)

    imgui.create_context()
    hello_layer = HelloWorld()

    main_scene = cocos.scene.Scene(hello_layer)
    director.run(main_scene)


if __name__ == "__main__":
    main()
