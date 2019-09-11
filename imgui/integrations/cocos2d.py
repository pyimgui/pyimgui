# -*- coding: utf-8 -*-
from __future__ import absolute_import

import cocos

import imgui

from .import compute_fb_scale
from .pyglet import PygletMixin
from .opengl import FixedPipelineRenderer


class ImguiLayer(PygletMixin, cocos.layer.Layer):
    is_event_handler = True

    def __init__(self):
        super(ImguiLayer, self).__init__()

        window_size = cocos.director.director.window.get_size()
        viewport_size = cocos.director.director.window.get_viewport_size()

        self.io = imgui.get_io()
        self.io.display_size = window_size
        self.io.display_fb_scale = compute_fb_scale(window_size, viewport_size)

        self.renderer = FixedPipelineRenderer()
        self._map_keys()
