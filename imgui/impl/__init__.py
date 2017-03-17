# -*- coding: utf-8 -*-
try:
    from imgui.impl._glfw import GlfwImpl
except ImportError:
    pass

try:
    from imgui.impl._pysdl2 import SDL2Impl
except ImportError:
    pass

