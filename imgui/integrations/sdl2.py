# -*- coding: utf-8 -*-
from __future__ import absolute_import

from sdl2 import *

import imgui
import ctypes

from .opengl import ProgrammablePipelineRenderer


class SDL2Renderer(ProgrammablePipelineRenderer):
    """Basic SDL2 integration implementation."""
    MOUSE_WHEEL_OFFSET_SCALE = 0.5

    def __init__(self, window):
        super(SDL2Renderer, self).__init__()
        self.window = window

        self._mouse_pressed = [False, False, False]
        self._mouse_wheel = 0.0
        self._gui_time = None

        width_ptr = ctypes.pointer(ctypes.c_int(0))
        height_ptr = ctypes.pointer(ctypes.c_int(0))
        SDL_GetWindowSize(self.window, width_ptr, height_ptr)

        self.io.display_size = width_ptr[0], height_ptr[0]

        self._map_keys()

    def _map_keys(self):
        key_map = self.io.key_map

        key_map[imgui.KEY_TAB] = SDLK_TAB
        key_map[imgui.KEY_LEFT_ARROW] = SDL_SCANCODE_LEFT
        key_map[imgui.KEY_RIGHT_ARROW] = SDL_SCANCODE_RIGHT
        key_map[imgui.KEY_UP_ARROW] = SDL_SCANCODE_UP
        key_map[imgui.KEY_DOWN_ARROW] = SDL_SCANCODE_DOWN
        key_map[imgui.KEY_PAGE_UP] = SDL_SCANCODE_PAGEUP
        key_map[imgui.KEY_PAGE_DOWN] = SDL_SCANCODE_PAGEDOWN
        key_map[imgui.KEY_HOME] = SDL_SCANCODE_HOME
        key_map[imgui.KEY_END] = SDL_SCANCODE_END
        key_map[imgui.KEY_DELETE] = SDLK_DELETE
        key_map[imgui.KEY_BACKSPACE] = SDLK_BACKSPACE
        key_map[imgui.KEY_ENTER] = SDLK_RETURN
        key_map[imgui.KEY_ESCAPE] = SDLK_ESCAPE
        key_map[imgui.KEY_A] = SDLK_a
        key_map[imgui.KEY_C] = SDLK_c
        key_map[imgui.KEY_V] = SDLK_v
        key_map[imgui.KEY_X] = SDLK_x
        key_map[imgui.KEY_Y] = SDLK_y
        key_map[imgui.KEY_Z] = SDLK_z

    def process_event(self, event):
        io = self.io

        if event.type == SDL_MOUSEWHEEL:
            self._mouse_wheel = event.wheel.y * self.MOUSE_WHEEL_OFFSET_SCALE
            return True

        if event.type == SDL_MOUSEBUTTONDOWN:
            if event.button.button == SDL_BUTTON_LEFT:
                self._mouse_pressed[0] = True
            if event.button.button == SDL_BUTTON_RIGHT:
                self._mouse_pressed[1] = True
            if event.button.button == SDL_BUTTON_MIDDLE:
                self._mouse_pressed[2] = True
            return True

        if event.type == SDL_KEYUP or event.type == SDL_KEYDOWN:
            key = event.key.keysym.sym & ~SDLK_SCANCODE_MASK

            if key < SDL_NUM_SCANCODES:
                io.keys_down[key] = event.type == SDL_KEYDOWN

            io.key_shift = ((SDL_GetModState() & KMOD_SHIFT) != 0)
            io.key_ctrl = ((SDL_GetModState() & KMOD_CTRL) != 0)
            io.key_alt = ((SDL_GetModState() & KMOD_ALT) != 0)

            return True

        if event.type == SDL_TEXTINPUT:
            for char in event.text.text.decode('utf-8'):
                io.add_input_character(ord(char))
            return True

    def process_inputs(self):
        io = imgui.get_io()

        s_w = ctypes.pointer(ctypes.c_int(0))
        s_h = ctypes.pointer(ctypes.c_int(0))
        SDL_GetWindowSize(self.window, s_w, s_h)
        w = s_w.contents.value
        h = s_h.contents.value

        io.display_size = w, h
        io.display_fb_scale = 1, 1

        current_time = SDL_GetTicks() / 1000.0

        if self._gui_time:
            self.io.delta_time = current_time - self._gui_time
        else:
            self.io.delta_time = 1. / 60.
        self._gui_time = current_time

        mx = ctypes.pointer(ctypes.c_int(0))
        my = ctypes.pointer(ctypes.c_int(0))
        mouse_mask = SDL_GetMouseState(mx, my)

        if SDL_GetWindowFlags(self.window) & SDL_WINDOW_MOUSE_FOCUS:
            io.mouse_pos = mx.contents.value, my.contents.value
        else:
            io.mouse_pos = -1, -1

        io.mouse_down[0] = self._mouse_pressed[0] or (mouse_mask & SDL_BUTTON(SDL_BUTTON_LEFT)) != 0
        io.mouse_down[1] = self._mouse_pressed[1] or (mouse_mask & SDL_BUTTON(SDL_BUTTON_RIGHT)) != 0
        io.mouse_down[2] = self._mouse_pressed[2] or (mouse_mask & SDL_BUTTON(SDL_BUTTON_MIDDLE)) != 0
        self._mouse_pressed = [False, False, False]

        io.mouse_wheel = self._mouse_wheel
        self._mouse_wheel = 0
