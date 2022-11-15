#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import absolute_import

import sys
backend = "pygame"
if "sdl2" in sys.argv:
    backend = "sdl2"
elif "pygame" in sys.argv:
    backend = "pygame"
elif "glfw" in sys.argv:
    backend = "glfw"
elif "cocos2d" in sys.argv:
    backend = "cocos2d"
sys.stderr.write("%s backend selected\n" % backend)

if backend == "sdl2":
    from sdl2 import *
    import ctypes
    from imgui.integrations.sdl2 import SDL2Renderer
elif backend == "pygame":
    import pygame
    from imgui.integrations.pygame import PygameRenderer
elif backend == "glfw":
    import glfw
    from imgui.integrations.glfw import GlfwRenderer
elif backend == "cocos2d":
    import cocos
    from cocos.director import director
    from imgui.integrations.cocos2d import ImguiLayer

import OpenGL.GL as gl
import imgui


def main_sdl2():
    def pysdl2_init():
        width, height = 1280, 720
        window_name = "minimal ImGui/SDL2 example"
        if SDL_Init(SDL_INIT_EVERYTHING) < 0:
            print("Error: SDL could not initialize! SDL Error: " + SDL_GetError())
            exit(1)
        SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1)
        SDL_GL_SetAttribute(SDL_GL_DEPTH_SIZE, 24)
        SDL_GL_SetAttribute(SDL_GL_STENCIL_SIZE, 8)
        SDL_GL_SetAttribute(SDL_GL_ACCELERATED_VISUAL, 1)
        SDL_GL_SetAttribute(SDL_GL_MULTISAMPLEBUFFERS, 1)
        SDL_GL_SetAttribute(SDL_GL_MULTISAMPLESAMPLES, 8)
        SDL_GL_SetAttribute(SDL_GL_CONTEXT_FLAGS, SDL_GL_CONTEXT_FORWARD_COMPATIBLE_FLAG)
        SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 4)
        SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 1)
        SDL_GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK, SDL_GL_CONTEXT_PROFILE_CORE)
        SDL_SetHint(SDL_HINT_MAC_CTRL_CLICK_EMULATE_RIGHT_CLICK, b"1")
        SDL_SetHint(SDL_HINT_VIDEO_HIGHDPI_DISABLED, b"1")
        window = SDL_CreateWindow(window_name.encode('utf-8'),
                                SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED,
                                width, height,
                                SDL_WINDOW_OPENGL|SDL_WINDOW_RESIZABLE)
        if window is None:
            print("Error: Window could not be created! SDL Error: " + SDL_GetError())
            exit(1)
        gl_context = SDL_GL_CreateContext(window)
        if gl_context is None:
            print("Error: Cannot create OpenGL Context! SDL Error: " + SDL_GetError())
            exit(1)
        SDL_GL_MakeCurrent(window, gl_context)
        if SDL_GL_SetSwapInterval(1) < 0:
            print("Warning: Unable to set VSync! SDL Error: " + SDL_GetError())
            exit(1)
        return window, gl_context
    window, gl_context = pysdl2_init()
    renderer = SDL2Renderer(window)
    running = True
    event = SDL_Event()
    while running:
        while SDL_PollEvent(ctypes.byref(event)) != 0:
            if event.type == SDL_QUIT:
                running = False
                break
            renderer.process_event(event)
        renderer.process_inputs()
        imgui.new_frame()
        on_frame()
        gl.glClearColor(1., 1., 1., 1)
        gl.glClear(gl.GL_COLOR_BUFFER_BIT)
        imgui.render()
        SDL_GL_SwapWindow(window)
    renderer.shutdown()
    SDL_GL_DeleteContext(gl_context)
    SDL_DestroyWindow(window)
    SDL_Quit()


def main_pygame():
    pygame.init()
    size = 800, 600
    pygame.display.set_mode(size, pygame.DOUBLEBUF | pygame.OPENGL | pygame.RESIZABLE)
    
    imgui.create_context()
    impl = PygameRenderer()
    
    io = imgui.get_io()
    io.fonts.add_font_default()
    io.display_size = size
    
    show_custom_window = True
    
    while 1:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                sys.exit()
            impl.process_event(event)
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

        if show_custom_window:
            is_expand, show_custom_window = imgui.begin("Custom window", True)
            if is_expand:
                imgui.text("Bar")
                imgui.text_colored("Eggs", 0.2, 1., 0.)
            imgui.end()
        
        # note: cannot use screen.fill((1, 1, 1)) because pygame's screen
        #       does not support fill() on OpenGL sufraces
        gl.glClearColor(1, 1, 1, 1)
        gl.glClear(gl.GL_COLOR_BUFFER_BIT)
        imgui.render()
        impl.render(imgui.get_draw_data())
        pygame.display.flip()


def main_glfw():
    def glfw_init():
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
    window = glfw_init()
    impl = GlfwRenderer(window)
    while not glfw.window_should_close(window):
        glfw.poll_events()
        impl.process_inputs()
        imgui.new_frame()
        on_frame()
        gl.glClearColor(1., 1., 1., 1)
        gl.glClear(gl.GL_COLOR_BUFFER_BIT)
        imgui.render()
        impl.render(imgui.get_draw_data())
        glfw.swap_buffers(window)
    impl.shutdown()
    glfw.terminate()


def main_cocos2d():
    class HelloWorld(ImguiLayer):
        is_event_handler = True

        def __init__(self):
            super(HelloWorld, self).__init__()
            self._text = "Input text here"

        def draw(self, *args, **kwargs):
            self.process_inputs()
            imgui.new_frame()
            on_frame()
            gl.glClearColor(1., 1., 1., 1)
            gl.glClear(gl.GL_COLOR_BUFFER_BIT)
            imgui.render()

    director.init(width=800, height=600, resizable=True)
    hello_layer = HelloWorld()
    main_scene = cocos.scene.Scene(hello_layer)
    director.run(main_scene)


# backend-independent frame rendering function:
def on_frame():
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


if __name__ == "__main__":
    imgui.create_context()
    io = imgui.get_io()

    if backend == "sdl2":
        main_sdl2()
    elif backend == "pygame":
        main_pygame()
    elif backend == "glfw":
        main_glfw()
    elif backend == "cocos2d":
        main_cocos2d()
