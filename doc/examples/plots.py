#!/usr/bin/env python
# -*- coding: utf-8 -*-

from array import array
from imgui.integrations.glfw import GlfwRenderer
from math import sin, pi
from random import random
from time import time
import OpenGL.GL as gl
import glfw
import imgui
import sys


C = 0.01
L = int(pi * 2 * 100)


def main():
    window = impl_glfw_init()
    imgui.create_context()
    impl = GlfwRenderer(window)

    plot_values = array("f", [sin(x * C) for x in range(L)])
    histogram_values = array("f", [random() for _ in range(20)])

    while not glfw.window_should_close(window):
        glfw.poll_events()
        impl.process_inputs()

        imgui.new_frame()

        imgui.begin("Plot example")
        imgui.plot_lines(
            "Sin(t)",
            plot_values,
            overlay_text="SIN() over time",
            # offset by one item every milisecond, plot values
            # buffer its end wraps around
            values_offset=int(time() * 100) % L,
            # 0=autoscale => (0, 50) = (autoscale width, 50px height)
            graph_size=(0, 50),
        )

        imgui.plot_histogram(
            "histogram(random())",
            histogram_values,
            overlay_text="random histogram",
            # offset by one item every milisecond, plot values
            # buffer its end wraps around
            graph_size=(0, 50),
        )

        imgui.end()

        gl.glClearColor(1.0, 1.0, 1.0, 1)
        gl.glClear(gl.GL_COLOR_BUFFER_BIT)

        imgui.render()
        impl.render(imgui.get_draw_data())
        glfw.swap_buffers(window)

    impl.shutdown()
    glfw.terminate()


def impl_glfw_init():
    width, height = 1280, 720
    window_name = "minimal ImGui/GLFW3 example"

    if not glfw.init():
        print("Could not initialize OpenGL context")
        sys.exit(1)

    # OS X supports only forward-compatible core profiles from 3.2
    glfw.window_hint(glfw.CONTEXT_VERSION_MAJOR, 3)
    glfw.window_hint(glfw.CONTEXT_VERSION_MINOR, 3)
    glfw.window_hint(glfw.OPENGL_PROFILE, glfw.OPENGL_CORE_PROFILE)

    glfw.window_hint(glfw.OPENGL_FORWARD_COMPAT, gl.GL_TRUE)

    # Create a windowed mode window and its OpenGL context
    window = glfw.create_window(int(width), int(height), window_name, None, None)
    glfw.make_context_current(window)

    if not window:
        glfw.terminate()
        print("Could not initialize Window")
        sys.exit(1)

    return window


if __name__ == "__main__":
    main()
