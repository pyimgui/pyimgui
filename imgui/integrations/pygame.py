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

        key_map[imgui.KEY_TAB] = pygame.K_TAB
        key_map[imgui.KEY_LEFT_ARROW] = pygame.K_LEFT
        key_map[imgui.KEY_RIGHT_ARROW] = pygame.K_RIGHT
        key_map[imgui.KEY_UP_ARROW] = pygame.K_UP
        key_map[imgui.KEY_DOWN_ARROW] = pygame.K_DOWN
        key_map[imgui.KEY_PAGE_UP] = pygame.K_PAGEUP
        key_map[imgui.KEY_PAGE_DOWN] = pygame.K_PAGEDOWN
        key_map[imgui.KEY_HOME] = pygame.K_HOME
        key_map[imgui.KEY_END] = pygame.K_END
        key_map[imgui.KEY_DELETE] = pygame.K_DELETE
        key_map[imgui.KEY_BACKSPACE] = pygame.K_BACKSPACE
        key_map[imgui.KEY_ENTER] = pygame.K_RETURN
        key_map[imgui.KEY_ESCAPE] = pygame.K_ESCAPE
        key_map[imgui.KEY_A] = pygame.K_a
        key_map[imgui.KEY_C] = pygame.K_c
        key_map[imgui.KEY_V] = pygame.K_v
        key_map[imgui.KEY_X] = pygame.K_x
        key_map[imgui.KEY_Y] = pygame.K_y
        key_map[imgui.KEY_Z] = pygame.K_z

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
            io.display_size = event.size
