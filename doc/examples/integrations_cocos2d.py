from __future__ import absolute_import

import cocos
from cocos.director import director

from pyglet import gl

from imgui.integrations.cocos2d import ImguiLayer
import imgui


class HelloWorld(ImguiLayer):
    is_event_handler = True

    def __init__(self):
        super(HelloWorld, self).__init__()
        self._text = "Input text here"

    def draw(self, *args, **kwargs):
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

        gl.glClearColor(1., 1., 1., 1)
        gl.glClear(gl.GL_COLOR_BUFFER_BIT)

        imgui.render()


def main():
    director.init(width=800, height=600, resizable=True)

    hello_layer = HelloWorld()
    main_scene = cocos.scene.Scene(hello_layer)
    director.run(main_scene)


if __name__ == "__main__":
    main()
