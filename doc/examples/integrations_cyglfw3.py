# -*- coding: utf-8 -*-
import cyglfw3
import OpenGL.GL as gl

import imgui
from imgui.integrations.cyglfw3 import Cyglfw3Renderer


def main():
    imgui.create_context()
    window = impl_glfw_init()
    impl = Cyglfw3Renderer(window)

    while not cyglfw3.WindowShouldClose(window):
        cyglfw3.PollEvents()
        impl.process_inputs()

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
        impl.render(imgui.get_draw_data())
        cyglfw3.SwapBuffers(window)

    impl.shutdown()
    cyglfw3.Terminate()


def impl_glfw_init():
    width, height = 1280, 720
    window_name = "minimal ImGui/GLFW3 example"

    if not cyglfw3.Init():
        print("Could not initialize OpenGL context")
        exit(1)

    # OS X supports only forward-compatible core profiles from 3.2
    cyglfw3.WindowHint(cyglfw3.CONTEXT_VERSION_MAJOR, 3)
    cyglfw3.WindowHint(cyglfw3.CONTEXT_VERSION_MINOR, 3)
    cyglfw3.WindowHint(cyglfw3.OPENGL_PROFILE, cyglfw3.OPENGL_CORE_PROFILE)

    cyglfw3.WindowHint(cyglfw3.OPENGL_FORWARD_COMPAT, gl.GL_TRUE)

    # Create a windowed mode window and its OpenGL context
    window = cyglfw3.CreateWindow(
        int(width), int(height), window_name, None, None
    )
    cyglfw3.MakeContextCurrent(window)

    if not window:
        cyglfw3.Terminate()
        print("Could not initialize Window")
        exit(1)

    return window


if __name__ == "__main__":
    main()
