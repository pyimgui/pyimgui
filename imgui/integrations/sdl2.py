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
        self.io.get_clipboard_text_fn = self._get_clipboard_text
        self.io.set_clipboard_text_fn = self._set_clipboard_text

        self._map_keys()

    def _get_clipboard_text(self):
        return SDL_GetClipboardText()

    def _set_clipboard_text(self, text):
        SDL_SetClipboardText(ctypes.c_char_p(text.encode()))

    def _map_keys(self):
        key_map = self.io.key_map

        key_map[imgui.KEY_TAB] = SDL_SCANCODE_TAB
        key_map[imgui.KEY_LEFT_ARROW] = SDL_SCANCODE_LEFT
        key_map[imgui.KEY_RIGHT_ARROW] = SDL_SCANCODE_RIGHT
        key_map[imgui.KEY_UP_ARROW] = SDL_SCANCODE_UP
        key_map[imgui.KEY_DOWN_ARROW] = SDL_SCANCODE_DOWN
        key_map[imgui.KEY_PAGE_UP] = SDL_SCANCODE_PAGEUP
        key_map[imgui.KEY_PAGE_DOWN] = SDL_SCANCODE_PAGEDOWN
        key_map[imgui.KEY_HOME] = SDL_SCANCODE_HOME
        key_map[imgui.KEY_END] = SDL_SCANCODE_END
        key_map[imgui.KEY_INSERT] = SDL_SCANCODE_INSERT
        key_map[imgui.KEY_DELETE] = SDL_SCANCODE_DELETE
        key_map[imgui.KEY_BACKSPACE] = SDL_SCANCODE_BACKSPACE
        key_map[imgui.KEY_SPACE] = SDL_SCANCODE_SPACE
        key_map[imgui.KEY_ENTER] = SDL_SCANCODE_RETURN
        key_map[imgui.KEY_ESCAPE] = SDL_SCANCODE_ESCAPE
        key_map[imgui.KEY_PAD_ENTER] = SDL_SCANCODE_KP_ENTER
        key_map[imgui.KEY_A] = SDL_SCANCODE_A
        key_map[imgui.KEY_C] = SDL_SCANCODE_C
        key_map[imgui.KEY_V] = SDL_SCANCODE_V
        key_map[imgui.KEY_X] = SDL_SCANCODE_X
        key_map[imgui.KEY_Y] = SDL_SCANCODE_Y
        key_map[imgui.KEY_Z] = SDL_SCANCODE_Z

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
            key = event.key.keysym.scancode

            if key < SDL_NUM_SCANCODES:
                io.keys_down[key] = event.type == SDL_KEYDOWN

            io.key_shift = ((SDL_GetModState() & KMOD_SHIFT) != 0)
            io.key_ctrl = ((SDL_GetModState() & KMOD_CTRL) != 0)
            io.key_alt = ((SDL_GetModState() & KMOD_ALT) != 0)
            io.key_super = ((SDL_GetModState() & KMOD_GUI) != 0)

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
            io.delta_time = current_time - self._gui_time
        else:
            io.delta_time = 1. / 60.
        if(io.delta_time <= 0.0): io.delta_time = 1./ 1000.
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
