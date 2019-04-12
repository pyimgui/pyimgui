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

        self.renderer = FixedPipelineRenderer()
        self.io = imgui.get_io()
        self._map_keys()
