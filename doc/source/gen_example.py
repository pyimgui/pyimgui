# -*- coding: utf-8 -*-
from inspect import cleandoc
import os

import glfw
import OpenGL.GL as gl
from PIL import Image

import imgui
from imgui.impl import GlfwImpl


def render_snippet(
    source,
    file_path,
    title="",
    width=200,
    height=200,
    auto_window=False,
    auto_layout=False,
    output_dir='.',
):
    code = compile(source, '<str>', 'exec')
    window_name = "minimal ImGui/GLFW3 example"

    if not glfw.init():
        print("Could not initialize OpenGL context")
        exit(1)

    # OS X supports only forward-compatible core profiles from 3.2
    glfw.window_hint(glfw.CONTEXT_VERSION_MAJOR, 3)
    glfw.window_hint(glfw.CONTEXT_VERSION_MINOR, 3)
    glfw.window_hint(glfw.OPENGL_PROFILE, glfw.OPENGL_CORE_PROFILE)
    glfw.window_hint(glfw.OPENGL_FORWARD_COMPAT, gl.GL_TRUE)
    # note: creating context without window is tricky so made window invisible
    glfw.window_hint(glfw.VISIBLE, False)

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
    glfw.poll_events()

    # render target for framebuffer
    texture = gl.glGenTextures(1)
    gl.glBindTexture(gl.GL_TEXTURE_2D, texture)
    gl.glTexImage2D(gl.GL_TEXTURE_2D, 0, gl.GL_RGBA, width, height, 0, gl.GL_RGB, gl.GL_UNSIGNED_BYTE, None)
    gl.glTexParameteri(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_MAG_FILTER, gl.GL_NEAREST)
    gl.glTexParameteri(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_MIN_FILTER, gl.GL_NEAREST)

    # create new framebuffer
    offscreen_fb = gl.glGenFramebuffers(1)
    gl.glBindFramebuffer(gl.GL_FRAMEBUFFER, offscreen_fb)
    # attach texture to framebuffer
    gl.glFramebufferTexture2D(gl.GL_FRAMEBUFFER, gl.GL_COLOR_ATTACHMENT0, gl.GL_TEXTURE_2D, texture, 0)

    imgui_ctx.new_frame()

    with imgui.styled(imgui.STYLE_ALPHA, 1):
        imgui.core.set_next_window_size(0, 0)

        if auto_layout:
            imgui.set_next_window_size(width - 10, height - 10)
            imgui.set_next_window_centered()

        if auto_window:
            imgui.set_next_window_size(width - 10, height - 10)
            imgui.set_next_window_centered()
            imgui.begin("Example: %s" % title)

        exec(code, locals(), globals())

        if auto_window:
            imgui.end()

    gl.glBindFramebuffer(gl.GL_FRAMEBUFFER, offscreen_fb)

    gl.glClearColor(1, 1, 1, 0)
    gl.glClear(gl.GL_COLOR_BUFFER_BIT)

    imgui.render()

    # retrieve pixels from framebuffer and write to file
    pixels = gl.glReadPixels(0, 0, width, height, gl.GL_RGBA, gl.GL_UNSIGNED_BYTE)

    image = Image.frombytes('RGBA', (width, height), pixels)
    # note: glReadPixels returns lines "bottom to top" but PIL reads bytes
    #       top to bottom
    image = image.transpose(Image.FLIP_TOP_BOTTOM)
    image.save(os.path.join(output_dir, file_path))

    glfw.terminate()


if __name__ == "__main__":
    example_source = cleandoc(
        """
        imgui.text("Bar")
        imgui.text_colored("Eggs", 0.2, 1., 0.)
        """
    )

    render_snippet(example_source, 'example_snippet.png')

