# -*- coding: utf-8 -*-
from __future__ import absolute_import

from warnings import warn


warn(
    """
    Integration layer in imgui.integrations is still in experimental mode.
    Expect mayor changes in future versions. For safety it is recommended
    to use code vendoring for specific integration impementation.

    This subpackage should become stable in 1.0.0 version.

    """, FutureWarning
)
