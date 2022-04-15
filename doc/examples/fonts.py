# -*- coding: utf-8 -*-
import os
import random
from glob import glob

import glfw
import OpenGL.GL as gl
import imgui
from imgui.integrations.glfw import GlfwRenderer


# use fonts bundled with imgui core project repository
FONTS_DIR = glob(
    os.path.join(
        os.path.dirname(__file__),
        '..', '..', 'imgui-cpp', 'misc', 'fonts', "*.ttf"
    )
)

FONT_SIZE_IN_PIXELS = 20


def fb_to_window_factor(window):
    win_w, win_h = glfw.get_window_size(window)
    fb_w, fb_h = glfw.get_framebuffer_size(window)

    return max(float(fb_w) / win_w, float(fb_h) / win_h)


def main():
    imgui.create_context()
    window = impl_glfw_init()
    impl = GlfwRenderer(window)
    font_scaling_factor = fb_to_window_factor(window)

    io = impl.io

    # clear font atlas to avoid downscaled default font
    # on highdensity screens. First font added to font
    # atlas will become default font.
    io.fonts.clear()

    # set global font scaling
    io.font_global_scale = 1. / font_scaling_factor

    # dictionary of font objects from our font directory
    null_font_config = None
    fonts = {
        os.path.split(font_path)[-1]: io.fonts.add_font_from_file_ttf(
            font_path,
            FONT_SIZE_IN_PIXELS * font_scaling_factor,
            null_font_config,
            io.fonts.get_glyph_ranges_latin()
        )
        for font_path in FONTS_DIR
    }

    secondary_window_main_font = random.choice(list(fonts.values()))

    impl.refresh_font_texture()

    while not glfw.window_should_close(window):
        glfw.poll_events()
        impl.process_inputs()

        imgui.new_frame()

        imgui.begin("Window with multiple custom fonts", True)
        imgui.text("This example showcases font usage on text() widget")

        for font_name, font in fonts.items():
            imgui.separator()

            imgui.text("Font:{}".format(font_name))

            with imgui.font(font):
                imgui.text("This text uses '{}' font.".format(font_name))

        imgui.end()

        with imgui.font(secondary_window_main_font):
            imgui.begin("Window one main custom font", True)
            imgui.text("This window uses same custom font for all widgets")
            imgui.end()

        gl.glClearColor(1., 1., 1., 1)
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

    return window


if __name__ == "__main__":
    main()
