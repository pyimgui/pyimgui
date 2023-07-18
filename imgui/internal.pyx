# distutils: language = c++
# distutils: sources = imgui-cpp/imgui.cpp imgui-cpp/imgui_draw.cpp imgui-cpp/imgui_demo.cpp imgui-cpp/imgui_widgets.cpp imgui-cpp/imgui_tables.cpp config-cpp/py_imconfig.cpp
# distutils: include_dirs = imgui-cpp ansifeed-cpp
# cython: embedsignature=True

import cython

cimport cimgui
cimport internal
cimport enums_internal

from cpython.version cimport PY_MAJOR_VERSION

include "imgui/common.pyx"

cdef UpdateImGuiContext(cimgui.ImGuiContext* _ptr):
    cimgui.SetCurrentContext(_ptr)

# === Enums ===

include "imgui/enums_internal.pyx"

# === API ===

def push_item_flag(internal.ImGuiItemFlags option, bool enabled):
    # TODO: document
    internal.PushItemFlag(option, enabled)

def pop_item_flag():
    internal.PopItemFlag()

def get_item_id():
    """Gets the id of the last item.

    Note:
        Not all items have unique item ids. Non-interactive items
        such as text will return 0.

    wraps::
        GetItemID()
    """
    return internal.GetItemID()
