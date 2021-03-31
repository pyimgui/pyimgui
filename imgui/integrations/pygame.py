from __future__ import absolute_import

from .opengl import FixedPipelineRenderer

import pygame
import pygame.event

import imgui


class PygameRenderer(FixedPipelineRenderer):
    def __init__(self):
        super(PygameRenderer, self).__init__()

        self._map_keys()

    def _map_keys(self):
        key_map = self.io.key_map
        # imgui key map value cannot over 512
        key_map[imgui.KEY_TAB] = (pygame.K_TAB & 0xFF)
        key_map[imgui.KEY_LEFT_ARROW] = (pygame.K_LEFT & 0xFF)
        key_map[imgui.KEY_RIGHT_ARROW] = (pygame.K_RIGHT & 0xFF)
        key_map[imgui.KEY_UP_ARROW] = (pygame.K_UP & 0xFF)
        key_map[imgui.KEY_DOWN_ARROW] = (pygame.K_DOWN & 0xFF)
        key_map[imgui.KEY_PAGE_UP] = (pygame.K_PAGEUP & 0xFF)
        key_map[imgui.KEY_PAGE_DOWN] = (pygame.K_PAGEDOWN & 0xFF)
        key_map[imgui.KEY_HOME] = (pygame.K_HOME & 0xFF)
        key_map[imgui.KEY_END] = (pygame.K_END & 0xFF)
        key_map[imgui.KEY_DELETE] = (pygame.K_DELETE & 0xFF)
        key_map[imgui.KEY_BACKSPACE] = (pygame.K_BACKSPACE & 0xFF)
        key_map[imgui.KEY_ENTER] = (pygame.K_RETURN & 0xFF)
        key_map[imgui.KEY_ESCAPE] = (pygame.K_ESCAPE & 0xFF)
        key_map[imgui.KEY_A] = (pygame.K_a & 0xFF)
        key_map[imgui.KEY_C] = (pygame.K_c & 0xFF)
        key_map[imgui.KEY_V] = (pygame.K_v & 0xFF)
        key_map[imgui.KEY_X] = (pygame.K_x & 0xFF)
        key_map[imgui.KEY_Y] = (pygame.K_y & 0xFF)
        key_map[imgui.KEY_Z] = (pygame.K_z & 0xFF)

    def process_event(self, event):
        # perf: local for faster access
        io = self.io

        if event.type == pygame.MOUSEMOTION:
            io.mouse_pos = event.pos

        if event.type == pygame.MOUSEBUTTONDOWN:
            if event.button == 1:
                io.mouse_down[0] = 1
            if event.button == 2:
                io.mouse_down[1] = 1
            if event.button == 3:
                io.mouse_down[2] = 1

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

        if event.type == pygame.KEYDOWN:
            for char in event.unicode:
                code = ord(char)
                if 0 < code < 0x10000:
                    io.add_input_character(code)

            io.keys_down[event.key] = True

        if event.type == pygame.KEYUP:
            io.keys_down[event.key] = False

        if event.type in (pygame.KEYDOWN, pygame.KEYUP):
            io.key_ctrl = (
                io.keys_down[pygame.K_LCTRL] or
                io.keys_down[pygame.K_RCTRL]
            )

            io.key_alt = (
                io.keys_down[pygame.K_LALT] or
                io.keys_down[pygame.K_RALT]
            )

            io.key_shift = (
                io.keys_down[pygame.K_LSHIFT] or
                io.keys_down[pygame.K_RSHIFT]
            )

            io.key_super = (
                io.keys_down[pygame.K_LSUPER] or
                io.keys_down[pygame.K_LSUPER]
            )

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
