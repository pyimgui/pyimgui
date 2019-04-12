# -*- coding: utf-8 -*-
from __future__ import absolute_import

from warnings import warn


warn(
    """
    Integration layer in imgui.integrations is still in experimental mode.
    Expect major changes in future versions. For safety it is recommended
    to use code vendoring for specific integration impementation.

    This subpackage should become stable in 1.0.0 version.

    """, FutureWarning
)


def compute_fb_scale(window_size, frame_buffer_size):
    win_width, win_height = window_size
    fb_width, fb_height = frame_buffer_size

    # future: remove floats after dropping py27 support
    if win_width != 0 and win_width != 0:
        return float(fb_width) / win_width, float(fb_height) / win_height

    return 1., 1.
