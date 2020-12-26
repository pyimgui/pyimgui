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
cimport enums_internal

cdef UpdateImGuiContext(cimgui.ImGuiContext* _ptr)

cdef extern from "imgui_internal.h":
    
    
    # ====
    # Forward declarations
    ctypedef struct ImBitVector
    ctypedef struct ImRect
    ctypedef struct ImDrawDataBuilder
    ctypedef struct ImDrawListSharedData
    ctypedef struct ImGuiColorMod
    ctypedef struct ImGuiColumns
    ctypedef struct ImGuiColumnData
    ctypedef struct ImGuiContext
    ctypedef struct ImGuiDataTypeInfo
    ctypedef struct ImGuiGroupData
    ctypedef struct ImGuiInputTextState
    ctypedef struct ImGuiLastItemDataBackup
    ctypedef struct ImGuiMenuColumns
    ctypedef struct ImGuiNavMoveResult
    ctypedef struct ImGuiNextWindowData
    ctypedef struct ImGuiNextItemData
    ctypedef struct ImGuiPopupData
    ctypedef struct ImGuiSettingsHandler
    ctypedef struct ImGuiStyleMod
    ctypedef struct ImGuiTabBar
    ctypedef struct ImGuiTabItem
    ctypedef struct ImGuiWindow
    ctypedef struct ImGuiWindowTempData
    ctypedef struct ImGuiWindowSettings
    
    
    # ====
    # Enums/Flags
    ctypedef int ImGuiLayoutType
    ctypedef int ImGuiButtonFlags
    ctypedef int ImGuiColumnsFlags
    ctypedef int ImGuiItemFlags
    ctypedef int ImGuiItemStatusFlags
    ctypedef int ImGuiNavHighlightFlags
    ctypedef int ImGuiNavDirSourceFlags
    ctypedef int ImGuiNavMoveFlags
    ctypedef int ImGuiNextItemDataFlags
    ctypedef int ImGuiNextWindowDataFlags
    ctypedef int ImGuiSeparatorFlags
    ctypedef int ImGuiTextFlags
    ctypedef int ImGuiTooltipFlags
    


cdef extern from "imgui_internal.h" namespace "ImGui":
    
    # TODO: Import full API
    
    # ====
    # Basic Helpers for widget code
    # ====
    void PushItemFlag(ImGuiItemFlags option, bool enabled) except + # ✓
    void PopItemFlag() except + # ✓