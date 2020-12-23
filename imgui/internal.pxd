# -*- coding: utf-8 -*-
# distutils: language = c++
# distutils: include_dirs = imgui-cpp
"""
Notes:
   `✓` marks API element as already mapped in core bindings.
   `✗` marks API element as "yet to be mapped
"""
from libcpp cimport bool

from enums cimport ImGuiKey_, ImGuiCol_, ImGuiSliderFlags_

cimport cimgui

cdef UpdateImGuiContext(cimgui.ImGuiContext* _ptr)

cdef extern from "imgui_internal.h":
    
    # TODO: Import full API
    
    ctypedef int ImGuiItemFlags
    
    # TODO: internal_enum.pxd ?
    ctypedef enum ImGuiItemFlags_:
        ImGuiItemFlags_None                     #
        ImGuiItemFlags_NoTabStop                # false
        ImGuiItemFlags_ButtonRepeat             # false    # Button() will return true multiple times based on io.KeyRepeatDelay and io.KeyRepeatRate settings.
        ImGuiItemFlags_Disabled                 # false    # [BETA] Disable interactions but doesn't affect visuals yet. See github.com/ocornut/imgui/issues/211
        ImGuiItemFlags_NoNav                    # false
        ImGuiItemFlags_NoNavDefaultFocus        # false
        ImGuiItemFlags_SelectableDontClosePopup # false    # MenuItem/Selectable() automatically closes current Popup window
        ImGuiItemFlags_MixedValue               # false    # [BETA] Represent a mixed/indeterminate value, generally multi-selection where values differ. Currently only supported by Checkbox() (later should support all sorts of widgets)
        ImGuiItemFlags_ReadOnly                 # false    # [ALPHA] Allow hovering interactions but underlying value is not changed.
        ImGuiItemFlags_Default_                 #


cdef extern from "imgui_internal.h" namespace "ImGui":
    
    # TODO: Import full API
    
    # ====
    # Basic Helpers for widget code
    # ====
    void PushItemFlag(ImGuiItemFlags option, bool enabled) except + # ✓
    void PopItemFlag() except + # ✓