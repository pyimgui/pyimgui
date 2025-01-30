#!/usr/bin/env python
# -*- coding: utf-8 -*-

from imgui.integrations.sdl3 import SDL3Renderer
from testwindow import show_test_window
from sdl3 import *
import OpenGL.GL as gl
import ctypes
import imgui
import sys


def main():
    if SDL_Init(SDL_INIT_VIDEO | SDL_INIT_EVENTS) < 0:
        print("Error: SDL could not initialize! SDL Error: " + SDL_GetError().decode())
        sys.exit(1)

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
    SDL_SetHint(SDL_HINT_MAC_CTRL_CLICK_EMULATE_RIGHT_CLICK, "1".encode())

    window = SDL_CreateWindow("minimal ImGui/SDL3 example".encode(), 1280, 720, SDL_WINDOW_OPENGL | SDL_WINDOW_RESIZABLE,)

    if window is None:
        print("Error: Window could not be created! SDL Error: " + SDL_GetError().decode())
        sys.exit(1)

    gl_context = SDL_GL_CreateContext(window)

    if gl_context is None:
        print("Error: Cannot create OpenGL Context! SDL Error: " + SDL_GetError().decode())
        sys.exit(1)

    SDL_GL_MakeCurrent(window, gl_context)

    if not SDL_GL_SetSwapInterval(1):
        print("Warning: Unable to set VSync! SDL Error: " + SDL_GetError().decode())
        sys.exit(1)

    imgui.create_context()
    impl = SDL3Renderer(window)
    event, running = SDL_Event(), True
    show_custom_window = True

    while running:
        while SDL_PollEvent(ctypes.byref(event)) != 0:
            impl.process_event(event)

            if event.type == SDL_EVENT_QUIT:
                running = False

        impl.process_inputs()
        imgui.new_frame()

        if imgui.begin_main_menu_bar():
            if imgui.begin_menu("File", True):
                clicked_quit, selected_quit = imgui.menu_item("Quit", "Cmd+Q", False, True)
                if clicked_quit: sys.exit(0)
                imgui.end_menu()

            imgui.end_main_menu_bar()

        show_test_window()
        # imgui.show_test_window()

        if show_custom_window:
            is_expand, show_custom_window = imgui.begin("Custom window", True)

            if is_expand:
                imgui.text("Bars")
                imgui.text_colored("Eggs", 0.2, 1.0, 0.0)

            imgui.end()

        gl.glClearColor(1.0, 1.0, 1.0, 1)
        gl.glClear(gl.GL_COLOR_BUFFER_BIT)

        imgui.render()
        impl.render(imgui.get_draw_data())
        SDL_GL_SwapWindow(window)

    impl.shutdown()
    SDL_GL_DestroyContext(gl_context)
    SDL_DestroyWindow(window)
    SDL_Quit()

if __name__ == "__main__":
    main()
