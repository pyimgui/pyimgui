# -*- coding: utf-8 -*-
# distutils: language = c++
# distutils: include_dirs = imgui-cpp
"""
Notes:
   `✓` marks API element as already mapped in core bindings.
   `✗` marks API element as "yet to be mapped
   `?` marks API element as not mapped and may or may not be mapped in future
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
    ctypedef struct ImGuiContext
    ctypedef struct ImGuiContextHook
    ctypedef struct ImGuiDataTypeInfo
    ctypedef struct ImGuiGroupData
    ctypedef struct ImGuiInputTextState
    ctypedef struct ImGuiLastItemDataBackup
    ctypedef struct ImGuiMenuColumns
    ctypedef struct ImGuiNavMoveResult
    ctypedef struct ImGuiMetricsConfig
    ctypedef struct ImGuiNextWindowData
    ctypedef struct ImGuiNextItemData
    ctypedef struct ImGuiOldColumnData
    ctypedef struct ImGuiOldColumns
    ctypedef struct ImGuiPopupData
    ctypedef struct ImGuiSettingsHandler
    ctypedef struct ImGuiStackSizes
    ctypedef struct ImGuiStyleMod
    ctypedef struct ImGuiTabBar
    ctypedef struct ImGuiTabItem
    ctypedef struct ImGuiTable
    ctypedef struct ImGuiTableColumn
    ctypedef struct ImGuiTableSettings
    ctypedef struct ImGuiTableColumnsSettings
    ctypedef struct ImGuiWindow
    ctypedef struct ImGuiWindowTempData
    ctypedef struct ImGuiWindowSettings
    
    
    # ====
    # Enums/Flags
    ctypedef int ImGuiLayoutType
    # ctypedef int ImGuiButtonFlags # REMOVED
    # ctypedef int ImGuiColumnsFlags # REMOVED
    ctypedef int ImGuiItemFlags
    ctypedef int ImGuiItemStatusFlags
    ctypedef int ImGuiOldColumnFlags
    ctypedef int ImGuiNavHighlightFlags
    ctypedef int ImGuiNavDirSourceFlags
    ctypedef int ImGuiNavMoveFlags
    ctypedef int ImGuiNextItemDataFlags
    ctypedef int ImGuiContextHookType
    ctypedef int ImGuiNextWindowDataFlags
    ctypedef int ImGuiSeparatorFlags
    ctypedef int ImGuiTextFlags
    ctypedef int ImGuiTooltipFlags
    ctypedef int ImGuiLogType
    ctypedef int ImGuiAxis
    ctypedef int ImGuiPlotType
    ctypedef int ImGuiInputSource
    ctypedef int ImGuiInputReadMode
    ctypedef int ImGuiNavForward
    ctypedef int ImGuiNavLayer
    ctypedef int ImGuiPopupPositionPolicy
    ctypedef void (*ImGuiErrorLogCallback)(void* user_data, const char* fmt, ...)
    
    # ===
    # Various forward declarations
    ctypedef struct ImVec2
    ctypedef struct ImVec4
    ctypedef struct ImFont
    ctypedef struct ImDrawList
    ctypedef struct ImGuiInputTextCallbackData
    ctypedef struct ImGuiSizeCallbackData
    ctypedef int ImGuiCol
    ctypedef int ImGuiCond
    ctypedef int ImGuiDataType
    ctypedef int ImGuiDir
    ctypedef int ImGuiKey
    ctypedef int ImGuiNavInput
    ctypedef int ImGuiMouseButton
    ctypedef int ImGuiMouseCursor
    ctypedef int ImGuiSortDirection
    ctypedef int ImGuiStyleVar
    ctypedef int ImGuiTableBgTarget
    ctypedef int ImDrawFlags
    ctypedef int ImDrawCornerFlags
    ctypedef int ImDrawListFlags
    ctypedef int ImFontAtlasFlags
    ctypedef int ImGuiBackendFlags
    ctypedef int ImGuiButtonFlags
    ctypedef int ImGuiColorEditFlags
    ctypedef int ImGuiConfigFlags
    ctypedef int ImGuiComboFlags
    ctypedef int ImGuiDragDropFlags
    ctypedef int ImGuiFocusedFlags
    ctypedef int ImGuiHoveredFlags
    ctypedef int ImGuiInputTextFlags
    ctypedef int ImGuiKeyModFlags
    ctypedef int ImGuiPopupFlags
    ctypedef int ImGuiSelectableFlags
    ctypedef int ImGuiSliderFlags
    ctypedef int ImGuiTabBarFlags
    ctypedef int ImGuiTabItemFlags
    ctypedef int ImGuiTableFlags
    ctypedef int ImGuiTableColumnFlags
    ctypedef int ImGuiTableRowFlags
    ctypedef int ImGuiTreeNodeFlags
    ctypedef int ImGuiWindowFlags
    
    # ====
    # Various int typedefs and enumerations
    ctypedef void* ImTextureID
    ctypedef unsigned int ImGuiID
    ctypedef int (*ImGuiInputTextCallback)(ImGuiInputTextCallbackData *data);
    ctypedef void (*ImGuiSizeCallback)(ImGuiSizeCallbackData* data);
    
    # ====
    # Basic scalar data types
    ctypedef signed char         ImS8 
    ctypedef unsigned char       ImU8 
    ctypedef signed short        ImS16
    ctypedef unsigned short      ImU16
    ctypedef signed int          ImS32
    ctypedef unsigned int        ImU32
    ctypedef signed   long long  ImS64
    ctypedef unsigned long long  ImU64
    
    ctypedef struct ImGuiShrinkWidthItem:
        int         Index
        float       Width
    

    

cdef extern from "imgui_internal.h" namespace "ImGui":
    
    # ====
    # Windows
    # ====
    ImGuiWindow* GetCurrentWindowRead() except + # ?
    ImGuiWindow* GetCurrentWindow() except + # ?
    ImGuiWindow* FindWindowByID(ImGuiID id) except + # ?
    ImGuiWindow* FindWindowByName(const char* name) except + # ?
    void UpdateWindowParentAndRootLinks(ImGuiWindow* window, ImGuiWindowFlags flags, ImGuiWindow* parent_window) except + # ?
    ImVec2 CalcWindowNextAutoFitSize(ImGuiWindow* window) except + # ?
    bool IsWindowChildOf(ImGuiWindow* window, ImGuiWindow* potential_parent) except + # ?
    bool IsWindowAbove(ImGuiWindow* potential_above, ImGuiWindow* potential_below) except + # ?
    bool IsWindowNavFocusable(ImGuiWindow* window) except + # ?
    ImRect GetWindowAllowedExtentRect(ImGuiWindow* window) except + # ?
    void SetWindowPos( # ?
        ImGuiWindow* window, 
        const ImVec2& pos, 
        # note: optional
        ImGuiCond cond          # = 0
    ) except +
    void SetWindowSize( # ?
        ImGuiWindow* window, 
        const ImVec2& size, 
        # note: conditional
        ImGuiCond cond          # = 0
    ) except +
    void SetWindowCollapsed( # ?
        ImGuiWindow* window, 
        bool collapsed, 
        # note: conditional
        ImGuiCond cond          # = 0
    ) except +
    void SetWindowHitTestHole(ImGuiWindow* window, const ImVec2& pos, const ImVec2& size) except + # ?

    # ====
    # Windows: Display Order and Focus Order
    # ====
    void FocusWindow(ImGuiWindow* window) except + # ?
    void FocusTopMostWindowUnderOne(ImGuiWindow* under_this_window, ImGuiWindow* ignore_window) except + # ?
    void BringWindowToFocusFront(ImGuiWindow* window) except + # ?
    void BringWindowToDisplayFront(ImGuiWindow* window) except + # ?
    void BringWindowToDisplayBack(ImGuiWindow* window) except + # ?

    # ====
    # Fonts, drawing
    # ====
    void SetCurrentFont(ImFont* font) except + # ?
    ImFont* GetDefaultFont() except + # ?
    ImDrawList* GetForegroundDrawList(ImGuiWindow* window) except + # ?
    
    # ====
    # Init
    # ====
    void Shutdown(ImGuiContext* context) except + # ?
    void Initialize(ImGuiContext* context) except + # ?
    
    # ====
    # NewFrame
    # ====
    void UpdateHoveredWindowAndCaptureFlags() except + # ?
    void StartMouseMovingWindow(ImGuiWindow* window) except + # ?
    void UpdateMouseMovingWindowNewFrame() except + # ?
    void UpdateMouseMovingWindowEndFrame() except + # ?
    
    # ====
    # Generic context hooks
    # ====
    void AddContextHook(ImGuiContext* context, const ImGuiContextHook* hook) except + # ?
    void CallContextHooks(ImGuiContext* context, ImGuiContextHookType type) except + # ?

    
    # ====
    # Settings
    # ====
    void MarkIniSettingsDirty() except + # ?
    void MarkIniSettingsDirty(ImGuiWindow* window) except + # ?
    void ClearIniSettings() except + # ?
    ImGuiWindowSettings* CreateNewWindowSettings(const char* name) except + # ?
    ImGuiWindowSettings* FindWindowSettings(ImGuiID id) except + # ?
    ImGuiWindowSettings* FindOrCreateWindowSettings(const char* name) except + # ?
    ImGuiSettingsHandler* FindSettingsHandler(const char* type_name) except + # ?

    # ====
    # Scrolling
    # ====
    void SetNextWindowScroll(const ImVec2& scroll) except + # ?
    void SetScrollX(ImGuiWindow* window, float scroll_x) except + # ?
    void SetScrollY(ImGuiWindow* window, float scroll_y) except + # ?
    void SetScrollFromPosX(ImGuiWindow* window, float local_x, float center_x_ratio) except + # ?
    void SetScrollFromPosY(ImGuiWindow* window, float local_y, float center_y_ratio) except + # ?
    ImVec2 ScrollToBringRectIntoView(ImGuiWindow* window, const ImRect& item_rect) except + # ?

    # ====
    # Basic Accessors
    # ====
    ImGuiID GetItemID() except + # ?
    ImGuiItemStatusFlags GetItemStatusFlags() except + # ?
    ImGuiID GetActiveID() except + # ?
    ImGuiID GetFocusID() except + # ?
    ImGuiItemFlags GetItemsFlags() except + # ?
    void SetFocusID(ImGuiID id, ImGuiWindow* window) except + # ?
    void SetActiveID(ImGuiID id, ImGuiWindow* window) except + # ?
    void ClearActiveID() except + # ?
    ImGuiID GetHoveredID() except + # ?
    void SetHoveredID(ImGuiID id) except + # ?
    void KeepAliveID(ImGuiID id) except + # ?
    void MarkItemEdited(ImGuiID id) except + # ?
    void PushOverrideID(ImGuiID id) except + # ?
    ImGuiID GetIDWithSeed(const char* str_id_begin, const char* str_id_end, ImGuiID seed) except + # ?

    # ====
    # Basic Helpers for widget code
    # ====
    void ItemSize( # ?
        const ImVec2& size, 
        # note: optional
        float text_baseline_y           # = -1.0f
    ) except +
    void ItemSize(# ?
        const ImRect& bb, 
        # note: optional
        float text_baseline_y           # = -1.0f
    ) except +
    bool ItemAdd( # ?
        const ImRect& bb, 
        ImGuiID id, 
        # note: optional
        const ImRect* nav_bb            # = NULL
    ) except +
    bool ItemHoverable(const ImRect& bb, ImGuiID id) except + # ?
    bool IsClippedEx(const ImRect& bb, ImGuiID id, bool clip_even_when_logged) except + # ?
    void SetLastItemData(ImGuiWindow* window, ImGuiID item_id, ImGuiItemStatusFlags status_flags, const ImRect& item_rect) except + # ?
    bool FocusableItemRegister(ImGuiWindow* window, ImGuiID id) except + # ?
    void FocusableItemUnregister(ImGuiWindow* window) except + # ?
    ImVec2 CalcItemSize(ImVec2 size, float default_w, float default_h) except + # ?
    float CalcWrapWidthForPos(const ImVec2& pos, float wrap_pos_x) except + # ?
    void PushMultiItemsWidths(int components, float width_full) except + # ?
    void PushItemFlag(ImGuiItemFlags option, bool enabled) except + # ✓
    void PopItemFlag() except + # ✓
    bool IsItemToggledSelection() except + # ?
    ImVec2 GetContentRegionMaxAbs() except + # ?
    void ShrinkWidths(ImGuiShrinkWidthItem* items, int count, float width_excess) except + # ?
    
    # ====
    # Logging/Capture
    # ====
    void LogBegin(ImGuiLogType type, int auto_open_depth) except + # ?
    void LogToBuffer( # ?
        # note: optional
        int auto_open_depth             # = -1
    ) except +

    # ====
    # Popups, Modals, Tooltips
    # ====
    bool BeginChildEx(const char* name, ImGuiID id, const ImVec2& size_arg, bool border, ImGuiWindowFlags flags) except + # ?
    void OpenPopupEx( # ?
        ImGuiID id, 
        # note: optional
        ImGuiPopupFlags popup_flags     # = ImGuiPopupFlags_None
    ) except + 
    void ClosePopupToLevel(int remaining, bool restore_focus_to_window_under_popup) except + # ?
    void ClosePopupsOverWindow(ImGuiWindow* ref_window, bool restore_focus_to_window_under_popup) except + # ?
    bool IsPopupOpen(ImGuiID id, ImGuiPopupFlags popup_flags) except + # ?
    bool BeginPopupEx(ImGuiID id, ImGuiWindowFlags extra_flags) except + # ?
    void BeginTooltipEx(ImGuiWindowFlags extra_flags, ImGuiTooltipFlags tooltip_flags) except + # ?
    ImGuiWindow* GetTopMostPopupModal() except + # ?
    ImVec2 FindBestWindowPosForPopup(ImGuiWindow* window) except + # ?
    ImVec2 FindBestWindowPosForPopupEx(const ImVec2& ref_pos, const ImVec2& size, ImGuiDir* last_dir, const ImRect& r_outer, const ImRect& r_avoid, ImGuiPopupPositionPolicy policy) except + # ?

    # ====
    # Gamepad/Keyboard Navigation
    # ====
    void NavInitWindow(ImGuiWindow* window, bool force_reinit) except + # ?
    bool NavMoveRequestButNoResultYet() except + # ?
    void NavMoveRequestCancel() except + # ?
    void NavMoveRequestForward(ImGuiDir move_dir, ImGuiDir clip_dir, const ImRect& bb_rel, ImGuiNavMoveFlags move_flags) except + # ?
    void NavMoveRequestTryWrapping(ImGuiWindow* window, ImGuiNavMoveFlags move_flags) except + # ?
    float GetNavInputAmount(ImGuiNavInput n, ImGuiInputReadMode mode) except + # ?
    ImVec2 GetNavInputAmount2d( # ?
        ImGuiNavDirSourceFlags dir_sources, 
        ImGuiInputReadMode mode, 
        # note: optional
        float slow_factor,                  # = 0.0f 
        float fast_factor                   # = 0.0f
    ) except +
    int CalcTypematicRepeatAmount(float t0, float t1, float repeat_delay, float repeat_rate) except + # ?
    void ActivateItem(ImGuiID id) except + # ?
    void SetNavID(ImGuiID id, int nav_layer, ImGuiID focus_scope_id, const ImRect& rect_rel) except + # ?
    
    # ====
    # Focus Scope (WIP)
    # ====
    void PushFocusScope(ImGuiID id) except + # ?
    void PopFocusScope() except + # ?
    ImGuiID GetFocusedFocusScope() except + # ?
    ImGuiID GetFocusScope() except + # ?
    
    # ====
    # Inputs
    # ====
    void SetItemUsingMouseWheel() except + # ?
    bool IsActiveIdUsingNavDir(ImGuiDir dir) except + # ?
    bool IsActiveIdUsingNavInput(ImGuiNavInput input) except + # ?
    bool IsActiveIdUsingKey(ImGuiKey key) except + # ?
    bool IsMouseDragPastThreshold( # ?
        ImGuiMouseButton button, 
        # note: optional
        float lock_threshold                # = -1.0f
    ) except +
    bool IsKeyPressedMap( # ?
        ImGuiKey key, 
        # note: optional
        bool repeat                         # = true
    ) except +
    bool IsNavInputDown(ImGuiNavInput n) except + # ?
    bool IsNavInputTest(ImGuiNavInput n, ImGuiInputReadMode rm) except + # ?
    ImGuiKeyModFlags GetMergedKeyModFlags() except + # ?

    # ====
    # Drag and Drop
    # ====
    bool BeginDragDropTargetCustom(const ImRect& bb, ImGuiID id) except + # ?
    void ClearDragDrop() except + # ?
    bool IsDragDropPayloadBeingAccepted() except + # ?

    # ====
    # Internal Columns API (this is not exposed because we will encourage transitioning to the Tables API)
    # ====
    void SetWindowClipRectBeforeSetChannel(ImGuiWindow* window, const ImRect& clip_rect) except + # ?
    void BeginColumns(  # ?
        const char* str_id, 
        int count, 
        # note: optional
        ImGuiOldColumnFlags flags             # = 0
    ) except +
    void EndColumns() except + # ?
    void PushColumnClipRect(int column_index) except + # ?
    void PushColumnsBackground() except + # ?
    void PopColumnsBackground() except + # ?
    ImGuiID GetColumnsID(const char* str_id, int count) except + # ?
    ImGuiOldColumns* FindOrCreateColumns(ImGuiWindow* window, ImGuiID id) except + # ?
    float GetColumnOffsetFromNorm(const ImGuiOldColumns* columns, float offset_norm) except + # ?
    float GetColumnNormFromOffset(const ImGuiOldColumns* columns, float offset) except + # ?

    # ====
    # Tables: Candidates for public API
    # ====
    void TableOpenContextMenu( # ?
        int column_n                # = -1
    ) except +
    void TableSetColumnWidth(int column_n, float width) except + # ?
    void TableSetColumnSortDirection(int column_n, ImGuiSortDirection sort_direction, bool append_to_sort_specs) except + # ?
    int TableGetHoveredColumn() except + # ?
    float TableGetHeaderRowHeight() except + # ?
    void TablePushBackgroundChannel() except + # ?
    void TablePopBackgroundChannel() except + # ?

    # ====
    # Tables: Internals
    # ====
    ImGuiTable* GetCurrentTable() except + # ?
    ImGuiTable* TableFindByID(ImGuiID id) except + # ?
    bool BeginTableEx( # ?
        const char* name, ImGuiID id, int columns_count, 
        ImGuiTableFlags flags,      # = 0
        const ImVec2& outer_size,   # = ImVec2(0, 0)
        float inner_width           # = 0.0f
    ) except +
    void TableBeginInitMemory(ImGuiTable* table, int columns_count) except + # ?
    void TableBeginApplyRequests(ImGuiTable* table) except + # ?
    void TableSetupDrawChannels(ImGuiTable* table) except + # ?
    void TableUpdateLayout(ImGuiTable* table) except + # ?
    void TableUpdateBorders(ImGuiTable* table) except + # ?
    void TableUpdateColumnsWeightFromWidth(ImGuiTable* table) except + # ?
    void TableDrawBorders(ImGuiTable* table) except + # ?
    void TableDrawContextMenu(ImGuiTable* table) except + # ?
    void TableMergeDrawChannels(ImGuiTable* table) except + # ?
    void TableSortSpecsSanitize(ImGuiTable* table) except + # ?
    void TableSortSpecsBuild(ImGuiTable* table) except + # ?
    ImGuiSortDirection TableGetColumnNextSortDirection(ImGuiTableColumn* column) except + # ?
    void TableFixColumnSortDirection(ImGuiTable* table, ImGuiTableColumn* column) except + # ?
    float TableGetColumnWidthAuto(ImGuiTable* table, ImGuiTableColumn* column) except + # ?
    void TableBeginRow(ImGuiTable* table) except + # ?
    void TableEndRow(ImGuiTable* table) except + # ?
    void TableBeginCell(ImGuiTable* table, int column_n) except + # ?
    void TableEndCell(ImGuiTable* table) except + # ?
    ImRect TableGetCellBgRect(const ImGuiTable* table, int column_n) except + # ?
    const char* TableGetColumnName(const ImGuiTable* table, int column_n) except + # ?
    ImGuiID TableGetColumnResizeID( # ?
        const ImGuiTable* table, int column_n, 
        int instance_no                 # = 0
    ) except +
    float TableGetMaxColumnWidth(const ImGuiTable* table, int column_n) except + # ?
    void TableSetColumnWidthAutoSingle(ImGuiTable* table, int column_n) except + # ?
    void TableSetColumnWidthAutoAll(ImGuiTable* table) except + # ?
    void TableRemove(ImGuiTable* table) except + # ?
    void TableGcCompactTransientBuffers(ImGuiTable* table) except + # ?
    void TableGcCompactSettings() except + # ?

    # ====
    # Tables: Settings
    # ====
    void TableLoadSettings(ImGuiTable* table) except + # ?
    void TableSaveSettings(ImGuiTable* table) except + # ?
    void TableResetSettings(ImGuiTable* table) except + # ?
    ImGuiTableSettings* TableGetBoundSettings(ImGuiTable* table) except + # ?
    void TableSettingsInstallHandler(ImGuiContext* context) except + # ?
    ImGuiTableSettings* TableSettingsCreate(ImGuiID id, int columns_count) except + # ?
    ImGuiTableSettings* TableSettingsFindByID(ImGuiID id) except + # ?

    # ==== 
    # Tab Bars
    # ====
    bool BeginTabBarEx(ImGuiTabBar* tab_bar, const ImRect& bb, ImGuiTabBarFlags flags) except + # ?
    ImGuiTabItem* TabBarFindTabByID(ImGuiTabBar* tab_bar, ImGuiID tab_id) except + # ?
    void TabBarRemoveTab(ImGuiTabBar* tab_bar, ImGuiID tab_id) except + # ?
    void TabBarCloseTab(ImGuiTabBar* tab_bar, ImGuiTabItem* tab) except + # ?
    void TabBarQueueReorder(ImGuiTabBar* tab_bar, const ImGuiTabItem* tab, int dir) except + # ?
    bool TabBarProcessReorder(ImGuiTabBar* tab_bar) except + # ?
    bool TabItemEx(ImGuiTabBar* tab_bar, const char* label, bool* p_open, ImGuiTabItemFlags flags) except + # ?
    ImVec2 TabItemCalcSize(const char* label, bool has_close_button) except + # ?
    void TabItemBackground(ImDrawList* draw_list, const ImRect& bb, ImGuiTabItemFlags flags, ImU32 col) except + # ?
    bool TabItemLabelAndCloseButton(ImDrawList* draw_list, const ImRect& bb, ImGuiTabItemFlags flags, ImVec2 frame_padding, const char* label, ImGuiID tab_id, ImGuiID close_button_id, bool is_contents_visible) except + # ?

    ## Render helpers
    ## AVOID USING OUTSIDE OF IMGUI.CPP! NOT FOR PUBLIC CONSUMPTION. THOSE FUNCTIONS ARE A MESS. THEIR SIGNATURE AND BEHAVIOR WILL CHANGE, THEY NEED TO BE REFACTORED INTO SOMETHING DECENT.
    ## NB: All position are in absolute pixels coordinates (we are never using window coordinates internally)
    #IMGUI_API void          RenderText(ImVec2 pos, const char* text, const char* text_end = NULL, bool hide_text_after_hash = true);
    #IMGUI_API void          RenderTextWrapped(ImVec2 pos, const char* text, const char* text_end, float wrap_width);
    #IMGUI_API void          RenderTextClipped(const ImVec2& pos_min, const ImVec2& pos_max, const char* text, const char* text_end, const ImVec2* text_size_if_known, const ImVec2& align = ImVec2(0, 0), const ImRect* clip_rect = NULL);
    #IMGUI_API void          RenderTextClippedEx(ImDrawList* draw_list, const ImVec2& pos_min, const ImVec2& pos_max, const char* text, const char* text_end, const ImVec2* text_size_if_known, const ImVec2& align = ImVec2(0, 0), const ImRect* clip_rect = NULL);
    #IMGUI_API void          RenderTextEllipsis(ImDrawList* draw_list, const ImVec2& pos_min, const ImVec2& pos_max, float clip_max_x, float ellipsis_max_x, const char* text, const char* text_end, const ImVec2* text_size_if_known);
    #IMGUI_API void          RenderFrame(ImVec2 p_min, ImVec2 p_max, ImU32 fill_col, bool border = true, float rounding = 0.0f);
    #IMGUI_API void          RenderFrameBorder(ImVec2 p_min, ImVec2 p_max, float rounding = 0.0f);
    #IMGUI_API void          RenderColorRectWithAlphaCheckerboard(ImDrawList* draw_list, ImVec2 p_min, ImVec2 p_max, ImU32 fill_col, float grid_step, ImVec2 grid_off, float rounding = 0.0f, ImDrawFlags flags = 0);
    #IMGUI_API void          RenderNavHighlight(const ImRect& bb, ImGuiID id, ImGuiNavHighlightFlags flags = ImGuiNavHighlightFlags_TypeDefault); // Navigation highlight
    #IMGUI_API const char*   FindRenderedTextEnd(const char* text, const char* text_end = NULL); // Find the optional ## from which we stop displaying text.
    #IMGUI_API void          LogRenderedText(const ImVec2* ref_pos, const char* text, const char* text_end = NULL);

    # ====
    # Render helpers (those functions don't access any ImGui state!)
    # ====
    void RenderArrow( # ?
        ImDrawList* draw_list, 
        ImVec2 pos, 
        ImU32 col, 
        ImGuiDir dir, 
        # note: optional
        float scale                     # = 1.0f
    ) except +
    void RenderBullet(ImDrawList* draw_list, ImVec2 pos, ImU32 col) except + # ?
    void RenderCheckMark(ImDrawList* draw_list, ImVec2 pos, ImU32 col, float sz) except + # ?
    void RenderMouseCursor(ImDrawList* draw_list, ImVec2 pos, float scale, ImGuiMouseCursor mouse_cursor, ImU32 col_fill, ImU32 col_border, ImU32 col_shadow) except + # ?
    void RenderArrowPointingAt(ImDrawList* draw_list, ImVec2 pos, ImVec2 half_sz, ImGuiDir direction, ImU32 col) except + # ?
    void RenderRectFilledRangeH(ImDrawList* draw_list, const ImRect& rect, ImU32 col, float x_start_norm, float x_end_norm, float rounding) except + # ?
    void RenderRectFilledWithHole(ImDrawList* draw_list, ImRect outer, ImRect inner, ImU32 col, float rounding) except + # ?

    # ====
    # Widgets
    # ====
    void TextEx( # ?
        const char* text, 
        # note: optional
        const char* text_end,           # = NULL
        ImGuiTextFlags flags            # = 0
    ) except +
    bool ButtonEx( # ?
        const char* label, 
        # note: optional
        const ImVec2& size_arg,         # = ImVec2(0, 0)
        ImGuiButtonFlags flags          # = 0
    ) except +
    bool CloseButton(ImGuiID id, const ImVec2& pos) except + # ?
    bool CollapseButton(ImGuiID id, const ImVec2& pos) except + # ?
    bool ArrowButtonEx( # ?
        const char* str_id, 
        ImGuiDir dir, 
        ImVec2 size_arg, 
        # note: optional
        ImGuiButtonFlags flags          # = 0
    ) except +
    void Scrollbar(ImGuiAxis axis) except + # ?
    bool ScrollbarEx(const ImRect& bb, ImGuiID id, ImGuiAxis axis, float* p_scroll_v, float avail_v, float contents_v, ImDrawFlags flags) except + # ?
    bool ImageButtonEx(ImGuiID id, ImTextureID texture_id, const ImVec2& size, const ImVec2& uv0, const ImVec2& uv1, const ImVec2& padding, const ImVec4& bg_col, const ImVec4& tint_col) except + # ?
    ImRect GetWindowScrollbarRect(ImGuiWindow* window, ImGuiAxis axis) except + # ?
    ImGuiID GetWindowScrollbarID(ImGuiWindow* window, ImGuiAxis axis) except + # ?
    ImGuiID GetWindowResizeID(ImGuiWindow* window, int n) except + # ?
    void SeparatorEx(ImGuiSeparatorFlags flags) except + # ?
    bool CheckboxFlags(const char* label, ImS64* flags, ImS64 flags_value) except + # ?
    bool CheckboxFlags(const char* label, ImU64* flags, ImU64 flags_value) except + # ?

    # ==== 
    # Widgets low-level behaviors
    # ====
    bool ButtonBehavior( # ?
        const ImRect& bb, 
        ImGuiID id, 
        bool* out_hovered, 
        bool* out_held, 
        # note: optional
        ImGuiButtonFlags flags          # = 0
    ) except +
    bool DragBehavior(ImGuiID id, ImGuiDataType data_type, void* p_v, float v_speed, const void* p_min, const void* p_max, const char* format, ImGuiSliderFlags flags) except + # ?
    bool SliderBehavior(const ImRect& bb, ImGuiID id, ImGuiDataType data_type, void* p_v, const void* p_min, const void* p_max, const char* format, ImGuiSliderFlags flags, ImRect* out_grab_bb) except + # ?
    bool SplitterBehavior( # ?
        const ImRect& bb, 
        ImGuiID id, 
        ImGuiAxis axis, 
        float* size1, 
        float* size2, 
        float min_size1, 
        float min_size2, 
        # note: optional
        float hover_extend,             # = 0.0f
        float hover_visibility_delay    # = 0.0f
    )except +
    bool TreeNodeBehavior( # ?
        ImGuiID id, 
        ImGuiTreeNodeFlags flags, 
        const char* label, 
        # note: optional
        const char* label_end           # = NULL
    ) except +
    bool TreeNodeBehaviorIsOpen( # ?
        ImGuiID id, 
        # note: optional
        ImGuiTreeNodeFlags flags        # = 0
    ) except +
    void TreePushOverrideID(ImGuiID id) except + # ?

    ## ====
    ## Template functions are instantiated in imgui_widgets.cpp for a finite number of types.
    ## To use them externally (for custom widget) you may need an "extern template" statement in your code in order to link to existing instances and silence Clang warnings (see #2036).
    ## e.g. " extern template IMGUI_API float RoundScalarWithFormatT<float, float>(const char* format, ImGuiDataType data_type, float v); "
    ## ====
    #template<typename T, typename SIGNED_T, typename FLOAT_T>   IMGUI_API float ScaleRatioFromValueT(ImGuiDataType data_type, T v, T v_min, T v_max, bool is_logarithmic, float logarithmic_zero_epsilon, float zero_deadzone_size);
    #template<typename T, typename SIGNED_T, typename FLOAT_T>   IMGUI_API T     ScaleValueFromRatioT(ImGuiDataType data_type, float t, T v_min, T v_max, bool is_logarithmic, float logarithmic_zero_epsilon, float zero_deadzone_size);
    #template<typename T, typename SIGNED_T, typename FLOAT_T>   IMGUI_API bool  DragBehaviorT(ImGuiDataType data_type, T* v, float v_speed, T v_min, T v_max, const char* format, ImGuiSliderFlags flags);
    #template<typename T, typename SIGNED_T, typename FLOAT_T>   IMGUI_API bool  SliderBehaviorT(const ImRect& bb, ImGuiID id, ImGuiDataType data_type, T* v, T v_min, T v_max, const char* format, ImGuiSliderFlags flags, ImRect* out_grab_bb);
    #template<typename T, typename SIGNED_T>                     IMGUI_API T     RoundScalarWithFormatT(const char* format, ImGuiDataType data_type, T v);
    #template<typename T>                                        IMGUI_API bool  CheckboxFlagsT(const char* label, T* flags, T flags_value);

    # ====
    # Data type helpers
    # ====
    const ImGuiDataTypeInfo*  DataTypeGetInfo(ImGuiDataType data_type) except + # ?
    int DataTypeFormatString(char* buf, int buf_size, ImGuiDataType data_type, const void* p_data, const char* format) except + # ?
    void DataTypeApplyOp(ImGuiDataType data_type, int op, void* output, const void* arg_1, const void* arg_2) except + # ?
    bool DataTypeApplyOpFromText(const char* buf, const char* initial_value_buf, ImGuiDataType data_type, void* p_data, const char* format) except + # ?
    int DataTypeCompare(ImGuiDataType data_type, const void* arg_1, const void* arg_2) except + # ?
    bool DataTypeClamp(ImGuiDataType data_type, void* p_data, const void* p_min, const void* p_max) except + # ?

    # ====
    # InputText
    # ====
    bool InputTextEx( # ?
        const char* label, 
        const char* hint, 
        char* buf, 
        int buf_size, 
        const ImVec2& size_arg, 
        ImGuiInputTextFlags flags, 
        # note: optional
        ImGuiInputTextCallback callback,        # = NULL
        void* user_data                         # = NULL
    ) except +
    bool TempInputText(const ImRect& bb, ImGuiID id, const char* label, char* buf, int buf_size, ImGuiInputTextFlags flags) except + # ?
    bool TempInputScalar( # ?
        const ImRect& bb, 
        ImGuiID id, 
        const char* label, 
        ImGuiDataType data_type, 
        void* p_data, 
        const char* format, 
        # note: optional
        const void* p_clamp_min,                # = NULL
        const void* p_clamp_max                 # = NULL
    ) except +
    bool TempInputIsActive(ImGuiID id) except + # ?
    ImGuiInputTextState* GetInputTextState(ImGuiID id) except + # ?

    # ====
    # Color
    # ====
    void ColorTooltip(const char* text, const float* col, ImGuiColorEditFlags flags) except + # ?
    void ColorEditOptionsPopup(const float* col, ImGuiColorEditFlags flags) except + # ?
    void ColorPickerOptionsPopup(const float* ref_col, ImGuiColorEditFlags flags) except + # ?

    # ====
    # Plot
    # ====
    int PlotEx(ImGuiPlotType plot_type, const char* label, float (*values_getter)(void* data, int idx), void* data, int values_count, int values_offset, const char* overlay_text, float scale_min, float scale_max, ImVec2 frame_size) except + # ?

    # ====
    # Shade functions (write over already created vertices)
    # ====
    void ShadeVertsLinearColorGradientKeepAlpha(ImDrawList* draw_list, int vert_start_idx, int vert_end_idx, ImVec2 gradient_p0, ImVec2 gradient_p1, ImU32 col0, ImU32 col1) except + # ?
    void ShadeVertsLinearUV(ImDrawList* draw_list, int vert_start_idx, int vert_end_idx, const ImVec2& a, const ImVec2& b, const ImVec2& uv_a, const ImVec2& uv_b, bool clamp) except + # ?

    # ====
    # Garbage collection
    # ====
    void GcCompactTransientMiscBuffers() except + # ?
    void GcCompactTransientWindowBuffers(ImGuiWindow* window) except + # ?
    void GcAwakeTransientWindowBuffers(ImGuiWindow* window) except + # ?

   
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    