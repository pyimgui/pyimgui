# -*- coding: utf-8 -*-
from __future__ import absolute_import

from sdl3 import *

import imgui, ctypes

from .opengl import ProgrammablePipelineRenderer


class SDL3Renderer(ProgrammablePipelineRenderer):
    """Basic SDL3 integration implementation."""
    MOUSE_WHEEL_OFFSET_SCALE = 0.5

    def __init__(self, window):
        super(SDL3Renderer, self).__init__()
        self.window = window

        SDL_StartTextInput(self.window)
        width, height = ctypes.c_int(0), ctypes.c_int(0)
        SDL_GetWindowSize(self.window, ctypes.byref(width), ctypes.byref(height))

        self.io.display_size = width.value, height.value
        self.io.get_clipboard_text_fn = self._get_clipboard_text
        self.io.set_clipboard_text_fn = self._set_clipboard_text
        self._gui_time, self._mouse_wheel = None, 0.0

        self._map_keys()

    def _get_clipboard_text(self):
        return SDL_GetClipboardText()

    def _set_clipboard_text(self, text):
        SDL_SetClipboardText(text.encode())

    def _map_keys(self) -> None:
        self.io.key_map[imgui.KEY_TAB] = SDL_SCANCODE_TAB
        self.io.key_map[imgui.KEY_LEFT_ARROW] = SDL_SCANCODE_LEFT
        self.io.key_map[imgui.KEY_RIGHT_ARROW] = SDL_SCANCODE_RIGHT
        self.io.key_map[imgui.KEY_UP_ARROW] = SDL_SCANCODE_UP
        self.io.key_map[imgui.KEY_DOWN_ARROW] = SDL_SCANCODE_DOWN
        self.io.key_map[imgui.KEY_PAGE_UP] = SDL_SCANCODE_PAGEUP
        self.io.key_map[imgui.KEY_PAGE_DOWN] = SDL_SCANCODE_PAGEDOWN
        self.io.key_map[imgui.KEY_HOME] = SDL_SCANCODE_HOME
        self.io.key_map[imgui.KEY_END] = SDL_SCANCODE_END
        self.io.key_map[imgui.KEY_INSERT] = SDL_SCANCODE_INSERT
        self.io.key_map[imgui.KEY_DELETE] = SDL_SCANCODE_DELETE
        self.io.key_map[imgui.KEY_BACKSPACE] = SDL_SCANCODE_BACKSPACE
        self.io.key_map[imgui.KEY_SPACE] = SDL_SCANCODE_SPACE
        self.io.key_map[imgui.KEY_ENTER] = SDL_SCANCODE_RETURN
        self.io.key_map[imgui.KEY_ESCAPE] = SDL_SCANCODE_ESCAPE
        self.io.key_map[imgui.KEY_PAD_ENTER] = SDL_SCANCODE_KP_ENTER
        self.io.key_map[imgui.KEY_A] = SDL_SCANCODE_A
        self.io.key_map[imgui.KEY_C] = SDL_SCANCODE_C
        self.io.key_map[imgui.KEY_V] = SDL_SCANCODE_V
        self.io.key_map[imgui.KEY_X] = SDL_SCANCODE_X
        self.io.key_map[imgui.KEY_Y] = SDL_SCANCODE_Y
        self.io.key_map[imgui.KEY_Z] = SDL_SCANCODE_Z

    def process_event(self, event):
        if event.type in [SDL_EVENT_MOUSE_WHEEL]:
            self._mouse_wheel = event.wheel.y * self.MOUSE_WHEEL_OFFSET_SCALE

        elif event.type in [SDL_EVENT_MOUSE_BUTTON_UP, SDL_EVENT_MOUSE_BUTTON_DOWN]:
            buttons = [SDL_BUTTON_LEFT, SDL_BUTTON_RIGHT, SDL_BUTTON_MIDDLE]

            if event.button.button in buttons:
                self.io.mouse_down[buttons.index(event.button.button)] = (event.type != SDL_EVENT_MOUSE_BUTTON_UP)

        elif event.type in [SDL_EVENT_MOUSE_MOTION]:
            self.io.mouse_pos = (event.motion.x, event.motion.y) \
                if SDL_GetWindowFlags(self.window) & SDL_WINDOW_MOUSE_FOCUS else (-1, -1)

        elif event.type in [SDL_EVENT_KEY_UP, SDL_EVENT_KEY_DOWN]:
            if event.key.scancode < SDL_SCANCODE_COUNT:
                self.io.keys_down[event.key.scancode] = (event.type != SDL_EVENT_KEY_UP)

            self.io.key_shift = (SDL_GetModState() & SDL_KMOD_SHIFT) != 0
            self.io.key_ctrl = (SDL_GetModState() & SDL_KMOD_CTRL) != 0
            self.io.key_alt = (SDL_GetModState() & SDL_KMOD_ALT) != 0
            self.io.key_super = (SDL_GetModState() & SDL_KMOD_GUI) != 0

        elif event.type in [SDL_EVENT_TEXT_INPUT]:
            for char in event.text.text.decode('utf-8'):
                self.io.add_input_character(ord(char))

        else:
            return False
        
        return True

    def process_inputs(self):
        width, height = ctypes.c_int(0), ctypes.c_int(0)
        SDL_GetWindowSize(self.window, ctypes.byref(width), ctypes.byref(height))
        self.io.display_size, self.io.display_fb_scale = (width.value, height.value), (1, 1)
        self.io.mouse_wheel, self._mouse_wheel = self._mouse_wheel, 0.0

        current_time = SDL_GetTicks() / 1000.0
        self.io.delta_time = (current_time - self._gui_time) if self._gui_time else (1.0 / 60.0)
        if (self.io.delta_time <= 0.0): self.io.delta_time = 1.0 / 10000.0
        self._gui_time = current_time