# distutils: language = c++
# distutils: sources = imgui-cpp/imgui.cpp imgui-cpp/imgui_draw.cpp imgui-cpp/imgui_demo.cpp imgui-cpp/imgui_widgets.cpp config-cpp/py_imconfig.cpp
# distutils: include_dirs = imgui-cpp ansifeed-cpp
# cython: embedsignature=True

import cython

cimport cimgui
cimport internal

from cpython.version cimport PY_MAJOR_VERSION

include "imgui/common.pyx"

cdef UpdateImGuiContext(cimgui.ImGuiContext* _ptr):
    cimgui.SetCurrentContext(_ptr)

# === API ===

ITEM_NONE = internal.ImGuiItemFlags_None                     
ITEM_NO_TAB_STOP = internal.ImGuiItemFlags_NoTabStop                
ITEM_BUTTON_REPEAT = internal.ImGuiItemFlags_ButtonRepeat             
ITEM_DISABLED = internal.ImGuiItemFlags_Disabled                 
ITEM_NO_NAV = internal.ImGuiItemFlags_NoNav                    
ITEM_NO_NAV_DEFAULT_FOCUS = internal.ImGuiItemFlags_NoNavDefaultFocus        
ITEM_SELECTABLE_DONT_CLOSE_POPUP = internal.ImGuiItemFlags_SelectableDontClosePopup 
ITEM_MIXED_VALUE = internal.ImGuiItemFlags_MixedValue               
ITEM_READ_ONLY = internal.ImGuiItemFlags_ReadOnly                 
ITEM_DEFAULT = internal.ImGuiItemFlags_Default_                 


def push_item_flag(internal.ImGuiItemFlags option, bool enabled):
    # TODO: document
    internal.PushItemFlag(option, enabled)
    
def pop_item_flag():
    internal.PopItemFlag()
