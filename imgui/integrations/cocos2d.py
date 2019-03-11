# -*- coding: utf-8 -*-
from __future__ import absolute_import

import cocos

import imgui
from .pyglet import PygletMixin
from .opengl import FixedPipelineRenderer


class ImguiLayer(PygletMixin, cocos.layer.Layer):
    is_event_handler = True

    def __init__(self):
        super(ImguiLayer, self).__init__()

        self.renderer = None
        self.io = imgui.get_io()

        self._map_keys()

    def on_enter(self):
        super(ImguiLayer, self).on_enter()

        if self.renderer is None:
            self.io.display_size = cocos.director.director.get_window_size()
            self.renderer = FixedPipelineRenderer()
