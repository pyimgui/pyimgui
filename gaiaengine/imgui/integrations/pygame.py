from __future__ import absolute_import

from .opengl import FixedPipelineRenderer

import pygame
import pygame.event
import pygame.time

import imgui


class PygameRenderer(FixedPipelineRenderer):
    def __init__(self):
        super(PygameRenderer, self).__init__()

        self._gui_time = None
        self.custom_key_map = {}

        self._map_keys()

    def _custom_key(self, key):
        # We need to go to custom keycode since imgui only support keycod from 0..512 or -1
        if not key in self.custom_key_map:
            self.custom_key_map[key] = len(self.custom_key_map)
        return self.custom_key_map[key]

    def _map_keys(self):
        key_map = self.io.key_map

        key_map[imgui.KEY_TAB] = self._custom_key(pygame.K_TAB)
        key_map[imgui.KEY_LEFT_ARROW] = self._custom_key(pygame.K_LEFT)
        key_map[imgui.KEY_RIGHT_ARROW] = self._custom_key(pygame.K_RIGHT)
        key_map[imgui.KEY_UP_ARROW] = self._custom_key(pygame.K_UP)
        key_map[imgui.KEY_DOWN_ARROW] = self._custom_key(pygame.K_DOWN)
        key_map[imgui.KEY_PAGE_UP] = self._custom_key(pygame.K_PAGEUP)
        key_map[imgui.KEY_PAGE_DOWN] = self._custom_key(pygame.K_PAGEDOWN)
        key_map[imgui.KEY_HOME] = self._custom_key(pygame.K_HOME)
        key_map[imgui.KEY_END] = self._custom_key(pygame.K_END)
        key_map[imgui.KEY_INSERT] = self._custom_key(pygame.K_INSERT)
        key_map[imgui.KEY_DELETE] = self._custom_key(pygame.K_DELETE)
        key_map[imgui.KEY_BACKSPACE] = self._custom_key(pygame.K_BACKSPACE)
        key_map[imgui.KEY_SPACE] = self._custom_key(pygame.K_SPACE)
        key_map[imgui.KEY_ENTER] = self._custom_key(pygame.K_RETURN)
        key_map[imgui.KEY_ESCAPE] = self._custom_key(pygame.K_ESCAPE)
        key_map[imgui.KEY_PAD_ENTER] = self._custom_key(pygame.K_KP_ENTER)
        key_map[imgui.KEY_A] = self._custom_key(pygame.K_a)
        key_map[imgui.KEY_C] = self._custom_key(pygame.K_c)
        key_map[imgui.KEY_V] = self._custom_key(pygame.K_v)
        key_map[imgui.KEY_X] = self._custom_key(pygame.K_x)
        key_map[imgui.KEY_Y] = self._custom_key(pygame.K_y)
        key_map[imgui.KEY_Z] = self._custom_key(pygame.K_z)

    def process_event(self, event):
        # perf: local for faster access
        io = self.io

        if event.type == pygame.MOUSEMOTION:
            io.mouse_pos = event.pos
            return True

        if event.type == pygame.MOUSEBUTTONDOWN:
            if event.button == 1:
                io.mouse_down[0] = 1
            if event.button == 2:
                io.mouse_down[1] = 1
            if event.button == 3:
                io.mouse_down[2] = 1
            return True 

        if event.type == pygame.MOUSEBUTTONUP:
            if event.button == 1:
                io.mouse_down[0] = 0
            if event.button == 2:
                io.mouse_down[1] = 0
            if event.button == 3:
                io.mouse_down[2] = 0
            if event.button == 4:
                io.mouse_wheel = .5
            if event.button == 5:
                io.mouse_wheel = -.5
            return True

        if event.type == pygame.KEYDOWN:
            for char in event.unicode:
                code = ord(char)
                if 0 < code < 0x10000:
                    io.add_input_character(code)

            io.keys_down[self._custom_key(event.key)] = True

        if event.type == pygame.KEYUP:
            io.keys_down[self._custom_key(event.key)] = False

        if event.type in (pygame.KEYDOWN, pygame.KEYUP):
            io.key_ctrl = (
                io.keys_down[self._custom_key(pygame.K_LCTRL)] or
                io.keys_down[self._custom_key(pygame.K_RCTRL)]
            )

            io.key_alt = (
                io.keys_down[self._custom_key(pygame.K_LALT)] or
                io.keys_down[self._custom_key(pygame.K_RALT)]
            )

            io.key_shift = (
                io.keys_down[self._custom_key(pygame.K_LSHIFT)] or
                io.keys_down[self._custom_key(pygame.K_RSHIFT)]
            )

            io.key_super = (
                io.keys_down[self._custom_key(pygame.K_LSUPER)] or
                io.keys_down[self._custom_key(pygame.K_LSUPER)]
            )
            
            return True

        if event.type == pygame.VIDEORESIZE:
            surface = pygame.display.get_surface()
            # note: pygame does not modify existing surface upon resize,
            #       we need to to it ourselves.
            pygame.display.set_mode(
                (event.w, event.h),
                flags=surface.get_flags(),
            )
            # existing font texure is no longer valid, so we need to refresh it
            self.refresh_font_texture()

            # notify imgui about new window size
            io.display_size = event.size

            # delete old surface, it is no longer needed
            del surface
            
            return True
    def process_inputs(self):
        io = imgui.get_io()
        
        current_time = pygame.time.get_ticks() / 1000.0

        if self._gui_time:
            io.delta_time = current_time - self._gui_time
        else:
            io.delta_time = 1. / 60.
        if(io.delta_time <= 0.0): io.delta_time = 1./ 1000.
        self._gui_time = current_time
        
        
        
        
        
        
        