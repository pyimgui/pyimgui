# -*- coding: utf-8 -*-
import glfw
import OpenGL.GL as gl

import imgui
from imgui.impl import GlfwImpl


def main():
    width, height = 1280, 720
    window_name = "minimal ImGui/GLFW3 example"

    if not glfw.init():
        print("Could not initialize OpenGL context")
        exit(1)

    # OS X supports only forward-compatible core profiles from 3.2
    glfw.window_hint(glfw.CONTEXT_VERSION_MAJOR, 3)
    glfw.window_hint(glfw.CONTEXT_VERSION_MINOR, 3)
    glfw.window_hint(glfw.OPENGL_PROFILE, glfw.OPENGL_CORE_PROFILE)

    glfw.window_hint(glfw.OPENGL_FORWARD_COMPAT, gl.GL_TRUE)

    # Create a windowed mode window and its OpenGL context
    window = glfw.create_window(
        int(width), int(height), window_name, None, None
    )
    glfw.make_context_current(window)

    if not window:
        glfw.terminate()
        print("Could not initialize Window")
        exit(1)

    imgui_ctx = GlfwImpl(window)
    imgui_ctx.enable()

    opened = True

    style = imgui.GuiStyle()

    while not glfw.window_should_close(window):
        glfw.poll_events()
        imgui_ctx.new_frame()

        imgui.show_user_guide()
        imgui.show_test_window()

        if opened:
            expanded, opened = imgui.begin("fooo", True)
            imgui.text("Bar")
            imgui.text_colored("Eggs", 0.2, 1., 0.)
            imgui.end()

        with imgui.styled(imgui.STYLE_ALPHA, 1):
            imgui.show_metrics_window()

        imgui.show_style_editor(style)

        # note: this is redundant
        width, height = glfw.get_framebuffer_size(window)
        gl.glViewport(0, 0, int(width/2), int(height))

        gl.glClearColor(114/255., 144/255., 154/255., 1)
        gl.glClear(gl.GL_COLOR_BUFFER_BIT)

        imgui.render()
        glfw.swap_buffers(window)

    glfw.terminate()


if __name__ == "__main__":
    main()
